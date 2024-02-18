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

If Dday < 1 Then
	If Dday = 0 Then
		Dday="D-day"
	Else
		Dday="D+" + Cstr(Dday*-1)
	End If
Else
	Dday="D-" + Cstr(Dday)
End If
%>
<link rel="stylesheet" type="text/css" href="/lib/css/wedding2018.css?v=1.72" />
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
		initialSlide:1,
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
	fnEvtItemList(85159,240256,'tab2');
	$('.d-day-wrap s').addClass('slideLeft2');
});
function fnWeddingInfoSet(){
	winwedding = window.open('/wedding/wedding_info_reg.asp','winwedding','scrollbars=yes')
	winwedding.focus();
}

function fnEvtItemList(ecode, gcode, menuid){
	$.ajax({
		url: "/wedding/act_evt_itemlist.asp?eventid="+ecode+"&eGC="+gcode,
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
			//alert(err.responseText);
			$(window).unbind("scroll");
		}
	});
}

function fnEvtItemList2(ecode, gcode, menuid){
	$.ajax({
		url: "/wedding/act_evt_itemlist.asp?eventid="+ecode+"&eGC="+gcode,
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
			//alert(err.responseText);
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
				<button class="wd-day" onclick="fnWeddingInfoSet();return false;">나의 웨딩일<em>등록하기</em><s>+Coupon</s></button>
				<% Else %>
				<button class="wd-day" onclick="jsChklogin_mobile('','<%=Server.URLencode("/wedding")%>')">나의 웨딩일<em>등록하기</em><s>+Coupon</s></button>
				<% End If %>
			<% Else %>
				<div class="wd-day my-wd-day" onclick="fnWeddingInfoSet();return false;">웨딩일까지<span><%=Dday%></span></div>
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
			<% server.Execute("/wedding/lib/shopping_list.asp") %>
		</div>
		<!--// 웨딩쇼핑리스트 -->

		<!-- 웨딩체크리스트 다운로드 -->
		<button class="btn-chck-list" onclick="javascript:fileDownload(4375);">
			<span>Wedding <i></i> Checklist</span>
			<s>다운받기</s>
		</button>
		<!--// 웨딩체크리스트 다운로드 -->

		<!-- 웨딩기획전 -->
		<% server.Execute("/wedding/lib/plan_event.asp") %>
		<!--// 웨딩기획전 -->

		<!-- 웨딩키트 -->
		<% server.Execute("/wedding/lib/wedding_kit.asp") %>
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