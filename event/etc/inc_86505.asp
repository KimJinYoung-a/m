<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<%
'####################################################
' Description :  텐바이텐 체크카드 밀키머그 이벤트
' History : 2018-05-15 정태훈 생성
'####################################################
Dim eCode, userid, oItem, itemid

IF application("Svr_Info") = "Dev" THEN
	eCode   =  68519
	itemid = 1239339
Else
	eCode   =  86505
	itemid = 1967223
End If

userid = GetEncLoginUserID()

Dim sqlStr, TotalCnt
sqlStr = "SELECT limitsold FROM [db_item].[dbo].[tbl_item] WHERE itemid = '" & itemid & "'"
rsget.CursorLocation = adUseClient
rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	TotalCnt = rsget(0)
Else
	TotalCnt=0
End IF
rsget.close

%>
<style type="text/css">
.mEvt86505 {background-color:#ffe282;}
.rolling {position:relative;}
.rolling .limit {position:absolute; right:2.6%; top:-6%; z-index:20; width:32%;  animation:bounce 1s 50;}
.rolling .pagination {position:absolute; bottom:4.6%; left:0; width:100%; height:.8rem; z-index:50; padding-top:0; text-align:center;}
.rolling .pagination span {width:.8rem; height:.8rem; margin:0 .4rem; background:#fff; box-shadow:0 0 .5rem 0 rgba(0,0,0,.2); transition:all .3s;}
.rolling .pagination .swiper-active-switch {width:1.3rem; background:#26a672; border-radius:1rem;}
.item {padding-bottom:2.65rem;}
.noti {padding:3.4rem 0; color:#fff; background:#08b26d;}
.noti h3 {text-align:center; padding-bottom:1.45rem;}
.noti h3 strong {display:inline-block; padding-bottom:0.3rem; font-size:1.2rem; border-bottom:0.1rem solid #6feab8;}
.noti ul {padding:0 6%; font-size:1.1rem; line-height:1.2;}
.noti li {padding:0 0 .5rem .65rem; text-indent:-.65rem;}
.noti li:last-child {padding-bottom:0;}
@keyframes bounce {
    from, to {transform:translateY(0); animation-timing-function:ease-out;}
    50% {transform:translateY(-8px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">
$(function(){
	rolling1 = new Swiper(".rolling .swiper-container",{
		loop:true,
		autoplay:2000,
		speed:800,
		pagination:".rolling .pagination",
		paginationClickable:true,
		effect:'fade'
	});
});
</script>
			<!-- 텐카찬스 프로젝트 01 - 밀키머그 -->
			<div class="mEvt86505">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/86505/m/tit_mug.png" alt="텐카찬스 프로젝트 01 - 밀키머그" /></h2>
				<div class="rolling">
					<p class="limit"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86505/m/txt_limit.png" alt="선착순 1,000명" /></p>
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86505/m/img_slide_1.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86505/m/img_slide_2.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86505/m/img_slide_3.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86505/m/img_slide_4.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86505/m/img_slide_5.jpg" alt="" /></div>
						</div>
					</div>
					<div class="pagination"></div>
				</div>
				<!-- 구매하기 -->
				<div class="item">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/86505/m/txt_item.png" alt="텐바이텐 체크카드 할인가 2,000원" /></p>
					<% If TotalCnt >= 1000 Then %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2018/86505/m/btn_soldout.png" alt="SOLD OUT" />
					<% Else %>
					<% if isApp=1 then %>
					<a href="javascript:fnAPPpopupProduct(<%=itemid%>);">
					<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=<%=itemid%>&pEtr=<%=eCode%>">
					<% End If %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2018/86505/m/btn_buy.png" alt="지금 구매하러 가기" />
					</a>
					<% End If %>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/86505/m/txt_free.png" alt="본 상품은 무료배송 입니다" /></p>
				</div>
				<div><a href="/event/eventmain.asp?eventid=85155" onclick="jsEventlinkURL('85155');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86505/m/bnr_event.jpg" alt="지금, 텐바이텐 체크카드로 3만원 이상 결제하면 카드홀더를 드려요!" /></div>
				<div class="noti">
					<h3><strong>유의사항</strong></h3>
					<ul>
						<li>- <strong>본 이벤트는 '텐바이텐 체크카드'로만 결제가 가능합니다.</strong></li>
						<li>- <strong>구매는 ID당 최대 1개까지 구매할 수 있습니다.</strong></li>
						<li>- 본 상품은 다른 상품과 함께 구매하실 수 없습니다.</li>
						<li>- 이벤트는 선착순 수량(1,000개) 품절 시 조기 마감될 수 있습니다.</li>
					</ul>
				</div>
			</div>
			<!--// 텐카찬스 프로젝트 01 - 밀키머그 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->