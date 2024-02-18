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
' Description : 메일링 이벤트
' History : 2019.05.09 최종원
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
dim limitcnt, currentcnt, isAcceptUser, evtCode, presentDate
dim eventType, jukyo
dim OJson
Set oJson = jsObject()
dim subscriptcount
dim eCode, userid, currenttime, device

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
Set oJson("data") = jsArray()
Set oJson("data")(null) = jsObject() 

isAcceptUser = request("isAcceptUser")
evtCode		 = request("evtCode")
presentDate  = request("presentDate")

'변수 초기화

eCode = evtCode

If eCode = "" Then	
	oJson("data")(null)("result") = "ERR|잘못된 접근입니다."
	oJson.flush
	Set oJson = Nothing	
	dbget.close() : Response.End
End IF

dim evtinfo : evtinfo = getEventDate(eCode)
subscriptcount = 0
eventStartDate = cdate(evtinfo(0,0))
eventEndDate = cdate(evtinfo(1,0))
currentDate = date()
eventStartDate = Cdate("2019-05-03")

currenttime = now()

userid = GetEncLoginUserID()

If userid = "" Then	
	oJson("data")(null)("result") = "ERR|로그인을 해주세요."
	oJson.flush
	Set oJson = Nothing	
	dbget.close() : Response.End
End IF

	device = "m"

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", isAcceptUser)
end if

if InStr(refer,"10x10.co.kr")<1 or not eCode <> "" then
	oJson("data")(null)("result") = "ERR|잘못된 접속입니다."
	oJson.flush
	Set oJson = Nothing	
	dbget.close() : Response.End
end If
if not (currentDate >= eventStartDate and currentDate <= eventEndDate ) then	
	oJson("data")(null)("result") = "ERR|이벤트 응모 기간이 아닙니다."
	oJson.flush
	Set oJson = Nothing		
	dbget.close() : Response.End
End IF
if isAcceptUser = "Y" then
	oJson("data")(null)("result") = "ERR|이미 메일 수신에 동의하셨습니다.>?n매달 첫번째 월요일을 기다려주세요!"
	oJson.flush
	Set oJson = Nothing		
	dbget.close() : Response.End
End IF

'이벤트 응모 이력 insert
sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', '', '"& isAcceptUser &"', '"& device &"')" + vbcrlf

'response.write sqlstr & "<Br>"
dbget.execute sqlstr

'이메일 허용값 updqte
sqlstr = "UPDATE DB_USER.DBO.TBL_USER_N " & vbcrlf
sqlstr = sqlstr & " SET EMAILOK = 'Y' " & vbcrlf
sqlstr = sqlstr & " where userid='" & userid & "'"  & vbcrlf

'response.write sqlstr & "<Br>"
dbget.execute sqlstr
if isAcceptUser = "N" then
	oJson("data")(null)("result") = "OK|이메일 수신동의가 완료되었습니다.>?n매달 첫번째 월요일을 기다려주세요!"
Else
	oJson("data")(null)("result") = "OK|이미 메일 수신에 동의하셨습니다.>?n매달 첫번째 월요일을 기다려주세요!"
end if

oJson.flush
Set oJson = Nothing		
dbget.close() : Response.End
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->