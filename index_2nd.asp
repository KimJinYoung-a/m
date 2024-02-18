<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
'###########################################################
' Description :  Today Main (index)
' History : 2015-09-17 이종화 생성 - 모바일
'###########################################################
	'//요일
	Dim weekDate : weekDate = weekDayName(weekDay(now))

dim currenttime
currenttime = now()

Response.end
%>
<title>10x10</title>
<link rel="stylesheet" type="text/css" href="/lib/css/newV15a.css" />
<style type="text/css">
/* Layer Popup */
.window {display:none;}
#mask {display:none; position:absolute; left:0; top:0; z-index:9000; background-color:#000; opacity:0.5;}
.lyAppdown {position:absolute; left:10%; top:100px; z-index:100000; width:80%; height:100px; border-top:7px solid #d60000;}
.lyAppdown img {vertical-align:top;}
.lyAppdown .app {padding-bottom:30px; background-color:#fff;}
.lyAppdown .app p {padding-top:30px;}
.lyAppdown .app .btnGroup {margin:0 24px;}
.lyAppdown .app .button {margin-top:30px; -webkit-box-shadow:0px 1px 1px 0px rgba(0, 0, 0, 0.15); -moz-box-shadow:0px 1px 1px 0px rgba(0, 0, 0, 0.15); box-shadow:0px 1px 1px 0px rgba(0, 0, 0, 0.15);}
.lyAppdown .app .button a em {padding-right:15px; background:transparent url(http://fiximage.10x10.co.kr/m/2014/common/blt_arrow_rt5.png) right 50% no-repeat; background-size:7px 12px;}
.lyAppdown .anymore {padding:15px 24px 15px 0; color:#fff; font-size:16px; line-height:1.438em; text-align:right;}
.lyAppdown .anymore input {vertical-align:top;}
.lyGoSuperbag {position:absolute; left:5%; top:80px; z-index:100000; width:90%;}
.lyGoSuperbag img {vertical-align:top;}
.lyGoSuperbag .goEvt {position:relative;}
.lyGoSuperbag .goEvt a {display:block; position:absolute; left:16%; bottom:12%; width:68%; height:11%; color:transparent;}
.lyGoSuperbag .closeToday {position:relative; overflow:hidden; padding:10px; color:#616161; font-size:13px; background:#f2f2f2;}
.lyGoSuperbag .closeToday input {vertical-align:middle; margin:-3px 2px 0 0;}
.lyGoSuperbag .closeToday a {display:block; width:16px; position:absolute; right:10px; top:10px;}
@media all and (min-width:480px){
	.lyAppdown .app {padding-bottom:50px;}
	.lyAppdown .app p {padding-top:45px;}
	.lyAppdown .app .button {margin-top:45px;}
	.lyAppdown .app .button a em {padding-right:22px; background-size:8px 18px;}
	.lyAppdown .anymore {padding-top:30px; padding-bottom:30px; font-size:18px;}
	.lyGoSuperbag .closeToday {padding:15px; font-size:20px;}
	.lyGoSuperbag .closeToday input {margin:-5px 3px 0 0;}
	.lyGoSuperbag .closeToday a {width:24px; right:15px; top:15px;}	
}
</style>
<%
	If request.Cookies("appdown")("mode") = "" then
%>
<script type="text/javascript">
	$(function(){
		var maskHeight = $(document).height();
		var maskWidth =	$(window).width();

		$('#mask').css({'width':maskWidth,'height':maskHeight});
		$('#boxes').show();
		$('#mask').show();
		$('.window').show();

		$('.lyrClose').click(function(e) {
			e.preventDefault();
			$('#boxes').hide();
			$('.window').hide();
		});

		$('#mask').click(function () {
			$('#boxes').hide();
			$('.window').hide();
		});

		$(window).resize(function () {
			var box = $('#boxes .window');
			var maskHeight = $(document).height();
			var maskWidth = $(window).width();
			$('#mask').css({'width':maskWidth,'height':maskHeight});

			var winH = $(window).height();
			var winW = $(window).width();
			box.css('top', winH/2 - box.height()/2);
			box.css('left', winW/2 - box.width()/2);
		});
	});

function hideLayer(due){
	document.getElementById('boxes').style.display = "none";
	document.getElementById('due').value = due;
	document.frm.action = '/common/Cookie_process.asp';
	document.frm.target = 'view';
	document.frm.submit();
}
</script>
<% End If %>
<script>
$(function(){
	// multi banner
	var _maxSwipe =6;
    var _iSwipe=0;
	var swiper = new Swiper('.swiper1', {
		pagination:'.paging1',
		paginationClickable:true,
		autoplay:3500,
		resizeReInit:true,
		calculateHeight:true,
		<!-- #include virtual="/chtml/main/xml/main_banner/main_rollchk.txt" -->
		autoplayDisableOnInteraction:false,
		loop:true,
		onTouchEnd:function(swiper) {
			swiper.startAutoplay()
		},
		followFinger:false,
		onSlideChangeEnd: function(swiper){
          _iSwipe++;
          if (_iSwipe>_maxSwipe){
            swiper.stopAutoplay();
          }
        }
	});

	// just 1day
	var swiperJ = new Swiper('.swiper2', {
		pagination:'.paging2',
		paginationClickable:true,
		resizeReInit:true,
		calculateHeight:true,
		loop:true
	});
	$('.arrow-left').on('click', function(e){
		e.preventDefault()
		swiperJ.swipePrev()
	});
	$('.arrow-right').on('click', function(e){
		e.preventDefault()
		swiperJ.swipeNext()
	});

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			swiper.reInit();
			swiperJ.reInit();
			clearInterval(oTm);
		}, 500);
	});
});
</script>
</head>
<body>
<!-- #INCLUDE Virtual="/member/actnvshopLayerCont.asp" -->
<!-- #INCLUDE Virtual="/member/actcoochaLayerCont.asp" -->
<!-- 앱 다운로드 레이어 -->
<% If request.Cookies("appdown")("mode") = "" Then %>
	<% 		
	'//2015.03.13 한용민 추가
	if (left(currenttime,10)>="2015-03-16" and left(currenttime,10)<"2015-03-21") or (left(currenttime,10)>="2015-03-23" and left(currenttime,10)<"2015-03-26") then
	%>
		<div id="boxes">
			<div id="mask"></div>
			<div class="window">
				<div class="lyGoSuperbag">
					<div class="goEvt">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_front_banner_m.jpg" alt="새로워진 텐바이텐 앱을 지금 만나보세요!" /></p>
						<a href="/event/eventmain.asp?eventid=59796">이벤트 참여하러 가기</a>
					</div>
					<p class="closeToday">
						<input type="checkbox" onclick="hideLayer('one'); return false;" id="todayAnymore" /> <label for="todayAnymore">오늘 하루 보지 않기</label>
						<a href="" class="lyrClose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/btn_close_banner.gif" alt="닫기" /></a>
					</p>
				</div>
			</div>
		</div>
	<% elseIf currenttime < #04/13/2015 00:00:00# Then %>
		<div id="boxes">
			<div id="mask"></div>
			<div class="window">
				<div class="lyAppdown">
					<div class="app">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/app/mo/txt_meet.gif" alt="새로워진 텐바이텐 앱을 지금 만나보세요!" /></p>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/app/mo/txt_download_coupon.gif" alt="지금 텐바이텐 앱을 다운받고, 할인쿠폰을 받으세요!" /></p>
						<div class="btnGroup">
							<span class="button btB1 btRed cWh1 w100p"><a href="/event/appdown/"><em>텐바이텐 APP 다운받기</em></a></span>
						</div>
					</div>
					<p class="anymore"><input type="checkbox" id="todayAnymore" onclick="hideLayer('one');"/> <label for="todayAnymore">오늘 하루 보지 않기</label></p>
				</div>
			</div>
		</div>
	<% End If %>
<% End If %>
<!-- //앱 다운로드 레이어 -->
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<div class="content todayMainV15a" id="contentArea">
				<% 'MAIN BANNER %>
				<section class="multiBnrV15a">
					<% server.Execute("/chtml/main/loader/2015loader/mainXMLBanner_2052_renew.asp") %>
				</section>
				<% 'MAIN BANNER %>
				<% 'JUST 1 DAY %>
				<section class="justDayV15a">
					<% server.Execute("/chtml/main/loader/2015loader/main_just1day_renew.asp") %>
				</section>
				<% 'JUST 1 DAY %>
				<% 'HOT KEYWORD %>
				<section class="keywordV15a">
					<% server.Execute("/chtml/main/loader/2015loader/main_hotkeyword_renew.asp") %>
				</section>
				<% 'HOT KEYWORD %>
				<% 'TEXT BANNER %>
				<section class="txtBnrV15a">
					<% server.Execute("/chtml/main/loader/2015loader/mainXMLBanner_2055_renew.asp") %>
				</section>
				<% 'TEXT BANNER %>
				<% 'TREND EVENT %>
				<section class="trendEvtV15a">
					<% server.Execute("/chtml/main/loader/2015loader/main_todayenjoy_renew.asp") %>
				</section>
				<% 'TREND EVENT %>
				<% 'MD`S PICK %>
				<section class="pdtCurationV15a">
					<% server.Execute("/chtml/main/loader/2015loader/main_mdpick_renew.asp") %>
				</section>
				<% 'MD`S PICK %>
			</div>
			<iframe name="view" id="view" frameborder="0" width="0" height="0" style="display:block;"></iframe>
			<form name="frm" method="post" style="margin:0px; display:inline;">
				<input type="hidden" id="due" name="due">
			</form>
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
<script type="text/javascript" src="/lib/js/nudge.min.js?v=103"></script>
</body>
</html>