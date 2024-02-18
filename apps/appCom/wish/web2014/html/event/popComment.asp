<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container popWin">
		<div class="header">
			<h1>코멘트</h1>
			<p class="btnPopClose"><button class="pButton" onclick="#">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<!-- 코멘트(탭 형식으로 on/off 됩니다) -->
			<div class="inner5 tMar15 cmtCont">
				<!-- 쓰기 -->
				<div class="tab01 noMove">
					<ul class="tabNav tNum2">
						<li class="current"><a href="#cmtWrite">쓰기<span></span></a></li>
						<li><a href="#cmtView">전체보기<span></span></a></li>
					</ul>
					<div class="tabContainer box1">
						<div id="cmtWrite" class="tabContent">
							<textarea cols="30" rows="5">코멘트를 남겨주세요</textarea>
							<p class="tip">통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며, 이벤트 참여에 제한을 받을 수 있습니다.</p>
							<span class="button btB1 btRed cWh1 w100p"><input type="submit" value="등록" /></span>
						</div>
					</div>
				</div>
				<!--// 쓰기 -->

				<!-- 전체보기 -->
				<div class="tab01 noMove">
					<ul class="tabNav tNum2">
						<li><a href="#cmtWrite">쓰기<span></span></a></li>
						<li class="current"><a href="#cmtView">전체보기<span></span></a></li>
					</ul>
					<div class="tabContainer box1">
						<div id="cmtView" class="tabContent">
							<div class="replyList">
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
													<!--
													<span><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge04.png" alt="포토 코멘터" /></span>
													<span><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge05.png" alt="브랜드 쿨" /></span>
													<span><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge06.png" alt="얼리버드" /></span>
													<span><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge07.png" alt="세일헌터" /></span>
													<span><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge08.png" alt="스타일리스트" /></span>
													<span><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge09.png" alt="컬러홀릭" /></span>
													<span><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge10.png" alt="텐텐 트윅스" /></span>
													<span><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge11.png" alt="카테고리 마스터" /></span>
													<span><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge12.png" alt="톡 엔젤" /></span>
													-->
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
									<li>
										<p class="num">13</p>
										<div class="replyCont">
											<p>맙소사</p>
											<div class="writerInfo">
												<p>2014.08.05 <span class="bar">/</span> tenbyten123</p>
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
						</div>
					</div>
				</div>
				<!--// 전체보기 -->
			</div>
			<!--// 코멘트 -->
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>