<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<script language="javascript">
<!--
	function jsReload(isOpen, strPath){
		if (isOpen == "on"){
			opener.location.reload();
		}
		
		location.href=strPath;
	}
//-->
</script>
<%
dim backpath,isopenerreload
dim strGetData, strPostData

isopenerreload = request("isopenerreload")

response.Cookies("shoppingbag").domain = "10x10.co.kr"
response.Cookies("shoppingbag")("isguestorderflag") = "on"

backpath 	= ReplaceRequestSpecialChar(request("backpath"))
strGetData  = ReplaceRequestSpecialChar(request("strGD"))
strPostData = ReplaceRequestSpecialChar(request("strPD"))

if (backpath="") then backpath="/"
if strGetData <> "" then backpath = backpath&"?"&strGetData

%>	
	<form method="post" name="frmLogin" action="<%=backpath%>" >
	<%	Call sbPostDataToHtml(strPostData) %>
	</form>
	<script language="javascript">
		document.frmLogin.submit();
	</script>
<%	
response.end
%>