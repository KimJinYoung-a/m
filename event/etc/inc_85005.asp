<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<%
'####################################################
' Description : 봄을 사랑한 초코파이
' History : 2018-03-15 정태훈
'####################################################
Dim eCode, userid, oItem, itemid, IsPresentItem, IsSpcTravelItem, ISFujiPhotobook, GiftNotice, DateCheck

DateCheck=now()
'DateCheck=#03/19/2018 10:00:00#

IF application("Svr_Info") = "Dev" THEN
	eCode   =  67515
	itemid = 834339
Else
	eCode   =  85005
	If DateCheck >= #03/15/2018 00:00:00# And DateCheck <= #03/25/2018 23:59:59# Then
		itemid=1922485
	ElseIf DateCheck >= #03/26/2018 00:00:00# And DateCheck <= #03/26/2018 23:59:59# Then
		itemid=1922486
	Else
		itemid=1922486
	End If
End If

userid = GetEncLoginUserID()

set oItem = new CatePrdCls
oItem.GetItemData itemid
IsPresentItem = (oItem.Prd.FItemDiv = "09")
IsSpcTravelItem = oitem.Prd.IsTravelItem and oItem.Prd.Fmakerid = "10x10Jinair"
ISFujiPhotobook = oItem.Prd.FMakerid="fdiphoto"
GiftNotice=false '사은품 소진 메세지 출력 유무

Dim sqlStr, OrderCnt, TotalCnt, TotalCheckCnt
sqlStr = "SELECT limitsold FROM [db_item].[dbo].[tbl_item] WHERE itemid = '" & itemid & "'"
rsget.CursorLocation = adUseClient
rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	TotalCnt = rsget(0)
Else
	TotalCnt=0
End IF
rsget.close

If DateCheck >= #03/15/2018 00:00:00# And DateCheck <= #03/25/2018 23:59:59# Then
TotalCheckCnt=500
ElseIf DateCheck >= #03/26/2018 00:00:00# And DateCheck <= #03/26/2018 23:59:59# Then
TotalCheckCnt=1000
Else
TotalCheckCnt=500
End If
TotalCnt=1000
OrderCnt=4
%>
<style type="text/css">
.mEvt85005 {position:relative;}
.mEvt85005 .slideTemplateV15 .pagination{position:absolute; bottom:2.56rem; z-index:10; left:0; }
.mEvt85005 .slideTemplateV15 .pagination span {width:.8rem; height:.8rem; margin:0 .45rem; border:solid .24rem #fff; background:transparent; box-shadow:0 0 .3rem .2rem rgba(100,21,41,.2);}
.mEvt85005 .slideTemplateV15 .pagination span.swiper-active-switch {width:.8rem; margin:0 .45rem; background-color:#fff;}
.mEvt85005 .slideTemplateV15 .slideNav {position:absolute; z-index:10; width:13%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2018/85005/m/btn_prev.png); text-indent:-999em; background-size:100% auto;}
.mEvt85005 .slideTemplateV15 .btnPrev {left:0;}
.mEvt85005 .slideTemplateV15 .btnNext {right:0; background-image:url(http://webimage.10x10.co.kr/eventIMG/2018/85005/m/btn_next.png); background-size:100% auto;}
.mEvt85005 .spring-edition {position:relative; background:url(http://webimage.10x10.co.kr/eventIMG/2018/85005/m/bg_pink.jpg) repeat-y 0 0; background-size:100% auto;}
.mEvt85005 .spring-edition .soldout {position:absolute; left:0; top:0; width:100%;}
.mEvt85005 .spring-edition .btn-group a {display:block; animation:move1 .6s infinite alternate;}
.mEvt85005 #lyrInfo {display:none; position:fixed; left:0; top:0; z-index:100; width:100%; height:100%; padding-top:1.5rem; background:rgba(0,0,0,.5);}
.mEvt85005 #lyrInfo .layer {position:relative; width:90%; margin:0 auto; padding:0 3.2% 1rem; background:#fff; border-radius:1.37rem;}
.mEvt85005 #lyrInfo .layer .btn-close {position:absolute; right:1rem; top:1.02rem; width:7%;}
.mEvt85005 #lyrInfo .layer ul {overflow-y:scroll; height:34.5rem; border:0.1rem solid #d4d4d4; -webkit-overflow-scrolling:touch; border-radius:.6rem; background:#f2f2f2;}
.mEvt85005 .noti {background:url(http://webimage.10x10.co.kr/eventIMG/2018/85005/m/bg_noti.jpg) 0 0 repeat; background-size:100% auto;}
.mEvt85005 .noti ul {color:#fff; font-size:1.1rem; padding:0 12% 4.1rem;}
.mEvt85005 .noti li {text-indent:-.7rem; padding-left:.7rem; line-height:1.7rem;}
@keyframes move1 {
	from {transform:translateY(0);}
	to {transform:translateY(8px);}
}
</style>
<% If isApp=1 Then %>
<script type="text/javascript">
<!--
function goShoppingBag()
{
	var frm = document.sbagfrm;
	var optCode = "0000";

	if (!frm.itemea.value){
		alert('장바구니에 넣을 수량을 입력해주세요.');
		return;
	}
	frm.itemid.value = "<%= itemid %>";
	frm.itemoption.value = optCode;
	frm.mode.value = "DO3"; 
	frm.target = "evtFrmProc"; 
	frm.action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp";
	frm.submit();
	return;
}
//-->
</script>
<% Else %>
<script type="application/x-javascript" src="/lib/js/shoppingbag_script.js"></script>
<% End If %>
<script type="text/javascript">
$(function(){
	slideTemplate = new Swiper('.slideTemplateV15 .swiper-container',{
		loop:true,
		autoplay:3000,
		autoplayDisableOnInteraction:false,
		speed:800,
		pagination:".slideTemplateV15 .pagination",
		paginationClickable:true,
		nextButton:'.slideTemplateV15 .btnNext',
		prevButton:'.slideTemplateV15 .btnPrev',
		effect:'fade'
	});

	$('.btn-info').click(function(){
		$('#lyrInfo').show();
		return false;
	});
	$('#lyrInfo .btn-close').click(function(){
		$('#lyrInfo').hide();
	});
});
function fnlogin(){
<% if isApp=1 then %>
	parent.calllogin();
	return false;
<% else %>
	parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
	return false;
<% end if %>
}
</script>
			<!-- 봄을 사랑한 초코파이 -->
			<div class="mEvt85005">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/tit_spring.jpg" alt="봄을 사랑한 초코파이" /></h2>
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/img_item.jpg" alt="" /></div>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/txt_edition.jpg" alt="올봄에만 만날 수 있는 오리온 봄&amp;봄 한정판 2종과 초코파이가 재해석한 핑크빛 봄봄 에코백과 보틀까지!" /></p>
				<form name="sbagfrm" method="post" action="" style="margin:0px;">
				<input type="hidden" name="mode" value="add" />
				<input type="hidden" name="itemid" value="<% = oitem.Prd.FItemid %>" />
				<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
				<input type="hidden" name="itemoption" value="" />
				<input type="hidden" name="userid" value="<%= userid %>" />
				<input type="hidden" name="itemPrice" value="<%= oItem.Prd.getRealPrice %>">
				<input type="hidden" name="isPresentItem" value="<%= isPresentItem %>" />
				<input type="hidden" name="IsSpcTravelItem" value="<%= IsSpcTravelItem %>">
				<input type="hidden" name="itemea" readonly value="1" />
				<div class="spring-edition">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/img_composition.jpg" alt="초코파이 딸기&amp;요거트, 후레쉬베리 복숭아&amp;요거트, 초코파이 봄봄 보틀, 초코파이 봄봄 에코백을 20,000원에 만나보세요!" /></div>
					<div class="btn-group">
					<% If DateCheck >= #03/15/2018 00:00:00# And DateCheck < #03/19/2018 10:00:00# Then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/btn_soon_1.jpg" alt="3.19(월) 오전 10시 잠시후에 오픈됩니다!" />
					<% ElseIf DateCheck >= #03/26/2018 00:00:00# And DateCheck < #03/26/2018 10:00:00# Then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/btn_soon_2.jpg" alt="3.26(월) 오전 10시 잠시후에 오픈됩니다!" />
					<% Else %>
						<% If TotalCnt >= 500 And DateCheck < #03/26/2018 00:00:00# Then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/btn_soldout.jpg" alt="SOLD OUT" />
						<% Else %>
							<% If IsUserLoginOK() Then %>
								<% If OrderCnt>=5 Then %>
									<a href="javascript:alert('구매는 ID 당 최대 5개까지 구매할 수 있습니다.');" class="buy"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/btn_buy.jpg" alt="바로 구매하기" /></a>
								<% Else %>
									<% If isApp=1 Then %>
									<a href="#" onclick="goShoppingBag();return false;" class="buy"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/btn_buy.jpg" alt="바로 구매하기" /></a>
									<% Else %>
									<a href="#" onclick="TnAddShoppingBag();return false;" class="buy"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/btn_buy.jpg" alt="바로 구매하기" /></a>
									<% End If %>
								<% End If %>
							<% Else %>
								<a href="javascript:fnlogin();" class="buy"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/btn_buy.jpg" alt="바로 구매하기" /></a>
							<% End If %>
						<% End If %>
					<% End If %>
					</div>
					<% If TotalCnt >= 1000 Then %>
					<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/txt_soldout.jpg" alt="SOLDOUT" /></p>
					<% End If %>
					<button class="btn-info"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/btn_info.jpg" alt="상품 필수 정보 보러가기" /></button>
				</div>
				<div id="lyrInfo">
					<div class="layer">
						<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/tit_info.png" alt="상품 필수 정보" /></h3>
						<ul>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/txt_info_1.png?v=1.2" alt="" /></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/txt_info_2.png?v=1.2" alt="" /></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/txt_info_3.png?v=1.2" alt="" /></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/txt_info_4.png?v=1.2" alt="" /></li>
						</ul>
						<button type="button" class="btn-close"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/btn_close.png" alt="닫기" /></button>
					</div>
				</div>
				</form>
				<form name="BagArrFrm" method="post" action="" onsubmit="return false;" >
				<input type="hidden" name="mode" value="arr">
				<input type="hidden" name="bagarr" value="">
				<% If isApp=1 Then %>
				<input type="hidden" name="giftnotice" value="<%=GiftNotice%>">
				<% End If %>
				</form>
				<div class="slideTemplateV15">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/img_slide_1.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/img_slide_2.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/img_slide_3.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/img_slide_4.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/img_slide_5.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/img_slide_6.jpg" alt="" /></div>
						</div>
					</div>
					<div class="pagination"></div>
					<button type="button" class="slideNav btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/btn_prev.jpg" alt="이전" /></button>
					<button type="button" class="slideNav btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/btn_next.jpg" alt="다음" /></button>
				</div>
				<div class="noti">
					<div class="inner">
						<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/85005/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
						<ul>
							<li>- 해당 상품은 3월 19일과 26일, 총 이틀에 걸쳐 선착순 1000개가 판매됩니다.</li>
							<li style="color:#ff99bb;">- 1차(3월 19일) 상품은 20일부터 배송됩니다.</li>
							<li>- 초코파이 봄봄에디션은 로그인 후 구매 가능합니다.</li>
							<li>- 구매는 ID 당 최대 5개까지 구매할 수 있습니다.</li>
							<li>- 이벤트는 상품 품절 시 조기 마감될 수 있습니다.</li>
							<li>- 이벤트는 즉시 결제로만 구매할 수 있습니다.</li>
						</ul>
					</div>
				</div>
			</div>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->