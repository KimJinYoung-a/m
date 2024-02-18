<%
dim soldList
soldList = oExhibition.getItemsNewListProc( "C", 8, mastercode, "", "", "" )
%>
<% if isArray(soldList) then %>
    <section class="sect_sold">
		<h2>방금 판매된<br/>상품이에요</h2>
		<div class="prd_list type_basic">
        <% 
        for i = 0 to Ubound(soldList) - 1 
            couponPer = oExhibition.GetCouponDiscountStr(soldList(i).Fitemcoupontype, soldList(i).Fitemcouponvalue)
            couponPrice = oExhibition.GetCouponDiscountPrice(soldList(i).Fitemcoupontype, soldList(i).Fitemcouponvalue, soldList(i).Fsellcash)                    
            itemSalePer     = CLng((soldList(i).Forgprice-soldList(i).Fsellcash)/soldList(i).FOrgPrice*100)
            if soldList(i).Fsailyn = "Y" and soldList(i).Fitemcouponyn = "Y" then '세일
                tempPrice = soldList(i).Fsellcash - couponPrice
                saleStr = "<span class=""discount""><dfn>할인율</dfn>"&itemSalePer&"%</span>"
                couponStr = "<span class=""discount""><dfn>할인율</dfn>"&couponPer&"</span>"  
            elseif soldList(i).Fitemcouponyn = "Y" then
                tempPrice = soldList(i).Fsellcash - couponPrice
                saleStr = ""
                couponStr = "<span class=""discount""><dfn>할인율</dfn>"&couponPer&"</span>"  
            elseif soldList(i).Fsailyn = "Y" then
                tempPrice = soldList(i).Fsellcash
                saleStr = "<span class=""discount""><dfn>할인율</dfn>"&itemSalePer&"%</span>"
                couponStr = ""                                              
            else
                tempPrice = soldList(i).Fsellcash
                saleStr = ""
                couponStr = ""                                              
            end if
        %>
			<article class="prd_item<% if soldList(i).IsSoldOut then %> soldout<% end if %>">
				<figure class="prd_img">
					<img src="<%=soldList(i).FImageList%>" alt="">
				</figure>
				<div class="prd_info">
					<div class="prd_price">
						<span class="set_price"><dfn>판매가</dfn><%=formatNumber(tempPrice, 0)%></span>
                        <% if saleStr<>"" then %><%=saleStr%><% end if %>
						<% if saleStr="" and couponStr<>"" then %><%=couponStr%><% end if %>
					</div>
					<div class="prd_name"><%=soldList(i).Fitemname%></div>
					<div class="prd_brand"><%=soldList(i).FbrandName%></div>
					<div class="user_side">
                        <% if fnEvalTotalPointAVG(soldList(i).FtotalPoint,"search") >= 80 then %>
						<span class="user_eval"><dfn>평점</dfn><i style="width:<%=fnEvalTotalPointAVG(soldList(i).FtotalPoint,"search")%>%"><%=fnEvalTotalPointAVG(soldList(i).FtotalPoint,"search")%>점</i></span>
						<% if soldList(i).FevalCnt >= 5 then  %><span class="user_comment"><dfn>상품평</dfn><%=soldList(i).FevalCnt%></span><% end if %>
                        <% end if %>
					</div>
					<div class="prd_badge">
                        <% if fnGetGiftiCon(soldList(i).Fdeliverytype,soldList(i).Forgprice,soldList(i).Fitemid) and giftCheck then %><i class="badge_gift">선물</i><% end if %>
						<% if fnGetDeliveryFreeiCon(soldList(i).Fdeliverytype,soldList(i).Fsellcash,soldList(i).FdefaultFreeBeasongLimit) then %><i class="badge_delivery">무료배송</i><% end if %>
					</div>
					<i class="badge_time"><%=soldList(i).FSellDate%></i>
				</div>
                <%if isapp = 1 then%>
                <a href="javascript:TnGotoProduct('<%=soldList(i).Fitemid%>');" class="prd_link"><span class="blind">상품 바로가기</span></a>
                <%else%>
                <a href="/category/category_itemPrd.asp?itemid=<%=soldList(i).Fitemid%>" class="prd_link"><span class="blind">상품 바로가기</span></a>
                <% end if %>
				
			</article>
        <% next %>
    </section>
<% end if %>