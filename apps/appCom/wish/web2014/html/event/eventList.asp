<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
</head>
<body>
<div class="heightGrid">
	<div class="container bgGry">
		<!-- content area -->
		<div class="content evtMain" id="contentArea">
			<div class="inner5">
				<div class="sorting">
					<p><span class="button ctgySort"><a href="">카테고리</a></span></p>
					<p><span class="button"><a href="">신규순</a></span></p><!-- for dev msg : 클릭시 selected 클래스 붙여주세요 -->
					<p class="selected"><span class="button"><a href="">인기순</a></span></p>
					<p><span class="button myEvt"><a href=""><em>MY</em></a></span></p>
				</div>
			
				<!-- 이벤트 없을 경우 -->
				<div class="noData" style="display:none">
					<p>진행중인 이벤트가 없습니다.</p>
					<!-- 관심이벤트 없을 경우<p>등록된 이벤트가 없습니다.</p> -->
				</div>
				<ul class="evtList">
					<li onclick="">
						<div class="pic"><img src="http://fiximage.10x10.co.kr/m/2014/temp/evt_bnr01.png" alt="" /></div>
						<dl>
							<dt>
								책가방 속 동화 이야기 
								<span class="cRd1">30%~</span>
								<!-- for dev msg : 이벤트 타입은 세일/할인/GIFT/참여/한정/1+1 의 우선순위로 한개씩만 노출됩니다.
								<span class="cRd1">30%~</span>
								<span class="cGr1">30%~</span>
								<span class="cGr2">GIFT</span>
								<span class="cBl2">참여</span>
								<span class="cBl3">한정</span>
								<span class="cGr2">1+1</span>
								 -->
							</dt>
							<dd>텐바이텐에서만 만날 수 있는 월간 오롯이</dd>
						</dl>
					</li>
					<li onclick="">
						<div class="pic"><img src="http://fiximage.10x10.co.kr/m/2014/temp/evt_bnr02.png" alt="" /></div>
						<dl>
							<dt>책가방 속 동화 이야기 <span class="cGr1">99%~</span></dt>
							<dd>텐바이텐에서만 만날 수 있는 월간 오롯이</dd>
						</dl>
					</li>
					<li onclick="">
						<div class="pic"><img src="http://fiximage.10x10.co.kr/m/2014/temp/evt_bnr01.png" alt="" /></div>
						<dl>
							<dt>책가방 속 동화 이야기 <span class="cGr2">1+1</span></dt>
							<dd>텐바이텐에서만 만날 수 있는 월간 오롯이</dd>
						</dl>
					</li>
					<li onclick="">
						<div class="pic"><img src="http://fiximage.10x10.co.kr/m/2014/temp/evt_bnr02.png" alt="" /></div>
						<dl>
							<dt>책가방 속 동화 이야기 <span class="cGr2">GIFT</span></dt>
							<dd>텐바이텐에서만 만날 수 있는 월간 오롯이</dd>
						</dl>
					</li>
				</ul>
			</div>
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>