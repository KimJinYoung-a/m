<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리 2020 메인페이지
' History : 2019-08-29 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/diarystory2020/lib/worker_only_view.asp" -->
<%
dim gnbflag
gnbflag = RequestCheckVar(request("gnbflag"),1)

IF application("Svr_Info") <> "Dev" THEN
    If GetLoginUserLevel <> "7" Then
        Response.Redirect "/diarystory2021/"
    End If
end if

If gnbflag <> "" Then '//gnb 숨김 여부
	gnbflag = true 
Else 
	gnbflag = False
	strHeadTitleName = "2020 다이어리"
End if
%>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
    <% server.Execute("/diarystory2020/inc/main/main_exec.asp") %>
	<!-- #include virtual="/lib/inc/incfooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->