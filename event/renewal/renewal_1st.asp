<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
'####################################################
' Description : 리뉴얼 안내 페이지
' History : 2021-03-15 정태훈 생성
'####################################################
dim gnbflag

gnbflag = RequestCheckVar(request("gnbflag"),1)

If gnbflag = "1" Then '//gnb 숨김 여부
	gnbflag = true
	strHeadTitleName = ""
Else 
	gnbflag = False
	strHeadTitleName = "리뉴얼 설명서"
End if
%>
<script>
var isApp = false;
</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
    <!-- #include virtual="/lib/inc/incHeader.asp" -->
	<% server.Execute("/event/renewal/main_exec.asp") %>
	<!-- #include virtual="/lib/inc/incfooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" --> 