<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [★★2017 F/W 웨딩 메인] A SMALL WEDDING
' History : 2017-03-27 이종화 생성
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
''date()

intI =0

IF application("Svr_Info") = "Dev" THEN
	eCode			= 66198	'현재 이벤트 코드
	subeCode		= 66200	'공간별 이벤트 코드
	egCodeBed		= 136973	'공간별 이벤트 - BEDROOM 그룹코드
	egCodeLiv		= 136979	'공간별 이벤트 - LIVINGROOM 그룹코드
	egCodeKit		= 136985	'공간별 이벤트 - KITCHEN 그룹코드
	egCodeDre		= 136991	'공간별 이벤트 - DRESSROOM 그룹코드

	BigeCode		= 66199	'빅세일 이벤트 코드( 1 WEEK SALE )
	'빅세일 이벤트 링크시 넘어갈 그룹 코드( 1 WEEK SALE )
	if date() < "2017-04-10" then
		BigGroupCd = 136998
	elseif date() >= "2017-04-10" and date() < "2017-04-17" then
		BigGroupCd = 136999
	elseif date() >= "2017-04-17" and date() < "2017-04-24" then
		BigGroupCd = 137000
	elseif date() >= "2017-04-24" then
		BigGroupCd = 137001
	end if
Else
	eCode			= 76950	'현재 이벤트 코드
	subeCode		= 76950	'공간별 이벤트 코드
	egCodeBed		= 203972	'공간별 이벤트 - BEDROOM 그룹코드
	egCodeLiv		= 203978	'공간별 이벤트 - LIVINGROOM 그룹코드
	egCodeKit		= 203984	'공간별 이벤트 - KITCHEN 그룹코드
	egCodeDre		= 203990	'공간별 이벤트 - DRESSROOM 그룹코드

	BigeCode		= 76948	'빅세일 이벤트 코드( 1 WEEK SALE )
	'빅세일 이벤트 링크시 넘어갈 그룹 코드( 1 WEEK SALE )
	if date() < "2017-04-10" then
		BigGroupCd = 203997
	elseif date() >= "2017-04-10" and date() < "2017-04-17" then
		BigGroupCd = 203998
	elseif date() >= "2017-04-17" and date() < "2017-04-24" then
		BigGroupCd = 203999
	elseif date() >= "2017-04-24" then
		BigGroupCd = 204000
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
.greeneryWedding {text-align:center; background-color:#fff;}
.just1week {position:relative; margin-bottom:1rem; padding-bottom:5.5rem;  background-color:#d3d987;}
.just1week .rate {position:absolute; right:5.15%; top:-5.75rem; width:6.6rem; height:6.7rem; padding-top:2rem; font-size:1rem; line-height:1.2; font-weight:600; color:#fff; background:url(http://webimage.10x10.co.kr/eventIMG/2017/76947/m/bg_balloon.png) no-repeat 0 0; background-size:100% auto;}
.just1week .rate strong {display:block; font-size:1.5rem; color:#fff839;}
.just1week .swiper-slide {width:62.5%; font-size:1.2rem;}
.just1week .swiper-slide .pic {overflow:hidden; border-radius:50%;}
.just1week .swiper-slide .pic img {border:0.35rem solid #fff; border-radius:50%;}
.just1week .swiper-slide .itemInfo p {overflow:hidden; padding:1.5rem 0 0.75rem; text-overflow:ellipsis; white-space:nowrap;}
.just1week .swiper-slide .itemInfo strong {color:#fe4b38;}
.just1week .swiper-slide .itemInfo s {color:#7b7c65; font-weight:normal;}

.selfHouse {background:#ffe3d0;}
.selfHouse .itemGroup {padding-bottom:6.5rem;}
.selfHouse .itemGroup h4 {padding-bottom:1rem;}
.selfHouse .itemGroup ul {padding:0 3.1%;}
.selfHouse .itemGroup ul:after {content:' '; display:block; clear:both;}
.selfHouse .itemGroup li {float:left; width:50%; padding-bottom:1rem; }
.selfHouse .itemGroup li:nth-child(even) {padding-left:1.6%;}
.selfHouse .itemGroup li:nth-child(odd) {padding-right:1.6%;}
.selfHouse .itemGroup li .itemInfo {color:#000; font-size:1.1rem; line-height:1.1; padding:1rem 1rem 1.8rem; background-color:#fff;}
.selfHouse .itemGroup li .itemInfo .pic {padding-bottom:2rem;}
.selfHouse .itemGroup li .itemInfo p {overflow:hidden; padding:0 0.5rem; text-overflow:ellipsis; white-space:nowrap;}
.selfHouse .itemGroup li .itemInfo .price {min-height:3.2rem; padding-top:0.8rem;}
.selfHouse .itemGroup li .itemInfo .price s {display:block; color:#999;}
.selfHouse .itemGroup li .itemInfo strong {}
.selfHouse .goMore {display:inline-block; padding:0 3.1%;}
</style>
<script type="text/javascript">
$(function(){
	mySwiper1 = new Swiper('.just1week .swiper-container',{
		slidesPerView:'auto',
		centeredSlides:true,
		spaceBetween:"8%"
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
</script>
	<%' 2017 !-- 웨딩기획전 --%>
	<div class="mEvt76947 greeneryWedding">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/76947/m/tit_greenery_wedding_v1.jpg" alt="Greenery Wedding" /></h2>
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
		<%'!-- JUST 1 WEEK --%>
		<div class="just1week">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/76947/m/tit_just_1week.png" alt="JSUT 1 WEEK" /></h3>
			<p class="rate">단 일주일만 <strong><% fnGetGroupMaxSalePer BigeCode,BigGroupCd %>%~</strong></p>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<% For intI =0 To iTotCnt %>
						<div class="swiper-slide">
						<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=76947'); return false;">
							<div class="pic">
								<%'' for dev msg : 상품 상세 대표 이미지 400x400로 썸네일 넣어주세요 %>
								<div><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
							</div>
							<div class="itemInfo">
								<p><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
								<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
										<strong><s><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getorgPrice,0) %></s> <% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원 <% if cEventItem.FCategoryPrdList(intI).getSalePro <> "0%" then %>[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]<% end if %></strong>
									<% End IF %>
								<% Else %>
									<strong><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원 </strong>
								<% End if %>
							</div>
						</a>
						</div>
					<% next %>

					<% ''마지막 슬라이드는 하단 더보기 버튼 들어갑니다 %>
					<div class="swiper-slide">
						<a href="<%=chkiif(isapp="1","/apps/appcom/wish/web2014/event/","/event/")%>eventmain.asp?eventid=<%= BigeCode %>&eGC=<%= BigGroupCd %>&redt=on">
							<img src="http://webimage.10x10.co.kr/eventIMG/2017/76947/m/btn_1week_sale.png" alt="단 일주일의 특가 상품 더 보러가기" />
						</a>
					</div>
				</div>
			</div>
		</div>
		<%'!--// JUST 1 WEEK --%>
		<% end if %>
		<% set cEventItem = nothing %>

		<div class="fullBnr">
			<div><a href="eventmain.asp?eventid=76949"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76947/m/bnr_party.jpg" alt="웨딩 파티" /></a></div>
		</div>

		<%'!-- SELF HOUSE --%>
		<div class="selfHouse">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/76947/m/tit_self_house.png" alt="SELF HOUSE 우리의 취향을 담아 꾸미는 집" /></h3>
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
			<%'!-- BED ROOM --%>
			<div class="itemGroup">
				<h4><a href="eventmain.asp?eventid=<%= subeCode %>&eGC=<%= egCodeBed %>"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76947/m/tit_bedroom.png" alt="BEDROOM" /></a></h4>
				<ul>
					<% For intI =0 To iTotCnt %>
						<li>
							<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=76947'); return false;">
							<div class="itemInfo">
								<div class="pic"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
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
				<a href="eventmain.asp?eventid=76950&amp;eGC=203972" class="goMore"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76947/m/btn_more_bedroom.png" alt="BEDROOM 상품 더 보기" /></a>
			</div>
			<%'!--// BED ROOM --%>
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
			<%'!-- LIVING ROOM --%>
			<div class="itemGroup">
				<h4><a href="eventmain.asp?eventid=<%= subeCode %>&eGC=<%= egCodeLiv %>"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76947/m/tit_livingroom.png" alt="LIVINGROOM" /></a></h4>
				<ul>
					<% For intI =0 To iTotCnt %>
						<li>
							<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=76947'); return false;">
							<div class="itemInfo">
								<div class="pic"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
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
				<a href="eventmain.asp?eventid=76950&amp;eGC=203978" class="goMore"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76947/m/btn_more_livingroom.png" alt="LIVINGROOM 상품 더 보기" /></a>
			</div>
			<%'!--// LIVING ROOM --%>
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
			<%'!-- KITCHEN --%>
			<div class="itemGroup">
				<h4><a href="eventmain.asp?eventid=<%= subeCode %>&eGC=<%= egCodeKit %>"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76947/m/tit_kitchen.png" alt="KITCHEN" /></a></h4>
				<ul>
					<% For intI =0 To iTotCnt %>
						<li>
							<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=76947'); return false;">
							<div class="itemInfo">
								<div class="pic"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
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
				<a href="eventmain.asp?eventid=76950&amp;eGC=203984" class="goMore"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76947/m/btn_more_kitchen.png" alt="KITCHEN 상품 더 보기" /></a>
			</div>
			<%'!--// KITCHEN --%>
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
			<%'!-- DRESSROOM --%>
			<div class="itemGroup">
				<h4><a href="eventmain.asp?eventid=<%= subeCode %>&eGC=<%= egCodeDre %>"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76947/m/tit_dressroom.png" alt="DRESSROOM" /></a></h4>
				<ul>
					<% For intI =0 To iTotCnt %>
						<li>
							<a href="" onclick="jsViewItem('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=76947'); return false;">
							<div class="itemInfo">
								<div class="pic"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
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
				<a href="eventmain.asp?eventid=76950&amp;eGC=203990" class="goMore"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76947/m/btn_more_dressroom.png" alt="DRESSROOM 상품 더 보기" /></a>
			</div>
			<%'!--// DRESSROOM --%>
			<% end if %>
			<% set cEventItem = nothing %>

			<div class="fullBnr">
				<div><a href="eventmain.asp?eventid=77010"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76947/m/bnr_honeymoon.jpg" alt="둘이어서 더 행복한 HONEYMOON" /></a></div>
				<div><a href="eventmain.asp?eventid=77011"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76947/m/bnr_self.jpg" alt="봄의 신부를 위한 SELF WEDDING" /></a></div>
			</div>
		</div>
		<%'!--// SELF HOUSE --%>
	</div>
	<%'!--// 웨딩기획전 --%>
<!-- #include virtual="/lib/db/dbclose.asp" -->