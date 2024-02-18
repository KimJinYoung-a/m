<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : B2B 서머리 페이지
' History : 2021-07-01 김형태 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/head.asp" -->
<%
dim gnbflag
gnbflag = RequestCheckVar(request("gnbflag"),1)

If gnbflag <> "" Then '//gnb 숨김 여부
	gnbflag = true
Else
	gnbflag = False
	strHeadTitleName = "Biz Summary"
End if
%>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
    <% server.Execute("/biz/exc_summary.asp") %>
</body>
</html>