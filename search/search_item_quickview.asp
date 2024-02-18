<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_item_qnacls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<%
'// 변수 선언 //
Dim lp, i, oItem, oADD, IsPresentItem, IsReceiveSiteItem, IsTicketItem, ISFujiPhotobook, LoginUserid

LoginUserid = getLoginUserid()

dim itemid, itEvtImg, itEvtImgMap, vRect
itemid = getNumeric(requestCheckVar(request("itemid"),9))
vRect = requestCheckVar(request("rect"),100)

if itemid="" or itemid="0" then
	dbget.close(): response.End
elseif Not(isNumeric(itemid)) then
	dbget.close(): response.End
else
	'정수형태로 변환
	itemid=CLng(itemid)
end if

'=============================== 상품 상세 정보 ==========================================
set oItem = new CatePrdCls
oItem.GetItemData itemid

if oItem.FResultCount=0 then
	dbget.close(): response.End
end if
if oItem.Prd.Fisusing="N" then
	dbget.close(): response.End
end if

'// fuji FDI photobook 2010-06-14
ISFujiPhotobook = oItem.Prd.FMakerid="fdiphoto"
'// Present상품
IsPresentItem = (oItem.Prd.FItemDiv = "09")
'// 현장수령 상품
IsReceiveSiteItem = (oItem.Prd.FDeliverytype="6")
'// 티켓팅
IsTicketItem = (oItem.Prd.FItemDiv = "08")
If IsTicketItem Then
	dim oTicket
	set oTicket = new CTicketItem
	oTicket.FRectItemID = itemid
	oTicket.GetOneTicketItem
End if

'=============================== 추가 이미지 & 메인 이미지 ==========================================
set oADD = new CatePrdCls
oADD.getAddImage itemid

'=============================== 추가 정보 ==========================================
dim isMyFavBrand: isMyFavBrand=false
dim isMyFavItem: isMyFavItem=false
if IsUserLoginOK then
	'isMyFavBrand = getIsMyFavBrand(LoginUserid,oItem.Prd.FMakerid)
	isMyFavItem = getIsMyFavItem(LoginUserid,itemid)
end if


function ImageExists(byval iimg)
	if (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
		ImageExists = false
	else
		ImageExists = true
	end if
end function
%>
<div class="inner">
	<div id="itemSwiper" class="swiper-container">
		<div class="swiper-wrapper">
		<%
			'// 상품 이미지 출력
			dim viBsimg, viMkimg, viAdImg
			dim viBstmb, viMktmb, viAdtmb
			
			'기본 이미지 (큰이미지가 있으면 큰걸로 취합)
			if ImageExists(oitem.Prd.FImageBasic) then
				viBsimg = oitem.Prd.FImageBasic
			end if

			if viBsimg<>"" then
				viBsimg = getThumbImgFromURL(viBsimg,400,400,"true","false")

				Response.write "<div class=""swiper-slide"">"
				Response.write "	<div class=""thumbnail""><img src=""" & viBsimg & """ alt=""" & replace(oItem.Prd.FItemName,"""","") & """ /></div>"
				Response.write "</div>"
			end if

			'누끼 이미지 (큰이미지가 있으면 큰걸로 취합)
			if ImageExists(oitem.Prd.FImageMask) then
				viMkimg = oitem.Prd.FImageMask
			end if

			if viMkimg<>"" then
				viMkimg = getThumbImgFromURL(viMkimg,400,400,"true","false")
				
				Response.write "<div class=""swiper-slide"">"
				Response.write "	<div class=""thumbnail""><img src=""" & viMkimg & """ alt=""" & replace(oItem.Prd.FItemName,"""","") & """ /></div>"
				Response.write "</div>"
			end if

			'추가 이미지 (큰이미지가 있으면 큰걸로 취합)
			If oAdd.FResultCount > 0 Then
				For i= 0 to oAdd.FResultCount-1
					viAdImg = "": viAdtmb=""
					If oAdd.FADD(i).FAddImageType=0 Then
						'if ImageExists(oAdd.FADD(i).FAddimage1000) then
						'	viAdImg = oAdd.FADD(i).FAddimage1000
						if ImageExists(oAdd.FADD(i).FAddimage) then
							viAdImg = oAdd.FADD(i).FAddimage
						end if
						
						if viAdImg<>"" then
							viAdImg = getThumbImgFromURL(viAdImg,400,400,"true","false")

							Response.write "<div class=""swiper-slide"">"
							Response.write "	<div class=""thumbnail""><img src=""" & viAdImg & """ alt=""" & replace(oItem.Prd.FItemName,"""","") & """ /></div>"
							Response.write "</div>"
						end if
					end if
				Next
			End if
		%>
		</div>
		<div class="pagination-dot"></div>
	</div>
	<div class="items type-card">
		<div class="desc">
			<span class="brand"><%= UCase(oItem.Prd.FBrandName) %></span>
			<p class="name"><%= replace(replace(oItem.Prd.FItemName,"<br>"," "),"<br />"," ") %></p>
			<div class="price">
				<div class="unit"><b class="sum">
				<%
				IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN
					Response.Write FormatNumber(oItem.Prd.FSellCash,0) & "<span class=""won"">" & chkIIF(oItem.Prd.IsMileShopitem,"Point","원") & "</span>"
					Response.Write "</b> <b class=""discount red"">"&CHKIIF(oItem.Prd.FOrgprice=0,"0",CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100))&"%</b>"
				ELSE
					Response.Write FormatNumber(oItem.Prd.getOrgPrice,0) & "<span class=""won"">" & chkIIF(oItem.Prd.IsMileShopitem,"Point","원") & "</span>"
					Response.Write "</b>"
				End If
				
				if oitem.Prd.isCouponItem Then
					Response.Write " <b class=""discount green"">"&oItem.Prd.GetCouponDiscountStr&"<small>쿠폰</small></b>"
				end if
				%>
				</div>
				<div class="option">
				<%
					if oItem.Prd.IsAboardBeasong then
						Response.Write "<span>텐바이텐" & chkIIF(oItem.Prd.IsFreeBeasong,"무료","") & "배송+해외배송</span>"
					else
						Response.Write "<span>" & oItem.Prd.GetDeliveryName & "</span>"
					end if
					
					If oItem.Prd.FPojangOk = "Y" Then
						Response.Write "&nbsp;<span>선물포장가능</span>"
					end if
				%>
				</div>
			</div>
			<div class="etc">
				<div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(oItem.Prd.FPoints,"")%>%;"><%=fnEvalTotalPointAVG(oItem.Prd.FPoints,"")%>점</i></span><span class="counting"><%=oItem.Prd.FEvalCnt%></span></div>
				<span class="tag wish btn-wish"><span class="icon icon-wish"><i class="hidden"> wish</i></span><span class="counting"><%= FormatNumber(oItem.Prd.FfavCount,0) %></span></span>
			</div>
		</div>
	</div>

	<div class="btn-group">
		<div class="btn-half"><a href="" onClick="jsCompareItem('set','<%=itemid%>');return false;">비교 담기</a></div>
		<div class="btn-half"><a href="/category/category_itemPrd.asp?itemid=<%=itemid%>&pRtr=<%=vRect%>&rc=qv_1_1"><%=CHKIIF(oItem.Prd.FSellYn="Y","구매하기","상세보기")%></a></div>
	</div>
	<button type="button" class="btn-close" onClick="jsSearchLayerClose('quickview');">닫기</button>
</div>
<%
	set oItem = Nothing
	set oADD =Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->