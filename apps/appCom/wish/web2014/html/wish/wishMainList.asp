<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<script>
$(function() {
	var sortW = $(".wishMain .sorting").outerWidth();
	$(".wishMain .sorting").css("margin-left", -sortW/2 +'px');

//	var vSpos, vChk;
//	$(window).on({
//		'touchstart': function(e) {
//			vSpos = $(window).scrollTop()
//			vChk = false;
//		}, 'touchmove': function(e) {
//			if(vSpos!=$(window).scrollTop()) {
//				$('.wishMain .sorting').css('display','none');
//				vChk = true;
//			}
//		}, 'touchend': function(e) {
//			if(vChk) $('.wishMain .sorting').fadeIn("fast");
//		}
//	});
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container bgGry">
		<!-- content area -->
		<div class="content" id="contentArea" style="position:relative;">
			<div class="wishMain">
				<div class="sorting">
					<p class="selected"><span class="button"><a href="">트랜드</a></span></p><!-- for dev msg : 클릭시 selected 클래스 붙여주세요(작업시 퍼블리셔 문의) -->
					<p><span class="button"><a href="">팔로우</a></span></p>
					<p><span class="button"><a href="">메이트</a></span></p>
					<p><span class="button ctgySort"><a href="">카테고리</a></span></p>
				</div>

				<div class="wishListWrap">
					<ul class="wishList">
						<li>
							<div class="wishPdtImg">
								<a href="http://www.naver.com"><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" style="z-index:30;" /></a>
								<p class="cpnView cpnRed" onclick=""><!-- for dev msg : 쿠폰있는 경우 노출됩니다. -->
									<span class="cpnCont"><em>10% 할인 쿠폰</em></span>
									<span class="tPad05">2014.08.26 ~ 09.30</span>
								</p>
							</div>
							<div class="wishCont">
								<div class="posRel">
									<div class="wishPdtDesp">
										<p><strong>Table talk 데스크 트레이 입니다</strong></p>
										<p class="tPad05">26,000원 <span class="cRd1">[10%]</span></p>
									</div>
									<div class="circleBox wishProfile">
										<p onclick=""><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member07.png" alt="" /></p>
										<span class="mateView"><em>88</em></span><!-- for dev msg : 위시등록한 상품이 같은게 있는 경우 노출됩니다. -->
									</div>
									<p class="circleBox wishView wishActive" onclick=""><!-- for dev msg : 위시 등록됬을때 클래스 wishActive 붙여주세요 -->
										<span>156</span>
									</p>
								</div>
							</div>
						</li>
						<li>
							<div class="wishPdtImg">
								<a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="" /></a>
							</div>
							<div class="wishCont">
								<div class="posRel">
									<div class="wishPdtDesp">
										<p><strong>Table talk 데스크 트레이 입니다</strong></p>
										<p class="tPad05">26,000원</p>
									</div>
									<div class="circleBox wishProfile">
										<p onclick=""><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member22.png" alt="" /></p>
									</div>
									<p class="circleBox wishView" onclick="">
										<span>16</span>
									</p>
								</div>
							</div>
						</li>
						<li>
							<div class="wishPdtImg">
								<a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" /></a>
								<p class="cpnView cpnGrn" onclick="">
									<span class="cpnCont"><em>3,000원 할인 쿠폰</em></span>
									<span class="tPad05">2014.08.26 ~ 09.30</span>
								</p>
							</div>
							<div class="wishCont">
								<div class="posRel">
									<div class="wishPdtDesp">
										<p><strong>리니어 화장대</strong></p>
										<p class="tPad05">126,000원 <span class="cGr1">[3,000원]</span></p>
									</div>
									<div class="circleBox wishProfile">
										<p onclick=""><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member02.png" alt="" /></p>
										<span class="mateView"><em>2</em></span>
									</div>
									<p class="circleBox wishView" onclick="">
										<span>16</span>
									</p>
								</div>
							</div>
						</li>
						<li>
							<div class="wishPdtImg">
								<a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" /></a>
								<p class="cpnView cpnGry"><!-- for dev msg : 품절된 상품일 경우 노출됩니다. -->
									<span class="cpnCont">품절</span>
								</p>
							</div>
							<div class="wishCont">
								<div class="posRel">
									<div class="wishPdtDesp">
										<p><strong>MONEY MATE</strong></p>
										<p class="tPad05">126,000원</p>
									</div>
									<div class="circleBox wishProfile">
										<p onclick=""><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member10.png" alt="" /></p>
										<span class="mateView"><em>22</em></span>
									</div>
									<p class="circleBox wishView" onclick="">
										<span>1,616</span>
									</p>
								</div>
							</div>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>