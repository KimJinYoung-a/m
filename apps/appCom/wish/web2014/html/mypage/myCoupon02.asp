<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content mypage" id="contentArea">
			<!-- #content -->
			<div id="content">
				<div class="inner">
					<div class="diff"></div>
					<div class="main-title">
						<h1 class="title"><span class="label">쿠폰</span></h1>
					</div>
				</div>
				<div class="well type-b type-cp">
					<ul class="txt-list">
						<li>오프라인 및 텐바이텐 제휴사에서 받은 쿠폰번호를 입력하시면 사용쿠폰을 알려드립니다.</li>
						<li>쿠폰 사용기준과 기간을 반드시 확인하여 주세요. (사용된 쿠폰은 주문 취소 후 재발급 불가)</li>
					</ul>
					<a href="" class="btn-down-all"><span>쿠폰<br>발급받기</span></a>
				</div>
				<div class="diff"></div>
				<div class="inner">
					<div class="tabs type-c three">
						<a href="">상품쿠폰 (1)</a>
						<a href="" class="active">보너스쿠폰 (2)</a>
						<a href="">모바일쿠폰 (2)</a>
					</div>
					<div class="diff"></div>
					<!-- 쿠폰 없을경우
					<div class="coupon-list">
						<p class="t-c" style="padding:30px 0">사용가능한 보너스쿠폰이 없습니다.</p>
					</div>
					 -->
					<ul class="coupon-list">
						<li class="coupon-box">
							<div class="gutter">
								<p class="amount">
									<strong>2,000</strong><span class="unit">원</span>
								</p>
								<p class="desc">
									오렌지 회원 2,000원 할인 쿠폰
								</p>
								<p class="period">
									유효기간 : 2013.11.01 ~ 2013.12.01
								</p>
							</div>
							<div class="condition">
								사용조건 : 50,000원 이상 구매시
							</div>
						</li>
						<li class="coupon-box">
							<div class="gutter">
								<p class="amount">
									<strong>무료배송</strong>
								</p>
								<p class="desc">
									무료 배송쿠폰 (2만원 이상 구매시)
								</p>
								<p class="period">
									유효기간 : 2013.11.01 ~ 2013.12.01
								</p>
							</div>
							<div class="condition">
								사용조건 : 텐바이텐 배송 상품금액 20,000원 이상 구매시
							</div>
						</li>
					</ul>
				</div>
			</div><!-- #content -->
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>