<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="location">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<em class="swiper-slide"><a href="">BRAND STREET</a></em>
						<em class="swiper-slide"><a href="">가</a></em>
					</div>
				</div>
			</div>

			<!-- Sorting -->
			<div class="sorting sortingBrand">
				<p class="all">
					<select class="selectBox" title="브랜드 정렬 선택 옵션">
						<option value="">가</option>
						<option value="">나</option>
						<option value="">다</option>
						<option value="">라</option>
					</select>
				</p>
				<p><span class="button ctgySort"><a href="">전체</a></span></p>
			</div>
			<!--// Sorting -->

			<div class="brandList">
				<!-- 브랜드 검색결과 없을경우 -->
				<div class="noBrandData" style="display:none;">
					<p class="result">선택하신 <span class="cRd1">브랜드 색인</span>에<br />브랜드가 없습니다.</p>
					<p class="fs11">브랜드명을 다시 확인하여 주시거나<br />검색으로 찾아주세요 :-)</p>
				</div>
				<!--// 브랜드 검색결과 없을경우 -->

				<!-- for dev msg : 클래스명 brand로 loop 돌려주세요. -->
				<div class="brand box1">
					<div class="info">
						<a href="">
							<em class="brandEng">AGUARD</em>
							<strong class="brandKor">아가드</strong>
						</a>
						<!-- for dev msg : 찜하면 클래스 on 넣어주세요 -->
						<button type="button" class="like on"><span>3571</span></button>
						<p class="pFlag">
							<span class="fgSale">SALE</span>
						</p>
					</div>
					<div class="goods">
						<ul>
							<!-- for dev msg : 이미지 alt값 상품명으로 넣어주세요 -->
							<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/@temp_img_140x140_01.jpg" alt="상품명" /></a></li>
							<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/@temp_img_140x140_02.jpg" alt="상품명" /></a></li>
							<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/@temp_img_140x140_03.jpg" alt="상품명" /></a></li>
							<li>
								<a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/@temp_img_140x140_04.jpg" alt="상품명" />
								<!-- for dev msg : 마지막 4번째 li에 상품갯수 부분 넣어주세요. -->
								<div class="count"><span><em>+ 124</em></span></div></a>
							</li>
						</ul>
					</div>
				</div>

				<div class="brand box1">
					<div class="info">
						<a href="">
							<em class="brandEng">AGOMALL</em>
							<strong class="brandKor">아고몰</strong>
						</a>
						<button type="button" class="like"><span>412</span></button>
						<p class="pFlag">
							<span class="fgNew">NEW</span>
						</p>
					</div>
					<div class="goods">
						<ul>
							<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/@temp_img_140x140_05.jpg" alt="상품명" /></a></li>
							<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/@temp_img_140x140_06.jpg" alt="상품명" /></a></li>
							<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/@temp_img_140x140_07.jpg" alt="상품명" /></a></li>
							<li>
								<a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/@temp_img_140x140_08.jpg" alt="상품명" />
									<div class="count"><span><em>+ 25</em></span></div>
								</a>
							</li>
						</ul>
					</div>
				</div>

				<div class="brand box1">
					<div class="info">
						<a href="">
							<em class="brandEng">AGIBUS</em>
							<strong class="brandKor">아기버스</strong>
						</a>
						<button type="button" class="like"><span>3571</span></button>
					</div>
					<div class="goods">
						<ul>
							<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/@temp_img_140x140_09.jpg" alt="상품명" /></a></li>
							<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/@temp_img_140x140_10.jpg" alt="상품명" /></a></li>
							<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/@temp_img_140x140_11.jpg" alt="상품명" /></a></li>
							<li>
								<a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/@temp_img_140x140_12.jpg" alt="상품명" />
									<div class="count"><span><em>+ 820</em></span></div>
								</a>
							</li>
						</ul>
					</div>
				</div>

				<div class="brand box1">
					<div class="info">
						<a href="">
							<em class="brandEng">Nanudesign</em>
							<strong class="brandKor">나누디자인 나누디자인 나누디자인</strong>
						</a>
						<button type="button" class="like"><span>2650</span></button>
					</div>
					<div class="goods">
						<ul>
							<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/@temp_img_140x140_01.jpg" alt="상품명" /></a></li>
							<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/@temp_img_140x140_02.jpg" alt="상품명" /></a></li>
							<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/@temp_img_140x140_03.jpg" alt="상품명" /></a></li>
							<li>
								<a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/@temp_img_140x140_04.jpg" alt="상품명" />
									<div class="count"><span><em>+ 820</em></span></div>
								</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>