<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 12월의구매사은품
' History : 2018-11-30 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/frontGiftCls.asp" -->
<%
	dim eCode

	IF application("Svr_Info") = "Dev" THEN
		eCode = "90198"
	Else
		eCode = "90726"
	End If

	Dim oOpenGift, openGiftStatus

	Set oOpenGift = new CopenGift
	oOpenGift.FRectGiftScope = "1"		'전체사은이벤트 범위 지정(1:전체,3:모바일,5:APP) - 2014.08.18; 허진원
	oOpenGift.getGiftItemList(eCode)

	If oOpenGift.FResultCount > 0 Then
		openGiftStatus = True
	Else
		openGiftStatus = False
	End if
%>
<style type="text/css">
/* 공통 */
.sns-share {position:relative; background-color:#4753c9;}
.sns-share ul {display:flex; position:absolute; top:0; right:0; height:100%; justify-content:flex-end; align-items:center; margin-right:2.21rem;}
.sns-share li {width:4.05rem; margin-left:.77rem;}

.mEvt90726 {background-color:#f47c64;}
.mEvt90726 h2 {position:relative;}
.mEvt90726 h2 .bnr-top {position:absolute; top:0; right:2%; z-index:99;}
.mEvt90726 h2 .bnr-top p {position:absolute; right:15%; width:8.4rem; height:13.14rem; animation:watch 2.0s 0.8s both linear 12; transform-origin:50% top; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/90726/m/ico_order.png); background-size:contain; text-indent:-9999px;}
.mEvt90726 h2 .bnr-top span {display:block; width:4.78rem; height:7.98rem; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/90726/m/ico_order_sm.png); background-size:contain; text-indent:-9999px;}
.mEvt90726 h2 .bnr-top.soldout p {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/90726/m/ico_order_off.png);}
.mEvt90726 h2 .bnr-top.soldout span {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/90726/m/ico_order_sm_off.png);}
.mEvt90726 .slide-area {position:relative;}
.mEvt90726 .slide-area #slide {position:absolute; top:0; z-index:99;}
.mEvt90726 .slide-area .pagination {position:absolute; bottom:43%; width:100%; z-index:99;}
.mEvt90726 .slide-area .pagination .swiper-pagination-switch {width:0.73rem; height:0.73rem; margin:0 .64rem; background-color:#f8aa9b; border-radius:0.73rem;}
.mEvt90726 .slide-area .pagination .swiper-active-switch {width:1.8rem; background-color:#e54828;}
.mEvt90726 .vod-wrap {position:relative; padding-bottom:2.6rem; background-color:#ffc445;}
.mEvt90726 .vod-wrap .vod {width:100%; height:0; padding-bottom:56.25%; box-shadow:0 .5rem 1.5rem rgba(0, 0, 0, 0.4);}
.mEvt90726 .noti {position:relative; padding:4.56rem 3rem 4.25rem 2.73rem; background-color:#262639; color:#cacadf; text-align:left;}
.mEvt90726 .noti h3 {width:7.17rem; margin:0 auto 2.5rem;}
.mEvt90726 .noti li {position:relative; line-height:1.8rem; font-size:1.14rem; margin-bottom:.5rem; word-break:keep-all;}
.mEvt90726 .noti li:before {content:''; position:absolute; left:-.94rem; top:.7rem; width:.38rem; height:.38rem; border-radius:50%; background-color:#f47c64;}
.mEvt90726 .noti b {font-weight:bold; color:#e9c066;}
.mEvt90726 .noti a {display:inline-block; height:1.54rem; padding:0 .68rem; margin:0.5rem 0; background-color:#e9c066; color:#14141d; font-weight:bold; text-decoration:none;}
@keyframes watch {
	from, 50%, to {transform:rotate(0);}
	25% {transform:rotate(10deg);}
	75% {transform:rotate(-10deg);}
}
</style>
<script>
$(function(){
	titSwiper = new Swiper("#slide",{
		loop:true,
		autoplay:1600,
		speed:1000,
		effect:'fade',
		pagination:".slide-area .pagination",
		paginationClickable:true,
	});
});
</script>
<%' 90726 12월의 구매사은품 %>
<div class="mEvt90726">
	<div class="inner-wrap">
		<h2>
			<img src="http://webimage.10x10.co.kr/fixevent/event/2018/90726/m/tit_img.png" alt="12월의 구매사은품">
			<%' for dev msg : 선착순 끝나면 솔드아웃 처리 : bnr-top 옆에 soldout 클래스 추가하심돼요 %>
			<div class="bnr-top <% If openGiftStatus Then %><% if (oOpenGift.FItemList(0).IsGiftItemSoldOut) then %>soldout<% End If %><% End If %>"> 
				<p>선착순 900개!</p>
				<span>선착순 900개!</span>
			</div>
		</h2>
		<div class="slide-area">
			<p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90726/m/img_play.png?v=1.01" alt=""></p>
			<% If isapp="1" Then %>
				<a href="" onclick="TnGotoProduct('2133684');return false;">
			<% Else %>
				<a href="/category/category_itemPrd.asp?itemid=2133684&pEtr=90726">
			<% End If %>
			
				<div id="slide" class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90726/m/img_slide_01.png" alt="슬라이드 이미지" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90726/m/img_slide_02.png" alt="슬라이드 이미지" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90726/m/img_slide_03.png?v=1.01" alt="슬라이드 이미지" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90726/m/img_slide_04.png" alt="슬라이드 이미지" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90726/m/img_slide_05.png" alt="슬라이드 이미지" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90726/m/img_slide_06.png" alt="슬라이드 이미지" /></div>
					</div>
				</div>
			</a>
			<div class="pagination"></div>
		</div>
		<div class="vod-wrap shape-rtgl">
			<div class="vod">
				<iframe src="https://www.youtube.com/embed/QYR6-OD7P0I" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
			</div>
		</div>
		<div class="noti">
			<h3><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90726/m/txt_notice.png" alt="유의사항" /></h3>
			<ul>
				<li>본 이벤트는 텐바이텐 회원님을 위한 혜택입니다. (비회원 구매 시, 증정 불가)</li>
				<li><b>텐바이텐 배송상품을 포함</b>하여야 사은품 선택이 가능합니다. <br/>
					<% If isapp="1" Then %>
						<a href="" onclick="fnAPPpopupEvent('89269');return false;">텐바이텐 배송상품 보기 ></a>
					<% Else %>
						<a href="/event/eventmain.asp?eventid=89269">텐바이텐 배송상품 보기 ></a>
					<% End If %>
				</li> 
				<li>쿠폰, 할인카드 등을 적용한 후 <b>구매확정 금액이 5만원 이상</b>이어야 합니다. (단일주문건 구매 확정액)</li>
				<li>마일리지, 예치금, 기프트카드를 사용하신 경우, 사용하신 금액이 구매확정 금액에 포함되어 사은품을 받으실 수 있습니다.</li>
				<li>텐바이텐 기프트카드를 구매하신 경우는 사은품 증정이 되지 않습니다.</li>
				<li>환불이나 교환 시 최종 구매 가격이 사은품 수량 가능금액 미만이 될 경우, 사은품과 함께 반품해야 합니다.</li>
				<li>한정 수량이므로 조기에 소진될 수 있습니다.</li>
			</ul>
		</div>
	</div>
</div>
<%' // 90726 12월의 구매사은품 %>
<%
	Set oOpenGift = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->