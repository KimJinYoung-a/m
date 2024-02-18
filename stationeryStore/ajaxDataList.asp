<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<%
    dim oExhibition
    dim page , mastercode , detailcode , listType , sortMet
    dim totalPrice , salePercentString , couponPercentString , totalSalePercent
    dim iCTotCnt , i

    listType = "B" 
    mastercode = 8
    detailcode = requestCheckVar(request("detailcode"),10)
    page = requestCheckVar(request("cpg"),10)
    sortMet = requestCheckVar(request("sortMet"),10)

    if page = "" then page = 1
    if sortMet = "" then sortMet = "5"

    SET oExhibition = new ExhibitionCls

        oExhibition.FPageSize = 6
        oExhibition.FCurrPage = page
        oExhibition.FrectMasterCode = mastercode
        oExhibition.FrectDetailCode = detailcode
        oExhibition.FrectListType = listType
        oExhibition.FrectSortMet = sortMet
        oExhibition.getItemsPageListProc

        iCTotCnt = oExhibition.FTotalCount

    if oExhibition.FTotalCount > 0 then			
        for i = 0 to oExhibition.FResultCount - 1
        call oExhibition.FItemList(i).fnItemPriceInfos(totalPrice , salePercentString , couponPercentString , totalSalePercent)
%>
        <li> 
            <% if isapp = 1 then %>
            <a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_StationeryStore_all_item','index|itemid','<%=i+1%>|<%=oExhibition.FItemList(i).Fitemid%>', function(bool){if(bool) {fnAPPpopupProduct('<%=oExhibition.FItemList(i).Fitemid%>');return false;}});">
            <% else %>
            <a href="/category/category_itemPrd.asp?itemid=<%=oExhibition.FItemList(i).Fitemid%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_StationeryStore_all_item','index|itemid','<%=i+1%>|<%=oExhibition.FItemList(i).Fitemid%>')">
            <% end if %>
                <div class="thumbnail">
                    <img src="<%=oExhibition.FItemList(i).FImageList%>" alt="" />
                </div>
                <div class="desc">
                    <p class="name"><%=oExhibition.FItemList(i).Fitemname%></p>
                    <div class="price">
                        <div class="unit">
                            <b class="sum"><%=formatNumber(totalPrice, 0)%><span class="won">원</span></b>
                            <% if salePercentString <> "0" then %><b class="discount color-red">[<%=salePercentString%>]</b><% end if%>
                            <% if couponPercentString <> "0" then %><b class="discount color-green">[<%=couponPercentString%>]</b><% end if%>
                        </div>
                    </div>
                </div>
            </a>
        </li>
<% 
        next
    end if
    SET oExhibition = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->




							
							
						