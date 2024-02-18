<%
    dim isSoldOut , RemainCount
%>
<div class="time-ing">
    <% if fnGetCurrentType(isAdmin,currentType) > 0 then %>
    <div class="time-top">
        <div class="inner">
            <% if fnGetCurrentType(isAdmin,currentType) = "1" then '첫번째 타임세일 %>
                <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_intro1_1.png" alt="시작합니다. 오늘의 첫번째 타임세일"></h2>
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_intro1_2.png" alt="첫번째 세일 종료까지"></p>
            <% end if %>

            <% if fnGetCurrentType(isAdmin,currentType) = "2" then '두번째 타임세일 %>
                <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_intro2_1.png" alt="이어집니다. 오늘의 두번째 타임세일"></h2>
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_intro2_2.png" alt="두번째 세일 종료까지"></p>
            <% end if %>

            <% if fnGetCurrentType(isAdmin,currentType) = "3" then '세번째 타임세일 %>
                <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_intro3_1.png" alt="두번 남았어요. 오늘의 세번째 타임세일"></h2>
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_intro3_2.png" alt="세번째 세일 종료까지"></p>
            <% end if %>

            <% if fnGetCurrentType(isAdmin,currentType) = "4" then '네번째 타임세일 %>
                <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_intro4_1.png" alt="이번엔 꼭! 오늘의 마지막 타임세일"></h2>
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_intro4_2.png" alt="마지막 세일 종료까지"></p>
            <% end if %>
            <div class="sale-timer"><span>-</span><span id="countdown">00:00:00</span></div>

            <%=fnGettimeNavHtml(fnGetCurrentType(isAdmin,currentType))%>
        </div>
    </div>
    <% end if %>
    <% if NOT isnull(fnGetCurrentType(isAdmin,currentType)) THEN %>
    <%'!-- 첫번째 ~ 네번째 타임세일 --%>
    <div class="time-items-on">
        <ul>
        <%
            FOR loopInt = 0 TO oTimeSale.FResultCount - 1
                isItem = oTimeSale.FitemList(loopInt).FcontentType = 1

                IF oTimeSale.FitemList(loopInt).Fround = Cint(fnGetCurrentType(isAdmin,currentType)) THEN
                    if isItem then
                        call oTimeSale.FitemList(loopInt).fnItemLimitedState(isSoldOut,RemainCount)
                        call oTimeSale.FitemList(loopInt).fnItemPriceInfos(totalPrice , salePercentString , couponPercentString , totalSalePercent)
                    end if
        %>
            <li <%=chkiif(isSoldOut and isItem, "class=""sold-out""", "")%>>
                <% IF oTimeSale.FitemList(loopInt).Fsortnumber > 1 THEN %>
                    <% if isItem then %>
                        <% if isapp then %>
                            <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_timesale_item','idx|itemid','<%=loopInt + 2%>|<%=oTimeSale.FitemList(loopInt).Fitemid%>', function(bool){if(bool) {TnGotoProduct('<%=oTimeSale.FitemList(loopInt).Fitemid%>');}});return false;">
                        <% else %>
                            <a href="/category/category_itemPrd.asp?itemid=<%=oTimeSale.FitemList(loopInt).Fitemid%>&pEtr=<%=eCode%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_timesale_item','idx|itemid','<%=loopInt%>|<%=oTimeSale.FitemList(loopInt).Fitemid%>')">
                        <% end if %>                    
                    <% else %>
                        <% if isapp then %>
                            <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_timesale_event','idx|evtcode','<%=loopInt + 2%>|<%=oTimeSale.FitemList(loopInt).FevtCode%>', function(bool){if(bool) {fnAPPpopupEvent('<%=oTimeSale.FitemList(loopInt).FevtCode%>');}});return false;">
                        <% else %>
                            <a href="/event/eventmain.asp?eventid=<%=oTimeSale.FitemList(loopInt).FevtCode%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_timesale_event','idx|evtcode','<%=loopInt%>|<%=oTimeSale.FitemList(loopInt).FevtCode%>')">
                        <% end if %>
                    <% end if %>
                <% END IF %>
                    <div class="thumbnail">
                        <img src="<%=oTimeSale.FitemList(loopInt).FprdImage%>" alt="">
                        <div class="label-box">
                                <span class="label">한정판매</span><%'갯수 노출 안함%>
                        </div>
                    </div>
                    <div class="desc">
                        <div class="name"><%=oTimeSale.FitemList(loopInt).FcontentName%></div>
                        <div class="price">
                            <p style="display:<%=chkiif(isItem, "","none") %>">
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
                <% IF oTimeSale.FitemList(loopInt).Fsortnumber > 1 THEN %>
                </a>
                <% END IF%>
            </li>
        <%
                END IF
            NEXT
        %>   
        </ul>
    </div>
    <% end if %>

    <%'!-- 타임세일 (예고)--%>
    <div class="coming-section" <%=fnNextDisplayCheck(fnGetCurrentType(isAdmin,currentType))(4)%>>
        <div class="inner">
            <div class="alarm">
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_soon.png" alt="잠시 후, 오픈합니다"></p>
                <button class="btn-alarm"></button>
            </div>
            <%'!-- 두번째 타임세일(예고) --%>
            <%
                FOR loopInt = 0 TO oTimeSale.FResultCount - 1

                    isItem = oTimeSale.FitemList(loopInt).FcontentType = 1
                    IF oTimeSale.FitemList(loopInt).Fround > 1 THEN
                        if isItem then
                            call oTimeSale.FitemList(loopInt).fnItemLimitedState(isSoldOut,RemainCount)
                            call oTimeSale.FitemList(loopInt).fnItemPriceInfos(totalPrice , salePercentString , couponPercentString , totalSalePercent)
                        end if
                        IF oTimeSale.FitemList(loopInt).Fsortnumber = 1 THEN
            %>
            <div class="time-items" <%=fnNextDisplayCheck(fnGetCurrentType(isAdmin,currentType))(oTimeSale.FitemList(loopInt).Fround)%>>
                <p class="txt-time"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/tit_time1_<%=oTimeSale.FitemList(loopInt).Fround%>.png" alt="<%=oTimeSale.FitemList(loopInt).Fround%>회차"></p>
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
                                <p style="display:<%=chkiif(isItem, "","none") %>">
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
                    END IF
                NEXT
            %>
        </div>
    </div>

    <% if fnGetCurrentType(isAdmin,currentType) = "4" then '네번째 타임세일 %>    
    <div class="alarm inner">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_alarm2.png" alt="우리, 이런 꿀 정보들은 잊지말고 챙겨받는게 어떨까요?"></p>
        <a href="/event/eventmain.asp?eventid=97629" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97629');return false;" class="btn-alarm btn-alarm2">앱푸시받기</a>
    </div>    
    <% else %>
    <div class="alarm inner">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_alarm1_1.png" alt="하루, 단 4번의 세일찬스. 놓치면 정말정말 아깝다구요!"></p>
        <%=fnGettimeNavHtml(fnGetCurrentType(isAdmin,currentType))%>
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_alarm1_2.png" alt="혹시, 시간을 잊어버릴까봐 걱정된다면?"></p>
        <button class="btn-alarm"></button>
    </div>
    <% end if %>
</div>