<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
</head>
<body class="shop">
<div class="heightGrid">
	<div class="container popWin">
		<!-- content area -->
		<div class="content order" id="contentArea" style="padding-bottom:50px;">

<!------- 2014 frame ------------->


            <header class="header">
                <h1 class="page-title">주문제작 문구수정</h1>
                <p class="btnPopClose"><button class="pButton" onclick="#">닫기</button></p>
            </header>

            <div class="modal-body">
                <p class="well type-b">같은 상품을 2개 이상 주문하시고 문구를 다르게 하실 경우, 반드시 각각의 문구를 작성해주시기 바랍니다.</p>
                <div class="gutter">
                    <textarea name="customMessage" id="" cols="30" rows="10" class="form bordered  full-size"></textarea>      
                </div>

            </div>
            <footer class="modal-footer" style="padding-left:10px; padding-right:10px;">
                <div class="two-btns">
                    <div class="col"><button class="btn type-b">수정</button></div>
                    <div class="col"><a href="#modalWriteCustomMessage" class="btn type-a full-size">취소</a></div>
                </div>
            </footer>


<!------- 2014 frame ------------->

		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>