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

Dim iCookieDomainName : iCookieDomainName = GetCookieDomainName

CALL fnDBSessionExpireV2() ''2018/08/18 위치변경 세션먼저

response.Cookies("uinfo").domain = iCookieDomainName
response.Cookies("uinfo") = ""
response.Cookies("uinfo").Expires = Date - 1

response.Cookies("mssn").domain = iCookieDomainName
response.Cookies("mssn") = ""
response.Cookies("mssn").Expires = Date - 1

response.Cookies("mSave").domain = iCookieDomainName
response.cookies("mSave") = ""
response.Cookies("mSave").Expires = Date - 1

response.Cookies("etc").domain = iCookieDomainName
response.Cookies("etc") = ""
response.Cookies("etc").Expires = Date - 1

response.Cookies("mybadge").domain = iCookieDomainName
response.Cookies("mybadge") = ""
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

Dim oJson
Dim sFDesc
Set oJson = jsObject()
oJson("response") = getErrMsg("1000",sFDesc)
oJson.flush
Set oJson = Nothing
%>
