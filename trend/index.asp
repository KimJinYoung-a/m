<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	'TREND 2017-08-21 생성
	'vue.js 사용
	'/trend/data_api 사용

Dim tempdiv , temptime

'//현재 나타날 템플릿 번호 / 시간
tempdiv = CInt((Hour(time) * 60 + Minute(time)) / 20 Mod 13)
temptime = CInt((Hour(time) * 60 + Minute(time)) Mod 20) 
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style>[v-cloak] { display: none; }</style>
<script>
function jsDownCoupon(idx){
	if ("<%=IsUserLoginOK%>"=="False") {
		jsChklogin('<%=IsUserLoginOK%>');
		return;
	}

	var frm;
	frm = document.frmC;
	frm.stype.value = 'prd';
	frm.idx.value = idx;
	frm.submit();
}

$(function(){
	<% if tempdiv >= 1 then %>$('#ifec').after($('#ifop'));<% end if %>
	<% if tempdiv >= 2 then %>$('#ifop').after($('#ify'));<% end if %>
	<% if tempdiv >= 3 then %>$('#ify').after($('#ifsch1'));<% end if %>
	<% if tempdiv >= 4 then %>$('#ifsch1').after($('#ifops'));<% end if %>
	<% if tempdiv >= 5 then %>$('#ifops').after($('#ifmsb'));<% end if %>
	<% if tempdiv >= 6 then %>$('#ifmsb').after($('#ifosb'));<% end if %>
	<% if tempdiv >= 7 then %>$('#ifosb').after($('#ifnb'));<% end if %>
	<% if tempdiv >= 8 then %>$('#ifnb').after($('#ifsch2'));<% end if %>
	<% if tempdiv >= 9 then %>$('#ifsch2').after($('#ifyw'));<% end if %>
	<% if tempdiv >= 10 then %>$('#ifyw').after($('#ifow'));<% end if %>
	<% if tempdiv >= 11 then %>$('#ifow').after($('#efed'));<% end if %>
	<% if tempdiv >= 12 then %>$('#efed').after($('#ifhk'));<% end if %>
});
</script>
</head>
<body class="default-font body-main">
<!-- #include virtual="/lib/inc/incheader.asp" -->
<div id="content" class="content">
	<article class="trend">
		<h2 class="hidden">트렌드</h2>
		<div class="update-time">
			<p><span><%=temptime%></span>분 전 업데이트</p>
		</div>

		<%' 지금, 다른 사람들은 어떤 상품을 샀을까? %>
		<section class="broadcast" id="ifop" v-cloak>
			<div class="icon icon-wallet">
				<svg viewBox="0 0 43 49">
					<path fill="#2985F7" d="M21.498 1C10.177 1 1 10.305 1 21.784c0 11.478 9.177 20.783 20.498 20.783.707 0-1.474 4.69-1.474 4.69s21.546-6.342 21.971-25.473C42.25 10.309 32.818 1 21.498 1z" />
				</svg>
			</div>
			<h3>지금, 다른 사람들은<br /> 어떤 상품을 샀을까?</h3>
			<div class="items type-column type-column-2">
				<ul>
					<item-list v-for="item in items" :item="item" :key="item.gubun" v-if="item.gubun == 1"></item-list>
				</ul>
			</div>
		</section>

		<%' USERNAME 님 이런 상품은 어때요? %>
		<div id="ify" v-cloak style="display:<%=chkiif(GetLoginUserName()="","none","")%>;" v-if="items.length">
			<section class="broadcast" >
				<div class="icon icon-magic-stick">
					<svg viewBox="0 0 43 49">
						<path fill="#ff5281" d="M21.498 1C10.177 1 1 10.305 1 21.784c0 11.478 9.177 20.783 20.498 20.783.707 0-1.474 4.69-1.474 4.69s21.546-6.342 21.971-25.473C42.25 10.309 32.818 1 21.498 1z" />
					</svg>
				</div>
				<h3><span class="myname"><%=GetLoginUserName()%></span>님,<br /> 이런 상품은 어때요?</h3>
				<div class="items type-column type-column-3">
					<ul>
						<item-list v-for="item in items" :item="item" :key="item.gubun" v-if="item.gubun == 2"></item-list>
					</ul>
				</div>
			</section>
		</div>

		<%' 급상승 키워드 1 %>
		<div id="ifsch1" v-cloak>
			<section class="broadcast" v-for="item in items" :item="item" :key="item.id" v-if="item.search1">
				<div class="icon icon-up">
					<svg viewBox="0 0 43 49">
						<path fill="#5063ff" d="M21.498 1C10.177 1 1 10.305 1 21.784c0 11.478 9.177 20.783 20.498 20.783.707 0-1.474 4.69-1.474 4.69s21.546-6.342 21.971-25.473C42.25 10.309 32.818 1 21.498 1z" />
					</svg>
				</div>
				<h3>급상승 키워드<br /> <a :href="item.klink1" style="color:#3a4ef2;">#{{item.keyword1}}</a></h3>
				<div class="type-photowall">
					<ul>
						<search-list v-for="sub in item.search1" :sub="sub" :key="sub.gubun"></search-list>
					</ul>
				</div>
				<div class="btn-group">
					<a :href="item.klink1" class="btn-plus color-blue"><span v-if="item.keyword1" class="icon icon-plus icon-plus-blue"></span>{{item.keyword1}} 더 보기</a>
				</div>
			</section>
		</div>

		<%'지금 다른 사람들은 이 상품을 보고 있어요!%>
		<section class="broadcast" id="ifops" v-cloak>
			<div class="icon icon-eyeglasses">
				<svg viewBox="0 0 43 49">
					<path fill="#8960f1" d="M21.498 1C10.177 1 1 10.305 1 21.784c0 11.478 9.177 20.783 20.498 20.783.707 0-1.474 4.69-1.474 4.69s21.546-6.342 21.971-25.473C42.25 10.309 32.818 1 21.498 1z" />
				</svg>
			</div>
			<h3>지금, 다른 사람들은<br /> 이 상품을 보고 있어요!</h3>
			<div class="items type-column type-column-2">
				<ul>
					<item-list v-for="item in items" :item="item" :key="item.gubun" v-if="item.gubun == 4"></item-list>
				</ul>
			</div>
		</section>

		<%' USERNAME 의 장바구니 상품이 할인 중입니다!.%>
		<div id="ifmsb" v-cloak style="display:<%=chkiif(GetLoginUserName()="","none","")%>;" v-if="items.length">
			<section class="broadcast">
				<div class="icon icon-percent">
					<svg viewBox="0 0 43 49">
						<path fill="#ff2f16" d="M21.498 1C10.177 1 1 10.305 1 21.784c0 11.478 9.177 20.783 20.498 20.783.707 0-1.474 4.69-1.474 4.69s21.546-6.342 21.971-25.473C42.25 10.309 32.818 1 21.498 1z" />
					</svg>
				</div>
				<h3><span class="myname"><%=GetLoginUserName()%></span>님의<br /> 장바구니 상품이 할인 중입니다!</h3>

				<div class="items type-full">
					<ul>
						<item-list v-for="item in items" :item="item" :key="item.gubun" v-if="item.gubun == 5"></item-list>
					</ul>
				</div>
				
				<div class="btn-group">
					<a href="/inipay/ShoppingBag.asp?gaparam=trend_mycart_0" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span>장바구니 바로가기</a>
				</div>
			</section>
		</div>

		<%' 다른 사람들의 장바구니에 상품이 담기고 있음%>
		<section class="broadcast" id="ifosb" v-cloak>
			<div class="icon icon-shoppingbag">
				<svg viewBox="0 0 43 49">
					<path fill="#2985f7" d="M21.498 1C10.177 1 1 10.305 1 21.784c0 11.478 9.177 20.783 20.498 20.783.707 0-1.474 4.69-1.474 4.69s21.546-6.342 21.971-25.473C42.25 10.309 32.818 1 21.498 1z" />
				</svg>
			</div>
			<h3>지금, 다른 사람들의 장바구니에<br /> 이 상품이 담기고 있어요!</h3>
			<div class="items type-column type-column-2">
				<ul>
					<item-list v-for="item in items" :item="item" :key="item.gubun" v-if="item.gubun == 6"></item-list>
				</ul>
			</div>
		</section>

		<%' 주목할만한 브랜드%>
		<section class="broadcast" id="ifnb" v-cloak>
			<div class="icon icon-eyeglasses">
				<svg viewBox="0 0 43 49">
					<path fill="#8960f1" d="M21.498 1C10.177 1 1 10.305 1 21.784c0 11.478 9.177 20.783 20.498 20.783.707 0-1.474 4.69-1.474 4.69s21.546-6.342 21.971-25.473C42.25 10.309 32.818 1 21.498 1z" />
				</svg>
			</div>
			<h3>주목할만한 브랜드<br /> <a :href="brandurl" style="color:#7d4fee;">{{brandname}}</a></h3>
			<div class="items type-column type-column-3">
				<ul>
					<item-list v-for="item in items" :item="item" :key="item.gubun" v-if="item.gubun == 7"></item-list>
				</ul>
			</div>
			<div class="btn-group">
				<a :href="brandurl" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span>{{brandname}} 상품 더 보기</a>
			</div>
		</section>

		<%' 급상승 키워드 2%>
		<div id="ifsch2" v-cloak>
			<section class="broadcast" v-for="item in items" :item="item" :key="item.id" v-if="item.search2">
				<div class="icon icon-up">
					<svg viewBox="0 0 43 49">
						<path fill="#5063ff" d="M21.498 1C10.177 1 1 10.305 1 21.784c0 11.478 9.177 20.783 20.498 20.783.707 0-1.474 4.69-1.474 4.69s21.546-6.342 21.971-25.473C42.25 10.309 32.818 1 21.498 1z" />
					</svg>
				</div>
				<h3>급상승 키워드<br /> <a :href="item.klink2" style="color:#3d52ff;">#{{item.keyword2}}</a></h3>
				<div class="type-photowall">
					<ul>
						<search-list v-for="sub in item.search2" :sub="sub" :key="sub.gubun"></search-list>
					</ul>
				</div>
				<div class="btn-group">
					<a :href="item.klink2" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span>{{item.keyword2}} 더 보기</a>
				</div>
			</section>
		</div>

		<%' USERNAME 님의 WISH 상품이 할인 중 입니다!. %>
		<div id="ifyw" v-cloak style="display:<%=chkiif(GetLoginUserName()="","none","")%>;" v-if="items.length">
			<section class="broadcast">
				<div class="icon icon-percent">
					<svg viewBox="0 0 43 49">
						<path fill="#ff2f16" d="M21.498 1C10.177 1 1 10.305 1 21.784c0 11.478 9.177 20.783 20.498 20.783.707 0-1.474 4.69-1.474 4.69s21.546-6.342 21.971-25.473C42.25 10.309 32.818 1 21.498 1z" />
					</svg>
				</div>
				<h3><span class="myname"><%=GetLoginUserName()%></span>님의<br /> WISH 상품이 할인 중입니다!</h3>

				<div class="items type-full">
					<ul>
						<item-list v-for="item in items" :item="item" :key="item.gubun" v-if="item.gubun == 9"></item-list>
					</ul>
				</div>
				
				<div class="btn-group">
					<a href="/my10x10/mywish/mywish.asp?gaparam=trend_mywish_0" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span>MY WISH 더 보기</a>
				</div>
			</section>
		</div>

		<%' 지금 위시를 가장 많이 받는 상품! .  %>
		<section class="broadcast" id="ifow" v-cloak>
			<div class="icon icon-heart">
				<svg viewBox="0 0 43 49">
					<path fill="#ff5281" d="M21.498 1C10.177 1 1 10.305 1 21.784c0 11.478 9.177 20.783 20.498 20.783.707 0-1.474 4.69-1.474 4.69s21.546-6.342 21.971-25.473C42.25 10.309 32.818 1 21.498 1z" />
				</svg>
			</div>
			<h3>지금, WISH를<br /> 가장 많이 받는 상품!</h3>
			<div class="items type-column type-column-2">
				<ul>
					<item-list v-for="item in items" :item="item" :key="item.gubun" v-if="item.gubun == 10"></item-list>
				</ul>
			</div>
		</section>

		<%' 서두르세요 종료 임박 추천 기획전 %>
		<section class="broadcast" id="efed" v-cloak>
			<div class="icon icon-clock">
				<svg viewBox="0 0 43 49">
					<path fill="#ff2f16" d="M21.498 1C10.177 1 1 10.305 1 21.784c0 11.478 9.177 20.783 20.498 20.783.707 0-1.474 4.69-1.474 4.69s21.546-6.342 21.971-25.473C42.25 10.309 32.818 1 21.498 1z" />
				</svg>
			</div>
			<h3>서두르세요<br /> 종료 임박 추천 기획전</h3>
			<div class="list-card type-align-center">
				<ul>
					<evt-list v-for="item in items" :item="item" :key="item.gubun" v-if="item.gubun == 11"></evt-list>
				</ul>
			</div>
			<div class="btn-group">
				<a href="/shoppingtoday/shoppingchance_allevent.asp?scTgb=planevt&selOP=1&gaparam=trend_event_0" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span>마감 임박 기획전 더 보기</a>
			</div>
		</section>

		<%' 인기 급상승 카테고리 %>
		<section class="broadcast" id="ifhk" v-cloak>
			<div class="icon icon-up">
				<svg viewBox="0 0 43 49">
					<path fill="#5063ff" d="M21.498 1C10.177 1 1 10.305 1 21.784c0 11.478 9.177 20.783 20.498 20.783.707 0-1.474 4.69-1.474 4.69s21.546-6.342 21.971-25.473C42.25 10.309 32.818 1 21.498 1z" />
				</svg>
			</div>
			<h3>인기 급상승 카테고리<br /> <a :href="cateurl" style="color:#5063ff;">{{catename}}</a></h3>
			<div class="items type-column type-column-3">
				<ul>
					<item-list v-for="item in items" :item="item" :key="item.gubun" v-if="item.gubun == 12"></item-list>
				</ul>
			</div>
			<div class="btn-group">
				<a :href="cateurl" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span>{{catename}} 더 보기</a>
			</div>
		</section>

		<%' 서두르세요 쿠폰 할인이 곧 종료됩니다! %>
		<section class="broadcast" id="ifec" v-cloak>
			<div class="icon icon-clock">
				<svg viewBox="0 0 43 49">
					<path fill="#ff2f16" d="M21.498 1C10.177 1 1 10.305 1 21.784c0 11.478 9.177 20.783 20.498 20.783.707 0-1.474 4.69-1.474 4.69s21.546-6.342 21.971-25.473C42.25 10.309 32.818 1 21.498 1z" />
				</svg>
			</div>
			<h3>서두르세요<br /> 쿠폰 할인이 곧 종료됩니다!</h3>
			<div class="coupon-list">
				<ul>
					<coupon-list v-for="item in items" :item="item" :key="item.gubun" v-if="item.gubun == 13"></coupon-list>
				</ul>
			</div>

			<div class="btn-group">
				<a href="/shoppingtoday/couponshop.asp?gaparam=trend_coupon_0" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span>쿠폰북 더 보기</a>
			</div>
		</section>

		<% if IsUserLoginOK = FALSE then %>
			<div class="more-than-recommend">
				<p>로그인을 하시면<br /> <em>고객님만을 위한 더 많은 상품을 추천해 드립니다</em></p>
				<div class="btn-group">
					<a href="/member/join.asp">회원가입</a>
					<a href="javascript:jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/trend/")%>');">로그인</a>
				</div>
			</div>
		<% end if %>
	</article>
</div>
<form name="frmC" method="post" action="/shoppingtoday/couponshop_process.asp" style="margin:0px;">
<input type="hidden" name="stype" value="">
<input type="hidden" name="idx" value="">
</form>
<!-- #include virtual="/lib/inc/incfooter.asp" -->
<script src="/vue/vue.min.js"></script>
<script src="/vue/trend.js?v=1.1"></script>
</body>
</html>