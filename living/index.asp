<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">
$(function(){

	/* new, hot, best */
	var ctgy = ['가구/수납', '데코/조명', '키친', '패브릭/생활']
	var itemSwiper1 = new Swiper(".ctgy-items #new .swiper-container", {
		loop:true,
		autoplay:3000,
		speed:300,
		effect:'fade',
		disableOnInteraction:false,
		pagination:'.ctgy-items #new .cate-list',
		paginationClickable:true,
		paginationBulletRender: function (index, className) {
			return '<span class="' + className + '">' + (ctgy[index]) + '</span>';
		}
	});
	var itemSwiper2 = new Swiper(".ctgy-items #hot .swiper-container", {
		loop:true,
		autoplay:3000,
		speed:300,
		effect:'fade',
		disableOnInteraction:false,
		pagination:'.ctgy-items #hot .cate-list',
		paginationClickable:true,
		paginationBulletRender: function (index, className) {
			return '<span class="' + className + '">' + (ctgy[index]) + '</span>';
		}
	});
	var itemSwiper3 = new Swiper(".ctgy-items #best .swiper-container", {
		loop:true,
		autoplay:3000,
		speed:300,
		effect:'fade',
		disableOnInteraction:false,
		pagination:'.ctgy-items #best .cate-list',
		paginationClickable:true,
		paginationBulletRender: function (index, className) {
			return '<span class="' + className + '">' + (ctgy[index]) + '</span>';
		}
	});
	$('.ctgy-items .nav li a').click(function(){
		$(".nav-stripe a").removeClass("on");
		$(this).addClass("on");
		var current = $(this).closest('li').attr('class');
		$('.tab-content').removeClass('current');
		$('.tab-content#'+current).addClass('current');
		return false;
	});

	// best review
	var reivewSwiper1 = new Swiper(".ctgy-review .items li:nth-child(1) .swiper-container", {
		loop:true,
		autoplay:1200,
		speed:600,
		effect:'fade'
	});
	var reivewSwiper2 = new Swiper(".ctgy-review .items li:nth-child(2) .swiper-container", {
		loop:true,
		autoplay:1200,
		speed:600,
		effect:'fade'
	});
	var reivewSwiper3 = new Swiper(".ctgy-review .items li:nth-child(3) .swiper-container", {
		loop:true,
		autoplay:1200,
		speed:600,
		effect:'fade'
	});
	var reivewSwiper4 = new Swiper(".ctgy-review .items li:nth-child(4) .swiper-container", {
		loop:true,
		autoplay:1200,
		speed:600,
		effect:'fade'
	});

	/* living category */
	$("#livingCtgy .panel .hgroup").on("click", function(){
		$(this).parent().toggleClass("current");
		return false;
	});

});
</script>
</head>
<body class="default-font body-main">
	<!-- #include virtual="/lib/inc/incheader.asp" -->
	<!-- contents -->
	<div id="content" class="content gnb-category gnb-living">
		<h1>Living</h1>

		<%'!-- 메인배너 --%>
		<% server.Execute("/living/exc_living_mainbanner.asp") %>

		<%'!-- MD 추천 브랜드 --%>
		<% server.Execute("/living/exc_living_mdbrand.asp") %>

		<%'!-- 기획전 목록 --%>
		<div class="exhibition-list">
			<h2 class="hidden">기획전</h2>
			<div class="list-card type-align-left">
				<ul id="exhibition1">
					<item-list v-for="(item , index) in items" :item="item" :index="index" :key="item.id" v-if="item.gubun == 1 && index < 4"></item-list>
				</ul>
			</div>
		</div>
		

		<%'!-- 신상품/급상승/위시베스트 for ajax--%>
		<div class="ctgy-items">
			<div class="nav nav-stripe nav-stripe-red">
				<ul>
					<li class="new"><a class="on" href="#new" onclick="livingitems(1);return false;">신상품</a></li>
					<li class="hot"><a href="#hot" onclick="livingitems(2);return false;">급상승</a></li>
					<li class="best"><a href="#best" onclick="livingitems(3);return false;">위시베스트</a></li>
				</ul>
			</div>
			<div class="tab-container" id="livingitems"></div>
		</div>

		<%'!-- 기획전 목록 --%>
		<div class="exhibition-list">
			<h2 class="hidden">기획전</h2>
			<div class="list-card type-align-left">
				<ul id="exhibition2">
					<item-list v-for="(item , index) in items" :item="item" :index="index" :key="item.id" v-if="item.gubun == 2 && index < 9"></item-list>
				</ul>
			</div>
		</div>

		<%'!-- 리뷰 베스트 --%>
		<% server.Execute("/living/exc_bestreview.asp") %>

		<%'!-- 기획전 목록 --%>
		<div class="exhibition-list">
			<h2 class="hidden">기획전</h2>
			<div class="list-card type-align-left">
				<ul id="exhibition3">
					<item-list v-for="(item , index) in items" :item="item" :index="index" :key="item.id" v-if="item.gubun == 3 && index < 15"></item-list>
				</ul>
			</div>
		</div>

		<%'!-- 리빙 카테고리 목록 --%>
		<div class="">
			<div id="livingCtgy" class="ctgy-list search-filter">
				<div id="fashionType1" class="panel current">
					<div class="hgroup">
						<a href="#fashionType1">
							<h3>가구/수납</h3>
						</a>
					</div>
					<div class="panelcont">
						<ul class="depth1 one-select">
							<%'정렬상자 호출; sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명 (via functions.asp)%>
							<% Call fnPrntDispCateNavi_2DepthLiving("121","E","fnChgDisp") %>
						</ul>
					</div>
				</div>

				<div id="fashionType2" class="panel">
					<div class="hgroup">
						<a href="#fashionType2">
							<h3>패브릭/생활</h3>
						</a>
					</div>
					<div class="panelcont">
						<ul class="depth1 one-select">
							<%'정렬상자 호출; sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명 (via functions.asp)%>
							<% Call fnPrntDispCateNavi_2DepthLiving("120","E","fnChgDisp") %>
						</ul>
					</div>
				</div>

				<div id="fashionType3" class="panel">
					<div class="hgroup">
						<a href="#fashionType3">
							<h3>데코/조명</h3>
						</a>
					</div>
					<div class="panelcont">
						<ul class="depth1 one-select">
							<%'정렬상자 호출; sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명 (via functions.asp)%>
							<% Call fnPrntDispCateNavi_2DepthLiving("122","E","fnChgDisp") %>
						</ul>
					</div>
				</div>
				<div id="fashionType4" class="panel">
					<div class="hgroup">
						<a href="#fashionType4">
							<h3>키친</h3>
						</a>
					</div>
					<div class="panelcont">
						<ul class="depth1 one-select">
							<%'정렬상자 호출; sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명 (via functions.asp)%>
							<% Call fnPrntDispCateNavi_2DepthLiving("112","E","fnChgDisp") %>
						</ul>
					</div>
				</div>
			</div>
		</div>

	</div>
	<!-- //contents -->
	<script src="/vue/vue.min.js"></script>
	<script src="/vue/vue.lazyimg.min.js"></script>
	<script src="/vue/living.js?v=0.2"></script>
	<script>
	$(function(){
		livingitems(1);

		$('.ctgy-items .nav li a').click(function(){
			$(".nav-stripe a").removeClass("on");
			$(this).addClass("on");
			return false;
		});
	});
	
	// 신상품, 급상승 , 위시베스트
	function livingitems(v){
		var acturl;
		if (v == 1){
			acturl = "/living/act_items_new.asp";
		}else if( v == 2 ){
			acturl = "/living/act_items_up.asp";
		}else if( v == 3){
			acturl = "/living/act_items_wishbest.asp";
		}

		$.ajax({
			url: acturl,
			cache: false,
			success: function(message) {
				if(message!="") {
					$("#livingitems").empty().append(message);
				}
			}
			,error: function(err) {
				alert(err.responseText);
			}
		});
	}

	function fnChgDisp(disp) {
		if ((disp+"").length>3){
			location.href = "/category/category_detail2020.asp?disp="+disp+"&gaparam=living_category_"+disp;
		}
		else{
			location.href = "/category/category_main2020.asp?disp="+disp+"&gaparam=living_category_"+disp;
		}
	}
	</script>
	<!-- #include virtual="/lib/inc/incfooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->