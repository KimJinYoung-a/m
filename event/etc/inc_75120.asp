<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 2017 설날에 만난 선물
' History : 2016.12.30 유태욱
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, nowdate, dday

IF application("Svr_Info") = "Dev" THEN
	eCode = "66260"
Else
	eCode = "75120"
End If

nowdate = date()
'nowdate = "2017-01-01"

dday = (right(nowdate,2)+5) mod 7
%>
<style type="text/css">
img {vertical-align:top;}
.newYearTitle {position:relative; }
.rolling {position:absolute; bottom:17.71%; left:4.9%; width:89.84%;}
.rolling .swiper {position:relative;}
.rolling .swiper .pagination{position:absolute; bottom:-9.5%; z-index:20; left:0; width:100%; height:26px;}
.rolling .swiper .swiper-pagination-switch {width:1.3rem; height:1.3rem; margin:0 0.1rem; background:transparent url(http://webimage.10x10.co.kr/eventIMG/2016/75120/m/btn_pagination_v2.png) 100% 100%; background-size:7.5rem 1.3rem}
.rolling .swiper .swiper-active-switch {background-position: 0 0;}
.rolling .swiper .swiper-active-switch:nth-child(2) {background-position: -1.5rem 0;}
.rolling .swiper .swiper-active-switch:nth-child(3) {background-position: -3rem 0;}
.rolling .swiper .swiper-active-switch:nth-child(4) {background-position: -4.5rem 0;}
.rolling .swiper button {position:absolute; bottom:-9.7%; z-index:20; width:2.03%; background-color:transparent; }
.rolling .swiper .btnPrev {left:35.15%;}
.rolling .swiper .btnNext {right:35.15%;}

/* thisWeek */
.thisWeek .dayCounting {position:relative;}
.thisWeek .dayCounting .day {position:absolute; top:24.86%; left:57.18%; width:4.06%;}
.itemList {overflow:hidden;}
.itemList li {float:left; width:50%;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt75120").offset().top}, 0);
});
$(function(){
	mySwiper = new Swiper("#rolling .swiper-container",{
		loop:true,
		autoplay:3000,
		speed:1000,
		pagination:"#rolling .pagination",
		paginationClickable:true,
		prevButton:'#rolling .btnPrev',
		nextButton:'#rolling .btnNext',
		spaceBetween:"0%",
		effect:"fade"
	});
});
</script>
	<!-- 2017 설날에 만난 선물 -->
	<div class="mEvt75120">
		<div class="newYearTitle">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/tit_new_year.jpg" alt="2017 설날에 만난 선물 오래오래 기억될 명절 선물을 찾아서" /></h2>
			<div id="rolling" class="rolling">
				<div class="swiper">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<a href="eventmain.asp?eventid=75121" ><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_slide_01_v2.jpg" alt="1 special event 작년 설엔 어떤 선물을 받았나요?" /></a>
							</div>
							<div class="swiper-slide">
								<a href="eventmain.asp?eventid=75122" ><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_slide_02_v3.jpg" alt="2 special event 나눠 먹으면 행복이 두 배!" /></a>
							</div>
							<div class="swiper-slide">
								<a href="eventmain.asp?eventid=75124" ><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_slide_03_v3.jpg" alt="3 special event 행복을 선물하는 베이킹 클래스" /></a>
							</div>
							<div class="swiper-slide">
								<!-- 01/09 오전9시 아래 a 태그를 <a href="eventmain.asp?eventid=75125" ><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_slide_04_v5.jpg" alt="4 hot brand 맛과 건강, IN SEASON" /></a> 로 변경 -->
								<!-- 01/16 오전9시 아래 a 태그를 <a href="eventmain.asp?eventid=75558" ><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_slide_04_v6.jpg" alt="첨가물 없이 비우고 채우다 건강 한차 다비채" /></a> 로 변경 -->
								<% if date < "2017-01-16" then %>
									<a href="eventmain.asp?eventid=75125" ><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_slide_04_v5.jpg" alt="4 hot brand 맛과 건강, IN SEASON" /></a>
								<% else %>
									<a href="eventmain.asp?eventid=75558" ><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_slide_04_v6.jpg" alt="첨가물 없이 비우고 채우다 건강 한차 다비채" /></a>
								<% end if %>
							</div>
						</div>
					</div>
					<div class="pagination"></div>
					<button type="button" class="slideNav btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/btn_prev.png" alt="" /></button>
					<button type="button" class="slideNav btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/btn_next.png" alt="" /></button>
				</div>
			</div>
		</div>
		<!-- thisWeek -->
		<div class="thisWeek">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/txt_only_week.jpg" alt="오직 일주일의 특가" /></h3>
			<%'' for dev msg 남은 특가 일수에 따라 class="day" 의 이미지를 변경해 주세요./ 이미지파일명은 "txt_num_남은 일수.png" 입니다.%>
			<!-- for dev msg txt_d_day_count.jpg 를 txt_d_day_last.jpg 로 교체해 주세요. class="day" 숨겨주세요-->
			<% if date >= "2017-01-23" then %>
				<p class="dayCounting"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/txt_d_day_last.jpg" alt="취향저격 명절선물 특가! # 일 남았습니다" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/dday/txt_num_0<%=dday+1%>.png" alt=""/></span></p>
			<% else %>
				<p class="dayCounting"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/txt_d_day_count.jpg" alt="취향저격 명절선물 특가! # 일 남았습니다" /><span class="day"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/dday/txt_num_0<%=dday+1%>.png" alt=""/></span></p>
			<% end if %>
			
			<% if date <= "2017-01-08" then %>
				<%'' 1주차 %>
				<div class="thisWeekPrice">
					<ul class="itemList mWeb">
						<li><a href="/category/category_itemPrd.asp?itemid=1285004&pEtr=75120"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_01_01.jpg" alt="닥터넛츠 오리지널 뉴 30개입 패키지" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=1620226&pEtr=75120"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_01_02.jpg" alt="달콤하고 바삭한 맛군 달추칩" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=1621594&pEtr=75120"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_01_03.jpg" alt="젠미야 블랙 선물세트" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=1626462&pEtr=75120"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_01_04.jpg" alt="[마이빈스 더치커피] 새해기원 선물세트 (210mlx4병)" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=1620012&pEtr=75120"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_01_05.jpg" alt="건강선물 맛있는수제차 패키지" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=1552452&pEtr=75120"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_01_06.jpg" alt="향기로운 허니트리플-FRAGRANT HONEY TRIPLE SET" /></a></li>
					</ul>
					<ul class="itemList mApp">
						<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1285004&pEtr=75120" onclick="fnAPPpopupProduct('1285004&pEtr=75120');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_01_01.jpg" alt="닥터넛츠 오리지널 뉴 30개입 패키지" /></a></li>
						<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1620226&pEtr=75120" onclick="fnAPPpopupProduct('1620226&pEtr=75120');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_01_02.jpg" alt="달콤하고 바삭한 맛군 달추칩" /></a></li>
						<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1621594&pEtr=75120" onclick="fnAPPpopupProduct('1621594&pEtr=75120');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_01_03.jpg" alt="젠미야 블랙 선물세트" /></a></li>
						<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1626462&pEtr=75120" onclick="fnAPPpopupProduct('1626462&pEtr=75120');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_01_04.jpg" alt="[마이빈스 더치커피] 새해기원 선물세트 (210mlx4병)" /></a></li>
						<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1620012&pEtr=75120" onclick="fnAPPpopupProduct('1620012&pEtr=75120');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_01_05.jpg" alt="건강선물 맛있는수제차 패키지" /></a></li>
						<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1552452&pEtr=75120" onclick="fnAPPpopupProduct('1552452&pEtr=75120');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_01_06.jpg" alt="향기로운 허니트리플-FRAGRANT HONEY TRIPLE SET" /></a></li>
					</ul>
				</div>
				<div class="thisWeekBrand">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/txt_recommend_brand.jpg" alt="오직 일주일의 특가" /></h3>
					<ul class="mWeb">
						<li><a href="/street/street_brand.asp?makerid=altdif"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_bnr_01_01_v2.jpg" alt="항상 맛있는 홍차를 마시는 습관 ALTDIF" /></a></li>
						<li><a href="/street/street_brand.asp?makerid=jcdelimeats"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_bnr_01_02_v2.jpg" alt="엄선한 육가공품 브랜드 JOHNCOOK DELI MEATS" /></a></li>
						<li><a href="/street/street_brand.asp?makerid=i2corp"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_bnr_01_03_v3.jpg" alt="상큼하게 즐기는 비타민구미 RAINBOW LIGTH" /></a></li>
					</ul>
					<ul class="mApp">
						<li><a href="/street/street_brand.asp?makerid=altdif" onclick="fnAPPpopupBrand('altdif'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_bnr_01_01_v2.jpg" alt="항상 맛있는 홍차를 마시는 습관 ALTDIF" /></a></li>
						<li><a href="/street/street_brand.asp?makerid=jcdelimeats" onclick="fnAPPpopupBrand('jcdelimeats'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_bnr_01_02_v2.jpg" alt="엄선한 육가공품 브랜드 JOHNCOOK DELI MEATS" /></a></li>
						<li><a href="/street/street_brand.asp?makerid=i2corp" onclick="fnAPPpopupBrand('i2corp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_bnr_01_03_v3.jpg" alt="상큼하게 즐기는 비타민구미 JOHNCOOK DELI MEATS" /></a></li>
					</ul>
				</div>
			<% elseif date >= "2017-01-09" and date <= "2017-01-15" then %>
				<%'' 2주차 %>
				<div class="thisWeekPrice">
					<ul class="itemList mWeb">
						<li><a href="/category/category_itemPrd.asp?itemid=1616984&pEtr=75120"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_02_01_v2.jpg" alt="[꽃을담다] 꽃차 1+2 기획세트" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=1620224&pEtr=75120"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_02_02.jpg" alt="일건식 아로니아즙 30포" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=1632702&pEtr=75120"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_02_03.jpg" alt="현미 연강정 산자 선물세트" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=1536909&pEtr=75120"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_02_04.jpg" alt="인테이크 힘내! 오렌지맛 멀티구미 (30일 섭취량, 252g×1병)" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=1632380&pEtr=75120"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_02_05.jpg" alt="리틀스커피 PREMIUM 커피 선물세트" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=1630094&pEtr=75120"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_02_06.jpg" alt="슈퍼너츠2종+슈퍼잼1종 선물세트" /></a></li>
					</ul>
					<ul class="itemList mApp">
						<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1616984&pEtr=75120" onclick="fnAPPpopupProduct('1616984&pEtr=75120');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_02_01_v2.jpg" alt="[꽃을담다] 꽃차 1+2 기획세트" /></a></li>
						<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1620224&pEtr=75120" onclick="fnAPPpopupProduct('1620224&pEtr=75120');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_02_02.jpg" alt=" 일건식 아로니아즙 30포" /></a></li>
						<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1632702&pEtr=75120" onclick="fnAPPpopupProduct('1632702&pEtr=75120');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_02_03.jpg" alt="현미 연강정 산자 선물세트" /></a></li>
						<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1536909&pEtr=75120" onclick="fnAPPpopupProduct('1536909&pEtr=75120');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_02_04.jpg" alt="인테이크 힘내! 오렌지맛 멀티구미 (30일 섭취량, 252g×1병)" /></a></li>
						<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1632380&pEtr=75120" onclick="fnAPPpopupProduct('1632380&pEtr=75120');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_02_05.jpg" alt="리틀스커피 PREMIUM 커피 선물세트" /></a></li>
						<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1630094&pEtr=75120" onclick="fnAPPpopupProduct('1630094&pEtr=75120');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_02_06.jpg" alt="슈퍼너츠2종+슈퍼잼1종 선물세트" /></a></li>
					</ul>
				</div>
				<div class="thisWeekBrand">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/txt_recommend_brand.jpg" alt="오직 일주일의 특가" /></h3>
					<ul class="mWeb">
						<li><a href="/street/street_brand.asp?makerid=alohwa"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_bnr_02_01.jpg" alt="꽃으로 당신의 삶을 향기롭게 ALOHWA" /></a></li>
						<li><a href="/street/street_brand.asp?makerid=zenmiyaofficial"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_bnr_02_02.jpg" alt="맛있는 요리를 위한 소스와 키친아이템 ZENMIYA" /></a></li>
						<li><a href="/street/street_brand.asp?makerid=matgoon"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_bnr_02_03.jpg" alt="순수 자연의 맛 MATGOON" /></a></li>
					</ul>
					<ul class="mApp">
						<li><a href="/street/street_brand.asp?makerid=alohwa" onclick="fnAPPpopupBrand('alohwa'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_bnr_02_01.jpg" alt="꽃으로 당신의 삶을 향기롭게 ALOHWA" /></a></li>
						<li><a href="/street/street_brand.asp?makerid=zenmiyaofficial" onclick="fnAPPpopupBrand('zenmiyaofficial'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_bnr_02_02.jpg" alt="맛있는 요리를 위한 소스와 키친아이템 ZENMIYA" /></a></li>
						<li><a href="/street/street_brand.asp?makerid=matgoon" onclick="fnAPPpopupBrand('matgoon'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_bnr_02_03.jpg" alt="순수 자연의 맛 MATGOON" /></a></li>
					</ul>
				</div>

			<% elseif date >= "2017-01-16" and date <= "2017-01-23" then %>
				<%'' 3주차 %>
				<div class="thisWeekPrice">
					<ul class="itemList mWeb">
						<li><a href="/category/category_itemPrd.asp?itemid=1626461&pEtr=75120"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_03_01.jpg" alt="[마이빈스 더치커피] 새해기원 선물세트 (250mlx4병)" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=1417458&pEtr=75120"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_03_02.jpg" alt="[콜록콜록] 한첩 SET" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=1547074&pEtr=75120"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_03_03.jpg" alt="인테이크 힘내 홍삼 젤리스틱 (30일 섭취량, 15gx30포)" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=1558536&pEtr=75120"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_03_04.jpg" alt="프렌비 벌꿀 3종 -풍요로운 선물" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=1635627&pEtr=75120"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_03_05.jpg" alt="sweet teatime 수제잼 선물세트" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=915264&pEtr=75120"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_03_06.jpg" alt="[1+1]해일 명품감말랭이 선물세트-지함1호(감말랭이100g×6봉)2박스" /></a></li>
					</ul>
					<ul class="itemList mApp">
						<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1626461&pEtr=75120" onclick="fnAPPpopupProduct('1626461&pEtr=75120');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_03_01.jpg" alt="[마이빈스 더치커피] 새해기원 선물세트 (250mlx4병)" /></a></li>
						<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1417458&pEtr=75120" onclick="fnAPPpopupProduct('1417458&pEtr=75120');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_03_02.jpg" alt=" [콜록콜록] 한첩 SET" /></a></li>
						<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1547074&pEtr=75120" onclick="fnAPPpopupProduct('1547074&pEtr=75120');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_03_03.jpg" alt="인테이크 힘내 홍삼 젤리스틱 (30일 섭취량, 15gx30포)" /></a></li>
						<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1558536&pEtr=75120" onclick="fnAPPpopupProduct('1558536&pEtr=75120');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_03_04.jpg" alt="프렌비 벌꿀 3종 -풍요로운 선물" /></a></li>
						<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1635627&pEtr=75120" onclick="fnAPPpopupProduct('1635627&pEtr=75120');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_03_05.jpg" alt="sweet teatime 수제잼 선물세트" /></a></li>
						<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=915264&pEtr=75120" onclick="fnAPPpopupProduct('915264&pEtr=75120');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_item_03_06.jpg" alt="[1+1]해일 명품감말랭이 선물세트-지함1호(감말랭이100g×6봉)2박스" /></a></li>
					</ul>
				</div>
				<div class="thisWeekBrand">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/txt_recommend_brand.jpg" alt="오직 일주일의 특가" /></h3>
					<ul class="mWeb">
						<li><a href="/street/street_brand.asp?makerid=jamong10"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_bnr_03_01.jpg" alt="SUPER JAM & NUTS" /></a></li>
						<li><a href="/street/street_brand.asp?makerid=sogobang"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_bnr_03_02.jpg" alt="SOHADONG GOBANG" /></a></li>
						<li><a href="/street/street_brand.asp?makerid=mybeans10"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_bnr_03_03.jpg" alt="MYBEANS" /></a></li>
					</ul>
					<ul class="mApp">
						<li><a href="/street/street_brand.asp?makerid=jamong10" onclick="fnAPPpopupBrand('jamong10'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_bnr_03_01.jpg" alt="SUPER JAM & NUTS" /></a></li>
						<li><a href="/street/street_brand.asp?makerid=sogobang" onclick="fnAPPpopupBrand('sogobang'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_bnr_03_02.jpg" alt="SOHADONG GOBANG" /></a></li>
						<li><a href="/street/street_brand.asp?makerid=mybeans10" onclick="fnAPPpopupBrand('mybeans10'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75120/m/img_bnr_03_03.jpg" alt="MYBEANS" /></a></li>
					</ul>
				</div>
			<% end if %>
		</div>
		<!-- //thisWeek -->
	</div>
	<!-- //2017 설날에 만난 선물 -->