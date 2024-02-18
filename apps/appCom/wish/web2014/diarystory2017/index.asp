<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리2017 APP 메인
' History : 2016-09-20 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2017/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2017/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
dim GiftSu, i, weekDate, imglink

weekDate = weekDayName(weekDay(now)) '// 요일 구하기 내장 함수

'2016년엔 10월4일(오픈) 이후로 평일빨간날(공휴일)이 없음.
'if date >= "2016-10-03" and  date < "2016-10-17" then
'	weekDate = "공휴일"
'end if
'weekDate="공휴일"
GiftSu=0

dim cDiary	'평일
dim cDiaryE'주말

 '1+1
Set cDiary = new cdiary_list
	cDiary.getOneplusOneDaily

'일반배너
Set cDiaryE = new cdiary_list
If weekDate = "토요일" Or weekDate = "일요일" Or weekDate = "공휴일" Then
	cDiaryE.Ftopcount = 3
else
	cDiaryE.Ftopcount = 2
end if
cDiaryE.getOneDailynot
	
if cDiary.ftotalcount>0 then
	GiftSu = cDiary.getGiftDiaryExists(cDiary.FOneItem.Fitemid) '사은품 수
		if GiftSu = false then GiftSu=0
else
	GiftSu=0
end if

dim cDiarycnt
Set cDiarycnt = new cdiary_list
	cDiarycnt.getDiaryCateCnt '상태바 count
	
IF application("Svr_Info") = "Dev" THEN
	imglink = "testimgstatic"
	'imglink = "imgstatic"
Else
	imglink = "imgstatic"
End If

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
dim snpTitle, snpLink, snpPre, snpImg , snpTag , snpTag2 , kakaourl
snpTitle = Server.URLEncode("[10x10] 2017 다이어리")
snpLink = Server.URLEncode(wwwUrl&"/diarystory2017/index.asp")
snpPre = Server.URLEncode("[10x10] 2017 다이어리")

snpImg = Server.URLEncode("http://webimage.10x10.co.kr/eventIMG/2016/73050/etcitemban20160922094206.JPEG")
'기본 태그
snpTag = Server.URLEncode("텐바이텐 " & Replace("2017 다이어리"," ",""))
snpTag2 = Server.URLEncode("#10x10")

If isapp = "1" Then '앱일경우
	kakaourl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/diarystory2017/index.asp"
Else '앱이 아닐경우
	kakaourl = "http://m.10x10.co.kr/diarystory2017/index.asp"
End If
strPageTitle = "생활감성채널, 텐바이텐 > 2017 다이어리 "

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/diary2017.css" />
<script type="text/javascript">
// SNS 공유 팝업
function fnAPPRCVpopSNS(){
	fnAPPpopupBrowserURL("공유","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popShare.asp?sTit=<%=snpTitle%>&sLnk=<%=snpLink%>&sPre=<%=snpPre%>&sImg=<%=snpImg%>");
	return false;
}

$(function(){
	<% if isapp then %>
		fnAPPchangPopCaption("2017 다이어리");
	<% end if %>

	// main banner
	if($('.todayDiary .swiper-slide').length>1) {
		var swiper1 = new Swiper(".todayDiary .swiper-container", {
			pagination:".todayDiary .paginationDot",
			paginationClickable:true,
			autoplay:3000,
			loop:true,
			speed:500
		});
	}

	// md choice
	var swiper2 = new Swiper(".mdChoice .swiper-container", {
		loop:false,
		autoplay:false,
		speed:500,
		slidesPerView:'auto',
		centeredSlides:false,
		pagination:false
	});

	// best diary
	var swiper3 = new Swiper(".bestDiary .swiper-container", {
		loop:false,
		autoplay:false,
		speed:500,
		slidesPerView:'auto',
		centeredSlides:false,
		pagination:false
	});

	// event title control
	$('.listCardV16 ul li').each(function(){
		if ($(this).find('.label').children("b").length == 2) {
			$(this).find('.desc').children('p').children('strong').css('width','74%');
		} else if ($(this).find('.label').children("b").length == 1) {
			$(this).find('.desc').children('p').children('strong').css('width','86%');
		} else {
			$(this).find('.desc').children('p').children('strong').css('width','100%');
		}
	});
});

function searchlink(v){
	if (v == ""){
		fnAPPpopupBrowserURL('다이어리 리스트','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2017/list.asp');
	}else{
		var listurl="<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2017/list.asp?arrds=" + v + ",";
		fnAPPpopupBrowserURL('다이어리 리스트',listurl);
	}
}

//토,일 배너 링크
function weeklink(v){
	if (v == ""){
		fnAPPpopupBrowserURL('다이어리','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2017/index.asp');
	}else{
		var listurl="<%=wwwUrl%>/apps/appCom/wish/web2014"+v;
		fnAPPpopupBrowserURL('다이어리',listurl);
	}
}

// 이벤트 이동
function goEventLink(evt) {
	<% if isApp then %>
//		fnAPPpopupEvent(evt);
		fnAPPpopupBrowserURL('다이어리 이벤트','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid='+evt);
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry diarystory2017">
			<%' content area  %>
			<div class="content" id="contentArea">
				<%' main banner  %>
				<section class="todayDiary">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<% If weekDate <> "토요일" and weekDate <> "일요일" and weekDate <> "공휴일" Then %>
								<%' 투데이 다이어리  %>
								<% if cDiary.ftotalcount > 0 then %>
									<div class="swiper-slide">
										<a href="" onclick="fnAPPpopupProduct('<%=cDiary.FOneItem.FItemid%>'); return false;">
											<div><img src="http://<%= imglink %>.10x10.co.kr/diary/oneplusone/<%= cDiary.FOneItem.Fmimage1 %>" alt="<%= cDiary.FOneItem.Fitemname %>" /></div>
											<% if cDiary.FOneItem.IsSaleItem or cDiary.FOneItem.isCouponItem Then %>
												<% IF cDiary.FOneItem.IsSaleItem then %>
													<p class="price"><%=FormatNumber(cDiary.FOneItem.getRealPrice,0)%>원 [<%=cDiary.FOneItem.getSalePro%>]</p>
												<% End If %>
												<% IF cDiary.FOneItem.IsCouponItem Then %>
													<p class="price"><%=FormatNumber(cDiary.FOneItem.GetCouponAssignPrice,0)%>원 [<%=cDiary.FOneItem.GetCouponDiscountStr%>]</p>
												<% end if %>
											<% else %>
												<p class="price"><%=FormatNumber(cDiary.FOneItem.getRealPrice,0) & chkIIF(cDiary.FOneItem.IsMileShopitem,"Point","원")%></p>
											<% end if %>
											
											<% If GiftSu > 0 Then %>
												<p class="limit"><%= GiftSu %>개<br />남음</p>
												<p class="plus">
													<span>
														<% if cDiary.FOneItem.fplustype="1" then %>
															<img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/ico_gift.png" alt="1+1" />
														<% else %>
															<img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/ico_gift.png" alt="1:1" />
														<% end if %>
													<span>
												</p>
											<% end if %>
										</a>
									</div>
								<% end if %>
							<% end if %>
							<%' 일반 통이미지 배너  %>
							<% if cDiaryE.FTotalCount > 0 then %>
								<% for i = 0 to cDiaryE.FTotalCount -1 %>
									<div class="swiper-slide">
										<a href="" onclick="weeklink('<%=cDiaryE.FItemList(i).Flinkpath%>'); return false;"><img src="<%= cDiaryE.FItemList(i).GetImageUrl %>" alt="<%= cDiaryE.FItemList(i).Fitemname %>" /></a>
									</div>
								<% next %>
							<% end if %>
						</div>
						<div class="paginationDot"></div>
					</div>
				</section>

				<%' gift  %>
				<!--
				<section class="diaryGift">
					<a href="" onclick="fnAPPpopupBrowserURL('사은품','http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2017/gift.asp'); return false;"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/bnr_diary_gift.jpg" alt="2017 다이어리 구매금액별 사은품" /></a>
				</section>
				-->

				<%' md's choice  %>
				<section class="mdChoice box">
					<!-- #include virtual="/apps/appcom/wish/web2014/diarystory2017/inc/inc_mdpick.asp" -->
				</section>

				<%' diary finder  %>
				<section class="diaryFinder">
					<ul>
						<li class="simple"><a href="" onclick="searchlink('10'); return false;"><span>Simple</span></a></li>
						<li class="illust"><a href="" onclick="searchlink('20'); return false;"><span>Illust</span></a></li>
						<li class="pattern"><a href="" onclick="searchlink('30'); return false;"><span>Pattern</span></a></li>
						<li class="photo"><a href="" onclick="searchlink('40'); return false;"><span>Photo</span></a></li>
					</ul>
					<a href="" onclick="fnAPPpopupBrowserURL('다이어리 리스트','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2017/list.asp'); return false;" class="btnFind"><span>2017 다이어리 보기</span></a>
				</section>

				<%' best diary  %>
				<section class="bestDiary box">
					<!-- #include virtual="/apps/appcom/wish/web2014/diarystory2017/inc/inc_best.asp" -->
				</section>

				<%' brand special %>
				<div class="special" style="background-image:url(<%=staticImgUrl%>/diary/specialbrand/<%=fnGetBrandSpecialimg%>)">
					<a href="" onclick="fnAPPpopupBrowserURL('브랜드 스페셜','http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2017/brandspecial.asp'); return false;"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/bnr_special.png" alt="" /></a>
				</div>

				<%' happy together  %>
				<section class="happyTogether box">
					<h2><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/tit_happy_together.png" alt="happy together" /></h2>
					<ul>
						<li><a href="" onclick="goEventLink('73013'); return false;"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/btn_pen_fair.png" alt="The Pen Fair" /></a></li>
						<li><a href="" onclick="goEventLink('73356'); return false;"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/btn_calendar.png" alt="Calendar" /></a></li>
						<li><a href="" onclick="goEventLink('73355'); return false;"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/btn_note.png" alt="Note" /></a></li>
						<li><a href="" onclick="goEventLink('73328'); return false;"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/btn_planner.png" alt="Planner" /></a></li>
						<li><a href="" onclick="goEventLink('73327'); return false;"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/btn_deco.png" alt="Deco" /></a></li>
						<li><a href="" onclick="fnAPPpopupCategory('101102102'); return false;"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/btn_organizer.png" alt="Organizer" /></a></li>
						<li><a href="" onclick="goEventLink('73358'); return false;"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/btn_premium.png" alt="Premium" /></a></li>
					</ul>
				</section>

				<%' diary event  %>
				<section class="diaryEvent">
					<!-- #include virtual="/apps/appcom/wish/web2014/diarystory2017/inc/inc_event_main.asp" -->
				</section>
			</div>
			<%' //content area %>
			<!-- #include virtual="/apps/appcom/wish/web2014/lib/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<%
Set cDiary = Nothing
Set cDiaryE = Nothing
Set cDiarycnt = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->