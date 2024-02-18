<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  텐바이텐x다노(이벤트페이지)
' History : 2015.06.12 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->

<%
dim nowdate, device
dim eCode, userid, mode, sqlstr, refer, txtcomm, txtcomm2, sub_idx, subscriptcount, ccomment
	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),32)
	sub_idx = requestcheckvar(request("sub_idx"),10)
	txtcomm = requestcheckvar(request("txtcomm"),300)
	txtcomm2 = requestcheckvar(request("txtcomm2"),300)

	if isapp then
		device = "A"
	else
		device = "M"
	end if

	nowdate = date()
'	nowdate = "2015-06-17"		'''''''''''''''''''''''''''''''''''''''''''''''''''''

	IF application("Svr_Info") = "Dev" THEN
		eCode   	= 63787
	Else
		eCode		= 63555
	End If

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

if mode<>"appdowncnt" then
	If userid = "" Then
		Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF
end if

if mode="addcomment" then
	set ccomment = new Cevent_etc_common_list
		ccomment.frectevt_code=eCode
		ccomment.frectuserid=userid
		ccomment.event_subscript_one
		
		subscriptcount = ccomment.ftotalcount
	set ccomment=nothing

	If not(nowdate>="2015-06-16" and nowdate<"2015-06-22") Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF	

	if subscriptcount > 0 then
		Response.Write "<script type='text/javascript'>alert('응모는 한번만 가능 합니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	if txtcomm="" then
		Response.Write "<script type='text/javascript'>alert('내용을 입력해 주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End		
	end if

	if txtcomm2="" then
		Response.Write "<script type='text/javascript'>alert('내용을 입력해 주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End		
	end if

	if checkNotValidTxt(txtcomm) then
		Response.Write "<script type='text/javascript'>alert('내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End		
	end if

	if checkNotValidTxt(txtcomm2) then
		Response.Write "<script type='text/javascript'>alert('내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End		
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& html2db(txtcomm) &"', '"& html2db(txtcomm2) &"', '"& device &"')" + vbcrlf
'	response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Call fnCautionEventLog(eCode,userid,html2db(txtcomm),html2db(txtcomm2),"",device)

	Response.Write "<script type='text/javascript'>alert('응모가 완료되었습니다.\n당첨자 발표일을 기다려주세요!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"

elseif mode="editcomment" then
	if txtcomm="" then
		Response.Write "<script type='text/javascript'>alert('내용을 입력해 주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End		
	end if	
	if checkNotValidTxt(txtcomm) then		
		Response.Write "<script type='text/javascript'>alert('내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End		
	end if

	sqlstr = "UPDATE [db_event].[dbo].[tbl_event_subscript]  " + vbcrlf
	sqlstr = sqlstr & " set sub_opt1='"& html2db(txtcomm) &"', " + vbcrlf
	sqlstr = sqlstr & " sub_opt3='"& html2db(txtcomm2) &"' where " + vbcrlf
	sqlstr = sqlstr & "  sub_idx='"& sub_idx &"' and userid='"& userid &"' and evt_code='"& eCode &"'"
	
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('수정 되었습니다.!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
elseif mode="delcomment" then
	If sub_idx = "" Then
		Response.Write "<script type='text/javascript'>alert('구분자가 없습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF

	sqlstr="delete from db_event.dbo.tbl_event_subscript where sub_idx='"& sub_idx &"' and userid='"& userid &"' and evt_code='"& eCode &"'"
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('삭제되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
elseif mode="appdowncnt" then

	sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
	sqlstr = sqlstr & " VALUES('"& eCode &"', 'appdowncnt')"
	dbget.execute sqlstr

	response.write "OK"
	response.End
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->