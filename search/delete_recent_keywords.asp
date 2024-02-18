<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<%
    Dim iCookieDomainName : iCookieDomainName = GetCookieDomainName
    response.Cookies("tenRecentKeywords").domain = iCookieDomainName
    Response.Cookies("tenRecentKeywords").Expires = date() - 1
%>