<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 바디케어 이벤트
' History : 2017.07.17 원승현
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
	eCode = "66396"
Else
	eCode = "79298"
End If

nowdate = date()
'nowdate = "2017-01-01"

vUserID = getEncLoginUserID
%>
<style type="text/css">
.mEvt78571 {background:#fff;}
.evtTit {}
.itemList {padding:0 7.8125%;}
.itemList ul {overflow:hidden; margin:0 auto; width:100%;}
.itemList ul li {padding-bottom:5.5rem; vertical-align:top; text-align:left;}
.itemList ul li a {display:block;}
.itemList ul li a:hover {text-decoration:none;}
.itemList ul li h3 {font-size:1.7rem; line-height:1.2;; color:#252525; font-weight:600;}
.itemList ul li dl {padding:1.3rem 2rem 0;}
.itemList ul li dt {display:inline-block; padding:0.4rem 0 0.8rem; font-size:1.25rem; color:#252525; border-top:2px solid #252525; font-weight:600;}
.itemList ul li dd {font-size:1.2rem; color:#666; line-height:1.5;}
.itemList ul li .itemInfo {margin-top:2rem; padding:0 2rem;}
.itemList ul li .itemInfo p {overflow:hidden; width:100%; font-size:1.2rem; color:#666; line-height:1.5;}
.itemList ul li .itemInfo span {float:left; width:50%;}
.itemList ul li .itemInfo span:first-child {width:50%;}
.itemList ul li .price {padding:1.3rem 0; font-size:1.2rem; letter-spacing:-0.04rem; color:#9c9c9c; font-weight:600; white-space:nowrap;}
.itemList ul li .price del {font-size:1.1rem;}
.itemList ul li .price strong {color:#df4b4b; font-size:1.3rem;}
.movieWrap {padding:0 7.8125% 3.3rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/79298/m/bg_movie.png) 50% 0 no-repeat; background-size:100% auto;}
.movieWrap .movie {overflow:hidden; position:relative; height:100%; padding-bottom:73.70%;}
.movieWrap .movie iframe {position:absolute; top:0; left:0; bottom:0; width:100%; height:100%;}
</style>

<div class="mEvt78571 care">
	<div class="evtTit">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/79298/m/tit_food.png" alt="[Tasting Store] Diet food - 당신이 먹어보기 전, 텐바이텐이 먼저 테스트 해드립니다." /></h2>
		<div class="movieWrap">
			<div class="movie"><iframe src="https://www.youtube.com/embed/rA2x52R4xIg" frameborder="0" allowfullscreen></iframe></div>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/79298/m/txt_better.png" alt="Better things for Everyday task - '케어' 속의 리뷰 코너! 당신의 바디 관리를 돕습니다" /></p>
	</div>

	<div class="itemList">
		<ul>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1678326&amp;pEtr=79298'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1678326&pEtr=79298">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79298/m/img_item_1.jpg" alt="" /></span>
					<div class="itemInfo">
						<h3>더슬림 도시락</h3>
						<%' for dev msg : 실시간 가격노출 유지(이하 상품 동일) %>
						<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1678326
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
						%>
						<% If oItem.FResultCount > 0 Then %>
							<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
								<div class="price"><del><%= FormatNumber(oItem.Prd.FOrgPrice,0)%></del> <strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong> (개당 할인시 약<%= formatnumber( CLng((oItem.Prd.FSellCash/8)), 0) %>원)</div>
							<% Else %>
								<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong> (개당 약<%= formatnumber(CLng((oItem.Prd.FOrgPrice/8)),0) %>원)</div>
							<% End If %>
						<% End If %>
						<% set oItem=nothing %>
						<p>
							<span>칼로리 : 346kcal</span>
							<span>중량 : 202g</span>
						</p>
						<p>
							<span>식품군 : 도시락</span>
							<span>포만감 : ★★★★</span>
						</p>
						<p>구성 : 제육볶음, 브로콜리,나물밥</p>
					</div>
					<dl>
						<dt>맛</dt>
						<dd>고기가 크지않고 짜잘해서 먹기 편했다<br />나물밥이 요물.동봉된 고추장에 비벼먹으면 세상꿀맛</dd>
					</dl>
					<dl>
						<dt>추천이유</dt>
						<dd>풍부한 리뷰와 다양한 메뉴로 다이어터들의<br />입맛을 사로잡은 맛좋은 다이어트 도시락</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1659068&amp;pEtr=79298'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1659068&pEtr=79298">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79298/m/img_item_2.jpg" alt="" /></span>
					<div class="itemInfo">
						<h3>슈퍼스무디 시크릿블랙(14개입)</h3>
						<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1659068
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
						%>
						<% If oItem.FResultCount > 0 Then %>
							<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
								<div class="price"><del><%= FormatNumber(oItem.Prd.FOrgPrice,0)%></del> <strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong> (개당 할인시 약<%= formatnumber( CLng((oItem.Prd.FSellCash/14)), 0) %>원)</div>
							<% Else %>
								<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong> (개당 약<%= formatnumber(CLng((oItem.Prd.FOrgPrice/14)),0) %>원)</div>
							<% End If %>
						<% End If %>
						<% set oItem=nothing %>
						<p>
							<span>칼로리 : 100kcal</span>
							<span>중량 : 개당 30g</span>
						</p>
						<p>
							<span>식품군 : 가루형 쉐이크</span>
							<span>포만감 : ★★★</span>
						</p>
						<p>구성 : 슈퍼스무디 14개</p>
					</div>
					<dl>
						<dt>맛</dt>
						<dd>고소하고 묵직한 스무디 식감. 다 먹을 즈음 톡톡튀는 바질씨가 나를 위로해주는 느낌</dd>
					</dl>
					<dl>
						<dt>추천이유</dt>
						<dd>다른 다이어트 대용식보다 간편하고<br />의외의 포만감이 상당해서 아침 저녁으로<br />먹기 좋은 다이어트 식품!</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1507511&amp;pEtr=79298'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1507511&pEtr=79298">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79298/m/img_item_3.jpg" alt="" /></span>
					<div class="itemInfo">
						<h3>딜리핏 3종 도시락 시즌2 - 12팩</h3>
						<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1507511
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
						%>
						<% If oItem.FResultCount > 0 Then %>
							<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
								<div class="price"><del><%= FormatNumber(oItem.Prd.FOrgPrice,0)%></del> <strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong> (개당 할인시 약<%= formatnumber( CLng((oItem.Prd.FSellCash/12)), 0) %>원)</div>
							<% Else %>
								<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong> (개당 약<%= formatnumber(CLng((oItem.Prd.FOrgPrice/12)),0) %>원)</div>
							<% End If %>
						<% End If %>
						<% set oItem=nothing %>
						<p>
							<span>칼로리 : 365kcal</span>
							<span>중량 : 210g</span>
						</p>
						<p>
							<span>식품군 : 도시락</span>
							<span>포만감 : ★★★</span>
						</p>
						<p>구성 : 현미밥,미니스테이크,계란후라이</p>
					</div>
					<dl>
						<dt>맛</dt>
						<dd>비법 간장소스에 비벼먹는 나물밥에 다이어트라고<br />생각되지않는 함박스테이크가 의외로 맛있다</dd>
					</dl>
					<dl>
						<dt>추천이유</dt>
						<dd>딜리핏의 새로운 3종메뉴로<br />함박스테이크의 합류로 더욱 업그레이드 했다.</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1724772&amp;pEtr=79298'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1724772&pEtr=79298">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79298/m/img_item_4.jpg" alt="" /></span>
					<div class="itemInfo">
						<h3>이너워터팩 잘빠진그대<br />20DAYS 패키지</h3>
						<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1724772
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
						%>
						<% If oItem.FResultCount > 0 Then %>
							<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
								<div class="price"><del><%= FormatNumber(oItem.Prd.FOrgPrice,0)%></del> <strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong> (개당 할인시 약<%= formatnumber( CLng((oItem.Prd.FSellCash/20)), 0) %>원)</div>
							<% Else %>
								<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong> (개당 약<%= formatnumber(CLng((oItem.Prd.FOrgPrice/20)),0) %>원)</div>
							<% End If %>
						<% End If %>
						<% set oItem=nothing %>
						<p>
							<span>칼로리 : 0kcal</span>
							<span>중량 : 개당 4.5g</span>
						</p>
						<p>
							<span>식품군 : 건조식품</span>
							<span>포만감 : ★</span>
						</p>
						<p>구성 : 이너워터팩 20개</p>
					</div>
					<dl>
						<dt>맛</dt>
						<dd>예쁜 빨간색 물이 보는맛을 주고<br />고소한 곡물차 맛이 무한 드링킹을 부른다.</dd>
					</dl>
					<dl>
						<dt>추천이유</dt>
						<dd>다이어트에 빠질 수 없는 물.<br />맛있으면 0칼로리를 실현시킨<br />이너워터팩 고소한 차를 물처럼 마실 수 있다</dd>
					</dl>
				</a>
			</li>
			<li>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1184962&amp;pEtr=79298'); return false;"> 
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1184962&pEtr=79298">
				<% End If %>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/79298/m/img_item_5.jpg" alt="" /></span>
					<div class="itemInfo">
						<h3>파워닭 치킨브레스트 바질맛</h3>
						<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1184962
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
						%>
						<% If oItem.FResultCount > 0 Then %>
							<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
								<div class="price"><del><%= FormatNumber(oItem.Prd.FOrgPrice,0)%></del> <strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(0, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong> (개당 할인시 약<%= formatnumber( CLng((oItem.Prd.FSellCash/8)), 0) %>원)</div>
							<% Else %>
								<div class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong> (개당 약<%= formatnumber(CLng((oItem.Prd.FOrgPrice/8)),0) %>원)</div>
							<% End If %>
						<% End If %>
						<% set oItem=nothing %>
						<p>
							<span>칼로리 : 137kcal</span>
							<span>중량 : 개당 약110g</span>
						</p>
						<p>
							<span>식품군 : 닭가슴살</span>
							<span>포만감 : ★★</span>
						</p>
						<p>구성 : 8~10개</p>
					</div>
					<dl>
						<dt>맛</dt>
						<dd>마늘향과 양파향 바질향과 닭가슴살이 잘어우러진다. 싱겁지만 괜찮다. 구워 먹는걸 추천!</dd>
					</dl>
					<dl>
						<dt>추천이유</dt>
						<dd>닭가슴살을 보다 향긋하게 즐길 수 있다.<br />바질이 들어있어 다른요리에 쉽게 응용해도<br />음식이 살아난다.</dd>
					</dl>
				</a>
			</li>
		</ul>
	</div>
	<p class="btnEvtGo">
		<a href="eventmain.asp?eventid=79187"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79298/m/bnr_go_body.jpg" alt="COOLING CARE 이벤트로 이동하기" /></a>
	</p>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->