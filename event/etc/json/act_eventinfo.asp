<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/inc_const.asp"-->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
'###############################################
' Discription : 이벤트 시작일 종료일 가저오기 + @ 기타 정보들 가저올 수 있음
' History : 2020.02.16 이종화
'###############################################

dim oJson , eventid
eventid = requestCheckVar(Request("eventid"),160)	'// 이벤트 코드들

'//헤더 출력
Response.ContentType = "application/json"

'// json객체 선언
Set oJson = jsObject()

if eventid<>"" then
	'정렬순서 쿼리

	dim sqlStr
	sqlStr = " SELECT evt_startdate , evt_enddate FROM "&vbcrlf
    sqlStr = sqlStr & "db_event.dbo.tbl_event WHERE evt_code = "& eventid
	
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	if Not(rsget.EOF or rsget.BOF) then
		Do Until rsget.EOF
			Set oJson("events") = jsObject()
			oJson("events")("startdate") = FormatDate(rsget("evt_startdate"),"0000/00/00 00:00:00")
			oJson("events")("enddate") = FormatDate(rsget("evt_enddate"),"0000/00/00 00:00:00")
			rsget.MoveNext
		loop
	else
		oJson("events") = ""
	end if
	rsget.Close
else
	oJson("events") = ""
end if

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
