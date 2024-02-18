<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/util/tenSessionLib.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.ContentType = "text/html"

Dim sData : sData = Request("json")
Dim sType, sKind, sOffset, sSize, sFDesc, i, sOS, sVerCd, sAppKey, sDeviceId, sUUID, snID, userid
Dim oJson

on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	''sType = oResult.type
    
    sOS = requestCheckVar(oResult.OS,10)
    sVerCd = requestCheckVar(oResult.versioncode,20)
    sDeviceId = requestCheckVar(oResult.pushid,256)
    sUUID = requestCheckVar(oResult.uuid,40)
    snID = requestCheckVar(oResult.nid,40)
    
    userid = GetLoginUserID

Dim iCookieDomainName : iCookieDomainName = GetCookieDomainName

''앱에서 로그 오프를 하고 날리는듯함.. (안드로이드만 그런듯)
CALL fnDBSessionExpireV2() ''2018/08/18 위치변경 세션먼저

response.Cookies("uinfo").domain = iCookieDomainName
response.Cookies("uinfo") = ""
response.Cookies("uinfo").Expires = Date - 1

response.Cookies("mssn").domain = iCookieDomainName
response.Cookies("mssn") = ""
response.Cookies("mssn").Expires = Date - 1

response.Cookies("etc").domain = iCookieDomainName
response.Cookies("etc") = ""
response.Cookies("etc").Expires = Date - 1

response.Cookies("mybadge").domain = iCookieDomainName
response.Cookies("mybadge") = ""
response.Cookies("mybadge").Expires = Date - 1

response.Cookies("mSave").domain = iCookieDomainName
response.cookies("mSave") = ""
response.Cookies("mybadge").Expires = Date - 1

response.Cookies("todayviewitemidlist").domain = iCookieDomainName
response.cookies("todayviewitemidlist") = ""
response.Cookies("todayviewitemidlist").Expires = Date - 1

''2017/05/30
response.Cookies("rdsite").domain = iCookieDomainName
response.cookies("rdsite") = ""
response.Cookies("rdsite").Expires = Date - 1

''2018/08/15
response.Cookies("shoppingbag").domain = iCookieDomainName
response.cookies("shoppingbag") = ""
response.Cookies("shoppingbag").Expires = Date - 1

session.abandon

if ERR then Call OnErrNoti()
On Error Goto 0

Set oJson = jsObject()
oJson("response") = getErrMsg("1000",sFDesc)
oJson.flush
Set oJson = Nothing
%>
