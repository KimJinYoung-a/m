<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 클리어런스 상품 상세
' History : 2020-10-23 이종화 생성
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
	strHeadTitleName = "클리어런스 상품 상세"
End if
%>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
    <% server.Execute("/list/clearance/exc_clearance_detail.asp") %>
</body>
</html>