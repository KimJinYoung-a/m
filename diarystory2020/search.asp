<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  다이어리스토리 2020
' History : 2019-04-10 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
    strHeadTitleName = "다이어리 검색"

    IF application("Svr_Info") <> "Dev" THEN
        If GetLoginUserLevel <> "7" Then
            Response.Redirect "/diarystory2021/"
        End If
    end if
%>
</head>
<body class="default-font body-sub diary2020">
    <!-- #include virtual="/lib/inc/incHeader.asp" -->	
<%
    server.Execute("/diarystory2020/inc/search/exec_search.asp")                    
%>	
    <!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>