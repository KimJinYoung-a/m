<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls.asp" -->
<%
Dim eCode , itemid1, itemid2, itemid3, itemid4
IF application("Svr_Info") = "Dev" THEN
	eCode   =  20992
	itemid1   =  374431 'test 한정
	itemid2   =  374431 'test 한정
	itemid3   =  374431 'test 한정
	itemid4   =  374431 'test 한정
Else
	eCode   =  46215
	itemid1   =  947569
	itemid2   =  947568
	itemid3   =  947571
	itemid4   =  947570
End If

dim oItem1,oItem2,oItem3,oItem4, ItemContent
set oItem1 = new CatePrdCls
oItem1.GetItemData itemid1 '상품상세1

set oItem2 = new CatePrdCls
oItem2.GetItemData itemid2 '상품상세2

set oItem3 = new CatePrdCls
oItem3.GetItemData itemid3 '상품상세3

set oItem4 = new CatePrdCls
oItem4.GetItemData itemid4 '상품상세4


%>
<!doctype html>
<html lang="ko">
<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<title>생활감성채널, 텐바이텐 > 이벤트 > 고민~ 고민하지마~ BOY</title>
	<style type="text/css">
	.evtView .mEvt46215 p {max-width:100%;}
	.mEvt46215 img {vertical-align:top; display:inline;}
	.mEvt46215 .present {padding-bottom:8%; background:#f97b7b; text-align:center;}
	</style>
</head>
<body>

			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="mEvt46215">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46215/46215_head.png" alt="이텐과 비트윈이 함께하는 빼빼로데이 이벤트 고민~ 고민하지마~ GIRL 쉽다! 예쁘다! 탐난다! 올해는 남자친구를 위해 나만의 빼빼로에 도전해 보세요! 텐바이텐 인기 DIY상품 파격 할인! 이벤트기간 : 2013.10.28 ~ 11.03" style="width:100%;" /></p>
					<div class="join">
						<p><a href="/member/join.asp?rdsite=between" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46215/46215_join.png" alt="아직 텐바이텐 회원이 아니신가요? 지금 회원 가입하면 4,000원 할인 쿠폰을 드려요! 회원 가입하러 가기" style="width:100%;" /></a></p>
					</div>

					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46215/46215_diy.png" alt="나만의 스타일 4색 DIY 빼빼로 한정판매니까 서두드세요! 비트윈 회원에게만 드리는  스페셜 할인!" style="width:100%;" /></p>
					<!-- for dev msg : 솔드아웃 될 경우 상품이미지명끝에 _soldout이 붙어요. -->
					<ul>
						<% IF (oItem1.Prd.isLimitItem) and (not (oItem1.Prd.isSoldout or oItem1.Prd.isTempSoldOut)) Then %>
							<li><a href="http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=947569" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46215/46215_img_product_01.png" alt="클래식한 디자인을 좋아하는 당신에게 100개 한정 판매 18,500 &rarr; 14,800원" style="width:100%;" /></a></li>
						<% ELSE %>
							<li><a href="http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=947569" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46215/46215_img_product_01_soldout.png" alt="클래식한 디자인을 좋아하는 당신에게 100개 한정 판매 18,500 &rarr; 14,800원" style="width:100%;" /></a></li>
						<% End IF %>

						<% IF (oItem2.Prd.isLimitItem) and (not (oItem2.Prd.isSoldout or oItem2.Prd.isTempSoldOut)) Then %>
							<li><a href="http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=947568" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46215/46215_img_product_02.png" alt="심플한 디자인을 좋아하는 당신에게 100개 한정 판매 28,900 &rarr; 23,000원" style="width:100%;" /></a></li>
						<% ELSE %>
							<li><a href="http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=947568" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46215/46215_img_product_02_soldout.png" alt="심플한 디자인을 좋아하는 당신에게 100개 한정 판매 28,900 &rarr; 23,000원" style="width:100%;" /></a></li>
						<% End IF %>

						<% IF (oItem3.Prd.isLimitItem) and (not (oItem3.Prd.isSoldout or oItem3.Prd.isTempSoldOut)) Then %>
							<li><a href="http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=947571" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46215/46215_img_product_03.png" alt="러블리! 로맨틱한 사랑스런 당신에게 100개 한정 판매 29,800 &rarr; 23,800원" style="width:100%;" /></a></li>
						<% ELSE %>
							<li><a href="http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=947571" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46215/46215_img_product_03_soldout.png" alt="러블리! 로맨틱한 사랑스런 당신에게 100개 한정 판매 29,800 &rarr; 23,800원" style="width:100%;" /></a></li>
						<% End IF %>

						<% IF (oItem4.Prd.isLimitItem) and (not (oItem4.Prd.isSoldout or oItem4.Prd.isTempSoldOut)) Then %>
							<li><a href="http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=947570" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46215/46215_img_product_04.png" alt="동글동글, 귀염귀염! 애교 많은 당신에게 100개 한정 판매 27,900 &rarr; 22,300원" style="width:100%;" /></a></li>
						<% ELSE %>
							<li><a href="http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=947570" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46215/46215_img_product_04_soldout.png" alt="동글동글, 귀염귀염! 애교 많은 당신에게 100개 한정 판매 27,900 &rarr; 22,300원" style="width:100%;" /></a></li>
						<% End IF %>


					</ul>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46215/46215_txt_01.png" alt="쉿! 남자친구에게 알려주세요! 비트윈 남자분들에게 주는 파격 할인! 여자들이 원하는 빼빼로 데이 선물 추천!" style="width:100%;" /></p>
					<div class="present">
						<a href="http://m.10x10.co.kr/event/eventmain.asp?eventid=46216" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46215/46215_btn_view.png" alt="빼빼로데이 선물보기" style="width:50%;" /></a>
					</div>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46215/46215_txt_02.png" alt="이벤트 안내 비트윈 이벤트 상자를 통해서 회원 가입을 하셔야 4,000원 할인쿠폰을 받으실 수 있습니다. (3만원 이상 구매시 사용 가능합니다)  쿠폰은 아이디당 1회 발급되며, 마이텐바이텐에서 확인 가능합니다. CS문의)1644-6030" style="width:100%;" /></p>
				</div>
			</div>
			<!-- //content area -->
<%
	Set oItem1 = Nothing
	Set oItem2 = Nothing
	Set oItem3 = Nothing
	Set oItem4 = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
</body>
</html>
