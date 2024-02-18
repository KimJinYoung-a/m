<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 가정의달 2020
' History : 2020-04-07 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
dim gnbflag : gnbflag = RequestCheckVar(request("gnbflag"),1)

If gnbflag <> "" Then '//gnb 숨김 여부
	gnbflag = true 
    strHeadTitleName = ""
Else 
	gnbflag = False
	strHeadTitleName = "가정의 달"
End if
%>
<script>
var isApp = false;
</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%> family2020">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
    <div id="content" class="content">
    <% server.Execute("/event/family2020/exc_main.asp") %>
    </div>
	<!-- #include virtual="/lib/inc/incfooter.asp" -->
</body>
</html>