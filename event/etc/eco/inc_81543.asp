<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 에코백 시리즈 11월 MA
' History : 2017-10-31 김송이 생성
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
.ecoBag {background-color:#f7f7f7;}
.ecoBag .topic {position:relative; padding-top:3.5rem; background-color:#fff;}
.ecoBag iframe {position:absolute; top:0; left:0; right:0; width:100%; height:5.5rem;}
.ecoBag .item {position:relative; text-align:center; background:#fff;}
.ecoBag .item li {position:relative; padding-bottom:4.84rem;}
.ecoBag .item a {display:block; position:absolute; left:0; top:0; z-index:10; width:100%; height:100%;}
.ecoBag .item .name {margin-top:4.5rem; font-size:1.5rem; line-height:1; font-weight:bold;}
.ecoBag .item .name span {display:block; padding:.7rem 0 .3rem; font-size:2rem; }
.ecoBag .item .name em {font-size:1.2rem; line-height:1; letter-spacing:0; font-weight:normal; color:#666;}
.ecoBag .item .price {padding-top:2rem; font-size:1.4rem; color:#ff3131; font-weight:bold; }
.ecoBag .item .price s {padding-right:.5rem; color:#868686; font-weight:normal;}
.ecoBag .item .price span {padding-left:.5rem;}
.ecoBag .item .date {display:inline-block; height:2.2rem; margin-top:1rem; padding:0 1rem; font-size:1.1rem; line-height:2.3rem; background-color:#ff3131; color:#fff; font-weight:bold;}
.ecoBag .swiper {position:relative;}
.ecoBag .swiper .pagination{position:absolute; bottom:1.2rem; z-index:20; left:0; width:100%; height:0.5rem; padding-top:0;}
.ecoBag .swiper .swiper-pagination-switch {width:0.5rem; height:0.5rem; margin:0 0.5rem; border:0.1rem solid #252525; background-color:transparent; border-radius:50%;}
.ecoBag .swiper .swiper-active-switch {background-color:#252525; border-radius:50%;}
.ecoBag .swiper button {position:absolute; top:42%; z-index:10; width:12.5%; background-color:transparent;}
.ecoBag .swiper .btnPrev {left:0;}
.ecoBag .swiper .btnNext {right:0;}
.ecoBag .swiper2 .pagination {bottom:4.95rem;}
.ecoBag .tip {position:relative;}
.ecoBag .tip span{display:inline-block; width:100%; padding:0 7.5%; background-color:#eaeaea;}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script type="text/javascript">
$(function(){
	fnApplyItemInfoList({
		items:"1809640,1809635,1811511", // 상품코드
		target:"lyrItemList",
		fields:["price","sale"],
		unit:"ew",
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
	mySwiper = new Swiper(".swiper2 .swiper-container",{
		loop:true,
		autoplay:2500,
		speed:800,
		pagination:".swiper2 .pagination",
		paginationClickable:true,
		prevButton:'.swiper2 .btnPrev',
		nextButton:'.swiper2 .btnNext',
		effect:'fade'
	});

	/* item */
	itemSlide = new Swiper('.swiper-item1 .swiper-container',{
		loop:true,
		autoplay:1800,
		speed:700,
		effect:'fade',
		pagination:false,
		prevButton:false,
		nextButton:false,
	});
	itemSlide = new Swiper('.swiper-item2 .swiper-container',{
		loop:true,
		autoplay:2000,
		speed:700,
		effect:'fade',
		pagination:false,
		prevButton:false,
		nextButton:false,
	});
	itemSlide = new Swiper('.swiper-item3 .swiper-container',{
		loop:true,
		autoplay:2200,
		speed:700,
		effect:'fade',
		pagination:false,
		prevButton:false,
		nextButton:false,
	});
});
</script>
	<!-- 월간(月刊) 에코백 -->
<div class="mEvt81543 ecoBag">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/tit_monthly_ecobag.png" alt="월간(月刊) 에코백" /></h2>
	<div class="topic">
		<iframe id="iframe_lucky" src="/event/etc/group/iframe_ecobag.asp?eventid=81543" frameborder="0" scrolling="no" title="월간 에코백 메뉴"></iframe>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/lveb.jpg" alt="#11월호 LVEB :인생을 더 아름답게, 라비에벨" /></div>
	</div>
	<p>
		<img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/txt_story.png" alt="이번 텐바이텐 월간 에코백은 라비에벨과 함께 했습니다. 쌀쌀한 날씨에 어울리는 재질과 색감! 사랑스러운 리본으로 포인트를 주고 추운 날씨에도 편안하게 함께 할 에코백을 준비했어요!코듀로이와 스웨이드로 따스하게 찾아온 리본 스트랩 에코백을 소개 합니다! " />
	</p>
	<ul class="item" id="lyrItemList">
		<li>
			<div class="swiper-item swiper-item1 thumbnail">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/img_item_1_1.jpg" alt="LVEB 리본스트랩 - 코듀로이" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/img_item_1_2.jpg" alt="LVEB 리본스트랩 - 코듀로이" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/img_item_1_3.jpg" alt="LVEB 리본스트랩 - 코듀로이" /></div>
					</div>
				</div>
			</div>
			<div class="desc">
				<p class="name">[텐바이텐 단독 제품]<span>LVEB 리본스트랩 - 코듀로이</span><em>COLOR : Pink, Khaki, charcoal</em></p>
				<p class="price">
					<s>정가</s>할인가<span>할인율</span>
				</p>
			</div>
			<% if date() < "2017-11-15" then %>
			<div class="date">11.01 ~ 11.14 단 2주간 단독 특가</div>
			<% end if %>
			<a href="/category/category_itemPrd.asp?itemid=1809640&pEtr=81543" class="mWeb"></a>
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1809640&pEtr=81543" onclick="fnAPPpopupProduct('1809640&pEtr=81543');return false;" class="mApp"></a>
		</li>
		<li>
			<div class="swiper-item swiper-item2 thumbnail">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/img_item_2_1.jpg" alt="LVEB 리본스트랩 - 스웨이드" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/img_item_2_2.jpg" alt="LVEB 리본스트랩 - 스웨이드" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/img_item_2_3.jpg" alt="LVEB 리본스트랩 - 스웨이드" /></div>
					</div>
				</div>
			</div>
			<div class="desc">
				<p class="name">[텐바이텐 단독 제품]<span>LVEB 리본스트랩 - 스웨이드</span><em>COLOR : brown, burgundy, charcoal</em></p>
				<p class="price">
					<s>정가</s>할인가<span>할인율</span>
				</p>
			</div>
			<% if date() < "2017-11-15" then %>
			<div class="date">11.01 ~ 11.14 단 2주간 단독 특가</div>
			<% end if %>
			<a href="/category/category_itemPrd.asp?itemid=1809635&pEtr=81543" class="mWeb"></a>
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1809635&pEtr=81543" onclick="fnAPPpopupProduct('1809635&pEtr=81543');return false;" class="mApp"></a>
		</li>
		<li>
			<div class="swiper-item swiper-item2 thumbnail">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/img_item_3_1.jpg" alt="LVEB 리본스트랩 - 텐셀" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/img_item_3_2.jpg" alt="LVEB 리본스트랩 - 텐셀" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/img_item_3_3.jpg" alt="LVEB 리본스트랩 - 텐셀" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/img_item_3_4.jpg" alt="LVEB 리본스트랩 - 텐셀" /></div>
					</div>
				</div>
			</div>
			<div class="desc">
				<p class="name">[텐바이텐 단독 제품]<span>LVEB 리본스트랩 - 텐셀</span><em>COLOR : wine, brown, dark blue, black</em></p>
				<p class="price">
					<s>정가</s>할인가<span>할인율</span>
				</p>
			</div>
			<% if date() < "2017-11-15" then %>
			<div class="date">11.01 ~ 11.14 단 2주간 단독 특가</div>
			<% end if %>
			<a href="/category/category_itemPrd.asp?itemid=1811511&pEtr=81543" class="mWeb"></a>
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1811511&pEtr=81543" onclick="fnAPPpopupProduct('1811511&pEtr=81543');return false;" class="mApp"></a>
		</li>
	</ul>

	<div class="swiper swiper1">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/img_slide_1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/img_slide_2.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/img_slide_3.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/img_slide_4.jpg" alt="" /></div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/btn_prev.png" alt="다음" /></button>
			<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/btn_next.png" alt="이전" /></button>
		</div>
	</div>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/txt_brand.jpg" alt="brand stroy 라비에벨은 여성 패션잡화 브랜드로 '인생은 아릅답다(la vie est belle)'라는 뜻을 담고 있습니다. 여자의 인생에서 빠질 수 없는 아름다움을 라비에벨과 함께하세요." /></div>
	<div class="swiper swiper2">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/txt_interview_1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/txt_interview_2.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/txt_interview_3.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/txt_interview_4.jpg" alt="" /></div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/btn_prev.png" alt="다음" /></button>
			<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/btn_next.png" alt="이전" /></button>
		</div>
	</div>
	<div class="tip">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/tit_tip_v2.jpg" alt="" /></p>
		<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/img_tip.gif" alt="" /></span>
		<img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/txt_tip_v2.jpg" alt="리본 예쁘게 묶기 TIP 1. 끈을 잡고 평소 묶던 방식으로 한번 묶어주세요 + 1번 묶기 전 위쪽으로 올라오는 끈을 꼭 기억해주세요. 2. 1번에서 위쪽으로 올라왔던 끈을 다시 위쪽으로 오게끔 다시 묶어주세요. + 마지막으로 잡아당길 때는 앞부분이 예쁘게 보이도록 한 후 잡아당겨주세요." />
	</div>
	<div><a href="#replyList"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81543/m/txt_comment.jpg" alt="라비에벨 X 텐바이텐의 에코백을 언제 들고 싶은지남겨주세요!정성스러운 댓글을 남겨주신 5분을 선정해 텐바이텐 1만원 상품권을 보내드립니다!" /></a></div>
</div>
	<!--// 월간(月刊) 에코백 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->