<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 에코백 시리즈 10월 MA
' History : 2017-10-10 김송이 생성
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
.ecoBag {background-color:#f7f7f7;}
.ecoBag .topic {position:relative; padding-top:3.5rem; background-color:#fff;}
.ecoBag iframe {position:absolute; top:0; left:0; right:0; width:100%; height:5.5rem;}
.ecoBag .item {position:relative; text-align:center; background:#fff;}
.ecoBag .item li {position:relative; padding-bottom:6.4rem;}
.ecoBag .item a {display:block; position:absolute; left:0; top:0; z-index:10; width:100%; height:100%;}
.ecoBag .item .name {margin-top:1.7rem; font-size:1.5rem; line-height:1; font-weight:bold;}
.ecoBag .item .name span {display:block; padding:.7rem 0 .3rem; font-size:2rem; }
.ecoBag .item .name em {font-size:1rem; line-height:1; letter-spacing:.1rem; font-weight:normal; color:#666;}
.ecoBag .item .price {padding-top:2rem; font-size:1.4rem; color:#ff3131; font-weight:bold; }
.ecoBag .item .price s {padding-right:.5rem; color:#868686; font-weight:normal;}
.ecoBag .item .price span {padding-left:.5rem;}
.ecoBag .item .date {display:inline-block; height:2.2rem; margin-top:1rem; padding:0 1rem; font-size:1.1rem; line-height:2.3rem; background-color:#d50c0c; color:#fff; font-weight:bold;}
.ecoBag .swiper {position:relative;}
.ecoBag .swiper .pagination{position:absolute; bottom:1.2rem; z-index:20; left:0; width:100%; height:0.5rem; padding-top:0;}
.ecoBag .swiper .swiper-pagination-switch {width:0.5rem; height:0.5rem; margin:0 0.5rem; border:0.1rem solid #252525; background-color:transparent;}
.ecoBag .swiper .swiper-active-switch {background-color:#252525; border:0;}
.ecoBag .swiper button {position:absolute; top:42%; z-index:10; width:12.5%; background-color:transparent;}
.ecoBag .swiper .btnPrev {left:0;}
.ecoBag .swiper .btnNext {right:0;}
.ecoBag .swiper2 .pagination {bottom:7.6rem;}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script type="text/javascript">
$(function(){
	/*fnApplyItemInfoList({
		items:"1803227,1803225", // 상품코드
		target:"lyrItemList",
		fields:["price","sale"],
		unit:"ew",
		saleBracket:true
	});*/
	fnApplyItemInfoList({
		items:"1803227,1803225", // 상품코드
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
});
</script>
	<!-- 월간(月刊) 에코백 -->
<div class="mEvt81098 ecoBag">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/tit_monthly_ecobag.png" alt="월간(月刊) 에코백" /></h2>
	<div class="topic">
		<iframe id="iframe_lucky" src="/event/etc/group/iframe_ecobag.asp?eventid=81098" frameborder="0" scrolling="no" title="월간 에코백 메뉴"></iframe>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/81098/m/tit_ithinkso.png" alt="#10월호" /></div>
	</div>
	<p>
		<img src="http://webimage.10x10.co.kr/eventIMG/2017/81098/m/txt_story.png" alt="이번 텐바이텐 월간 에코백은 아이띵소와 함께 했습니다. 아이띵소만의 차분함으로 가을,겨울과 어울리는 데일리 에코백 입니다. 차분하면서 세련된 컬러감으로 4계절 내내 사용하실 수 있습니다. 언제나 함께할 담백한 가방 PUMPKIN SHOULDER BAG을 소개 합니다!" />
	</p>
	<ul class="item" id="lyrItemList">
		<li>
			<div class="thumbnail">
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/81098/m/img_item_1.jpg" alt="PUMPKIN SHOULDER BRICK" />
			</div>
			<div class="desc">
				<p class="name">[텐바이텐 단독 컬러]<span>PUMPKIN SHOULDER</span><em>BRICK</em></p>
				<p class="price">
					<s>42,000won</s>33,600won<span>[20%]</span>
				</p>
			</div>
			<% if date() < "2017-10-26" then %>
			<div class="date">10.11 ~ 10.25 단 2주간 단독특가</div> <!-- for dev msg // 특가 기간 이후 노출 되지 않게 해주세요. 이하동일 -->
			<% end if %>
			<a href="/category/category_itemPrd.asp?itemid=1803227&pEtr=81098" class="mWeb"></a>
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1803227&pEtr=81098" onclick="fnAPPpopupProduct('1803227&pEtr=81098');return false;" class="mApp"></a>
		</li>
		<li>
			<div class="thumbnail">
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/81098/m/img_item_2.jpg" alt="PUMPKIN SHOULDER CHARCOAL" />
			</div>
			<div class="desc">
				<p class="name">[단독 선런칭 & 할인]<span>PUMPKIN SHOULDER</span><em>CHARCOAL</em></p>
				<p class="price">
					<s>42,000won</s>33,600won<span>[20%]</span>
				</p>
			</div>
			<% if date() < "2017-10-26" then %>
			<div class="date">10.11 ~ 10.25 단 2주간 단독특가</div>
			<% end if %>
			<a href="/category/category_itemPrd.asp?itemid=1803225&pEtr=81098" class="mWeb"></a>
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1803225&pEtr=81098" onclick="fnAPPpopupProduct('1803225&pEtr=81098');return false;" class="mApp"></a>
		</li>
		<li>
			<div class="thumbnail">
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/81098/m/img_item_3.jpg" alt="PUMPKIN SHOULDER REDBROWN" />
			</div>
			<div class="desc">
				<p class="name">[단독 선런칭 & 할인]<span>PUMPKIN SHOULDER</span><em>REDBROWN</em></p>
				<p class="price">
					<s>42,000won</s>33,600won<span>[20%]</span>
				</p>
			</div>
			<% if date() < "2017-10-26" then %>
			<div class="date">10.11 ~ 10.25 단 2주간 단독특가</div>
			<% end if %>
			<a href="/category/category_itemPrd.asp?itemid=1803225&pEtr=81098" class="mWeb"></a>
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1803225&pEtr=81098" onclick="fnAPPpopupProduct('1803225&pEtr=81098');return false;" class="mApp"></a>
		</li>
	</ul>

	<div class="swiper swiper1">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81098/m/img_slide_1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81098/m/img_slide_2.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81098/m/img_slide_3.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81098/m/img_slide_4.jpg" alt="" /></div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/btn_prev.png" alt="다음" /></button>
			<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/btn_next.png" alt="이전" /></button>
		</div>
	</div>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/81098/m/txt_brand.jpg" alt="brand stroy 가장 아름다운 감성, 누군가와의 공감.. ithinkso는 이야기를 함께 나눌 수 있는 곳이 되려합니다. 이야기의 크고 작음, 많고 적음 보다는 함께하는 공감을 소중하게 생각합니다.또한 ithinkso가 판매하는 모든 상품은 누군가의 이야기를 담고 있습니다. 그 누군가가 당신이 되는 상상을 할 때, 우리는 가장 설렙니다. 당신의 소소한 일상에 즐거움과 편안함으로 살며시 젖어드는 스타일 브랜드 아이띵소 입니다." /></div>
	<div class="swiper swiper2">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81098/m/txt_interview_1.png" alt="Q. 아이띵소만의 매력 아이띵소가 생각하는 심픔은 담백함이예요." /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81098/m/txt_interview_2.png" alt="Q. 이번 월간 에코백의 포인트 자신만의 스타일을 은은하게 드러내는 데일리 백이죠." /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81098/m/txt_interview_3.png" alt="Q. 이번 상품에 대해 소개해주세요 쉽게 흘러내리지 않도록 윗부분은 한번 더 마감" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81098/m/txt_interview_4.png" alt="Q. 펌킨숄더를 구매하시는 분들에게 한마디 펌킨 숄더는 원피스부터 코트까지 어디에나 자유롭게 매치할 수 있어 편안하게 나만의 스타일을 드러낼 수 있다고 생각해요." /></div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/btn_prev.png" alt="다음" /></button>
			<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/btn_next.png" alt="이전" /></button>
		</div>
	</div>
	<div><a href="#replyList"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81098/m/txt_comment.png" alt="comment event 아이띵소 X 텐바이텐의 에코백을 언제 들고 싶은지남겨주세요!정성스러운 댓글을 남겨주신 5분을 선정해텐바이텐 1만원 상품권을 보내드립니다!" /></a></div>
</div>
	<!--// 월간(月刊) 에코백 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->