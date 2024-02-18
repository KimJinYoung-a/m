<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 나를 미치게 하는 여자 (주말용)
' History : 2015-11-11 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, mode, vTotalCount
Dim vQuery
Dim device

mode = requestcheckvar(request("mode"),32)

userid = GetEncLoginUserID()

If isapp = "1" Then device = "A" Else device = "M" End if

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  65947
	Else
		eCode   =  67349
	End If

	If userid = "" Then
		Response.Write "{ "
		response.write """resultcode"":""44"""
		response.write "}"
		dbget.close()
		response.end
	End If

'//하루 한번 응모
If mode = "daily" Then 
	if date() < "2015-11-13" or date() > "2015-11-15" Then
		Response.Write "{ "
		response.write """resultcode"":""88"""
		response.write "}"
		dbget.close()
		response.end
	End If 
'===================================================================================================================================================================================================
	Sub fnGetPrize() '응모
		'//이벤트 테이블에 등록
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, device) VALUES('" & eCode & "', '" & userid & "', '"& device &"')"
		dbget.Execute vQuery
		Response.Write "{ "
		Response.write """resultcode"":""11"""
		Response.write "}"
		dbget.close()
		Response.end
	End Sub
'===================================================================================================================================================================================================
	'// 이벤트 출석 내역 확인
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' and datediff(day,regdate,getdate()) = 0 "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly 
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End If
	rsget.close()
	
	'// 오늘 응모 완료
	If vTotalCount > 0 Then
		Response.Write "{ "
		response.write """resultcode"":""33"""
		response.write "}"
		dbget.close()
		response.End
	Else 	
		Call fnGetPrize() '//응모
	End If 
End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->