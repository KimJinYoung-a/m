<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 레이니 시즌케어 이벤트
' History : 2017.07.05 원승현
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<%
dim eCode, vUserID, nowdate, itemid, oItem

IF application("Svr_Info") = "Dev" THEN
	eCode = "66380"
Else
	eCode = "78835"
End If

nowdate = date()
'nowdate = "2017-01-01"

vUserID = getEncLoginUserID
%>
<style type="text/css">
.care {background:#fff;}
.navigator .swiper-slide:nth-child(2):before {display:none;}
.itemList {padding:5rem 7.8125% 0;}
.itemList ul {overflow:hidden; margin:0 auto; width:100%;}
.itemList ul li {vertical-align:top; text-align:left;}
.itemList ul li a {display:block;}
.itemList ul li a:hover {text-decoration:none;}
.itemList ul li h3 {padding-top:2rem; font-size:1.7rem; color:#252525; font-weight:600;}
.itemList ul li p, .itemList ul li dl dd {padding-top:0.9rem; font-size:1.2rem; color:#666; line-height:1.6;}
.itemList ul li dl {padding:1.5rem 0 6rem;}
.itemList ul li dl dt {display:inline-block; padding-top:0.4rem; font-size:1.25rem; color:#252525; border-top:2px solid #252525; font-weight:600;}
.itemList ul li .price {padding-top:1rem; font-size:1.3rem;}
.itemList ul li .price strong {color:#df4b4b;}
</style>
<script>
$(function(){
	var eid = frmact.eventid.value;
	jsGetCare(eid);
});

function jsGetCare(m){
	$.ajax({
		url: "/event/etc/group/inc_care.asp?eventid="+m+"",
		cache: false,
		success: function(message) {
			if(message!="") {
				$("#navigatorwrap").empty().append(message);
			}
		}
	});
}
</script>

<div class="mEvt78835 care">
	<div id="navigatorwrap" class="navigatorwrap"></div>
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/78835/m/tit_rainy_care.jpg" alt="RAINY SEASON CARE - 당신의 비오는 일상을 위한 작은 케어" /></h2>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/78835/m/img_gift_v2.jpg" alt="GIFT - 3만원 이상 구매 시 블링블링 텀블러, 5만원 이상 구매 시 블링블링 파우치 증정" /></p>
	<%' 상품 목록 %>
	<div class="itemList">
		<ul>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1507668&amp;pEtr=78835'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1507668&pEtr=78835">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78835/m/img_thumnail_1.jpg" alt="신발용 자연제습기" /></span>
					<h3>신발용 자연제습기</h3>
					<%' for dev msg : 실시간 가격노출 유지(기획서변경/이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1507668
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<% If oItem.FResultCount > 0 Then %>
						<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong></div>
						<% Else %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></div>
						<% End If %>
					<% End If %>
					<% set oItem=nothing %>
					<p>실리카겔을 이용해 자연적으로 공기 중의 습기를 제거하는 제습기</p>
					<dl>
						<dt>추천이유</dt>
						<dd>신발에 찬 습기나 땀, 냄새를 직접적으로 제거 할 수 있어 장마철에 편리. 반복재사용이 가능한 친환경 상품으로 햇볕이나 드라이기로 건조하여 재사용이 가능합니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1084157&amp;pEtr=78835'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1084157&pEtr=78835">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78835/m/img_thumnail_2.jpg" alt="자연탈취제" /></span>
					<h3>자연탈취제</h3>
					<%' for dev msg : 실시간 가격노출 유지(기획서변경/이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1084157
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<% If oItem.FResultCount > 0 Then %>
						<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong></div>
						<% Else %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></div>
						<% End If %>
					<% End If %>
					<% set oItem=nothing %>
					<p>장성 축령산 등지에서 채취한 편백나무 증류수 원액 100%</p>
					<dl>
						<dt>추천이유</dt>
						<dd>유럽의 높은 유기농 생산과정 인증인 에코서트 인증을 받은 업체가 만든 수액으로 자연에서 채취한 편백나무의 착한기능과 향을 강력 추천합니다. 겨울엔 가습기 안에, 사계절 침구에 뿌려보세요. 새집증후군 개선에도 좋습니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1687392&amp;pEtr=78835'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1687392&pEtr=78835">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78835/m/img_thumnail_3.jpg" alt="3단 우산" /></span>
					<h3>3단 우산</h3>
					<%' for dev msg : 실시간 가격노출 유지(기획서변경/이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1687392
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<% If oItem.FResultCount > 0 Then %>
						<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong></div>
						<% Else %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></div>
						<% End If %>
					<% End If %>
					<% set oItem=nothing %>
					<p>비를 막아 줄 예쁘고 튼튼한 3단 수동 우산</p>
					<dl>
						<dt>추천이유</dt>
						<dd>예전과는 다르게 스콜처럼 갑자기 내리는 장맛비에 대비해 가방 속에 필요한 기본템 3단 우산. 코팅 가공을 통해 방수가 우수합니다. 시원해 보이는 디자인은 덤.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1720488&amp;pEtr=78835'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1720488&pEtr=78835">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78835/m/img_thumnail_4.jpg" alt="자동 장우산" /></span>
					<h3>자동 장우산</h3>
					<%' for dev msg : 실시간 가격노출 유지(기획서변경/이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1720488
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<% If oItem.FResultCount > 0 Then %>
						<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong></div>
						<% Else %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></div>
						<% End If %>
					<% End If %>
					<% set oItem=nothing %>
					<p>큰 비를 막아주는 자동 장우산</p>
					<dl>
						<dt>추천이유</dt>
						<dd>다양하고 상큼한 컬러, 부드러운 원목 손잡이로 그립감이 좋습니다. UV코팅이 되어 90%이상 자외선을 차단합니다. 비가 많이 오는 날을 위한 선택.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1058652&amp;pEtr=78835'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1058652&pEtr=78835">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78835/m/img_thumnail_5.jpg" alt="파우치 형 타올" /></span>
					<h3>파우치 형 타올</h3>
					<%' for dev msg : 실시간 가격노출 유지(기획서변경/이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1058652
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<% If oItem.FResultCount > 0 Then %>
						<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong></div>
						<% Else %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></div>
						<% End If %>
					<% End If %>
					<% set oItem=nothing %>
					<p>면재질의 실용적인 타올 파우치</p>
					<dl>
						<dt>추천이유</dt>
						<dd>미니수건 겸 물병주머니 겸 우산보관 겸 파우치까지. 다양다양한 매력을 가진 파우치 모양의 타올로 장마철 유용함을 뽐낼 수 있는 아이템.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1639631&amp;pEtr=78835'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1639631&pEtr=78835">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78835/m/img_thumnail_6.jpg" alt="티타임" /></span>
					<h3>티타임</h3>
					<%' for dev msg : 실시간 가격노출 유지(기획서변경/이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1639631
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<% If oItem.FResultCount > 0 Then %>
						<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong></div>
						<% Else %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></div>
						<% End If %>
					<% End If %>
					<% set oItem=nothing %>
					<p>야생화의 향과 은은한 맛을 가진 구절초꽃 생화를 말려 만든 차.</p>
					<dl>
						<dt>추천이유</dt>
						<dd>들꽃같이 수수한 모습과 연보라 빛의 색감이 매력적인 꽃차로 비에 젖어 눅룩해진 몸과 마음을 따뜻하게 녹여 줄 차 한잔 입니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1531766&amp;pEtr=78835'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1531766&pEtr=78835">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78835/m/img_thumnail_7.jpg" alt="방수노트" /></span>
					<h3>방수노트</h3>
					<%' for dev msg : 실시간 가격노출 유지(기획서변경/이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1531766
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<% If oItem.FResultCount > 0 Then %>
						<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong></div>
						<% Else %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></div>
						<% End If %>
					<% End If %>
					<% set oItem=nothing %>
					<p>극한의 조건에서도 사용이 가능한 언더워터 수첩.</p>
					<dl>
						<dt>추천이유</dt>
						<dd>방수노트로 유명한 브랜드 라잇인더레인의 베스트상품으로 물 속에서도 글씨 쓰기가 가능해 아웃도어 문구로 인기가 많다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1473315&amp;pEtr=78835'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1473315&pEtr=78835">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78835/m/img_thumnail_8.jpg" alt="방수 숄더백" /></span>
					<h3>방수 숄더백</h3>
					<%' for dev msg : 실시간 가격노출 유지(기획서변경/이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1473315
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<% If oItem.FResultCount > 0 Then %>
						<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong></div>
						<% Else %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></div>
						<% End If %>
					<% End If %>
					<% set oItem=nothing %>
					<p>비오는 날 사용하기 좋은 가벼운 가방</p>
					<dl>
						<dt>추천이유</dt>
						<dd>초 경량원단. 구김이 생겨도 자연스럽게 펴지는 우산용 발수제 코팅. 다양한 포켓구성으로 활용도가 높고, 기존 가방 보호용으로도 최적입니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1736763&amp;pEtr=78835'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1736763&pEtr=78835">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78835/m/img_thumnail_9.jpg" alt="레인부츠" /></span>
					<h3>레인부츠</h3>
					<%' for dev msg : 실시간 가격노출 유지(기획서변경/이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1736763
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<% If oItem.FResultCount > 0 Then %>
						<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong></div>
						<% Else %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></div>
						<% End If %>
					<% End If %>
					<% set oItem=nothing %>
					<p>모던한 디자인의 발목까지 오는 숏트한 레인부츠</p>
					<dl>
						<dt>추천이유</dt>
						<dd>여성스러움을 돋보이게 하는 모던한 디자인, 매트한 컬러가 시크하고 멋있다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1588057&amp;pEtr=78835'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1588057&pEtr=78835">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78835/m/img_thumnail_10.jpg" alt="캔들워머 &amp; 캔들" /></span>
					<h3>캔들워머 &amp; 캔들</h3>
					<%' for dev msg : 실시간 가격노출 유지(기획서변경/이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1588057
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<% If oItem.FResultCount > 0 Then %>
						<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong></div>
						<% Else %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></div>
						<% End If %>
					<% End If %>
					<% set oItem=nothing %>
					<p>글루미선데이에서 영감을 받은 무드로 만든 캔들과 그에 어울리는 황동 워머</p>
					<dl>
						<dt>추천이유</dt>
						<dd>비가 오는 저녁, 촉촉함에서 축축함으로 무드가 넘어가기 전 피우는 향초. 습한 기운을 없애주고 꿉꿉한 냄새를 없애는데 도움이 됩니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1511958&amp;pEtr=78835'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1511958&pEtr=78835">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78835/m/img_thumnail_11.jpg" alt="에어써큘레이터" /></span>
					<h3>에어써큘레이터</h3>
					<%' for dev msg : 실시간 가격노출 유지(기획서변경/이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1511958
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<% If oItem.FResultCount > 0 Then %>
						<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong></div>
						<% Else %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></div>
						<% End If %>
					<% End If %>
					<% set oItem=nothing %>
					<p>빈티지한 인테리어 소품만으로도 소장가치 가득한 보네이도의 팬.</p>
					<dl>
						<dt>추천이유</dt>
						<dd>실내의 공기를 빠르게 순환시켜 비오는 날의 습기 찬 공기도 쾌적하게 해주는 팬. 제습 효과와 함께 냉방비 절약도 체감하실 수 있습니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=997179&amp;pEtr=78835'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=997179&pEtr=78835">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78835/m/img_thumnail_12.jpg" alt="파우치형 판쵸우의" /></span>
					<h3>파우치형 판쵸우의</h3>
					<%' for dev msg : 실시간 가격노출 유지(기획서변경/이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 997179
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<% If oItem.FResultCount > 0 Then %>
						<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong></div>
						<% Else %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></div>
						<% End If %>
					<% End If %>
					<% set oItem=nothing %>
					<p>1978년에 탄생한 글로벌 여행용품 브랜드 고트래블의 휴대용 우의</p>
					<dl>
						<dt>추천이유</dt>
						<dd>가방에 소지품처럼 넣고 다니다가 비상시 넉넉한 판쵸 우의로 활용할 수 있는 아이템. 초경량에 부피도 작아 휴대도 간편합니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1458389&amp;pEtr=78835'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1458389&pEtr=78835">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78835/m/img_thumnail_13.jpg" alt="섬유탈취제" /></span>
					<h3>섬유탈취제</h3>
					<%' for dev msg : 실시간 가격노출 유지(기획서변경/이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1458389
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<% If oItem.FResultCount > 0 Then %>
						<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong></div>
						<% Else %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></div>
						<% End If %>
					<% End If %>
					<% set oItem=nothing %>
					<p>무향. 99.9%의 살균력. 0세부터 쓸 수 있는 섬유탈취제</p>
					<dl>
						<dt>추천이유</dt>
						<dd>우리 아기가 쓰는 패브릭의 항균, 탈취, 제균까지. 매번 세탁이 힘든 섬유 제품에 뿌려  쾌적한 장마철을 보내실 수 있습니다. </dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1536091&amp;pEtr=78835'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1536091&pEtr=78835">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78835/m/img_thumnail_14.jpg" alt="손수건" /></span>
					<h3>손수건</h3>
					<%' for dev msg : 실시간 가격노출 유지(기획서변경/이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1536091
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<% If oItem.FResultCount > 0 Then %>
						<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong></div>
						<% Else %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></div>
						<% End If %>
					<% End If %>
					<% set oItem=nothing %>
					<p>면 100%,  땀 흡수가 잘되고, 촉감이 부드러운 손수건.</p>
					<dl>
						<dt>추천이유</dt>
						<dd>소프트한 컬러와 촉감이 예쁜 패브릭 전문 브랜드의 손수건. 비가 오는 날 있으면 무조건 유용한 손수건!</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1333967&amp;pEtr=78835'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1333967&pEtr=78835">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78835/m/img_thumnail_15.jpg" alt="애견용 레인코트" /></span>
					<h3>애견용 레인코트</h3>
					<%' for dev msg : 실시간 가격노출 유지(기획서변경/이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1333967
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<% If oItem.FResultCount > 0 Then %>
						<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong></div>
						<% Else %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></div>
						<% End If %>
					<% End If %>
					<% set oItem=nothing %>
					<p>기존의 레인코트보다 슬림핏인 레인브레이커</p>
					<dl>
						<dt>추천이유</dt>
						<dd>비오는 날도 산책이 가능한 우리 아기 레인코트. 끈 조절이 가능한 후드. 멋까지 플러스.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1734890&amp;pEtr=78835'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1734890&pEtr=78835">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78835/m/img_thumnail_16.jpg" alt="유아 우산 우의 셋트" /></span>
					<h3>유아 우산 우의 셋트</h3>
					<%' for dev msg : 실시간 가격노출 유지(기획서변경/이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1734890
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<% If oItem.FResultCount > 0 Then %>
						<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong></div>
						<% Else %>
							<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></div>
						<% End If %>
					<% End If %>
					<% set oItem=nothing %>
					<p>3~6세까지 사용이 가능한 우의와 우산 셋트.</p>
					<dl>
						<dt>추천이유</dt>
						<dd>안전함이 고려된 살대보호 튜브와 안전 손잡이. 납작하게 작업 된 우산꼭지. 아이들의 안전을 위한 디테일이 살아있는 우산과 우의 입니다.</dd>
					</dl>
				</a>
			</li>
		</ul>
	</div>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->