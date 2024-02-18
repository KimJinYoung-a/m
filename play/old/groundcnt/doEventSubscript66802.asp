<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : play 스물다섯 번째 이야기 TOY
' History : 2015.10.15 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim mode, gubunval, sqlstr, isAppname, isApp
	mode = requestcheckvar(request("mode"),16)
	gubunval = requestcheckvar(request("gubunval"),1)
	isApp = requestcheckvar(request("isApp"),2)

if isApp="" then isApp=0
if isApp=1 then
	isAppname="A"
else
	isAppname="M"
end if

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end If

dim currenttime
	currenttime =  now()
	'currenttime = #10/19/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  64932
Else
	eCode   =  66802
End If

dim userid, i
	userid = GetEncLoginUserID()

dim subscriptexistscount, staffconfirm
	subscriptexistscount=0
	staffconfirm=FALSE

if not( left(currenttime,10)>="2015-10-19" and left(currenttime,10)<"2015-10-29" ) then
	Response.Write "DATENOT"
	dbget.close() : Response.End
End If
if userid="" then
	Response.Write "USERNOT"
	dbget.close() : Response.End
End If
'if Hour(currenttime) < 10 then
'	Response.write "TIMENOT"
'	Response.end
'end if
'if staffconfirm and request.cookies("uinfo")("userlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW
'	Response.write "STAFF"
'	dbget.close() : Response.End
'end if

If mode = "add" Then
	if gubunval="" then
		Response.Write "NOTVAL"
		dbget.close() : Response.End
	End If
	subscriptexistscount = getevent_subscriptexistscount(eCode, userid, "", "", "")
	if subscriptexistscount > 4 then
		Response.write "END"
		dbget.close()	:	response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"& left(currenttime,10) &"', '"& gubunval &"' ,'', getdate(), '"& isAppname &"')" + vbcrlf
	
	'response.write sqlstr & "<br>"
	dbget.execute sqlstr

	Response.write "SUCCESS"
	dbget.close()	:	response.End

Else
	Response.Write "정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->