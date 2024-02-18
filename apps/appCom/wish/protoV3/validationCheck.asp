<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV3/protoV3Function.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/validationCheck.asp
' Discription : Wish APP 구동시 무결성 검사
' Request : json > type, pushid, OS, versioncode, versionname, verserion
' Response : response > 결과, event
' History : 2018.08.27 원승현 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sData : sData = Request("json")
Dim oJson, sType, sAppType, sOsType, sVersionName, sKey, sqlStr, vValidationCheck

'// 전송결과 파징
on Error Resume Next
	vValidationCheck = False
	'// json객체 선언
	Set oJson = jsObject()
	oJson("response") = "ok"
	On Error Goto 0
'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->