<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 2019 크리스마스 기획전
' History : 2019-11-11 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	dim gnbflag , testmode
	gnbflag = RequestCheckVar(request("gnbflag"),1)
	testmode = RequestCheckVar(request("testmode"),1)

	If gnbflag <> "" Then '//gnb 숨김 여부
		gnbflag = true
	Else 
		gnbflag = False
		strHeadTitleName = "크리스마스"
	End if
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style>[v-cloak] { display: none; }</style>
<link href="https://fonts.googleapis.com/css?family=Noto+Serif:400,700&display=swap" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="/lib/css/xmas2019.css?v=1.02">
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script type="text/javascript">
$(function(){
	var wT = $(window).scrollTop();
	var xmasTop = $('.xmas2019').offset().top;
	var floatInitTop = $('.xmas2019 .bnr-floating').offset().top;
	if (wT==0) {
		var floatNewTop = xmasTop + floatInitTop;
		$('.xmas2019 .bnr-floating').css('top', floatNewTop);
	} else {
		var floatNewTop = xmasTop + floatInitTop - wT;
		$('.xmas2019 .bnr-floating').css('top', floatNewTop);
	}
	$(window).scroll(function(){
		var sT = $(window).scrollTop();
		$('.xmas2019 .take .txt-wrap').each(function(){
			var txtTop = $(this).offset().top - $(window).height() * 0.5;
			if( sT > txtTop ) {
				$(this).addClass('que');
			}
		});
		var mdTop = $('.xmas-item').offset().top - $(window).height() * 0.8;
		if ( sT > mdTop ) {
			$('.xmas2019 .bnr-floating').fadeOut();
		} else {
			$('.xmas2019 .bnr-floating').fadeIn();
		}
	});
	$('.xmas2019 .bnr-floating').click(function(){
		$('html,body').animate({
			scrollTop: $('.xmas-item').offset().top
		}, 1000);
	});
	$('.xmas2019 .prd-wrap').each(function(){
		var prd = $(this);
		prd.find('li:gt(2)').hide();
		prd.find('.btn-more').click(function(){
			prd.find('li').fadeIn();
			$(this).hide();
		});
	});
	var slider = $('.xmas2019 .take .slider');
	function sliderAction (target) {
		var progress = target.siblings('.progressbar').find('.progressbar-fill');
		var pager = target.siblings('.pager');
		var slideCount = target.find('.swiper-slide').length;
		var init = Math.floor(100 / slideCount);
		progress.css('width', init + '%');
		pager.find('span').text(slideCount);
		var takeSwiper = new Swiper(target, {
			loop:true,
			autoplay:3500,
			slidesPerView:'auto',
			centeredSlides:true,
			onSlideChangeStart: function(s) {
				var currentIdx = s.activeIndex % slideCount + 1;
				pager.find('b').text(currentIdx)
				progress.css('width', init * currentIdx + '%');
			}
		});
	}
	slider.each(function(){
		sliderAction( $(this) );
	});
	fnApplyItemInfoList({
		items:"2584298,2580851,1688020,2140986,2023635,2546624,2476601,2311368,2123394,2584246",
		target:"itemList1",
		fields:["image","name","price","sale"],
		unit:"hw",
		saleBracket:false
	});
	fnApplyItemInfoList({
		items:"2568784,2571181,2543028,2564632,2564638,2576083,1611105,1609775,1831398,2571163",
		target:"itemList2",
		fields:["image","name","price","sale"],
		unit:"hw",
		saleBracket:false
	});
	fnApplyItemInfoList({
		items:"2065460,2519454,2541074,1672546,1552103,2202150,2566671,2568866,2452501,2483131",
		target:"itemList3",
		fields:["image","name","price","sale"],
		unit:"hw",
		saleBracket:false
	});
	var evtSwiper = new Swiper('.evt-slider .swiper-container', {
		loop:true,
		pagination:'.evt-slider .pagination-dot'
	});
});
</script>
<script type="text/javascript">
var isApp = false;
$(function() {
	fnAmplitudeEventMultiPropertiesAction('view_2019christmas_main','','');
});
</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->	
	<div id="content" class="content xmas2019">
		<div class="topic">
			<span class="tit-pick"><img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/tit_pick.gif" alt="Pick"></span>
			<h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/tit_xmas.png" alt=""></h2>
		</div>

		<div class="bnr-floating">
			<button type="button"><img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/bnr_floating.png" alt="MD's pick"></button>
		</div>

		<section class="keyword">
			<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/tit_keyword.png" alt=""></h3>
			<div class="tag mWeb">
				<div class="row">
					<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=크리스마스" target="_blank" class="sch on">#크리스마스</a>
					<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=벽트리" target="_blank" class="sch">#벽트리</a>
					<a href="/event/eventmain.asp?eventid=98654" target="_blank" class="evt">#MERRYLIGHT</a>
				</div>
				<div class="row">
					<a href="/event/eventmain.asp?eventid=98626" target="_blank" class="evt">#미니트리</a>
					<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=가랜드" target="_blank" class="sch">#가랜드</a>
					<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=전구" target="_blank" class="sch on">#전구</a>
					<a href="/event/eventmain.asp?eventid=98631" target="_blank" class="evt">#파티</a>
				</div>
				<div class="row">
					<a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=오너먼트" target="_blank" class="sch">#오너먼트</a>
					<a href="/event/eventmain.asp?eventid=98627" target="_blank" class="evt on">#크리스마스선물</a>
					<a href="/event/eventmain.asp?eventid=98630" target="_blank" class="evt">#크리스마스카드</a>
				</div>
			</div>
			<div class="tag mApp">
				<div class="row">
					<a href="javascript:fnSearchEventText('크리스마스');" class="sch on">#크리스마스</a>
					<a href="javascript:fnSearchEventText('벽트리');" class="sch">#벽트리</a>
					<a href="jsEventlinkURL(98654);return false;" class="evt">#MERRYLIGHT</a>
				</div>
				<div class="row">
					<a href="jsEventlinkURL(98626);return false;" class="evt">#미니트리</a>
					<a href="javascript:fnSearchEventText('가랜드');" class="sch">#가랜드</a>
					<a href="javascript:fnSearchEventText('전구');" class="sch on">#전구</a>
					<a href="jsEventlinkURL(98631);return false;" class="evt">#파티</a>
				</div>
				<div class="row">
					<a href="javascript:fnSearchEventText('오너먼트');" class="sch">#오너먼트</a>
					<a href="jsEventlinkURL(98627);return false;" class="evt on">#크리스마스선물</a>
					<a href="jsEventlinkURL(98630);return false;" class="evt">#크리스마스카드</a>
				</div>
			</div>
		</section>

		<section style="padding-bottom:10%;" class="bnr-wrap">
			<!-- for dev msg : 마케팅 쿠폰 -->
			<% server.Execute("/christmas/2019/exc_coupon.asp") %>
		</section>

		<section class="take">
			<div class="take1">
				<p>
					<a href="/category/category_itemPrd.asp?itemid=2374389" onclick="TnGotoProduct('2374389');return false;">
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/img_take1_1.png" alt="">
					</a>
				</p>
				<div class="txt-wrap">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/tit_take_01.png" alt="Take 1. On the table"></p>
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/txt_take_01.png" alt="시선 닿는 곳마다 크리스마스"></p>
				</div>
				<div class="slider-wrap">
					<div class="swiper-container slider">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=2580857" onclick="TnGotoProduct('2580857');return false;">
									<img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/img_slide1_1.jpg" alt="">
								</a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1958525" onclick="TnGotoProduct('1958525');return false;">
									<img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/img_slide1_2.jpg" alt="">
								</a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=2464507" onclick="TnGotoProduct('2464507');return false;">
									<img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/img_slide1_3.jpg" alt="">
								</a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=2581264" onclick="TnGotoProduct('2581264');return false;">
									<img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/img_slide1_4.jpg" alt="">
								</a>
							</div>
						</div>
					</div>
					<div class="progressbar"><span class="progressbar-fill"></span></div>
					<div class="pager"><b>1</b><i>/</i><span>4</span></div>
				</div>
				<p>
					<a href="/category/category_itemPrd.asp?itemid=2374389" onclick="TnGotoProduct('2374389');return false;">
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/img_take1_2.jpg" alt="">
					</a>
				</p>
				<div class="prd-wrap">
					<ul id="itemList1">
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2584298" onclick="TnGotoProduct('2584298');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2580851" onclick="TnGotoProduct('2580851');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1688020" onclick="TnGotoProduct('1688020');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2140986" onclick="TnGotoProduct('2140986');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2023635" onclick="TnGotoProduct('2023635');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2546624" onclick="TnGotoProduct('2546624');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2476601" onclick="TnGotoProduct('2476601');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2311368" onclick="TnGotoProduct('2311368');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2123394" onclick="TnGotoProduct('2123394');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2584246" onclick="TnGotoProduct('2584246');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
					</ul>
					<button type="button" class="btn-more"><img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/btn_more.png" alt="제품 더보기"></button>
				</div>
			</div>

			<div class="take2">
				<p>
					<a href="/category/category_itemPrd.asp?itemid=2564639" onclick="TnGotoProduct('2564639');return false;">
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/img_take2_1.png" alt="">
					</a>
				</p>
				<div class="txt-wrap">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/tit_take_02.png" alt="Take 2. Wall decoration"></p>
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/txt_take_02.png" alt="오늘부터 크리스마스"></p>
				</div>
				<div class="slider-wrap">
					<div class="swiper-container slider">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=2568784" onclick="TnGotoProduct('2568784');return false;">
									<img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/img_slide2_1.jpg" alt="">
								</a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=2084384" onclick="TnGotoProduct('2084384');return false;">
									<img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/img_slide2_2.jpg" alt="">
								</a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=2581021" onclick="TnGotoProduct('2581021');return false;">
									<img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/img_slide2_3.jpg" alt="">
								</a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=2143326" onclick="TnGotoProduct('2143326');return false;">
									<img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/img_slide2_4.jpg" alt="">
								</a>
							</div>
						</div>
					</div>
					<div class="progressbar"><span class="progressbar-fill"></span></div>
					<div class="pager"><b>1</b><i>/</i><span>4</span></div>
				</div>
				<p>
					<a href="/category/category_itemPrd.asp?itemid=2580838" onclick="TnGotoProduct('2580838');return false;">
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/img_take2_2.jpg" alt="">
					</a>
				</p>
				<div class="prd-wrap">
					<ul id="itemList2">
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2568784" onclick="TnGotoProduct('2568784');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2571181" onclick="TnGotoProduct('2571181');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2543028" onclick="TnGotoProduct('2543028');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2564632" onclick="TnGotoProduct('2564632');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2564638" onclick="TnGotoProduct('2564638');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2576083" onclick="TnGotoProduct('2576083');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1611105" onclick="TnGotoProduct('1611105');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1609775" onclick="TnGotoProduct('1609775');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1831398" onclick="TnGotoProduct('1831398');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2571163" onclick="TnGotoProduct('2571163');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
					</ul>
					<button type="button" class="btn-more"><img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/btn_more.png" alt="제품 더보기"></button>
				</div>
			</div>

			<div class="take3">
				<p>
					<a href="/category/category_itemPrd.asp?itemid=1786079" onclick="TnGotoProduct('1786079');return false;">
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/img_take3_1.png" alt="">
					</a>
				</p>
				<div class="txt-wrap">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/tit_take_03.png" alt="Take 3. For someone"></p>
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/txt_take_03.png" alt="올해는 부끄러워하지 말기"></p>
				</div>
				<div class="slider-wrap">
					<div class="swiper-container slider">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=2139418" onclick="TnGotoProduct('2139418');return false;">
									<img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/img_slide3_1.jpg" alt="">
								</a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=2374389" onclick="TnGotoProduct('2374389');return false;">
									<img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/img_slide3_2.jpg" alt="">
								</a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1786079" onclick="TnGotoProduct('1786079');return false;">
									<img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/img_slide3_3.jpg" alt="">
								</a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1914402" onclick="TnGotoProduct('1914402');return false;">
									<img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/img_slide3_4.jpg" alt="">
								</a>
							</div>
						</div>
					</div>
					<div class="progressbar"><span class="progressbar-fill"></span></div>
					<div class="pager"><b>1</b><i>/</i><span>4</span></div>
				</div>
				<p>
					<a href="/category/category_itemPrd.asp?itemid=1786079" onclick="TnGotoProduct('1786079');return false;">
						<img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/img_take3_2.jpg" alt="">
					</a>
				</p>
				<div class="prd-wrap">
					<ul id="itemList3">
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2065460" onclick="TnGotoProduct('2065460');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2519454" onclick="TnGotoProduct('2519454');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2541074" onclick="TnGotoProduct('2541074');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1672546" onclick="TnGotoProduct('1672546');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=1552103" onclick="TnGotoProduct('1552103');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2202150" onclick="TnGotoProduct('2202150');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2566671" onclick="TnGotoProduct('2566671');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2568866" onclick="TnGotoProduct('2568866');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2452501" onclick="TnGotoProduct('2452501');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
						<li>
							<a href="/category/category_itemPrd.asp?itemid=2483131" onclick="TnGotoProduct('2483131');return false;">
								<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/256/B002568866.jpg" alt=""></div>
								<div class="desc">
									<p class="name">상품명</p>
									<p class="price"><s>36,400</s> 32,030원<span>12%</span></p>
								</div>
							</a>
						</li>
					</ul>
					<button type="button" class="btn-more"><img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/btn_more.png" alt="제품 더보기"></button>
				</div>
			</div>
		</section>

		<%' 상품 리스트 %>
		<div id="app"></div>
	</div>
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<% IF application("Svr_Info") = "Dev" or testmode = "1" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<script src="/vue/exhibition/components/more-button.js"></script>
<script src="/vue/exhibition/components/slide-list.js"></script>
<script src="/vue/exhibition/components/item-list.js"></script>
<script src="/vue/exhibition/modules/store.js"></script>
<script src="/vue/exhibition/main/christmas2019/index.js"></script>
</body>
</html>