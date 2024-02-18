<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 슈퍼백의 기적(박스이벤트)
' History : 2015.03.11 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/etc/event59795Cls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/wishCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->

<%
dim eCode, userid
eCode=getevt_code
userid = getloginuserid()

%>

<!-- #include virtual="/lib/inc/head.asp" -->

<%
'//슈퍼백의 기적 오픈기간
if not( left(currenttime,10)>="2015-03-21" and left(currenttime,10)<"2015-03-23" ) then
%>
	<style type="text/css">
	img {vertical-align:top;}
	.bagSwiper {position:relative; z-index:20;}
	.bagSwiper .bPagination {position:absolute; left:0; bottom:10px; width:100%; height:5px; text-align:center;}
	.bagSwiper .bPagination span {display:inline-block; width:5px; height:5px; background:#fff; margin:0 2px; vertical-align:top; border-radius:50%;}
	.bagSwiper .bPagination span.swiper-active-switch {background:#f24a3e;}
	.bagSwiper button {position:absolute; top:39%; width:24px; height:38px; background-repeat:no-repeat; background-size:100% 100%; background-color:transparent; text-indent:-999em;}
	.bagSwiper .btnPrev {left:1%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/59795/btn_prev.png);}
	.bagSwiper .btnNext {right:1%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/59795/btn_next.png);}
	.superBag {padding:0 4%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59795/bg_dot.gif) left top repeat-y; background-size:100% auto;}
	.superBag .todayBag {position:relative; padding-bottom:12px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59795/bg_box_shadow.png) left bottom no-repeat; background-size:100% 12px;}
	.superBag .picA {position:relative; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/59795/bg_pin.png),url(http://webimage.10x10.co.kr/eventIMG/2015/59795/bg_pin.png); background-position:1.5% 2%, 99% 2%; background-repeat:no-repeat; background-size:12px 13px; background-color:#ffbd4d;}
	.superBag .picA div {padding:0 10px 10px;}
	.superBag .picA .plus {position:absolute; left:50%; bottom:-10%; width:18%; margin-left:-9%; z-index:35;}
	.superBag .picA .deco {position:absolute; left:0; bottom:-10%; width:100%; z-index:30;}
	.superBag .picB {padding:10px 10px 0; background-color:#ffe0ac;}
	.eventInfo {padding:0 4% 25px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59795/bg_dot.gif) left top repeat-y; background-size:100% auto;}
	.todayRandom {background-color:#ffe0ac;}
	.todayRandom .pdt {display:none; position:relative;}
	.todayRandom .pdt li {position:absolute;}
	.todayRandom .pdt li a {display:block; width:100%; height:100%; color:transparent;}
	.todayRandom .pdt li.p01 {left:10%; top:23%; width:37%; height:33%;}
	.todayRandom .pdt li.p02 {right:10%; top:23%; width:37%; height:33%;}
	.todayRandom .pdt li.p03 {left:7%; bottom:8%; width:25%; height:31%; }
	.todayRandom .pdt li.p04 {left:37.5%; bottom:8%; width:25%; height:31%;}
	.todayRandom .pdt li.p05 {right:7%; bottom:8%; width:25%; height:31%;}
	.todayRandom .openPdt,.todayRandom .closePdt {cursor:pointer;}
	
	@media all and (min-width:480px){
		.superBag .todayBag {padding-bottom:18px; background-size:100% 18px;}
		.superBag .picA {background-size:18px 20px;}
		.superBag .picA div {padding:0 15px 15px;}
		.superBag .picA .deco {bottom:-15%;}
		.superBag .picB {padding:15px 15px 0;}
		.bagSwiper .bPagination {bottom:15px; height:8px;}
		.bagSwiper .bPagination span {width:8px; height:8px; margin:0 5px;}
		.bagSwiper button {width:36px; height:57px;}
	}
	</style>
	<script type="text/javascript">
	$(function(){
		// swipe
		showSwiper= new Swiper('.swiper',{
			loop:true,
			resizeReInit:true,
			calculateHeight:true,
			pagination:'.bPagination',
			paginationClickable:true,
			speed:300,
			autoplay:2000,
			onTouchEnd: function(){
				showSwiper.startAutoplay();
			}
		});
		$('.btnPrev').on('click', function(e){
			e.preventDefault()
			showSwiper.swipePrev()
		});
	
		$('.btnNext').on('click', function(e){
			e.preventDefault()
			showSwiper.swipeNext()
		});
		$(window).on("orientationchange",function(){
			var oTm = setInterval(function () {
			showSwiper.reInit();
			clearInterval(oTm);
			}, 500);
		});
	
		// 오늘의 상품 열기,닫기
		$('.openPdt').click(function(){
			$(this).hide();
			$(this).next('.pdt').show();
		});
		$('.closePdt').click(function(){
			$(this).parents('.pdt').hide();
			$('.openPdt').show();
		});
	});
	
	function applink10x10(){
		var str = $.ajax({
			type: "GET",
			url: "/event/etc/doEventSubscript59795.asp",
			data: "mode=mo_main",
			dataType: "text",
			async: false
		}).responseText;
	
		if (str == "OK"){
			parent.top.location.href='http://m.10x10.co.kr/apps/link/?2920150313';
			return false;
		}else{
			alert('오류가 발생했습니다.');
			return false;
		}
	}
	
	</script>
	</head>
	<body>
	
	<!-- 슈퍼백의 기적(M) -->
	<div class="mEvt59796">
	
		<!-- 오늘의 상품 (날짜별로 노출시켜주세요) -->
		<div class="superBagWrap">
			<% 
			'/오픈전
			if left(currenttime,10)<"2015-03-16" then
			%>
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_superbag_0316.gif" alt="슈퍼백의 기적" /></h2>
			<% 
			'/종료
			elseif left(currenttime,10)>"2015-03-25" then
			%>
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_superbag_0325.gif" alt="슈퍼백의 기적" /></h2>
			<% elseif left(currenttime,10)>="2015-03-23" and left(currenttime,10)<"2015-03-26" then %>
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_superbag_<%= Format00(2,month(currenttime)) %><%= Format00(2,day(currenttime)) %>.jpg" alt="슈퍼백의 기적" /></h2>
			<% else %>
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_superbag_<%= Format00(2,month(currenttime)) %><%= Format00(2,day(currenttime)) %>.gif" alt="슈퍼백의 기적" /></h2>
			<% end if %>
			
			<div class="superBag">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_today_bag.png" alt="오늘의 슈퍼백" /></h3>
	
				<div class="todayBag">
					<% 
					'/오픈전
					if left(currenttime,10)<"2015-03-16" then
					%>
						<div class="picA">
							<!-- 날짜별 변경 -->
							<h4><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_bag_name_0316.png" alt="오늘의 슈퍼백" /></h4>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_todaybag_0316.jpg" alt="슈퍼백 이미지" /></div>
							<p class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_bag_deco_0316.png" alt="" /></p>
							<!--// 날짜별 변경 -->
							<p class="plus"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/ico_plus.png" alt="+" /></p>
						</div>
					<% 
					'/종료
					elseif left(currenttime,10)>"2015-03-25" then
					%>
						<div class="picA">
							<!-- 날짜별 변경 -->
							<h4><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_bag_name_0325.png" alt="오늘의 슈퍼백" /></h4>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_todaybag_0325.jpg" alt="슈퍼백 이미지" /></div>
							<p class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_bag_deco_0325.png" alt="" /></p>
							<!--// 날짜별 변경 -->
							<p class="plus"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/ico_plus.png" alt="+" /></p>
						</div>
					<% elseif left(currenttime,10)="2015-03-19" then %>
						<div class="picA">
							<!-- 날짜별 변경 -->
							<h4><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_bag_name_0327.png" alt="오늘의 슈퍼백" /></h4>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_todaybag_0327.jpg" alt="슈퍼백 이미지" /></div>
							<p class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_bag_deco_0327.png" alt="" /></p>
							<!--// 날짜별 변경 -->
							<p class="plus"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/ico_plus.png" alt="+" /></p>
						</div>
					<% elseif left(currenttime,10)="2015-03-25" then %>
						<div class="picA">
							<!-- 날짜별 변경 -->
							<h4><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_bag_name_0326.png" alt="오늘의 슈퍼백" /></h4>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_todaybag_0326.jpg" alt="슈퍼백 이미지" /></div>
							<p class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_bag_deco_0326.png" alt="" /></p>
							<!--// 날짜별 변경 -->
							<p class="plus"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/ico_plus.png" alt="+" /></p>
						</div>
					<% else %>
						<div class="picA">
							<!-- 날짜별 변경 -->
							<h4><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_bag_name_<%= Format00(2,month(currenttime)) %><%= Format00(2,day(currenttime)) %>.png" alt="오늘의 슈퍼백" /></h4>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_todaybag_<%= Format00(2,month(currenttime)) %><%= Format00(2,day(currenttime)) %>.jpg" alt="슈퍼백 이미지" /></div>
							<p class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_bag_deco_<%= Format00(2,month(currenttime)) %><%= Format00(2,day(currenttime)) %>.png" alt="" /></p>
							<!--// 날짜별 변경 -->
							<p class="plus"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/ico_plus.png" alt="+" /></p>
						</div>
					<% end if %>
	
					<div class="picB">
						<div class="bagSwiper">
							<div class="swiper-container swiper">
								<div class="swiper-wrapper">
									<% if left(currenttime,10)="2015-03-16" then %>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0316.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0316.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0316.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0316.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0316.jpg" alt="" /></div>
									<% elseif left(currenttime,10)="2015-03-17" then %>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0317.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0317.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0317.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0317.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0317.jpg" alt="" /></div>
									<% elseif left(currenttime,10)="2015-03-18" then %>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0318.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0318.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0318.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0318.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0318.jpg" alt="" /></div>
									<% elseif left(currenttime,10)="2015-03-19" then %>
										<!--<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0319.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0319.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0319.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0319.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0319.jpg" alt="" /></div>-->
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0327.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0327.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0327.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0327.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0327.jpg" alt="" /></div>
									<% elseif left(currenttime,10)="2015-03-20" then %>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0320.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0320.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0320.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0320.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0320.jpg" alt="" /></div>
									<% elseif left(currenttime,10)="2015-03-23" then %>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0323.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0323.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0323.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0323.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0323.jpg" alt="" /></div>
									<% elseif left(currenttime,10)="2015-03-24" then %>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0324.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0324.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0324.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0324.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0324.jpg" alt="" /></div>
									<% elseif left(currenttime,10)="2015-03-25" then %>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0326.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0326.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0326.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0326.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0326.jpg" alt="" /></div>
									<% 
									'/오픈전
									elseif left(currenttime,10)<"2015-03-16" then
									%>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0316.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0316.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0316.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0316.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0316.jpg" alt="" /></div>
									<% 
									'/종료
									elseif left(currenttime,10)>"2015-03-25" then
									%>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0326.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0326.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0326.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0326.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0326.jpg" alt="" /></div>
									<% end if %>
								</div>
							</div>
							<div class="bPagination"></div>
							<button type="button" class="btnPrev">이전</button>
							<button type="button" class="btnNext">다음</button>
						</div>
					</div>
					<div class="todayRandom">
						<p class="openPdt"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/btn_open_product.gif" alt="오늘의 랜덤 상품 자세히보기" /></p>
						<div class="pdt">
							<p class="closePdt"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/btn_close_product.gif" alt="오늘의 랜덤 상품 닫기" /></p>
							
							<% if left(currenttime,10)="2015-03-16" then %>
								<div>
									<ul>
										<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1176161" target="_top">애플 맥북에어 13형</a></li>
										<li class="p02"><a href="/category/category_itemPrd.asp?itemid=1153596" target="_top">네오스마트펜 N2</a></li>
										<li class="p03"><a href="/category/category_itemPrd.asp?itemid=1185713" target="_top">디즈니 캐릭터 USB 메모리</a></li>
										<li class="p04"><a href="/category/category_itemPrd.asp?itemid=1203703" target="_top">뭉게구름 LED</a></li>
										<li class="p05"><a href="/category/category_itemPrd.asp?itemid=1146210" target="_top">Card case</a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0316.png" alt="3월16일 슈퍼백 상품" /></p>
								</div>
							<% elseif left(currenttime,10)="2015-03-17" then %>
								<div>
									<ul>
										<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1182606" target="_top">애플 아이패드 미니3</a></li>
										<li class="p02"><a href="/category/category_itemPrd.asp?itemid=1116011" target="_top">Beats by Dr.dre</a></li>
										<li class="p03"><a href="/category/category_itemPrd.asp?itemid=1190691" target="_top">단보 보조배터리</a></li>
										<li class="p04"><a href="/category/category_itemPrd.asp?itemid=1196076" target="_top">GRE, 그래!</a></li>
										<li class="p05"><a href="/category/category_itemPrd.asp?itemid=958184" target="_top">컴팩트 사이드노크 </a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0317.png" alt="3월17일 슈퍼백 상품" /></p>
								</div>
							<% elseif left(currenttime,10)="2015-03-18" then %>
								<div>
									<ul>
										<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1176161" target="_top">애플 맥북에어 13형</a></li>
										<li class="p02"><a href="/category/category_itemPrd.asp?itemid=770217" target="_top">인스탁스 미니 8 카메라</a></li>
										<li class="p03"><a href="/category/category_itemPrd.asp?itemid=1160001" target="_top">KEEP CUP</a></li>
										<li class="p04"><a href="/category/category_itemPrd.asp?itemid=273007" target="_top">휴대용 칫솔</a></li>
										<li class="p05"><a href="/category/category_itemPrd.asp?itemid=1219458" target="_top">반8 포장 김밥 필통</a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0318.png" alt="3월18일 슈퍼백 상품" /></p>
								</div>
							<% elseif left(currenttime,10)="2015-03-19" then %>
								<!--<div>
									<ul>
										<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1182606" target="_top">애플 아이패드 미니3</a></li>
										<li class="p02"><a href="/category/category_itemPrd.asp?itemid=1196599" target="_top">MARC JACOBS 손목시계</a></li>
										<li class="p03"><a href="/category/category_itemPrd.asp?itemid=778787" target="_top">하루의열매 베리믹스 한입</a></li>
										<li class="p04"><a href="/category/category_itemPrd.asp?itemid=1180608" target="_top">숙성천연비누</a></li>
										<li class="p05"><a href="/category/category_itemPrd.asp?itemid=1100627" target="_top">몽키 바나나 휴대용 손톱깎이</a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0319.png" alt="3월19일 슈퍼백 상품" /></p>
								</div>-->
								<div>
									<ul>
										<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1182606" target="_top">애플 아이패드 미니3</a></li>
										<li class="p02"><a href="/category/category_itemPrd.asp?itemid=770217" target="_top">인스탁스 미니 8 카메라</a></li>
										<li class="p03"><a href="/category/category_itemPrd.asp?itemid=1160001" target="_top">KEEPCUP KHIDR</a></li>
										<li class="p04"><a href="/category/category_itemPrd.asp?itemid=1154815" target="_top">오아시스 피크닉매트</a></li>
										<li class="p05"><a href="/category/category_itemPrd.asp?itemid=1128352" target="_top">무민 이어캡</a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0327.png" alt="3월27일 슈퍼백 상품" /></p>
								</div>
							<% elseif left(currenttime,10)="2015-03-20" then %>
								<div>
									<ul>
										<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1176161" target="_top">애플 맥북에어 13형</a></li>
										<li class="p02"><a href="/category/category_itemPrd.asp?itemid=1116021" target="_top">Beats by Dr.dre</a></li>
										<li class="p03"><a href="/category/category_itemPrd.asp?itemid=675616" target="_top">데메테르향수 롤온</a></li>
										<li class="p04"><a href="/category/category_itemPrd.asp?itemid=1206817" target="_top">마주로 클립 셀카렌즈</a></li>
										<li class="p05"><a href="/category/category_itemPrd.asp?itemid=1215643" target="_top">헬로키티 네오프렌 아령</a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0320.png" alt="3월20일 슈퍼백 상품" /></p>
								</div>
							<% elseif left(currenttime,10)="2015-03-23" then %>
								<div>
									<ul>
										<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1182606" target="_top">애플 아이패드 미니3</a></li>
										<li class="p02"><a href="/category/category_itemPrd.asp?itemid=1196599" target="_top">MARC JACOBS 손목시계</a></li>
										<li class="p03"><a href="/category/category_itemPrd.asp?itemid=1185713" target="_top">디즈니 캐릭터 USB 메모리</a></li>
										<li class="p04"><a href="/category/category_itemPrd.asp?itemid=1180608" target="_top">숙성천연비누</a></li>
										<li class="p05"><a href="/category/category_itemPrd.asp?itemid=1219458" target="_top">반8 포장 김밥 필통</a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0323.png" alt="3월23일 슈퍼백 상품" /></p>
								</div>
							<% elseif left(currenttime,10)="2015-03-24" then %>
								<div>
									<ul>
										<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1176161" target="_top">애플 맥북에어 13형</a></li>
										<li class="p02"><a href="/category/category_itemPrd.asp?itemid=1182832" target="_top">머메이드2607</a></li>
										<li class="p03"><a href="/category/category_itemPrd.asp?itemid=778787" target="_top">하루의열매 베리믹스 한입</a></li>
										<li class="p04"><a href="/category/category_itemPrd.asp?itemid=273007" target="_top">휴대용 칫솔</a></li>
										<li class="p05"><a href="/category/category_itemPrd.asp?itemid=1215642" target="_top">헬로키티 네오프렌 아령</a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0324.png" alt="3월24일 슈퍼백 상품" /></p>
								</div>
							<% elseif left(currenttime,10)="2015-03-25" then %>
								<div>
									<ul>
										<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1176161" target="_top">애플 맥북에어 13형</a></li>
										<li class="p02"><a href="/category/category_itemPrd.asp?itemid=1153596" target="_top">네오스마트펜 N2</a></li>
										<li class="p03"><a href="/category/category_itemPrd.asp?itemid=1142469" target="_top">Lovely Ice Cream Lamp</a></li>
										<li class="p04"><a href="/category/category_itemPrd.asp?itemid=1196076" target="_top">GRE, 그래!</a></li>
										<li class="p05"><a href="/category/category_itemPrd.asp?itemid=958184" target="_top">컴팩트 사이드노크</a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0326.png" alt="3월26일 슈퍼백 상품" /></p>
								</div>
							<% 
							'/오픈전
							elseif left(currenttime,10)<"2015-03-16" then
							%>
								<div>
									<ul>
										<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1176161" target="_top">애플 맥북에어 13형</a></li>
										<li class="p02"><a href="/category/category_itemPrd.asp?itemid=1153596" target="_top">네오스마트펜 N2</a></li>
										<li class="p03"><a href="/category/category_itemPrd.asp?itemid=1185713" target="_top">디즈니 캐릭터 USB 메모리</a></li>
										<li class="p04"><a href="/category/category_itemPrd.asp?itemid=1203703" target="_top">뭉게구름 LED</a></li>
										<li class="p05"><a href="/category/category_itemPrd.asp?itemid=1146210" target="_top">Card case</a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0316.png" alt="3월16일 슈퍼백 상품" /></p>
								</div>
							<% 
							'/종료
							elseif left(currenttime,10)>"2015-03-25" then
							%>
								<div>
									<ul>
										<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1176161" target="_top">애플 맥북에어 13형</a></li>
										<li class="p02"><a href="/category/category_itemPrd.asp?itemid=1153596" target="_top">네오스마트펜 N2</a></li>
										<li class="p03"><a href="/category/category_itemPrd.asp?itemid=1142469" target="_top">Lovely Ice Cream Lamp</a></li>
										<li class="p04"><a href="/category/category_itemPrd.asp?itemid=1196076" target="_top">GRE, 그래!</a></li>
										<li class="p05"><a href="/category/category_itemPrd.asp?itemid=958184" target="_top">컴팩트 사이드노크</a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0326.png" alt="3월26일 슈퍼백 상품" /></p>
								</div>
							<% end if %>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="eventInfo">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/txt_price.png" alt="=5,000원(배송비포함)" /></p>
			<a href="" onclick="applink10x10(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/btn_go_app.gif" alt="텐바이텐 APP으로 가기" /></a>
		</div>
		<!--// 오늘의 상품 -->
	</div>
	<!--// 슈퍼백의 기적(M) -->

	</body>
	</html>

<%
'/주말 처리
else
%>
	<style type="text/css">
	.mEvt59795 {position:relative; margin-bottom:-50px;}
	.mEvt59795 img {vertical-align:top;}
	.mEvt59795 .superHead {position:relative;}
	.mEvt59795 .superHead .timerWrap {position:absolute; left:3%; bottom:9.2%; width:94%; height:14%;}
	.mEvt59795 .superHead .timer {position:absolute; left:0; top:50%; width:100%; height:35px; margin-top:-18px; font-weight:bold; text-align:center;}
	.mEvt59795 .superHead .timer em {display:inline-block; width:35px; height:100%; line-height:1.555em; margin:0 2px; font-size:25px; color:#000; background:#fff;}
	.mEvt59795 .superHead .timer span {display:inline-block; width:6px; font-size:28px; color:#fff;}
	.mEvt59795 .nextBrand li {position:relative; cursor:pointer;}
	.mEvt59795 .nextBrand li .on {display:none; position:absolute; left:0; top:0;}
	@media all and (min-width:480px){
		.mEvt59795 .superHead .timer {height:53px; margin-top:-27px;}
		.mEvt59795 .superHead .timer em {width:53px; margin:0 3px; font-size:38px;}
		.mEvt59795 .superHead .timer span {width:9px; font-size:42px;}
	}
	</style>
	<script type="text/javascript">

	$(function(){
		$(".nextBrand li").click(function(){
			$(this).children('.on').toggle();
		});
	});

	//카카오 친구 초대
	function kakaosendcall(){
		<% if not( left(currenttime,10)>="2015-03-21" and left(currenttime,10)<"2015-03-23" ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
				alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
				return;
			<% else %>
				var rstStr = $.ajax({
					type: "POST",
					url: "<%= appUrlPath %>/event/etc/doEventSubscript59795.asp",
					data: "mode=KAKAOHOILDAY",
					dataType: "text",
					async: false
				}).responseText;
				//alert(rstStr);
				if (rstStr == "OK"){
					parent.parent_kakaolink('[텐바이텐] 슈퍼백의기적!\n\n신학기! 첫 출근! 첫 데이트!\n3월! 새로운 시작을 앞둔 당신에게 텐바이텐이 매일 새로운 Bag에 선물을 보내드립니다.!\n\n든든한 당신의 백! 지금 도전해 보세요!\n\n오직! 텐바이텐 APP에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/59795/kakao-banner.jpg' , '200' , '200' , '<% = wwwUrl %><% = appUrlPath %>/event/eventmain.asp?eventid=<% = eCode %>' );
					//parent.parent_kakaolink('[텐바이텐] 슈퍼백의기적!\n\n신학기! 첫 출근! 첫 데이트!\n3월! 새로운 시작을 앞둔 당신에게 텐바이텐이 매일 새로운 Bag에 선물을 보내드립니다.!\n\n든든한 당신의 백! 지금 도전해 보세요!\n\n오직! 텐바이텐 APP에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/59795/kakao-banner.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/link/?2920150313' );
					return false;
				}else if (rstStr == "DATENOT"){
					alert('이벤트 응모 기간이 아닙니다.');
					return false;
				}else{
					alert('관리자에게 문의');
					return false;
				}
			<% end if %>
		<% end if %>
	}
	
	<%
	Dim vEdate : vEdate = "2015-03-22 23:59:59" '//주말
	%>
	var yr = "<%=Year(vEdate)%>";
	var mo = "<%=TwoNumber(Month(vEdate))%>";
	var da = "<%=TwoNumber(Day(vEdate))%>";
	var hh = "<%=TwoNumber(hour(vEdate))%>";
	var mm = "<%=TwoNumber(minute(vEdate))%>";
	var ss = "<%=TwoNumber(second(vEdate))%>";
	var tmp_hh = "99";
	var tmp_mm = "99";
	var tmp_ss = "99";
	var minus_second = 0;
	var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
	var today=new Date(<%=Year(currenttime)%>, <%=Month(currenttime)-1%>, <%=Day(currenttime)%>, <%=Hour(currenttime)%>, <%=Minute(currenttime)%>, <%=Second(currenttime)%>);
	
	function countdown(){
		today = new Date(Date.parse(today) + (1000+minus_second));	//서버시간에 1초씩 증가
		var todayy=today.getYear()
	
		if(todayy < 1000)
			todayy+=1900

			var todaym=today.getMonth()
			var todayd=today.getDate()
			var todayh=today.getHours()
			var todaymin=today.getMinutes()
			var todaysec=today.getSeconds()
			var todaystring=montharray[todaym]+" "+todayd+", "+todayy+" "+todayh+":"+todaymin+":"+todaysec
			//futurestring=montharray[mo-1]+" "+da+", "+yr+" 11:59:59";
			futurestring=montharray[mo-1]+" "+da+", "+yr+" "+hh+":"+mm+":"+ss;

			dd=Date.parse(futurestring)-Date.parse(todaystring)
			dday=Math.floor(dd/(60*60*1000*24)*1)
			dhour=Math.floor((dd%(60*60*1000*24))/(60*60*1000)*1)
			dmin=Math.floor(((dd%(60*60*1000*24))%(60*60*1000))/(60*1000)*1)
			dsec=Math.floor((((dd%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1)
	
			if (dday == 1){
				dhour = dhour + 24
			}
	
			if(dhour < 0)
			{
				$("#lyrCounter").hide();
				return;
			}
	
			if(dhour < 10) {
				dhour = "0" + dhour;
			}
			if(dmin < 10) {
				dmin = "0" + dmin;
			}
			if(dsec < 10) {
				dsec = "0" + dsec;
			}
	
			$("#lyrCounter").html("<em>"+Left(dhour,1)+ "</em> <em>"+ Right(dhour,1)+ "</em> <span>:</span> <em>"+ Left(dmin,1) +"</em> <em>"+ Right(dmin,1)+ "</em> <span>:</span> <em>"+ Left(dsec,1) + "</em> <em>"+ Right(dsec,1)+ "</em>");
			
			tmp_hh = dhour;
			tmp_mm = dmin;
			tmp_ss = dsec;
			minus_second = minus_second + 1;
	
		setTimeout("countdown()",1000)
	}
	
	countdown();
	
	//left
	function Left(Str, Num){
		if (Num <= 0)
			return "";
		else if (Num > String(Str).length)
			return Str;
		else
			return String(Str).substring(0,Num);
	}
	
	//right
	function Right(Str, Num){
		if (Num <= 0)
			return "";
		else if (Num > String(Str).length)
			return Str;
		else
			var iLen = String(Str).length;
			return String(Str).substring(iLen, iLen-Num);
	}

	</script>
	</head>
	<body>

	<!-- 슈퍼백의 기적_주말(APP) -->
	<div class="mEvt59795">
		<div class="superHead">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_superbag_weekend.gif" alt="슈퍼백의 기적" /></h2>
			<div class="timerWrap">
				<div class="timer" id="lyrCounter">
					<em>0</em><em>1</em>
					<span>:</span>
					<em>2</em><em>3</em>
					<span>:</span>
					<em>4</em><em>5</em>
				</div>
			</div>
		</div>
		<div class="nextBrand">
			<ul>
				<li>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_next_brand01.jpg" alt="" /></p>
					<p class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_next_brand01_on.jpg" alt="" /></p>
				</li>
				<li>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_next_brand02.jpg" alt="" /></p>
					<p class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_next_brand02_on.jpg" alt="" /></p>
				</li>
				<li>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_next_brand04_.jpg" alt="" /></p>
					<p class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_next_brand04_on.jpg" alt="" /></p>
				</li>
			</ul>
		</div>
		<p><a href="#" onclick="kakaosendcall(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/btn_noti_friends_weekend.gif" alt="두둥! 월요일10시! 친구에게도 미리 슈퍼백의 기적을 알려주세요- 슈퍼백의 기적 알려주기" /></a></p>
	</div>
	<!--// 슈퍼백의 기적_주말(APP) -->

	</body>
	</html>
<% end if %>
<!-- #include virtual="/lib/db/dbclose.asp" -->
