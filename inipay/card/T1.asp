<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>

<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/header.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<script language='javascript'>
function GoNext(){
	if(( navigator.userAgent.indexOf("MSIE") >= 0 || navigator.appName == 'Microsoft Internet Explorer' ) ){
		//frm1.acceptCharset='euc-kr';  // ie인 경우 document.charset 이라나. // 또는 Form 안에  <form accept-charset="euc-kr"
		document.charset = "euc-kr";
		
	}
	frm1.submit();
}
</script>
<div id="home" selected="true" >
<form name=frm1 method=post action="t2.asp"  accept-charset="euc-kr">
<input type="text" name="aaa" value="가나다">
<input type="text" name="bbb" value="가나다">
<input type="hidden" name="ccc" value="가나다">
</form>
<input type="button" value="go" onClick="GoNext();">
</div>
<!--푸터영역-->
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->