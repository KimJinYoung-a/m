<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 애플전용관
' History : 2020-04-20 이종화 생성
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
	strHeadTitleName = "Apple"
End if
%>
<script>
var isApp = false;
</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
    <% server.Execute("/event/apple/exc_main.asp") %>
    </div>
	<!-- #include virtual="/lib/inc/incfooter.asp" -->
</body>
</html>