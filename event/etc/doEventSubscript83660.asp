<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 서울가요대상
' History : 2018-01-11 정태훈
'####################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<%
Dim strSql, userid, mode, apgubun, eCode
mode = requestcheckvar(request("mode"),3)
eCode = requestcheckvar(request("eCode"),10)
userid  = GetencLoginUserID
apgubun = "M"

IF eCode = "" THEN
	Response.Write "01||유입경로에 문제가 발생하였습니다. 관리자에게 문의해주십시오"
	dbget.close() : Response.End
END IF

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "02|로그인 후 참여하실 수 있습니다."
	response.End
End If

If now() > #01/11/2018 00:00:00# and now() < #01/18/2018 23:59:59# Then
Else
	Response.Write "12|이벤트 기간이 아닙니다."
	response.End
End If

'// 해당이벤트 참여했는지 확인
Function UserAppearChk()
	Dim vQuery
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&userid&"'"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		UserAppearChk = rsget(0)
	End IF
	rsget.close
End Function

'// 참여 데이터 ins
Function InsAppearData(evt_code, uid, device, sub_opt1)
	Dim vQuery
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid, device, sub_opt1, regdate)" & vbCrlf
	vQuery = vQuery & " VALUES ("& evt_code &", '"& uid &"', '"&device&"','"&sub_opt1&"',getdate())"
	dbget.execute vQuery
End Function

if mode = "add" then
	If UserAppearChk() > 0 Then
		Response.Write "13|이미 이벤트에 응모하셨습니다."
		dbget.close() : Response.End
	Else
		'// 참여 데이터를 넣는다.
		Call InsAppearData(eCode, userid, apgubun, "ins")
		Response.Write "11|OK"
		dbget.close() : Response.End
	End If
else
	Response.Write "00||정상적인 경로가 아닙니다."
	dbget.close() : Response.End	
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
