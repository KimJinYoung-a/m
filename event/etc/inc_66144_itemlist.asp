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
' Description : [2015 FW 웨딩] 모바일 main 상단 랜덤상품
' History : 2015-09-15 유태욱 생성
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
dim mainimgnum, eCodelink
dim cEvent, cEventItem, arrItem, arrGroup, intI, intG
dim egCode, itemlimitcnt,iTotCnt, tmpitemcount
dim eitemsort, itemid, eItemListType
intI =0
tmpitemcount=0
dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   	=	64887
	eCodelink	=	64887
Else
	eCode   	=	66248
	eCodelink	=	66248
End If

	egCode = requestCheckVar(Request("eGC"),10)	'이벤트 그룹코드
	IF egCode = "" THEN egCode = 0
	
	IF application("Svr_Info") = "Dev" THEN
		if egCode ="136711" then
			mainimgnum = "01"
		elseif egCode ="136712" then
			mainimgnum = "02"
		elseif egCode ="136713" then
			mainimgnum = "03"
		elseif egCode ="136714" then
			mainimgnum = "04"
		elseif egCode ="136715" then
			mainimgnum = "05"
		elseif egCode ="136716" then
			mainimgnum = "06"
		elseif egCode ="136717" then
			mainimgnum = "07"
		elseif egCode ="136718" then
			mainimgnum = "08"
		elseif egCode ="136719" then
			mainimgnum = "09"
		elseif egCode ="136720" then
			mainimgnum = "10"
		end if
	else
		if egCode ="160002" then
			mainimgnum = "01"
		elseif egCode ="160003" then
			mainimgnum = "02"
		elseif egCode ="160004" then
			mainimgnum = "03"
		elseif egCode ="160005" then
			mainimgnum = "04"
		elseif egCode ="160006" then
			mainimgnum = "05"
		elseif egCode ="160007" then
			mainimgnum = "06"
		elseif egCode ="160008" then
			mainimgnum = "07"
		elseif egCode ="160009" then
			mainimgnum = "08"
		elseif egCode ="160010" then
			mainimgnum = "09"
		elseif egCode ="160011" then
			mainimgnum = "10"
		end if		
	end if
	itemlimitcnt = 105	'상품최대갯수
	eitemsort = 3		'정렬방법
	eItemListType = "1"	'격자형
	
	set cEventItem = new ClsEvtItem
	cEventItem.FECode 	= eCode
	cEventItem.FEGCode 	= egCode
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
<style type="text/css">
img {vertical-align:top;}
.itemDetail {padding-top:3%; padding-bottom:50px; margin-bottom:-50px; background:#f2f2f2 url(http://webimage.10x10.co.kr/eventIMG/2015/66144/bg_stripe.gif) no-repeat 0 0; background-size:100% 130px;}
.itemDetail .todayItem {position:relative; }
.itemDetail .todayItem h3 {font-size:15px; padding:6% 0 2.8%; text-align:center;}
.itemDetail .todayItem .figure {position:relative; width:88%; margin:0 auto; padding:4px; border:3px solid #fff; text-align:center;}
.itemDetail .todayItem .relatedPdt {overflow:hidden; width:89%; margin:0 auto; padding:5.3% 0 7.5%; background:url(http://fiximage.10x10.co.kr/m/2014/common/double_line.gif) 0 100% repeat-x; background-size:1px 1px;}
.itemDetail .todayItem:last-child .relatedPdt {background:none;}
.itemDetail .todayItem .relatedPdt li {float:left; width:33.33333%; padding:0 3%; text-align:center;}
.itemDetail .todayItem .relatedPdt li .pName {position:relative; height:23px; font-size:11px; font-weight:600; padding-top:0; color:#222; z-index:100; overflow:hidden; text-overflow:ellipsis; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; word-wrap:break-word;}
.itemDetail .todayItem .relatedPdt li .pPrice {font-size:11px; color:#999; padding-top:2px;}
.itemDetail .todayItem .relatedPdt li .pPrice span {display:block;}
.itemDetail .todayItem .relatedPdt li .num {position:relative; display:block; width:30px; margin:-12px auto 0; z-index:50;}
@media all and (min-width:480px){
	.itemDetail {background-size:100% 195px;}
	.itemDetail .todayItem .figure {padding:6px; border:4px solid #fff;}
	.itemDetail .todayItem .relatedPdt li .pName {height:35px; font-size:17px; margin-top:-7px;}
	.itemDetail .todayItem .relatedPdt li .pPrice {font-size:17px; padding-top:3px;}
	.itemDetail .todayItem .relatedPdt li .num {width:45px; margin:-18px auto 0;}
}
</style>
<% IF (iTotCnt >= 0) THEN %>
	<div class="todayItem">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/tit_item<%=mainimgnum%>.png" alt="둘만의 휴식공간"></h3>
		<div class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/img_main_item<%=mainimgnum%>.jpg" alt="활용컷"></div>
		<ul class="relatedPdt">
		<% For intI =0 To iTotCnt %>
			<li>
				<% if isApp then %>
					<div class="pPhoto" onclick="fnAPPpopupProduct('<% = cEventItem.FCategoryPrdList(intI).Fitemid %>'); return false;"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,112,112,"true","false") %>" alt="" /></div>
				<% else %>
					<div class="pPhoto" onclick="parent.location.href='/category/category_itemPrd.asp?itemid=<% = cEventItem.FCategoryPrdList(intI).Fitemid %>&flag=e';"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,112,112,"true","false") %>" alt="" /></div>
				<% end if %>
				<span class="num"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/ico_num_0<%= intI+1 %>.png" alt="0<%= intI+1 %>" /></span>
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
			</li>
		<% next %>
		</ul>
		<a href="" onclick="goEventLink('<%=eCodelink%>'); return false;"class="btnMore"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/btn_more.png" alt="more"></a>
	</div>
<% end if %>
<% set cEventItem = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->