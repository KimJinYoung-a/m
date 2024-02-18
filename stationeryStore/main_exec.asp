<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  텐텐문방구 contents
' History : 2019.06.12 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<!-- #include virtual="/stationeryStore/stationeryStoreCls.asp" -->
<%
dim vGaparam, gnbflag
dim strGaParam, strGnbStr
Dim oExhibition, oRealSell, realsellItemList
dim mastercode,  detailcode, bestItemList, eventList, detailGroupList, listType
dim i, y, wishlist , lp
dim arrSwiperList
dim totalPrice , salePercentString , couponPercentString , totalSalePercent '// 할인율 관련
dim getOneDayItemEvent

vGaparam = request("gaparam")
if vGaparam <> "" then strGaParam = "&gaparam=" & vGaparam
if gnbflag <> "" then strGnbStr = "&gnbflag=1"

gnbflag = RequestCheckVar(request("gnbflag"),1)

mastercode =  8
listType = "A"

SET oExhibition = new ExhibitionCls
SET oRealSell = new CstationeryStore

    bestItemList = oExhibition.getItemsListProc( listType, 12, mastercode, "", "1", "" )     '리스트타입, row개수, 마스터코드, 디테일코드, best아이템 구분, 카테고리 정렬 구분 
	detailGroupList = oExhibition.getDetailGroupList("1")		
	realsellItemList = oRealSell.getNowSellingItems()
	eventList = oExhibition.getEventListProc( listType, 10, mastercode, 0 )     '리스트타입, row개수, 마스터코드, 디테일코드
	arrSwiperList = oExhibition.getSwiperListProc( mastercode , "M" , "exhibition" ) '마스터코드 , 채널 , 기획전종류
	getOneDayItemEvent = oExhibition.getEventListProc( "B", 1, mastercode, 0 )     '상품 이벤트

	Set wishlist = new CstationeryStore
	'아이템 리스트
	wishlist.FPageSize = 12
	wishlist.FCurrPage = 1
	wishlist.Fbestgubun = "f"
	wishlist.ftectSortMet = "dbest"
	wishlist.getAwardBest

function format(ByVal szString, ByVal Expression)
	if len(szString) < len(Expression) then
	format = left(expression, len(szString)) & szString
	else
	format = szString
	end if
end function

dim OnedayStart, OnedayEnd, OnedayItemID, OnedayTitle, OnedayIMG , OnedayLabel , OneDayDueDate
Dim vTimerDate, targetNum, listenddate, liststartdate
OnedayLabel = "oneday"

if isArray(getOneDayItemEvent) then 
	OnedayStart = getOneDayItemEvent(0).Fstartdate
	OnedayEnd = getOneDayItemEvent(0).Fenddate
	OnedayItemID = getOneDayItemEvent(0).Fetc_itemid
	OnedayTitle = getOneDayItemEvent(0).Fitemname
	OnedayIMG = getOneDayItemEvent(0).Fsquareimage
	OneDayDueDate = DateDiff("d",date(),OnedayEnd+1)

	if getOneDayItemEvent(0).Fissale then
		OnedayLabel = "oneday"
	end if

	if getOneDayItemEvent(0).Fisgift then
		OnedayLabel = "gift"
	end if

	if getOneDayItemEvent(0).Fisoneplusone then
		OnedayLabel = "oneplus"
	end if

	liststartdate = DateAdd("d",0,OnedayStart) & " 00:00:00"
	listenddate = DateAdd("d",0,OnedayEnd) & " 23:59:59"
	vTimerDate = DateAdd("d",1,OnedayEnd) & " 23:59:59"
	targetNum = Cint(cint(DateDiff("s", Now(),listenddate) / DateDiff("s", liststartdate, listenddate)* 100))
end if
%>
<script type="text/javascript" src="/lib/js/TweenMax.min.js"></script>
<script type="text/javascript" src="/lib/js/jquery.easypiechart.min.js"></script>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script type="text/javascript">

var j1yr = "<%=Year(vTimerDate)%>";
var j1mo = "<%=TwoNumber(Month(vTimerDate))%>";
var j1da = "<%=TwoNumber(Day(vTimerDate))%>";
var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
var j1today=new Date(<%=Year(now)%>, <%=Month(now)-1%>, <%=Day(now)%>, <%=Hour(now)%>, <%=Minute(now)%>, <%=Second(now)%>);

var j1minus_second = 0;		// 변경될 증가시간(초)
var j1nowDt=new Date();		// 시작시 브라우저 시간

function countdown(){
	var cntDt = new Date(Date.parse(j1today) + (1000*j1minus_second));	//서버시간에 변화값(1초) 증가
	var todayy=cntDt.getYear()

	if(todayy < 1000) todayy+=1900;

	var todaym=cntDt.getMonth();
	var todayd=cntDt.getDate();
	var todayh=cntDt.getHours();
	var todaymin=cntDt.getMinutes();
	var todaysec=cntDt.getSeconds();
	var todaystring=montharray[todaym]+" "+todayd+", "+todayy+" "+todayh+":"+todaymin+":"+todaysec;
	var futurestring=montharray[j1mo-1]+" "+j1da+", "+j1yr+" 00:00:00";

	var nowdt = new Date();
	var thendt = new Date('<%=Year(vTimerDate)&"-"&Month(vTimerDate)&"-"&Day(vTimerDate)&" "&Hour(vTimerDate)&":"&Minute(vTimerDate)&":"&Second(vTimerDate)%>');
	var gapdt = thendt.getTime() - nowdt.getTime();

	gapdt = Math.floor(gapdt / (1000*60*60*24));

	dd=Date.parse(futurestring)-Date.parse(todaystring);
	dday=Math.floor(dd/(60*60*1000*24)*1);
	dhour=Math.floor((dd%(60*60*1000*24))/(60*60*1000)*1);
	dmin=Math.floor(((dd%(60*60*1000*24))%(60*60*1000))/(60*1000)*1);
	dsec=Math.floor((((dd%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1);

	if(dday < 0) {
		$("#countdown").html("00:00:00");
		return;
	}

    if (dday>=1){
        dhour=24*dday+dhour;
    }

	if(dhour < 10) dhour = "0" + dhour;
	if(dmin < 10) dmin = "0" + dmin;
	if(dsec < 10) dsec = "0" + dsec;
	dhour = dhour+'';
	dmin = dmin+'';
	dsec = dsec+'';

	$("#countdown").html(dhour.substr(0,1)+dhour.substr(1,1)+dhour.substr(2,1)+":"+dmin.substr(0,1)+dmin.substr(1,1)+":"+dsec.substr(0,1)+dsec.substr(1,1));

	var usrDt=new Date();	// 현재 브라우저 시간
	var vTerm = parseInt(usrDt.getTime()/1000)-parseInt(j1nowDt.getTime()/1000);	// 시작시 시간과의 차이(초)
	j1minus_second = vTerm;	// 증가시간에 차이 반영

	setTimeout("countdown()",500)
}

$(function() {
    countdown();
	//oneday chart
	$('.main-prd .chart').easyPieChart({
		barColor: '#ff7e20',
		trackColor: '', 
		scaleColor: false,
		lineWidth: 3.7,
		size:270,
		onStep: function(from, to, percent) {
			var value = percent * 360 / 100;
			$(this.el).find('.percent').css('transform','rotate('+value+'deg)');
		}
	});

	//timelinemax
	var blink = new TimelineMax({repeat:-1,yoyo: true});
	blink.to((".issue-vod .tit b"), .01,  {'opacity':'0', repeat: -1,repeatDelay:.4, yoyo: true})
	blink.to((".brand7 .ani span"), .01,  {'opacity':'0', repeat: -1,repeatDelay:.4, yoyo: true})

	var circle = new TimelineMax({repeat:-1});
	circle.to("#circle",14,{left:"+=120vw",ease: Power0.easeNone})
	.to("#circle",1,{top:"+=8rem",ease: Power0.easeNone})
	.to("#circle",14,{left:"-=120vw",ease: Power0.easeNone})
	.to("#circle",1,{top:"-=8rem",ease: Power0.easeNone})

	var brd1 = new TimelineMax({repeat:-1,repeatDelay:1,yoyo: true});
	brd1.staggerFrom( ".brand1 .ani span",.01,{'opacity':'0'},.5)

	var bounce = new TimelineMax({repeat:-1,yoyo: true});
	bounce.to( ".brand3 .ani span",.5,{'transform':'translateY(-1rem)',ease: Power1.easeOut})

	var mickyFace = new TimelineMax({repeat:-1,repeatDelay:.6});
        mickyFace.to( ".brand4 .ani span:nth-child(1)" , .5,{rotation:-15,repeat:2, yoyo:true,ease: Power0.easeNone})
            .to( ".brand4 .ani span:nth-child(1)" , .5,{rotation:0, ease: Power0.easeNone})
        mickyFace.to( ".brand4 .ani span:nth-child(2)" , .5,{rotation:15,repeat:2, yoyo:true,ease: Power0.easeNone},'-=2')
            .to( ".brand4 .ani span:nth-child(2)" , .5,{rotation:0 ,ease: Power0.easeNone},'-=.5')
        mickyFace.to( ".brand4 .ani span:nth-child(4)" , .1,{opacity:0},'-=2.5')
            .to( ".brand4 .ani span:nth-child(4)" , .1,{opacity:1},'+=.1')

	//btn more style
	$(".elmore").css("display","none");
	$('.btn-more').each(function(){
		$(this).click(function(e){
			var idx = e.target.value;
			if (idx != "") {
				$(this).toggleClass('on')
				$(".detailElm"+idx).css("display", "");
				$(this).hide();
			}
		})
	})

	//top slide-bnr
	var mainBnr = new Swiper(".main-bnr .swiper-container", {
		paginationClickable:true,
		autoplay:4400,
		loop:true,
		speed:600,
		parallax:true,
		onSlideChangeStart: function (mainBnr) {
			var vActIdx = parseInt(mainBnr.activeIndex);
			if (vActIdx<=0) {
				vActIdx = mainBnr.slides.length-2;
			} else if(vActIdx>(mainBnr.slides.length-2)) {
				vActIdx = 1;
			}
			$(".main-bnr .pagingNo .page strong").text(vActIdx);
		}
	});
	$('.main-bnr .pagingNo .page strong').text(1);
	$('.main-bnr .pagingNo .page span').text(mainBnr.slides.length-2);

    //timer
	var date = new Date(-32400000);
	setInterval(function() {
		date.setSeconds(date.getSeconds() + 1);
		$('.issue-vod .timer').html(date.toTimeString().substr(0, 8));
	}, 1000);

	//스페셜 상품
    fnApplyItemInfoEach ({
        items:"<%=OnedayItemID%>", //상품코드
        target:"item",
        fields:["price","sale","soldout"],
        unit:"hw", 
        saleBracket:false 
    });
	
	//category
	swiper = new Swiper('.cateList.slide1', {
		slidesPerView:'auto',
	});
	$('.cate-area .sort a').click(function(e){
		var checkval = $(this).attr("rel");
		$(this).parent().addClass('on').siblings().removeClass('on')
		document.listfrm.sortMet.value = checkval;
		document.listfrm.cpg.value = 1;
        e.preventDefault();
        getList();
	})

	$('.cateList li').click(function(){
        var checkval = $(this).find("input[name='type']").val();
        $(this).addClass('on').siblings().removeClass('on')
        document.listfrm.detailcode.value = checkval;
		document.listfrm.cpg.value = 1;
        getList();
    })

	// item list init
    getList();
});

// 전체 상품 리스트
function getList() {
	var str = $.ajax({
			type: "GET",
	        url: "/stationerystore/ajaxDataList.asp",
	        data: $("#listfrm").serialize(),
	        dataType: "text",
	        async: false
	}).responseText;

	if (str!="") {
		($("#listfrm input[name='cpg']").val()=="1") ? $('#catearea').empty().html(str) : $('#catearea').append(str);
    } else {
		alert('마지막 입니다.');
		$(".all-item").hide();
	}
}

function jsGoComPage() {
    document.listfrm.cpg.value++;
    getList();
}

function fnGoHistory(evtcode){
<% if isapp = 1 then %>
	fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid='+evtcode);
<% else %>
	location.href='/event/eventmain.asp?eventid='+evtcode;
<% end if %>
}
</script>
	<!-- contents -->
	<div id="content" class="content moonbanggu">
		<h2 class="logo"><span><img src="//fiximage.10x10.co.kr/m/2019/moonbanggu/tit_moonbanggu.png" alt=""></span></h2>
		
		<!-- 메인롤링배너 -->
		<% if isArray(arrSwiperList) then %>
		<section class="text-bnr main-bnr">
			<div class="swiper-container">
				<div class="swiper-wrapper">
                    <% 
                        for lp = 0 to ubound(arrSwiperList,2)
                    %>
					<div class="swiper-slide">
                        <% if isapp = 1 then %>
						<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_StationeryStore_swipe','idx|eventcode','<%=lp+1%>|<%=arrSwiperList(12,lp)%>'
						, function(bool){if(bool) {fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=arrSwiperList(12,lp)%>');return false;}});">
                        <% else %>
                        <a href="/event/eventmain.asp?eventid=<%=arrSwiperList(12,lp)%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_StationeryStore_swipe','idx|eventcode','<%=lp+1%>|<%=arrSwiperList(12,lp)%>')">
                        <% end if %>
							<div class="thumbnail"><img src="<%=arrSwiperList(8,lp)%>" alt=""></div>
							<div class="desc" data-swiper-parallax="-100">
								<div class="headline">
									<span><%=arrSwiperList(5,lp)%></span>
								</div>
								<p class="subcopy"><%=arrSwiperList(20,lp)%></p>
								<div>
									<% if arrSwiperList(22,lp) <> "" and (arrSwiperList(24,lp)) then %><b class="discount bg-red">~<%=arrSwiperList(22,lp)%>%</b><% end if %>
									<% if arrSwiperList(23,lp) <> "" and (arrSwiperList(25,lp)) then %><b class="discount bg-green">~<%=arrSwiperList(23,lp)%>%</b><% end if %>
								</div>
							</div>
						</a>
					</div>
					<% 
						next 							
					%>	
				</div>
			</div>
			<div class="pagingNo" style="display:block;"><p class="page"><strong></strong><em>ㅣ</em><span></span></p></div>
		</section>
		<% end if %>

		<%' oneday %>
		<%
			if isArray(getOneDayItemEvent) then
		%>
		<section class="main-prd item<%=OnedayItemID%>">
			<div class="inner">
				<% if isapp = 1 then %>
				<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_StationeryStore_Oneday_item','itemid','<%=OnedayItemID%>', function(bool){if(bool) {fnAPPpopupProduct('<%=OnedayItemID%>');return false;}});" class="<%=OnedayLabel%>">
				<% else %>
				<a href="/category/category_itemPrd.asp?itemid=<%=OnedayItemID%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_StationeryStore_Oneday_item','itemid','<%=OnedayItemID%>')" class="<%=OnedayLabel%>">
				<% end if %>
					<div class="img-cont verNew">
						<div class="thumbnail">
							<img src="<%=OnedayIMG%>" alt="">
						</div>
						<p class="badge day-0<%=OneDayDueDate%>"></p>
						<div class="oneday-chart">
							<div class="chart" data-percent="<%=targetNum%>"><span class="percent"></span><canvas height="250" width="250"></canvas></div>
							<p class="time"><span class="icon icon-clock"></span><span id="countdown">00:00:00</span></p>
						</div>
					</div>
					<div class="desc">
						<p class="name-area"><span class="name"><%=OnedayTitle%></span></p>
						<div class="price"><s></s> <span></span></div>
					</div>
				</a>
			</div>
		</section>
		<%
			end if 
		%>
		<section class="items-wrap">
			<div class="inner">
				<!-- 실시간랭킹 -->
				<article class="now-ranking" id="now-ranking">
					<h3 class="nav">
						<ul>
							<li class="nav1 on"><a href="#now-ranking">실시간 랭킹</a></li>
							<li class="nav2"><a href="#cart-best">장바구니 베스트</a></li>
							<li class="nav3"><a href="#tenten-pic">텐텐문방구 PICK</a></li>
						</ul>
					</h3>
					<div class="items">
						<ul>
						<% if Ubound(realsellItemList) > 0 then %>
							<%  
								dim couponPrice, couponPer, tempPrice, salePer
								dim saleStr, couponStr
								
								for i = 0 to Ubound(realsellItemList) - 1
								couponPer = oExhibition.GetCouponDiscountStr(realsellItemList(i).Fitemcoupontype, realsellItemList(i).Fitemcouponvalue)
								couponPrice = oExhibition.GetCouponDiscountPrice(realsellItemList(i).Fitemcoupontype, realsellItemList(i).Fitemcouponvalue, realsellItemList(i).Fsellcash)                    
								salePer     = CLng((realsellItemList(i).Forgprice-realsellItemList(i).Fsellcash)/realsellItemList(i).FOrgPrice*100)
								if realsellItemList(i).FSaleyn = "Y" and realsellItemList(i).Fitemcouponyn = "Y" then '세일
									tempPrice = realsellItemList(i).Fsellcash - couponPrice
									saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
									couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
								elseif realsellItemList(i).Fitemcouponyn = "Y" then
									tempPrice = realsellItemList(i).Fsellcash - couponPrice
									saleStr = ""
									couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
								elseif realsellItemList(i).FSaleyn = "Y" then
									tempPrice = realsellItemList(i).Fsellcash
									saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
									couponStr = ""                                              
								else
									tempPrice = realsellItemList(i).Fsellcash
									saleStr = ""
									couponStr = ""                                              
								end if
							%>
							<li<%=chkIIF(i > 5, " class='elmore detailElm"&realsellItemList(5).Fitemid&"'", "")%>>
								<% if isapp = 1 then %>
								<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_StationeryStore_best_item','index|itemid','<%=i+1%>|<%=realsellItemList(i).Fitemid%>', function(bool){if(bool) {fnAPPpopupProduct('<%=realsellItemList(i).Fitemid%>');return false;}});">
								<% else %>
								<a href="/category/category_itemPrd.asp?itemid=<%=realsellItemList(i).Fitemid%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_StationeryStore_best_item','index|itemid','<%=i+1%>|<%=realsellItemList(i).Fitemid%>')">
								<% end if %>
									<div class="thumbnail">
										<img src="<%=realsellItemList(i).FImageBasic%>" alt="<%=realsellItemList(i).Fitemname%>" />
										<em><%=i+1%></em><% if realsellItemList(i).FsellYn = "N" then %><b class="soldout">일시 품절</b><% end if %>
									</div>
									<div class="desc">
										<p class="name"><%=realsellItemList(i).Fitemname%></p>
										<div class="price">
											<div class="unit"><b class="sum"><%=formatNumber(tempPrice, 0)%><span class="won">원</span></b><%=saleStr%><%=couponStr%></div>
										</div>
									</div>
								</a>
							</li>
							<% next %>                    
                		<% end if %>
						</ul>
					</div>
					<% if Ubound(realsellItemList) > 5 then %>
					<button class="btn btn-more" value="<%=realsellItemList(5).Fitemid%>">더 많은 상품 보기</button>
					<% end if %>
				</article>
				<!-- 장바구니 베스트 -->
				<article class="cart-best" id="cart-best">
					<h3 class="nav">
						<ul>
							<li class="nav1"><a href="#now-ranking">실시간 랭킹</a></li>
							<li class="nav2 on"><a href="#cart-best">장바구니 베스트</a></li>
							<li class="nav3"><a href="#tenten-pic">텐텐문방구 PICK</a></li>
						</ul>
					</h3>
					<!-- for dev msg : 처음에는 상품 6개 노출 되고 더보기 버튼 누른후 12개 노출 -->
					<div class="items">
						<ul>
							<%
							If wishlist.FResultCount > 0 Then
								For i = 0 To wishlist.FResultCount - 1

								IF application("Svr_Info") = "Dev" THEN
									wishlist.FItemList(i).FImageicon1 = left(wishlist.FItemList(i).FImageicon1,7)&mid(wishlist.FItemList(i).FImageicon1,12)
								end if
							%>
							<li<%=chkIIF(i>5, " class='elmore detailElm"&wishlist.FItemList(0).Fitemid&"'", "")%>>
								<% If isapp Then %>
								<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_StationeryStore_recommend_cart_item','item_index|itemid|brand_name','<%=i+1%>|<%=wishlist.FItemList(i).FItemid%>|<%=replace(wishlist.FItemList(i).FBrandName,"'","")%>',function(bool){if(bool) {fnAPPpopupAutoUrl('/category/category_itemprd.asp?itemid=<%=wishlist.FItemList(i).FItemid%>&gaparam=stationerystore_wish_<%=i+1%>');}});return false;">
								<% Else %>
								<a href="/category/category_itemprd.asp?itemid=<%=wishlist.FItemList(i).FItemid%>&gaparam=stationerystore_wish_<%=i+1%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_StationeryStore_recommend_cart_item','item_index|itemid|brand_name','<%=i+1%>|<%=wishlist.FItemList(i).FItemid%>|<%=replace(wishlist.FItemList(i).FBrandName,"'","")%>')">
								<% End if %>
									<div class="thumbnail">
										<img src="<%= wishlist.FItemList(i).FDiaryBasicImg2 %>" alt="<%= wishlist.FItemList(i).FItemName %>" />
										<% If wishlist.FItemList(i).Ffavcount > 0 Then %><em><%=formatnumber(wishlist.FItemList(i).Ffavcount,0)%>명</em><% end if %><% if wishlist.FItemList(i).IsSoldOut then %><b class="soldout">일시 품절</b><% end if %>
									</div>
									<div class="desc">
										<p class="name">
											<% If wishlist.FItemList(i).isSaleItem Or wishlist.FItemList(i).isLimitItem Then %>
												<%= chrbyte(wishlist.FItemList(i).FItemName,30,"Y") %>
											<% Else %>
												<%= wishlist.FItemList(i).FItemName %>
											<% End If %>
										</p>
										<div class="price">
											<div class="unit">
												<% if wishlist.FItemList(i).IsSaleItem or wishlist.FItemList(i).isCouponItem Then %>
													<% IF wishlist.FItemList(i).IsCouponItem Then %>
														<b class="sum"><%=FormatNumber(wishlist.FItemList(i).GetCouponAssignPrice,0)%><span class="won">원</span></b>
														<b class="discount color-green"><%=wishlist.FItemList(i).GetCouponDiscountStr%></b>
													<% else %>                                                                            
														<b class="sum"><%=FormatNumber(wishlist.FItemList(i).getRealPrice,0)%><span class="won">원</span></b>
														<b class="discount color-red"><%=wishlist.FItemList(i).getSalePro%></b>
													<% End If %>
												<% else %>
													<b class="sum"><%=FormatNumber(wishlist.FItemList(i).getRealPrice,0) & chkIIF(wishlist.FItemList(i).IsMileShopitem,"Point","<span class='won'>원</span>")%></b>
												<% end if %>
											</div>
										</div>
									</div>
								</a>
							</li>
							<%
								Next
							end If
							%>
						</ul>
					</div>
					<% if wishlist.FResultCount > 5 then %>
					<button class="btn btn-more" value="<%=wishlist.FItemList(0).Fitemid%>">더 많은 상품 보기</button>
					<% end if %>
				</article>
				<!-- 텐텐문방구 pick -->
				<article class="tenten-pic" id="tenten-pic">
					<h3 class="nav">
						<ul>
							<li class="nav1"><a href="#now-ranking">실시간 랭킹</a></li>
							<li class="nav2"><a href="#cart-best">장바구니 베스트</a></li>
							<li class="nav3 on"><a href="#tenten-pic">텐텐문방구 PICK</a></li>
						</ul>
					</h3>
					<!-- for dev msg : 처음에는 상품 6개 노출 되고 더보기 버튼 누른후 12개 노출 -->
					<div class="items">
						<ul>
						<% if Ubound(bestItemList) > 0 then %>
							<%  
								for i = 0 to Ubound(bestItemList) - 1
								couponPer = oExhibition.GetCouponDiscountStr(bestItemList(i).Fitemcoupontype, bestItemList(i).Fitemcouponvalue)
								couponPrice = oExhibition.GetCouponDiscountPrice(bestItemList(i).Fitemcoupontype, bestItemList(i).Fitemcouponvalue, bestItemList(i).Fsellcash)                    
								salePer     = CLng((bestItemList(i).Forgprice-bestItemList(i).Fsellcash)/bestItemList(i).FOrgPrice*100)
								if bestItemList(i).Fsailyn = "Y" and bestItemList(i).Fitemcouponyn = "Y" then '세일
									tempPrice = bestItemList(i).Fsellcash - couponPrice
									saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
									couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
								elseif bestItemList(i).Fitemcouponyn = "Y" then
									tempPrice = bestItemList(i).Fsellcash - couponPrice
									saleStr = ""
									couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
								elseif bestItemList(i).Fsailyn = "Y" then
									tempPrice = bestItemList(i).Fsellcash
									saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
									couponStr = ""                                              
								else
									tempPrice = bestItemList(i).Fsellcash
									saleStr = ""
									couponStr = ""                                              
								end if
							%>
							<li<%=chkIIF(i > 5, " class='elmore detailElm"&bestItemList(5).Fdetailcode&"'", "")%>>
								<% if isapp = 1 then %>
								<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_StationeryStore_mdpick_item','index|itemid','<%=i+1%>|<%=bestItemList(i).Fitemid%>', function(bool){if(bool) {fnAPPpopupProduct('<%=bestItemList(i).Fitemid%>');return false;}});">
								<% else %>
								<a href="/category/category_itemPrd.asp?itemid=<%=bestItemList(i).Fitemid%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_StationeryStore_mdpick_item','index|itemid','<%=i+1%>|<%=bestItemList(i).Fitemid%>')">
								<% end if %>
									<div class="thumbnail">
										<img src="<%=bestItemList(i).FBasicimage%>" alt="<%=bestItemList(i).Fitemname%>" />
										<em><%=i+1%></em><% if bestItemList(i).FsellYn = "N" then %><b class="soldout">일시 품절</b><% end if %>
									</div>
									<div class="desc">
										<p class="name"><%=bestItemList(i).Fitemname%></p>
										<div class="price">
											<div class="unit"><b class="sum"><%=formatNumber(tempPrice, 0)%><span class="won">원</span></b><%=saleStr%><%=couponStr%></div>
										</div>
									</div>
								</a>
							</li>
							<% next %>                    
                		<% end if %>
						</ul>
					</div>
					<% if Ubound(bestItemList) > 5 then %>
					<button class="btn btn-more" value="<%=bestItemList(5).Fdetailcode%>">더 많은 상품 보기</button>
					<% end if %>
				</article>
			</div>
		</section>

		<%' 전체 리스트 %>
		<form id="listfrm" name="listfrm" method="get" style="margin:0px;">
            <input type="hidden" name="cpg" value="1" />
            <input type="hidden" name="sortMet" />
            <input type="hidden" name="detailcode" value="" />
		</form>
		<section class="cate-area">
			<div class="items-wrap">
				<div class="cateList slide1">
					<ul class="swiper-wrapper">
						<li class="all swiper-slide"><input type="radio" name="type" id="all" value=""/><label for="all"><span></span>전체보기</label></li>
						<li class="sticker swiper-slide"><input type="radio" name="type" id="sticker" value="10"/><label for="sticker"><span></span>스티커</label></li>
						<li class="tape swiper-slide"><input type="radio" name="type" id="tape" value="20"/><label for="tape"><span></span>마스킹테이프</label></li>
						<li class="keyring swiper-slide"><input type="radio" name="type" id="keyring" value="30"/><label for="keyring"><span></span>키링</label></li>
						<li class="pen swiper-slide"><input type="radio" name="type" id="pen" value="40"/><label for="pen"><span></span>펜</label></li>
						<li class="case swiper-slide"><input type="radio" name="type" id="case" value="50"/><label for="case"><span></span>필통</label></li>
						<li class="memo swiper-slide"><input type="radio" name="type" id="memo" value="60"/><label for="memo"><span></span>메모지/노트</label></li>
						<li class="binder swiper-slide"><input type="radio" name="type" id="binder" value="70"/><label for="binder"><span></span>바인더/다이어리</label></li>
						<li class="desc swiper-slide"><input type="radio" name="type" id="desc" value="80"/><label for="desc"><span></span>데스크아이템</label></li>
					</ul>
				</div>
				<div class="inner">
					<div class="sort">
						<ul>
							<li class="on"><a href="" rel="5">신상품순</a></li>
							<li><a href="" rel="6">낮은가격순</a></li>
							<li><a href="" rel="7">높은할인율순</a></li>
						</ul>
					</div>
					<div class="items">
						<ul id="catearea"></ul>
					</div>
					<button class="btn btn-more all-item" onclick="jsGoComPage();">더 많은 상품 보기</button>
				</div>
			</div>
		</section>
		<%' 전체 리스트 %>

		<!-- 텐텐문방구 스토리 -->
		<section class="story">
			<svg id="circle"><circle/></svg>
			<div class="inner">
				<h3>텐텐문방구 스토리</h3>
				<% if now()>="2019-08-07" then %>
				<dl>
					<dt><img src="//webimage.10x10.co.kr/fixevent/event/2019/moonbanggu/tentenstory/190807/img.png" alt=""></span></dt>
					<dd>
						<span class="label">이번주 테마</span>
						<p class="tit">D-100, 격하게 응원해!!</p>
						<div class="subtxt">
							수능 D-100 중요한 지금 딱 필요한 꿀템 추천!
						</div>
						<button class="btn btn-detail" onclick="fnGoHistory(96370);">자세히 보러가기</button>
					</dd>
				</dl>
				<% else %>
				<dl>
					<dt><img src="//webimage.10x10.co.kr/fixevent/event/2019/moonbanggu/tentenstory/190724/img.png" alt=""></span></dt>
					<dd>
						<span class="label">이번주 테마</span>
						<p class="tit">비 오는 날의 수채화</p>
						<div class="subtxt">
							비 오는 날의 추억을 <br>추천드립니다.
						</div>
						<button class="btn btn-detail" onclick="fnGoHistory(96271);">자세히 보러가기</button>
					</dd>
				</dl>
				<% end if %>
			</div>
		</section>
		<!-- 기획전 -->
		<section class="evt-list">
			<div class="inner">
				<h3>기획전</h3>
				<%'!-- for dev msg : 처음에는 상품 3개 노출 되고 더보기 버튼 누른후 5개 노출 --%>
				<ul>
                    <% if isArray(eventList) then %>
                    <%
                        for i = 0 to Ubound(eventList) - 1
						if eventList(i).Frectangleimage = "" then
                        else
                    %>
					<li class="<%=chkIIF(i > 3, "elmore detailElm3", "")%>">
						<% if isapp = 1 then %>
						<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_StationeryStore_event','idx|eventcode','<%=i+1%>|<%=eventList(i).Fevt_code%>'
						, function(bool){if(bool) {fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=eventList(i).Fevt_code%>');return false;}});">
                        <% else %>
                        <a href="/event/eventmain.asp?eventid=<%=eventList(i).Fevt_code%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_StationeryStore_event','idx|eventcode','<%=i+1%>|<%=eventList(i).Fevt_code%>')">
                        <% end if %>
							<div class="thumbnail">
								<img src="<%=eventList(i).Frectangleimage%>" alt="<%=cStr(Split(eventList(i).Fevt_name,"|")(0))%>">
								<% if eventList(i).Fisgift then %><span class="ico-gift"></span><% end if %>
							</div>
							<div class="desc">
								<p class="tit">
									<span><%=cStr(Split(eventList(i).Fevt_name,"|")(0))%></span>
									<% if eventList(i).Fsaleper <> "" and not(isnull(eventList(i).Fsaleper)) then %>
										<% if eventList(i).Fsaleper > 0 then %>
										<em class="discount bg-red">~<%=eventList(i).Fsaleper%>%</em>
										<% end if %>
									<% end if %>
								</p>
							</div>
						</a>
					</li>
					<%
						end if
						next
					%>
				    <% end if %>
				</ul>
				<% 
					if isArray(eventList) then 
						if Ubound(eventList) > 5 then 
				%>
				<button class="btn btn-more" value="3">더 많은 기획전 보기</button>
				<% 
						end if 
					end if
				%>
			</div>
		</section>
		<section class="issue-vod">
			<% if now()>="2019-08-21" then %>
			<div class="inner">
				<% if isapp = 1 then %>
				<a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96769')">
				<% else %>
				<a href="/event/eventmain.asp?eventid=96769">
				<% end if %>
					<div class="tit">
						<span><b>·</b>이슈영상</span>
						<em class="timer">00:00:00</em>
					</div>
					<dl>
						<dt class="new">
							<img src="//webimage.10x10.co.kr/fixevent/event/2019/moonbanggu/vodthumb/190821/img.png" alt="">
						</dt>
						<dd>
							<span class="label">다꾸TV 4편</span>
							<div class="subtxt">
								인스타그래머<br>나키의<br>다이어리꾸미기
							</div>
						</dd>
					</dl>
				</a>
			</div>
			<% else %>
			<div class="inner">
				<% if isapp = 1 then %>
				<a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=95898')">
				<% else %>
				<a href="/event/eventmain.asp?eventid=95898">
				<% end if %>
					<div class="tit">
						<span><b>·</b>이슈영상</span>
						<em class="timer">00:00:00</em>
					</div>
					<dl>
						<dt class="new">
							<img src="//webimage.10x10.co.kr/fixevent/event/2019/moonbanggu/vodthumb/190724/img.png" alt="">
						</dt>
						<dd>
							<span class="label">다꾸TV 3편</span>
							<div class="subtxt">
								유튜버 피치보쨘의 상큼달큼 다꾸의 정석!
							</div>
						</dd>
					</dl>
				</a>
			</div>
			<% end if %>
		</section>
		<section class="brand-story">
			<div class="inner">
				<h3>브랜드 스토리</h3>
				<div class="list-wrap">
					<span><img src="//fiximage.10x10.co.kr/m/2019/moonbanggu/img_brand.jpg" alt=""></span>
					<ul>
						<li class="brand1">
							<h4 class="blind">HIGHTIDE</h4>
							<a href="/street/street_brand.asp?makerid=HIGHTIDE" class="mWeb"></a>
							<a href="" onclick="fnAPPpopupBrand('HIGHTIDE'); return false;" class="mApp"></a>
							<div class="ani">
								<span><img src="//fiximage.10x10.co.kr/m/2019/moonbanggu/img_brand1_01.png?v=1.03" alt=""></span>
								<span><img src="//fiximage.10x10.co.kr/m/2019/moonbanggu/img_brand1_02.png?v=1.03" alt=""></span>
								<span><img src="//fiximage.10x10.co.kr/m/2019/moonbanggu/img_brand1_04.png?v=1.03" alt=""></span>
								<span><img src="//fiximage.10x10.co.kr/m/2019/moonbanggu/img_brand1_03.png?v=1.03" alt=""></span>
							</div>
						</li>
						<li class="brand2">
							<h4 class="blind">TRAVELER'S NOTE</h4>
							<a href="/street/street_brand.asp?makerid=tfc2018" class="mWeb"></a>
							<a href="" onclick="fnAPPpopupBrand('tfc2018'); return false;" class="mApp"></a>
						</li>
						<li class="brand3">
							<h4 class="blind">MOLESKINE</h4>
							<a href="/street/street_brand.asp?makerid=moleskine" class="mWeb"></a>
							<a href="" onclick="fnAPPpopupBrand('moleskine'); return false;" class="mApp"></a>
							<div class="ani"><span><img src="//fiximage.10x10.co.kr/m/2019/moonbanggu/img_brand3_01.png?v=1.03" alt=""></span></div>
						</li>
						<li class="brand4">
							<h4 class="blind">DISNEY</h4>
							<a href="/street/street_brand.asp?makerid=disney10x10" class="mWeb"></a>
							<a href="" onclick="fnAPPpopupBrand('disney10x10'); return false;" class="mApp"></a>
							<div class="ani">
								<span><img src="//fiximage.10x10.co.kr/m/2019/moonbanggu/img_brand4_03.png?v=1.03" alt=""></span>
								<span><img src="//fiximage.10x10.co.kr/m/2019/moonbanggu/img_brand4_04.png?v=1.03" alt=""></span>
								<span><img src="//fiximage.10x10.co.kr/m/2019/moonbanggu/img_brand4_01.png?v=1.03" alt=""></span>
								<span><img src="//fiximage.10x10.co.kr/m/2019/moonbanggu/img_brand4_02.png?v=1.03" alt=""></span>
							</div>
						</li>
						<li class="brand5">
							<h4 class="blind">BT21</h4>
							<a href="/street/street_brand.asp?makerid=khstudio8" class="mWeb"></a>
							<a href="" onclick="fnAPPpopupBrand('khstudio8'); return false;" class="mApp"></a>
						</li>
						<li class="brand6">
							<h4 class="blind">LAMY</h4>
							<a href="/street/street_brand.asp?makerid=lamy2" class="mWeb"></a>
							<a href="" onclick="fnAPPpopupBrand('lamy2'); return false;" class="mApp"></a>
						</li>
						<li class="brand7">
							<h4 class="blind">THENCE</h4>
							<a href="/street/street_brand.asp?makerid=onward" class="mWeb"></a>
							<a href="" onclick="fnAPPpopupBrand('onward'); return false;" class="mApp"></a>
							<div class="ani"><span><img src="//fiximage.10x10.co.kr/m/2019/moonbanggu/img_brand7_01.png?v=1.03" alt=""></span></div>
						</li>
					</ul>
				</div>
			</div>
		</section>
	</div>
<%
Set oRealSell = Nothing
Set oExhibition = Nothing
Set wishlist = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->        