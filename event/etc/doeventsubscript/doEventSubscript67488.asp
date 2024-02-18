<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 크리스마스(참여1차) - 공유하기
' History : 2015-11-19 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, mode
Dim vQuery
Dim device, snsgubun

	mode = requestcheckvar(request("mode"),32)
	snsgubun = requestcheckvar(request("sns"),32)
	
	userid = GetEncLoginUserID()
	
	If isapp = "1" Then device = "A" Else device = "M" End if
	
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  65955
	Else
		eCode   =  67488
	End If

	If userid = "" Then
		Response.Write "{ "
		response.write """resultcode"":""44"""
		response.write "}"
		dbget.close()
		response.end
	End If


If mode = "2015xmas" Then 
	if date() < "2015-11-23" or date() > "2015-12-06" Then
		Response.Write "{ "
		response.write """resultcode"":""88"""
		response.write "}"
		dbget.close()
		response.end
	End If
'===================================================================================================================================================================================================
	Sub fnGetPrize() '응모
		'//이벤트 테이블에 등록
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt1, device) VALUES('" & eCode & "', '" & userid & "', '" & snsgubun & "', '"& device &"')"
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