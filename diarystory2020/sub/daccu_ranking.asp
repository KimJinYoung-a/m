<div class="ranking">
    <%'!-- top --%>
    <div class="top">
        <h2>DIARY DECO <br>RANKING</h2>
        <div class="deco">
            <i class="dc1 circle circle1"></i>
            <i class="dc2 circle circle2"></i>
            <i class="dc3 circle circle2"></i>
            <i class="dc4 circle circle2"></i>
            <i class="dc5 circle circle3"></i>
        </div>
    </div>

    <%'!-- nav-gnb --%>
    <div id="navDaccu" class="nav-gnb">
        <nav class="swiper-container">
            <ul class="swiper-wrapper">
                <li class="swiper-slide"><a href="<%=appUrlPath%>/diarystory2020/daccu_ranking.asp?date=<%=vDate%>" class="<%=chkiif(Trim(vDaccuType)="","on","")%>"> 전체</a></li>
                <li class="swiper-slide"><a href="<%=appUrlPath%>/diarystory2020/daccu_ranking.asp?date=<%=vDate%>&daccutype=pen" class="<%=chkiif(Trim(vDaccuType)="pen","on","")%>">펜/색연필</a></li>
                <li class="swiper-slide"><a href="<%=appUrlPath%>/diarystory2020/daccu_ranking.asp?date=<%=vDate%>&daccutype=memo" class="<%=chkiif(Trim(vDaccuType)="memo","on","")%>">떡메/메모지</a></li>
                <li class="swiper-slide"><a href="<%=appUrlPath%>/diarystory2020/daccu_ranking.asp?date=<%=vDate%>&daccutype=sticker" class="<%=chkiif(Trim(vDaccuType)="sticker","on","")%>">스티커</a></li>
                <li class="swiper-slide"><a href="<%=appUrlPath%>/diarystory2020/daccu_ranking.asp?date=<%=vDate%>&daccutype=tape" class="<%=chkiif(Trim(vDaccuType)="tape","on","")%>">테이프</a></li>
                <li class="swiper-slide"><a href="<%=appUrlPath%>/diarystory2020/daccu_ranking.asp?date=<%=vDate%>&daccutype=stamp" class="<%=chkiif(Trim(vDaccuType)="stamp","on","")%>">스탬프</a></li>
            </ul>
        </nav>
    </div>

    <div class="items type-list">
        <ul>
            <%  
                '// 할인율 / 가격 
                dim totalPrice , salePercentString , couponPercentString , totalSalePercent
            %>
            <% If oDaccuRanking.FResultCount > 0 Then %>
                <%	For i=0 to oDaccuRanking.FResultCount-1 %>
                    <%
                        call oDaccuRanking.FItemList(i).fnItemPriceInfos(totalPrice , salePercentString , couponPercentString , totalSalePercent)
                    %>
                    <%
                        If i > 49 Then
                            exit for
                        End If
                    %>
                    <li>
                        <div class="badge badge-count1 num-rolling">
                            <em><%=i+1%></em>
                            <% if i < 3 then %>
                            <svg><circle cx="1.5rem" cy="1.5rem" stroke="#ffe400" r="1.28rem" fill="none" stroke-width="2" stroke-miterlimit="10"></circle></svg>
                            <% end if %>
                        </div>
                        <% If isapp="1" Then %>
                            <a href="" class="col-wrap" onclick="fnAPPpopupAutoUrl('/category/category_itemPrd.asp?itemid=<%=oDaccuRanking.FItemList(i).FItemID%>&gaparam=diary_daccuranking_<%=i+1%>');return false;">
                        <% Else %>
                            <a href="/category/category_itemprd.asp?itemid=<%=oDaccuRanking.FItemList(i).FItemId%>&gaparam=diary_daccuranking_<%=i+1%>" target="_blank" class="col-wrap">
                        <% End If %>
                            <div class="thumbnail">
                                <img src="<%=getThumbImgFromURL(oDaccuRanking.FItemList(i).FImageBasic,"286","286","true","false") %>" alt="" />
                                <% if oDaccuRanking.FItemList(i).IsSoldOut() Then %>
                                    <span class="soldout"><span class="ico-soldout">일시품절</span></span>
                                <% End If %>
                            </div>
                            <div class="desc">
                                <div class="price">
                                    <div class="unit">
                                        <b class="sum"><%=formatNumber(totalPrice, 0)%><span class="won">원</span></b> 
                                        <% if salePercentString <> "0" then %><b class="discount color-red"><%=salePercentString%></b><% end if%>
                                        <% if couponPercentString <> "0" then %><b class="discount color-green"><%=couponPercentString%></b><% end if%>
                                    </div>
                                </div>
                                <p class="name"><%=oDaccuRanking.FItemList(i).FItemName %></p>
                                <span class="brand"><%=oDaccuRanking.FItemList(i).FBrandName %></span>
                            </div>
                        </a>
                        <% if oDaccuRanking.FItemList(i).FOptionCount > 0 Then %>
                            <button class="btn-cart" onclick="fnDiaryRankingBasketCheck('option','<%=oDaccuRanking.FItemList(i).FItemID%>');"></button>
                        <% Else %>
                            <button class="btn-cart" onclick="fnDiaryRankingBasketCheck('basket','<%=oDaccuRanking.FItemList(i).FItemID%>');"></button>
                        <% End If %>
                    </li>
                <% next %>
            <% End If %>
        </ul>
    </div>

    <%' for dev msg 옵션이 없을경우 %>
    <div class="alertBoxV17a" style="display:none" id="alertBoxV17a">
        <div>
            <p class="alertCart" id="sbaglayerx" style="display:none"><span>장바구니에 상품이 담겼습니다.</span></p>
            <p id="sbaglayero" style="display:none"><span>장바구니에 이미 같은 상품이 있습니다.</span></p>
            <p class="tMar1-1r">
                <% If isApp="1" Then %>
                    <button type="button" class="btn btn-small btn-red btn-icon btn-radius" onClick="fnAPPpopupBaguni();">장바구니 가기<span class="icon icon-arrow"></span></button> 
                <% Else %>
                    <button type="button" class="btn btn-small btn-red btn-icon btn-radius" onClick="location.href='/inipay/ShoppingBag.asp';">장바구니 가기<span class="icon icon-arrow"></span></button>
                <% End If %>
            </p>
        </div>
    </div>

    <%' for dev msg 옵션이 있을경우 %>
    <div class="alertBoxV17a optionBoxV18" style="display:none" id="optionBoxV18">
        <div>
            <p><span>크기, 색상, 종류등과 같은<br/>다양한 옵션이 있는 상품입니다</span></p>
            <p class="btn-group">
                <button type="button" class="btn btn-small btn-line-white btn-radius" onclick="fnOptionConfirmShowItemPrd('x');return false;">쇼핑 계속하기</button>
                <button type="button" class="btn btn-small btn-red btn-radius" onclick="fnOptionConfirmShowItemPrd('o');return false;">옵션 선택</button>
            </p>
        </div>
    </div>
</div>