<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">

			<!-- wrapper -->
			<div class="wrapper">
				<!-- #content -->
				<div id="content">

            <div class="inner">
                <div class="diff"></div>
                <div class="main-title">
                    <h1 class="title"><span class="label">비회원 정보수집동의</span></h1>
                </div>
                <p>비회원으로 구매시, 다음 개인정보 수집 항목을 확인 후 동의하셔야 합니다. </p>
            </div>
            <div class="diff"></div>
            <div class="well type-b">
                <ol class="ol-list">
                    <li>
                        수집하는 개인정보 항목
                        <ul>
                            <li>e-mail, 전화번호, 성명, 주소, 은행계좌번호</li>
                        </ul>
                    </li>
                    <li>
                        수집 목적
                        <ol>
                            <li>e-mail, 전화번호: 고지의 전달. 불만처리나 주문/배송정보 안내 등  원활한 의사소통 경로의 확보.</li>
                            <li>성명, 주소: 고지의 전달, 청구서, 정확한 상품 배송지의 확보.</li>
                            <li>은행계좌번호: 구매상품에 대한 환불시 확보.</li>
                        </ol>
                    </li>
                    <li>
                        개인정보 보유기간
                        <ol>
                            <li>계약 또는 청약철회 등에 관한 기록 : 5년</li>
                            <li>대금결제 및 재화 등의 공급에 관한 기록 : 5년</li>
                            <li>소비자의 불만 또는 분쟁처리에 관한 기록 : 3년</li>
                        </ol>
                    </li>
                    <li>
                        비회원 주문 시 제공하신 모든 정보는 상기 목적에 필요한 용도 이외로는 사용되지않습니다. <br>기타 자세한 사항은 '개인정보취급방침'을 참고하여주시기 바랍니다.
                    </li>
                </ol>                
            </div>

            <div class="inner">
                <label for="agree">
                    <input type="checkbox" class="form" id="agree"> 동의
                </label>
            </div>

            <div class="form-actions highlight">
                <button class="btn type-b full-size">비회원구매</button>
            </div>

				</div><!-- #content -->
				
				<!-- #footer -->
				<footer id="footer">
				</footer><!-- #footer -->
			</div>
			<!-- wrapper -->

		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
<script>
$('.cart-box').each(function(){
		var box = $(this);
		$('.check-all input[type="checkbox"]', box).on('click', function(){
				if ( $(this).is(":checked") == true) {
						$('.product-in-cart .checker', box).attr('checked', true);
				} else {
						$('.product-in-cart .checker', box).attr('checked', false);
				}
		});
});

</script>
</body>
</html>