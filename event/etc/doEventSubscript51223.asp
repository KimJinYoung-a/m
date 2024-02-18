<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [텐바이텐x다노] 내 생에 가장 단호한 일주일 
' History : 2014.02.21 한용민 생성-2014.02.21 유태욱 수정
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event51223Cls.asp" -->

<%
dim eCode, userid, mode, sqlstr, refer, itemid, txtcomm, sub_idx
dim subscriptcount, couponnewcount, itemexistscnt
	eCode=getevt_code
	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),32)
	itemid = requestcheckvar(request("itemid"),10)
	sub_idx = requestcheckvar(request("sub_idx"),10)
	txtcomm = requestcheckvar(request("txtcomm"),64)

subscriptcount=0
itemexistscnt=0

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF
If not(getnowdate>="2014-04-21" and getnowdate<"2014-04-28") Then
	Response.Write "<script type='text/javascript'>alert('출석체크 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF

if mode="day1" then
	if checkNotValidTxt(txtcomm) then
		Response.Write "<script type='text/javascript'>alert('내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End		
	end if
	
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "1", "")
	If subscriptcount > 0 Then
		Response.Write "<script type='text/javascript'>alert('이미 응모 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate &"', '1' , '"& html2db(txtcomm) &"', 'M')" + vbcrlf
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('출석체크 완료!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	
elseif mode="day1del" then
	If sub_idx = "" Then
		Response.Write "<script type='text/javascript'>alert('구분자가 없습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF

	sqlstr="delete from db_event.dbo.tbl_event_subscript where sub_idx='"& sub_idx &"'"
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('삭제되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"

elseif mode="day2" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "2", "")
	If subscriptcount > 0 Then
		Response.Write "<script type='text/javascript'>alert('이미 응모 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate &"', '2' , 'M')" + vbcrlf
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('출석체크 완료!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"

elseif mode="day3" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "3", "")
	If subscriptcount > 0 Then
		Response.Write "<script type='text/javascript'>alert('이미 응모 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate &"', '3' , 'M')" + vbcrlf
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('출석체크 완료!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	
elseif mode="day4" then
	if checkNotValidTxt(itemid) then
		Response.Write "<script type='text/javascript'>alert('상품 코드에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End		
	end if
	
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "4", "")
	If subscriptcount > 0 Then
		Response.Write "<script type='text/javascript'>alert('이미 응모 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF
	
	'//존재하는 상품인지 체크
	sqlstr = "select count(*) as cnt"
	sqlstr = sqlstr & " from db_item.dbo.tbl_item"
	sqlstr = sqlstr & " where itemid <> 0 and itemid="& itemid &""

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		itemexistscnt = rsget("cnt")
	END IF
	rsget.close
	If itemexistscnt = 0 Then
		Response.Write "<script type='text/javascript'>alert('존재하지 않는 상품 입니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF
	
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate &"', '4' , '"& html2db(itemid) &"', 'M')" + vbcrlf
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('출석체크 완료!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	

	elseif mode="day5" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "5", "")
	If subscriptcount > 0 Then
		Response.Write "<script type='text/javascript'>alert('이미 응모 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate &"', '5' , 'M')" + vbcrlf
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('출석체크 완료!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"

	elseif mode="day6" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "6", "")
	If subscriptcount > 0 Then
		Response.Write "<script type='text/javascript'>alert('이미 응모 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate &"', '6' , 'M')" + vbcrlf
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('출석체크 완료!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"

	elseif mode="day7" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "7", "")
	If subscriptcount > 0 Then
		Response.Write "<script type='text/javascript'>alert('이미 응모 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate &"', '7' , 'M')" + vbcrlf
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('출석체크 완료!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if

%>

<!-- #include virtual="/lib/db/dbclose.asp" -->