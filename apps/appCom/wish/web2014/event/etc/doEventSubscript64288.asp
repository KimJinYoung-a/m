<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 그것이 알고 싶다 for App
' History : 2015-06-30 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, sqlstr, mode, vLinkECode , vTotalCount
Dim totalbonuscouponcount '//쿠폰
Dim couponidx
Dim vQuery
Dim userSelValue

userSelValue = requestcheckvar(request("usv"),4)
userid = GetLoginUserID


IF application("Svr_Info") = "Dev" THEN
	eCode = "63806"
Else
	eCode = "64288"
End If

If userid = "" Then
	Response.Write "{ "
	response.write """resultcode"":""44"""
	response.write "}"
	dbget.close()
	response.end
End If

'// 이벤트 응모 내역 확인
vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' "
rsget.Open vQuery,dbget,1
IF Not rsget.Eof Then
	vTotalCount = rsget(0)
End If
rsget.close()

If vTotalCount > 0 Then
	Response.Write "{ "
	response.write """resultcode"":""22"""
	response.write "}"
	dbget.close()
	response.end
End If 


'// 이벤트 테이블에 내역을 남긴다.
vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device) VALUES('" & eCode & "', '" & userid & "','"&userSelValue&"', 'A')"
dbget.Execute vQuery

Response.Write "{ "
response.write """resultcode"":""99"""
response.write "}"
dbget.close()
response.End


%>

<!-- #include virtual="/lib/db/dbclose.asp" -->