<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/lib/util/rndSerial.asp" -->
<%
	''GIFT카드 재발송 페이지에서만 사용가능
	dim refer, sh, oIdx
	refer = lcase(request.serverVariables("HTTP_REFERER"))
	
	if InStr(refer,"giftcardorderdetail.asp")<1 and InStr(refer,"displayorder.asp")<1 then
		Call Alert_close("잘못된 접속입니다.")
		dbget.Close: response.End
	end if

	'// 변수 선언
	dim giftorderserial, masterCardCd, resendCnt, strSql

	'// 전송값 확인
	giftorderserial = requestCheckVar(request("idx"),11)
	if giftorderserial="" then
		Call Alert_Move("주문번호가 없습니다.[011]","about:blank")
		dbget.close: response.End
	end if

	'//유효한 코드확인 및 인증번호 접수
	masterCardCd = getGiftCardMasterCD(giftorderserial,resendCnt,oIdx)
	Select Case masterCardCd
		Case "W"
			Call Alert_Move("취소되었거나 없는 카드입니다.[023]","about:blank")
			dbget.close: response.End
		Case "A"
			Call Alert_Move("입금 대기중인 카드입니다.[034]","about:blank")
			dbget.close: response.End
		Case "R"
			Call Alert_Move("주문취소된 카드입니다.[035]","about:blank")
			dbget.close: response.End
		Case "C"
			Call Alert_Move("등록이 완료된 카드는 인증번호 재전송을 할 수 없습니다.[036]","about:blank")
			dbget.close: response.End
		Case "E"
			Call Alert_Move("죄송합니다. 유효기간이 만료된 카드입니다.[047]","about:blank")
			dbget.close: response.End
		Case "O"
			Call Alert_Move("죄송합니다. 재전송 제한(2회)이 초과되었습니다.[048]","about:blank")
			dbget.close: response.End
	End Select

	'# 재발송 정보 저장
	Call chgOrderInfoResendMasterCD(giftOrderSerial,masterCardCd)

	'//SMS 재전송
    '# Gift카드 MMS 발송
    Call sendGiftCardLMSMsg2016(giftOrderSerial)

	Response.Write "<script language='javascript'>" & vbCrLf &_
					"alert('SMS 재전송 되었습니다.');" & vbCrLf &_
					"parent.location.reload();" & vbCrLf &_
					"</script>"
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->