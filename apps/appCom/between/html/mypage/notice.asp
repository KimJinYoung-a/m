<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script type="text/javascript">
$(function() {
	$(".noticeHead").click(function() {
		if($(this).next("div").is(":visible")){
			$(this).next("div").slideUp(300);
			$(this).removeClass('current');
		} else {
			$(this).addClass('current');
			$(".noticeView").slideUp(300);
			$(this).next("div").slideToggle(300);
			$(this).addClass('current');
		}
	});
});
</script>
</head>
<body>
<div class="wrapper" id="btwMypage"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="hWrap hrBlk">
				<h1 class="headingA">공지사항</h1>
			</div>
			<ul class="notice">
				<li>
					<p class="noticeHead"><em>선물하기 점검 관련 안내</em> <span class="date">07/02</span><span class="newIco saleRed">N<span></p>
					<div class="noticeView">
						안녕하세요 비트윈 선물하기 이용자 여러분, 더 나은 서비스 제공을 위해 수요일 새벽(27일) 선물하기 서비스 점검이 진행될 예정입니다. 아래의 점검시간동안에는 선물하기 서비스를 이용하실 수 없습니다.<br />점검시간:7월27일 05:30~06:00<br />
						<img src="http://fiximage.10x10.co.kr/m/webview/between/main/bnr_user01.png" alt="" />
					</div>
				</li>
				<li>
					<p class="noticeHead"><em>비트윈 선물하기 오픈기념 이벤트</em> <span class="date">07/02</span></p>
					<div class="noticeView">안녕하세요 비트윈 선물하기 이용자 여러분, 더 나은 서비스 제공을 위해 수요일 새벽(27일) 선물하기 서비스 점검이 진행될 예정입니다. 아래의 점검시간동안에는 선물하기 서비스를 이용하실 수 없습니다.</div>
				</li>
				<li>
					<p class="noticeHead"><em>비트윈 선물하기 오픈기념 이벤트 당첨자 발표 비트윈 선물하기 오픈기념 긴긴제목 두줄까지...</em><span class="date">07/02</span></p>
					<div class="noticeView">안녕하세요 비트윈 선물하기 이용자 여러분, 더 나은 서비스 제공을 위해 수요일 새벽(27일) 선물하기 서비스 점검이 진행될 예정입니다. 아래의 점검시간동안에는 선물하기 서비스를 이용하실 수 없습니다.</div>
				</li>
				<li>
					<p class="noticeHead"><em>비트윈 선물하기 오픈기념 이벤트</em> <span class="date">07/02</span></p>
					<div class="noticeView">안녕하세요 비트윈 선물하기 이용자 여러분, 더 나은 서비스 제공을 위해 수요일 새벽(27일) 선물하기 서비스 점검이 진행될 예정입니다. 아래의 점검시간동안에는 선물하기 서비스를 이용하실 수 없습니다.</div>
				</li>
				<li>
					<p class="noticeHead"><em>비트윈 선물하기 오픈기념 이벤트</em> <span class="date">07/02</span></p>
					<div class="noticeView">안녕하세요 비트윈 선물하기 이용자 여러분, 더 나은 서비스 제공을 위해 수요일 새벽(27일) 선물하기 서비스 점검이 진행될 예정입니다. 아래의 점검시간동안에는 선물하기 서비스를 이용하실 수 없습니다.</div>
				</li>
			</ul>
			<div class="listAddBtn">
				<a href="">공지사항 더 보기</a>
			</div>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>