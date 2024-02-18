<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/piece/piececls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<%
	'####################################################
	' Description : 안내 페이지
	' 				기존 페이지 소스는 ./index_back_20180719.asp
	' History : 2018-07-18 최종원
	'####################################################
	Dim logStore : logStore = requestCheckVar(Request("store"),16)

	If logStore <> "" And Len(logstore) = 1 Then '// log입력
		sqlStr = " insert into db_temp.dbo.tbl_log_appdown_store (store) values ('"&logStore&"')"
		dbget.Execute sqlStr
	End If 	

%>
<title>10x10: PIECE</title>
<script type="text/javascript">
var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipad')) { //아이패드
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipod')) { //아이팟
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('android')) { //안드로이드 기기
		window.parent.top.document.location= 'market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>%5F<%=logStore%>';
	} else { //그 외
		window.parent.top.document.location= 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>%5F<%=logStore%>';
	}
};
$(function(){
	$(".play-introduce").addClass("animation");

	var guideSwiper = new Swiper(".lets-play .swiper-container", {
		autoplay:3000,
		autoplayDisableOnInteraction:false,
		speed:800,
		pagination:".lets-play .pagination",
		paginationClickable:true,
		nextButton:'.lets-play .btnNext',
		prevButton:'.lets-play .btnPrev',
		scrollbar:'.swiper-scrollbar',
		scrollbarHide:false,
		parallax:true
	});
});
</script>
</head>
<body class="default-font body-main play-renewal">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<div id="content" class="content">
		<div class="play-introduce">
			<i></i>
			<h2><img src="http://fiximage.10x10.co.kr/m/2018/play/logo_play_v4.png" alt="PLAY" /></h2>
			<p><span>즐/거/운/쇼핑</span>을 위한 콜라보</p>
			<div>텐바이텐의 상품 추천 서비스 ‘조각’과<br />즐거운 감성 컨텐츠 ‘플레잉’이 만나<br />보고 듣고 즐기며 쇼핑하는<br />쇼핑 플레이리스트 <span>‘PLAY’</span>로 재탄생했습니다.</div>
		</div>
		<div class="lets-play">
			<h3>Let's PLAY</h3>
			<div class="swiper-container">
				<ul class="swiper-wrapper">
					<li class="swiper-slide"><div><strong data-swiper-parallax="-300">텐바이텐의 숨은<br />마스터피스를 소개해드립니다.</strong><img src="http://fiximage.10x10.co.kr/m/2018/play/img_intro_slide1_v2.png" alt="" /></div></li>
					<li class="swiper-slide"><div><strong data-swiper-parallax="-300">보고, 듣고, 즐기는<br />다양한 쇼핑 컨텐츠를 제공합니다.</strong><img src="http://fiximage.10x10.co.kr/m/2018/play/img_intro_slide2.png" alt="" /></div></li>
					<li class="swiper-slide"><div><strong data-swiper-parallax="-300">한정 뱃지, 한정 굿즈 등<br />PLAY만의 상품을 판매합니다.</strong><img src="http://fiximage.10x10.co.kr/m/2018/play/img_intro_slide3.png" alt="" /></div></li>
 				</ul>
				<div class="swiper-scrollbar"></div>
				<button type="button" class="slideNav btnPrev">이전</button>
				<button type="button" class="slideNav btnNext">다음</button>
			</div>
			<div class="greeting-msg">APP 업데이트 하고<br /><span>새로워진 플레이</span>를 만나세요!</div>
		</div>
		<% if (flgDevice="I") then %>
		<div class="app-update"><button type="button" class="btn-update" onclick=gotoDownload(); return false;><span>텐바이텐 APP 업데이트</span></button></div>
		<% elseif (flgDevice="A") then %>
		<div class="app-update"><div class="txt-standby"><span>Android 올 하반기 오픈 예정</span></div></div>
		<% else %>
		<div class="app-update"><button type="button" class="btn-update" onclick=gotoDownload(); return false;><span>텐바이텐 APP 업데이트</span></button></div>
		<% end if %>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->