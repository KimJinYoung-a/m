<%
    dim bestList : bestList = oExhibition.getItemsListProc( "B", 6, mastercode, "", "1", "1" )
%>
<% if isArray(bestList) then %>
<section class="sect_md">
    <h2>MD가 추천해요</h2>
    <div class="prd_list">
    <%
        for i = 0 to Ubound(bestList) - 1
            couponPer = oExhibition.GetCouponDiscountStr(bestList(i).Fitemcoupontype, bestList(i).Fitemcouponvalue)
            couponPrice = oExhibition.GetCouponDiscountPrice(bestList(i).Fitemcoupontype, bestList(i).Fitemcouponvalue, bestList(i).Fsellcash)
            itemSalePer     = CLng((bestList(i).Forgprice-bestList(i).Fsellcash)/bestList(i).FOrgPrice*100)
            if bestList(i).Fsailyn = "Y" and bestList(i).Fitemcouponyn = "Y" then '세일
                totalPrice = bestList(i).Fsellcash - couponPrice
                totalSaleCouponString = "더블할인"
            elseif bestList(i).Fitemcouponyn = "Y" then
                totalPrice = bestList(i).Fsellcash - couponPrice
                totalSaleCouponString = ""&couponPer&""
            elseif bestList(i).Fsailyn = "Y" then
                totalPrice = bestList(i).Fsellcash
                totalSaleCouponString = chkiif(itemSalePer > 0,""&itemSalePer&"%","")
            else
                totalPrice = bestList(i).Fsellcash
                totalSaleCouponString = ""
            end if
    %>
        <article class="prd_item">
            <figure class="prd_img">
                <img src="<%=bestList(i).FImageList%>" alt="">
            </figure>
            <div class="prd_info">
                <div class="prd_price">
                    <span class="set_price"><dfn>판매가</dfn><%=formatNumber(totalPrice, 0)%></span>
                    <span class="discount"><dfn>할인율</dfn><%=totalSaleCouponString%></span>
                </div>
                <div class="prd_name"><%=bestList(i).Fitemname%></div>
                <div class="user_side">
                    <% if fnEvalTotalPointAVG(bestList(i).FtotalPoint,"search") >= 80 then %>
                    <span class="user_eval"><dfn>평점</dfn><i style="width:<%=fnEvalTotalPointAVG(bestList(i).FtotalPoint,"search")%>%"><%=fnEvalTotalPointAVG(bestList(i).FtotalPoint,"search")%>점</i></span>
                    <% if bestList(i).FevalCnt >= 5 then  %><span class="user_comment"><dfn>상품평</dfn><%=formatNumber(bestList(i).FevalCnt,0)%></span><% end if %>
                    <% end if %>
                </div>
                <div class="prd_badge">
                    <% if fnGetGiftiCon(bestList(i).Fdeliverytype,bestList(i).Forgprice,bestList(i).Fitemid) and giftCheck then %><i class="badge_gift">선물</i><% end if %>
                    <% if fnGetDeliveryFreeiCon(bestList(i).Fdeliverytype,bestList(i).Fsellcash,bestList(i).FdefaultFreeBeasongLimit) then %><i class="badge_delivery">무료배송</i><% end if %>
                </div>
            </div>
            <a href="<%=chkiif(isapp=1 , "javascript:TnGotoProduct('"& bestList(i).Fitemid &"');" , "/category/category_itemPrd.asp?itemid="& bestList(i).Fitemid &"")%>" class="prd_link"><span class="blind">상품 바로가기</span></a>
        </article>
    <% next %>
    </div>
</section>
<% end if %>