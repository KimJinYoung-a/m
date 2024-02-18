<%
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_orderCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/lib/util/rndSerial.asp" -->
<%

'*******************************************************************************
' FILE NAME : mx_rnoti.asp
' FILE DESCRIPTION :
' 이니시스 smart phone 결제 결과 수신 페이지 샘플
 '기술문의 : ts@inicis.com
' HISTORY
 '2010. 02. 25 최초작성
 '2010  06. 23 WEB 방식의 가상계좌 사용시 가상계좌 채번 결과 무시 처리 추가(APP 방식은 해당 없음!!)
 'WEB 방식일 경우 이미 P_NEXT_URL 에서 채번 결과를 전달 하였으므로,
 '이니시스에서 전달하는 가상계좌 채번 결과 내용을 무시 하시기 바랍니다.
'*******************************************************************************

'이 페이지는 수정하지 마십시요. 수정시 html태그나 자바스크립트가 들어가는 경우 동작을 보장할 수 없습니다
'그리고 정상적으로 data를 처리한 경우에도 이니시스에서 응답을 받지 못한 경우는 결제결과가 중복해서 나갈 수
'있으므로 관련한 처리도 고려되어야 합니다.

'**********************************************************************************
' 처리 흐름
'1) 결과 결과 수신 => 2) 상점 DB 처리 => 3) DB 처리 성공시 "OK 응답" 실패시 "FAIL" 응답
'**********************************************************************************

PGIP = Request.ServerVariables("REMOTE_ADDR")

IF PGIP = "118.129.210.25" OR  PGIP = "211.219.96.165" OR  PGIP = "118.129.210.24" OR PGIP = "39.115.212.9" OR PGIP = "183.109.71.153" OR PGIP = "203.238.37.15" OR  PGIP = "192.168.187.140" OR  PGIP = "172.20.22.40" OR  PGIP = "127.0.0.1" THEN  'PG에서 보냈는지 IP로 체크
'PG에서 보냈는지 IP로 체크  118.129.210.24, 192.168.187.140, 172.20.22.40, 127.0.0.1은 사내 네트웍에서 테스트하기 위한 용도임


	'이니시스 NOTI 서버에서 받은 Value
	Dim P_TID				' 거래번호
	Dim P_MID				' 상점아이디
	Dim P_AUTH_DT			' 승인일자
	Dim P_STATUS			' 거래상태 (00:성공, 01:실패)
	Dim P_TYPE				' 지불수단
	Dim P_OID				' 상점주문번호
	Dim P_FN_CD1			' 금융사코드1
	Dim P_FN_CD2			' 금융사코드2
	Dim P_FN_NM				' 금융사명 (은행명, 카드사명, 이통사명)
	Dim P_AMT				' 거래금액
	Dim P_UNAME				' 결제고객성명
	Dim P_RMESG1			' 결과코드
	Dim P_RMESG2			' 결과메시지
	Dim P_NOTI				' 노티메시지(상점에서 올린 메시지)
	Dim P_AUTH_NO			' 승인번호
	Dim P_CARD_PRTC_CODE	' 부분할부여부

	Dim resp, noti(18), resp_time, vIdx

	Dim P_CARD_ISSUER_CODE	'카드발급사코드
	Dim P_CARD_NUM			'카드번호



	'noti server에서 받은 value
	resp_time		= Now()
	P_TID			= trim(request("P_TID"))
	P_MID			= trim(request("P_MID"))
	P_AUTH_DT		= trim(request("P_AUTH_DT"))
	P_STATUS		= trim(request("P_STATUS"))
	P_TYPE			= trim(request("P_TYPE"))
	P_OID			= trim(request("P_OID"))
	P_FN_CD1		= trim(request("P_FN_CD1"))
	P_FN_CD2		= trim(request("P_FN_CD2"))
	P_FN_NM			= trim(request("P_FN_NM"))
	P_AMT			= trim(request("P_AMT"))
	P_UNAME			= trim(request("P_UNAME"))
	P_RMESG1		= trim(request("P_RMESG1"))
	''P_RMESG1		= trim(BinaryToText(request("P_RMESG1"),"euc-kr"))
	P_RMESG2		= trim(request("P_RMESG2"))
	P_NOTI			= trim(request("P_NOTI"))
	P_AUTH_NO		= trim(request("P_AUTH_NO"))
	P_CARD_ISSUER_CODE	= trim(request("P_CARD_ISSUER_CODE"))
	P_CARD_NUM			= trim(request("P_AUTH_NO"))
	P_CARD_PRTC_CODE	= trim(request("P_PRTC_CODE"))

	'####### 더미주문번호 이므로 실제 필요한 tbl_giftcard_order_temp의 idx값이 필요하여 대체하여 씀.
	vIdx = P_NOTI

	''오류가 생겼을경우 계속 날라옴.
	IF (vIdx="32") THEN
	    response.write "OK"
	    response.end
	END IF
	'WEB 방식의 경우 가상계좌 채번 결과 무시 처리
	'(APP 방식의 경우 해당 내용을 삭제 또는 주석 처리 하시기 바랍니다.)
	IF P_TYPE = "VBANK" THEN		'결제수단이 가상계좌이며
		IF P_STATUS <> "02"	THEN	'입금통보 "02" 가 아니면(가상계좌 채번 : 00 또는 01 경우)
		Response.Write("OK")
		Response.End
		END IF
	END IF

	

	noti(0) = resp_time
	noti(1) = P_TID
	noti(2) = P_MID
	noti(3) = P_AUTH_DT
	noti(4) = P_STATUS
	noti(5) = P_TYPE
	noti(6) = P_OID
	noti(7) = P_FN_CD1
	noti(8) = P_FN_CD2
	noti(9) = P_FN_NM
	noti(10) = P_AMT
	noti(11) = P_UNAME
	noti(12) = P_RMESG1
	noti(13) = P_RMESG2
	noti(14) = P_NOTI
	noti(15) = P_AUTH_NO
	noti(16) = P_CARD_ISSUER_CODE
	noti(17) = P_CARD_NUM
	noti(18) = P_CARD_PRTC_CODE

	'***********************************************************************************
	 ' 위에서 상점 데이터베이스에 등록 성공유무에 따라서 성공시에는 "OK"를 이니시스로 실패시는 "FAIL" 을
	 ' 리턴하셔야합니다. 아래 조건에 데이터베이스 성공시 받는 FLAG 변수를 넣으세요
	 ' (주의) OK를 리턴하지 않으시면 이니시스 지불 서버는 "OK"를 수신할때까지 계속 재전송을 시도합니다
	'  기타 다른 형태의 Response.Write는 하지 않으시기 바랍니다
	'***********************************************************************************

	IF (vIdx="") THEN
	    Response.Write("FAIL")
	    Response.End
	End If

	Dim vQuery, vMessage, vTemp, vResult, vIOrder, vIsSuccess, userid, userhp
	vMessage = "[" & P_TYPE & "_" & P_RMESG1 & "]"

	vQuery = "UPDATE [db_order].[dbo].[tbl_giftcard_order_temp] SET P_STATUS = '" & P_STATUS & "', P_TID = '" & P_TID & "', P_AUTH_NO = '" & P_AUTH_NO & "' , P_RMESG1 = '" & vMessage & "' "
	vQuery = vQuery & ", P_RMESG2 = '" & P_RMESG2 & "', P_FN_CD1 = '" & P_FN_CD1 & "', P_CARD_ISSUER_CODE = '" & P_CARD_ISSUER_CODE & "', P_CARD_PRTC_CODE = '" & P_CARD_PRTC_CODE & "' "
	vQuery = vQuery & "WHERE temp_idx = '" & vIdx & "'"
	dbget.execute vQuery

	IF P_TYPE = "VBANK" THEN
	'========== 가상계좌 ==========
		'// 기프트카드 가상계좌는 실주문번호를 이미 따놓은 상태로 입금확인 처리만 하면됨 (2016.02.05)
		vQuery = "SELECT TOP 1 userid, buyhp, giftOrderSerial FROM [db_order].[dbo].[tbl_giftcard_order_temp] WHERE temp_idx = '" & vIdx & "'"
		rsget.Open vQuery,dbget,1
		IF Not rsget.Eof THEN
	        userid = rsget("userid")
	        userhp = rsget("buyhp")
	        vIOrder = rsget("giftOrderSerial")
	    ENd IF
	    rsget.close()

		'이니시스 결제TID 수신 Test
		'vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','GiftCard 가상계좌- " & P_STATUS & ":" & P_TID & ":" & vIdx & "'"
		'dbget.Execute vQuery

		IF (vIOrder="") THEN
			vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','GiftCard 가상계좌오류 - tmpid:" + vIdx+ "'"
			dbget.Execute vQuery

		    Response.Write("FAIL")
		    Response.End
		End If

		On Error Resume Next

		'// 주문상태 변경
		vQuery = " update [db_order].[dbo].tbl_giftcard_order" + vbCrlf
		vQuery = vQuery + " Set ipkumdiv='4'" + vbCrlf
		vQuery = vQuery + " ,jumunDiv='3'" + vbCrlf
		vQuery = vQuery + " ,paydateid='" & P_TID & "'" + vbCrlf				'인증TID와 결제TID가 다름! 재저장
		vQuery = vQuery + " ,ipkumdate=getdate()" + vbCrlf
		vQuery = vQuery + " where giftOrderSerial='" + CStr(vIOrder) + "'" + vbCrlf
		dbget.execute vQuery

	    IF (Err) then
			vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','GiftCard 주문오류 :" + vIOrder +":"+ replace(Err.Description,"'","") + "'"
			dbget.Execute vQuery
		    Response.Write("FAIL")
		    Response.End
		end if

	    '// 결제 완료 메일 발송::주문자에게 발송.
	    Call SendMailGiftOrder(userid,vIOrder,"텐바이텐<customer@10x10.co.kr>")
    
	    dim osms
	    '// 결제 완료 SMS 발송
	    set osms = new CSMSClass
	    osms.SendJumunOkMsg userhp, vIOrder
	    set osms = Nothing

	    '// Gift카드 MMS 발송::수령인에게
	    Call sendGiftCardLMSMsg2016(vIOrder)

		'// 메지시 발송 처리
        vQuery = "update db_order.dbo.tbl_giftcard_order"
        vQuery = vQuery & " set jumundiv=5"
        vQuery = vQuery & " ,senddate=getdate()"
        vQuery = vQuery & " ,ipkumdiv=8"
        vQuery = vQuery & " where giftorderserial='" & CStr(vIOrder) & "'"
        vQuery = vQuery & " and ipkumdiv>3"
        vQuery = vQuery & " and jumundiv<5"
        vQuery = vQuery & " and cancelyn='N'"
        dbget.Execute vQuery

		On Error Goto 0

		Response.Write("OK")
	
	ELSEIF P_TYPE = "BANK" THEN
	'========== 실시간계좌이체 ==========
		'// 실시간계좌이체는 mx_return과는 별도록 비동기로 mx_rnoti를 호출하므로 실주문 처리해야 됨
	    SESSION("vIdx")=vIdx
	    SERVER.EXECUTE("/inipay/giftcard/mx_rnoti_RET.asp")   '''OK
	end if

END IF
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->