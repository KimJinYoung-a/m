<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 쿨링케어 이벤트
' History : 2017.06.15 원승현
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
	eCode = "66344"
Else
	eCode = "78570"
End If

nowdate = date()
'nowdate = "2017-01-01"

vUserID = getEncLoginUserID
%>
<style type="text/css">
.care {background:#fff;}
.navigator {position:relative; margin-bottom:-0.5px;}
.navigator iframe {position:absolute; top:0; left:0; right:0; bottom:0; width:100%; height:100%; vertical-align:top;}
.itemList {margin-top:3rem; padding:0 7.8125%;}
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
.itemMoreView {margin-bottom:3rem;}
</style>

<script>
$(function(){
	$(".itemList ul").children("li").hide();
	$(".itemList ul").children(":lt(8)").show();
	$(".itemMoreView").click(function() {
		$(".itemList ul").children(":lt(16)").show();
		$(this).hide();
	});

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


<div class="mEvt78570 care">
	<% If nowdate >= "2017-07-06" Then %>
		<div id="navigatorwrap" class="navigatorwrap"></div>
	<% End If %>
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/tit_coolingcare.jpg" alt="COLLING CARE - 당신의 시원한 일상을 위한 작은 케어" /></h2>
	<!-- p><img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/img_gift_v2.png" alt="GIFT | 5만원 이상 구매 시 백조 or 도넛 컵홀더 증정 / 30만원 이상 구매 시 플라밍고 튜브 증정(텐바이텐 배송상품 포함 시 선택 가능 / 컵홀더 6종 중 1종 랜덤 발송)" /></p -->

	<div class="section itemList">
		<ul>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1510595&amp;pEtr=78570'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1510595&pEtr=78570">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/img_thumnail01.jpg" alt="트로피칼 쿨스카프 12종" /></span>
					<h3>트로피칼 쿨스카프 12종</h3>
					<%' for dev msg : 실시간 가격노출 유지(기획서변경/이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1510595
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
					<p>언제 어디서든 물만 있으면 자연스럽게 열기를 차단하여 시원함을 유지합니다. 물속에 쿨스카프를 넣고 2~5분 담가두면, 스카프 내부의 폴리머가 팽창합니다. 팽창된 폴리머를 고루 펴준 뒤 사용하세요.</p>
					<dl>
						<dt>추천이유</dt>
						<dd>휴대가 간편. 인체에 무해하며, <br />언제든 재사용이 가능한 친환경  쿨링용품</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1690093&amp;pEtr=78570'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1690093&pEtr=78570">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/img_thumnail02.jpg" alt="MFN-I30BGCB" /></span>
					<h3>MFN-I30BGCB</h3>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1690093
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
					<p>180도 팬의 회전이 가능한  롤링형 선풍기</p>
					<dl>
						<dt>추천이유</dt>
						<dd>건조함이나 냉방병, 눈시림을 팬을 돌려줌으로써 <br />간접바람으로 변환 바람이 방해되는 순간을 막을 수 있습니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1698256&amp;pEtr=78570'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1698256&pEtr=78570">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/img_thumnail03.jpg" alt="레이스 2중거즈 여름이불" /></span>
					<h3>레이스 2중거즈 여름이불</h3>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1698256
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
					<p>2중직 거즈원단으로 만들어 진 여름 이불</p>
					<dl>
						<dt>추천이유</dt>
						<dd>순한 아기피부를 가진 아기들에게만 쓴다는 거즈를 2중으로 만들어 부드럽고 시원하며 쾌적하다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1699896&amp;pEtr=78570'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1699896&pEtr=78570">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/img_thumnail04.jpg" alt="왕하트 왕얼음 아이스트레이 셋트" /></span>
					<h3>왕하트 왕얼음 아이스트레이 셋트</h3>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1699896
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
					<p>얼음을 하트모양과 큰 구로 만들어 주는 왕 얼음틀</p>
					<dl>
						<dt>추천이유</dt>
						<dd>여름필수! 커피나 음료에 넣을 얼음이 필요할 때 좀 더 예쁘게 시원하게 유지를 시켜 줄 얼음틀. <br />커피를 얼려 큐브라떼도 즐겨보세요.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=900274&amp;pEtr=78570'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=900274&pEtr=78570">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/img_thumnail05.jpg" alt="HAIR TIE-A22 DAISY DARLING" /></span>
					<h3>HAIR TIE-A22 DAISY DARLING</h3>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 900274
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
					<p>다섯가지 컬러를 가진 엘라스틱 헤어타이</p>
					<dl>
						<dt>추천이유</dt>
						<dd>더워지는 여름 긴 머리를 묶어줄 타이. <br />시원한 컬러가 팔목을 돋보이게 합니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1685329&amp;pEtr=78570'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1685329&pEtr=78570">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/img_thumnail06.jpg" alt="루메나 N9-FAN 핸디선풍기" /></span>
					<h3>루메나 N9-FAN 핸디선풍기</h3>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1685329
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
					<p>3단계 풍량 조절이 가능한 핸디 &amp; 데스크 충전형 휴대 선풍기</p>
					<dl>
						<dt>추천이유</dt>
						<dd>추천의 첫번째 이유, 예쁘다. 두번째 이유, 예쁘다. <br />세번째 이유, 예쁘다. <br />그리고 매우 조용하고 아름답고 시원하다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1718304&amp;pEtr=78570'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1718304&pEtr=78570">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/img_thumnail07.jpg" alt="생화 엽란 한단" /></span>
					<h3>생화 엽란 한단</h3>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1718304
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
					<p>투명한 유리화병과 어울리는 식물들</p>
					<dl>
						<dt>추천이유</dt>
						<dd>한 켠에 놓아두면 시원해 보일 뿐만 아니라 인테리어 효과로도 효율이 크다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1696842&amp;pEtr=78570'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1696842&pEtr=78570">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/img_thumnail08.jpg" alt="GIVE, SEAHORSE" /></span>
					<h3>GIVE, SEAHORSE</h3>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1696842
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
					<p>발가락만을 살포시 덮어 주는 하프 삭스</p>
					<dl>
						<dt>추천이유</dt>
						<dd>발가락엔 매너를, 발목에는 센스를, 발에는 시원함을</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1717859&amp;pEtr=78570'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1717859&pEtr=78570">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/img_thumnail09.jpg" alt="여름 왕골 슬리퍼" /></span>
					<h3>여름 왕골 슬리퍼</h3>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1717859
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
					<p>왕골 소재의 루잔 스트라이프 슬리퍼</p>
					<dl>
						<dt>추천이유</dt>
						<dd>실내용 이지만 미끄럼방지가 되어있어 가까운 실외에서도 쓸 수 있다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1536736&amp;pEtr=78570'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1536736&pEtr=78570">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/img_thumnail10.jpg" alt="Retro Gold Fineapple Glass" /></span>
					<h3>Retro Gold Fineapple Glass</h3>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1536736
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
					<p>골드 포인트로 파인애플이 새겨진 롱 글라스</p>
					<dl>
						<dt>추천이유</dt>
						<dd>시원한 음료를 담아 마시면 더 시원해 보이는 금빛 포인트와 딱 적당한 사이즈</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1676711&amp;pEtr=78570'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1676711&pEtr=78570">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/img_thumnail11.jpg" alt="NEON MANIA PURPLE" /></span>
					<h3>NEON MANIA PURPLE</h3>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1676711
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
					<p>설명이 필요없는 벤시몽의 신상</p>
					<dl>
						<dt>추천이유</dt>
						<dd>심플하면서도 가볍다. 하지만 예사롭지 않다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1228874&amp;pEtr=78570'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1228874&pEtr=78570">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/img_thumnail12.jpg" alt="핏풋 (Fit foot)" /></span>
					<h3>핏풋 (Fit foot)</h3>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1228874
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
					<p>매일 앉아만 있어야 하는 사람에게 필요한 발 해먹</p>
					<dl>
						<dt>추천이유</dt>
						<dd>지치고 더워지는 날씨에 내 다리에게 주는 꿀 휴식처</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1710612&amp;pEtr=78570'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1710612&pEtr=78570">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/img_thumnail13.jpg" alt="쿨링 3D 메쉬매트 패밀리용" /></span>
					<h3>쿨링 3D 메쉬매트 패밀리용</h3>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1710612
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
					<p>순수 100%의 면 원단으로 만들어진 쿨매트</p>
					<dl>
						<dt>추천이유</dt>
						<dd>세탁이 쉬운 쿨매트. 올 여름은 예쁘고 시원한 매트 위에서 꿀잠 어때요?</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1726002&amp;pEtr=78570'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1726002&pEtr=78570">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/img_thumnail14.jpg" alt="ANIMAL FOLDING FAN" /></span>
					<h3>ANIMAL FOLDING FAN</h3>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1726002
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
					<p>동그랗게 펼쳐지는 동물 패턴이 귀여운 접이식 부채</p>
					<dl>
						<dt>추천이유</dt>
						<dd>전용케이스가 있어 보관이 쉽고, 가볍고 시원해요!</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1354945&amp;pEtr=78570'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1354945&pEtr=78570">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/img_thumnail15.jpg" alt="멜팅케이스" /></span>
					<h3>멜팅케이스</h3>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1354945
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
					<p>녹아내리는 듯한 멜팅디자인에 홀로그램 필름으로 시원하게 한번 더!</p>
					<dl>
						<dt>추천이유</dt>
						<dd>여름에 딱 어울리는 디자인과 컬러!</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1732017&amp;pEtr=78570'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1732017&pEtr=78570">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/img_thumnail16.jpg" alt="오미베리 오리지널 325ml" /></span>
					<h3>오미베리 오리지널 325ml</h3>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1732017
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
					<p>당이 없는 오미자 추출액 100%</p>
					<dl>
						<dt>추천이유</dt>
						<dd>몸에도 좋고 맛도 좋고 색도 이쁘고!</dd>
					</dl>
				</a>
			</li>
		</ul>
		<button type="button" class="itemMoreView"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/btn_more.jpg" alt="상품 더 보기" /></button>
	</div>

	<%' for dev msg : 21일부터 노출되게 해주세요 %>
	<% If nowdate >= "2017-06-21" Then %>
		<p class="btnEvtGo">
			<a href="<%=CHKIIF(isApp=1,"/apps/appCom/wish/web2014/","")%>/event/eventmain.asp?eventid=78571">
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/78570/m/btn_tastingstore.jpg" alt="TASTING STORE" />
			</a>
		</p>
	<% End If %>
	<%'// for dev msg : 21일부터 노출되게 해주세요 %>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->