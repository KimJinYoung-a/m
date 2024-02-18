<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 개인정보 수집 이용안내
'	History	: 2014.01.08 한용민 생성
'           : 2014.02.05 허진원 APP용으로 디자인 변경 (웹뷰용: ajax_viewPrivateTerms.asp)
'#######################################################
%>
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
</head>
<body class="util">
    <div class="box">
        <div class="modal-body">
            <div class="inner doc" style="padding: 10px;">
				<!-- #include virtual="/apps/appCom/wish/webview/member/privateCont.asp" -->
            </div>
        </div>
    </div>

    <!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>