<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 당신이 너무 눈부셔서(APP이벤트)
' History : 2014.11.07 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/etc/event56327Cls.asp" -->

<%
dim eCode, userid, mode, sqlstr, refer, giftrndNo
	eCode=getevt_code
	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),32)
	giftrndNo = requestcheckvar(request("giftrndNo"),1)

dim totalmysubscriptcount, myisusingsubscriptcount
	totalmysubscriptcount=0
	myisusingsubscriptcount=0

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

'If userid = "" Then
'	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
'	dbget.close() : Response.End
'End IF
If not(getnowdate>="2014-11-13" and getnowdate<"2014-11-18") Then
'	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
'	dbget.close() : Response.End
	response.write "222"
	dbget.close() : Response.End
End IF

if mode="eventreg" then
	'//본인 응모수
	totalmysubscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate, "", "")
	'//템프값		'//카카오톡 친구초대시 1회에 한해서 하루에 한번더 참여가능. 체크를 위해 템프값을 넣어놓음
	myisusingsubscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate, "3", "")
	'//템프값이 0이 아닐경우 응모수에서 템프값을 뺌

	if myisusingsubscriptcount<>0 then
		totalmysubscriptcount=totalmysubscriptcount-myisusingsubscriptcount
	end if

	if not( totalmysubscriptcount < 2 ) then
		Response.Write "<script type='text/javascript'>alert('하루에 두번까지만 참여가 가능합니다.'); parent.top.location.href='/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
		dbget.close() : Response.End
	end if

	if not( myisusingsubscriptcount = 0 ) then
		Response.Write "<script type='text/javascript'>alert('이미 응모 하셨습니다. 카카오톡 친구초대시 한번더 응모 하실수 있습니다.'); parent.top.location.href='/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate &"', 1, '"&giftrndNo&"', 'A')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
	'//카톡 초기화 용		'//탬프값
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate &"', 3, '', 'A')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
		
	'Response.Write "<script type='text/javascript'>alert('당첨!! 참여해 주셔서 감사합니다.'); parent.top.location.href='/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
	response.write "000"
	dbget.close() : Response.End

elseif mode="kakaoreg" then
	'//본인 응모수
	totalmysubscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate, "", "")
	'//템프값		'//카카오톡 친구초대시 1회에 한해서 하루에 한번더 참여가능. 체크를 위해 템프값을 넣어놓음
	myisusingsubscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate, "3", "")
	'//템프값이 0이 아닐경우 응모수에서 템프값을 뺌
	if myisusingsubscriptcount<>0 then
		totalmysubscriptcount=totalmysubscriptcount-myisusingsubscriptcount
	end if

	if not( totalmysubscriptcount < 2 ) then
		Response.Write "<script type='text/javascript'>alert('하루에 두번까지만 참여가 가능합니다.'); parent.top.location.href='/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
		dbget.close() : Response.End
	end if
	if not( totalmysubscriptcount > 0 ) then
		Response.Write "<script type='text/javascript'>alert('응모를 먼저 해주세요.'); parent.top.location.href='/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
		dbget.close() : Response.End
	end if
	if not( myisusingsubscriptcount > 0 ) then
		Response.Write "<script type='text/javascript'>alert('카카오톡 친구 참여는 1회만 가능 합니다.'); parent.top.location.href='/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
		dbget.close() : Response.End
	end if
	
	'//카톡 초기화 용		'//탬프값을 삭제 해서 1회 응모 더 가능하게함
	sqlstr = "delete from [db_event].[dbo].[tbl_event_subscript] where evt_code="& eCode &" and userid='"& userid &"' and sub_opt1='"& getnowdate &"' and sub_opt2=3"

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
		
	Response.Write "<script type='text/javascript'>parent.top.location.href='/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
	dbget.close() : Response.End
	
elseif mode="notlogin" then
	'쿠키꿉는다
	response.cookies("etc").domain="10x10.co.kr"
	response.cookies("etc")("evtcode") = 56327
	
	response.write "111"		'//성공임
	dbget.close()	:	response.end
	
elseif mode="countchk" then
    
    sqlStr = "select top 1 sub_opt2 from [db_event].[dbo].[tbl_event_subscript]"
    sqlStr = sqlStr & "	where evt_code = "& eCode &" and userid='ct'"

    rsget.Open sqlStr,dbget,1
    if Not(rsget.EOF or rsget.BOF) then
		sqlstr = "UPDATE [db_event].[dbo].[tbl_event_subscript] SET sub_opt2 = sub_opt2 + 1 WHERE evt_code = "& eCode &" and userid='ct'" + vbcrlf
		dbget.execute sqlstr
	else
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt2, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", 'ct', '1', 'A')" + vbcrlf
		dbget.execute sqlstr
    end if
   dbget.close()	:	response.end
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->