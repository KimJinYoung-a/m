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
' Discription : 포맷
' History : 2019-07-24
'###############################################

Response.ContentType = "application/json"
dim oJson

'object 초기화
Set oJson = jsObject()
set oJson("comments") = jsArray()

set oJson("comments")(null) = jsObject()
oJson("comments")(null)("content") = "hi"
set oJson("comments")(null) = jsObject()
oJson("comments")(null)("content") = "hi1"
set oJson("comments")(null) = jsObject()
oJson("comments")(null)("content") = "hi2"


oJson("testdata1") = "hello1"
oJson("testdata2") = "hello2"
set oJson("testdata3") = jsArray()
set oJson("testdata3")(null) = jsObject()
oJson("testdata3")(null)("name1") = "hi"


'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
