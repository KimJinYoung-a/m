<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 등급업 확인용 proc
'####################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim vQuery, userid, evt_code
evt_code = requestcheckvar(request("eventid"),10)
userid  = GetencLoginUserID

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
    Call Alert_Return("로그인 후 참여하실 수 있습니다.")
    response.End
else
    vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid, regdate)" & vbCrlf
    vQuery = vQuery & " VALUES ('"& evt_code &"' , '"& userid &"' , getdate())" & vbCrlf
    dbget.execute vQuery
End If

if isapp = 1 then 
    response.redirect "/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& evt_code
    dbget.close() : Response.End
else
    response.redirect "/event/eventmain.asp?eventid="& evt_code
    dbget.close() : Response.End
end if 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
