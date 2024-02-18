<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리 2021 메인페이지
' History : 2020-08-11 이종화 새성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/diarystory2022/lib/worker_only_view.asp" -->
<%
dim gnbflag, gaparam
gnbflag = RequestCheckVar(request("gnbflag"),1)
gaparam = RequestCheckVar(request("gaparam"),12)

If gnbflag <> "" Then '//gnb 숨김 여부
	gnbflag = True
	gaparam = "gnb"
Else 
	gnbflag = False
	strHeadTitleName = "다이어리 스토리"
End if

%>
<script>
$(function(){
	fnAmplitudeEventAction('view_diarystory_main','place','<%=gaparam%>');
});
</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
    <% server.Execute("/diarystory2022/inc/main/main_exec.asp") %>
	<!-- #include virtual="/lib/inc/incfooter.asp" -->
</body>
</html> 
<!-- #include virtual="/lib/db/dbclose.asp" -->