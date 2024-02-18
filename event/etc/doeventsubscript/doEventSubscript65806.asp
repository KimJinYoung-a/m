<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  2015 텐바이텐X 멜로디 포레스트캠프 공식굿즈 런칭
' History : 2015.09.01 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, userid, mode, sqlstr, refer, txtcomm, sub_idx, subscriptcount, ccomment, getnowdate, snsno, device, movno

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  64873
	Else
		eCode   =  65806
	End If

	getnowdate = date()

	If isapp="1" Then
		device = "A"
	else
		device = "M"
	end if
	
	userid = GetEncLoginUserID()
	mode = requestcheckvar(request("mode"),32)
	snsno = requestcheckvar(request("snsno"),10)
	movno = requestcheckvar(request("movno"),10)
	sub_idx = requestcheckvar(request("sub_idx"),10)
	txtcomm = requestcheckvar(request("txtcomm"),300)

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

if mode<>"snscnt" and mode<>"movie" then
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
	
	If not(getnowdate>="2015-09-01" and getnowdate<"2015-09-14") Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF	
	
	if subscriptcount > 4 then
		Response.Write "<script type='text/javascript'>alert('참여는 다섯번 가능 합니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if
	
	if txtcomm="" then
		Response.Write "<script type='text/javascript'>alert('내용을 입력해 주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End		
	end if	
	if checkNotValidTxt(txtcomm) then
		Response.Write "<script type='text/javascript'>alert('내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End		
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& html2db(txtcomm) &"')" + vbcrlf
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('응모완료!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"

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
	sqlstr = sqlstr & " set sub_opt3='"& html2db(txtcomm) &"' where " + vbcrlf
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
elseif mode="snscnt" then
	sqlstr = "insert into db_log.[dbo].[tbl_caution_event_log] (evt_code, userid, refip, value1 , value2, value3, device ) values " &_
			" ('"& eCode &"' " &_
			", '"& userid &"' " &_
			", '"& Left(request.ServerVariables("REMOTE_ADDR"),32) & "' " &_
			", '"& snsno &"' " &_
			", '' " &_
			", '' " &_
			", '"& device & "') "
	dbget.Execute sqlstr
	if snsno = "tw" then
		Response.write "tw"
	elseif snsno = "fb" then
		Response.write "fb"
	else
		Response.write "99"
	end if
	Response.End
elseif mode="movie" then
	if movno = "edk" then
		response.write "<iframe src='https://www.youtube.com/embed/mBUpixRSsGk' width='480' height='300' frameborder='0' title='2015 멜로디 포레스트 캠프 에디킴 라인업 공개!' webkitallowfullscreen='' mozallowfullscreen='' allowfullscreen=''></iframe>"
	elseif movno = "iu" then
		response.write "<iframe src='https://www.youtube.com/embed/uixxC7T1uJs' width='480' height='300' frameborder='0' title='2015 멜로디 포레스트 캠프 아이유 라인업 공개!' webkitallowfullscreen='' mozallowfullscreen='' allowfullscreen=''></iframe>"
	elseif movno = "yhe" then
		response.write "<iframe src='https://www.youtube.com/embed/aneZ7nNrQqg' width='480' height='300' frameborder='0' title='2015 멜로디 포레스트 캠프 양희은 라인업 공개!' webkitallowfullscreen='' mozallowfullscreen='' allowfullscreen=''></iframe>"
	elseif movno = "yjs" then
		response.write "<iframe src='https://www.youtube.com/embed/KBPqbambw1U' width='480' height='300' frameborder='0' title='2015 멜로디 포레스트 캠프 윤종신 라인업 공개!' webkitallowfullscreen='' mozallowfullscreen='' allowfullscreen=''></iframe>"
	elseif movno = "yhy" then
		response.write "<iframe src='https://www.youtube.com/embed/YL3nFovBk5s' width='480' height='300' frameborder='0' title='2015 멜로디 포레스트 캠프 유희열 라인업 공개!' webkitallowfullscreen='' mozallowfullscreen='' allowfullscreen=''></iframe>"
	else
		response.write "<iframe src='https://www.youtube.com/embed/uixxC7T1uJs' width='480' height='300' frameborder='0' title='2015 멜로디 포레스트 캠프 아이유 라인업 공개!' webkitallowfullscreen='' mozallowfullscreen='' allowfullscreen=''></iframe>"
	end if
	Response.End
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->