<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  다이어리 스토리 다꾸채널 - 상세
' History : 2019-08-22 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/diarystory2020/lib/worker_only_view.asp" -->
<%
    dim gnbflag : gnbflag = RequestCheckVar(request("gnbflag"),1)
    strHeadTitleName = "다꾸TV"
%>
<!-- #include virtual="/lib/inc/head.asp" -->
</head>
<link rel="stylesheet" type="text/css" href="/lib/css/platform.css?v=2.00">
<link rel="stylesheet" type="text/css" href="/lib/css/diary2020.css?v=1.08" />
<body class="default-font body-sub diary2020">
<!-- #include virtual="/lib/inc/incHeader.asp" -->
<%
    server.Execute("/diarystory2020/daccutv_detail_exec.asp")
%>	
<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->