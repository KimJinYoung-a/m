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
				<li class="giftTalk"><a href=""><span class="tabIco"></span>나의 톡<em></em></a></li>
				<li class="giftDay on"><a href=""><span class="tabIco"></span>나의 글<em></em></a></li>
			</ul>
			<div class="giftBrdHead">
				<p>작성하신 컨텐츠 내용을<br />수정 및 삭제하실 수 있습니다.</p>
				<a href="" class="goMyGift">GIFT DAY</a>
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
				<div class="giftDay">
					<div class="noGiftData"><span class="ico"></span>등록된 GIFT DAY가 없습니다.<br />주고 싶은 선물, 받고 싶은 선물 있다면 이벤트에 참여보세요!</div>
					<ul class="giftList">
						<!-- for dev msg : 주고싶은 선물 클래스명(giveGift) / 받고싶은 선물 클래스명(getGift) -->
						<li class="myBrdBox giveGift">
							<div class="giftBrdInfo">
								<div class="ftLt">
									<p class="cBk1"><strong>tenbyten***</strong></p>
									<p class="tPad05">10시간 전</p>
								</div>
								<div class="ftRt tPad05">
									<p class="view"><span>view</span> <em>9999</em></p>
									<p class="reply"><span>댓글</span> <em>999</em></p>
								</div>
							</div>
							<div class="giftBrdCont">
								<p class="dayFlag" onclick=""></p>
								<p class="myTxt"><a href="">주문했는데, 받침대랑 구성품확인 꼭!하시고 보내주세요. 선물할거라 구성품이 제대로 왔으면 좋겠네요 ㅠㅠ 금요일까지는 받을수있게 해주시고 수고하세요</a></p>
								<dl class="myTag">
									<dt>Tag</dt>
									<dd>
										<a href="#">MEN</a>, <a href="#">생일</a>, <a href="#">크리스마스</a>
									</dd>
								</dl>
							</div>
							<p class="pic">
								<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_600x600.png" alt="ascreem**님이 올린 쇼핑톡" style="width:100%;" /></a><!-- for dev msg : 상품명 alt 속성에 넣어주세요. -->
							</p>
							<div class="btnCont">
								<span class="btnModify">수정</span>
								<span class="bar">|</span>
								<span class="btnDelete">삭제</span>
							</div>
						</li>
						<li class="myBrdBox getGift">
							<div class="giftBrdInfo">
								<div class="ftLt">
									<p class="cBk1"><strong>tenbyten***</strong></p>
									<p class="tPad05">1시간 전</p>
								</div>
								<div class="ftRt tPad05">
									<p class="view"><span>view</span> <em>9999</em></p>
									<p class="reply"><span>댓글</span> <em>999</em></p>
								</div>
							</div>
							<div class="giftBrdCont">
								<p class="dayFlag" onclick=""></p>
								<p class="myTxt"><a href="">주문했는데, 받침대랑 구성품확인 꼭!하시고 보내주세요. 선물할거라 구성품이 제대로 왔으면 좋겠네요 ㅠㅠ 금요일까지는 받을수있게 해주시고 수고하세요</a></p>
								<dl class="myTag">
									<dt>Tag</dt>
									<dd>
										<a href="#">MEN</a>, <a href="#">생일</a>, <a href="#">크리스마스</a>
									</dd>
								</dl>
							</div>
							<p class="pic">
								<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_600x600.png" alt="ascreem**님이 올린 쇼핑톡" style="width:100%;" /></a>
							</p>
							<div class="btnCont">
								<span class="btnModify">수정</span>
								<span class="bar">|</span>
								<span class="btnDelete">삭제</span>
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
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>