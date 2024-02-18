<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 헬로우 텐바이텐
' History : 2018-02-13 정태훈
'####################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<%
Dim strSql, userid, mode, apgubun, eCode, medalcnt
mode = requestcheckvar(request("mode"),3)
medalcnt = requestcheckvar(request("medalcnt"),3)
IF application("Svr_Info") = "Dev" THEN
	eCode   =  67504
Else
	eCode   =  84256
End If
userid  = GetencLoginUserID
apgubun = "W"

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "02|로그인 후 참여하실 수 있습니다."
	response.End
End If

If now() > #02/13/2018 00:00:00# and now() < #02/19/2018 23:59:59# Then
Else
	Response.Write "12|이벤트 기간이 아닙니다."
	response.End
End If

if mode = "add" Then

	Dim CheckCode, sqlStr, CheckResult
	sqlStr = "EXEC [db_temp].[dbo].[usp_WWW_Event_HelloTenTenKey_Upd] '" & userid & "'"
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		CheckCode=rsget(0)
		CheckResult=rsget(1)
	End IF
	rsget.close

	If CheckResult="0" Then
		Response.Write "11|"&CheckCode
		dbget.close() : Response.End
	ElseIf  CheckResult="1" Then
		Response.Write "11|"&CheckCode
		dbget.close() : Response.End
	Else
		sqlStr = "EXEC [db_temp].[dbo].[usp_WWW_Event_HelloTenTenKey_Upd] '" & userid & "'"
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
		IF Not rsget.Eof Then
			CheckCode=rsget(0)
			CheckResult=rsget(1)
		End IF
		rsget.close
		If CheckResult="0" Then
			Response.Write "11|"&CheckCode
			dbget.close() : Response.End
		ElseIf  CheckResult="1" Then
			Response.Write "11|"&CheckCode
			dbget.close() : Response.End
		Else
			Response.Write "13|비밀번호가 다 소진되었습니다. 내일 다시 참여해주세요."
			dbget.close() : Response.End
		End if
	End if
else
	Response.Write "00||정상적인 경로가 아닙니다."
	dbget.close() : Response.End	
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
