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
						<h1 class="title"><span class="label">나의 찜 브랜드</span></h1>
					</div>
				</div>
				<div class="inner">
				<!-- category -->
				<div class="two-inputs">
					<div class="col rPad05">
						<button class="btn type-b-arrow w100p" onclick="">전체</button>
					</div>
					<div class="col lPad05">
						<button class="btn type-b-arrow w100p" onclick="">최근등록순</button>
					</div>
				</div><!-- category -->

				<div class="clear diff-10"></div>

				<!-- product-list -->
				<ul class="product-list list-type-1">
					<li>
						<div class="product">
							<div class="product-img">
								<img src="../../img/_dummy-264x264.png" alt="" width="132" height="132">
							</div>
							<div class="product-spec t-c">
								<p class="fs11">LINGO BAND</p>
								<p class="fs15 cBk1">링고밴드</p>
								<div class="product-meta inner5">
									<button class="btn type-e small w80p">찜브랜드 삭제</button>
								</div>
							</div>
							<div class="clear"></div>
						</div>
					</li>
					<li>
						<div class="product">
							<div class="product-img">
								<img src="../../img/_dummy-264x264.png" alt="" width="132" height="132">
							</div>
							<div class="product-spec t-c">
								<p class="fs11">matha in the garret</p>
								<p class="fs15 cBk1">마사인더가렛</p>
								<div class="product-meta inner5">
									<button class="btn type-e small w80p">찜브랜드 삭제</button>
								</div>
							</div>
							<div class="clear"></div>
						</div>
					</li>
				</ul>
				<div class="clear diff-10"></div>
				<!-- 찜브랜드 없을 경우 -->
				<div class="no-item-message t-c">
					<p class="diff-10"></p>
					<img src="../../img/img-sad.png" alt="" style="width:50px;">
					<p class="diff-10"></p>
					<p class="x-large quotation" style="width:164px;">
						<strong>등록하신<br /><span class="red">찜브랜드가 없습니다.</span></strong>
					</p>
				</div>
				<!--// 찜브랜드 없을 경우 -->

				<!-- product-list -->

				<div class="clear"></div>
			</div>
			</div><!-- #content -->
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>