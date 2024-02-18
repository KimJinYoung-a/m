<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/tenSessionLib.asp" -->
<script type="text/javascript" src="https://cdn.branch.io/branch-2.52.2.min.js"></script>
<script>
	!function(q,g,r,a,p,h,js) {
        if(q.qg)return;
        js = q.qg = function() {
            js.callmethod ? js.callmethod.call(js, arguments) : js.queue.push(arguments);
        };
        js.queue = [];
        p=g.createElement(r);p.async=!0;p.src=a;h=g.getElementsByTagName(r)[0];
        h.parentNode.insertBefore(p,h);
    } (window,document,'script','https://cdn.qgr.ph/qgraph.df0854decfeb333174cb.js');
    qg("event", "logout");

	<%'// Branch Init %>
	<% if application("Svr_Info")="staging" Then %>
		branch.init('key_test_ngVvbkkm1cLkcZTfE55Dshaexsgl87iz');
	<% elseIf application("Svr_Info")="Dev" Then %>
		branch.init('key_test_ngVvbkkm1cLkcZTfE55Dshaexsgl87iz');
	<% else %>
		branch.init('key_live_hpOucoij2aQek0GdzW9xFddbvukaW6le');
	<% end if %>
	branch.logout();
</script>
<%
dim backpath, isBiz

backpath = request("backpath")
isBiz = request("isBiz")

Dim iCookieDomainName : iCookieDomainName = GetCookieDomainName

CALL fnDBSessionExpireV2()

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

dim referer
referer = request.ServerVariables("HTTP_REFERER")

if (isBiz = "Y") Then
	response.redirect "/biz/"
elseif (backpath = "") then
	response.redirect "/"
else
	response.redirect backpath
end if
%>
