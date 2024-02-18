<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoriteEventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
'	Select * From db_event.dbo.tbl_eventitem Where evt_code='60446' And evtgroup_code=131405
	Dim vUserID, eCode, vQuery, vEvtgroupCode, itemlimitcnt, cEventItem, strsql, itemid, iTotCnt, intI, slideNum, vEndGroupCodeRnd

	IF application("Svr_Info") = "Dev" THEN
		eCode = "21514"
	Else
		eCode = "60446"
	End If

	Randomize()
	vEndGroupCodeRnd = Int((Rnd * 9) + 2)
	If Len(Trim(vEndGroupCodeRnd))=1 Then
		vEndGroupCodeRnd = "0"&vEndGroupCodeRnd
	End If
	
	vEvtgroupCode = requestCheckVar(Request("eGC"),10)	'이벤트 그룹코드


	If vEvtgroupCode = "" Or Len(Trim(vEvtgroupCode))=0 Then
		IF application("Svr_Info") = "Dev" THEN
			vEvtgroupCode = "15419"
		Else
			vEvtgroupCode = "1314"&vEndGroupCodeRnd
		End If
	End If


	set cEventItem = new ClsEvtItem
	cEventItem.FECode 	= eCode
	cEventItem.FEGCode 	= vEvtgroupCode
	cEventItem.FEItemCnt= 10
	cEventItem.FItemsort= 50
	cEventItem.fnGetEventItem
	iTotCnt = cEventItem.FTotCnt

	IF itemid = "" THEN
		itemid = cEventItem.FItemArr
	ELSE
		itemid = itemid&","&cEventItem.FItemArr
	END IF

	'// 페이지별 슬라이드 넘버
	select case trim(vEvtgroupCode)
		case "131402","131403","131404"
			slideNum = 0
		case "131405","131406","131407"
			slideNum = 3
		case "131408","131409","131410"
			slideNum = 8
	End Select




%>

<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>웨딩 기획전</title>
<style type="text/css">
.homestagram {margin:20px 5px 0; background:url(http://fiximage.10x10.co.kr/m/2014/common/double_line.png) left top repeat-x; background-size:1px 1px;}
.homestagram .swipeWrap {position:relative; width:310px; padding:15px 17px 0; margin:0 auto; /*border-bottom:1px solid #d2d2d2;*/}
.homestagram .swiper-container {width:100%;}
.homestagram .swiper-slide {float:left;}
.homestagram .swiper-slide a {display:inline-block; padding:5px 10px; margin:0 2px;}
.homestagram .swiper-slide span {display:inline-block; color:#94999d; border-bottom:1px solid #a7acaf; font-size:13px; line-height:1; text-align:center;}
.homestagram .current a {padding:4px 9px 3px; background:#ff9a92; border:1px solid #f9847b; border-radius:2px;}
.homestagram .current span {color:#fff; text-shadow:0 1px 1px #d96259; border-bottom:0;}
.homestagram .swipeNav {position:absolute; top:14px; width:13px;}
.homestagram .btnPrev {left:0;}
.homestagram .btnNext {right:0;}
.homestagram .weddingPdt .pdtList {background-image:none;}
/*
.homestagram .weddingPdt .pdtList li:nth-last-of-type(1),
.homestagram .weddingPdt .pdtList li:nth-last-of-type(2) {background:none !important;}
*/
.homestagram .weddingPdt .pdtCont {min-height:60px;}
@media all and (min-width:480px){
	.homestagram {margin:30px 7px 0;}
	.homestagram .swipeWrap {width:470px; padding:23px 26px 0;}
	.homestagram .swiper-slide a {padding:7px 15px 6px; margin:0 3px;}
	.homestagram .swiper-slide span {font-size:20px;}
	.homestagram .current a {padding:6px 12px; border-radius:3px;}
	.homestagram .current span {border-bottom:0;}
	.homestagram .swipeNav {top:24px; width:20px;}
	.homestagram .weddingPdt .pdtCont {min-height:90px;}
}
</style>
<script type="text/javascript">
$(function(){
	showSwiper= new Swiper('.swiper',{
		calculateHeight:true,
		slidesPerView:'auto',
		initialSlide:<%=slideNum%>
	});
	$('.btnPrev').on('click', function(e){
		e.preventDefault()
		showSwiper.swipePrev()
	});
	$('.btnNext').on('click', function(e){
		e.preventDefault()
		showSwiper.swipeNext()
	});
});
</script>
<% if isApp=1 then %>
	<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<% end if %>
<div class="homestagram">
	<div class="swipeWrap">
		<div class="swiper-container swiper">
			<div class="swiper-wrapper">
				<%' 슬라이드 번호 0번 그룹 %>
				<div class="swiper-slide <% If vEvtgroupCode="131402" Then %>current<% End If %>"><a href="/event/etc/inc_60446.asp?eGC=131402" onclick="parent.goWdTag(131402); return false;"><span>#밤이기다려져</span></a></div>
				<div class="swiper-slide <% If vEvtgroupCode="131403" Then %>current<% End If %>"><a href="/event/etc/inc_60446.asp?eGC=131403" onclick="parent.goWdTag(131403); return false;"><span>#셀프웨딩?</span></a></div>
				<div class="swiper-slide <% If vEvtgroupCode="131404" Then %>current<% End If %>""><a href="/event/etc/inc_60446.asp?eGC=131404" onclick="parent.goWdTag(131404); return false;"><span>#침대는과학</span></a></div>
				<%' 슬라이드 번호 0번 그룹 %>

				<%' 슬라이드 번호 1번 그룹 %>
				<div class="swiper-slide <% If vEvtgroupCode="131405" Then %>current<% End If %>"><a href="/event/etc/inc_60446.asp?eGC=131405" onclick="parent.goWdTag(131405); return false;"><span>#오붓한시간</span></a></div>
				<div class="swiper-slide <% If vEvtgroupCode="131406" Then %>current<% End If %>"><a href="/event/etc/inc_60446.asp?eGC=131406" onclick="parent.goWdTag(131406); return false;"><span>#션같은남자</span></a></div>
				<div class="swiper-slide <% If vEvtgroupCode="131407" Then %>current<% End If %>"><a href="/event/etc/inc_60446.asp?eGC=131407" onclick="parent.goWdTag(131407); return false;"><span>#여보미안해</span></a></div>
				<%' 슬라이드 번호 1번 그룹 %>

				<%' 슬라이드 번호 2번 그룹 %>
				<div class="swiper-slide <% If vEvtgroupCode="131408" Then %>current<% End If %>"><a href="/event/etc/inc_60446.asp?eGC=131408" onclick="parent.goWdTag(131408); return false;"><span>#욕실은두개</span></a></div>
				<div class="swiper-slide <% If vEvtgroupCode="131409" Then %>current<% End If %>"><a href="/event/etc/inc_60446.asp?eGC=131409" onclick="parent.goWdTag(131409); return false;"><span>#엄지척수납</span></a></div>
				<div class="swiper-slide <% If vEvtgroupCode="131410" Then %>current<% End If %>"><a href="/event/etc/inc_60446.asp?eGC=131410" onclick="parent.goWdTag(131410); return false;"><span>#휴지사절</span></a></div>
				<%' 슬라이드 번호 2번 그룹 %>
			</div>
		</div>
		<span class="swipeNav btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60432/btn_tag_prev.png" alt="이전" /></span>
		<span class="swipeNav btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60432/btn_tag_next.png" alt="다음" /></span>
	</div>
	<%' 상품목록 (이벤트코드:60446) %>
	<div class="weddingPdt">
		<div class="pdtListWrap">
			<ul class="pdtList">
				<% If iTotCnt >= 0 Then %>
					<% For intI =0 To iTotCnt %>
						<% If isApp = 1 Then %>
							<li onclick="parent.fnAPPpopupProduct('<% = cEventItem.FCategoryPrdList(intI).Fitemid %>'); return false;" class="<%=chkiif(cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut,"soldOut","")%>">
						<% Else %>
							<li onclick="window.open('/category/category_itemPrd.asp?itemid=<% = cEventItem.FCategoryPrdList(intI).Fitemid %>&flag=e');" class="<%=chkiif(cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut,"soldOut","")%>">
						<% End If %>
							<div class="pPhoto">
								<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %><p><span><em>품절</em></span></p><% End if %>
								<img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
							<div class="pdtCont">
								<p class="pBrand"><% = cEventItem.FCategoryPrdList(intI).FBrandName %></p>
								<p class="pName"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
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
							</div>
						</li>
					<% Next %>
				<% End If %>
			</ul>
		</div>
	</div>
	<%'// 상품목록 %>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->