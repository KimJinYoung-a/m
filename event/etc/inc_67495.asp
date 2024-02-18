<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<%
	Response.Charset="UTF-8"
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 2015 크리스마스
' History : 2015-11-19 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<%
dim cEvent, cEventItem, intI
dim egCode, itemlimitcnt,iTotCnt
dim eitemsort, itemid, eItemListType
dim eCode

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  65952
	Else
		eCode   =  67495
	End If

	intI =0
	itemlimitcnt = 8	'상품최대갯수(큰이미지+작은이미지)
	eitemsort = 3		'정렬방법
	eItemListType = "1"	'격자형

%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}
.christmas2015 {text-align:center; padding-bottom:5rem; margin-bottom:-5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67495/m/bg_stripe.png) 0 0 repeat; background-size:100% 2px;}
.xmasItem {position:relative;}
.xmasItem:first-child {margin-top:0;}
.xmasItem:last-child {margin-bottom:0;}
.xmasItem h3 {width:100%; color:#fff; font-weight:bold; letter-spacing:-0.02rem;}
.xmasItem h3 span {position:relative; display:inline-block;}
.xmasItem .name {overflow:hidden; color:#222; font-size:1.3rem; font-weight:bold; text-overflow:ellipsis; white-space:nowrap;}
.xmasItem .price {color:#000; font-size:1.2rem;}
.xmasItem .swiper-slide {width:11rem; margin-right:0.5rem;}
.xmasItem .swiper-slide:first-child {margin-left:6.25%;}
.xmasItem div.swiper-slide:last-child {margin-right:6.25%;}
.xmasItem .viewMore a {display:inline-block; width:100%; height:100%;}
.xmasItem .viewMore a img {display:inline-block; position:absolute; left:50%; top:50%; width:6.6rem; margin:-0.9rem 0 0 -3.3rem;}

/* type A */
.type01 {margin:3.5rem 0;}
.type01 h3 {position:absolute; left:0; top:2.2rem; z-index:40;}
.type01 h3 span { padding:3px; background-color:#000;}
.type01 h3 span em {display:inline-block; height:2.4rem; padding:0 1.4rem; font-size:1.4rem; line-height:2.4rem; border:1px solid #fff; }
.type01 .mainItem {padding:0 6.25% 1.5rem;}
.type01 .mainItem .boxWrap {position:relative; z-index:30; padding:0.5rem; background:#fff; box-shadow:0 0 12px 5px rgba(0,0,0,.1);}
.type01 .mainItem .boxWrap:before {content:''; display:inline-block; position:absolute; left:0; top:0; width:0; height:0; border-style: solid; border-width:19rem 19rem 0 0; border-color:#b4945f transparent transparent transparent; z-index:-1;}
.type01 .mainItem .box {padding:6rem 14.2% 7%; border:1.5px solid #f7f7f7;}
.type01 .mainItem .name {padding:1.8rem 0 0.6rem; font-size:1.4rem;}
.type01 .mainItem .price {font-size:1.3rem;}
.type01 .swiper-slide {height:15rem;}
.type01 .swiper-slide .name {padding:1rem 0.6rem 0.5rem;}
.type01 .viewMore {border-top:2px solid #000; border-bottom:2px solid #000;}
.xmasItem:first-child,
.xmasItem:nth-child(8) {padding-bottom:5.5rem; margin-bottom:2.2rem; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67495/m/bg_deco.png) 0 100% no-repeat; background-size:100% auto;}
.xmasItem:nth-child(2),
.xmasItem:nth-child(9) {margin-top:0;}
.xmasItem:nth-child(2) .boxWrap:before {border-color:#57af7e  transparent transparent transparent;}
.xmasItem:nth-child(4) .boxWrap:before {border-color:#bf4345 transparent transparent transparent;}
.xmasItem:nth-child(8) .boxWrap:before {border-color:#485e91 transparent transparent transparent;}
.xmasItem:nth-child(9) .boxWrap:before {border-color:#57af7e transparent transparent transparent;}
.xmasItem:nth-child(11) .boxWrap:before {border-color:#c83e42 transparent transparent transparent;}

/* type B */
.type02 {padding:9% 0 14%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67495/m/bg_item_type_b.jpg) 0 0 no-repeat; background-size:100% 100%;}
.type02 h3 {margin-bottom:7.2%;}
.type02 h3 span {height:2.6rem; line-height:2.8rem; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67495/m/bg_tag_ct.png) 0 0 repeat-x; background-size:100% 100%;}
.type02 h3 span:before,
.type02 h3 span:after {content:''; display:inline-block; position:absolute; top:0; width:2.5rem; height:2.6rem; background-position:0 0; background-repeat:no-repeat; background-size:100% 100%;}
.type02 h3 span:before {left:-2.5rem; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/67495/m/bg_tag_lt.png);}
.type02 h3 span:after {right:-2.55rem; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/67495/m/bg_tag_rt.png)}
.type02 h3 span em {font-size:1.3rem; padding:0 1rem;}
.type02 .swiper-slide {height:16rem; background-color:#fff;}
.type02 .swiper-slide .name {padding:1rem 0.6rem 0.5rem;}
.type02 .viewMore {background:rgba(0,0,0,.5);}

/* type C */
.type03 {padding:4rem 0 2.8rem; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67495/m/bg_item_type_c.png) 0 0 no-repeat; background-size:100% 100%;}
.type03 .photo {overflow:hidden; position: relative;}
.type03 .swiper-slide {width:12.5rem; margin-right:-0.4rem;}
.type03 div.viewMore a img {position:static; width:100%; margin:0;}
</style>
<script>
$(function(){
	var swiper1 = new Swiper('.swiper1', {
		slidesPerView:'auto'
	});
	var swiper2 = new Swiper('.swiper2', {
		slidesPerView:'auto'
	});
	var swiper3 = new Swiper('.swiper3', {
		slidesPerView:'auto'
	});
	var swiper4 = new Swiper('.swiper4', {
		slidesPerView:'auto'
	});
	var swiper5 = new Swiper('.swiper5', {
		slidesPerView:'auto'
	});
	var swiper6 = new Swiper('.swiper6', {
		slidesPerView:'auto'
	});
	var swiper7 = new Swiper('.swiper7', {
		slidesPerView:'auto'
	});
	var swiper8 = new Swiper('.swiper8', {
		slidesPerView:'auto'
	});
	var swiper9 = new Swiper('.swiper9', {
		slidesPerView:'auto'
	});

	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			swiper1.reInit();
			swiper2.reInit();
			swiper3.reInit();
			swiper4.reInit();
			swiper5.reInit();
			swiper6.reInit();
			swiper7.reInit();
			swiper8.reInit();
			swiper9.reInit();
			clearInterval(oTm);
		}, 500);
	});
});

//상품이동
function jsViewItem(i){
	<% if isApp=1 then %>
		parent.fnAPPpopupProduct(i);
		return false;
	<% else %>
		top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
		return false;
	<% end if %>
}

// 이벤트 이동
function goEventLink(evt) {
	<% if isApp then %>
		fnAPPpopupBrowserURL("Gold Magic Christmas","http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid="+evt);
//		fnAPPpopupEvent_14th(evt);
//		fnAPPpopupEvent_URL("http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid="+evt);
//		fnAPPpopupEvent(evt);
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
</script>
	<div class="christmas2015">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/67495/m/tit_christmas.png" alt="Gold Magic Christmas" /></h2>
		<div class="goldmagicXmas">


			<%''// type A %>
			<div class="xmasItem type01">
				<h3><span><em>북유럽 스타일 트리</em></span></h3>
				<%
				set cEventItem = new ClsEvtItem
				cEventItem.FECode 	= eCode
				IF application("Svr_Info") = "Dev" THEN
					cEventItem.FEGCode 	= 136734	''egCode
				else
					cEventItem.FEGCode 	= 165433	''egCode
				end if
				cEventItem.FEItemCnt= itemlimitcnt
				cEventItem.FItemsort= eitemsort
				cEventItem.fnGetEventItem_v2
				iTotCnt = cEventItem.FTotCnt
			
				IF itemid = "" THEN
					itemid = cEventItem.FItemArr
				ELSE
					itemid = itemid&","&cEventItem.FItemArr
				END IF
				%>
				<div class="mainItem">
					<div class="boxWrap">
						<div class="box">
							<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(0).Fitemid %>'); return false;">
								<div class="photo"><img src="<%= cEventItem.FCategoryPrdList(0).FImageBasic %>" alt="<%= cEventItem.FCategoryPrdList(0).FItemName %>" /></div>
								<p class="name"><%= cEventItem.FCategoryPrdList(0).FItemName %></p>
								<% IF cEventItem.FCategoryPrdList(0).IsSaleItem or cEventItem.FCategoryPrdList(0).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(0).IsSaleItem Then %>
										<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(0).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(0).getSalePro %>]</span></p>
									<% End IF %>
									<% IF cEventItem.FCategoryPrdList(0).IsCouponItem Then %>
										<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(0).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(0).GetCouponDiscountStr %>]</span></p>
									<% End IF %>
								<% Else %>
									<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(0).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(0).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
								<% End if %>
							</a>
						</div>
					</div>
				</div>

				<div class="thumbItem">
					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
							<!-- 1set -->
							<% For intI =1 To iTotCnt %>
								<div class="swiper-slide">
									<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>'); return false;">
										<div class="photo"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,220,220,"true","false") %>" alt="<%= cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
										<p class="name"><%= cEventItem.FCategoryPrdList(intI).FItemName %></p>
										<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
											<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</span></p>
											<% End IF %>
											<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
											<% End IF %>
										<% Else %>
											<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
										<% End if %>
									</a>
								</div>
							<% next %>
							<% set cEventItem = nothing %>
							<% ''// ★마지막 슬라이드는 항상 MORE 들어갑니다★ %>
							<div class="swiper-slide viewMore">
								<a href="" onclick="goEventLink('67496'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67495/m/btn_more_01.png" alt="MORE" /></a>
							</div>
						</div>
					</div>
				</div>
			</div>
			<%''// type A %>


			<%''// type A %>
			<div class="xmasItem type01">
				<h3><span><em>크리스마스 조명</em></span></h3>
				<%
				set cEventItem = new ClsEvtItem
				cEventItem.FECode 	= eCode
				IF application("Svr_Info") = "Dev" THEN
					cEventItem.FEGCode 	= 136738	''egCode
				else
					cEventItem.FEGCode 	= 165437	''egCode
				end if
				cEventItem.FEItemCnt= itemlimitcnt
				cEventItem.FItemsort= eitemsort
				cEventItem.fnGetEventItem_v2
				iTotCnt = cEventItem.FTotCnt
			
				IF itemid = "" THEN
					itemid = cEventItem.FItemArr
				ELSE
					itemid = itemid&","&cEventItem.FItemArr
				END IF
				%>
				<div class="mainItem">
					<div class="boxWrap">
						<div class="box">
							<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(0).Fitemid %>'); return false;">
								<div class="photo"><img src="<%= cEventItem.FCategoryPrdList(0).FImageBasic %>" alt="<%= cEventItem.FCategoryPrdList(0).FItemName %>" /></div>
								<p class="name"><%= cEventItem.FCategoryPrdList(0).FItemName %></p>
								<% IF cEventItem.FCategoryPrdList(0).IsSaleItem or cEventItem.FCategoryPrdList(0).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(0).IsSaleItem Then %>
										<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(0).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(0).getSalePro %>]</span></p>
									<% End IF %>
									<% IF cEventItem.FCategoryPrdList(0).IsCouponItem Then %>
										<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(0).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(0).GetCouponDiscountStr %>]</span></p>
									<% End IF %>
								<% Else %>
									<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(0).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(0).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
								<% End if %>
							</a>
						</div>
					</div>
				</div>

				<div class="thumbItem">
					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
							<!-- 1set -->
							<% For intI =1 To iTotCnt %>
								<div class="swiper-slide">
									<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>'); return false;">
										<div class="photo"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,220,220,"true","false") %>" alt="<%= cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
										<p class="name"><%= cEventItem.FCategoryPrdList(intI).FItemName %></p>
										<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
											<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</span></p>
											<% End IF %>
											<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
											<% End IF %>
										<% Else %>
											<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
										<% End if %>
									</a>
								</div>
							<% next %>
							<% set cEventItem = nothing %>
							<% ''// ★마지막 슬라이드는 항상 MORE 들어갑니다★ %>
							<div class="swiper-slide viewMore">
								<a href="" onclick="goEventLink('67501'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67495/m/btn_more_01.png" alt="MORE" /></a>
							</div>
						</div>
					</div>
				</div>
			</div>
			<%''// type A %>


			<%''// type B %>
			<div class="xmasItem type02">
				<h3><span><em>포인트 장식 소품</em></span></h3>
				<div class="thumbItem">
					<div class="swiper-container swiper3">
						<div class="swiper-wrapper">
							<%
							set cEventItem = new ClsEvtItem
							cEventItem.FECode 	= eCode
							IF application("Svr_Info") = "Dev" THEN
								cEventItem.FEGCode 	= 136741	''egCode
							else
								cEventItem.FEGCode 	= 165440	''egCode
							end if
							cEventItem.FEItemCnt= itemlimitcnt
							cEventItem.FItemsort= eitemsort
							cEventItem.fnGetEventItem_v2
							iTotCnt = cEventItem.FTotCnt
						
							IF itemid = "" THEN
								itemid = cEventItem.FItemArr
							ELSE
								itemid = itemid&","&cEventItem.FItemArr
							END IF
							%>
							<!-- 1set -->
							<% For intI =0 To iTotCnt %>
								<div class="swiper-slide">
									<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>'); return false;">
										<div class="photo"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,220,220,"true","false") %>" alt="<%= cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
										<p class="name"><%= cEventItem.FCategoryPrdList(intI).FItemName %></p>
										<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
											<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</span></p>
											<% End IF %>
											<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
											<% End IF %>
										<% Else %>
											<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
										<% End if %>
									</a>
								</div>
							<% next %>
							<% set cEventItem = nothing %>
							<!--// 1set -->
							<!-- ★마지막 슬라이드는 항상 MORE 들어갑니다★ -->
							<div class="swiper-slide viewMore">
								<a href="" onclick="goEventLink('67504'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67495/m/btn_more_02.png" alt="MORE" /></a>
							</div>
						</div>
					</div>
				</div>
			</div>
			<%''// type B %>


			<%''// type A %>
			<div class="xmasItem type01">
				<h3><span><em>크리스마스 리스</em></span></h3>
				<%
				set cEventItem = new ClsEvtItem
				cEventItem.FECode 	= eCode
				IF application("Svr_Info") = "Dev" THEN
					cEventItem.FEGCode 	= 136743	''egCode
				else
					cEventItem.FEGCode 	= 165442	''egCode
				end if
				cEventItem.FEItemCnt= itemlimitcnt
				cEventItem.FItemsort= eitemsort
				cEventItem.fnGetEventItem_v2
				iTotCnt = cEventItem.FTotCnt
			
				IF itemid = "" THEN
					itemid = cEventItem.FItemArr
				ELSE
					itemid = itemid&","&cEventItem.FItemArr
				END IF
				%>
				<div class="mainItem">
					<div class="boxWrap">
						<div class="box">
							<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(0).Fitemid %>'); return false;">
								<div class="photo"><img src="<%= cEventItem.FCategoryPrdList(0).FImageBasic %>" alt="<%= cEventItem.FCategoryPrdList(0).FItemName %>" /></div>
								<p class="name"><%= cEventItem.FCategoryPrdList(0).FItemName %></p>
								<% IF cEventItem.FCategoryPrdList(0).IsSaleItem or cEventItem.FCategoryPrdList(0).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(0).IsSaleItem Then %>
										<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(0).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(0).getSalePro %>]</span></p>
									<% End IF %>
									<% IF cEventItem.FCategoryPrdList(0).IsCouponItem Then %>
										<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(0).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(0).GetCouponDiscountStr %>]</span></p>
									<% End IF %>
								<% Else %>
									<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(0).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(0).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
								<% End if %>
							</a>
						</div>
					</div>
				</div>

				<div class="thumbItem">
					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
							<!-- 1set -->
							<% For intI =1 To iTotCnt %>
								<div class="swiper-slide">
									<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>'); return false;">
										<div class="photo"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,220,220,"true","false") %>" alt="<%= cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
										<p class="name"><%= cEventItem.FCategoryPrdList(intI).FItemName %></p>
										<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
											<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</span></p>
											<% End IF %>
											<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
											<% End IF %>
										<% Else %>
											<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
										<% End if %>
									</a>
								</div>
							<% next %>
							<% set cEventItem = nothing %>
							<% ''// ★마지막 슬라이드는 항상 MORE 들어갑니다★ %>
							<div class="swiper-slide viewMore">
								<a href="" onclick="goEventLink('67506'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67495/m/btn_more_01.png" alt="MORE" /></a>
							</div>
						</div>
					</div>
				</div>
			</div>
			<%''// type A %>


			<%''// type C (요기는 개발없이 코딩까지만!!!) %>
			<div class="xmasItem type03">
				<div class="thumbItem">
					<div class="swiper-container swiper5">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<a href="" onclick="goEventLink('67511'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67495/m/bnr_kwd_01.png" alt="크리스마스카드" /></a>
							</div>
							<div class="swiper-slide">
								<a href="" onclick="goEventLink('67502'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67495/m/bnr_kwd_02.png" alt="캔들" /></a>
							</div>
							<div class="swiper-slide">
								<a href="" onclick="goEventLink('67508'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67495/m/bnr_kwd_03.png" alt="호두까기" /></a>
							</div>
							<div class="swiper-slide">
								<a href="" onclick="goEventLink('67499'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67495/m/bnr_kwd_04.png" alt="스티커" /></a>
							</div>
							<div class="swiper-slide">
								<a href="" onclick="goEventLink('67510'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67495/m/bnr_kwd_05.png" alt="파티테이블" /></a>
							</div>
							<div class="swiper-slide">
								<a href="" onclick="goEventLink('67509'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67495/m/bnr_kwd_06.png" alt="커트러리" /></a>
							</div>
							<div class="swiper-slide">
								<a href="" onclick="goEventLink('67505'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67495/m/bnr_kwd_07.png" alt="캔들 홀더" /></a>
							</div>
						</div>
					</div>
				</div>
			</div>
			<%''// type C %>


			<%''// type A %>
			<div class="xmasItem type01">
				<h3><span><em>크리스마스 데코 전구</em></span></h3>
				<%
				set cEventItem = new ClsEvtItem
				cEventItem.FECode 	= eCode
				IF application("Svr_Info") = "Dev" THEN
					cEventItem.FEGCode 	= 136735	''egCode
				else
					cEventItem.FEGCode 	= 165434	''egCode
				end if
				cEventItem.FEItemCnt= itemlimitcnt
				cEventItem.FItemsort= eitemsort
				cEventItem.fnGetEventItem_v2
				iTotCnt = cEventItem.FTotCnt
			
				IF itemid = "" THEN
					itemid = cEventItem.FItemArr
				ELSE
					itemid = itemid&","&cEventItem.FItemArr
				END IF
				%>
				<div class="mainItem">
					<div class="boxWrap">
						<div class="box">
							<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(0).Fitemid %>'); return false;">
								<div class="photo"><img src="<%= cEventItem.FCategoryPrdList(0).FImageBasic %>" alt="<%= cEventItem.FCategoryPrdList(0).FItemName %>" /></div>
								<p class="name"><%= cEventItem.FCategoryPrdList(0).FItemName %></p>
								<% IF cEventItem.FCategoryPrdList(0).IsSaleItem or cEventItem.FCategoryPrdList(0).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(0).IsSaleItem Then %>
										<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(0).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(0).getSalePro %>]</span></p>
									<% End IF %>
									<% IF cEventItem.FCategoryPrdList(0).IsCouponItem Then %>
										<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(0).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(0).GetCouponDiscountStr %>]</span></p>
									<% End IF %>
								<% Else %>
									<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(0).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(0).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
								<% End if %>
							</a>
						</div>
					</div>
				</div>

				<div class="thumbItem">
					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
							<!-- 1set -->
							<% For intI =1 To iTotCnt %>
								<div class="swiper-slide">
									<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>'); return false;">
										<div class="photo"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,220,220,"true","false") %>" alt="<%= cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
										<p class="name"><%= cEventItem.FCategoryPrdList(intI).FItemName %></p>
										<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
											<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</span></p>
											<% End IF %>
											<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
											<% End IF %>
										<% Else %>
											<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
										<% End if %>
									</a>
								</div>
							<% next %>
							<% set cEventItem = nothing %>
							<% ''// ★마지막 슬라이드는 항상 MORE 들어갑니다★ %>
							<div class="swiper-slide viewMore">
								<a href="" onclick="goEventLink('67497'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67495/m/btn_more_01.png" alt="MORE" /></a>
							</div>
						</div>
					</div>
				</div>
			</div>
			<%''// type A %>


			<% ''// 참여 이벤트 %>
			<% if date() >= "2015-12-14" then %>
				<div class="mainItem"><a href="" onclick="goEventLink('67490'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67495/m/bnr_apply_event_v3.png" alt="참여이벤트 바로가기" /></a></div>
			<% else %>
				<div class="mainItem"><a href="" onclick="goEventLink('67489'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67495/m/bnr_apply_event_v2.png" alt="참여이벤트 바로가기" /></a></div>
			<% end if %>


			<%''// type A %>
			<div class="xmasItem type01">
				<h3><span><em>트리 장식</em></span></h3>
				<%
				set cEventItem = new ClsEvtItem
				cEventItem.FECode 	= eCode
				IF application("Svr_Info") = "Dev" THEN
					cEventItem.FEGCode 	= 136740	''egCode
				else
					cEventItem.FEGCode 	= 165439	''egCode
				end if
				cEventItem.FEItemCnt= itemlimitcnt
				cEventItem.FItemsort= eitemsort
				cEventItem.fnGetEventItem_v2
				iTotCnt = cEventItem.FTotCnt
			
				IF itemid = "" THEN
					itemid = cEventItem.FItemArr
				ELSE
					itemid = itemid&","&cEventItem.FItemArr
				END IF
				if iTotCnt > 0 then
				%>
				<div class="mainItem">
					<div class="boxWrap">
						<div class="box">
							<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(0).Fitemid %>'); return false;">
								<div class="photo"><img src="<%= cEventItem.FCategoryPrdList(0).FImageBasic %>" alt="<%= cEventItem.FCategoryPrdList(0).FItemName %>" /></div>
								<p class="name"><%= cEventItem.FCategoryPrdList(0).FItemName %></p>
								<% IF cEventItem.FCategoryPrdList(0).IsSaleItem or cEventItem.FCategoryPrdList(0).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(0).IsSaleItem Then %>
										<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(0).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(0).getSalePro %>]</span></p>
									<% End IF %>
									<% IF cEventItem.FCategoryPrdList(0).IsCouponItem Then %>
										<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(0).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(0).GetCouponDiscountStr %>]</span></p>
									<% End IF %>
								<% Else %>
									<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(0).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(0).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
								<% End if %>
							</a>
						</div>
					</div>
				</div>

				<div class="thumbItem">
					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
							<!-- 1set -->
							<% For intI =1 To iTotCnt %>
								<div class="swiper-slide">
									<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>'); return false;">
										<div class="photo"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,220,220,"true","false") %>" alt="<%= cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
										<p class="name"><%= cEventItem.FCategoryPrdList(intI).FItemName %></p>
										<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
											<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</span></p>
											<% End IF %>
											<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
											<% End IF %>
										<% Else %>
											<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
										<% End if %>
									</a>
								</div>
							<% next %>
							<% set cEventItem = nothing %>
							<% ''// ★마지막 슬라이드는 항상 MORE 들어갑니다★ %>
							<div class="swiper-slide viewMore">
								<a href="" onclick="goEventLink('67503'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67495/m/btn_more_01.png" alt="MORE" /></a>
							</div>
						</div>
					</div>
				</div>
			</div>
			<% end if %>
			<%''// type A %>


			<%''// type B %>
			<div class="xmasItem type02">
				<h3><span><em>워터볼 / 오르골</em></span></h3>
				<div class="thumbItem">
					<div class="swiper-container swiper3">
						<div class="swiper-wrapper">
							<%
							set cEventItem = new ClsEvtItem
							cEventItem.FECode 	= eCode
							IF application("Svr_Info") = "Dev" THEN
								cEventItem.FEGCode 	= 136744	''egCode
							else
								cEventItem.FEGCode 	= 165443	''egCode
							end if
							cEventItem.FEItemCnt= itemlimitcnt
							cEventItem.FItemsort= eitemsort
							cEventItem.fnGetEventItem_v2
							iTotCnt = cEventItem.FTotCnt
						
							IF itemid = "" THEN
								itemid = cEventItem.FItemArr
							ELSE
								itemid = itemid&","&cEventItem.FItemArr
							END IF
							%>
							<!-- 1set -->
							<% For intI =0 To iTotCnt %>
								<div class="swiper-slide">
									<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>'); return false;">
										<div class="photo"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,220,220,"true","false") %>" alt="<%= cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
										<p class="name"><%= cEventItem.FCategoryPrdList(intI).FItemName %></p>
										<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
											<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</span></p>
											<% End IF %>
											<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
											<% End IF %>
										<% Else %>
											<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
										<% End if %>
									</a>
								</div>
							<% next %>
							<% set cEventItem = nothing %>
							<!--// 1set -->
							<!-- ★마지막 슬라이드는 항상 MORE 들어갑니다★ -->
							<div class="swiper-slide viewMore">
								<a href=""  onclick="goEventLink('67507'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67495/m/btn_more_02.png" alt="MORE" /></a>
							</div>
						</div>
					</div>
				</div>
			</div>
			<%''// type B %>


			<%''// type A %>
			<div class="xmasItem type01">
				<h3><span><em>모빌 / 가랜더</em></span></h3>
				<%
				set cEventItem = new ClsEvtItem
				cEventItem.FECode 	= eCode
				IF application("Svr_Info") = "Dev" THEN
					cEventItem.FEGCode 	= 136737	''egCode
				else
					cEventItem.FEGCode 	= 165436	''egCode
				end if
				cEventItem.FEItemCnt= itemlimitcnt
				cEventItem.FItemsort= eitemsort
				cEventItem.fnGetEventItem_v2
				iTotCnt = cEventItem.FTotCnt
			
				IF itemid = "" THEN
					itemid = cEventItem.FItemArr
				ELSE
					itemid = itemid&","&cEventItem.FItemArr
				END IF
				%>
				<div class="mainItem">
					<div class="boxWrap">
						<div class="box">
							<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(0).Fitemid %>'); return false;">
								<div class="photo"><img src="<%= cEventItem.FCategoryPrdList(0).FImageBasic %>" alt="<%= cEventItem.FCategoryPrdList(0).FItemName %>" /></div>
								<p class="name"><%= cEventItem.FCategoryPrdList(0).FItemName %></p>
								<% IF cEventItem.FCategoryPrdList(0).IsSaleItem or cEventItem.FCategoryPrdList(0).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(0).IsSaleItem Then %>
										<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(0).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(0).getSalePro %>]</span></p>
									<% End IF %>
									<% IF cEventItem.FCategoryPrdList(0).IsCouponItem Then %>
										<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(0).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(0).GetCouponDiscountStr %>]</span></p>
									<% End IF %>
								<% Else %>
									<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(0).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(0).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
								<% End if %>
							</a>
						</div>
					</div>
				</div>

				<div class="thumbItem">
					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
							<!-- 1set -->
							<% For intI =1 To iTotCnt %>
								<div class="swiper-slide">
									<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>'); return false;">
										<div class="photo"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,220,220,"true","false") %>" alt="<%= cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
										<p class="name"><%= cEventItem.FCategoryPrdList(intI).FItemName %></p>
										<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
											<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</span></p>
											<% End IF %>
											<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
											<% End IF %>
										<% Else %>
											<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
										<% End if %>
									</a>
								</div>
							<% next %>
							<% set cEventItem = nothing %>
							<% ''// ★마지막 슬라이드는 항상 MORE 들어갑니다★ %>
							<div class="swiper-slide viewMore">
								<a href="" onclick="goEventLink('67500'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67495/m/btn_more_01.png" alt="MORE" /></a>
							</div>
						</div>
					</div>
				</div>
			</div>
			<%''// type A %>


		</div>
	</div>
<script type="text/javascript">
$(function(){
	
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->