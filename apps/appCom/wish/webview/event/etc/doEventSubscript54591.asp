<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 기승전 2차 매일 매일 한가위만 같아라
' History : 2014.08.29 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/event54591Cls.asp" -->

<%
dim eCode, userid, mode, sqlstr, refer
	eCode=getevt_code
	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),32)

dim totalwinnersubscriptcount, totalmysubscriptcount, myisusingsubscriptcount, mysubscriptarr, mysubscriptresultval
	totalwinnersubscriptcount=0
	totalmysubscriptcount=0
	myisusingsubscriptcount=0
	mysubscriptarr=""
	mysubscriptresultval=""
	
dim itemrndNo, giftrndNo
	itemrndNo=0
	giftrndNo=0

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
	dbget.close() : Response.End
End IF
If not(getnowdate>="2014-09-02" and getnowdate<"2014-09-10") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
	dbget.close() : Response.End
End IF

if mode="eventreg" then
	'//총응모자 중에 당첨된 사람수
	totalwinnersubscriptcount = getevent_subscripttotalcount(eCode, getnowdate, "1", "")

	'//본인 응모수
	totalmysubscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate, "", "")
	'//템프값		'//카카오톡 친구초대시 1회에 한해서 하루에 한번더 참여가능. 체크를 위해 템프값을 넣어놓음
	myisusingsubscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate, "3", "")
	'//템프값이 0이 아닐경우 응모수에서 템프값을 뺌
	if myisusingsubscriptcount<>0 then
		totalmysubscriptcount=totalmysubscriptcount-myisusingsubscriptcount
	end if
	'//최근응모 1개
	'mysubscriptresultval = get54589event_subscriptresultval(eCode, userid, getnowdate)
	'//전체응모내역
	'mysubscriptarr = get54589event_subscriptarr(eCode, userid)

'	if limitgift(getnowdate)<=totalwinnersubscriptcount then
'		Response.Write "<script type='text/javascript'>alert('오늘의 선물이 이미 소진 되었습니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
'		dbget.close() : Response.End
'	end if
	if not( totalmysubscriptcount < 2 ) then
		Response.Write "<script type='text/javascript'>alert('하루에 두번까지만 참여가 가능합니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
		dbget.close() : Response.End
	end if
	if not( myisusingsubscriptcount = 0 ) then
		Response.Write "<script type='text/javascript'>alert('이미 응모 하셨습니다. 카카오톡 친구초대시 한번더 응모 하실수 있습니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
		dbget.close() : Response.End
	end if

	randomize
	itemrndNo = Int((100 * Rnd) + 1)
	
	'//제한수량이 넘었을경우 무조건 꽝됨
	if limitgift(getnowdate)<=totalwinnersubscriptcount then
		randomize
		giftrndNo = Int((7 * Rnd) + 1)

		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate &"', 2, '0"&replace(giftrndNo,0,1)&"', 'A')" + vbcrlf
	
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
		'//카톡 초기화 용		'//탬프값
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate &"', 3, '', 'A')" + vbcrlf
	
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
			
		'Response.Write "<script type='text/javascript'>alert('꽝!! 다음기회에 도전해 주세요.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
		response.write "0" & replace(giftrndNo,0,1) & "X"
		dbget.close() : Response.End
	else
		'//당첨		'//날짜별로 확률을 셋팅해놓고 가져옴
		if itemrndNo < randomitemcnt(getnowdate) then
			randomize
			giftrndNo = Int((3 * Rnd) + 1)
	
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate &"', 1, '0"&replace(giftrndNo,0,1)&"', 'A')" + vbcrlf
		
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr
			'//카톡 초기화 용		'//탬프값
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate &"', 3, '', 'A')" + vbcrlf
		
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr
				
			'Response.Write "<script type='text/javascript'>alert('당첨!! 참여해 주셔서 감사합니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
			response.write "0" & replace(giftrndNo,0,1) & "O"
			dbget.close() : Response.End
	
		'//꽝
		else
			randomize
			giftrndNo = Int((7 * Rnd) + 1)
	
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate &"', 2, '0"&replace(giftrndNo,0,1)&"', 'A')" + vbcrlf
		
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr
			'//카톡 초기화 용		'//탬프값
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate &"', 3, '', 'A')" + vbcrlf
		
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr
				
			'Response.Write "<script type='text/javascript'>alert('꽝!! 다음기회에 도전해 주세요.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
			response.write "0" & replace(giftrndNo,0,1) & "X"
			dbget.close() : Response.End
		end if
	end if

elseif mode="kakaoreg" then
	'//총응모자 중에 당첨된 사람수
	totalwinnersubscriptcount = getevent_subscripttotalcount(eCode, getnowdate, "1", "")

	'//본인 응모수
	totalmysubscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate, "", "")
	'//템프값		'//카카오톡 친구초대시 1회에 한해서 하루에 한번더 참여가능. 체크를 위해 템프값을 넣어놓음
	myisusingsubscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate, "3", "")
	'//템프값이 0이 아닐경우 응모수에서 템프값을 뺌
	if myisusingsubscriptcount<>0 then
		totalmysubscriptcount=totalmysubscriptcount-myisusingsubscriptcount
	end if
	'//최근응모 1개
	'mysubscriptresultval = get54589event_subscriptresultval(eCode, userid, getnowdate)
	'//전체응모내역
	'mysubscriptarr = get54589event_subscriptarr(eCode, userid)

'	if limitgift(getnowdate)<=totalwinnersubscriptcount then
'		Response.Write "<script type='text/javascript'>alert('오늘의 선물이 이미 소진 되었습니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
'		dbget.close() : Response.End
'	end if
	if not( totalmysubscriptcount < 2 ) then
		Response.Write "<script type='text/javascript'>alert('하루에 두번까지만 참여가 가능합니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
		dbget.close() : Response.End
	end if
	if not( totalmysubscriptcount > 0 ) then
		Response.Write "<script type='text/javascript'>alert('응모를 먼저 해주세요.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
		dbget.close() : Response.End
	end if
	if not( myisusingsubscriptcount > 0 ) then
		Response.Write "<script type='text/javascript'>alert('카카오톡 친구 참여는 1회만 가능 합니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
		dbget.close() : Response.End
	end if
	
	'//카톡 초기화 용		'//탬프값을 삭제 해서 1회 응모 더 가능하게함
	sqlstr = "delete from [db_event].[dbo].[tbl_event_subscript] where evt_code="& eCode &" and userid='"& userid &"' and sub_opt1='"& getnowdate &"' and sub_opt2=3"

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
		
	Response.Write "<script type='text/javascript'>parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
	dbget.close() : Response.End


else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->