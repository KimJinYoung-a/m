<%
dim arrSwiperList
dim eventCode, imgURL, headLine, subCopy, salePer, saleCPer, isSale, isCoupon, leftBGColor, rightBGColor, isgift, isoneplusone, leftCnt, brand, evtSellCash
dim isOnly, isNew, isFreeDel, isReserveSell, RBeventCodeArr
arrSwiperList = oExhibition.getSwiperListProc3( masterCode, "M" , "exhibition" ) '마스터코드 , 채널 , 기획전종류
%>
<% if isArray(arrSwiperList) then %>
    <div class="sect_rolling">
		<h2 class="blind">롤링배너</h2>
        <div class="dr_evt_swiper swiper-container">
            <div class="swiper-wrapper">
<%
    for i = 0 to ubound(arrSwiperList,2)

        eventCode = arrSwiperList(9,i)
        imgURL = arrSwiperList(5,i)
        headLine = nl2br(arrSwiperList(2,i))
        subCopy = nl2br(arrSwiperList(10,i))
        salePer = arrSwiperList(12,i)
        saleCPer = arrSwiperList(13,i)
        isSale = arrSwiperList(14,i)
        isCoupon = arrSwiperList(15,i)
        leftBGColor = arrSwiperList(3,i)
        rightBGColor = arrSwiperList(4,i)
        isgift = arrSwiperList(16,i)
        isoneplusone = arrSwiperList(17,i)
        leftCnt = arrSwiperList(18,i)
        brand = arrSwiperList(19,i)
		evtSellCash = arrSwiperList(20,i)
		isOnly = arrSwiperList(21,i)
		isNew = arrSwiperList(22,i)
		isFreeDel = arrSwiperList(23,i)
		isReserveSell = arrSwiperList(24,i)
        RBeventCodeArr = RBeventCodeArr & eventCode & ","
%>
                <div class="swiper-slide">
                    <article class="dr_evt_item">
                        <figure class="dr_evt_img"><img src="<%=imgURL%>" alt=""></figure>
                        <div class="dr_evt_info">
                            <div class="dr_evt_badge">
                                <% if isSale and salePer > "0" then %><span class="badge_type2"><%=salePer%>%</span><% end if %>
                                <% if isCoupon and couponDisp(saleCPer) <> "" then %><span class="badge_type1"><%=couponDisp(saleCPer)%> 쿠폰</span><% end if %>
                                <% if isOnly then %><span class="badge_type1">ONLY</span><% end if %> 
                                <% if isgift then %><span class="badge_type1">사은품</span><% end if %>
                                <% if isoneplusone then %><span class="badge_type1">1+1</span><% end if %>
                                <% if isNew then %><span class="badge_type1">런칭</span> <% end if %>
                                <% if isFreeDel then %><span class="badge_type1">무료배송</span> <% end if %>
                                <% if isReserveSell then %><span class="badge_type1">예약판매</span> <% end if %>
                                <% if leftCnt <> "" and leftCnt <> 0 then %><span class="badge_type1"><%=FormatNumber(leftCnt, 0)%>개 남음</span><% end if %>
                            </div>
                            <p class="dr_evt_name"><%=headLine%></p>
                        </div>
                        <% if isapp = 1 then %>
                        <a href="javascript:TnGotoAPPDiaryEvent('<%=eventCode%>');" class="dr_evt_link" onclick="fnAmplitudeEventMultiPropertiesAction('click_diarystory_mainrolling','number|url','<%=i+1%>|/event/eventmain.asp?eventid=<%=eventCode%>');">
                        <% else %>
                        <a href="javascript:TnGotoDiaryEvent('<%=eventCode%>');" class="dr_evt_link" onclick="fnAmplitudeEventMultiPropertiesAction('click_diarystory_mainrolling','number|url','<%=i+1%>|/event/eventmain.asp?eventid=<%=eventCode%>');">
                        <% end if %>
                        <span class="blind">이벤트바로가기</span></a>
                    </article>
                </div>
<%
    next
%>
            </div>
            <div class="swiper-pagination"></div>
        </div>
	</div>
<% end if %>