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
' Description : 가격이 구구구, 구구구! for app
' History : 2015-06-05 이종화 생성
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
dim cEvent, cEventItem, arrItem, arrGroup, intI, intG
dim egCode, itemlimitcnt,iTotCnt
dim eitemsort, itemid, eItemListType
intI =0
dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  63781 
Else
	eCode   =  63373
End If

	egCode = requestCheckVar(Request("eGC"),10)	'이벤트 그룹코드
	IF egCode = "" THEN egCode = 0

	itemlimitcnt = 105	'상품최대갯수
	eitemsort = 3		'정렬방법
	eItemListType = "1"	'격자형
	
	set cEventItem = new ClsEvtItem
	cEventItem.FECode 	= eCode
	cEventItem.FEGCode 	= egCode
	cEventItem.FEItemCnt= itemlimitcnt
	cEventItem.FItemsort= eitemsort
	cEventItem.fnGetEventItem_present
	iTotCnt = cEventItem.FTotCnt

	IF itemid = "" THEN
		itemid = cEventItem.FItemArr
	ELSE
		itemid = itemid&","&cEventItem.FItemArr
	END IF
%>
<% IF (iTotCnt >= 0) THEN %>
	<div class="pdtListWrap">
		<ul class="pdtList">
			<% For intI =0 To iTotCnt %>
			<li onclick="fnAPPpopupProduct('<% = cEventItem.FCategoryPrdList(intI).Fitemid %>'); return false;" class="<%=chkiif(cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut,"soldOut","")%><%=chkiif(cEventItem.FCategoryPrdList(intI).FLimitYn="Y" And cEventItem.FCategoryPrdList(intI).FLimitNo <= 10 ,"hurryUp","")%>">
				<div class="pPhoto">
					<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %>
					<p><span><em>품절</em></span></p>
					<% End If %>
					<% IF cEventItem.FCategoryPrdList(intI).FLimitYn="Y" And cEventItem.FCategoryPrdList(intI).FLimitNo <= 10 Then %>
					<p><span><em>HURRY UP!</em></span></p>
					<% End If %>
					<img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,300,300,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
				</div>
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
			<% next %>
		</ul>
	</div>
<% end if %>
<% set cEventItem = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->