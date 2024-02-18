<%@  codepage="65001" language="VBScript" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
    response.charset = "utf-8"

	'# 현재 페이지명 접수
	dim nowViewPage
	nowViewPage = request.ServerVariables("SCRIPT_NAME")
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script language="javascript">
//document.location.href = "contest2.asp";  
//$(function() {
  //
//});
</script>
<div class="heightGrid">

	<div class="container bgGry">
		<!-- content area -->
		<div class="content evtView" id="contentArea">
            <div><iframe id="iframe_55082" src="/apps/appcom/wish/web2014/event/etc/iframe_55082.asp" width="100%" height="100%" frameborder="0" scrolling="no" class="autoheight"></iframe></div>
        </div>
    </div>
    <!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
    <script type="text/javascript" src="/lib/js/jquery.iframe-auto-height-webview.js"></script>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->