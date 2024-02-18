<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  널리 박스테이프를 이롭게 하다
' History : 2015.01.13 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event58567Cls.asp" -->

<%
dim mode, sqlstr, typeval, sub_opt2
	mode = requestcheckvar(request("mode"),32)
	typeval=getNumeric(requestcheckvar(request("typeval"),1))
	sub_opt2=getNumeric(requestcheckvar(request("sub_opt2"),2))
	
dim eCode, userid, i
	eCode=getevt_code
	userid = getloginuserid()

dim subscriptcount, totalsubscriptcount1, totalsubscriptcount2
	subscriptcount=0
	totalsubscriptcount1=0
	totalsubscriptcount2=0

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

if mode="valinsert" then
	If not(getnowdate>="2015-01-14" and getnowdate<"2015-01-19") Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF
	If userid = "" Then
		Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF
	if staffconfirm and request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW
		Response.Write "<script type='text/javascript'>alert('텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if
	If typeval = "" Then
		Response.Write "<script type='text/javascript'>alert('진행상황이 잘돗 되었습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF
	If sub_opt2 = "" Then
		Response.Write "<script type='text/javascript'>alert('선물을 선택해 주세요.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF

	'//본인참여수
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
	if subscriptcount>=5 then
		Response.Write "<script type='text/javascript'>alert('모두 참여 하셨습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if
	
	if typeval<=subscriptcount then
		Response.Write "<script type='text/javascript'>alert('이전 단계["& subscriptcount+1 &"]를 먼저 참여 하셔야 합니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& typeval &"', "& sub_opt2 &", '', 'M')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
	
	Response.Write "<script type='text/javascript'>"
	
	if subscriptcount+1>=5 then
		Response.Write "	alert('모든 투표가 끝났습니다. 감사힙니다.');"
	else
		Response.Write "	alert('투표하셨습니다.\n"& 5-subscriptcount-1 &"개를 더 선택하실 수 있습니다.');"
	end if
	
	Response.Write "	parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'"
	Response.Write "</script>"
	dbget.close() : Response.End

else
	Response.Write "정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->