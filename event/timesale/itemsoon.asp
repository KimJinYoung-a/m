<div class="time-soon">
    <div class="time-top">
        <div class="inner">
            <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_soon_1.png" alt="곧 시작합니다. 오늘의 첫번째 타임세일"></h2>
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_soon_2.png" alt="첫번째 세일 시작까지"></p>
            <div class="sale-timer"><span>-</span><span id="countdown">00:00:00</span></div>
            <%=fnGettimeNavHtml(fnGetCurrentType(isAdmin,currentType))%>
        </div>
    </div>
    <div class="coming-section">
        <div class="inner">
            <div class="alarm">
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_soon.png" alt="잠시 후, 오픈합니다"></p>
                <button class="btn-alarm"></button>
            </div>
            <%'!-- 타임세일(예고) --%>
            <%
                FOR loopInt = 0 TO oTimeSale.FResultCount - 1

                    isItem = oTimeSale.FitemList(loopInt).FcontentType = 1 '콘텐츠 구분 추가
                    if isItem then
                        call oTimeSale.FitemList(loopInt).fnItemLimitedState(isSoldOut,RemainCount)
                        call oTimeSale.FitemList(loopInt).fnItemPriceInfos(totalPrice , salePercentString , couponPercentString , totalSalePercent)
                    end if

                    IF oTimeSale.FitemList(loopInt).Fsortnumber = 1 THEN
            %>
            <div class="time-items">
                <p class="txt-time"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/tit_time1_<%= oTimeSale.FitemList(loopInt).Fround%>.png" alt="<%=oTimeSale.FitemList(loopInt).Fround%> 회차"></p>
                <ul>
            <%
                    END IF
            %>
                    <li>
                        <div class="thumbnail">
                            <img src="<%=oTimeSale.FitemList(loopInt).FprdImage%>" alt="">
                            <div class="label-box">
                                <span class="label">한정판매</span><%'갯수 노출 안함%>
                            </div>
                        </div>
                        <div class="desc">
                            <div class="name"><%=oTimeSale.FitemList(loopInt).FcontentName%></div>
                            <div class="price">
                                <p  style="display:<%=chkiif(isItem, "","none") %>">
                                <% IF oTimeSale.FitemList(loopInt).Fitemdiv <> "21" THEN %>
                                    <b><%=formatnumber(oTimeSale.FitemList(loopInt).Forgprice,0)%></b>
                                <% END IF %>
                                <em><%=chkiif(oTimeSale.FitemList(loopInt).Fitemdiv = "21",formatnumber(oTimeSale.FitemList(loopInt).FmasterSellCash,0)&"~",totalPrice)%><span>원</span></em>
                                </p>
                                <% if isItem then %>                      
                                    <% IF oTimeSale.FitemList(loopInt).Fitemdiv = "21" THEN %>
                                        <% IF oTimeSale.FitemList(loopInt).FmasterDiscountRate > 0 THEN %><i class="sale">~<%=oTimeSale.FitemList(loopInt).FmasterDiscountRate%>%</i><% end if %>
                                    <% ELSE %>
                                        <% if totalSalePercent <> "0" then %><i class="sale"><%=totalSalePercent%></i><% end if %>
                                    <% END IF %>
                                <% else %>
                                        <%if oTimeSale.FitemList(loopInt).FevtSale <> 0 then%><i class="sale">~<%=oTimeSale.FitemList(loopInt).FevtSale%>%</i><%end if%>
                                <% end if %>               
                            </div>
                        </div>
                    </li>
            <%
                    IF oTimeSale.FitemList(loopInt).Fsortnumber = 12 THEN
            %>
                </ul>
            </div>
            <%
                    END IF
                NEXT
            %>
        </div>
    </div>
    <div class="alarm inner">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_alarm1_1.png" alt="하루, 단 4번의 세일찬스. 놓치면 정말정말 아깝다구요!"></p>
        <%=fnGettimeNavHtml(fnGetCurrentType(isAdmin,currentType))%>
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_alarm1_2.png" alt="혹시, 시간을 잊어버릴까봐 걱정된다면?"></p>
        <button class="btn-alarm"></button>
    </div>
</div>