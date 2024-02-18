<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
</head>
<body class="default-font body-main">
	<div id="content" class="content fashion-main">
		<h1>Fashion</h1>
		<%'!-- 메인배너 --%>
		<div class="fashion-main-bnr">
			<div class="swiper-container">
				<div class="swiper-wrapper" id="rollingbanner">
					<item-rolling v-for="item in items" :item="item" :key="item.gubun" :isapp="1" v-if="item.gubun == 1 || item.gubun == 2 "></item-rolling>
				</div>
			</div>
		</div>

		<%'!-- 패션 키워드 --%>
		<% server.Execute("/fashion/exc_fashion_keyword.asp") %>

		<%'!-- 핫 브랜드 --%>
		<div class="fashion-brand">
			<h2><small>Fashion Best Brand</small>주목해야 하는 핫한 브랜드!</h2>
			<div class="swiper-container">
				<div class="swiper-wrapper" id="hotbrand">
					<brand-list v-for="(item , index) in items" :item="item" :index="index" :isapp="1" :key="item.id"></brand-list>
				</div>
			</div>
		</div>

		<%'!-- 기획전 목록 --%>
		<div class="exhibition-list">
			<h2 class="hidden">기획전</h2>
			<div class="list-card type-align-left">
				<ul id="exhibition1">
					<item-list v-for="(item , index) in items" :item="item" :index="index" :isapp="1" :key="item.id" v-if="item.gubun == 3 && index < 11"></item-list>
				</ul>
			</div>
		</div>

		<%'!-- 신상품/급상승/위시베스트 for ajax--%>
		<div class="fashion-items">
			<div class="nav nav-stripe nav-stripe-red">
				<ul>
					<li class="new"><a class="on" href="#new" onclick="fashionitems(1);return false;">신상품</a></li>
					<li class="hot"><a href="#hot" onclick="fashionitems(2);return false;">급상승</a></li>
					<li class="best"><a href="#best" onclick="fashionitems(3);return false;">위시베스트</a></li>
				</ul>
			</div>
			<div class="tab-container" id="fashionitems"></div>
		</div>

		<%'!-- 기획전 목록 --%>
		<div class="exhibition-list">
			<h2 class="hidden">기획전</h2>
			<div class="list-card type-align-left">
				<ul id="exhibition2">
					<item-list v-for="(item , index) in items" :item="item" :index="index" :isapp="1" :key="item.id" v-if="item.gubun == 4 && index < 15"></item-list>
				</ul>
			</div>
		</div>

		<%'!-- 리뷰 베스트 --%>
		<% server.Execute("/fashion/exc_bestreview.asp") %>
		
		<%'!-- 패션 카테고리 목록 --%>
		<div class="">
			<div id="fashionCtgy" class="fashion-category search-filter">
				<div id="fashionType1" class="panel current">
					<div class="hgroup">
						<a href="#fashionType1">
							<h3>패션의류</h3>
						</a>
					</div>
					<div class="panelcont">
						<ul class="depth1 one-select">
							<%'정렬상자 호출; sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명 (via functions.asp)%>
							<% Call fnPrntDispCateNavi_2Depth("117","E","fnAPPpopupCategory") %>
						</ul>
					</div>
				</div>

				<div id="fashionType2" class="panel">
					<div class="hgroup">
						<a href="#fashionType2">
							<h3>패션잡화</h3>
						</a>
					</div>
					<div class="panelcont">
						<ul class="depth1 one-select">
							<%'정렬상자 호출; sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명 (via functions.asp)%>
							<% Call fnPrntDispCateNavi_2Depth("116","E","fnAPPpopupCategory") %>
						</ul>
					</div>
				</div>

				<div id="fashionType3" class="panel">
					<div class="hgroup">
						<a href="#fashionType3">
							<h3>뷰티</h3>
						</a>
					</div>
					<div class="panelcont">
						<ul class="depth1 one-select">
							<%'정렬상자 호출; sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명 (via functions.asp)%>
							<% Call fnPrntDispCateNavi_2Depth("118","E","fnAPPpopupCategory") %>
						</ul>
					</div>
				</div>
				<div id="fashionType4" class="panel">
					<div class="hgroup">
						<a href="#fashionType4">
							<h3>주얼리/시계</h3>
						</a>
					</div>
					<div class="panelcont">
						<ul class="depth1 one-select">
							<%'정렬상자 호출; sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명 (via functions.asp)%>
							<% Call fnPrntDispCateNavi_2Depth("125","E","fnAPPpopupCategory") %>
						</ul>
					</div>
				</div>
			</div>
		</div>

	</div>
	<!-- //contents -->
	<script src="/vue/vue.min.js"></script>
	<script src="/vue/vue.lazyimg.min.js"></script>
	<script src="/vue/fashion.js?v=1.11"></script>
	<script>
	$(function(){
		/* fashion category */
		$("#fashionCtgy .panel .hgroup").on("click", function(){
			$(this).parent().toggleClass('current');
			return false;
		});

		fashionitems(1);

		$('.fashion-items .nav li a').click(function(){
			$(".nav-stripe a").removeClass("on");
			$(this).addClass("on");
			return false;
		});
	});
	
	// 신상품, 급상승 , 위시베스트
	function fashionitems(v){
		var acturl;
		if (v == 1){
			acturl = "/fashion/act_items_new.asp";
		}else if( v == 2 ){
			acturl = "/fashion/act_items_up.asp";
		}else if( v == 3){
			acturl = "/fashion/act_items_wishbest.asp";
		}

		$.ajax({
			url: acturl,
			cache: false,
			success: function(message) {
				if(message!="") {
					$("#fashionitems").empty().append(message);
				}
			}
			,error: function(err) {
				alert(err.responseText);
			}
		});
	}
	</script>
<!-- #include virtual="/apps/appcom/wish/web2014/lib/incfooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->