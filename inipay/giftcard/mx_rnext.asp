<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
    response.charset = "utf-8"

	'# 현재 페이지명 접수
	dim nowViewPage
	nowViewPage = request.ServerVariables("SCRIPT_NAME")
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/GiftCardinfoCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/GiftCardOptionCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_orderCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/lib/util/rndSerial.asp" -->
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
P_MID = chkIIF(application("Svr_Info")="Dev","INIpayTest","teenxteen8")					'// 상점아이디


'/////////////////////////////////////////////////////////////////////////////
'///// 3. 승인요청 :                                                      ////
'/////    인증값을 가지고 P_REQ_URL로 승인요청을 함...                    ////
'/////  - 참조 : http://doevents.egloos.com/296023
'/////////////////////////////////////////////////////////////////////////////


Dim vQuery, vAuthCode, vTID, vIdx, vMessage, vPType, vP_RMESG2, vP_FN_CD1, vP_CARD_ISSUER_CODE, vP_CARD_PRTC_CODE, vBankName, vBankNum, vBankInput
dim url : url = P_REQ_URL
dim xmlHttp,  postdata

vIdx = P_NOTI			'임시주문 일렬번호

''선저장 //2013/03/14 추가
vQuery = "UPDATE [db_order].[dbo].[tbl_giftcard_order_temp] "
vQuery = vQuery & " SET P_STATUS = convert(varchar(4),'" & CStr(Trim(P_STATUS)) & "')"
vQuery = vQuery & " , P_TID = convert(varchar(50),'" & P_TID & "')"
vQuery = vQuery & " WHERE temp_idx = '" & vIdx & "'"                                  '' P_NOTI is temp_idx
dbget.execute vQuery

''주문 기본 정보 접수
'''-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Dim vUserID, vRdsite, vPrice, vCItemid, vCOption
vQuery = "SELECT TOP 1 * FROM [db_order].[dbo].[tbl_giftcard_order_temp] WHERE temp_idx = '" & vIdx & "'"
rsget.Open vQuery,dbget,1
IF Not rsget.EOF THEN
	vUserID 		= rsget("userid")
	vRdsite			= rsget("rdsite")
	vPrice			= rsget("price")
	vCItemid		= rsget("cardItemid")
	vCOption		= rsget("cardOption")
END IF
rsget.close

Dim vAppLink, device
SELECT CASE vRdsite
	Case "app_wish2" : vAppLink = "/apps/appCom/wish/web2014"
	Case "app_wish" : vAppLink = "/apps/appCom/wish/webview"
	Case "app_cal" : vAppLink = "/apps/appCom/wish/webview"
End SELECT
if instr(vRdsite,"app") > 0 then
	device="A"
else
	device="M"
end if
if device="" then device="M"

If P_STATUS<>"00" Then '인증결과가 실패일 경우
	Response.write "<script>alert('01. 이니시스에 인증결과 실패가 발생하였습니다. 다시 시도해 주세요.');"
	Response.write "location.replace('"&M_SSLUrl&vAppLink&"/giftcard/');</script>"  ''추가 2015/08/03
	dbget.close()
	Response.End
End If


'''-------------------------------------------------------------------------------------------------

'// 카드-옵션 정보 접수
dim oCardItem, strSql
Set oCardItem = new CItemOption
oCardItem.FRectItemID = vCItemid
oCardItem.FRectItemOption = vCOption
oCardItem.GetItemOneOptionInfo

if oCardItem.FResultCount<=0 then
	Response.write "<script>alert('판매중인 Gift카드가 아니거나 없는 Gift카드번호 입니다.');"
	Response.write "location.replace('"&M_SSLUrl&vAppLink&"/giftcard/');</script>"  ''추가 2015/08/03
	dbget.close: response.End
elseif oCardItem.FOneItem.FoptSellYn="N" then
	Response.write "<script>alert('판매중인 Gift카드가 아니거나 품절된 Gift카드 옵션입니다.');"
	Response.write "location.replace('"&M_SSLUrl&vAppLink&"/giftcard/');</script>"  ''추가 2015/08/03
	dbget.close: response.End
end if

if CLNG(oCardItem.FOneItem.FcardSellCash)<>CLNG(vPrice) then
	Response.write "<script>alert('금액 오류 - 다시계산해 주세요.');"
	Response.write "location.replace('"&M_SSLUrl&vAppLink&"/giftcard/');</script>"  ''추가 2015/08/03

    ''관리자 오류 통보
	'strSql = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','gift카드 금액오류 moRnext:"&CStr(vIdx)&":" & oCardItem.FOneItem.FcardSellCash &":"&vPrice&"'"
	'dbget.Execute strSql
	response.end
end if

set oCardItem=Nothing

''======================================================================================================================

'''-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

''이니시스 승인요청
Dim useXMLHTTP, vntPostedData, strData, arr, k, i
''useXMLHTTP = (application("Svr_Info")="Dev") or (application("Svr_Info")="138") or (application("Svr_Info")="084") or (application("Svr_Info")="085") or (application("Svr_Info")="086") or (application("Svr_Info")="088") or (application("Svr_Info")="089") or (application("Svr_Info")="091")
''useXMLHTTP = true
''if (application("Svr_Info")="137") or (application("Svr_Info")="083") or (application("Svr_Info")="085") or (application("Svr_Info")="084") or (application("Svr_Info")="089") or (application("Svr_Info")="088") or (application("Svr_Info")="087") or (application("Svr_Info")="086") then ''win2008 / iis7 응용프로그램 풀 재생후 SSL 최초접속 안됨. ServerXMLHTTP 은 됨..
''    useXMLHTTP = false
''end if

'' useXMLHTTP = false  :: ServerXMLHTTP
useXMLHTTP = false

''서버 버번에 따라 나눔? Default : xmlHTTP 3.0
if (useXMLHTTP) then 
    Set xmlHttp = server.CreateObject("Microsoft.XMLHTTP")
else
	Set xmlHttp = CreateObject("Msxml2.ServerXMLHTTP.3.0")
end if


postdata = "P_TID=" & P_TID & "&P_MID=" & P_MID '보낼 데이터

'// ISP 결제의 경우 URL인코딩 되어있는 케이스가 있음.
url = Replace(url,"%3A",":")
url = Replace(url,"%2F","/")

On Error Resume Next
xmlHttp.Open "POST", url, False
xmlHttp.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
xmlHttp.setTimeouts 30000,90000,90000,90000 ''2013/03/14 추가
xmlHttp.Send postdata

IF Err.Number <> 0 then
	'strSql = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','gift카드 승인오류 moRnext:"&CStr(vIdx)&":" & P_NOTI&":"&replace(err.Description,"'","")&"'"
	'dbget.Execute strSql

	Response.write "<script>alert('02. 이니시스에 승인요청 중 오류가 발생하였습니다.');"
	Response.write "location.replace('"&M_SSLUrl&vAppLink&"/giftcard/');</script>"
	dbget.close(): Response.End
End If

On Error Goto 0

''vntPostedData = BinaryToText(xmlHttp.responseBody, "euc-kr")
vntPostedData = BinaryToText(xmlHttp.responseBody, "UTF-8")			'inpay mobile v4.0부터 utf-8로 결과 받을 수 있음?
''vntPostedData = (xmlHttp.responseText)

Set xmlHttp = nothing

strData = vntPostedData

arr = Split(strData , "&")
k = 0
for i = 0 to UBound(arr)
k = k +1
next

for i = 0 to k-1
	'response.write "["&i+1&"] "&arr(i)
	'response.write "<br>"
	' asp 연관배열 http://www.shop-wiz.com/board/main/view/root/asp2/60

	If instr(1, arr(i), "P_AUTH_NO") <> "0" Then
		vAuthCode = Split(arr(i),"=")(1)
	End If

	If instr(1, arr(i), "P_TID") <> "0" Then
		vTID = Split(arr(i),"=")(1)
	End If

	''If instr(1, arr(i), "P_NOTI") <> "0" Then	vIdx = Split(arr(i),"=")(1)

	If instr(1, arr(i), "P_RMESG1") <> "0" Then
		vMessage = Split(arr(i),"=")(1)
	End If

	If instr(1, arr(i), "P_TYPE") <> "0" Then
		vPType = Split(arr(i),"=")(1)
	End If

	If instr(1, arr(i), "P_RMESG2") <> "0" Then
		vP_RMESG2 = Split(arr(i),"=")(1)
	End If

	If instr(1, arr(i), "P_FN_CD1") <> "0" Then
		vP_FN_CD1 = Split(arr(i),"=")(1)
	End If

	If instr(1, arr(i), "P_CARD_ISSUER_CODE") <> "0" Then
		vP_CARD_ISSUER_CODE = Split(arr(i),"=")(1)
	End If

	If instr(1, arr(i), "P_CARD_PRTC_CODE") <> "0" Then
		vP_CARD_PRTC_CODE = Split(arr(i),"=")(1)
	End If
	
	IF (vPType="VBANK") then  '2015/04/22 추가
		If instr(1, arr(i), "P_VACT_NUM") <> "0" Then  
			vBankNum = Split(arr(i),"=")(1)
		End If
		If instr(1, arr(i), "P_VACT_BANK_CODE") <> "0" Then  
			vBankName = getBankCode2Name(Split(arr(i),"=")(1))
		End If
		''If instr(1, arr(i), "P_VACT_NAME") <> "0" Then  
		If instr(1, arr(i), "P_UNAME") <> "0" Then  
			vBankInput = Split(arr(i),"=")(1)
		End If
	end if
next

vMessage = "[" & vPType & "_" & vMessage & "]"

'	vQuery = "UPDATE [db_order].[dbo].[tbl_giftcard_order_temp] SET P_STATUS = '" & CStr(Trim(Split(arr(0),"=")(1))) & "', P_TID = '" & vTID & "', P_AUTH_NO = '" & vAuthCode & "' , P_RMESG1 = '" & vMessage & "' "
'	vQuery = vQuery & ", P_RMESG2 = '" & vP_RMESG2 & "', P_FN_CD1 = '" & vP_FN_CD1 & "', P_CARD_ISSUER_CODE = '" & vP_CARD_ISSUER_CODE & "', P_CARD_PRTC_CODE = '" & vP_CARD_PRTC_CODE & "' "
'	vQuery = vQuery & "WHERE temp_idx = '" & vIdx & "'"
'	dbget.execute vQuery

vQuery = "UPDATE [db_order].[dbo].[tbl_giftcard_order_temp] "
vQuery = vQuery & " SET P_STATUS = convert(varchar(4),'" & CStr(Trim(Split(arr(0),"=")(1))) & "')"
vQuery = vQuery & " , P_TID = convert(varchar(50),'" & vTID & "')"
vQuery = vQuery & " , P_AUTH_NO = convert(varchar(50),'" & vAuthCode & "')"
vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'" & vMessage & "') "
vQuery = vQuery & " , P_RMESG2 = convert(varchar(500),'" & vP_RMESG2 & "')"
vQuery = vQuery & " , P_FN_CD1 = convert(varchar(5),'" & vP_FN_CD1 & "')"
vQuery = vQuery & " , P_CARD_ISSUER_CODE = convert(varchar(4),'" & vP_CARD_ISSUER_CODE & "')"
vQuery = vQuery & " , P_CARD_PRTC_CODE = convert(varchar(10),'" & vP_CARD_PRTC_CODE & "') "

IF vPType="VBANK" then
	vQuery = vQuery & " , accountno='" & vBankName & " " & vBankNum & "'"
	vQuery = vQuery & " , accountname='" & vBankInput & "'"
End IF

vQuery = vQuery & " WHERE temp_idx = '" & vIdx & "'"
dbget.execute vQuery

Dim vTemp, vResult, vIOrder, vIsSuccess, vRstMsg
vTemp 		= OrderRealSaveProc(vIdx)				'///승인 후 실주문 정보 저장

vResult		= Split(vTemp,"|")(0)
vIOrder		= Split(vTemp,"|")(1)
vRstMsg		= Split(vTemp,"|")(2)
vIsSuccess	= Split(vTemp,"|")(3)

IF vResult = "ok" Then
	vQuery = "UPDATE [db_order].[dbo].[tbl_giftcard_order_temp] SET IsPay = 'Y', PayResultCode = '" & vResult & "', giftOrderSerial = '" & vIOrder & "', IsSuccess = '" & vIsSuccess & "' WHERE temp_idx = '" & vIdx & "'"
	dbget.execute vQuery
Else
	vQuery = "UPDATE [db_order].[dbo].[tbl_giftcard_order_temp] SET IsPay = 'N', PayResultCode = '" & vResult & "' WHERE temp_idx = '" & vIdx & "'"
	dbget.execute vQuery
End If

'' 결제 실패는 00이 아님 주석처리:2014/09/24
'If CStr(Trim(Split(arr(0),"=")(1))) <> CStr("00") Then
'	Response.write "<script>alert('이니시스에서 승인요청 결과 오류가 발생하였습니다. 고객센터로 문의해 주세요.');</script>"
'	dbget.close()
'	Response.End
'End IF

''2013/01/28 추가
if (vResult<>"ok") then
	Response.write "<script>alert('" & vRstMsg & "');"
	Response.write "location.replace('"&M_SSLUrl&vAppLink&"/giftcard/');</script>"
	dbget.close(): Response.End
else
	''Save OrderSerial / UserID or SSN Key
	response.Cookies("shoppingbag").domain = "10x10.co.kr"
	response.Cookies("shoppingbag")("before_GiftOrdSerial") = vIOrder

	if (vIsSuccess) then
		response.Cookies("shoppingbag")("before_GiftisSuccess") = "true"
	else
		response.Cookies("shoppingbag")("before_GiftisSuccess") = "false"
	end if
end if

dim dumi : dumi=LEFT(MD5(vIOrder&"ten"&vIOrder),20)	''TenOrderSerialHash(vIOrder)	in "/lib/classes/ordercls/sp_myordercls.asp"

%>

<html>
<head></head>
<body>
<script type="text/javascript">
document.location.replace("<%=wwwUrl&vAppLink%>/giftcard/DisplayOrder.asp?dumi=<%=dumi%>");  //캐시 먹음. post or dumi
</script>
</body>
</html>
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

	'// IniWeb표준 결제 무통장 은행명 반환
	function getBankCode2Name(icode)
	    SELECT CASE trim(icode)
	        CASE "03" : getBankCode2Name = "기업"
	        CASE "04" : getBankCode2Name = "국민"
	        CASE "05" : getBankCode2Name = "외환"
	        CASE "07" : getBankCode2Name = "수협"
	        CASE "11" : getBankCode2Name = "농협"
	        CASE "20" : getBankCode2Name = "우리"
	        CASE "23" : getBankCode2Name = "SC제일"
	        CASE "31" : getBankCode2Name = "대구"
	        CASE "32" : getBankCode2Name = "부산"
	        CASE "34" : getBankCode2Name = "광주"
	        CASE "37" : getBankCode2Name = "전북"
	        CASE "39" : getBankCode2Name = "경남"
	        CASE "53" : getBankCode2Name = "씨티"
	        CASE "71" : getBankCode2Name = "우체국"
	        CASE "81" : getBankCode2Name = "하나"
	        CASE "88" : getBankCode2Name = "신한"
	        CASE ELSE : getBankCode2Name = icode
	    END SELECT
	end function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->