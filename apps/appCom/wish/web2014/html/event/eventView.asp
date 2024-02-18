<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
</head>
<body>
<div class="heightGrid">
	<div class="container bgGry">
		<!-- content area -->
		<div class="content evtView" id="contentArea">
			<div class="evtViewHead">
				<h2>기본이 되는 가방</h2>
				<p class="date">2014.08.22 ~ 2014.09.30</p>
				<div class="btnWrap">
					<p class="circleBox evtShare"><span>공유</span></p>
					<p class="circleBox wishView wishActive"><span>찜하기</span></p><!-- for dev msg : 관심이벤트 등록시 클래스 wishActive -->
				</div>
			</div>
			<!-- 이벤트 배너 등록 영역 -->
			<div class="evtCont">
				<!-- 종료된 이벤트일 경우 <div class="finishEvt"><p>죄송합니다.<br />종료된 이벤트 입니다.</p></div>-->
				<div><img src="http://fiximage.10x10.co.kr/m/2014/temp/evt_bnr01.png" alt="" /></div>
				
			</div>
			<!--// 이벤트 배너 등록 영역 -->

			<!-- 상품리스트 (상품정렬방식에 따라 클래스 evtTypeA/evtTypeB/evtTypeC) -->
			<div class="inner10">
				<select class="groupBar">
					<option>ithinkso HOT ITEM 30%</option>
					<option>ithinkso NEW ITEM 30%</option>
				</select>
			</div>
			<div class="evtTypeA">
				<div class="evtPdtListWrap">
					<div class="pdtListWrap">
						<ul class="pdtList">
							<li onclick="">
								<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="" /></div><!-- for dev msg : 상품명 alt값 속성에 넣어주세요 -->
								<div class="pdtCont">
									<p class="pBrand">MINI BUS</p>
									<p class="pName">소니엔젤 아티스트 컬렉션</p>
									<p class="pPrice">8,000원 <span class="cRd1">[20%]</span></p>
								</div>
							</li>
							<li onclick="">
								<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" /></div>
								<div class="pdtCont">
									<p class="pBrand">MINI BUS</p>
									<p class="pName">소니엔젤 아티스트 컬렉션</p>
									<p class="pPrice">8,000원 <span class="cRd1">[20%]</span></p>
								</div>
							</li>
						</ul>
					</div>
				</div>
				<div class="evtPdtListWrap">
					<div class="pdtListWrap">
						<ul class="pdtList">
							<li onclick="">
								<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="" /></div>
								<div class="pdtCont">
									<p class="pBrand">MINI BUS</p>
									<p class="pName">소니엔젤 아티스트 컬렉션</p>
									<p class="pPrice">8,000원 <span class="cRd1">[20%]</span></p>
								</div>
							</li>
							<li onclick="" class="soldOut">
								<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" /></div>
								<div class="pdtCont">
									<p class="pBrand">MINI BUS</p>
									<p class="pName">소니엔젤 아티스트 컬렉션</p>
									<p class="pPrice">8,000원 <span class="cRd1">[20%]</span></p>
								</div>
							</li>
						</ul>
					</div>
				</div>
			</div>
			<div class="evtTypeB">
				<div class="evtPdtListWrap">
					<div class="pdtListWrap">
						<ul class="pdtList">
							<li onclick="">
								<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="" /></div><!-- for dev msg : 상품명 alt값 속성에 넣어주세요 -->
								<div class="pdtCont">
									<p class="pBrand">MINI BUS</p>
									<p class="pName">소니엔젤 아티스트 컬렉션</p>
									<p class="pPrice">8,000원 <span class="cRd1">[20%]</span></p>
								</div>
							</li>
							<li onclick="">
								<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" /></div>
								<div class="pdtCont">
									<p class="pBrand">MINI BUS</p>
									<p class="pName">소니엔젤 아티스트 컬렉션</p>
									<p class="pPrice">8,000원 <span class="cRd1">[20%]</span></p>
								</div>
							</li>
						</ul>
					</div>
				</div>
			</div>
			<div class="evtTypeC">
				<div class="evtPdtListWrap">
					<div class="pdtListWrap">
						<ul class="pdtList">
							<li onclick="">
								<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="" /></div><!-- for dev msg : 상품명 alt값 속성에 넣어주세요 -->
								<div class="pdtCont">
									<p class="pBrand">MINI BUS</p>
									<p class="pName">소니엔젤 아티스트 컬렉션</p>
									<p class="pPrice">8,000원 <span class="cRd1">[20%]</span></p>
								</div>
							</li>
							<li onclick="">
								<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" /></div>
								<div class="pdtCont">
									<p class="pBrand">MINI BUS</p>
									<p class="pName">소니엔젤 아티스트 컬렉션</p>
									<p class="pPrice">8,000원 <span class="cRd1">[20%]</span></p>
								</div>
							</li>
						</ul>
					</div>
				</div>
			</div>
			<!--// 상품리스트 -->

			<!-- 댓글 리스트 -->
			<div class="inner5">
				<div class="replyList box1">
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
					</ul>
					<div class="btnWrap ct tPad15">
						<span class="button btM2 btRed cWh1 w30p"><a href="#">쓰기</a></span>
						<span class="button btM2 btRedBdr cRd1 w30p"><a href="#">전체보기</a></span>
					</div>
				</div>
			</div>
			<!--// 댓글 리스트 -->

			<!-- EVENT & ISSUE -->
			<div class="inner5">
				<div class="evtnIsu box1">
					<h2><span>EVENT &amp; ISSUE</span></h2>
					<ul class="list01">
						<li><a href="">모노폴리 포켓 시리즈 출시! <span class="cRd1">20%</span></a></li>
						<li><a href="">아는 여자들은 다 아는 스타일 업 아이템!</a></li>
						<li><a href="">포켓의 발견, 미니멀 모음전! <span class="cRd1">62%</span></a></li>
					</ul>
				</div>
			</div>
			<!--// EVENT & ISSUE -->
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>