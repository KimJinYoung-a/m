<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 마일리지 프로세스
' History : 2020-07-07 이종화
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
dim sqlstr	
dim eventEndDate, currentDate, eventStartDate
dim limitcnt, currentcnt, mileage
dim eventType, jukyo
dim OJson
Set oJson = jsObject()
dim subscriptcount, totalsubscriptcount
dim eventCode, userid, currenttime, device
dim evtinfo 

eventCode = request("eventCode")
eventType = request("eventType")
jukyo = requestCheckVar(request("jukyo"),100)

evtinfo = getEventDate(eventCode)
subscriptcount = 0
totalsubscriptcount = 0
eventStartDate = cdate(evtinfo(0,0))
eventEndDate = cdate(evtinfo(1,0))
currentDate = date()
mileage = 2000

'// 요건 이벤트 오픈때는 주석처리 할 것
if (GetLoginUserLevel="7") then
    IF currentDate < eventStartDate THEN
        eventStartDate = currentDate
    END IF
end if

dim refer
	refer = request.ServerVariables("HTTP_REFERER")

currenttime = now()
'currenttime = #02/04/2019 09:00:00#

userid = GetEncLoginUserID()

Set oJson("data") = jsArray()
Set oJson("data")(null) = jsObject() 

If userid = "" Then	
	oJson("data")(null)("result") = "ERR|로그인을 해주세요."
	oJson.flush
	Set oJson = Nothing	
	dbget.close() : Response.End
End IF

if isApp="1" then
	device = "A"
else
	device = "M"
end if

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eventCode, userid, "", mileage, "")
end if

'//전체 참여수
totalsubscriptcount = getevent_subscripttotalcount(eventCode, left(currenttime,10), mileage, "")

limitcnt = 99999
currentcnt = limitcnt - totalsubscriptcount

oJson("data")(null)("currentcnt") = cStr(Format00(4,currentcnt))
oJson("data")(null)("mileage") = getUserCurrentMileage(userid)

IF application("Svr_Info") <> "Dev" THEN
    IF InStr(refer,"10x10.co.kr")<1 or not eventCode <> "" THEN
        oJson("data")(null)("result") = "ERR|잘못된 접속입니다."
        oJson.flush
        Set oJson = Nothing	
        dbget.close() : Response.End
    END IF
END IF

if not (currentDate >= eventStartDate and currentDate <= eventEndDate ) then	
	oJson("data")(null)("result") = "ERR|이벤트 응모 기간이 아닙니다."
	oJson.flush
	Set oJson = Nothing		
	dbget.close() : Response.End
End IF
if subscriptcount > 0 then
	oJson("data")(null)("result") = "ERR|ID당 1회만 참여 가능합니다."
	oJson.flush
	Set oJson = Nothing		
	dbget.close() : Response.End
End IF
if eventType = "limitedEvent" then
	if currentcnt < 1 then
		oJson("data")(null)("result") = "ERR|오늘의 마일리지가 모두 소진 되었습니다."
		oJson.flush
		Set oJson = Nothing		
		dbget.close() : Response.End
	End IF
	if Hour(currenttime) < 10 then	
		oJson("data")(null)("result") = "ERR|마일리지는 오전 10시부터 받으실수 있습니다."
		oJson.flush
		Set oJson = Nothing		
		dbget.close() : Response.End
	End IF
end if

sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
sqlstr = sqlstr & " VALUES("& eventCode &", '" & userid & "', '"& left(currenttime,10) &"', '"& mileage &"', '', '"& device &"')" + vbcrlf

'response.write sqlstr & "<Br>"
dbget.execute sqlstr

sqlstr = "update db_user.dbo.tbl_user_current_mileage" & vbcrlf
sqlstr = sqlstr & " set bonusmileage = bonusmileage + "& mileage &" where" & vbcrlf
sqlstr = sqlstr & " userid='" & userid & "'"

'response.write sqlstr & "<Br>"
dbget.execute sqlstr

sqlstr = "insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) values (" & vbcrlf
sqlstr = sqlstr & " '" & userid & "', '"& mileage &"', "& eventCode &", '"& jukyo &"','N')"

'response.write sqlstr & "<Br>"
dbget.execute sqlstr

oJson("data")(null)("result") = "OK|entry"
oJson("data")(null)("currentcnt") = cStr(Format00(4,limitcnt - getevent_subscripttotalcount(eventCode, left(currenttime,10), mileage, "")))
oJson("data")(null)("mileage") = getUserCurrentMileage(userid)
oJson("data")(null)("evtStartDate") = eventStartDate
oJson("data")(null)("evtEndDate") = eventEndDate
oJson.flush
Set oJson = Nothing		
dbget.close() : Response.End
%>