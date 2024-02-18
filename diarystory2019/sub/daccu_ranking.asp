<div class="top-ranking">
    <h2>프로 다꾸러들이<br><em>애용하는 베스트 데코템</em></h2>
    <div class="date">
        <select name="daccuRankingDate" onChange="fnChgDaccuRankingDate(this.value);">
            <option value="<%=vDate%>" selected><%=vDateDisplayValue%></option>
            <%=GetDiaryDaccuBestDate(vDate)%>
        </select>
        <span></span>
    </div>
</div>

<div id="navDaccu" class="nav-gnb">
    <nav class="swiper-container">
        <ul class="swiper-wrapper">
            <li class="swiper-slide"><a href="<%=appUrlPath%>/diaryStory2019/daccu_ranking.asp?date=<%=vDate%>" <% If Trim(vDaccuType)="" Then %>class="on"<% End If %>> 전체</a></li>
            <li class="swiper-slide"><a href="<%=appUrlPath%>/diaryStory2019/daccu_ranking.asp?date=<%=vDate%>&daccutype=pen" <% If Trim(vDaccuType)="pen" Then %>class="on"<% End If %>>펜/색연필</a></li>
            <li class="swiper-slide"><a href="<%=appUrlPath%>/diaryStory2019/daccu_ranking.asp?date=<%=vDate%>&daccutype=memo" <% If Trim(vDaccuType)="memo" Then %>class="on"<% End If %>>떡메/떡메모지</a></li>
            <li class="swiper-slide"><a href="<%=appUrlPath%>/diaryStory2019/daccu_ranking.asp?date=<%=vDate%>&daccutype=sticker" <% If Trim(vDaccuType)="sticker" Then %>class="on"<% End If %>>스티커</a></li>
            <li class="swiper-slide"><a href="<%=appUrlPath%>/diaryStory2019/daccu_ranking.asp?date=<%=vDate%>&daccutype=tape" <% If Trim(vDaccuType)="tape" Then %>class="on"<% End If %>>테이프</a></li>
            <li class="swiper-slide"><a href="<%=appUrlPath%>/diaryStory2019/daccu_ranking.asp?date=<%=vDate%>&daccutype=stamp" <% If Trim(vDaccuType)="stamp" Then %>class="on"<% End If %>>스탬프</a></li>
        </ul>
    </nav>
</div>

<div class="items-list">
    <div class="items type-grid">
        <ul>
            <% If oDaccuRanking.FResultCount > 0 Then %>
                <%	For i=0 to oDaccuRanking.FResultCount-1 %>
                    <%
                        If i > 49 Then
                            exit for
                        End If
                    %>
                    <li> 
                        <% If isapp="1" Then %>
                            <a href="" onclick="fnAPPpopupAutoUrl('/category/category_itemPrd.asp?itemid=<%=oDaccuRanking.FItemList(i).FItemID%>&gaparam=diary_daccuranking_<%=i+1%>');return false;">
                        <% Else %>
                            <a href="/category/category_itemprd.asp?itemid=<%=oDaccuRanking.FItemList(i).FItemId%>&gaparam=diary_daccuranking_<%=i+1%>" target="_blank">
                        <% End If %>
                            <div class="thumbnail">
                                <img src="<%=getThumbImgFromURL(oDaccuRanking.FItemList(i).FImageBasic,"286","286","true","false") %>" alt="" />
                                <em><%=i+1%></em>
                                <% if oDaccuRanking.FItemList(i).IsSoldOut() Then %>
                                    <b class="soldout">일시 품절</b>
                                <% End If %>
                            </div>
                            <div class="desc">
                                <span class="brand"><%=oDaccuRanking.FItemList(i).FBrandName %></span>
                                <p class="name"><%=oDaccuRanking.FItemList(i).FItemName %></p>
                            </div>
                        </a>
                        <% if oDaccuRanking.FItemList(i).FOptionCount > 0 Then %>
                            <button class="btn-shoppingbag" onclick="fnDiaryRankingBasketCheck('option','<%=oDaccuRanking.FItemList(i).FItemID%>');">장바구니에 담기</button>
                        <% Else %>
                            <button class="btn-shoppingbag" onclick="fnDiaryRankingBasketCheck('basket','<%=oDaccuRanking.FItemList(i).FItemID%>');">장바구니에 담기</button>
                        <% End If %>
                    </li>
                <% next %>
            <% End If %>
        </ul>
    </div>
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