<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 마일리지를 사수하라
' History : 2015.03.20 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event60274Cls.asp" -->

<%
dim mode, sqlstr, i
	mode = requestcheckvar(request("mode"),32)

dim eCode, subscriptcount, itembuycount, userid
	eCode=getevt_code
	userid = getloginuserid()

subscriptcount=0
itembuycount=0

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

if mode="valinsert" then
	If not(getnowdate>="2015-03-11" and getnowdate<"2015-03-16") Then
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

	'//본인참여수
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
	if subscriptcount>0 then
		Response.Write "<script type='text/javascript'>alert('이미 응모 하셨습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if
	
	itembuycount = get10x10onlineordercount(userid, "2015-03-11", "2015-03-16", "", "'app_wish2'", "7", "N")
	'itembuycount = 1
	if itembuycount<1 then
		Response.Write "<script type='text/javascript'>alert('텐바이텐 APP 구매 내역이 없습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate &"', '', '', 'M')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
	
	Response.Write "<script type='text/javascript'>"
	Response.Write "	alert('응모해 주셔서 감사힙니다.');"
	Response.Write "	parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'"
	Response.Write "</script>"
	dbget.close() : Response.End

else
	Response.Write "정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->