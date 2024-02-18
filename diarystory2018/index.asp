<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리2018 M 메인
' History : 2017-09-26 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2018/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2018/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
dim GiftSu, i, weekDate, imglink, gnbflag

gnbflag = RequestCheckVar(request("gnbflag"),1)

If gnbflag = "" Then '//gnb 숨김 여부
	gnbflag = true 
Else 
	gnbflag = False
	strHeadTitleName = "2018 다이어리"
End if

weekDate = weekDayName(weekDay(now)) '// 요일 구하기 내장 함수
if date = "2017-12-25" then
	weekDate = "공휴일"
end if

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
	cDiaryE.Ftopcount = 4
else
	cDiaryE.Ftopcount = 3
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

'strHeadTitleName = "2018 다이어리"
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/diary2018.css" />
<script type="text/javascript">
$(function() {
	var swiper = new Swiper(".main-rolling .swiper-container", {
		pagination:".main-rolling .pagination",
		paginationClickable:true,
		paginationBulletRender: function (index, className) {
			return '<span class="' + className + '">' + (index + 1) + '</span>';
		},
		//autoplay:3000,
		loop:true,
		speed:600,
		nextButton:'.main-rolling .btn-next',
		prevButton:'.main-rolling .btn-prev'
	});
});

function searchlink(v){
	if (v == ""){
		document.location = "/<%=g_HomeFolder%>/list.asp?gnbflag=1";
	}else{
		document.location = "/<%=g_HomeFolder%>/list.asp?gnbflag=1&arrds=" + v + ",";
	}
}

// 이벤트 이동
function goEventLink(evt) {
	<% if isApp then %>
		fnAPPpopupEvent(evt);
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%> diary2018"><%' for dev msg : GNB메뉴에서 들어갈때만 body-main클래스가 붙습니다. 그 이외의 페이지에서는 body-sub가 붙습니다. %>
	<!-- #include virtual="/lib/inc/incHeader.asp" -->

	<!-- contents -->
	<div id="content" class="content diary-main">
		<h2 class="hidden">DIARYSTORY 2018</h2>

		<!-- main rolling -->
		<div class="main-rolling">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<%' 1+1, 1: 1배너 평일만 %>
					<% If weekDate <> "토요일" and weekDate <> "일요일" and weekDate <> "공휴일" Then %>
						<% if cDiary.ftotalcount > 0 then %>
							<div class="swiper-slide">
								<a href="" onclick="TnGotoProduct('<%=cDiary.FOneItem.FItemid%>'); return false;">
									<div class="thumbnail"><img src="http://<%= imglink %>.10x10.co.kr/diary/oneplusone/<%= cDiary.FOneItem.Fmimage1 %>" alt="<%= cDiary.FOneItem.Fitemname %>" /></div>
									<% If GiftSu > 0 Then %>
										<div class="label">
											<% if cDiary.FOneItem.fplustype="1" then %>
												<span class="plus">1+1</span>
											<% else %>
												<span class="colon">1:1</span>
											<% end if %>
											<span class="count"><em><%= GiftSu %>개</em><br/>남음</span>
										</div>
									<% end if %>
								</a>
							</div>
						<% end if %>
					<% end if %>

					<%' 일반 배너 %>
					<% if cDiaryE.FTotalCount > 0 then %>
						<% for i = 0 to cDiaryE.FTotalCount -1 %>
							<div class="swiper-slide">
								<a href="<%=cDiaryE.FItemList(i).Flinkpath%>">
									<div class="thumbnail"><img src="<%= cDiaryE.FItemList(i).GetImageUrl %>" alt="<%= cDiaryE.FItemList(i).Fitemname %>" /></div>
								</a>
							</div>
						<% next %>
					<% end if %>
				</div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="btn-prev"><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btn-next"><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/btn_next.png" alt="다음" /></button>
		</div>

		<!--<div class="diary-collabo"><a href="/diarystory2018/gift.asp?gnbflag=1"><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/bnr_gift_v3.jpg" alt="구매금액별 사은품 + 무료배송" /></a></div>-->

		<!-- md's pick -->
		<div class="category-item-content">
			<section class="category-item-list">
				<h3>MD'S PICK</h3>
				<div class="items">
					<ul>
						<!-- #include virtual="/diarystory2018/inc/inc_mdpick.asp" -->
					</ul>
				</div>
				<div class="btn-group">
					<a href="/diarystory2018/list.asp?gnbflag=1" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> 더 많은 다이어리</a>
				</div>
			</section>
		</div>

		<!-- search -->
		<div class="finder">
			<h3 class="hidden">DIARY SEARCH</h3>
			<ul>
				<li>
					<a href="" onclick="searchlink('10'); return false;">
						<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/img_search_simple_v2.jpg" alt="" /></div>
						<p>심플 다이어리 찾기<i></i></p>
					</a>
				</li>
				<li>
					<a href="" onclick="searchlink('20'); return false;">
						<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/img_search_illust_v2.jpg" alt="" /></div>
						<p>일러스트 다이어리 찾기<i></i></p>
					</a>
				</li>
				<li>
					<a href="" onclick="searchlink('30'); return false;">
						<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/img_search_pattern_v2.jpg" alt="" /></div>
						<p>패턴 다이어리 찾기<i></i></p>
					</a>
				</li>
				<li>
					<a href="" onclick="searchlink('40'); return false;">
						<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/img_search_photo_v2.jpg" alt="" /></div>
						<p>포토 다이어리 찾기<i></i></p>
					</a>
				</li>
			</ul>
		</div>

		<!-- event list -->
		<div class="event-list">
			<section id="exhibitionList" class="exhibition-list">
				<h3 class="hidden">EVENT LIST</h3>
				<div class="list-card type-align-left">
					<ul>
						<li class="ad-bnr"><a href="" onclick="goEventLink('83443'); return false;"><div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/bnr_calendar.jpg" alt="2018 CALENDAR" /></div></a></li>
						<!--<li class="ad-bnr"><a href="" onclick="goEventLink(''); return false;"><div class="thumbnail"><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/bnr2.jpg" alt="" /></div></a></li>-->
						<!-- #include virtual="/diarystory2018/inc/inc_event_main.asp" -->
					</ul>
				</div>
			</section>
			<div class="btn-group">
				<a href="/<%=g_HomeFolder%>/event.asp?gnbflag=1" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> 더 많은 다이어리 기획전</a>
			</div>
		</div>

		<!-- event banner -->
		<div class="event-bnr">
			<h3 class="hidden">EVENT BANNER</h3>
			<ul>
				<li class="event1"><a href="" onclick="goEventLink('80907'); return false;">THE PEN STORY</a></li>
				<li class="event2"><a href="" onclick="goEventLink('80912'); return false;">MOLESKINE</a></li>
				<li class="event3"><a href="" onclick="goEventLink('80908'); return false;">PLANNER</a></li>
				<li class="event4">
					<a href="/category/category_list.asp?disp=101103" class="mWeb">NOTE</a>
					<a href="#" onclick="fnAPPpopupCategory('101103'); return false;" class="mApp">NOTE</a>
				</li>
				<li class="event5"><a href="" onclick="goEventLink('80909'); return false;">DECO</a></li>
				<li class="event6">
					<a href="/category/category_list.asp?disp=101102102" class="mWeb">ORGANIZER</a>
					<a href="#" onclick="fnAPPpopupCategory('101102102'); return false;" class="mApp">ORGANIZER</a>
				</li>
				<li class="event7">
					<a href="/street/street_brand.asp?makerid=midori2">MIDORI</a>
					<a href="" onclick="fnAPPpopupBrand('midori2'); return false;">MIDORI</a>
				</li>
			</ul>
			<div><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/bnr_diary_event.jpg" alt="" /></div>
		</div>

		<!-- best diary -->
		<div class="best-diary">
			<div class="best-items-list">
				<h3>BEST DIARY</h3>
				<div class="items type-list tenten-best-default">
					<ul>
						<!-- #include virtual="/diarystory2018/inc/inc_best.asp" -->
					</ul>
				</div>
			</div>
			<div class="btn-group">
				<a href="/<%=g_HomeFolder%>/list.asp?srm=best&gnbflag=1" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> 더 많은 다이어리</a>
			</div>
		</div>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incfooter.asp" -->
</body>
</html>
<%
Set cDiary = Nothing
Set cDiaryE = Nothing
Set cDiarycnt = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->