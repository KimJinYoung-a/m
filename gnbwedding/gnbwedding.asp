<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
Dim yyyy, mm, dd, ix, userid

yyyy=year(now())
userid = getloginuserid()

Function ZeroTime(hs)
	If hs<10 Then
		ZeroTime="0"+hs
	Else
		ZeroTime=hs
	End If
End Function

Dim sqlStr, UserName, Sex, PartnerName, WeddingDate, SMS, Email, DateArr, Dday, mode
sqlStr = "SELECT top 1 UserName, Sex, PartnerName, WeddingDate, SMS, Email FROM [db_sitemaster].[dbo].[tbl_wedding_user_info] WHERE isusing='Y' and userid='"&userid&"'"
rsget.CursorLocation = adUseClient
rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	UserName = rsget("UserName")
	Sex  = rsget("Sex")
	PartnerName = rsget("PartnerName")
	WeddingDate = rsget("WeddingDate")
	SMS = rsget("SMS")
	Email = rsget("Email")
	mode="edit"
Else
	Sex="F"
	WeddingDate=yyyy&"-01-01"
	SMS="Y"
	Email ="Y"
	mode="add"
End IF
rsget.close

DateArr = split(WeddingDate,"-")
Dday = DateDiff("D",Now(),WeddingDate)
%>
<link rel="stylesheet" type="text/css" href="/lib/css/wedding2018.css?v=1.69" />
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script type="text/javascript">
$(function () {

	fnApplyItemInfoList({
		items:"1929160, 1916509, 1926966",
		target:"kit-list",
		fields:["sale","price"],
		unit:"ew"
	});

	mySwiper = new Swiper(".shp-list .swiper-container",{
		loop:true,
		autoplay:false,
		speed:600,
		pagination:".shp-list .pagination",
		prevButton:'.shp-list .btnPrev',
		nextButton:'.shp-list .btnNext',
		paginationClickable:true,
		effect:"slide",
		slidesPerView:'auto',
		centeredSlides: true,
		onSlideChangeStart: function (mySwiper) {
			$('.d-day-wrap s').removeClass('slideLeft2');
			var actSlide = $('.swiper-slide-active');
			$('.d-day-wrap > div').hide();
			if(actSlide.hasClass('d100')) {
				$('.d-day-wrap .d100').show();
			}
			if(actSlide.hasClass('d60')) {
				$('.d-day-wrap .d60').show();
			}
			if(actSlide.hasClass('d30')) {
				$('.d-day-wrap .d30').show();
			}
			if(actSlide.hasClass('d15')) {
				$('.d-day-wrap .d15').show();
			}
			if(actSlide.hasClass('d10')) {
				$('.d-day-wrap .d10').show();
			}
			if((mySwiper.previousIndex - mySwiper.activeIndex) > 0){
				$('.d-day-wrap s').addClass('reverse');
				$('.d-day-wrap s').addClass('slideLeft');
			}
			if((mySwiper.previousIndex - mySwiper.activeIndex) < 0){
				$('.d-day-wrap s').removeClass('reverse');
				$('.d-day-wrap s').addClass('slideLeft');
			}
		},
		onSlideChangeEnd: function (mySwiper) {
			$('.d-day-wrap s').removeClass('slideLeft');
		}
	});
	$('.d-day-wrap s').addClass('slideLeft2');

	// more클릭시하단탭선택
	$('.shp-list .more a').click(function(){
		$('.wed-nav-more li').removeClass('on')
		var more = $(this).attr('href');
		$('.wed-nav-more').find(more).addClass('on');
	});

	// 효과
	$('.wd-day').addClass("slideUp");
	$(window).scroll(function() {
		var wdhead = $(".wed-head").offset().top + 200;
		var y = $(window).scrollTop();
		if ( y < wdhead ) {
			$('.wd-day').addClass("slideUp");
			$('.wd-day').removeClass("slideDown2");
		}
		else {
			$('.wd-day').addClass("slideDown2");
			$('.wd-day').removeClass("slideUp");
		}
	});
	$('.kit ul li').css({"opacity":"0","z-index":"100"});
	$(window).scroll(function() {
		var h = $(window).height();
		var scrollY = $(window).scrollTop();
		$('.kit ul li').each(function(){
			var kitPosition = $(this).offset().top + 100;
			if (scrollY > kitPosition - h){
				$(this).addClass('slideDown');
			}
		});
	});
	fnEvtItemList(85159,240250,'tab1');
	$('.d-day-wrap s').addClass('slideLeft2');
});
function fnWeddingInfoSet(){
	winwedding = window.open('/wedding/wedding_info_reg.asp','winwedding','scrollbars=yes')
	winwedding.focus();
}

function fnEvtItemList(ecode, gcode, menuid){
	$.ajax({
		url: "act_evt_itemlist.asp?eventid="+ecode+"&eGC="+gcode,
		cache: false,
		success: function(message) {
			if(message!="") {
				//alert(message);
				$("#tab1").removeClass("on");
				$("#tab2").removeClass("on");
				$("#tab3").removeClass("on");
				$("#tab4").removeClass("on");
				$("#tab5").removeClass("on");
				$("#"+menuid).addClass("on");
				$("#evtPdtListWrapV15").empty().append(message);
				vScrl=true;
			} else {
			}
		}
		,error: function(err) {
			alert(err.responseText);
			$(window).unbind("scroll");
		}
	});
}

function fnEvtItemList2(ecode, gcode, menuid){
	$.ajax({
		url: "act_evt_itemlist.asp?eventid="+ecode+"&eGC="+gcode,
		cache: false,
		success: function(message) {
			if(message!="") {
				//alert(message);
				$("#tab1").removeClass("on");
				$("#tab2").removeClass("on");
				$("#tab3").removeClass("on");
				$("#tab4").removeClass("on");
				$("#tab5").removeClass("on");
				$("#"+menuid).addClass("on");
				window.scrollTo(0,$(".wed-nav-more").offset().top);
				$("#evtPdtListWrapV15").empty().append(message);
				vScrl=true;
			} else {
			}
		}
		,error: function(err) {
			alert(err.responseText);
			$(window).unbind("scroll");
		}
	});
}

function goGroupSelect(v,a){
	$('html, body').animate({
	    scrollTop: $("#groupBar"+v+"").offset().top
	}, 300)

	$("#groupBar"+a+" > option[value="+a+"]").attr("selected", "true");
}

function fnWeddingEventView(){
	winwedding2 = window.open('/wedding/pop_wd_event.asp','winwedding2','scrollbars=yes')
	winwedding2.focus();
}
</script>
</head>
<body class="default-font body-main">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->

	<!-- contents -->
	<div id="content" class="content wedding2018" >
		<div class="wed-head">
			<h2><img src="http://fiximage.10x10.co.kr/m/2018/wedding2018/tit_wedding.jpg?v=1.1" alt="상견례 예비 신랑, 신부와 양가 가족이 공식적으로 만나 인사를 나누고 혼인 절차를 의논하는 자리에요.긴장되는 자리인 만큼 미리미리 준비하는 게 좋겠죠?" usemap="#map-d100-2" /></h2>
			<% If UserName="" Then %>
				<% If userid<>"" Then %>
				<button class="wd-day" onclick="fnWeddingInfoSet();return false;">나의 웨딩일<em>등록하기</em></button>
				<% Else %>
				<button class="wd-day" onclick="jsChklogin_mobile('','<%=Server.URLencode("/wedding")%>')">나의 웨딩일<em>등록하기</em></button>
				<% End If %>
			<% Else %>
				<div class="wd-day my-wd-day" onclick="fnWeddingInfoSet();return false;">웨딩일까지<span>D-<%=Dday%></span></div>
			<% End If %>
		</div>

		<!-- 웨딩쇼핑리스트 -->
		<div class="shp-list">
			<div class="d-day-wrap">
				<div class="d100" id="d100">
					<span>웨딩의 설레는 첫 걸음</span>
					<p class="d-day"><i></i>D-100</a></p>
				</div>
				<div class="d60">
					<span>차근차근 본격적인 준비!</span>
					<p class="d-day"><i></i>D-60</p>
				</div>
				<div class="d30">
					<span>완벽한 결혼을 위한 점검</span>
					<p class="d-day"><i></i>D-30</p>
				</div>
				<div class="d15">
					<span>꼼꼼한 마무리로 준비 끝!</span>
					<p class="d-day"><i></i>D-15</p>
				</div>
				<div class="d10">
					<span>예식 후 잊지 말아야할 일!</span>
					<p class="d-day"><i></i>D+10</p>
				</div>
				<s></s>
			</div>
			<div class="swiper">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide d100">
							<div class="tumb"><a href="/category/category_itemPrd.asp?itemid=1714877&pEtr=85159" onclick="TnGotoProduct('1714877');return false;"><img src="http://fiximage.10x10.co.kr/m/2018/wedding2018/img_d100_1.jpg" alt="" /></a></div>
							<div class="info">
								<p class="step">상견례</p>
								<p>예비 신랑, 신부와 양가가 공식적으로 만나 인사를 나누고 혼인 절차를 의논하는 자리에요. 긴장되는 자리인 만큼 미리미리 준비하는 게 좋겠죠?</p>
							</div>
							<div class="more"><a href="javascript:fnEvtItemList2(85159,240250,'tab1');">D-100 쇼핑리스트 더보기</a></div>
						</div>
						<div class="swiper-slide d60">
							<div class="tumb"><a href="/category/category_itemPrd.asp?itemid=1923631&pEtr=85159" onclick="TnGotoProduct('1923631');return false;"><img src="http://fiximage.10x10.co.kr/m/2018/wedding2018/img_d60_1.jpg" alt="" /></a></div>
							<div class="info">
								<p class="step">혼수 가구 준비</p>
								<p>신혼집이 정해졌다면, 큰 가구부터 준비하는 것이 좋아요. 집의 크기와 예산, 서로의 취향에 맞춰 충분히 의논하고 따져본 후 선택 하세요!</p>
							</div>
							<div class="more"><a href="javascript:fnEvtItemList2(85159,240256,'tab2');">D-60 쇼핑리스트 더보기</a></div>
						</div>
						<div class="swiper-slide d60">
							<div class="tumb"><a href="/category/category_itemPrd.asp?itemid=1880224&pEtr=85159" onclick="TnGotoProduct('1880224');return false;"><img src="http://fiximage.10x10.co.kr/m/2018/wedding2018/img_d60_2.jpg" alt="" /></a></div>
							<div class="info">
								<p class="step">혼수 가전 준비</p>
								<p> 기능뿐 아니라, 디자인까지 잡은 가전이 많아져 고르는 즐거움도 2배! 가격대가 워낙 다양하니, 기능과 디자인을 잘 고려해서 마련하세요!</p>
							</div>
							<div class="more"><a href="javascript:fnEvtItemList2(85159,240256,'tab2');">D-60 쇼핑리스트 더보기</a></div>
						</div>
						<div class="swiper-slide d60">
							<div class="tumb"><a href="/category/category_itemPrd.asp?itemid=1807390&pEtr=85159" onclick="TnGotoProduct('1807390');return false;"><img src="http://fiximage.10x10.co.kr/m/2018/wedding2018/img_d60_3.jpg" alt="" /></a></div>
							<div class="info">
								<p class="step">웨딩 촬영</p>
								<p>둘만의 특별한 컨셉이 담긴 웨딩 사진을 꿈꾸시나요? 셀프 웨딩을 위한 상품부터, 사진을 특별하게 해줄 센스있는 소품까지!</p>
							</div>
							<div class="more"><a href="javascript:fnEvtItemList2(85159,240256,'tab2');">D-60 쇼핑리스트 더보기</a></div>
						</div>
						<div class="swiper-slide d30">
							<div class="tumb"><a href="/category/category_itemPrd.asp?itemid=1902447&pEtr=85159" onclick="TnGotoProduct('1902447');return false;"><img src="http://fiximage.10x10.co.kr/m/2018/wedding2018/img_d30_1.jpg" alt="" /></a></div>
							<div class="info">
								<p class="step">리빙 아이템 준비</p>
								<p>큰 가구와 가전이 준비되었다면, 어울리는 리빙 아이템들을 채워 넣을 차례에요. 필요한 아이템은 리스트를 작성해야 당황하지 않을 거예요!</p>
							</div>
							<div class="more"><a href="javascript:fnEvtItemList2(85159,240262,'tab3');">D-30 쇼핑리스트 더보기</a></div>
						</div>
						<div class="swiper-slide d30">
							<div class="tumb"><a href="/category/category_itemPrd.asp?itemid=1599159&pEtr=85159" onclick="TnGotoProduct('1599159');return false;"><img src="http://fiximage.10x10.co.kr/m/2018/wedding2018/img_d30_2.jpg" alt="" /></a></div>
							<div class="info">
								<p class="step">브라이덜 샤워</p>
								<p>많은 신부님들의 로망이라는 브라이덜 샤워! 친구들과의 잊지 못할 추억과 함께, 인생샷도 꼭 남겨야겠죠?</p>
							</div>
							<div class="more"><a href="javascript:fnEvtItemList2(85159,240268,'tab3');">D-30 쇼핑리스트 더보기</a></div>
						</div>
						<div class="swiper-slide d15">
							<div class="tumb"><a href="/category/category_itemPrd.asp?itemid=1681899&pEtr=85159" onclick="TnGotoProduct('1681899');return false;"><img src="http://fiximage.10x10.co.kr/m/2018/wedding2018/img_d15_1.jpg" alt="" /></a></div>
							<div class="info">
								<p class="step">신혼여행 짐싸기</p>
								<p>생각만 해도 설레는 신혼여행! 급하게 싸다보면 어찌나 필요한게 많은지, 미리 준비해야 후회하지 않아요.<br/ > 여권, 비자, 환전도 꼭 확인하세요!</p>
							</div>
							<div class="more"><a href="javascript:fnEvtItemList2(85159,240268,'tab4');">D-15 쇼핑리스트 더보기</a></div>
						</div>
						<div class="swiper-slide d10">
							<div class="tumb"><a href="/category/category_itemPrd.asp?itemid=1808742&pEtr=85159" onclick="TnGotoProduct('1808742');return false;"><img src="http://fiximage.10x10.co.kr/m/2018/wedding2018/img_d10_1.jpg" alt="" /></a></div>
							<div class="info">
								<p class="step">집들이</p>
								<p>양가가족, 지인들을 초대해서 감사의 인사를 전해보세요. 오시는 분들의 취향에 맞춰 준비하면 더욱 좋겠죠?</p>
							</div>
							<div class="more"><a href="javascript:fnEvtItemList2(85159,240276,'tab5');">D+10 쇼핑리스트 더보기</a></div>
						</div>
					</div>
				</div>
			<!-- <div class="pagination"></div> -->
			<button type="button" class="btnNav btnPrev">이전</button>
			<button type="button" class="btnNav btnNext">다음</button>
			</div>
		</div>
		<!--// 웨딩쇼핑리스트 -->

		<!-- 웨딩체크리스트 다운로드 -->
		<button class="btn-chck-list" onclick="javascript:fileDownload(4375);">
			<span>Wedding <i></i> Checklist</span>
			<s>다운받기</s>
		</button>
		<!--// 웨딩체크리스트 다운로드 -->

		<!-- 웨딩기획전 -->
		<div class="wed-evt">
			<ul>
				<li>
					<a href="/event/eventmain.asp?eventid=85088" onclick="jsEventlinkURL(85088);return false;">
						<div class="tumb"><img src="http://fiximage.10x10.co.kr/m/2018/wedding2018/img_evt_1.jpg?v=1.1" alt="" /></div>
						<p class="evt-tit"><em>호텔을 닮은 신혼집, Sweet Room</em><em class="sale"> ~64%</em></p>
						<p>고급미 넘치는 호텔 무드로 신혼집 꾸미기</p>
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=85045" onclick="jsEventlinkURL(85045);return false;">
						<div class="tumb"><img src="http://fiximage.10x10.co.kr/m/2018/wedding2018/img_evt_2.jpg" alt="" /></div>
						<p class="evt-tit"><em>JUST WHITE</em><em class="sale"> ~83%</em></p>
						<p>화이트 컬러를 집 안에 활용하는 5가지 방법</p>
					</a>
				</li>
			</ul>
			<div class="more"><a href="javascript:fnWeddingEventView();">웨딩 기획전 전체 보기</a></div>
		</div>
		<!--// 웨딩기획전 -->

		<!-- 웨딩키트 -->
		<div class="kit">
			<div class="kit-head">
				<p>오직 텐텐에서만 만날 수 있는</p>
				<h3>Wedding Set</h3>
				<i></i>
			</div>
			<ul id="kit-list">
				<li>
					<a href="/category/category_itemPrd.asp?itemid=1929160&pEtr=85159" onclick="TnGotoProduct('1929160');return false;">
						<div class="info">
							<p class="tag">화장대 / 서랍장 / 침대 / 매트리스</p>
							<p class="name">Wedding Shoes Set</p>
							<p class="price">1,229,500won <span>51%</span></p>
						</div>
						<div class="tumb"><img src="http://fiximage.10x10.co.kr/m/2018/wedding2018/img_set_1.jpg" alt="" /></div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=1916509&pEtr=85159" onclick="TnGotoProduct('1916509');return false;">
						<div class="info">
							<p class="tag">사각 접시 소&대 / 손잡이 소스볼 / 테이블매트</p>
							<p class="name">Couple Brunch Set</p>
							<p class="price">할인가 <span>할인율</span></p>
						</div>
						<div class="tumb"><img src="http://fiximage.10x10.co.kr/m/2018/wedding2018/img_set_2.jpg" alt="" /></div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=1926966&pEtr=85159" onclick="TnGotoProduct('1926966');return false;">
						<div class="info">
							<p class="tag">침대 / 화장대set / 서랍장 / 미니 캐비넷</p>
							<p class="name">New Retro Bedroom Set</p>
							<p class="price">할인가 <span>할인율</span></p>
						</div>
						<div class="tumb"><img src="http://fiximage.10x10.co.kr/m/2018/wedding2018/img_set_3.jpg" alt="" /></div>
					</a>
				</li>
			</ul>
			<div class="more"><a href="/event/eventmain.asp?eventid=85324" onclick="jsEventlinkURL(85324);return false;" class="">심플 웨딩 세트 전체 보기</a></div>
		</div>
		<!--// 웨딩키트 -->

		<!-- 하단탭 -->
		<div class="wed-nav-more">
			<ul>
				<li class="on" id="tab1"><a href="javascript:fnEvtItemList(85159,240250,'tab1');">D-100</a></li>
				<li id="tab2"><a href="javascript:fnEvtItemList(85159,240256,'tab2');">D-60</a></li>
				<li id="tab3"><a href="javascript:fnEvtItemList(85159,240262,'tab3');">D-30</a></li>
				<li id="tab4"><a href="javascript:fnEvtItemList(85159,240268,'tab4');">D-15</a></li>
				<li id="tab5"><a href="javascript:fnEvtItemList(85159,240276,'tab5');">D+10</a></li>
			</ul>
		</div>
		<!--// 하단탭 -->
	</div>
	<div id="evtPdtListWrapV15">
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->