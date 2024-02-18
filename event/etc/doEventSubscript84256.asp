<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 메달 개수를 맞춰라!
' History : 2018-02-08 정태훈
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
mode = requestcheckvar(request("mode"),4)
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

If now() > #02/07/2018 00:00:00# and now() < #02/22/2018 23:59:59# Then
Else
	Response.Write "12|이벤트 기간이 아닙니다."
	response.End
End If

Dim EditCheck2, sqlStr
sqlStr = "SELECT regdate FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&userid&"'"
rsget.CursorLocation = adUseClient
rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	EditCheck2 = rsget(0)
End IF
rsget.close

'// 참여 데이터 ins
Function InsAppearData(evt_code, uid, device, sub_opt2)
	Dim vQuery
	vQuery = "if exists(SELECT sub_opt2 FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&userid&"')" & vbCrlf
	vQuery = vQuery & "	begin" & vbCrlf
	vQuery = vQuery & "		update [db_event].[dbo].[tbl_event_subscript]" & vbCrlf
	vQuery = vQuery & "		set sub_opt2='"&sub_opt2&"'" & vbCrlf
	vQuery = vQuery & "		, regdate=getdate()" & vbCrlf
	vQuery = vQuery & "		where evt_code='"& evt_code &"'" & vbCrlf
	vQuery = vQuery & "		and userid='"& uid &"'" & vbCrlf
	vQuery = vQuery & "	end" & vbCrlf
	vQuery = vQuery & "else" & vbCrlf
	vQuery = vQuery & "	begin" & vbCrlf
	vQuery = vQuery & "		INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid, device, sub_opt2, regdate)" & vbCrlf
	vQuery = vQuery & "		VALUES ("& evt_code &", '"& uid &"', '"&device&"','"&sub_opt2&"',getdate())" & vbCrlf
	vQuery = vQuery & "	end"
	dbget.execute vQuery
End Function

if mode = "add" Then
	If left(EditCheck2,10) = left(now(),10) Then
		Response.Write "13|이미 이벤트에 응모하셨습니다."
		dbget.close() : Response.End
	Else
		'// 참여 데이터를 넣는다.
		Call InsAppearData(eCode, userid, apgubun, medalcnt)
		Response.Write "11|OK"
		dbget.close() : Response.End
	End If
ElseIf mode="edit" Then
	If userid="corpse2" Or userid="ley330" Or userid="greenteenz" Or userid = "motions" Then
		sqlStr = "update [db_event].[dbo].[tbl_event_subscript]" & vbCrlf
		sqlStr = sqlStr & " set sub_opt2='"&medalcnt&"'" & vbCrlf
		sqlStr = sqlStr & " , regdate=getdate()" & vbCrlf
		sqlStr = sqlStr & " where sub_idx=9260329" & vbCrlf
		dbget.execute sqlStr
	end if
	Response.Write "11|OK"
		dbget.close() : Response.End
else
	Response.Write "00||정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
