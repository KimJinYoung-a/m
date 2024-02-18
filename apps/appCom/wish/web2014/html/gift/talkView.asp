<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<script>
$(function(){
	$('.selectAB .item .pic:nth-child(1)').prepend('<span class="label">A</span>');
	$('.selectAB .item .pic:nth-child(2)').prepend('<span class="label">B</span>');
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container bgGry">
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="prevPage">
				<a href="javascript:history.back();"><em class="icoPrev">이전으로</em></a>
			</div>
			<div class="inner10">
				<div class="giftTalk">
					<div class="giftView">
						<div class="myBrdBox">
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
								<p class="myTxt"><a href="">주문했는데, 받침대랑 구성품확인 꼭!하시고 보내주세요. 선물할거라 구성품이 제대로 왔으면 좋겠네요 ㅠㅠ 금요일까지는 받을수있게 해주시고 수고하세요</a></p>
								<dl class="myTag">
									<dt>Tag</dt>
									<dd>
										<a href="#">MEN</a>, <a href="#">생일</a>, <a href="#">크리스마스</a>
									</dd>
								</dl>
							</div>
							<!-- for dev msg : A,B 선택해야하는 경우 (.selectAB) -->
							<div class="selectAB">
								<div class="item">
									<p class="pic">
										<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_600x600.jpg" alt="ascreem**님이 올린 쇼핑톡" style="width:100%;" /></a>
									</p>
									<p class="pic">
										<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_600x600.png" alt="ascreem**님이 올린 쇼핑톡" style="width:100%;" /></a>
									</p>
									<div class="voteArea">
										<div class="btWrap"><p class="vote" onclick=""><span><strong>A</strong> 선택</span> <em class="num">100</em></p></div>
										<div class="btWrap"><p class="vote" onclick=""><span><strong>B</strong> 선택</span> <em class="num">100</em></p></div>
									</div>
								</div>
							</div>
							<!--// for dev msg : A,B 선택해야하는 경우 (.selectAB) -->

							<!-- for dev msg : 찬성,반대 선택의 경우 (.selectYN) -->
							<div class="selectYN" >
								<div class="item">
									<p class="pic">
										<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_600x600.png" alt="ascreem**님이 올린 쇼핑톡" style="width:100%;" /></a><!-- for dev msg : 상품명 alt 속성에 넣어주세요. -->
									</p>
									<div class="voteArea">
										<div class="btWrap"><p class="vote" onclick=""><span>찬성</span> <em class="num">100</em></p></div>
										<div class="btWrap"><p class="vote" onclick=""><span>반대</span> <em class="num">9999</em></p></div>
									</div>
								</div>
							</div>
							<!-- for dev msg : 찬성,반대 선택의 경우 (.selectYN) -->
						</div>
						<div class="talkCmt">
							<textarea cols="36" rows="5" class="writeFrm">최대 500자 입력가능(주제와 적합하지 않은 의견은 삭제될 수 있습니다)</textarea>
							<p class="txtLimit"><span>0</span>/500자</p>
						</div>
						<div class="ct tPad05">
							<span class="button btM1 btRed cWh1"><a href="#">등록</a></span>
						</div>
						<div class="noData tMar25">
							<p class="box1">등록된 쇼핑톡 의견이 없습니다.</p>
						</div>
						<!-- 코멘트 -->
						<div class="replyList box1 tMar25">
							<p class="total">총 <em class="cRd1">15</em>개의 댓글이 있습니다.</p>
							<ul>
								<li>
									<p class="num">15<span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성" /></span></p>
									<div class="replyCont">
										<p>어머! 이렇게 유쾌한 광고라니! 정말 찾던 테이블이네요. 집에서도 어디로 여행을 떠날 수 있을 것 같아요!</p>
										<p class="tPad05">
											<span class="button btS1 btWht cBk1"><a href="#">수정</a></span>
											<span class="button btS1 btWht cBk1"><a href="#">삭제</a></span>
										</p>
										<div class="writerInfo">
											<p>2014.08.05 <span class="bar">/</span> tenbyten123</p>
											<p class="badge">
												<span><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge01.png" alt="슈퍼 코멘터" /></span>
												<span><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge02.png" alt="기프트 초이스" /></span>
												<span><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge03.png" alt="위시 메이커" /></span>
											</p>
										</div>
									</div>
								</li>
								<li>
									<p class="num">14</p>
									<div class="replyCont">
										<p>어머! 이렇게 유쾌한 광고라니! 정말 찾던 테이블이네요. 집에서도 어디로 여행을 떠날 수 있을 것 같아요!</p>
										<div class="writerInfo">
											<p>2014.08.05 <span class="bar">/</span> tenbyten123</p>
											<p class="badge">
												<span><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge10.png" alt="텐텐 트윅스" /></span>
												<span><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge11.png" alt="카테고리 마스터" /></span>
											</p>
										</div>
									</div>
								</li>
							</ul>
							<div class="paging">
								<span class="arrow prevBtn"><a href="">prev</a></span>
								<span class="current"><a href="">1</a></span>
								<span><a href="">2</a></span>
								<span><a href="">3</a></span>
								<span><a href="">4</a></span>
								<span class="arrow nextBtn"><a href="">next</a></span>
							</div>
						</div>
						<!--// 코멘트 -->
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