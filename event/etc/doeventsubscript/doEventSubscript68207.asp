<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : MIDORI 창립 66주년, 당신의 매일을 풍요롭게 하다
' History : 2015-12-18 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, mode, vUserCount
Dim vQuery, sqlstr
Dim device, itemsel

	mode = requestcheckvar(request("mode"),32)
	itemsel = requestcheckvar(request("itemsel"),32)
	
	userid = GetEncLoginUserID()
	
	if isapp then
		device = "A"
	else
		device = "M"
	end if
	
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  65987
	Else
		eCode   =  68207
	End If

	If userid = "" Then
		Response.Write "{ "
		response.write """resultcode"":""44"""
		response.write "}"
		dbget.close()
		response.end
	End If


	'// 참여여부
	sqlstr = "select count(*) "
	sqlstr = sqlstr & " from db_event.dbo.tbl_event_subscript"
	sqlstr = sqlstr & " where evt_code='"& eCode &"' and userid='"&userid&"' "
	rsget.Open sqlstr, dbget, 1

	If Not rsget.Eof Then
		vUserCount = rsget(0)
	End IF
	rsget.close

	if vUserCount > 0 then
		Response.Write "{ "
		response.write """resultcode"":""77"""
		response.write "}"
		dbget.close()
		response.end
	end if

If mode = "midoriadd" Then 
	if date() < "2015-12-21" or date() > "2015-12-31" Then
		Response.Write "{ "
		response.write """resultcode"":""88"""
		response.write "}"
		dbget.close()
		response.end
	End If
'===================================================================================================================================================================================================
	Sub fnGetPrize() '응모
		'//이벤트 테이블에 등록
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt2, device) VALUES('" & eCode & "', '" & userid & "', " & itemsel & ", '"& device &"')"
		dbget.Execute vQuery
		Response.Write "{ "
		Response.write """resultcode"":""11"""
		Response.write "}"
		dbget.close()
		Response.end
	End Sub
'===================================================================================================================================================================================================

	Call fnGetPrize() '//응모
End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->