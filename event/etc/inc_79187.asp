<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 바디케어 이벤트
' History : 2017.07.12 원승현
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
	eCode = "66393"
Else
	eCode = "79187"
End If

nowdate = date()
'nowdate = "2017-01-01"

vUserID = getEncLoginUserID
%>
<style type="text/css">
.care {background:#fff;}
.navigator .swiper-slide:nth-child(3):before {display:none;}
.itemList {padding:5rem 7.8125% 0;}
.itemList ul {overflow:hidden; margin:0 auto; width:100%;}
.itemList ul li {vertical-align:top; text-align:left;}
.itemList ul li div {position:relative;}
.itemList ul li div span {position:absolute; right:2%; bottom:-4.5%; text-align:right; font-size:1.3rem; font-weight:600; color:#666;}
.itemList ul li div em {color:#252525; font-weight:bold;}
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
<div class="mEvt79187 care">
	<div id="navigatorwrap" class="navigatorwrap"></div>
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/79187/m/tit_body.png" alt="BODY CARE - 당신의 바디를 위한 작은 케어" /></h2>
	<%' 상품 목록 %>
	<div class="itemList">
		<ul>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1598055&amp;pEtr=79187'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1598055&pEtr=79187">
				<% End If %>
					<div><span><em>1</em> / 16</span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79187/m/img_thumnail_1.jpg" alt="스마트 체중계" /></div>
					<h3>스마트 체중계</h3>
					<%' for dev msg : 실시간 가격노출 유지(이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1598055
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
					<p>매일 매일 체크가 디테일 하게 가능한 앱 연동 체중계</p>
					<dl>
						<dt>추천이유</dt>
						<dd>수분 보충을 위한 물 한잔을 권하거나 부족한 단백질 보충 조언을 해주는 등 11가지 데이터를 기초로 건강함을 유지할 수 있게 도와줍니다. iOS건강 앱과 삼성 S헬스와 연동이 가능한 똑똑함을 장착한 체중계.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1708739&amp;pEtr=79187'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1708739&pEtr=79187">
				<% End If %>
					<div><span><em>2</em> / 16</span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79187/m/img_thumnail_2.jpg" alt="6mm 요가매트" /></div>
					<h3>6mm 요가매트</h3>
					<%' for dev msg : 실시간 가격노출 유지(이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1708739
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
					<p>안전하고 복원력이 빠른 친환경 요가매트</p>
					<dl>
						<dt>추천이유</dt>
						<dd>유럽품질 안전 인증 검사가 완료 된 6P 프리 제품. 고급 천연 고무에서 채취한 TPE로 만들어 졌습니다. 민감한 피부를 가진 분들에게 추천해 드립니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1554288&amp;pEtr=79187'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1554288&pEtr=79187">
				<% End If %>
					<div><span><em>3</em> / 16</span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79187/m/img_thumnail_3.jpg" alt="착한 물병" /></div>
					<h3>착한 물병</h3>
					<%' for dev msg : 실시간 가격노출 유지(이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1554288
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
					<p>물을 더 맛있게 만드는 물병. MADE IN USA.</p>
					<dl>
						<dt>추천이유</dt>
						<dd>물병 입구에 달린 카본 필터로 들어 있는 물을 한번 더 깨끗하게. 500ml 생수 300병 정수가 가능. 카림 라시드가 디자인 한 그립감이 좋습니다. 환경호르몬 걱정 없는 트라이탄 소재입니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1722880&amp;pEtr=79187'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1722880&pEtr=79187">
				<% End If %>
					<div><span><em>4</em> / 16</span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79187/m/img_thumnail_4.jpg" alt="건강하고 편리한 대용식" /></div>
					<h3>건강하고 편리한 대용식</h3>
					<%' for dev msg : 실시간 가격노출 유지(이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1722880
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
					<p>물만 넣으면 완성되는 간편한 식사 대용 밀스.</p>
					<dl>
						<dt>추천이유</dt>
						<dd>200Kcal로 가벼움. 5가지 맛의 선택지로 맛을 놓치지 않고, 영양 밸런스를 맞춰 한 병으로도 든든합니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=694895&amp;pEtr=79187'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=694895&pEtr=79187">
				<% End If %>
					<div><span><em>5</em> / 16</span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79187/m/img_thumnail_5.jpg" alt="손에 쏙 들어오는 작은 줄자" /></div>
					<h3>손에 쏙 들어오는 작은 줄자</h3>
					<%' for dev msg : 실시간 가격노출 유지(이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 694895
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
					<p>작지만 견고한 1.5m 줄자</p>
					<dl>
						<dt>추천이유</dt>
						<dd>문구를 오랜 기간 만든 미도리 사의 컬러스테이셔너리 라인으로 상큼한 컬러와 높은 퀄리티를 자랑합니다. 연질의 줄자라인이 신체 부위 측정을 더욱 쉽게 돕습니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1695909&amp;pEtr=79187'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1695909&pEtr=79187">
				<% End If %>
					<div><span><em>6</em> / 16</span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79187/m/img_thumnail_6.jpg" alt="스마트 체지방 측정기" /></div>
					<h3>스마트 체지방 측정기</h3>
					<%' for dev msg : 실시간 가격노출 유지(이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1695909
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
					<p>체지방 체크가 가능한 휴대폰 앱과 연동되는 측정기</p>
					<dl>
						<dt>추천이유</dt>
						<dd>체중조절에 필요한 항목들을 손쉽게 직접 관리합니다.<br />다이어트의 속도가 아닌 방향을 찾아줍니다.<br />요요없이 건강한 다이어트 도전을 돕습니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1205524&amp;pEtr=79187'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1205524&pEtr=79187">
				<% End If %>
					<div><span><em>7</em> / 16</span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79187/m/img_thumnail_7.jpg" alt="매일 바르고 싶은 바디로션" /></div>
					<h3>매일 바르고 싶은 바디로션</h3>
					<%' for dev msg : 실시간 가격노출 유지(이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1205524
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
					<p>오래 가는 향으로 유명한 미국 향수 NO.1 브랜드에서 나온 프레그런스 바디로션</p>
					<dl>
						<dt>추천이유</dt>
						<dd>향과 촉촉함이 오래가며, 우리에게 익숙한 화이트 머스크향이 샤워 후 내 몸의 수분을 머금어 더욱 촉촉한 살결을 유지해 줍니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1654249&amp;pEtr=79187'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1654249&pEtr=79187">
				<% End If %>
					<div><span><em>8</em> / 16</span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79187/m/img_thumnail_8.jpg" alt="바디워시를 머금은 스폰지" /></div>
					<h3>바디워시를 머금은 스폰지</h3>
					<%' for dev msg : 실시간 가격노출 유지(이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1654249
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
					<p>바디워시가 필요 없는 샤워 스폰지로 20회 이상의<br />샤워가능</p>
					<dl>
						<dt>추천이유</dt>
						<dd>특허성분인 멀티 셀토너로 물이 닿으면 셀룰라이트 배출을 돕습니다. 울퉁불퉁한 고민 부위에 대고 마사지를 하면 피부에 침투하여 매끈한 피부를 유지합니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1631367&amp;pEtr=79187'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1631367&pEtr=79187">
				<% End If %>
					<div><span><em>9</em> / 16</span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79187/m/img_thumnail_9.jpg" alt="샤워기 헤드 필터" /></div>
					<h3>샤워기 헤드 필터</h3>
					<%' for dev msg : 실시간 가격노출 유지(이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1631367
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
					<p>수돗물 속 잔류염소, 오래된 수도관 녹물을<br />정화해 주는 필터</p>
					<dl>
						<dt>추천이유</dt>
						<dd>사용하던 샤워기 그대로 4인 가족 기준 45~60일, 7200리터 필터링 가능. 필터를 통해 안 좋은 성분이 제거된 후 잔류염소는 비타민C겔로 환원되는 원리.<br />아토피 안심마크 획득.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=876782&amp;pEtr=79187'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=876782&pEtr=79187">
				<% End If %>
					<div><span><em>10</em> / 16</span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79187/m/img_thumnail_10.jpg" alt="목욕 바디 브러쉬" /></div>
					<h3>목욕 바디 브러쉬</h3>
					<%' for dev msg : 실시간 가격노출 유지(이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 876782
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
					<p>돼지털과 말털로 만들어진 천연 원목 브러쉬</p>
					<dl>
						<dt>추천이유</dt>
						<dd>화학 가공을 일절 하지 않은 천연소재로 피부를 깨끗하게 유지하도록 돕습니다. 바디클렌저를 적당히 묻혀 손이나 발 끝부터 몸 중앙을 향해 원을 그리듯 마사지 해주세요.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1315788&amp;pEtr=79187'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1315788&pEtr=79187">
				<% End If %>
					<div><span><em>11</em> / 16</span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79187/m/img_thumnail_11.jpg" alt="피부에 빛을 주는 바스 솔트" /></div>
					<h3>피부에 빛을 주는 바스 솔트</h3>
					<%' for dev msg : 실시간 가격노출 유지(이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1315788
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
					<p>99.5%의 미네랄 솔트와 천연 비타민을 배합해<br /> 한정 생산 된 솔트</p>
					<dl>
						<dt>추천이유</dt>
						<dd>자극 없이 각질 제거를 도우며, 마린 향으로 릴렉싱을 도와 줍니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1173231&amp;pEtr=79187'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1173231&pEtr=79187">
				<% End If %>
					<div><span><em>12</em> / 16</span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79187/m/img_thumnail_12.jpg" alt="다이어트 노트" /></div>
					<h3>다이어트 노트</h3>
					<%' for dev msg : 실시간 가격노출 유지(이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1173231
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
					<p>50일간의 다이어트를 기록합니다.</p>
					<dl>
						<dt>추천이유</dt>
						<dd>체중 변화를 한 눈에 체크 가능한 레이아웃. 나도 모르게 세뇌되는 다이어트 주문이 표지가 되어 매일 매일 좋아지는 나를 발견 할 수 있습니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1724771&amp;pEtr=79187'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1724771&pEtr=79187">
				<% End If %>
					<div><span><em>13</em> / 16</span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79187/m/img_thumnail_13.jpg" alt="이너워터팩" /></div>
					<h3>이너워터팩</h3>
					<%' for dev msg : 실시간 가격노출 유지(이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1724771
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
					<p>건조레몬과 향긋한 플라워 티,<br />리프레쉬를 위한 구아바잎의 워터팩</p>
					<dl>
						<dt>추천이유</dt>
						<dd>생 레몬을 사서 닦아서 잘라서 물에 넣어먹기 귀찮은<br />당신을 위한 물 섭취 처방팩.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1617119&amp;pEtr=79187'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1617119&pEtr=79187">
				<% End If %>
					<div><span><em>14</em> / 16</span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79187/m/img_thumnail_14.jpg" alt="공기압 마사지기" /></div>
					<h3>공기압 마사지기</h3>
					<%' for dev msg : 실시간 가격노출 유지(이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1617119
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
					<p>안 해본 사람은 있어도, 한번만 해본 사람은 없다는 마력을 가진 마사지기</p>
					<dl>
						<dt>추천이유</dt>
						<dd>다리 붓기 빼기와 혈액순환을 돕는 나만의 홈 에스테틱<br />아이템 입니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1743088&amp;pEtr=79187'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1743088&pEtr=79187">
				<% End If %>
					<div><span><em>15</em> / 16</span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79187/m/img_thumnail_15.jpg" alt="순수 산소를 담은 산소캔" /></div>
					<h3>순수 산소를 담은 산소캔</h3>
					<%' for dev msg : 실시간 가격노출 유지(이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1743088
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
					<p>뜨거운 공기와 숨막히는 환경에서 산소를 공급하는 산소캔</p>
					<dl>
						<dt>추천이유</dt>
						<dd>답답한 사무실이나 먼지가 많은 환경에서 내 몸에 신선함을 공급하는데 도움이 됩니다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1650044&amp;pEtr=79187'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1650044&pEtr=79187">
				<% End If %>
					<div><span><em>16</em> / 16</span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79187/m/img_thumnail_16.jpg" alt="건강한 내 몸을 위한 습관" /></div>
					<h3>건강한 내 몸을 위한 습관</h3>
					<%' for dev msg : 실시간 가격노출 유지(이하 상품 동일) %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1650044
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
					<p>면역력을 키워 스트레스에 대한 내성을 키우는데 도움을 주는 보조식품 셋트</p>
					<dl>
						<dt>추천이유</dt>
						<dd>고르기 어려운 유산균과 비타민의 고민을 덜어주는 인테이크 착한 셋트 하루 한번으로 건강한 습관을 만들어줍니다.</dd>
					</dl>
				</a>
			</li>
		</ul>
	</div>
	<%'// 상품 목록 %>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->