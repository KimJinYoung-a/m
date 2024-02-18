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
	eCode   =  20993
	itemid1   =  374431 'test 한정
	itemid2   =  374431 'test 한정
	itemid3   =  374431 'test 한정
Else
	eCode   =  46216
	itemid1   =  947590
	itemid2   =  947593
	itemid3   =  947705
End If

dim oItem1,oItem2,oItem3,oItem4, ItemContent
set oItem1 = new CatePrdCls
oItem1.GetItemData itemid1 '상품상세1

set oItem2 = new CatePrdCls
oItem2.GetItemData itemid2 '상품상세2

set oItem3 = new CatePrdCls
oItem3.GetItemData itemid3 '상품상세3

%>
<!doctype html>
<html lang="ko">
<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<title>생활감성채널, 텐바이텐 > 이벤트 > 고민~ 고민하지마~ BOY</title>
	<style type="text/css">
	.evtView .mEvt46216 p {max-width:100%;}
	.mEvt46216 img {vertical-align:top; display:inline;}
	</style>
</head>
<body>

			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="mEvt46216">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46216/46216_head.png" alt="이텐과 비트윈이 함께하는 빼빼로데이 이벤트 고민~ 고민하지마~ BOY 쉽다! 오! 빼빼로 데이! 센스작렬! 여자들이 좋아하는 빼빼로 데이 선물! 사랑과 센스가 넘치는 선물 고민마세요! 텐바이텐이 추천하는 빼빼로데이 선물! 이벤트기간 : 2013.10.28 ~ 11.03" style="width:100%;" /></p>
					<div class="join">
						<p><a href="/member/join.asp"  target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46216/46216_join.png" alt="아직 텐바이텐 회원이 아니신가요? 지금 회원 가입하면 4,000원 할인 쿠폰을 드려요! 회원 가입하러 가기" style="width:100%;" /></a></p>
					</div>

					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46216/46216_diy.png" alt="빼빼로 데이 센스작렬 선물 한정판매니까 서두드세요! 비트윈 회원에게만 드리는  스페셜 할인!" style="width:100%;" /></p>
					<!-- for dev msg : 솔드아웃 될 경우 상품이미지명끝에 _soldout이 붙어요. -->
					<ul>
					<% IF (oItem1.Prd.isLimitItem) and (not (oItem1.Prd.isSoldout or oItem1.Prd.isTempSoldOut)) Then %>
						<li><a href="http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=947590" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46216/46216_img_product_01.png" alt="가을 패션 BEST 여자들의 필수 아이템! Muffler 200개 한정 판매 21,000 &rarr; 14,500원" style="width:100%;" /></a></li>
					<% ELSE %>
						<li><a href="http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=947590" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46216/46216_img_product_01_soldout.png" alt="가을 패션 BEST 여자들의 필수 아이템! Muffler 200개 한정 판매 21,000 &rarr; 14,500원" style="width:100%;" /></a></li>
					<% End IF %>

					<% IF (oItem2.Prd.isLimitItem) and (not (oItem2.Prd.isSoldout or oItem2.Prd.isTempSoldOut)) Then %>
						<li><a href="http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=947593" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46216/46216_img_product_02.png" alt="패션 카드지갑 BEST 스타일리쉬의 완성! FISHING IN BAG 200개 한정 판매 24,800 &rarr; 17,300원" style="width:100%;" /></a></li>
					<% ELSE %>
						<li><a href="http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=947593" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46216/46216_img_product_02_soldout.png" alt="패션 카드지갑 BEST 스타일리쉬의 완성! FISHING IN BAG 200개 한정 판매 24,800 &rarr; 17,300원" style="width:100%;" /></a></li>
					<% End IF %>

					<% IF (oItem3.Prd.isLimitItem) and (not (oItem3.Prd.isSoldout or oItem3.Prd.isTempSoldOut)) Then %>
						<li><a href="http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=947705" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46216/46216_img_product_03.png" alt="베스트 셀러의 BEST 텐바이텐 MD가 추천해요! POSTER BAG 200개 한정 판매 36,000 &rarr; 25,000원" style="width:100%;" /></a></li>
					<% ELSE %>
						<li><a href="http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=947705" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46216/46216_img_product_03_soldout.png" alt="베스트 셀러의 BEST 텐바이텐 MD가 추천해요! POSTER BAG 200개 한정 판매 36,000 &rarr; 25,000원" style="width:100%;" /></a></li>
					<% End IF %>
					</ul>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46216/46216_txt_01.png" alt="잠깐! 빼빼로는 준비하셨나요?! 고민 마세요~ 인기 빼빼로와 초콜렛이 한자리에!" style="width:100%;" /></p>
					<div class="present">
						<a href="http://m.10x10.co.kr/event/eventmain.asp?eventid=46275"  target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46216/46216_btn_view.png" alt="추천 초콜릿 보러가기" style="width:100%;" /></a>
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/46216/46216_img_bg.png" alt="" style="width:100%;" />
					</div>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46216/46216_txt_02.png" alt="이벤트 안내 비트윈 이벤트 상자를 통해서 회원 가입을 하셔야 4,000원 할인쿠폰을 받으실 수 있습니다. (3만원 이상 구매시 사용 가능합니다)  쿠폰은 아이디당 1회 발급되며, 마이텐바이텐에서 확인 가능합니다. CS문의)1644-6030" style="width:100%;" /></p>
				</div>
			</div>
			<!-- //content area -->
<%
	Set oItem1 = Nothing
	Set oItem2 = Nothing
	Set oItem3 = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
</body>
</html>