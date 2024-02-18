<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 다이어리스토리 2022 메인페이지
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
dim i, weekDate, imglink, gnbflag, gaparam

gnbflag = RequestCheckVar(request("gnbflag"),1)
gaparam = RequestCheckVar(request("gaparam"),12)

If gnbflag = "1" Then '//gnb 숨김 여부
	gnbflag = true
	gaparam = "gnb"
Else 
	gnbflag = False
	strHeadTitleName = "다이어리 스토리"
End if
	
IF application("Svr_Info") = "Dev" THEN
	imglink = "testimgstatic"
Else
	imglink = "imgstatic"
End If
%>
<style>.body-main {padding-top:91px;}</style>
<script>
$(function(){
	fnAmplitudeEventAction('view_diarystory_main','place','<%=gaparam%>');
});
</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%> diary2021">
	<% server.Execute("/diarystory2022/inc/main/main_exec.asp") %>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->