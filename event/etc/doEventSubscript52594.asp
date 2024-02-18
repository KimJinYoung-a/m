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
' Description :  [10x10 오감충족 마지막 이벤트] This is My Bottle!(WWW)
' History : 2014.06.12 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event52594Cls.asp" -->

<%
dim eCode, userid, mode, sqlstr, refer, txtcomm, sub_idx
	eCode=getevt_code
	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),32)
	sub_idx = requestcheckvar(request("sub_idx"),10)
	txtcomm = requestcheckvar(request("txtcomm"),300)

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF
If not(getnowdate>="2014-06-16" and getnowdate<"2014-06-21") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF

if mode="addcomment" then
	if txtcomm="" then
		Response.Write "<script type='text/javascript'>alert('내용을 입력해 주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End		
	end if	
	if checkNotValidTxt(txtcomm) then
		Response.Write "<script type='text/javascript'>alert('내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End		
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& html2db(txtcomm) &"' , 'M')" + vbcrlf
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('등록완료!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->