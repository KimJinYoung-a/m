<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 회원가입
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim txUserId, evtFlag
	evtFlag = requestCheckVar(Request("eFlg"),1)
	txUserId = session("sUserid")
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script type='text/javascript'>

<% if evtFlag="C" then %>
	//alert('회원가입 이벤트 쿠폰이 발행 되었습니다.');
<% end if %>

</script>

</head>
<body class="util">
    <!-- wrapper -->
    <div class="wrapper">
        <!-- #header -->
        <header id="header">
            <h1 class="page-title">회원가입</h1>
            <ul class="process clear">
                <li><span class="label">약관동의</span></li>
                <li><span class="label">정보입력</span></li>
                <li><span class="label">본인인증</span></li>
                <li class="active"><span class="label">가입완료</span></li>
            </ul>
        </header><!-- #header -->

        <!-- #content -->
        <div id="content">
            <div class="inner">
                <div class="welcome t-c">
                    <strong><span class="red"><%=txUserId%></span>님<br>텐바이텐의 가족이 되신 것을 <br>진심으로 환영합니다 !</strong>
                    <div class="diff"></div>
                    <img src="/apps/appcom/wish/webview/img/txt-welcome.png" alt="" width="190">
                    <img src="/apps/appcom/wish/webview/img/btn-welcome.png" alt="텐바이텐 첫화면 바로가기" width="258" onclick="return callmain();">
                    <div class="diff"></div>
                    <p>
                        텐바이텐만의 감성 디자인 상품과 다양하고 특별한<br>혜택을 즐겁게 누리시길 바랍니다. 
                    </p>

                </div>
                
            </div>
        </div><!-- #content -->

        <!-- #footer -->
        <footer id="footer">
            
        </footer><!-- #footer -->
    </div><!-- wrapper -->
	<!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->