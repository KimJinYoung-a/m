 <%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#############################################################
' Description : 크리스마스 기획전 MA
' History : 2017-11-06 유태욱 생성
'#############################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include Virtual="/lib/util/htmllib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/etc/event72792Cls.asp" -->
<%
	Dim eCode, oItem, intI, cEventItem, iTotCnt, itemid
	dim userid, i, UserAppearChk, nowdate

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  67461
	Else
		eCode   =  81815
	End If

	userid = GetEncLoginUserID()
	nowdate = Left(Now(), 10)
'																							nowdate = "2017-09-20"
%>
<style type="text/css">

.christmas2017 .topic {background:#000;}

.christmas2017 #alone {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/81815/m/bg_noise_1.png);}
.christmas2017 #couple {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/81815/m/bg_noise_2.png);}
.christmas2017 #many {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/81815/m/bg_noise_3.png);}
.christmas2017 .items {background:none;}
.christmas2017 .color-red {color:#ff3131 !important;}
.christmas2017 .items .price b {font-family:'AvenirNext-Regular', 'AppleSDGothicNeo-Regular', 'RobotoRegular', 'Noto Sans', sans-serif;}

.christmas2017 .section {padding-bottom:6.83rem; background-position:0 0; background-repeat:repeat; background-size:100% auto;}
.christmas2017 .section .represent {position:relative;}
.christmas2017 .section .represent .btn-plus {display:block; position:absolute; right:1.88rem; bottom:3rem; width:4.2rem; height:4.2rem; background:rgba(0,0,0,.5); vertical-align:top; border-radius:50%; text-indent:-999em;}
.christmas2017 .section .represent .btn-plus:before,.section .represent .btn-plus:after {content:''; display:inline-block; position:absolute; left:50%; top:50%; width:0.1rem; height:1.8rem; margin:-0.9rem 0 0 -0.05rem; background:#fff; transition:all .3s;}
.christmas2017 .section .represent .btn-plus:after {transform:rotate(90deg);}
.christmas2017 .section .represent .deco {position:absolute;}
.christmas2017 #alone .represent .deco {right:0; top:52%; width:37.33333%;}
.christmas2017 #couple .represent .deco {left:0; top:0; width:38.66666%;}
.christmas2017 #many .represent .d1 {left:0; top:9%; width:24%;}
.christmas2017 #many .represent .d2 {right:0; top:9%; width:50.66666%;}

.christmas2017 .represent-item {overflow:hidden; position:relative; height:0; margin:0; padding:0; background:url(http://webimage.10x10.co.kr/eventIMG/2017/81815/m/bg_noise_4.png) 0 0 repeat; background-size:100% auto; transition:height .3s;}
.christmas2017 .represent-item.category-item-list .items ul {margin-top:0; padding-top:2.13rem;}
.christmas2017 .represent-item.category-item-list .items li {margin-top:0;}
.christmas2017 .represent-item.category-item-list .items a {height:12.5rem;}
.christmas2017 .represent-item .items .price {margin-top:1rem;}
.christmas2017 .represent-item .items .sum {color:#fff;}
.christmas2017 .section.view-more .represent-item {height:28.5rem; margin-top:-1rem;}
.christmas2017 .section.view-more .represent .btn-plus:before {transform:rotate(-45deg);}
.christmas2017 .section.view-more .represent .btn-plus:after {transform:rotate(45deg);}

.christmas2017 .story {position:relative; margin-top:-1.2rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/81815/m/bg_story_1.png?v=1) 0 0 no-repeat; background-size:100% auto;}
.christmas2017 #couple .story {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/81815/m/bg_story_2.png?v=1);}
.christmas2017 #many .story {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/81815/m/bg_story_3.png?v=1);}

.christmas2017 .pick-list {margin-top:0; padding:0; background:none;}
.christmas2017 .pick-list .items ul {width:30.4rem; margin-top:0;}
.christmas2017 .pick-list .items li {width:14.34rem; margin:0.88rem 0.43rem 0; background:#fff;}
.christmas2017 .pick-list .items a {overflow:hidden; height:22.5rem;}
.christmas2017 .pick-list .items .thumbnail {width:14.34rem; height:14.34rem;}
.christmas2017 .pick-list .items .desc {padding:1.7rem 1.37rem 0;}
.christmas2017 .pick-list .items .name {height:auto; max-height:2.82rem; margin-top:0;}
.christmas2017 .pick-list .items .price {margin-top:0.8rem; }

.christmas2017 .christmas-bnr ul {overflow:hidden; padding-top:0.85rem; background-color:#fff;}
.christmas2017 .christmas-bnr li {float:left; width:50%; padding-bottom:0.85rem;}
.christmas2017 .christmas-bnr li:first-child,.christmas-bnr li:last-child {width:100%;}

.christmas2017 .christmas-best {background-color:#fff;}
.christmas2017 .christmas-best .sortingbar-best {padding-top:3.75rem; padding-bottom:1.79rem;}

</style>
<script type="text/javascript">
$(function(){
	$(".btn-plus").click(function(){
		$(this).closest(".section").toggleClass("view-more");
		window.parent.$('html,body').delay(200).animate({scrollTop:$(this.hash).offset().top},800);
		return false;
	});
});

	//script 에서 queryString 처리 (파라메터 값을 받아 온다) 
	var getQueryString = function ( field, url ) {  
		var href = url ? url : window.location.href;  
		var reg = new RegExp( "[?&]" + field + "=([^&#]*)", "i" );  
		var string = reg.exec(href);  return string ? string[1] : null; 
	};  
	//함수형태로 가저온 쿼리 스트링에 필요한 값만 추출한다
	//gnbflag 파라메타 명 ex) http://........?gnbflag=파라메타값 
	var gf = getQueryString("gnbflag");


function goEventLink(evt) {
	<% if isApp then %>
		if (!gf){
			parent.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid='+evt;
		}else{
			fnAPPpopupEvent(evt);
		}
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}

function jsViewItem(i){
	<% if isApp=1 then %>
		parent.fnAPPpopupProduct(i);
		return false;
	<% else %>
		top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
		return false;
	<% end if %>
}

</script>
	<!-- 2017 크리스마스 기획전 -->
	<div class="mEvt81815 christmas2017">
		<div class="topic">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/tit_christmas_v4.jpg" alt="I Wish We Feel Christmas" /></h2>
		</div>

		<div class="christmas-cont">

			<!-- 1.혼자서 여유롭게 -->
			<div id="alone" class="section">
				<div class="represent">
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_alone.jpg?v=1" alt="" />
					<a href="#more1" id="more1" class="btn-plus">더보기</a>
					<div class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_deco_1.gif" alt="" /></div>
				</div>
				<!-- 이미지 속 상품(고정) -->
				<section class="represent-item category-item-list">
					<div class="items">
						<ul>
							<!-- for dev msg : 상품가격, 링크 연결해주세요 -->
							<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1782597
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
								<li>
									<a href="" onclick="jsViewItem('1782597&pEtr=81815'); return false;">
										<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_alone_item_1.jpg" alt="[킨토] OCT 머그 300ml" /></div>
										<div class="desc">
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
													<div class="price">
														<b class="discount color-red"><%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</b>
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% else %>
													<div class="price">
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% end if %>
											<% end if %>
										</div>
									</a>
								</li>
							<% Set oItem = Nothing %>

							<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1761652
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
								<li>
									<a href="" onclick="jsViewItem('1761652&pEtr=81815'); return false;">
										<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_alone_item_2.jpg" alt="시아 우드도마 3type" /></div>
										<div class="desc">
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
													<div class="price">
														<b class="discount color-red"><%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</b>
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% else %>
													<div class="price">
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% end if %>
											<% end if %>
										</div>
									</a>
								</li>
							<% Set oItem = Nothing %>

							<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 972555
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
								<li>
									<a href="" onclick="jsViewItem('972555&pEtr=81815'); return false;">
										<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_alone_item_3.jpg" alt="Brown candle-DEEP WOOD" /></div>
										<div class="desc">
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
													<div class="price">
														<b class="discount color-red"><%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</b>
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% else %>
													<div class="price">
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% end if %>
											<% end if %>
										</div>
									</a>
								</li>
							<% Set oItem = Nothing %>

							<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1797423
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
								<li>
									<a href="" onclick="jsViewItem('1797423&pEtr=81815'); return false;">
										<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_alone_item_4.jpg" alt="인리나스 아이보리 니트블랭킷" /></div>
										<div class="desc">
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
													<div class="price">
														<b class="discount color-red"><%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</b>
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% else %>
													<div class="price">
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% end if %>
											<% end if %>
										</div>
									</a>
								</li>
							<% Set oItem = Nothing %>

							<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1366309
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
								<li>
									<a href="" onclick="jsViewItem('1366309&pEtr=81815'); return false;">
										<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_alone_item_5.jpg" alt="Dome glass candle" /></div>
										<div class="desc">
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
													<div class="price">
														<b class="discount color-red"><%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</b>
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% else %>
													<div class="price">
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% end if %>
											<% end if %>
										</div>
									</a>
								</li>
							<% Set oItem = Nothing %>

							<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1823631
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
								<li>
									<a href="" onclick="jsViewItem('1823631&pEtr=81815'); return false;">
										<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_alone_item_6.jpg" alt="파스텔 앤틱 우드 촛대(캔들홀더)" /></div>
										<div class="desc">
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
													<div class="price">
														<b class="discount color-red"><%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</b>
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% else %>
													<div class="price">
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% end if %>
											<% end if %>
										</div>
									</a>
								</li>
							<% Set oItem = Nothing %>
						</ul>
					</div>
				</section>
				<div class="story"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/txt_story_1_v2.png" alt="혼자서 여유롭게 - 혼자라면 무조건 외롭다는 편견을 뒤로하고 한 해 동안의 나를 돌아보는 시간을 가져요. 향 좋은 캔들 하나 켜두고, 깊은 생각에 빠지는 하루는 지친 마음을 여유롭게 만들어 줄 거예요." /></div>
				<!-- 이벤트 상품(변동) -->
				<section class="category-item-list pick-list">
					<div class="items">
						<ul>
						<%
						dim rstArrItemid: rstArrItemid=""
						dim iLp, vWishArr
						intI = 0
		
						set cEventItem = new ClsEvtItem
						cEventItem.FECode 	= 81816
						cEventItem.FEGCode 	= 224147
						cEventItem.FEPGsize 	= 5
		'				cEventItem.Frectminnum= 11
		'				cEventItem.Frectmaxnum= 20
						cEventItem.fnGetEventItem_v2
						iTotCnt = cEventItem.FTotCnt
						%>
						<% IF (iTotCnt >= 0) THEN %>
							<% For intI =0 To iTotCnt %>
								<li>
									<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=81815'); return false;">
										<div class="thumbnail"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="" /></div>
										<div class="desc">
											<p class="name"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
											<div class="price">
												<%
													If cEventItem.FCategoryPrdList(intI).IsSaleItem AND cEventItem.FCategoryPrdList(intI).isCouponItem Then	'### 쿠폰 O 세일 O
														Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
														Response.Write "&nbsp;<b class=""discount color-red"">" & cEventItem.FCategoryPrdList(intI).getSalePro & "</b>"
														If cEventItem.FCategoryPrdList(intI).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
															If InStr(cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
																Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
															Else
																Response.Write "&nbsp;<b class=""discount color-green"">" & cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr & "<small>쿠폰</small></b>"
															End If
														End If
														Response.Write "</div>" &  vbCrLf
													ElseIf cEventItem.FCategoryPrdList(intI).IsSaleItem AND (Not cEventItem.FCategoryPrdList(intI).isCouponItem) Then	'### 쿠폰 X 세일 O
														Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) & "<span class=""won"">원</span></b>"
														Response.Write "&nbsp;<b class=""discount color-red"">" & cEventItem.FCategoryPrdList(intI).getSalePro & "</b>"
														Response.Write "</div>" &  vbCrLf
													ElseIf cEventItem.FCategoryPrdList(intI).isCouponItem AND (NOT cEventItem.FCategoryPrdList(intI).IsSaleItem) Then	'### 쿠폰 O 세일 X
														Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
														If cEventItem.FCategoryPrdList(intI).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
															If InStr(cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
																Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
															Else
																Response.Write "&nbsp;<b class=""discount color-green"">" & cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr & "<small>쿠폰</small></b>"
															End If
														End If
														Response.Write "</div>" &  vbCrLf
													Else
														Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) & "<span class=""won"">" & CHKIIF(cEventItem.FCategoryPrdList(intI).IsMileShopitem," Point","원") & "</span></b></div>" &  vbCrLf
													End If
												%>
											</div>
										</div>
									</a>
								</li>
							<% next %>
						<% end if %>
						<% set cEventItem = nothing %>
							<li>
								<a href="" onclick="goEventLink('81817'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/btn_more_1.jpg" alt="상품 더 보기" /></a>
							</li>
						</ul>
					</div>
				</section>
			</div>

			<!-- 2.둘이서 오붓하게 -->
			<div id="couple" class="section">
				<div class="represent">
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_couple.jpg" alt="" />
					<a href="#more2" id="more2" class="btn-plus">더보기</a>
					<div class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_deco_2.gif?v=1" alt="" /></div>
				</div>
				<!-- 이미지 속 상품(고정) -->
				<section class="represent-item category-item-list">
					<div class="items">
						<ul>
							<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1741337
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
								<li>
									<a href="" onclick="jsViewItem('1741337&pEtr=81815'); return false;">
										<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_couple_item_1.jpg" alt="오븐치킨" /></div>
										<div class="desc">
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
													<div class="price">
														<b class="discount color-red"><%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</b>
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% else %>
													<div class="price">
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% end if %>
											<% end if %>
										</div>
									</a>
								</li>
							<% set oItem = nothing %>

							<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1781560
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
								<li>
									<a href="" onclick="jsViewItem('1781560&pEtr=81815'); return false;">
										<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_couple_item_2.jpg" alt="감바스 알 아히요" /></div>
										<div class="desc">
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
													<div class="price">
														<b class="discount color-red"><%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</b>
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% else %>
													<div class="price">
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% end if %>
											<% end if %>
										</div>
									</a>
								</li>
							<% set oItem = nothing %>

							<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1756450
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
								<li>
									<a href="" onclick="jsViewItem('1756450&pEtr=81815'); return false;">
										<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_couple_item_3.jpg" alt="양숄더랙 500g" /></div>
										<div class="desc">
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
													<div class="price">
														<b class="discount color-red"><%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</b>
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% else %>
													<div class="price">
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% end if %>
											<% end if %>
										</div>
									</a>
								</li>
							<% set oItem = nothing %>

							<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1781554
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
								<li>
									<a href="" onclick="jsViewItem('1781554&pEtr=81815'); return false;">
										<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_couple_item_4.jpg" alt="브루스케타 시스터즈" /></div>
										<div class="desc">
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
													<div class="price">
														<b class="discount color-red"><%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</b>
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% else %>
													<div class="price">
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% end if %>
											<% end if %>
										</div>
									</a>
								</li>
							<% set oItem = nothing %>

							<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1783467
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
								<li>
									<a href="" onclick="jsViewItem('1783467&pEtr=81815'); return false;">
										<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_couple_item_5.jpg" alt="볼볼오리진 2인 홈세트" /></div>
										<div class="desc">
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
													<div class="price">
														<b class="discount color-red"><%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</b>
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% else %>
													<div class="price">
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% end if %>
											<% end if %>
										</div>
									</a>
								</li>
							<% set oItem = nothing %>

							<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1496208
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
								<li>
									<a href="" onclick="jsViewItem('1496208&pEtr=81815'); return false;">
										<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_couple_item_6.jpg" alt="[킨토] 페틀 디저트 볼" /></div>
										<div class="desc">
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
													<div class="price">
														<b class="discount color-red"><%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</b>
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% else %>
													<div class="price">
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% end if %>
											<% end if %>
										</div>
									</a>
								</li>
							<% set oItem = nothing %>
						</ul>
					</div>
				</section>
				<div class="story"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/txt_story_2_v2.png" alt="둘이서 오붓하게 - 북적거리는 사람들 틈 속이 아닌 둘만이 간직할 수 있는 저녁 식사를 해요. 함께 장을 보고, 서툰 요리 실력을 뽐내고, 아껴 두었던 그릇을 꺼내 식탁을 채워, 사랑하는 사람과 마주 앉아 그 순간을 공유하세요." /></div>
				<!-- 이벤트 상품(변동) -->
				<section class="category-item-list pick-list">
					<div class="items">
						<ul>
						<%
						intI = 0
						set cEventItem = new ClsEvtItem
						cEventItem.FECode 	= 81816
						cEventItem.FEGCode 	= 224153
						cEventItem.FEPGsize 	= 5
		'				cEventItem.Frectminnum= 11
		'				cEventItem.Frectmaxnum= 20
						cEventItem.fnGetEventItem_v2
						iTotCnt = cEventItem.FTotCnt
						%>
						<% IF (iTotCnt >= 0) THEN %>
							<% For intI =0 To iTotCnt %>
								<li>
									<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=81815'); return false;">
										<div class="thumbnail"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="" /></div>
										<div class="desc">
											<p class="name"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
											<div class="price">
												<%
													If cEventItem.FCategoryPrdList(intI).IsSaleItem AND cEventItem.FCategoryPrdList(intI).isCouponItem Then	'### 쿠폰 O 세일 O
														Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
														Response.Write "&nbsp;<b class=""discount color-red"">" & cEventItem.FCategoryPrdList(intI).getSalePro & "</b>"
														If cEventItem.FCategoryPrdList(intI).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
															If InStr(cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
																Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
															Else
																Response.Write "&nbsp;<b class=""discount color-green"">" & cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr & "<small>쿠폰</small></b>"
															End If
														End If
														Response.Write "</div>" &  vbCrLf
													ElseIf cEventItem.FCategoryPrdList(intI).IsSaleItem AND (Not cEventItem.FCategoryPrdList(intI).isCouponItem) Then	'### 쿠폰 X 세일 O
														Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) & "<span class=""won"">원</span></b>"
														Response.Write "&nbsp;<b class=""discount color-red"">" & cEventItem.FCategoryPrdList(intI).getSalePro & "</b>"
														Response.Write "</div>" &  vbCrLf
													ElseIf cEventItem.FCategoryPrdList(intI).isCouponItem AND (NOT cEventItem.FCategoryPrdList(intI).IsSaleItem) Then	'### 쿠폰 O 세일 X
														Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
														If cEventItem.FCategoryPrdList(intI).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
															If InStr(cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
																Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
															Else
																Response.Write "&nbsp;<b class=""discount color-green"">" & cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr & "<small>쿠폰</small></b>"
															End If
														End If
														Response.Write "</div>" &  vbCrLf
													Else
														Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) & "<span class=""won"">" & CHKIIF(cEventItem.FCategoryPrdList(intI).IsMileShopitem," Point","원") & "</span></b></div>" &  vbCrLf
													End If
												%>
											</div>
										</div>
									</a>
								</li>
							<% next %>
						<% end if %>
						<% set cEventItem = nothing %>
							<li>
								<a href="" onclick="goEventLink('81818'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/btn_more_2.jpg" alt="상품 더 보기" /></a>
							</li>
						</ul>
					</div>
				</section>
			</div>

			<!-- 3.여럿이 즐겁게 -->
			<div id="many" class="section">
				<div class="represent">
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_many.jpg" alt="" />
					<a href="#more3" id="more3" class="btn-plus">더보기</a>
					<div class="deco d1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_deco_3.gif" alt="" /></div>
					<div class="deco d2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_deco_4.gif" alt="" /></div>
				</div>
				<!-- 이미지 속 상품(고정) -->
				<section class="represent-item category-item-list">
					<div class="items">
						<ul>
							<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1823627
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
								<li>
									<a href="" onclick="jsViewItem('1823627&pEtr=81815'); return false;">
										<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_many_item_1.jpg" alt="파인 트리 리스" /></div>
										<div class="desc">
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
													<div class="price">
														<b class="discount color-red"><%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</b>
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% else %>
													<div class="price">
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% end if %>
											<% end if %>
										</div>
									</a>
								</li>
							<% set oItem = nothing %>

							<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1617876
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
								<li>
									<a href="" onclick="jsViewItem('1617876&pEtr=81815'); return false;">
										<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_many_item_2.jpg" alt="룬라핀 파티 크라운" /></div>
										<div class="desc">
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
													<div class="price">
														<b class="discount color-red"><%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</b>
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% else %>
													<div class="price">
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% end if %>
											<% end if %>
										</div>
									</a>
								</li>
							<% set oItem = nothing %>

							<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 829889
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
								<li>
									<a href="" onclick="jsViewItem('829889&pEtr=81815'); return false;">
										<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_many_item_3.jpg" alt="테이블 탑 트리" /></div>
										<div class="desc">
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
													<div class="price">
														<b class="discount color-red"><%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</b>
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% else %>
													<div class="price">
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% end if %>
											<% end if %>
										</div>
									</a>
								</li>
							<% set oItem = nothing %>

							<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1607129
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
								<li>
									<a href="" onclick="jsViewItem('1607129&pEtr=81815'); return false;">
										<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_many_item_4.jpg" alt="비 메리 파티 컵" /></div>
										<div class="desc">
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
													<div class="price">
														<b class="discount color-red"><%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</b>
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% else %>
													<div class="price">
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% end if %>
											<% end if %>
										</div>
									</a>
								</li>
							<% set oItem = nothing %>

							<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1822917
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
								<li>
									<a href="" onclick="jsViewItem('1822917&pEtr=81815'); return false;">
										<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_many_item_5.jpg" alt="와이어 우드 스타 오너먼트" /></div>
										<div class="desc">
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
													<div class="price">
														<b class="discount color-red"><%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</b>
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% else %>
													<div class="price">
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% end if %>
											<% end if %>
										</div>
									</a>
								</li>
							<% set oItem = nothing %>

							<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1384659
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
								<li>
									<a href="" onclick="jsViewItem('1384659&pEtr=81815'); return false;">
										<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/img_many_item_6.jpg" alt="프리미엄 리얼소나무트리" /></div>
										<div class="desc">
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
													<div class="price">
														<b class="discount color-red"><%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</b>
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% else %>
													<div class="price">
														<b class="sum"><%= FormatNumber(oItem.Prd.FSellCash,0) %><span class="won"><%= chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></span></b>
													</div>
												<% end if %>
											<% end if %>
										</div>
									</a>
								</li>
							<% set oItem = nothing %>
						</ul>
					</div>
				</section>
				<div class="story"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/txt_story_3_v2.png" alt="여럿이 즐겁게 - 편한 사람들과 편안한 모습으로 조금은 시끌벅적한 크리스마스를 즐겨요. 맛있는 음식을 나누고, 소소한 이야기를 나누며 오래도록 간직할 추억거리를 하나 더 쌓아 보세요." /></div>
				<!-- 이벤트 상품(변동) -->
				<section class="category-item-list pick-list">
					<div class="items">
						<ul>
						<%
						intI = 0
						set cEventItem = new ClsEvtItem
						cEventItem.FECode 	= 81816
						cEventItem.FEGCode 	= 224154
						cEventItem.FEPGsize 	= 5
		'				cEventItem.Frectminnum= 11
		'				cEventItem.Frectmaxnum= 20
						cEventItem.fnGetEventItem_v2
						iTotCnt = cEventItem.FTotCnt
						%>
						<% IF (iTotCnt >= 0) THEN %>
							<% For intI =0 To iTotCnt %>
								<li>
									<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=81815'); return false;">
										<div class="thumbnail"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="" /></div>
										<div class="desc">
											<p class="name"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
											<div class="price">
												<%
													If cEventItem.FCategoryPrdList(intI).IsSaleItem AND cEventItem.FCategoryPrdList(intI).isCouponItem Then	'### 쿠폰 O 세일 O
														Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
														Response.Write "&nbsp;<b class=""discount color-red"">" & cEventItem.FCategoryPrdList(intI).getSalePro & "</b>"
														If cEventItem.FCategoryPrdList(intI).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
															If InStr(cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
																Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
															Else
																Response.Write "&nbsp;<b class=""discount color-green"">" & cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr & "<small>쿠폰</small></b>"
															End If
														End If
														Response.Write "</div>" &  vbCrLf
													ElseIf cEventItem.FCategoryPrdList(intI).IsSaleItem AND (Not cEventItem.FCategoryPrdList(intI).isCouponItem) Then	'### 쿠폰 X 세일 O
														Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) & "<span class=""won"">원</span></b>"
														Response.Write "&nbsp;<b class=""discount color-red"">" & cEventItem.FCategoryPrdList(intI).getSalePro & "</b>"
														Response.Write "</div>" &  vbCrLf
													ElseIf cEventItem.FCategoryPrdList(intI).isCouponItem AND (NOT cEventItem.FCategoryPrdList(intI).IsSaleItem) Then	'### 쿠폰 O 세일 X
														Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
														If cEventItem.FCategoryPrdList(intI).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
															If InStr(cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
																Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
															Else
																Response.Write "&nbsp;<b class=""discount color-green"">" & cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr & "<small>쿠폰</small></b>"
															End If
														End If
														Response.Write "</div>" &  vbCrLf
													Else
														Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) & "<span class=""won"">" & CHKIIF(cEventItem.FCategoryPrdList(intI).IsMileShopitem," Point","원") & "</span></b></div>" &  vbCrLf
													End If
												%>
											</div>
										</div>
									</a>
								</li>
							<% next %>
						<% end if %>
						<% set cEventItem = nothing %>
							<li>
								<a href="" onclick="goEventLink('81819'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/btn_more_3.jpg" alt="상품 더 보기" /></a>
							</li>
						</ul>
					</div>
				</section>
			</div>

			<!-- 연동 이벤트 -->
			<div id="bnr" class="christmas-bnr">
				<ul>
					<li><a href="" onclick="goEventLink('81823'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/bnr_event_1.jpg?v=1" alt="색,다른 크리스마스" /></a></li>
					<li><a href="" onclick="goEventLink('81820'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/bnr_event_2.jpg?v=1" alt="1인 아이템" /></a></li>
					<li><a href="" onclick="goEventLink('81821'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/bnr_event_3.jpg?v=1" alt="커플 아이템" /></a></li>
					<li><a href="" onclick="goEventLink('81822'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81815/m/bnr_event_4.jpg?v=1" alt="크리스마스 카드" /></a></li>
				</ul>
			</div>

			<!-- 크리스마스 베스트 아이템 -->
			<div id="best" class="christmas-best">
				<div class="sortingbar sortingbar-best">
					<span class="headline"><em class="color-red">크리스마스</em><br />BEST ITEMS</span>
				</div>
				<div class="items type-list tenten-best-default">
					<ul>
					<%
					intI = 0
					set cEventItem = new ClsEvtItem
					cEventItem.FECode 	= 81816
					cEventItem.FEGCode 	= ""
					cEventItem.FEPGsize 	= 20
	'				cEventItem.Frectminnum= 11
	'				cEventItem.Frectmaxnum= 20
					cEventItem.fnGetEventItem_v2
					iTotCnt = cEventItem.FTotCnt
					%>
					<% IF (iTotCnt >= 0) THEN %>
						<% For intI =0 To iTotCnt %>
							<li>
								<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=81815'); return false;">
									<b class="no"><span class="rank"><%=intI+1%></span><%' 급상승처리불가능 <span class="icon icon-up">급상승</span> %></b>
									<div class="thumbnail"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="" /></div>
									<div class="desc">
										<span class="brand"><%= cEventItem.FCategoryPrdList(intI).FBrandName %></span>
										<p class="name"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
										<div class="price">
										<%
											If cEventItem.FCategoryPrdList(intI).IsSaleItem AND cEventItem.FCategoryPrdList(intI).isCouponItem Then	'### 쿠폰 O 세일 O
												Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
												Response.Write "&nbsp;<b class=""discount color-red"">" & cEventItem.FCategoryPrdList(intI).getSalePro & "</b>"
												If cEventItem.FCategoryPrdList(intI).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
													If InStr(cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
														Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
													Else
														Response.Write "&nbsp;<b class=""discount color-green"">" & cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr & "<small>쿠폰</small></b>"
													End If
												End If
												Response.Write "</div>" &  vbCrLf
											ElseIf cEventItem.FCategoryPrdList(intI).IsSaleItem AND (Not cEventItem.FCategoryPrdList(intI).isCouponItem) Then	'### 쿠폰 X 세일 O
												Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) & "<span class=""won"">원</span></b>"
												Response.Write "&nbsp;<b class=""discount color-red"">" & cEventItem.FCategoryPrdList(intI).getSalePro & "</b>"
												Response.Write "</div>" &  vbCrLf
											ElseIf cEventItem.FCategoryPrdList(intI).isCouponItem AND (NOT cEventItem.FCategoryPrdList(intI).IsSaleItem) Then	'### 쿠폰 O 세일 X
												Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
												If cEventItem.FCategoryPrdList(intI).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
													If InStr(cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
														Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
													Else
														Response.Write "&nbsp;<b class=""discount color-green"">" & cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr & "<small>쿠폰</small></b>"
													End If
												End If
												Response.Write "</div>" &  vbCrLf
											Else
												Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) & "<span class=""won"">" & CHKIIF(cEventItem.FCategoryPrdList(intI).IsMileShopitem," Point","원") & "</span></b></div>" &  vbCrLf
											End If
										%>
										</div>
									</div>
								</a>
							</li>
						<% next %>
					<% end if %>
					<% set cEventItem = nothing %>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<!--// 2017 크리스마스 기획전 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->