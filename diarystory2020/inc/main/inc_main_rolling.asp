<%
dim arrSwiperList
dim eventCode, imgURL, headLine, subCopy, salePer, saleCPer, isSale, isCoupon, leftBGColor, rightBGColor, isgift, isoneplusone, leftCnt, brand, evtSellCash
dim isOnly, isNew, isFreeDel, isReserveSell
arrSwiperList = oExhibition.getSwiperListProc2( masterCode, "M" , "exhibition" ) '마스터코드 , 채널 , 기획전종류
%>
<script>
$(function(){
	$("#mainSwiper .evt-slide").each(function(idx){
		$(".badge-area .evt-info em:gt(2)", this).css('display','none');
	})
})
</script>
<% if isArray(arrSwiperList) then %>
		<div class="slide1" id="mainSwiper">
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
%>
				<div class="swiper-slide evt-slide">
				<% if isapp = 1 then %>
					<a href="javascript:fnAPPpopupEvent('<%=eventCode%>');">
				<% else %>
					<a href="/event/eventmain.asp?eventid=<%=eventCode%>">
				<% end if %>
						<div class="img-area">
							<!-- for dev msg: 컬러값 지정 -->
							<div class="img-bg" style="background-color: #<%=leftBGColor%>"></div>
							<div class="thumbnail"><img src="<%=imgURL%>" alt=""></div>
						</div>
						<div class="copy-area">
							<ul>
								<li class="brand"><%=brand%></li>
								<li class="tit"><%=headLine%></li>
								<li class="price-area">
									<% if evtSellCash <> "" and evtSellCash <> "0" then %><span class="price"><%=FormatNumber(evtSellCash, 0)%></span><% end if %>
								</li>
							</ul>
							<div class="badge-area">
								<% if isSale then %><em class="badge badge-sale evt-info"><%=salePer%>%</em><% end if %>
								<% if isCoupon then %><em class="badge badge-cpn evt-info"><%=couponDisp(saleCPer)%><br>쿠폰</em><% end if %>
								<% if isOnly then %><em class="badge badge-only evt-info">ONLY</em><% end if %> 
								<% if isgift then %><em class="badge badge-gift evt-info">GIFT</em><% end if %>
								<% if isoneplusone then %><em class="badge badge-plus evt-info">1+1</em><% end if %>
								<% if isNew then %><em class="badge badge-launch evt-info">런칭</em> <% end if %>
								<% if isFreeDel then %><em class="badge badge-free evt-info">무료<br>배송</em> <% end if %>
								<% if isReserveSell then %><em class="badge badge-book evt-info">예약<br>판매</em> <% end if %>
								<% if leftCnt <> "" and leftCnt <> 0 then %><em class="badge badge-count"><%=FormatNumber(leftCnt, 0)%>개<br>남음</em><% end if %>
							</div>
						</div>
					</a>
				</div>
<%
    next
%>
			</div>
			<div class="pagination"><span class="pagination-fill"></span></div>
		</div>
<% end if %>