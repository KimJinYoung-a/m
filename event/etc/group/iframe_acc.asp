<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style>
html, body {position:absolute; top:0; left:0; right:0; backface-visibility:visible; -webkit-backface-visibility:visible; background-color:#e7e7e7;}
.inner {position:absolute; left:0; top:0; width:100%; height:100%;}
.inner button {position:absolute; top:23%; z-index:20; width:18%; background-color:transparent;}
.inner .btnPrev {left:0;}
.inner .btnNext {right:0;}
.inner .pagination {position:absolute; left:0; bottom:3rem; z-index:50; width:100%; height:auto; padding-top:0;}
.inner .pagination span {width:0.9rem; height:0.9rem; margin:0 0.8rem; border:0.15rem solid #ada9ad; cursor:pointer; background-color:transparent; transition:all .3s;}
.inner .pagination .swiper-active-switch {border:#262626; background-color:#262626;}
</style>
<script type="text/javascript" src="/apps/appcom/wish/web2014/lib/js/customapp.js"></script>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.inner .swiper-container',{
		loop:true,
		autoplay:2600,
		speed:800,
		pagination:".pagination",
		paginationClickable:true,
		nextButton:'.btnNext',
		prevButton:'.btnPrev'
	});
});
</script>
</head>
<body>
<div class="inner">
	<div class="swiper-container">
		<% if currentdate < "2017-07-12" then %>
		<%' 1일차(7.11) %>
		<ul class="swiper-wrapper">
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=1002592&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just1_1.jpg" alt="" /></a>
				<a href="" onclick="fnAPPpopupProduct('1002592&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just1_1.jpg" alt="" /></a>
			</li>
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=1646491&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just1_2.jpg" alt="" /></a>
				<a href="" onclick="fnAPPpopupProduct('1646491&amp;pEtr=78997');return false;" class="mApp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just1_2.jpg" alt="" /></a>
			</li>
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=1434197&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just1_3.jpg" alt="" /></a>
				<a href="" onclick="fnAPPpopupProduct('1434197&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just1_3.jpg" alt="" /></a>
			</li>
		</ul>

		<% elseif currentdate < "2017-07-13" then %>
		<%' 2일차(7.12) %>
		<ul class="swiper-wrapper">
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=1748945&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just2_1.jpg" alt="썸머 세트귀걸이+심플 엔틱귀걸이" /></a>
				<a href="" onclick="fnAPPpopupProduct('1748945&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just2_1.jpg" alt="썸머 세트귀걸이+심플 엔틱귀걸이" /></a>
			</li>
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=1748025&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just2_2.jpg" alt="따뜻한 감성시계 로제필드 23종" /></a>
				<a href="" onclick="fnAPPpopupProduct('1748025&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just2_2.jpg" alt="따뜻한 감성시계 로제필드 23종" /></a>
			</li>
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=812303&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just2_3.jpg" alt="carol.36iii" /></a>
				<a href="" onclick="fnAPPpopupProduct('812303&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just2_3.jpg" alt="carol.36iii" /></a>
			</li>
		</ul>

		<% elseif currentdate < "2017-07-14" then %>
		<%' 3일차(7.13) %>
		<ul class="swiper-wrapper">
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=1371322&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just3_1.jpg" alt="할머니일자리선물기부팔찌 위벌스" /></a>
				<a href="" onclick="fnAPPpopupProduct('1371322&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just3_1.jpg" alt="할머니일자리선물기부팔찌 위벌스" /></a>
			</li>
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=1748026&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just3_2.jpg" alt="DKNY / 마크제이콥스 당신을 빛내줄 여성" /></a>
				<a href="" onclick="fnAPPpopupProduct('1748026&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just3_2.jpg" alt="DKNY / 마크제이콥스 당신을 빛내줄 여성" /></a>
			</li>
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=1747908&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just3_3.jpg" alt="여성스러운 롱 귀걸이 원데이 특가" /></a>
				<a href="" onclick="fnAPPpopupProduct('1747908&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just3_3.jpg" alt="여성스러운 롱 귀걸이 원데이 특가" /></a>
			</li>
		</ul>

		<% elseif currentdate < "2017-07-15" then %>
		<%' 4일차(7.14) %>
		<ul class="swiper-wrapper">
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=1693326&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just4_1.jpg" alt="silver dot earring + 레스이즈모어 베스트귀걸이 5종" /></a>
				<a href="" onclick="fnAPPpopupProduct('1693326&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just4_1.jpg" alt="silver dot earring + 레스이즈모어 베스트귀걸이 5종" /></a>
			</li>
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=1659476&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just4_2.jpg" alt="월트디즈니 여성용 주얼리시계 6종" /></a>
				<a href="" onclick="fnAPPpopupProduct('1659476&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just4_2.jpg" alt="월트디즈니 여성용 주얼리시계 6종" /></a>
			</li>
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=91178&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just4_3.jpg" alt="RS-074(BELLGOTHIC글자반지)" /></a>
				<a href="" onclick="fnAPPpopupProduct('91178&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just4_3.jpg" alt="RS-074(BELLGOTHIC글자반지)" /></a>
			</li>
		</ul>

		<% elseif currentdate < "2017-07-16" then %>
		<%' 5일차(7.15) %>
		<ul class="swiper-wrapper">
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=1693326&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just4_1.jpg" alt="silver dot earring + 레스이즈모어 베스트귀걸이 5종" /></a>
				<a href="" onclick="fnAPPpopupProduct('1693326&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just4_1.jpg" alt="silver dot earring + 레스이즈모어 베스트귀걸이 5종" /></a>
			</li>
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=1659476&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just4_2.jpg" alt="월트디즈니 여성용 주얼리시계 6종" /></a>
				<a href="" onclick="fnAPPpopupProduct('1659476&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just4_2.jpg" alt="월트디즈니 여성용 주얼리시계 6종" /></a>
			</li>
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=91178&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just4_3.jpg" alt="RS-074(BELLGOTHIC글자반지)" /></a>
				<a href="" onclick="fnAPPpopupProduct('91178&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just4_3.jpg" alt="RS-074(BELLGOTHIC글자반지)" /></a>
			</li>
		</ul>

		<% elseif currentdate < "2017-07-17" then %>
		<%' 6일차(7.16) %>
		<ul class="swiper-wrapper">
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=1693326&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just4_1.jpg" alt="silver dot earring + 레스이즈모어 베스트귀걸이 5종" /></a>
				<a href="" onclick="fnAPPpopupProduct('1693326&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just4_1.jpg" alt="silver dot earring + 레스이즈모어 베스트귀걸이 5종" /></a>
			</li>
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=1659476&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just4_2.jpg" alt="월트디즈니 여성용 주얼리시계 6종" /></a>
				<a href="" onclick="fnAPPpopupProduct('1659476&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just4_2.jpg" alt="월트디즈니 여성용 주얼리시계 6종" /></a>
			</li>
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=91178&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just4_3.jpg" alt="RS-074(BELLGOTHIC글자반지)" /></a>
				<a href="" onclick="fnAPPpopupProduct('91178&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just4_3.jpg" alt="RS-074(BELLGOTHIC글자반지)" /></a>
			</li>
		</ul>

		<% else %>
		<%' 7일차(7.17) %>
		<ul class="swiper-wrapper">
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=1753058&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just5_1.jpg" alt="제이로렌 SP0100 데일리 실버 발찌 원데이 특가" /></a>
				<a href="" onclick="fnAPPpopupProduct('1753058&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just5_1.jpg" alt="제이로렌 SP0100 데일리 실버 발찌 원데이 특가" /></a>
			</li>
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=1748026&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just5_2.jpg" alt="DKNY / 마크제이콥스 당신을 빛내줄 여성" /></a>
				<a href="" onclick="fnAPPpopupProduct('1748026&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just5_2.jpg" alt="DKNY / 마크제이콥스 당신을 빛내줄 여성" /></a>
			</li>
			<li class="swiper-slide">
				<a href="/category/category_itemPrd.asp?itemid=1431265&amp;pEtr=78997" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just5_3.jpg" alt="송오브송즈 행성 이어링 8종" /></a>
				<a href="" onclick="fnAPPpopupProduct('1431265&amp;pEtr=78997');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/img_just5_3.jpg" alt="송오브송즈 행성 이어링 8종" /></a>
			</li>
		</ul>
		<% end if %>

		<div class="pagination"></div>
		<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/btn_prev.png" alt="이전" /></button>
		<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78997/m/btn_next.png" alt="다음" /></button>
	</div>
</div>
</body>
</html>