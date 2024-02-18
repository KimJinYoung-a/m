<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 히치하이커 메인 페이지
' History : 2021-01-12 임보라 생성
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
	strHeadTitleName = "히치하이커"
End if
%>
<link rel="stylesheet" type="text/css" href="/lib/css/hitchhiker.css?v=1.0">
</head>
<body>
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<% server.Execute("/hitchhiker/exc_main.asp") %>
</body>
</html>