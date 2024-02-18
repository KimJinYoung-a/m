<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리 2021 사은품 안내
' History : 2020-09-02 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
dim gnbflag
gnbflag = RequestCheckVar(request("gnbflag"),1)

If gnbflag <> "" Then '//gnb 숨김 여부
	gnbflag = true 
Else 
	gnbflag = False
	strHeadTitleName = "다이어리 스토리"
End if
%>
</head>
<body class="default-font <%=chkiif(isapp,"","body-popup")%>">
<% server.Execute("/diarystory2021/inc/benefit/exec_benefit.asp") %>
<!-- #include virtual="/lib/inc/incfooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->