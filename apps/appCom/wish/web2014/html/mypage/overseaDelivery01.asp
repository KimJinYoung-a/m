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
						<h1 class="title"><span class="label">주문 / 배송조회</span></h1>
					</div>
				</div>
				<div class="well type-b">
					<ul class="txt-list">
						<li>최근 2개월간 고객님의 주문내역입니다. 주문번호를 탭하시면 상세조회를 하실 수 있습니다.</li>
						<li>2개월 이전 내역 조회는 PC용 사이트에서 이용하실 수 있습니다. </li>
					</ul>
				</div>
				<div class="diff"></div>
				<div class="inner">
					<div class="tabs type-c three lines">
						<a href="">일반주문<br>(0)</a>
						<a href="" class="active">해외배송 주문조회<br>(2)</a>
						<a href="">취소 주문조회<br>(3)</a>
						<div class="clear"></div>
					</div>
					<div class="diff"></div>
					<ul class="order-list">
						<li class="bordered-box">
							<a href="#" class="box-meta">
								<span class="date">2013.12.12</span>
								<span class="box-title">주문번호(1234123)</span>
							</a>
							<div class="product-info gutter">
								<strong class="order-status red pull-left">주문접수</strong>
								<button class="btn type-a small pull-right">주문취소</button>
								<div class="clear"></div>
								<div class="product-spec">
									<p class="product-brand">[A.MONO FURNITURE STUDIO STUDIO] </p>
									<p class="product-name">처칠머그컵(런던트레블, 크라운실루엣 중 택1) 처칠..</p>
									<p class="product-option">옵션 : gray</p>
								</div>
								<div class="price">
									<strong>23,000</strong>원 / 수량 <strong>1</strong>개
								</div>
							</div>
						</li>
						<li class="bordered-box">
							<a href="#" class="box-meta">
								<span class="date">2013.12.12</span>
								<span class="box-title">주문번호(1234123)</span>
							</a>
							<div class="product-info gutter">
								<strong class="order-status red pull-left">배송중</strong>
								<button class="btn type-b small pull-right">배송조회</button>
								<div class="clear"></div>                        
								<div class="product-spec">
									<p class="product-brand">[A.MONO FURNITURE STUDIO STUDIO] </p>
									<p class="product-name">처칠머그컵(런던트레블, 크라운실루엣 중 택1) 처칠..</p>
									<p class="product-option">옵션 : gray</p>
								</div>
								<div class="price">
									<strong>23,000</strong>원 / 수량 <strong>1</strong>개
								</div>
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