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
.ecoBag {background-color:#f7f7f7;}
.ecoBag .topic {position:relative; padding-top:3.5rem; background-color:#fff;}
.ecoBag iframe {position:absolute; top:0; left:0; right:0; width:100%; height:5.5rem;}
.ecoBag .item {position:relative; text-align:center; background:#fff;}
.ecoBag .item li {position:relative; padding-bottom:5rem;}
.ecoBag .item a {display:block; position:absolute; left:0; top:0; z-index:10; width:100%; height:100%;}
.ecoBag .item .name {margin-top:4.5rem; font-size:1.5rem; line-height:1; font-weight:bold;}
.ecoBag .item .name span {display:block; padding:.7rem 0 1rem; font-size:2rem; }
.ecoBag .item .name em {font-size:1.2rem; line-height:1; letter-spacing:0; font-weight:normal; color:#666;}
.ecoBag .item .price {padding-top:1.5rem; font-size:1.4rem; color:#ff3131; font-weight:bold; }
.ecoBag .item .price s {padding-right:.5rem; color:#868686; font-weight:normal;}
.ecoBag .item .price span {padding-left:.5rem;}
.ecoBag .item .date {display:inline-block; height:2.2rem; margin-top:1rem; padding:0 1rem; font-size:1.1rem; line-height:2.3rem; background-color:#ff3131; color:#fff; font-weight:bold;}
.ecoBag .swiper {position:relative;}
.ecoBag .swiper1 {margin-bottom:9.2rem;}
.ecoBag .swiper .pagination{position:absolute; bottom:1.2rem; z-index:20; left:0; width:100%; height:0.5rem; padding-top:0;}
.ecoBag .swiper .swiper-pagination-switch {width:0.5rem; height:0.5rem; margin:0 0.5rem; border:0.1rem solid #252525; background-color:transparent; border-radius:50%;}
.ecoBag .swiper .swiper-active-switch {background-color:#252525; border-radius:50%;}
.ecoBag .swiper button {position:absolute; top:42%; z-index:10; width:12.5%; background-color:transparent;}
.ecoBag .swiper .btnPrev {left:0;}
.ecoBag .swiper .btnNext {right:0;}
.ecoBag .swiper2 .pagination {bottom:6.2rem;}
.ecoBag .tip {position:relative;}
.ecoBag .tip span{display:inline-block; width:100%; padding:0 7.5%; background-color:#eaeaea;}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script type="text/javascript">
$(function(){
	fnApplyItemInfoList({
		items:"1841012,1856182,1841011", // 상품코드
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
<div class="mEvt82985 ecoBag">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/tit_monthly_ecobag.png" alt="월간(月刊) 에코백" /></h2>
	<div class="topic">
		<iframe id="iframe_lucky" src="/event/etc/group/iframe_ecobag.asp?eventid=82985" frameborder="0" scrolling="no" title="월간 에코백 메뉴"></iframe>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/82985/m/tit_ecobag.jpg" alt="#12월호 uncommon things :베이직한 느낌이 좋다. 하지만, 특별하고 싶다." /></div>
	</div>
	<p>
		<img src="http://webimage.10x10.co.kr/eventIMG/2017/82985/m/txt_story.png" alt="이번 텐바이텐 월간 에코백은 언커먼띵스와 함께 했습니다. 어디에 매치해도 잘 어울리는 디자인. 겨울과 어울리는 따뜻한 느낌을 주는 은은한 색감과 포근한 원단 올겨울을 따스하게 지켜줄언커먼띵스 에코백을 소개 합니다." />
	</p>
	<ul class="item" id="lyrItemList">
		<li>
			<div class="swiper-item swiper-item1 thumbnail">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82985/m/img_item_1_1.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82985/m/img_item_1_2.jpg" alt="" /></div>
					</div>
				</div>
			</div>
			<div class="desc">
				<p class="name">[텐바이텐 단독]<span>우븐 스트라이프 에코백_브라운</span><em>SIZE : S, L</em></p>
				<p class="price">
					<s>정가</s>할인가<span>할인율</span>
				</p>
			</div>
			<% if date() < "2017-12-28" then %>
			<div class="date">12.14 ~ 12.27 단 2주간 단독 특가</div>
			<% end if %>
			<a href="/category/category_itemPrd.asp?itemid=1841012&pEtr=82985" onclick="TnGotoProduct('1841012');return false;"></a>
		</li>
		<li>
			<div class="swiper-item swiper-item2 thumbnail">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82985/m/img_item_2_1.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82985/m/img_item_2_2.jpg" alt="" /></div>
					</div>
				</div>
			</div>
			<div class="desc">
				<p class="name">[텐바이텐 선런칭]<span>우븐 스트라이프 에코백_그레이</span><em>SIZE : S, L</em></p>
				<p class="price">
					<s>정가</s>할인가<span>할인율</span>
				</p>
			</div>
			<% if date() < "2017-12-28" then %>
			<div class="date">12.14 ~ 12.27 단 2주간 단독 특가</div>
			<% end if %>
			<a href="/category/category_itemPrd.asp?itemid=1856182&pEtr=82985" onclick="TnGotoProduct('1856182');return false;"></a>

		</li>
		<li>
			<div class="swiper-item swiper-item2 thumbnail">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82985/m/img_item_3_1.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82985/m/img_item_3_2.jpg" alt="" /></div>
					</div>
				</div>
			</div>
			<div class="desc">
				<p class="name">[텐바이텐 선런칭]<span>우븐 스트라이프 에코백_블랙</span><em>SIZE : S, L</em></p>
				<p class="price">
					<s>정가</s>할인가<span>할인율</span>
				</p>
			</div>
			<% if date() < "2017-12-28" then %>
			<div class="date">12.14 ~ 12.27 단 2주간 단독 특가</div>
			<% end if %>
			<a href="/category/category_itemPrd.asp?itemid=1841011&pEtr=82985" onclick="TnGotoProduct('1841011');return false;"></a>
		</li>
	</ul>

	<div class="swiper swiper1">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82985/m/img_slide_1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82985/m/img_slide_2.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82985/m/img_slide_3.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82985/m/img_slide_4.jpg" alt="" /></div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/btn_prev.png" alt="다음" /></button>
			<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/btn_next.png" alt="이전" /></button>
		</div>
	</div>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/82985/m/txt_brand.jpg" alt="brand stroy 'common things but uncommon things' 흔하지만 흔하지 않은 것. uncommon things가 바라보는 흔하거나 흔하지 않은 세상을 많은 사람들에게 공유하고자 언커먼띵스가 느끼는 감성과 생각을 제품으로 표현하며 수작업으로 진행하고 공감할 수 있도록 노력합니다." /></div>
	<div class="swiper swiper2">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82985/m/txt_interview_1.jpg" alt="Q. 언커먼띵스만의 매력 흔한 것 같지만 흔하지 않은 디자인으로 심플하면서도 제품마다 포인트가 있어 끌리게 되는 매력 아닐까요? " /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82985/m/txt_interview_2.jpg" alt="Q. 이번 월간 에코백의 포인트 역시나, 깔끔하지만 유용하게 활용할 수 있는 디자인과 컬러감인 것 같아요." /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82985/m/txt_interview_3.jpg" alt="Q. 이번 상품에 대해 소개해주세요 양쪽을 접었다가 폈다가 두 가지 디자인으로 활용을 할 수 있고 복잡하지 않은 깔끔한 디자인과 컬러감이 포인트" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82985/m/txt_interview_4.jpg" alt="Q. 우븐 스트라이프 에코백을 구매하시는 분들에게 한마디 모직 울 혼방 소재로 따듯하고 포근한 느낌" /></div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/btn_prev.png" alt="다음" /></button>
			<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/btn_next.png" alt="이전" /></button>
		</div>
	</div>
	<div><a href="#replyList"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82985/m/txt_comment.jpg" alt="언커먼띵스 X 텐바이텐의  에코백을 언제 들고 싶은지 남겨주세요! 정성스러운 댓글을 남겨주신 5분을 선정해 텐바이텐 1만원 상품권을 보내드립니다!" /></a></div>
</div>
	<!--// 월간(月刊) 에코백 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->