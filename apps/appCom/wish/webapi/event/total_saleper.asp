<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/inc_const.asp"-->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<%
'###############################################
' Discription : 이벤트 대표 할인율 get
' History : 2020-01-14
'###############################################

Response.ContentType = "application/json"
dim oJson, eventCode, dispId

'object 초기화
Set oJson = jsObject()

eventCode = request("eventCode")
dispId = request("dispId")


dim salePer
salePer = getEvtTotalSalePer(eventCode)
oJson("salePer") = salePer
oJson("dispId") = dispId

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing

%>
