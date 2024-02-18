<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 사은품
' History : 2017-03-31 이종화
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/props/sns.asp" -->
<style type="text/css">
.itemWrap {position:relative;}
.itemWrap h3 {position:absolute; left:0; top:1.3rem; width:100%; animation:bounce 1.8s infinite;}
.itemWrap a {overflow:hidden; display:block; position:absolute; left:0; top:10%; width:50%; height:90%; background-color:rgba(0,0,0,0); text-indent:-999em;}
.slideTemplateV15 {padding:0.75rem; background-color:#fff;}
.slideTemplateV15 .slideNav {background-size:40%;}
.slideTemplateV15 .btnNext {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/sopum/77063/m/btn_slide_next.png);}
.slideTemplateV15 .btnPrev {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/sopum/77063/m/btn_slide_prev.png);}
.slideTemplateV15 .pagination span {border-color:#000; box-shadow:none;}
.slideTemplateV15 .pagination .swiper-active-switch {background-color:#000; border-color:#000;}
.slideTemplateV15 .pagination span.swiper-active-switch {background-color:#000;}
.noti {position:relative; margin-top:-0.2px; padding:2.5rem 2rem 2.4rem 2.5rem; border-top:1rem solid #00b696; background-color:#eee;}
.noti h3 {position:relative; color:#00b696; font-size:1.3rem; font-weight:bold; line-height:1em;}
.noti h3:after {content:' '; display:block; position:absolute; top:50%; left:-1rem; width:0.4rem; height:1rem; margin-top:-0.4rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/sopum/77063/m/blt_arrow.png) 50% 0 no-repeat; background-size:100% auto;}
.noti ul {margin-top:1.3rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#333; font-size:1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.6rem; left:0; width:0.4rem; height:0.1rem; background-color:#333;}
.noti ul li strong {color:#ea2a2a;}
.noti li .btnEvent {display:inline-block; margin-top:0.1rem; position:relative; height:1.6rem; padding:0.2rem 1.3rem 0 0.7rem; border-radius:1rem; background-color:#00b696; color:#fff; line-height:1.5rem;}
.noti li .btnEvent:after {content:'>'; display:block; position:absolute; top:50%; right:0.5rem; height:1.6rem; margin-top:-0.62rem; color:#fff; line-height:1.5rem;}
.sns {position:relative;}
.sns ul {width:33.75%; position:absolute; top:31%; right:3.43%;}
.bnr {background-color:#f4f7f7;}
.bnr ul li {margin-top:1rem;}
.bnr ul li:first-child {margin-top:0;}
@keyframes bounce {
	from, to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(7px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">
$(function(){
	// slide template
	slideTemplate = new Swiper('.slideTemplateV15 .swiper-container',{
		loop:true,
		autoplay:3000,
		autoplayDisableOnInteraction:false,
		speed:800,
		pagination:".slideTemplateV15 .pagination",
		paginationClickable:true,
		nextButton:'.slideTemplateV15 .btnNext',
		prevButton:'.slideTemplateV15 .btnPrev'
	});
});
</script>
<div class="sopum">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77063/m/tit.png" alt="완전 소중한 사은품 완소품" /></p>
	<div class="itemWrap">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77063/m/subtit1.png" alt="5만원 이상 구매 시" /></h3>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77063/m/img_item1.png" alt="5만원 이상 구매 시 텐바이텐 자수 수건(2종 중 1종 랜덤 발송) 또는 2,000 마일리지 제공" /></p>
	</div>
	<div class="itemWrap">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77063/m/subtit2_v1.png" alt="30만원 이상 구매 시" /></h3>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77063/m/img_item2_soldout.png" alt="30만원 이상 구매 시 브리오신 집들이 선물세트 또는 15,000 마일리지 제공" /></p>
		<a  class="mWeb" href="/category/category_itemPrd.asp?itemid=1378730&pEtr=77063">브리오신 집들이 선물세트</a>
		<a  class="mApp" href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1378730&pEtr=77063" onclick="fnAPPpopupProduct('1378730&pEtr=77063');return false;">브리오신 집들이 선물세트</a>
	</div>
	<div class="slideTemplateV15">
		<div class="swiper">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77063/m/img_slide1.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77063/m/img_slide2.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77063/m/img_slide3.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77063/m/img_slide4.png" alt="" /></div>
				</div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="slideNav btnPrev">이전</button>
			<button type="button" class="slideNav btnNext">다음</button>
		</div>
	</div>
	<div class="noti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>텐바이텐 사은이벤트는 텐바이텐 회원님을 위한 혜택입니다.<br />(비회원 구매 시 증정 불가)</li>
			<li>텐바이텐 배송상품을 포함해야 사은품 선택이 가능합니다.<br /><a href="eventmain.asp?eventid=65618" title="텐텐 배송 기획전으로 이동" class="btnEvent">텐바이텐 배송상품 보러가기</a></li>
			<li>업체배송 상품으로만 구매시 마일리지만 선택 가능합니다.</li>
			<li>상품 쿠폰, 보너스 쿠폰 등의 사용 후 구매 확정액이 <strong>5/30만원 이상</strong>이어야 합니다. (단일주문건 구매 확정액)</li>
			<li>마일리지, 예치금, Gift카드를 사용하신 경우에는 구매 확정액에 포함되어 사은품을 받을 수 있습니다.</li>
			<li>텐바이텐 Gift카드를 구매하신 경우에는 사은품 증정이 되지 않습니다.<br />마일리지는 차후 일괄 지급 입니다.<br /><strong>1차: 4월 12일 수요일</strong> (~7일 자정까지 결제완료 기준)<br /><strong>2차: 4월 25일 화요일</strong> (4/8~17일까지 결제완료 기준)</li>
			<li>환불이나 교환 시, 최종 구매가격이 사은품 수령 가능 금액 미만일 경우 사은품과 함께 반품해야 합니다.</li>
			<li>각 상품별 한정 수량이므로, 조기 소진될 수 있습니다.</li>
		</ul>
	</div>
	<div class="sns"><%=snsHtml%></div>
	<div class="bnr">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/common/m/tit_event_more.gif" alt="이벤트 더보기" /></h3>
		<ul>
			<li><a href="<%=chkiif(isapp="1","/apps/appcom/wish/web2014/event/","/event/")%>eventmain.asp?eventid=77059"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/common/m/img_bnr_index.jpg" alt="소품전 이벤트 메인페이지 가기" /></a></li>
			<li><a href="<%=chkiif(isapp="1","/apps/appcom/wish/web2014/event/","/event/")%>eventmain.asp?eventid=77060"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/common/m/img_bnr_sopumland.jpg" alt="매일 만나는 다양한 테마기획전" /></a></li>
			<li><a href="<%=chkiif(isapp="1","/apps/appcom/wish/web2014/event/","/event/")%>eventmain.asp?eventid=77062"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/common/m/img_bnr_treasure.jpg" alt="보물을 찾으면 기프트카드를 드려요" /></a></li>
		</ul>
	</div>
</div>