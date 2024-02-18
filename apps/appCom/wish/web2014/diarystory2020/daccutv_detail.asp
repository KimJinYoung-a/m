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
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/diarystory2020/lib/worker_only_view.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
</head>
<link rel="stylesheet" type="text/css" href="/lib/css/platform.css?v=2.00">
<link rel="stylesheet" type="text/css" href="/lib/css/diary2020.css?v=1.07" />
<body class="default-font body-sub diary2020">
<%
    server.Execute("/diarystory2020/daccutv_detail_exec.asp")
%>			
<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->