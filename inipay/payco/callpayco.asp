<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim redirectUrl
redirectUrl = Request("rdurl")

if redirectUrl="" then
	Response.write "<script type='text/javascript'>alert('오류가 발생했습니다.\n- 파라메터 없음');opener.location.replace('"&SSLUrl&"/inipay/UserInfo.asp');self.close();</script>"
	dbget.close(): Response.End
end if

Response.Redirect redirectUrl
%>
