<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/inipay/common/orderTempFunction.asp" -->
<%

'/////////////////////////////////////////////////////////////////////////////
'///// 1. 변수 초기화 및 POST 인증값 받음                                 ////
'/////////////////////////////////////////////////////////////////////////////
Dim P_STATUS, P_RMESG1, P_TID, P_REQ_URL, P_NOTI
P_STATUS = Request("P_STATUS")			'// 인증 상태
P_RMESG1 = Request("P_RMESG1")			'// 인증 결과 메시지
P_TID = Request("P_TID")				'// 인증 거래번호
P_REQ_URL = Request("P_REQ_URL")		'// 결제요청 URL
P_NOTI = Request("P_NOTI")				'// 기타주문정보


'/////////////////////////////////////////////////////////////////////////////
'///// 2. 상점 아이디 설정 :                                              ////
'/////    결제요청 페이지에서 사용한 MID값과 동일하게 세팅해야 함...      ////
'/////////////////////////////////////////////////////////////////////////////
Dim P_MID
P_MID = "teenxteen9"					'// 상점아이디
IF application("Svr_Info")="Dev" THEN
	P_MID = "INIpayTest"
END IF

''휴대폰 결제 2015/05/14
if InStr(LCASE(P_TID),"teenteen10")>0 THEN P_MID = "teenteen10"

''이니렌탈 2020/10/30
IF application("Svr_Info")="Dev" THEN
	P_MID = "teenxtest1"
Else
	If InStr(LCASE(P_TID),"teenxteenr")>0 Then	
		P_MID = "teenxteenr"
	End If
END IF



'	If P_STATUS = "01" Then '인증결과가 실패일 경우
'		Response.write "<script language='javascript'>alert('01. 이니시스에 인증결과 실패가 발생하였습니다. 다시 시도해 주세요.');</script>"
'		dbget.close()
'		Response.End
'	End If


'/////////////////////////////////////////////////////////////////////////////
'///// 3. 승인요청 :                                                      ////
'/////    인증값을 가지고 P_REQ_URL로 승인요청을 함...                    ////
'/////  - 참조 : http://doevents.egloos.com/296023
'/////////////////////////////////////////////////////////////////////////////

Dim vP_AMT, vPrice  ''2018/05/03 추가
Dim vQuery, vAuthCode, vTID, vIdx, vMessage, vPType, vP_RMESG2, vP_FN_CD1, vP_CARD_ISSUER_CODE, vP_CARD_PRTC_CODE
dim url : url = P_REQ_URL
dim xmlHttp,  postdata
''이니렌탈 추가 파라미터값
dim vRTPAY_totalPrice, vRTPAY_rentalPrice, vRTPAY_rentalPeriod, vRTPAY_rentalNo, vRTPAY_rentalDate, vRTPAY_rentalTime
vIdx = P_NOTI

''선저장 //2013/03/14 추가
vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
vQuery = vQuery & " SET P_STATUS = convert(varchar(3),'" & CStr(Trim(P_STATUS)) & "')"
vQuery = vQuery & " , P_TID = convert(varchar(50),'" & P_TID & "')"
vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'" & P_RMESG1 & "')"
vQuery = vQuery & " WHERE temp_idx = '" & P_NOTI & "'"                                  '' P_NOTI is temp_idx
dbget.execute vQuery


'// 임시주문 정보 접수
Dim vRdsite, vMid
vQuery = "SELECT TOP 1 * FROM [db_order].[dbo].[tbl_order_temp] WHERE temp_idx = '" & vIdx & "'"
rsget.CursorLocation = adUseClient
rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.EOF THEN
	vRdsite			= rsget("rdsite")
	vMid            = rsget("mid")
	vPrice          = rsget("price")
END IF
rsget.close

''2018/04/17
if (vMid<>"") then P_MID=vMid

Dim vAppLink
SELECT CASE vRdsite
	Case "app_wish2" : vAppLink = "/apps/appCom/wish/web2014"
	Case "app_wish" : vAppLink = "/apps/appCom/wish/webview"
	Case "app_cal" : vAppLink = "/apps/appCom/wish/webview"
End SELECT


If Trim(P_STATUS) = "01" Then '인증결과가 실패일 경우
	Response.write "<script language='javascript'>alert('01. 이니시스에 인증결과 실패가 발생하였습니다. 다시 시도해 주세요.');</script>"
	Response.write "<script language='javascript'>location.replace('"&M_SSLUrl&vAppLink&"/inipay/UserInfo.asp');</script>"  ''추가 2015/08/03
	dbget.close()
	Response.End
End If



Dim retChkOK, oshoppingbag, iErrStr, ireserveParam
iErrStr = ""
retChkOK = fnCheckOrderTemp(vIdx, oshoppingbag,iErrStr, ireserveParam, "")

if NOT(retChkOK) then
    response.write "<script>alert('처리중 오류가 발생하였습니다.\r\n- "&replace(iErrStr,"'","")&"');</script>"
    response.write "<script>location.replace('" &wwwUrl&vAppLink&"/inipay/shoppingbag.asp');</script>"
    dbget.close()
    response.end
end if

if (oshoppingbag is Nothing) then
    response.write "<script>alert('처리중 오류가 발생하였습니다..\r\n- "&replace(iErrStr,"'","")&"');</script>"
    response.write "<script>location.replace('" &wwwUrl&vAppLink& "/inipay/shoppingbag.asp');</script>"
    dbget.close()
    response.end
end if

''201712 임시장바구니 변경.
dim iorderserial
iErrStr = ""
iorderserial = oshoppingbag.SaveOrderDefaultDB_TmpBaguni(vIdx, iErrStr)

if (iErrStr<>"") then
    response.write iErrStr
    response.write "<script language='javascript'>alert('결제는 이루어 지지 않았습니다. \n\n: 오류 -" & replace(iErrStr,"'","") & "');</script>"

    ''2015/08/16 수정
	'vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','주문저장중오류(승인이전Mo_Ini) :" + vIdx +":"+ replace(iErrStr,"'","") + "'"
	'dbget.Execute vQuery
    'dbget.close()
	response.end
end if


''======================================================================================================================

'''-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

''이니시스 승인요청

	Set xmlHttp = CreateObject("Msxml2.ServerXMLHTTP.3.0")

	postdata = "P_TID=" & P_TID & "&P_MID=" & P_MID '보낼 데이터 <!-- //-->
    On Error Resume Next
	xmlHttp.open "POST",url, False
    xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
    xmlHttp.setTimeouts 30000,90000,90000,90000 ''2013/03/14 추가
	xmlHttp.Send postdata	'post data send


	IF Err.Number <> 0 then
	    'vQuery = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
		'vQuery = vQuery + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
        'vQuery = vQuery + " convert(varchar(250),'SvrXmlhttp :"&application("Svr_Info")&"-"&P_NOTI&":"&replace(err.Description&":"&url,"'","")&"'))"

		'dbget.Execute vQuery

		Response.write "<script language='javascript'>alert('02. 이니시스에 승인요청 중 오류가 발생하였습니다. ');</script>"
		dbget.close()
		Response.End
	End If

    On Error Goto 0

Dim vntPostedData: vntPostedData = BinaryToText(xmlHttp.responseBody, "UTF-8")

	Set xmlHttp = nothing

Dim arrPst, i, k
arrPst = Split(vntPostedData , "&")
k = 0
for i = 0 to UBound(arrPst)
    k = k +1
next

for i = 0 to k-1
	'response.write "["&i+1&"] "&arrPst(i)
	'response.write "<br>"
	' asp 연관배열 http://www.shop-wiz.com/board/main/view/root/asp2/60

	If instr(1, arrPst(i), "P_AUTH_NO") <> "0" Then
		vAuthCode = Split(arrPst(i),"=")(1)
	End If

	If instr(1, arrPst(i), "P_TID") <> "0" Then
		vTID = Split(arrPst(i),"=")(1)
	End If

	If instr(1, arrPst(i), "P_NOTI") <> "0" Then
		vIdx = Split(arrPst(i),"=")(1)
	End If

	If instr(1, arrPst(i), "P_RMESG1") <> "0" Then
		vMessage = Split(arrPst(i),"=")(1)
	End If

	If instr(1, arrPst(i), "P_TYPE") <> "0" Then
		vPType = Split(arrPst(i),"=")(1)
	End If

	If instr(1, arrPst(i), "P_RMESG2") <> "0" Then
		vP_RMESG2 = Split(arrPst(i),"=")(1)
	End If

	If instr(1, arrPst(i), "P_FN_CD1") <> "0" Then
		vP_FN_CD1 = Split(arrPst(i),"=")(1)
	End If

	If instr(1, arrPst(i), "P_CARD_ISSUER_CODE") <> "0" Then
		vP_CARD_ISSUER_CODE = Split(arrPst(i),"=")(1)
	End If

	If instr(1, arrPst(i), "P_CARD_PRTC_CODE") <> "0" Then
		vP_CARD_PRTC_CODE = Split(arrPst(i),"=")(1)
	End If

	IF (vPType="MOBILE") then  '2015/04/22 추가
		If instr(1, arrPst(i), "P_HPP_NUM") <> "0" Then
			vAuthCode = Split(arrPst(i),"=")(1)
		End If
	end if

	''2018/05/03 추가 결제금액검토
	If instr(1, arrPst(i), "P_AMT") <> "0" Then
		vP_AMT = Split(arrPst(i),"=")(1)
	End If

	'' 이니렌탈 가격
	If instr(1, arrPst(i), "RTPAY_totalPrice") <> "0" Then
		vRTPAY_totalPrice = Split(arrPst(i),"=")(1)
	End If

	'' 이니렌탈 월 납부금액
	If instr(1, arrPst(i), "RTPAY_rentalPrice") <> "0" Then
		vRTPAY_rentalPrice = Split(arrPst(i),"=")(1)
	End If

	'' 이니렌탈 렌탈기간
	If instr(1, arrPst(i), "RTPAY_rentalPeriod") <> "0" Then
		vRTPAY_rentalPeriod = Split(arrPst(i),"=")(1)
	End If

	'' 이니렌탈 번호
	If instr(1, arrPst(i), "RTPAY_rentalNo") <> "0" Then
		vRTPAY_rentalNo = Split(arrPst(i),"=")(1)
	End If

	'' 이니렌탈 승인일자
	If instr(1, arrPst(i), "RTPAY_rentalDate") <> "0" Then
		vRTPAY_rentalDate = Split(arrPst(i),"=")(1)
	End If

	'' 이니렌탈 승인시간
	If instr(1, arrPst(i), "RTPAY_rentalTime") <> "0" Then
		vRTPAY_rentalTime = Split(arrPst(i),"=")(1)
	End If				

next

vMessage = "[" & vPType & "_" & vMessage & "]"

vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
vQuery = vQuery & " SET P_STATUS = convert(varchar(3),'" & CStr(Trim(Split(arrPst(0),"=")(1))) & "')"
vQuery = vQuery & " , P_TID = convert(varchar(50),'" & vTID & "')"
vQuery = vQuery & " , P_AUTH_NO = convert(varchar(50),'" & vAuthCode & "')"
vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'" & vMessage & "') "
If vPType = "RTPAY" Then
	vQuery = vQuery & " , P_RMESG2 = convert(varchar(500),'" & vRTPAY_rentalPeriod&"|"&vRTPAY_rentalPrice&"|"&vRTPAY_rentalNo & "')" ''이니렌탈일 경우 렌탈개월수|월납입금액|렌탈번호
Else
	vQuery = vQuery & " , P_RMESG2 = convert(varchar(500),'" & vP_RMESG2 & "')"
End If
vQuery = vQuery & " , P_FN_CD1 = convert(varchar(5),'" & vP_FN_CD1 & "')"
vQuery = vQuery & " , P_CARD_ISSUER_CODE = convert(varchar(3),'" & vP_CARD_ISSUER_CODE & "')"
vQuery = vQuery & " , P_CARD_PRTC_CODE = convert(varchar(10),'" & vP_CARD_PRTC_CODE & "') "
vQuery = vQuery & " WHERE temp_idx = '" & vIdx & "'"
dbget.execute vQuery

''Dim vTemp, vResult, vIOrder, vIsSuccess
''vTemp 		= OrderRealSaveProc(vIdx)
''
''vResult		= Split(vTemp,"|")(0)
''vIOrder		= Split(vTemp,"|")(1)
''vIsSuccess	= Split(vTemp,"|")(2)
''
''IF vResult = "ok" Then
''	vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] SET IsPay = 'Y', PayResultCode = '" & vResult & "', orderserial = '" & vIOrder & "', IsSuccess = '" & vIsSuccess & "' WHERE temp_idx = '" & vIdx & "'"
''	dbget.execute vQuery
''Else
''	vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] SET IsPay = 'N', PayResultCode = '" & vResult & "' WHERE temp_idx = '" & vIdx & "'"
''	dbget.execute vQuery
''End If

'' 결제 실패는 00이 아님 주석처리:2014/09/24
'If CStr(Trim(Split(arrPst(0),"=")(1))) <> CStr("00") Then
'	Response.write "<script language='javascript'>alert('이니시스에서 승인요청 결과 오류가 발생하였습니다. 고객센터로 문의해 주세요.');</script>"
'	dbget.close()
'	Response.End
'End IF
'''2013/01/28 추가
'if (vResult<>"ok") then
'    Response.write "<script language='javascript'>alert('주문 처리 과정중 오류가 발생하였습니다. 고객센터로 문의해 주세요.');</script>"
'	dbget.close()
'	Response.End
'end if

''2018/05/03 결제금액 검증
if (Trim(CStr(vP_AMT))<>Trim(CStr(vPrice))) then
    Response.write "<script language='javascript'>alert('이니시스에서 승인요청 결과 오류가 발생하였습니다. 고객센터로 문의해 주세요.');</script>"
    'vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','결제금액 검증 오류(Mo_Ini) :" + CStr(vIdx) +":"+CStr(vP_AMT)+":"+CStr(vPrice)+ "'"
	'dbget.Execute vQuery
    dbget.close()
	response.end
end if

Dim vResult, vIsSuccess, iPaymethod
iPaymethod =""
iErrStr = ""
Call oshoppingbag.SaveOrderResultDB_TmpBaguni(vIdx, iPaymethod, iErrStr, vResult, vIsSuccess)

if (iErrStr<>"") then
    response.write iErrStr
    Response.write "<script type='text/javascript'>alert('04. 주문 처리 과정중 오류가 발생하였습니다. 고객센터로 문의해 주세요.');</script>"
    response.write "<script>location.replace('"&wwwUrl & vAppLink&"/inipay/shoppingbag.asp')</script>"
	dbget.close()
    response.end
end if

On Error resume Next
dim osms, helpmail
helpmail = oshoppingbag.GetHelpMailURL

IF (vIsSuccess) THEN
    call sendmailorder(iorderserial,helpmail)

    set osms = new CSMSClass
	osms.SendJumunOkMsg ireserveParam.FBuyhp, iorderserial
    set osms = Nothing

end if
on Error Goto 0

response.Cookies("shoppingbag").domain = "10x10.co.kr"
response.Cookies("shoppingbag")("before_orderserial") = iorderserial

if (vIsSuccess) then
	response.Cookies("shoppingbag")("before_issuccess") = "true"
else
	response.Cookies("shoppingbag")("before_issuccess") = "false"
end if

dim dumi : dumi=TenOrderSerialHash(iorderserial)

''비회원인 경우 orderserial-uk 값 저장. 2017/10/23 require commlib
IF (vResult = "ok") and (ireserveParam.FUserID="") then
    Call fnUserLogCheck_AddGuestOrderserial_UK(iorderserial,request.Cookies("shoppingbag")("GSSN"))
end if
%>

<%
	'//바이너리 데이터 TEXT형태로 변환
	Function  BinaryToText(BinaryData, CharSet)
		 Const adTypeText = 2
		 Const adTypeBinary = 1

		 Dim BinaryStream
		 Set BinaryStream = CreateObject("ADODB.Stream")

		'원본 데이터 타입
		 BinaryStream.Type = adTypeBinary

		 BinaryStream.Open
		 BinaryStream.Write BinaryData
		 ' binary -> text
		 BinaryStream.Position = 0
		 BinaryStream.Type = adTypeText

		' 변환할 데이터 캐릭터셋
		 BinaryStream.CharSet = CharSet

		'변환한 데이터 반환
		 BinaryToText = BinaryStream.ReadText

		 Set BinaryStream = Nothing
	End Function

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->

<script language="javascript">
    setTimeout(function(){
        try{
            window.location.replace("<%=wwwUrl&vAppLink%>/inipay/DisplayOrder.asp?dumi=<%=dumi%>");
        }catch(ss){
            location.href="<%=vAppLink%>/inipay/DisplayOrder.asp?dumi=<%=dumi%>";
        }
    },200);
	//document.location.href = "<%=wwwUrl&vAppLink%>/inipay/DisplayOrder.asp?dumi=<%=dumi%>";  //캐시 먹음. post or dumi
</script>
