<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
</head>
<body class="shop">
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content order fail" id="contentArea">

<!------- 2014 frame ------------->

        <!-- #header -->
        <header id="header">
            <h1 class="page-title">결제실패</h1>
        </header><!-- #header -->

        <!-- #content -->
        <div id="content">
            <form action="">
            <div class="inner">
                <div class="order-finish t-c">
                    <img src="../../img/img-sorry.png" alt="" style="width:50px">
                    <div class="diff-10"></div>
                    <p class="x-large quotation" style="width:180px;">
                        <strong><span class="red">결제실패</span> 하였습니다.</strong>
                    </p>
                    <p class="diff-10"></p>
                    <p class="small t-c">
                        실패 사유를 확인하신 후, 다시 결제해 주세요.
                    </p>
                </div>
                <div class="diff"></div>
                
                <div class="main-title">
                    <h1 class="title"><span class="label">결제정보 확인</span></h1>
                </div>
                <table class="plain">
                    <tr>
                        <th>실패사유</th>
                        <td>한도초과</td>
                    </tr>
                    <tr>
                        <th>주문번호</th>
                        <td>111111111111111</td>
                    </tr>
                    <tr>
                        <th>금액</th>
                        <td>25,6000원</td>
                    </tr>
                    <tr>
                        <th>결제</th>
                        <td>비씨카드</td>
                    </tr>
                    <tr>
                        <th>카드번호</th>
                        <td>1111-****-****-**11</td>
                    </tr>
                </table>
            </div>
            <div class="form-actions highlight">
                <button class="btn type-a full-size">다시 결제하기</button>
            </div>
            </form>
        </div><!-- #content -->

        <footer id="footer">
        </footer>


<!------- 2014 frame ------------->

		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>