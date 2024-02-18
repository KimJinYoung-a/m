<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<script>
$(function(){
	$('.mVIPGOLD .mGrade strong').text('VIP GOLD');
	$('.mVIPSILVER .mGrade strong').text('VIP SILVER');
	$('.mBLUE .mGrade strong').text('BLUE');
	$('.mGREEN .mGrade strong').text('GREEN');
	$('.mYELLOW .mGrade strong').text('YELLOW');
	$('.mORANGE .mGrade strong').text('ORANGE');
	$('.mSTAFF .mGrade strong').text('STAFF');
	$('.mFAMILY .mGrade strong').text('FAMILY');
	$('.mFRIENDS .mGrade strong').text('FRIENDS');

	$('.mVIPGOLD .g01').addClass('on').children('dd').slideDown();
	$('.mVIPSILVER .g02').addClass('on').children('dd').slideDown();
	$('.mBLUE .g03').addClass('on').children('dd').slideDown();
	$('.mGREEN .g04').addClass('on').children('dd').slideDown();
	$('.mYELLOW .g05').addClass('on').children('dd').slideDown();
	$('.mORANGE .g06').addClass('on').children('dd').slideDown();

	$('.gradeBenefit dt').click(function(){
		$('.gradeBenefit dd').slideUp();
		$(this).next('dd').slideDown();
		$('.gradeBenefit dt').removeClass('on');
		$(this).addClass('on');
	});
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="header">
			<h1>10X10 등급혜택</h1>
			<p class="btnPopClose"><button class="pButton" onclick="window.close();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<!-- 등급별로 클래스 mVIPGOLD/mVIPSILVER/mBLUE/mGREEN/mYELLOW/mORANGE/mSTAFF 넣어주세요 -->
			<div class="gradeBenefit mVIPGOLD">
				<p class="mGrade"><span><em class="cBk1">skyblue123</em>님은 <strong></strong>등급입니다.</span></p>
				<div class="inner5">
					<div class="box2">
						<dl class="g01">
							<dt class="mVIPGOLD">VIP GOLD</dt>
							<dd>
								<p class="tit">선정기준</p>
								<ul>
									<li>- 주문 12회 이상 또는  결제금액 100만원 이상</li>
								</ul>

								<p class="tit">등급혜택</p>
								<ul>
									<li>- 10% 쿠폰 2장</li>
									<li>- 3천원 쿠폰 2장</li>
									<li>- 1만원 쿠폰 1장 (10만원이상 구매 시)</li>
									<li>- 3개월 연속 VIP GOLD 유지 시 7천원 쿠폰 1장 (5만원이상 구매 시)</li>
									<li>- 텐바이텐 배송상품 무료배송</li>
									<li>- 우수회원샵 25% 할인</li>
									<li>- 히치하이커 무료지급 (신청기간 내 주소확인 시)</li>
									<li>- 핑거스아카데미 10% 쿠폰 1장</li>
								</ul>
							</dd>
						</dl>
						<dl class="g02">
							<dt class="mVIPSILVER">VIP SILVER</dt>
							<dd>
								<p class="tit">선정기준</p>
								<ul>
									<li>- 주문 6회 이상~12회 미만 또는 결제금액 50~100만원 미만</li>
								</ul>

								<p class="tit">등급혜택</p>
								<ul>
									<li>- 10% 쿠폰 1장</li>
									<li>- 3천원 쿠폰 2장</li>
									<li>- 무료배송쿠폰 3장 (텐바이텐 배송상품 구매 시)</li>
									<li>- 3개월 연속 VIP SILVER 유지 시 5천원 쿠폰 1장 (4만원이상 구매 시)</li>
									<li>- 텐바이텐 배송상품 1만원이상 무료배송</li>
									<li>- 우수회원샵 20% 할인</li>
									<li>- 히치하이커 무료지급 (신청기간 내 주소확인 시)</li>
									<li>- 핑거스아카데미 7% 쿠폰 1장</li>
								</ul>
							</dd>
						</dl>
						<dl class="g03">
							<dt class="mBLUE">BLUE</dt>
							<dd>
								<p class="tit">선정기준</p>
								<ul>
									<li>- 주문 4회 이상~6회 미만 또는 결제금액 30~50만원 미만</li>
								</ul>

								<p class="tit">등급혜택</p>
								<ul>
									<li>- 10% 쿠폰 1장</li>
									<li>- 무료배송쿠폰 2장 (텐바이텐 배송상품 1만원이상 구매 시)</li>
									<li>- 텐바이텐 배송상품 2만원이상 무료배송</li>
									<li>- 우수회원샵 15% 할인</li>
									<li>- 핑거스아카데미 5%쿠폰 1장</li>
								</ul>
							</dd>
						</dl>
						<dl class="g04">
							<dt class="mGREEN">GREEN</dt>
							<dd>
								<p class="tit">선정기준</p>
								<ul>
									<li>- 주문 1회 이상~4회 미만 또는 결제금액 10~30만원 미만</li>
								</ul>

								<p class="tit">등급혜택</p>
								<ul>
									<li>- 5% 쿠폰 2장</li>
									<li>- 무료배송쿠폰 1장 (텐바이텐 배송상품 2만원이상 구매 시)</li>
								</ul>
							</dd>
						</dl>
						<dl class="g05">
							<dt class="mYELLOW">YELLOW</dt>
							<dd>
								<p class="tit">선정기준</p>
								<ul>
									<li>- 5개월 이내 구매경험이 없는 고객</li>
								</ul>

								<p class="tit">등급혜택</p>
								<ul>
									<li>-  5% 쿠폰 1장</li>
									<li>- 무료배송쿠폰 1장 (텐바이텐 배송상품 2만원이상 구매 시)</li>
								</ul>
							</dd>
						</dl>
						<dl class="g06">
							<dt class="mORANGE">ORANGE</dt>
							<dd>
								<p class="tit">선정기준</p>
								<ul>
									<li>신규가입회원, 구매경험이 없는 고객</li>
								</ul>

								<p class="tit">등급혜택</p>
								<ul>
									<li> - 2천원 쿠폰 1장 (5만원이상 구매시)</li>
									<li>- 무료배송쿠폰 1장 (텐바이텐 배송상품 2만원이상 구매 시)</li>
								</ul>
							</dd>
						</dl>
					</div>
				</div>
				<div class="gradeTip">
					<h2>꼭 알아두세요!</h2>
					<ul>
						<li>최근 5개월간의 이용내역을 반영하여 매월 1일 새로운 회원등급이 부여됩니다.</li>
						<li>1만원 미만의 구매내역은 구매횟수로 계산되는 선정기준에서는 제외됩니다. (산정기준 = 실결제액 + 마일리지사용액 )</li>
						<li>무료배송 쿠폰은 텐바이텐 배송상품 구매 시 사용가능 합니다.</li>
					</ul>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>