<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'##################################################################	
' today main 
' 2014-06-11 이종화
'##################################################################
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script src="/lib/js/swiper-2.1.min.js"></script>
</head>
<script>
$(function() {
	mySwiper1 = new Swiper('.swiper1',{
		pagination:'.paging1',
		paginationClickable:true,
		loop:true,
		resizeReInit:true,
		calculateHeight:true
	});

	mySwiper2= new Swiper('.swiper2',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		speed:200
	});
	$('.goodsSwiper .arrow-left').on('click', function(e){
		e.preventDefault()
		mySwiper2.swipePrev()
	})
	$('.goodsSwiper .arrow-right').on('click', function(e){
		e.preventDefault()
		mySwiper2.swipeNext()
	})
	//gnb셋팅
	seltopmenu('today');

	//하단 Top버튼 컨트롤
	$('.btn-top').hide();
	$(window).scroll(function(){
		var vSpos = $(window).scrollTop();
		var docuH = $(document).height() - $(window).height();
		if (vSpos > 10){
			$('.btn-top').show();
		} else {
			$('.btn-top').hide();
		}
	});

	// TODAY DEAL Tag 위치값 계산
	var tagW = $('.todayWrap .tag').outerWidth();
	$('.todayWrap .tag').css('margin-left', -tagW/2+'px');

});
</script>
<body class="today">
	<!-- wrapper -->
	<div class="wrapper">
		<!-- #content -->
		<div id="content">
			<h1>TODAY</h1>
			<!-- 0:상단배너 -->
			<p class="mainBigIssue">
				<% server.Execute("/chtml/main/loader/mainXMLBanner_2039.asp") %>
			</p>
			<!-- //0:상단배너 -->

			<!-- 1:일반 멀티 배너(swiper slide) -->
			<div class="mainMulti">
				<% server.Execute("/chtml/main/loader/mainXMLBanner_2040.asp") %>
			</div>
			<!-- //1:일반 멀티 배너(swiper slide) -->

			<!-- 2:JUST 1DAY -->
			<div class="mainJustDay">
				<% server.Execute("/chtml/main/loader/app_main_just1day.asp") %>
			</div>
			<!-- //2:JUST 1DAY -->

			<!-- 3:TODAY WISH -->
			<div class="todayWish">
				<h2>TODAY WISH</h2>
				<span class="more"><a href="javascript:callmain();">WISH 메인 페이지로 이동</a></span>
				<% server.Execute("/chtml/main/loader/app_main_todaywish.asp") %>
			</div>
			<!-- 3:TODAY WISH -->

			<!-- 4:텍스트 배너 -->
			<p class="mainTxtBnr"><a href="/apps/appcom/wish/webview/event/eventmain.asp?eventid=52674"><img src="http://fiximage.10x10.co.kr/m/2013/today/today_txt_bnr01.png" alt="You're already different" /></a></p>
			<!-- //4:텍스트 배너 -->

			<!-- 5:TODAY DEAL -->
			<div class="todayDeal">
				<% server.Execute("/chtml/main/loader/app_main_todaydeal.asp") %>
			</div>
			<!-- 5:TODAY DEAL -->

			<!-- 6:ENJOY EVENT -->
			<div class="enjoyEvent">
				<h2>ENJOY EVENT</h2>
				<span class="more"><a href="javascript:callevent();">EVENT 메인 페이지로 이동</a></span>
				<% server.Execute("/chtml/main/loader/app_main_todayenjoy.asp") %>
			</div>
			<!-- 6:ENJOY EVENT -->

			<!-- 7:MD'S PICK -->
			<div class="mdPick">
				<h2>MD'S PICK</h2>
				<% server.Execute("/chtml/main/loader/app_main_mdpick.asp") %>
			</div>
			<!-- 7:MD'S PICK -->
		</div>
		<!-- #content -->

		<!-- #footer -->
		<footer id="footer">
			<a href="#" class="btn-top">top</a>
		</footer><!-- #footer -->

	</div>
	<!-- //wrapper -->

	<!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>