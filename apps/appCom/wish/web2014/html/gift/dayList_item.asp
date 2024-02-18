<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<script>
$(function(){
	$(".getGift .dayFlag").text("받고싶은 선물");
	$(".giveGift .dayFlag").text("주고싶은 선물");
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container bgGry">
		<!-- content area -->
		<div class="content" id="contentArea">
			<ul class="giftTab">
				<li class="giftTalk"><a href=""><span class="tabIco"></span>GIFT TALK<em></em></a></li>
				<li class="giftDay on"><a href=""><span class="tabIco"></span>GIFT DAY<em></em></a></li>
			</ul>
			<div class="giftBrdHead">
				<p>기프트데이 이벤트에 참여보세요!<br /><a href="" class="viewGuide" target="_blank">GIFT DAY 이용방법<span>&gt;</span></a></p>
				<a href="" class="goMyGift">나의 글</a>
			</div>
			<div class="tPad10">
				<div class="dayEvt"><img src="http://fiximage.10x10.co.kr/m/2013/gift/day_evt_bnr.png" alt="5월의 주제 - 로즈데이, 선물을 찾아라!" style="width:100%;" /><!-- dev for msg : 이벤트 등록 이미지 / alt값 해당 이벤트 내용 넣어주세요 --></div>
				<div class="dayHead">
					<ul class="btnCont">
						<li class="dList" onclick=""><p>리스트</p></li>
						<li class="dPdt on" onclick=""><p>추천상품</p></li>
					</ul>
					<select title="주제를 선택해주세요" class="ftRt w49p">
						<option>주제보기</option>
					</select>
				</div>
				<div class="inner10">
					<div class="overHidden">
						<select title="키워드를 선택해주세요" class="ftLt w49p">
							<option>키워드 검색</option>
						</select>
						<select title="정렬방법을 선택해주세요" class="ftRt w49p">
							<option>최근등록순</option>
						</select>
					</div>
					<div class="giftDay tMar10">
						<!-- 추천상품-->
						<div class="pdtListWrap">
							<ul class="pdtList">
								<li onclick="" class="soldOut">
									<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" /></div><!-- for dev msg : 상품명 alt값 속성에 넣어주세요 -->
									<div class="pdtCont">
										<p class="pBrand">MINI BUS</p>
										<p class="pName">소니엔젤 아티스트 컬렉션</p>
										<p class="pPrice">8,000원 <span class="cRd1">[20%]</span></p>
										<p class="pShare">
											<span class="cmtView">1,578</span>
											<span class="wishView" onclick="">2,045</span>
										</p>
									</div>
								</li>
								<li onclick="">
									<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" /></div>
									<div class="pdtCont">
										<p class="pBrand">PLAN D</p>
										<p class="pName">소니엔젤 아티스트 컬렉션-마가렛-Rabbitg</p>
										<p class="pPrice">8,000원 <span class="cGr1">[20%]</span></p>
										<p class="pShare">
											<span class="cmtView">11,000</span>
											<span class="wishView" onclick="">11,000</span>
										</p>
									</div>
								</li>
							</ul>
						</div>
						<!--// 추천상품 -->
					</div>
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
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>