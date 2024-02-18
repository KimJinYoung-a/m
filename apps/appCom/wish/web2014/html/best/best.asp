<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
</head>
<body>
<div class="heightGrid">
	<div class="container bgGry">
		<!-- content area -->
		<div class="content bPad35" id="contentArea">
			<div class="bestMain inner5">
				<!-- 카테고리별 정렬 -->
				<div class="sorting cateBest">
					<p class="all">
						<select class="selectBox" title="카테고리 선택">
							<option value="">전체카테고리</option>
						</select>
					</p>
					<p><span class="button"><a href="">SELLER</a></span></p><!-- for dev msg : 클릭시 selected 클래스 붙여주세요 -->
					<p><span class="button"><a href="">NEW</a></span></p>
					<p><span class="button"><a href="">WISH</a></span></p>
				</div>
				<!--// 카테고리별 정렬 -->
				<!-- 타겟별 정렬 -->
				<div class="sorting tMar05">
					<p><span class="button"><a href="">나 혼자산다</a></span></p>
					<p><span class="button"><a href="">돌아온 슈퍼맘</a></span></p>
					<p><span class="button"><a href="">아임 젠틀맨이다</a></span></p>
				</div>
				<!--// 타겟별 정렬 -->

				<div class="box1 inner5">
					<div class="pdtListWrap">
						<ul class="pdtList">
							<li onclick="" class="soldOut top1">
								<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" /></div><!-- for dev msg : 상품명 alt값 속성에 넣어주세요 -->
								<div class="pdtCont">
									<p class="ranking">1</p>
									<p class="pBrand">MINI BUS</p>
									<p class="pName">소니엔젤 아티스트 컬렉션</p>
									<p class="pPrice">8,000원 <span class="cRd1">[20%]</span></p>
									<p class="pShare">
										<span class="cmtView">1,578</span>
										<span class="wishView" onclick="">2,045</span>
									</p>
								</div>
							</li>
							<li onclick="" class="top2">
								<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" /></div>
								<div class="pdtCont">
									<p class="ranking">2</p>
									<p class="pBrand">PLAN D</p>
									<p class="pName">소니엔젤 아티스트 컬렉션-마가렛-Rabbitg</p>
									<p class="pPrice">8,000원 <span class="cGr1">[20%]</span></p>
									<p class="pShare">
										<span class="cmtView">11,000</span>
										<span class="wishView" onclick="">11,000</span>
									</p>
								</div>
							</li>
							<li onclick="" class="top3">
								<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" /></div>
								<div class="pdtCont">
									<p class="ranking">3</p>
									<p class="pBrand">MINI BUS</p>
									<p class="pName">소니엔젤 아티스트 컬렉션-마가렛-Rabbit</p>
									<p class="pPrice">8,000원</p>
									<p class="pShare">
										<span class="cmtView">121,578</span>
										<span class="wishView" onclick="">45</span>
									</p>
								</div>
							</li>
							<li onclick="">
								<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" /></div>
								<div class="pdtCont">
									<p class="ranking">4</p>
									<p class="pBrand">MINI BUS</p>
									<p class="pName">소니엔젤 아티스트 컬렉션-마가렛-Rabbit</p>
									<p class="pPrice">8,000원 <span class="cRd1">[20%]</span></p>
									<p class="pShare">
										<span class="cmtView">3</span>
										<span class="wishView" onclick="">10</span>
									</p>
								</div>
							</li>
							<li onclick="">
								<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" /></div>
								<div class="pdtCont">
									<p class="ranking">5</p>
									<p class="pBrand">MINI BUS</p>
									<p class="pName">소니엔젤 아티스트 컬렉션-마가렛-Rabbit</p>
									<p class="pPrice">8,000원 <span class="cRd1">[20%]</span></p>
									<p class="pShare">
										<span class="cmtView">3</span>
										<span class="wishView" onclick="">10</span>
									</p>
								</div>
							</li>
							<li onclick="">
								<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" /></div>
								<div class="pdtCont">
									<p class="ranking">6</p>
									<p class="pBrand">MINI BUS</p>
									<p class="pName">소니엔젤 아티스트 컬렉션-마가렛-Rabbit</p>
									<p class="pPrice">8,000원 <span class="cRd1">[20%]</span></p>
									<p class="pShare">
										<span class="cmtView">3</span>
										<span class="wishView" onclick="">10</span>
									</p>
								</div>
							</li>
						</ul>
					</div>
					<div class="paging">
						<span class="arrow prevBtn"><a href="">prev</a></span>
						<span class="current"><a href="">1</a></span>
						<span><a href="">2</a></span>
						<span><a href="">3</a></span>
						<span><a href="">4</a></span>
						<span class="arrow nextBtn"><a href="">next</a></span>
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