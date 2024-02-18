<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
'어벤져박스의 기적 - for mobile
'2015-01-14 이종화
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
dim lcode , eCode, userid, mode, sqlstr, refer
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21434
		lcode   =  21435
	Else
		eCode   =  58541
		lcode	=  58539
	End If
	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),32)

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

if mode="mo_main" then
    '모바일 렌딩 페이지 
	sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& lcode &", '"& mode &"')" + vbcrlf
	dbget.execute sqlstr

	Response.write "OK"
	dbget.close()	:	response.End
elseif mode="banner1" Or mode="banner2" then
	'//기획전배너 1 , 2
	sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')" + vbcrlf
	dbget.execute sqlstr

	Response.write "OK"
	dbget.close()	:	response.end	
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="& eCode &"'</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->