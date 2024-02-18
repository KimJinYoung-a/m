<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 에코백 시리즈 7월 MA
' History : 2017-12-13 김송이 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<style type="text/css">
.finish-event {display:none;}
.ecoBag {background-color:#fff; padding-bottom:1.67rem;}
.ecoBag .topic {position:relative; padding-top:3.5rem; background-color:#fff;}
.ecoBag iframe {position:absolute; top:0; left:0; right:0; width:100%; height:5.5rem;}
.ecoBag .item {position:relative; padding:0 2.38rem 5.3rem; text-align:center; background:#fff;}
.ecoBag .item a {display:block; position:absolute; left:0; top:0; z-index:10; width:100%; height:100%;}
.ecoBag .item .name {margin-top:1.8rem; font-size:1.5rem; line-height:1; font-weight:bold;}
.ecoBag .item .name span {display:block; padding:.7rem 0 1rem; font-size:2rem; }
.ecoBag .item .name em {font-size:1.2rem; line-height:1; letter-spacing:0; font-weight:normal; color:#666;}
.ecoBag .item .price {padding-top:1.92rem; font-size:1.4rem; color:#ff3131; font-weight:bold; }
.ecoBag .item .price s {padding-right:.5rem; color:#868686; font-weight:normal;}
.ecoBag .item .price span {padding-left:.5rem;}
.ecoBag .item .date {position:absolute; top:0; right:2.38rem; z-index:10; display:inline-block; width:15.36rem;}
.ecoBag .swiper {position:relative;}
.ecoBag .swiper .pagination{position:absolute; bottom:4.18rem; z-index:20; left:0; width:100%; height:0.34rem; padding-top:0; }
.ecoBag .swiper .pagination .swiper-pagination-switch {width:2.94rem; height:.34rem; background:url(http://webimage.10x10.co.kr/eventIMG/2018/86441/m/btn_paginaton.png) 0 50% no-repeat; border-radius:0; -webkit-border-radius:0;}
.ecoBag .swiper .pagination .swiper-pagination-switch {margin:0;}
.ecoBag .swiper .pagination .swiper-active-switch {background-position:100% 50%;}
.ecoBag .swiper button {position:absolute; top:9.3rem; z-index:10; width:12.5%; background-color:transparent;}
.ecoBag .swiper .btnPrev {left:.93rem;}
.ecoBag .swiper .btnNext {right:.93rem;}
.slideTemplateV15 {margin-top:1rem;}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script type="text/javascript">
$(function(){
	fnApplyItemInfoEach({
		items:"1963516",
		target:"item",
		fields:["soldout","price"],
		unit:"hw",
		saleBracket:true
});
	mySwiper = new Swiper(".swiper1 .swiper-container",{
		loop:true,
		autoplay:2500,
		speed:800,
		pagination:".swiper1 .pagination",
		paginationClickable:true,
		prevButton:'.swiper1 .btnPrev',
		nextButton:'.swiper1 .btnNext',
		effect:'fade'
	});

	slideTemplate = new Swiper('.slideTemplateV15 .swiper-container',{
		loop:true,
		autoplay:3000,
		autoplayDisableOnInteraction:false,
		speed:800,
		nextButton:'.slideTemplateV15 .btnNext',
		prevButton:'.slideTemplateV15 .btnPrev',
		effect:'fade'
	});
});
</script>
	<!-- 월간(月刊) 에코백 -->
<div class="mEvt86441 ecoBag">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/86441/m/tit_monthly_ecobag.png" alt="월간(月刊) 에코백" /></h2>
	<div class="topic">
		<iframe id="iframe_lucky" src="/event/etc/group/iframe_ecobag.asp?eventid=86441" frameborder="0" scrolling="no" title="월간 에코백 메뉴"></iframe>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/86441/m/tit_ecobag.jpg" alt="#12월호 uncommon things :베이직한 느낌이 좋다. 하지만, 특별하고 싶다." /></div>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/86441/m/txt_story.png" alt="이번 텐바이텐 월간 에코백은 아이띵소와 함께 했습니다." /></p>
	<div class="item item1963516" id="lyrItemList">
		<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86441/m/img_item_1.jpg" alt="" /></div>
		<div class="desc">
			<p class="name">[텐바이텐 단독]<span>DAY 2WAY PACK</span><em>BLACK, BEIGE, NAVY</em></p>
			<p class="price">
				<s>정가</s>할인가<span>할인율</span>
			</p>
		</div>
		<% if date() < "2018-05-27" then %>
		<div class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86441/m/txt_only_2week.png" alt="5.14 ~ 27 단 2주간 단독특가"></div>
		<% end if %>
		<a href="/category/category_itemPrd.asp?itemid=1963516&pEtr=86441" onclick="TnGotoProduct('1963516');return false;"></a>
	</div>
	<a href="/category/category_itemPrd.asp?itemid=1963516&pEtr=86441"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86441/m/txt_material.jpg" alt="MATERIALS 왜 나일론일까? 자주 사용하는 가방일수록 오염에 민감하지만 매일 세탁할 수 없기에, 생활방수가 가능하고 튼튼한 나일론으로 데일리 백을 만들었습니다. 그저 가볍게 슥 닦아내세요. 오랜 사용에도 쉽게 해지지 않아 부담없이 가볍게 들기 좋습니다." /></a>
	<a href="/category/category_itemPrd.asp?itemid=1963516&pEtr=86441"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86441/m/img_size.jpg?v=1" alt="사이즈 비교샷 데일리로 사용하기 알맞게 조정된 사이즈" /></a>
	<div class="swiper swiper1">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/86441/m/tit_rolling.jpg" alt="POCKET 사용자를 배려한 마음 " /></p>
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86441/m/img_slide_1.jpg" alt="자주 꺼내게 되는 텀블러나 우산을 수납하기 좋은 양옆의 오픈 포켓 같아요. 사용하면서 완성하게 되는 가방이랄까요?" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86441/m/img_slide_2.jpg" alt="탈부착이 가능한 내부 지퍼파우치는 필요에 따라 가방을 접어 보관하거나 파우치로 활용" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86441/m/img_slide_3.jpg" alt="큰짐과 섞이지 않도록 작은 소품을 분리수납할 수 있는 내부 두 개의 오픈포켓" /></div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86441/m/btn_prev.png" alt="다음" /></button>
			<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86441/m/btn_next.png" alt="이전" /></button>
		</div>
	</div>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/86441/m/txt_history.jpg" alt="ITEM HISTORY 일상에 최적화된 사이즈와 소재" /></div>
	<a href="/category/category_itemPrd.asp?itemid=1963516&pEtr=86441" onclick="TnGotoProduct('1963516');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86441/m/img_thumb.jpg" alt="" /></a>

	<div class="slideTemplateV15">
		<div class="swiper">
			<div class="txt"><img src="http://webimage.10x10.co.kr/eventIMG/2016/test/m/temp_title.png" alt="" /></div>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86441/m/img_finish_1.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86441/m/img_finish_2.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86441/m/img_finish_3.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86441/m/img_finish_4.jpg" alt="" /></div>
				</div>
			</div>
			<!--<div class="pagination"></div>-->
			<button type="button" class="slideNav btnPrev">이전</button>
			<button type="button" class="slideNav btnNext">다음</button>
		</div>
	</div>

</div>
	<!--// 월간(月刊) 에코백 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->