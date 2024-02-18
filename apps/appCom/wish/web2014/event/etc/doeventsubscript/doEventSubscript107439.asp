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
' Description : 반짝 2000 마일리지
' History : 2020-11-10 정태훈
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
dim eCode, userid, currenttime, device, eGiveCode
'변수 초기화
IF application("Svr_Info") = "Dev" THEN
	eCode = "103261"
Else
	eCode = "107439"
End If
dim evtinfo : evtinfo = getEventDate(eCode)
subscriptcount = 0
totalsubscriptcount = 0
eventStartDate = cdate(evtinfo(0,0))
eventEndDate = cdate(evtinfo(1,0))
currentDate = date()
mileage = 2000

eventType = request("eventType")

'// 요건 이벤트 오픈때는 주석처리 할 것
if (GetLoginUserLevel="7") then
    IF currentDate < eventStartDate THEN
        eventStartDate = currentDate
    END IF
end if

dim refer
	refer = request.ServerVariables("HTTP_REFERER")

currenttime = now()
'currenttime = #11/12/2020 09:00:00#

userid = GetEncLoginUserID()

if left(Cdate(currenttime),10) = "2020-11-11" then
    eGiveCode = "107482"
    jukyo = "반짝 마일리지 (11/12 02:59까지 사용 가능)"
elseif left(Cdate(currenttime),10) = "2020-11-12" then
    eGiveCode = "107483"
    jukyo = "반짝 마일리지 (11/13 02:59까지 사용 가능)"
elseif left(Cdate(currenttime),10) = "2020-11-13" then
    eGiveCode = "107484"
    jukyo = "반짝 마일리지 (11/14 02:59까지 사용 가능)"
elseif left(Cdate(currenttime),10) = "2020-11-14" then
    eGiveCode = "107485"
    jukyo = "반짝 마일리지 (11/15 02:59까지 사용 가능)"
elseif left(Cdate(currenttime),10) = "2020-11-15" then
    eGiveCode = "107486"
    jukyo = "반짝 마일리지 (11/16 02:59까지 사용 가능)"
elseif left(Cdate(currenttime),10) = "2020-11-16" then
    eGiveCode = "107634"
	jukyo = "반짝 마일리지 (11/17 02:59까지 사용 가능)"
elseif left(Cdate(currenttime),10) = "2020-11-17" then
    eGiveCode = "107635"
	jukyo = "반짝 마일리지 (11/18 02:59까지 사용 가능)"
else
    eGiveCode = "107482"
    jukyo = "반짝 마일리지 (11/12 02:59까지 사용 가능)"
end if
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
	subscriptcount = getevent_subscriptexistscount(eGiveCode, userid, "", mileage, "")
end if

'//전체 참여수
totalsubscriptcount = getevent_subscripttotalcount(eCode, left(currenttime,10), mileage, "")

limitcnt = 99999
currentcnt = limitcnt - totalsubscriptcount

oJson("data")(null)("currentcnt") = cStr(Format00(4,currentcnt))
oJson("data")(null)("mileage") = getUserCurrentMileage(userid)

IF application("Svr_Info") <> "Dev" THEN
	if InStr(refer,"10x10.co.kr")<1 or not eCode <> "" then
		oJson("data")(null)("result") = "ERR|잘못된 접속입니다."
		oJson.flush
		Set oJson = Nothing	
		dbget.close() : Response.End
	end If
END IF

if not (currentDate >= eventStartDate and currentDate <= eventEndDate ) then	
	oJson("data")(null)("result") = "ERR|이벤트 응모 기간이 아닙니다."
	oJson.flush
	Set oJson = Nothing		
	dbget.close() : Response.End
End IF
if Hour(now()) >= Hour("00:00") and Hour(now()) < Hour("18:00") then	
	oJson("data")(null)("result") = "ERR|오후 6시부터 자정까지 마일리지 발급이 가능합니다."
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

sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
sqlstr = sqlstr & " VALUES("& eGiveCode &", '" & userid & "', '"& left(currenttime,10) &"', '"& mileage &"', '', '"& device &"')" + vbcrlf

'response.write sqlstr & "<Br>"
dbget.execute sqlstr

sqlstr = "update db_user.dbo.tbl_user_current_mileage" & vbcrlf
sqlstr = sqlstr & " set bonusmileage = bonusmileage + "& mileage &" where" & vbcrlf
sqlstr = sqlstr & " userid='" & userid & "'"

'response.write sqlstr & "<Br>"
dbget.execute sqlstr

sqlstr = "insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) values (" & vbcrlf
sqlstr = sqlstr & " '" & userid & "', '"& mileage &"', "& eGiveCode &", '"& jukyo &"','N')"

'response.write sqlstr & "<Br>"
dbget.execute sqlstr

oJson("data")(null)("result") = "OK|entry"
oJson("data")(null)("currentcnt") = cStr(Format00(4,limitcnt - getevent_subscripttotalcount(eCode, left(currenttime,10), mileage, "")))
oJson("data")(null)("mileage") = getUserCurrentMileage(userid)
oJson("data")(null)("evtStartDate") = eventStartDate
oJson("data")(null)("evtEndDate") = eventEndDate
oJson.flush
Set oJson = Nothing		
dbget.close() : Response.End
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->