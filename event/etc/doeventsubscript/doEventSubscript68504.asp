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
' Description : 2016 마일리지
' History : 2016.01.08 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim mode, sqlstr
	mode = requestcheckvar(request("mode"),32)
	isapp = requestcheckvar(request("isapp"),1)

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end If

dim eCode, userid, currenttime
	IF application("Svr_Info") = "Dev" THEN
		eCode = "65999"
	Else
		eCode = "68504"
	End If

	currenttime = now()
	'currenttime = #01/11/2016 10:06:00#

	userid = GetEncLoginUserID()

dim subscriptcount, totalsubscriptcount
subscriptcount=0
totalsubscriptcount=0

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "1", "")

end if

'//전체 참여수
totalsubscriptcount = getevent_subscripttotalcount(eCode, left(currenttime,10), "1", "")

dim limitcnt, currentcnt
limitcnt = 2016
currentcnt = limitcnt - totalsubscriptcount

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF
If not( left(currenttime,10)>="2016-01-11" and left(currenttime,10)<"2016-01-16" ) Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF

if mode="regmillage" then
	if subscriptcount>0 then
		Response.Write "<script type='text/javascript'>alert('이미 마일리지를 받으셨습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF
	if currentcnt<1 then
		Response.Write "<script type='text/javascript'>alert('오늘의 마일리지가 모두 소진 되었습니다!.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF
	if Hour(currenttime) < 10 then
		Response.Write "<script type='text/javascript'>alert('마일리지는 오전 10시부터 받으실수 있습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf

	if isApp="1" then
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 1, '', 'A')" + vbcrlf
	else
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 1, '', 'M')" + vbcrlf
	end if

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	sqlstr = "update db_user.dbo.tbl_user_current_mileage" & vbcrlf
	sqlstr = sqlstr & " set bonusmileage = bonusmileage+2016 where" & vbcrlf
	sqlstr = sqlstr & " userid='" & userid & "'"

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	sqlstr = "insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) values (" & vbcrlf
	sqlstr = sqlstr & " '" & userid & "', '+2016', "& eCode &", '2016마일리지','N')"

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
	
	'쿠키 꿉기
	response.Cookies("etc").domain = "10x10.co.kr"
	response.Cookies("etc")("mcurrentmile") = request.Cookies("etc")("mcurrentmile") + 2016

	Response.Write "<script type='text/javascript'>alert('마일리지 지급 완료\n현금처럼 사용 가능한 마일리지!\n오늘 자정까지 꼭 사용하세요!'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End

else
	Response.Write "정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->