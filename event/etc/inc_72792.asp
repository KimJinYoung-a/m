<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [★★2016 F/W 웨딩 메인] A SMALL WEDDING
' History : 2016-09-08 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include Virtual="/lib/util/htmllib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/etc/event72792Cls.asp" -->
<%
dim currenttime, eCode, subeCode, BigeCode, itemlimitcnt
dim eitemsort, eItemListType, cEventItem
dim egCode, itemid
dim userid, i, intI, iTotCnt, itemnum
dim egCodeBed, egCodeLiv, egCodeKit, egCodeDre, BigGroupCd
	userid = GetEncLoginUserID()

currenttime = now()
'currenttime = #09/26/2016 10:05:00#
''left(currenttime,10)

intI =0

IF application("Svr_Info") = "Dev" THEN
	eCode			= 66198	'현재 이벤트 코드
	subeCode		= 66200	'공간별 이벤트 코드
	BigeCode		= 66199	'빅세일 이벤트 코드( 1 WEEK SALE )
	egCodeBed		= 136973	'공간별 이벤트 - BEDROOM 그룹코드
	egCodeLiv		= 136979	'공간별 이벤트 - LIVINGROOM 그룹코드
	egCodeKit		= 136985	'공간별 이벤트 - KITCHEN 그룹코드
	egCodeDre		= 136991	'공간별 이벤트 - DRESSROOM 그룹코드

	'빅세일 이벤트 링크시 넘어갈 그룹 코드( 1 WEEK SALE )
	if left(currenttime,10) < "2016-09-26" then
		BigGroupCd = 136998
	elseif left(currenttime,10) >= "2016-09-26" and left(currenttime,10) < "2016-10-03" then
		BigGroupCd = 136999
	elseif left(currenttime,10) >= "2016-10-03" and left(currenttime,10) < "2016-10-10" then
		BigGroupCd = 137000
	elseif left(currenttime,10) >= "2016-10-10" then
		BigGroupCd = 137001
	end if
Else
	eCode			= 72792	'현재 이벤트 코드
	subeCode		= 73069	'공간별 이벤트 코드
	BigeCode		= 72793	'빅세일 이벤트 코드( 1 WEEK SALE )
	egCodeBed		= 188925	'공간별 이벤트 - BEDROOM 그룹코드
	egCodeLiv		= 188931	'공간별 이벤트 - LIVINGROOM 그룹코드
	egCodeKit		= 188937	'공간별 이벤트 - KITCHEN 그룹코드
	egCodeDre		= 188943	'공간별 이벤트 - DRESSROOM 그룹코드

	'빅세일 이벤트 링크시 넘어갈 그룹 코드( 1 WEEK SALE )
	if left(currenttime,10) < "2016-09-26" then
		BigGroupCd = 187549
	elseif left(currenttime,10) >= "2016-09-26" and left(currenttime,10) < "2016-10-03" then
		BigGroupCd = 187550
	elseif left(currenttime,10) >= "2016-10-03" and left(currenttime,10) < "2016-10-10" then
		BigGroupCd = 187551
	elseif left(currenttime,10) >= "2016-10-10" then
		BigGroupCd = 187552
	end if
End If

'IF egCode = "" THEN egCode = 0

'itemlimitcnt = 10	'상품최대갯수
'eitemsort = 3		'정렬방법
'eItemListType = "1"	'격자형

'IF itemid = "" THEN
'	itemid = cEventItem.FItemArr
'ELSE
'	itemid = itemid&","&cEventItem.FItemArr
'END IF

%>
<style type="text/css">
img {vertical-align:top;}
.evtHeadV15 {display:none;}
.bigSale {position:relative; padding-bottom:3.5rem; text-align:center; background:#fce7de;}
.bigSale .just1week {position:absolute; left:50%; top:0; width:10.6rem; height:2.9rem; margin-left:-5.3rem; font-size:1.1rem; line-height:2.2rem; color:#fff;  background:url(http://webimage.10x10.co.kr/eventIMG/2016/72792/m/bg_balloon.png) no-repeat 0 0; background-size:100% auto;}
.bigSale .swiper-container {position:relative; background:url(http://webimage.10x10.co.kr/eventIMG/2016/72792/m/bg_half_round.png) no-repeat 0 0; background-size:12.5% auto;}
.bigSale .swiper-slide {position:relative; width:56%;}
.bigSale .swiper-slide .pic {overflow:hidden; border-radius:50%;}
.bigSale .swiper-slide .pic img {border:0.4rem solid #fff; border-radius:50%;}
.bigSale .swiper-slide .itemInfo p {overflow:hidden; padding:1.2rem 0 0.7rem; font-size:1.2rem; font-weight:bold; text-overflow:ellipsis; white-space:nowrap;}
.bigSale .swiper-slide .itemInfo strong {font-size:1.2rem; color:#d60000;}
.bigSale .swiper-slide .itemInfo s {font-size:1.1rem; color:#646464; font-weight:normal;}
.bigSale .swiper-slide .rate {position:absolute; right:0.1rem; top:8.3%; width:4rem; height:4rem; font-size:1.4rem; color:#fff; line-height:4.1rem; font-weight:bold; background:#d81414; border-radius:50%;}
.halfBnr {overflow:hidden;}
.halfBnr li {float:left; width:50%;}
.selfHouse {padding-bottom:2.5rem; background:#fffae8;}
.selfHouse .itemGroup {padding:0 4.6% 2.7rem;}
.selfHouse .itemGroup ul:after {content:' '; display:block; clear:both;}
.selfHouse .itemGroup li {float:left; width:50%; padding-bottom:1.2rem;}
.selfHouse .itemGroup li:nth-child(even) {padding-left:1.8%;}
.selfHouse .itemGroup li:nth-child(odd) {padding-right:1.8%;}
.selfHouse .itemGroup li .itemInfo {padding:1.5rem 0 1.2rem; text-align:center; color:#000; line-height:1.1; background:#fff; border-radius:0 0 0.5rem 0.5rem; box-shadow:0 0.1rem 0.5rem 0.1rem #f5ead4;}
.selfHouse .itemGroup li .itemInfo p {overflow:hidden; padding:0 1rem 0.5rem; font-size:1.1rem; text-overflow:ellipsis; white-space:nowrap;}
.selfHouse .itemGroup li .itemInfo strong {font-size:1.2rem;}
.selfHouse .fullBnr {padding:0 4.6%;}
.selfHouse .fullBnr li {padding-bottom:0.35rem;}
.selfHouse .itemGroup li .itemInfo .price {height:2.5rem;}
.selfHouse .itemGroup li .itemInfo .price s {display:block; color:#999;}
</style>
<script type="text/javascript">
$(function(){
	$(".swiper-slide:first-child").addClass('swiper-slide-first');
	mySwiper1 = new Swiper('.bigSale .swiper-container',{
		loop:false,
		autoplay:false,
		speed:500,
		slidesPerView:'auto',
		centeredSlides:true,
		spaceBetween:"8%",
		pagination:false,
		onSlideChangeStart: function (mySwiper1) {
			$(".bigSale .swiper-container").css("background","none");
			if ($(".bigSale .swiper-slide-active").is(".swiper-slide-first")) {
				$(".bigSale .swiper-container").css("background","url(http://webimage.10x10.co.kr/eventIMG/2016/72792/m/bg_half_round.png) no-repeat 0 0");
				$(".bigSale .swiper-container").css("background-size","12.5% auto");
			}
		}
	});
});

function jsViewItem(i){
	<% if isApp=1 then %>
		parent.fnAPPpopupProduct(i);
		return false;
	<% else %>
		top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
		return false;
	<% end if %>
}

function goEventLink(evt) {
	<% if isApp then %>
		fnAPPpopupEvent(evt);
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
</script>
	<!-- 웨딩기획전 -->
	<div class="mEvt72792">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/72792/m/tit_small_wedding.png" alt="SMALL WEDDING" /></h2>
		<%
		set cEventItem = new ClsEvtItem
		cEventItem.FECode 	= BigeCode
		cEventItem.FEGCode 	= BigGroupCd
		cEventItem.FEPGsize 	= 5
		cEventItem.Frectminnum= 1
		cEventItem.Frectmaxnum= 50
		cEventItem.fnGetEventItem_v2
		iTotCnt = cEventItem.FTotCnt
		%>
		<% IF (iTotCnt >= 0) THEN %>
		<!-- BIG SALE -->
		<div class="bigSale">
			<p class="just1week">단 일주일만 <strong><% fnGetGroupMaxSalePer BigeCode,BigGroupCd %>%~</strong></p>
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/72792/m/tit_big_sale.png" alt="BIG SALE" /></h3>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<% For intI =0 To iTotCnt %>
						<div class="swiper-slide">
						<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=72792'); return false;">
							<div class="pic">
								<%'' for dev msg : 상품 상세 대표 이미지 400x400로 썸네일 넣어주세요 %>
								<div><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
								<% if cEventItem.FCategoryPrdList(intI).getSalePro <> "0%" then %><span class="rate"><% = cEventItem.FCategoryPrdList(intI).getSalePro %></span><% end if %>
							</div>
							<div class="itemInfo">
								<p><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
								<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
										<strong><s><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getorgPrice,0) %></s> <% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원</strong>
									<% End IF %>
								<% Else %>
									<strong><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원</strong>
								<% End if %>
							</div>
						</a>
						</div>
					<% next %>

					<% ''마지막 슬라이드는 하단 더보기 버튼 들어갑니다 %>
					<div class="swiper-slide">
						<a href="" onclick="goEventLink('<%= BigeCode %>&eGC=<%= BigGroupCd %>'); return false;">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/72792/m/btn_1week_sale.png" alt="단 일주일의 특가 상품 더 보러가기" />
						</a>
					</div>
				</div>
			</div>
		</div>
		<!--// BIG SALE -->
		<% end if %>
		<% set cEventItem = nothing %>

		<ul class="halfBnr">
			<li><a href="" onclick="goEventLink('72794'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72792/m/bnr_party.png" alt="웨딩 파티" /></a></li>
			<li><a href="" onclick="goEventLink('73007'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72792/m/bnr_membership.png" alt="웨딩 멤버십" /></a></li>
		</ul>

		<!-- SELF HOUSE -->
		<div class="selfHouse">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/72792/m/tit_self_house.png" alt="SELF HOUSE" /></h3>
			<%
			set cEventItem = new ClsEvtItem
			cEventItem.FECode 	= eCode
			cEventItem.FEGCode 	= egCode
			cEventItem.FEPGsize 	= 10
			cEventItem.Frectminnum= 1
			cEventItem.Frectmaxnum= 10
			cEventItem.fnGetEventItem_v2
			iTotCnt = cEventItem.FTotCnt
			%>
			<% IF (iTotCnt >= 0) THEN %>
			<!-- BED ROOM -->
			<div class="itemGroup">
				<h4><a href="eventmain.asp?eventid=<%= subeCode %>&eGC=<%= egCodeBed %>"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72792/m/tit_bedroom.png" alt="BEDROOM" /></a></h4>
				<ul>
					<% For intI =0 To iTotCnt %>
						<li>
							<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=72792'); return false;">
							<div class="pic"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
							<div class="itemInfo">
								<p><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
								<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
										<p class="price"><s><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getorgPrice,0) %></s><strong><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %> <em class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</em></strong></p>
									<% End IF %>
									<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
										<p class="price"><s><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %></s><strong><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %> <em class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</em></strong></p>
									<% End IF %>
								<% Else %>
									<p class="price"><strong><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %> <% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></strong></p>
								<% End if %>
							</div>
							</a>
						</li>
					<% next %>
				</ul>
			</div>
			<!--// BED ROOM -->
			<% end if %>
			<% set cEventItem = nothing %>


			<%
			set cEventItem = new ClsEvtItem
			cEventItem.FECode 	= eCode
			cEventItem.FEGCode 	= egCode
			cEventItem.FEPGsize 	= 10
			cEventItem.Frectminnum= 11
			cEventItem.Frectmaxnum= 20
			cEventItem.fnGetEventItem_v2
			iTotCnt = cEventItem.FTotCnt
			%>
			<% IF (iTotCnt >= 0) THEN %>
			<!-- LIVING ROOM -->
			<div class="itemGroup">
				<h4><a href="eventmain.asp?eventid=<%= subeCode %>&eGC=<%= egCodeLiv %>"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72792/m/tit_living.png" alt="LIVINGROOM" /></a></h4>
				<ul>
					<% For intI =0 To iTotCnt %>
						<li>
							<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=72792'); return false;">
							<div class="pic"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
							<div class="itemInfo">
								<p><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
								<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
										<p class="price"><s><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getorgPrice,0) %></s><strong><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %> <em class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</em></strong></p>
									<% End IF %>
									<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
										<p class="price"><s><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %></s><strong><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %> <em class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</em></strong></p>
									<% End IF %>
								<% Else %>
									<p class="price"><strong><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %> <% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></strong></p>
								<% End if %>
							</div>
							</a>
						</li>
					<% next %>
				</ul>
			</div>
			<!--// LIVING ROOM -->
			<% end if %>
			<% set cEventItem = nothing %>


			<%
			set cEventItem = new ClsEvtItem
			cEventItem.FECode 	= eCode
			cEventItem.FEGCode 	= egCode
			cEventItem.FEPGsize 	= 10
			cEventItem.Frectminnum= 21
			cEventItem.Frectmaxnum= 30
			cEventItem.fnGetEventItem_v2
			iTotCnt = cEventItem.FTotCnt
			%>
			<% IF (iTotCnt >= 0) THEN %>
			<!-- KITCHEN -->
			<div class="itemGroup">
				<h4><a href="eventmain.asp?eventid=<%= subeCode %>&eGC=<%= egCodeKit %>"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72792/m/tit_kitchen.png" alt="KITCHEN" /></a></h4>
				<ul>
					<% For intI =0 To iTotCnt %>
						<li>
							<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=72792'); return false;">
							<div class="pic"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
							<div class="itemInfo">
								<p><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
								<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
										<p class="price"><s><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getorgPrice,0) %></s><strong><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %> <em class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</em></strong></p>
									<% End IF %>
									<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
										<p class="price"><s><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %></s><strong><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %> <em class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</em></strong></p>
									<% End IF %>
								<% Else %>
									<p class="price"><strong><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %> <% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></strong></p>
								<% End if %>
							</div>
							</a>
						</li>
					<% next %>
				</ul>
			</div>
			<!--// KITCHEN -->
			<% end if %>
			<% set cEventItem = nothing %>


			<%
			set cEventItem = new ClsEvtItem
			cEventItem.FECode 	= eCode
			cEventItem.FEGCode 	= egCode
			cEventItem.FEPGsize 	= 10
			cEventItem.Frectminnum= 31
			cEventItem.Frectmaxnum= 40
			cEventItem.fnGetEventItem_v2
			iTotCnt = cEventItem.FTotCnt
			%>
			<% IF (iTotCnt >= 0) THEN %>
			<!-- DRESSROOM -->
			<div class="itemGroup">
				<h4><a href="eventmain.asp?eventid=<%= subeCode %>&eGC=<%= egCodeDre %>"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72792/m/tit_dressroom.png" alt="DRESSROOM" /></a></h4>
				<ul>
					<% For intI =0 To iTotCnt %>
						<li>
							<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=72792'); return false;">
							<div class="pic"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
							<div class="itemInfo">
								<p><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
								<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
										<p class="price"><s><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getorgPrice,0) %></s><strong><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %> <em class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</em></strong></p>
									<% End IF %>
									<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
										<p class="price"><s><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %></s><strong><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %> <em class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</em></strong></p>
									<% End IF %>
								<% Else %>
									<p class="price"><strong><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %> <% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></strong></p>
								<% End if %>
							</div>
							</a>
						</li>
					<% next %>
				</ul>
			</div>
			<!--// DRESSROOM -->
			<% end if %>
			<% set cEventItem = nothing %>

			<ul class="fullBnr">
				<li><a href="eventmain.asp?eventid=73012"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72792/m/bnr_honeymoon.jpg" alt="둘이어서 더 행복한 HONEYMOON" /></a></li>
				<li><a href="eventmain.asp?eventid=72612"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72792/m/bnr_self.jpg" alt="가을의 신부를 위한 SELF WEDDING" /></a></li>
			</ul>
		</div>
		<!--// SELF HOUSE -->
	</div>
	<!--// 웨딩기획전 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->