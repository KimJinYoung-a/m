<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  텐텐문방구
' History : 2019.06.12 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
    dim gnbflag : gnbflag = requestCheckVar(request("gnbflag"),1)
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/moonbanggu.css" />
<script type="text/javascript">
$(function() {
	//map move
	$(".items-wrap .nav a").click(function(e){
		$('html,body').animate({'scrollTop': $(this.hash).offset().top-75});
			e.preventDefault();
	});
});
</script>
<body class="default-font body-<%=chkiif(gnbflag="1","main","sub")%> moonbanggu">  
<%
     server.Execute("/stationeryStore/main_exec.asp")
%>			
    <!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->