<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/inc/incForceSSL_Test.asp" -->
<!-- #include virtual="/lib/inc/incCheckCookieEnabled.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
	'// pc일경우 m -> pc 리다이렉트
	Dim redirect_url : redirect_url = fnRedirectToPc()
	If redirect_url <> "" Then
		dbget.close()
		Response.redirect redirect_url
		Response.end
	End If

	'Open Graph - head.asp에서 출력
	strOGMeta = strOGMeta & "<meta property=""og:title"" content=""텐바이텐 10X10: 감성채널 감성에너지"">" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:type"" content=""website"" />" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:url"" content=""http://m.10x10.co.kr/"" />" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:image"" content=""http://fiximage.10x10.co.kr/web2017/common/main_intro_20170918.jpg"">" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:description"" content=""생활감성채널 10x10(텐바이텐)은 디자인소품, 아이디어상품, 독특한 인테리어 및 패션 상품 등으로 고객에게 즐거운 경험을 주는 디자인전문 쇼핑몰 입니다."">" & vbCrLf

	'// 구글 ADS 스크립트 관련(2018.09.21 신규버전 추가)
	googleADSCRIPT = " <script> "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "   gtag('event', 'page_view', { "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'send_to': 'AW-851282978', "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'ecomm_pagetype': 'home', "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'ecomm_prodid': '', "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'ecomm_totalvalue': '' "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "   }); "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & " </script> "

	'# 현재 페이지명 접수
	dim nowViewPage
	nowViewPage = request.ServerVariables("SCRIPT_NAME")
	Dim strOGMeta		'RecoPick환경변수

	'/서버 주기적 업데이트 위한 공사중 처리 '2011.11.11 한용민 생성
	'/리뉴얼시 이전해 주시고 지우지 말아 주세요
	Call serverupdate_underconstruction()

	'// 사이트 공사중
	'Call Underconstruction()

	'// 로그인 유효기간 확인 및 처리
	Select Case lcase(Request.ServerVariables("URL"))
		Case "/_index.asp", "/index.asp"
			Call chk_ValidLogin()
	End Select

	'// 자동로그인 확인
	Call chk_AutoLogin()

	'####### .js 파일 연동시 사용 - CC_currentyyyymmdd=V_CURRENTYYYYMM 변수로 .js에서 해당 날짜 이미지/링크등 뿌려줌
	dim CC_currentyyyymmdd
	On Error Resume Next
	CC_currentyyyymmdd=request("yyyymmdd")
	On Error Goto 0
	if CC_currentyyyymmdd="" then CC_currentyyyymmdd = Left(now(),10)
	'#########################################################################

	'###### 제휴사 flag 관련 - 주문 저장시/회원가입시 제휴사 Flag 저장 ######
	dim irdsite20, arrRdSite, irdData
	irdsite20 = requestCheckVar(request("rdsite"),32)
	irdData = requestCheckVar(request("rddata"),100)	'기타 전송 데이터 (회원ID,이벤트 번호 등)
	'//파라메터가 겹쳐있는 경우 중복 제거
	if irdsite20<>"" then
		arrRdSite = split(irdsite20,",")
		irdsite20 = arrRdSite(0)
	end if

	if (irdsite20<>"") then
		if (request.cookies("rdsite")<>irdsite20) then
			response.cookies("rdsite").domain = "10x10.co.kr"
			if (left(irdsite20,7)<>"mobile_") then		''2015/05/22 추가 mobile_mobile_da CASE
				response.cookies("rdsite") = Left("mobile_"&trim(irdsite20),25)
			else
				response.cookies("rdsite") = Left(trim(irdsite20),32)
			end if
		end if
		if (request.cookies("rddata")<>irdData) then
			response.cookies("rddata") = irdData
		end if
	end if
	'#########################################################################

	Dim strPageKeyword
	'// 페이지 검색 키워드
	if strPageKeyword="" then
		strPageKeyword = "커플, 선물, 커플선물, 감성디자인, 디자인, 아이디어상품, 디자인용품, 판촉, 스타일, 10x10, 텐바이텐, 큐브"
	else
		strPageKeyword = "10x10, 텐바이텐, 감성, 디자인, " & strPageKeyword
	end If

	'################# Amplitude에 들어갈 Referer 값 정의 ###################
	Dim AmpliduteReferer
	AmpliduteReferer = Request.ServerVariables("HTTP_REFERER")
	If Trim(AmpliduteReferer) <> "" Then
		If Not(InStr(AmpliduteReferer, "10x10")>0) Then
			response.cookies("CheckReferer") = AmpliduteReferer
		End If
	End If
	'#########################################################################

	'//쿠폰북 쿠폰 totalcount
	Dim cntSqlstr , rsMem , cTotcnt : cTotcnt = 0
		cntSqlstr = "db_item.[dbo].[sp_Ten_couponshop_couponTotalCnt] "

	on Error Resume Next
	set rsMem = getDBCacheSQL(dbget, rsget, "todaycnt", cntSqlstr, 60*60)
	IF Not (rsMem.EOF OR rsMem.BOF) THEN
		cTotcnt = rsMem(0)
	END IF
	rsMem.close
	on Error Goto 0

	'//디즈니페어 기간중 홈을 디즈니로 변경(2018.03.10~11)
	If Now() >= "2018-03-10" And Now() < "2018-03-12" Then
		If Trim(session("chkDisneyHomeMove")) = "" Then
			response.redirect "/subgnb/gnbeventmain.asp?eventid=84780"
			response.End
		End If
	End If

	Dim couponBannerImage
	couponBannerImage = "http://imgstatic.10x10.co.kr/mobile/201812/2078/mkt_banner_2018122017115414629.jpg"

	'//모바일 고도화 A/B 테스트
	Dim mAbTestMobile
	If request.Cookies("mAbTest")="" Then
		mAbTestMobile = session.sessionid Mod 2
		response.Cookies("mAbTest") = mAbTestMobile
		response.Cookies("mAbTest").expires = DateAdd("ww",2,Now())
	Else
		mAbTestMobile = request.Cookies("mAbTest")
	End If

	'//크리테오에 보낼 md5 유저 이메일값
	If Trim(session("ssnuseremail")) <> "" Then
		CriteoUserMailMD5 = MD5(Trim(session("ssnuseremail")))
	Else
		CriteoUserMailMD5 = ""
	End If

	Dim mdpickUrl, saleUrl, newUrl, categoryUrl
    mdpickUrl = "/list/mdpick/md_summary2020.asp"
	saleUrl = "/list/sale/sale_summary2020.asp"
	newUrl = "/list/new/new_summary2020.asp"

	'######################### Biz ###############################
	Dim b2bCurrentPage : b2bCurrentPage = Request.ServerVariables("HTTP_URL")

	'// Biz User 여부
	Dim isBizUser : isBizUser = chkiif(GetLoginUserLevel="7" OR (GetLoginUserLevel="9" AND Session("ssnuserbizconfirm")="Y"), "Y", "N")
	'// index로 이동했다면 Biz모드 쿠키 만료시킴
	If b2bCurrentPage = "/" OR b2bCurrentPage = "/index.asp" Then
		response.Cookies("bizMode").domain = "10x10.co.kr"
		response.cookies("bizMode") = ""
		response.Cookies("bizMode").Expires = Date - 1

	'// b2b경로로 들어왔지만 쿠키가 없거나 값이 N이라면 Y값으로 쿠키 생성
	ElseIf LEFT(b2bCurrentPage, 4) = "/biz" And request.cookies("bizMode") <> "Y" Then
		Response.Cookies("bizMode").domain = "10x10.co.kr"
    	Response.Cookies("bizMode") = "Y"
	End If

	'// 현재 B2B모드인지 여부
	Dim bizCookie : bizCookie = request.cookies("bizMode")
	Dim isBizMode : isBizMode = (BizCookie="Y")
	'#############################################################
%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" />
<meta name="keywords" content="<%=strPageKeyword%>" />
<meta name="format-detection" content="telephone=no" />
<link rel="SHORTCUT ICON" href="/lib/ico/10x10_140616.ico" />
<link rel="apple-touch-icon" href="/lib/ico/10x10TouchIcon_150303.png" />
<% if strOGMeta<>"" then Response.Write strOGMeta %>
<%
	Select Case lcase(Request.ServerVariables("URL"))
		Case "/_index.asp", "/index.asp", "/category/category_itemprd.asp", "/event/eventmain.asp"
			Response.Write "<meta name=""apple-itunes-app"" content=""app-id=864817011, app-argument=tenwishapp://"" />"
	End Select
%>
<link rel="stylesheet" type="text/css" href="/lib/css/common.css?v=2.00" />
<link rel="stylesheet" type="text/css" href="/lib/css/main.css?v=2.10" />
<style type="text/css">
.tit01 {font-size:15px; color:#000; padding:0 0 0 8px; position:relative; font-weight:bold; letter-spacing:-0.05em; text-align:left;}
.tit01:before {content:''; position:absolute; left:0; top:0; width:3px; height:13px; background-color:#d60000;}
@media all and (min-width:480px){
	.tit01 {font-size:22px; padding:0 0 0 12px;}
	.tit01:before {width:4px; height:21px;}
}

.box2 {border:1px solid #bebebe; border-radius:3px; -webkit-border-radius:3px;}

ul.commonTabV16a {display:table; width:100% !important; height:3.9rem; border-bottom:1px solid #e4e4e4; background-color:#fff;}
.commonTabV16a li {display:table-cell; position:relative; height:100%; vertical-align:middle; text-align:center; font-size:1.3rem; color:#676767; letter-spacing:-0.025rem; white-space:nowrap; font-weight:600;}
.commonTabV16a li span {font-size:1rem;}
.commonTabV16a li.current {color:#ff3131;}
.commonTabV16a li.current:after {position:absolute; left:0; bottom:-1px; content:''; width:100%; height:3px; background-color:#ff3131;}

.policyList {margin-top:10px;}
.policyList li {border-top:1px solid #bebebe;}
.policyList li:first-child {border-top:0;}
.policyList li a {display:block; padding:16px 15px; font-size:13px; font-weight:bold; color:#000; background:url(http://fiximage.10x10.co.kr/m/2014/common/blt_arrow_btm.png) 95% center no-repeat; background-size:13px 6px;}
.policyCont section {padding:40px 5px; color:#666; font-size:11px; line-height:1.4;}
.policyCont section h3 {margin-bottom:24px; color:#ff3131; font-size:13px; font-weight:bold;}
.policyCont section h4 {margin-top:18px; font-weight:bold;}
.policyCont section ul.depth li {padding-left:8px;}
.policyCont .startDate {padding:20px 0 0 5px; border-top:1px solid #cbcbcb; font-size:12px; line-height:1.4; font-weight:bold;}
@media all and (min-width:480px){
	.policyList {margin-top:15px;}
	.policyList li a {padding:24px 23px; font-size:20px; background-size:20px 9px;}
	.policyCont section {padding:60px 7px; font-size:17px;}
	.policyCont section h3 {margin-bottom:36px; font-size:20px;}
	.policyCont section h4 {margin-top:27px;}
	.policyCont section ul.depth li {padding-left:12px;}
	.policyCont .startDate {padding:30px 0 0 7px; font-size:18px;}
}
#mdpickSwiperV2 {margin-top:4.05rem; padding-bottom:2.47rem;}
</style>
<script type="text/javascript">
    var isapp = '<%=isapp%>'
    var V_CURRENTYYYYMM = "<%= CC_currentyyyymmdd %>";
</script>
<!-- #INCLUDE Virtual="/lib/inc/incNaverOpenDate.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/incDaumOpenDate.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/incPopup.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/inccoochalayerOpen.asp" -->
<%
'###########################################################
' Description : Today Main (index)
' History : 2017-08-15 이종화 생성 - 모바일
'###########################################################
	'//요일
	Dim weekDate : weekDate = weekDayName(weekDay(now))
	Dim RvSelNum : RvSelNum = Session.SessionID Mod 2
%>
<title>10x10</title>
<style>[v-cloak] { display: none; }</style>
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="/lib/js/jquery.swiper-3.1.2.min.js"></script>
<script>
var chkSwiper=0, arrCancelP= new Array();

function rectPosition() {
	return;
}

$(function() {
    /* diary banner random */
    var image = new Array ();
    image[0] = "http://fiximage.10x10.co.kr/m/2021/diary/bnr_diary2022_03.png";
    image[1] = "http://fiximage.10x10.co.kr/m/2021/diary/bnr_diary2022_04.png";
    image[2] = "http://fiximage.10x10.co.kr/m/2021/diary/bnr_diary2022_01.png";
    var size = image.length
    var x = Math.floor(size*Math.random())
    $('#bnrdiaryrandom').attr('src',image[x]);

	/* category menu check */
	$(".menu-category").each(function(){
		var itemCheck = $(this).children("ul").children("li").length;
		if (itemCheck > 9) {
			$(".menu-category ul li:gt(7)").hide();
			$(".menu-category .btn-group").show();
		}
	});

	$(".menu-category .btn-open").on("click", function(){
		$(this).hide();
		$(".menu-category .btn-close").show();
		$(".menu-category ul li:gt(7)").fadeIn(100, function(){ $(this).show();});
	});

	$(".menu-category .btn-close").on("click", function(){
		$(this).hide();
		$(".menu-category .btn-open").show();
		$(".menu-category ul li:gt(7)").fadeOut(100, function(){ $(this).hide();});
	});

	setTimeout(function(){
		$("#hcp1").after($("#hcp2"));
		$("#hcp2").after($("#hcp3"));
	},500);

	fnAmplitudeEventAction("view_main","","","");

	<%'// Branch Init %>
	<% if application("Svr_Info")="staging" Then %>
		branch.init('key_test_ngVvbkkm1cLkcZTfE55Dshaexsgl87iz');
	<% elseIf application("Svr_Info")="Dev" Then %>
		branch.init('key_test_ngVvbkkm1cLkcZTfE55Dshaexsgl87iz');
	<% else %>
		branch.init('key_live_hpOucoij2aQek0GdzW9xFddbvukaW6le');
	<% end if %>
	branch.logEvent("view_main");
});
</script>
</head>
<body class="default-font body-main">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<% server.Execute("/chtml/main/loader/2017loader/main_popup.asp") %>
	<% '======================전면배너===============================================%>
	<!-- contents -->
	<div id="content" class="content">
		<main>
			<h1 class="hidden">투데이</h1>

			<%'// 메인롤링 %>
			<% server.Execute("/chtml/main/loader/2017loader/exc_mainRolling.asp") %>

			<%'<!-- 라운드 배너 -->	%>
			<% server.Execute("/chtml/main/loader/2017loader/round_bnr.asp") %>
			<%'<!-- 키워드 배너 -->	%>
			<%' server.Execute("/chtml/main/loader/2017loader/hotkey_bnr.asp") %>

			<%'!-- just one day --%>
			<% 'If Date() >= "2018-12-04" then %>
				<% server.Execute("/chtml/main/loader/2017loader/exc_just1day_2018_new.asp") %>
			<% 'else %>
				<% server.Execute("/chtml/main/loader/2017loader/exc_just1day_2018.asp") %>
			<% 'end if %>

			<%' 상단 기획전 배너 %>
			<% server.Execute("/chtml/main/loader/2017loader/main_top_event_banner.asp") %>

			<%' 다스배너 %>
            <% If now() >= #2022-02-02 23:59:59# Then %>
            <a href="/diarystory2022/index.asp?gaparam=today_banner" class="bnr_main_dr mWeb"><img src="http://fiximage.10x10.co.kr/m/2021/diary/bnr_diary2022_03.png" alt="다이어리스토리 메인으로 이동" id="bnrdiaryrandom"></a>
            <% else %>
            <a href="https://m.10x10.co.kr/common/news/news_view.asp?type=&idx=19266&page=1" class="bnr_main_dr mWeb"><img src="http://fiximage.10x10.co.kr/m/2021/banner/bnr_holiday2022.png" alt="2022년 설 배송안내로 이동"></a>
            <% end if %>

			<%'// 마케팅 배너 %>
			<div id="mktbanner" class="marketing-bnr" v-cloak>
				<main-banner v-for="item in items" :item="item" :key="item.poscode" v-if="item.poscode == 2078"></main-banner>
			</div>
			<%'// 공지사항 %>
			<% server.Execute("/chtml/main/loader/2017loader/main_notice_banner.asp") %>

			<%'// 메인 빅 이벤트 배너 %>
			<% server.Execute("/chtml/main/loader/2017loader/exc_mainBigEvent.asp") %>

			<%'!-- md's pick AType--%>
			<section id="mdpickSwiper" class="item-carousel md-pick" v-cloak>
				<div class="hgroup">
					<h2 class="headline headline-speech"><span lang="en">MD&#39;S PICK</span> <small>MD가 주목한 상품!</small></h2>
					<a href="<%=mdpickUrl%>" class="btn-more btn-arrow">더보기</a>
				</div>

				<div class="items type-multi-row swiper-container">
					<ul class="swiper-wrapper" v-for="item in items" :item="item" :key="item.id" v-if="item.gubun1">
						<li class="swiper-slide">
							<main-mdpick v-for="(sub,index) in item.gubun1" :sub="sub" :key="sub.id" v-if="index < 2"></main-mdpick>
						</li>
						<li class="swiper-slide">
							<main-mdpick v-for="(sub,index) in item.gubun1" :sub="sub" :key="sub.id" v-if="index > 1 && index < 4"></main-mdpick>
						</li>
						<li class="swiper-slide">
							<main-mdpick v-for="(sub,index) in item.gubun1" :sub="sub" :key="sub.id" v-if="index > 3 && index < 6"></main-mdpick>
						</li>
						<li class="swiper-slide">
							<main-mdpick v-for="(sub,index) in item.gubun1" :sub="sub" :key="sub.id" v-if="index > 5 && index < 8"></main-mdpick>
						</li>
						<li class="swiper-slide">
							<main-mdpick v-for="(sub,index) in item.gubun1" :sub="sub" :key="sub.id" v-if="index > 7 && index < 10"></main-mdpick>
						</li>
						<li class="swiper-slide">
							<main-mdpick v-for="(sub,index) in item.gubun1" :sub="sub" :key="sub.id" v-if="index > 9 && index < 12"></main-mdpick>
						</li>
						<li class="swiper-slide">
							<main-mdpick v-for="(sub,index) in item.gubun1" :sub="sub" :key="sub.id" v-if="index > 11 && index < 14"></main-mdpick>
						</li>
						<li class="swiper-slide">
							<main-mdpick v-for="(sub,index) in item.gubun1" :sub="sub" :key="sub.id" v-if="index == 14"></main-mdpick>
							<a href="/mdpicklist/?gaparam=today_mdpick_plus" title="md&#39;s pick 더 보러가기" class="btn-more">+45</a>
						</li>
					</ul>
				</div>
			</section>
			<%'!-- md's pick --%>

			<%'!-- 베스트 리뉴얼 페이지 --%>
			<section id="best-renewal" class="item-carousel best">
                <best-renewal :items="items" :update_text="update_text" ></best-renewal>
            </section>
			<%'!-- best --%>

			<%'=========specialbrand=========%>
			<% if date() <> Cdate("2019-12-16") then '스페셜브랜드 노출 제어%>
			<div id="specialBrand"></div>
			<% end if %>
			<%'=========specialbrand=========%>

			<%'// 이미지 C타입 %>
			<div id="imgbanC" class="gif-bnr" v-cloak>
				<main-banner v-for="item in items" :item="item" :key="item.poscode" v-if="item.poscode == 2081"></main-banner>
			</div>

			<!-- 기프트 배너 -->
			<div class="gift-bnr">
				<div class="giftcard">
					<a href="/giftcard/?gaparam=today_banner_giftcard">
						<span><img src="//fiximage.10x10.co.kr/m/2019/today/bg_giftcard.png" alt=""></span>
						<p class="txt">따사로운 마음을 전하는<strong>기프트카드 선물하기</strong></p>
					</a>
				</div>
				<!--<div class="giftwrap">
					<a href="/shoppingtoday/gift_recommend.asp?gaparam=today_banner_packaging">
						<span><img src="http://fiximage.10x10.co.kr/m/2018/today/bg_giftwrap.png" alt=""></span>
						<p class="txt">감사의 마음까지 함께 담은 <strong>선물포장 상품 보기</strong></p>
					</a>
				</div>-->
				<div class="giftwrap">
					<a href="/gift/gifttalk/">
						<span><img src="http://fiximage.10x10.co.kr/m/2018/today/bg_gifttalk.png" alt=""></span>
						<p class="txt">뭐 살까 고민 될 땐 <strong>선물의 참견으로</strong></p>
					</a>
				</div>
			</div>

			<%'!-- for you --%>
			<div class="for-you" id="foryou" v-cloak v-if="openlayer">
				<div v-for="item in items" :item="item" :key="item.id">
					<h2 class="headline headline-speech" v-once>
						<strong class="label label-color"><em class="color-blue">For You</em></strong>{{username}}님께 추천합니다!
					</h2>
					<div class="items">
						<ul>
	 						<cateitem-more v-for="sub in item.listitems" :sub="sub"></cateitem-more>
						</ul>
					</div>
				</div>
			</div>

			<%' 실시간 인기 검색어%>
			<% ''server.Execute("/chtml/main/loader/2017loader/realtime_keyword.asp") %>
			<%
			On Error resume Next ''2017/10/24 by eastone
			server.Execute("/chtml/main/html/realtime_keyword_mob.html")
			On Error Goto 0
			%>
			<%' 실시간 인기 검색어%>

			<%' new for you %>
			<%
			On Error resume Next '2019-05-28 최종원
			if IsUserLoginOK() then
				server.Execute("/chtml/main/loader/2017loader/foryou.asp")
			end if
			On Error Goto 0
			%>
			<%' new for you %>

			<%'투데이이벤트 1~3%>
			<section id="enjoyevent1" class="exhibition-list" v-cloak>
				<h2 class="hidden">기획전</h2>
				<div class="list-card type-align-left">
					<ul>
						<main-eventban v-for="item in items" :item="item" :key="item.id" v-if="item.id < 4"></main-eventban>
					</ul>
				</div>
			</section>

			<%'// 이미지 A타입 %>
			<section id="imgbanA" class="text-bnr" v-cloak>
				<img-banner v-for="item in items" :item="item" :key="item.poscode" v-if="item.poscode == 2079"></img-banner>
			</section>

			<%'//twinitems %>
			<div id="twinitems" class="items-single-bnr" v-cloak>
				<ul class="items" v-for="item in items" :item="item">
					<li>
						<a :href="item.l_itemurl" onclick="fnAmplitudeEventAction('click_maintwoproducts','index|itemid','A|item.l_itemid');">
							<span class="label label-triangle" v-if="item.l_newbest > 0"><em v-if="item.l_newbest == 1">NEW</em><em v-if="item.l_newbest == 2">BEST</em></span>
							<div class="thumbnail"><img :src="item.l_img" alt=""></div>
							<div class="desc">
								<b class="headline">{{item.l_maincopy}} <u>{{item.l_itemname}}</u></b>
								<span class="price"><b class="discount color-red" v-if="item.l_saleper">{{item.l_saleper}}</b> <b class="sum">{{item.l_price}}<span class="won">원</span></b></span>
							</div>
						</a>
					</li>
					<li>
						<a :href="item.r_itemurl" onclick="fnAmplitudeEventAction('click_maintwoproducts','index|itemid','B|item.r_itemid');">
							<span class="label label-triangle" v-if="item.r_newbest > 0"><em v-if="item.r_newbest == 1">NEW</em><em v-if="item.r_newbest == 2">BEST</em></span>
							<div class="thumbnail"><img :src="item.r_img" alt=""></div>
							<div class="desc">
								<b class="headline">{{item.r_maincopy}} <u>{{item.r_itemname}}</u></b>
								<span class="price"><b class="discount color-red" v-if="item.r_saleper">{{item.r_saleper}}</b> <b class="sum">{{item.r_price}}<span class="won">원</span></b></span>
							</div>
						</a>
					</li>
				</ul>
			</div>

			<%'!-- on sale --%>
			<section id="saleSwiper" class="item-carousel on-sale-items" v-cloak>
				<div class="hgroup">
					<h2 class="headline headline-speech"><span lang="en">ON SALE</span> <small>세일 상품 모두 모여라</small></h2>
					<a href="<%=saleUrl%>" class="btn-more btn-arrow">더보기</a>
				</div>
				<div class="items type-multi-row swiper-container">
				<ul class="swiper-wrapper" v-for="item in items" :item="item" :key="item.id" v-if="item.gubun4">
					<li class="swiper-slide">
						<main-sale v-for="(sub,index) in item.gubun4" :sub="sub" :key="sub.id" v-if="index < 2"></main-sale>
					</li>
					<li class="swiper-slide">
						<main-sale v-for="(sub,index) in item.gubun4" :sub="sub" :key="sub.id" v-if="index > 1 && index < 4"></main-sale>
					</li>
					<li class="swiper-slide">
						<main-sale v-for="(sub,index) in item.gubun4" :sub="sub" :key="sub.id" v-if="index > 3 && index < 6"></main-sale>
					</li>
					<li class="swiper-slide">
						<main-sale v-for="(sub,index) in item.gubun4" :sub="sub" :key="sub.id" v-if="index > 5 && index < 8"></main-sale>
					</li>
					<li class="swiper-slide">
						<main-sale v-for="(sub,index) in item.gubun4" :sub="sub" :key="sub.id" v-if="index > 7 && index < 10"></main-sale>
					</li>
					<li class="swiper-slide">
						<main-sale v-for="(sub,index) in item.gubun4" :sub="sub" :key="sub.id" v-if="index > 9 && index < 12"></main-sale>
					</li>
					<li class="swiper-slide">
						<main-sale v-for="(sub,index) in item.gubun4" :sub="sub" :key="sub.id" v-if="index > 11 && index < 14"></main-sale>
					</li>
					<li class="swiper-slide">
						<main-sale v-for="(sub,index) in item.gubun4" :sub="sub" :key="sub.id" v-if="index > 13 && index < 16"></main-sale>
					</li>
				</ul>
			</div>
			</section>

			<%'투데이이벤트 4~6 %>
			<section id="enjoyevent2" class="exhibition-list" v-cloak>
				<h2 class="hidden">기획전</h2>
				<div class="list-card type-align-left">
					<ul>
						<main-eventban v-for="item in items" :item="item" :key="item.id" v-if="item.id > 3 && item.id < 7"></main-eventban>
					</ul>
				</div>
			</section>

			<%'//today-keyword %>
			<div id="mainkeyword" v-cloak>
				<section class="hot-keyword" v-for="item in items" :item="item" :key="item.id" :style="{background:item.bgcolor}">
					<h2 class="headline">
						<span>HOT <em>KEYWORD <span class="vol">v.{{item.ver_no}}</span></em></span>
						<small><a :href="item.link">#{{item.maincopy}}</a></small>
					</h2>
					<ul>
						<li>
							<a :href="item.itemid1url" onclick="fnAmplitudeEventAction('click_mainhotkeyword','indexnumber|itemid','1|item.itemid_1');">
								<span class="label label-star" v-if="item.picknum == 1"><svg viewBox="0 0 45 45"><path fill="#000" fill-rule="evenodd" d="M22.5 41.73l-5.385 2.616-3.552-4.818-5.983-.187-.907-5.917-5.21-2.945 1.947-5.661-3.246-5.03L4.52 15.68l-.536-5.962 5.765-1.613 2.296-5.529 5.854 1.251L22.5 0l4.602 3.828 5.854-1.25 2.296 5.528 5.765 1.613-.536 5.962 4.355 4.107-3.246 5.03 1.948 5.66-5.211 2.946-.907 5.917-5.983.187-3.552 4.818z"/></svg><em>pick</em></span>
								<div class="thumbnail"><img :src="item.imgsrc1" alt="" /></div>
							</a>
						</li>
						<li>
							<a :href="item.itemid2url" onclick="fnAmplitudeEventAction('click_mainhotkeyword','indexnumber|itemid','2|item.itemid_2');">
								<span class="label label-star" v-if="item.picknum == 2"><svg viewBox="0 0 45 45"><path fill="#000" fill-rule="evenodd" d="M22.5 41.73l-5.385 2.616-3.552-4.818-5.983-.187-.907-5.917-5.21-2.945 1.947-5.661-3.246-5.03L4.52 15.68l-.536-5.962 5.765-1.613 2.296-5.529 5.854 1.251L22.5 0l4.602 3.828 5.854-1.25 2.296 5.528 5.765 1.613-.536 5.962 4.355 4.107-3.246 5.03 1.948 5.66-5.211 2.946-.907 5.917-5.983.187-3.552 4.818z"/></svg><em>pick</em></span>
								<div class="thumbnail"><img :src="item.imgsrc2" alt="" /></div>
							</a>
						</li>
						<li>
							<a :href="item.itemid3url" onclick="fnAmplitudeEventAction('click_mainhotkeyword','indexnumber|itemid','3|item.itemid_3');">
								<span class="label label-star" v-if="item.picknum == 3"><svg viewBox="0 0 45 45"><path fill="#000" fill-rule="evenodd" d="M22.5 41.73l-5.385 2.616-3.552-4.818-5.983-.187-.907-5.917-5.21-2.945 1.947-5.661-3.246-5.03L4.52 15.68l-.536-5.962 5.765-1.613 2.296-5.529 5.854 1.251L22.5 0l4.602 3.828 5.854-1.25 2.296 5.528 5.765 1.613-.536 5.962 4.355 4.107-3.246 5.03 1.948 5.66-5.211 2.946-.907 5.917-5.983.187-3.552 4.818z"/></svg><em>pick</em></span>
								<div class="thumbnail"><img :src="item.imgsrc3" alt="" /></div>
							</a>
						</li>
						<li>
							<a :href="item.itemid4url" onclick="fnAmplitudeEventAction('click_mainhotkeyword','indexnumber|itemid','4|item.itemid_4');">
								<span class="label label-star" v-if="item.picknum == 4"><svg viewBox="0 0 45 45"><path fill="#000" fill-rule="evenodd" d="M22.5 41.73l-5.385 2.616-3.552-4.818-5.983-.187-.907-5.917-5.21-2.945 1.947-5.661-3.246-5.03L4.52 15.68l-.536-5.962 5.765-1.613 2.296-5.529 5.854 1.251L22.5 0l4.602 3.828 5.854-1.25 2.296 5.528 5.765 1.613-.536 5.962 4.355 4.107-3.246 5.03 1.948 5.66-5.211 2.946-.907 5.917-5.983.187-3.552 4.818z"/></svg><em>pick</em></span>
								<div class="thumbnail"><img :src="item.imgsrc4" alt="" /></div>
							</a>
						</li>
					</ul>
				</section>
			</div>

			<%'!-- enjoy --%>
			<div id="enjoySwiper" v-cloak>
				<section class="item-carousel enjoy-items" v-for="item in items" :item="item" :key="item.id">
					<div class="hgroup">
						<h2 class="headline headline-speech"><span lang="en">ENJOY</span> <small>{{item.extitle1}}</small></h2>
						<a :href="item.link1" v-if="item.link1" class="btn-more btn-arrow">더보기</a>
					</div>

					<div class="swiper-container items type-box-grey">
						<ul class="swiper-wrapper">
							<main-itemlist v-for="(sub,index) in item.exhibition1" :sub="sub" :index="index" :key="sub.id"></main-itemlist>
						</ul>
					</div>
				</section>
			</div>

			<%'!-- brand banner --%>
			<section id="mainbrand" class="brand-bnr" v-cloak>
				<brand-banner v-for="item in items" :item="item"></brand-banner>
			</section>

			<!-- special brand (20190712) -->
			<div class="special-brand-bnr">
				<a href="/brand/">
					<img src="//fiximage.10x10.co.kr/m/2019/pb/bnr_special_brand.jpg" alt="" />
				</a>
			</div>

			<%'이미지 배너 B타입%>
			<section id="imgbanB" class="text-bnr" v-cloak>
				<img-banner v-for="item in items" :item="item" :key="item.poscode" v-if="item.poscode == 2080"></img-banner>
			</section>

			<%'투데이이벤트 7~9 %>
			<section id="enjoyevent3" class="exhibition-list" v-cloak>
				<h2 class="hidden">기획전</h2>
				<div class="list-card type-align-left">
					<ul>
						<main-eventban v-for="item in items" :item="item" :key="item.id" v-if="item.id > 6 && item.id < 10"></main-eventban>
					</ul>
				</div>
			</section>

			<%'!-- category --%>
			<section class="menu-category">
				<h2 class="hidden">카테고리</h2>
				<ul>
					<li><a href="/category/category_main2020.asp?disp=101" class="on"><span class="icon icon-category101"></span><span class="name">디자인문구</span></a></li>
					<li><a href="/category/category_main2020.asp?disp=102"><span class="icon icon-category102"></span><span class="name">디지털/핸드폰</span></a></li>
					<li><a href="/category/category_main2020.asp?disp=124"><span class="icon icon-category124"></span><span class="name">디자인가전</span></a></li>
					<li><a href="/category/category_main2020.asp?disp=121"><span class="icon icon-category121"></span><span class="name">가구/수납</span></a></li>
					<li><a href="/category/category_main2020.asp?disp=122"><span class="icon icon-category122"></span><span class="name">데코/조명</span></a></li>
					<li><a href="/category/category_main2020.asp?disp=120" class="on"><span class="icon icon-category120"></span><span class="name">패브릭/생활</span></a></li>
					<li><a href="/category/category_main2020.asp?disp=112"><span class="icon icon-category112"></span><span class="name">키친</span></a></li>
					<li><a href="/category/category_main2020.asp?disp=119"><span class="icon icon-category119"></span><span class="name">푸드</span></a></li>
					<li><a href="/category/category_main2020.asp?disp=117"><span class="icon icon-category117"></span><span class="name">패션의류</span></a></li>
					<li><a href="/category/category_main2020.asp?disp=116"><span class="icon icon-category116"></span><span class="name">패션잡화</span></a></li>
					<li><a href="/category/category_main2020.asp?disp=125"><span class="icon icon-category125"></span><span class="name">주얼리/시계</span></a></li>
					<li><a href="/category/category_main2020.asp?disp=118"><span class="icon icon-category118"></span><span class="name">뷰티</span></a></li>
					<li><a href="/category/category_main2020.asp?disp=104"><span class="icon icon-category104"></span><span class="name">토이/취미</span></a></li>
					<!--<li><a href="/category/category_main2020.asp?disp=115"><span class="icon icon-category115"></span><span class="name">베이비/키즈</span></a></li>-->
					<li><a href="/category/category_main2020.asp?disp=110"><span class="icon icon-category110"></span><span class="name">캣앤독</span></a></li>
					<li><a href="/category/category_main2020.asp?disp=103"><span class="icon icon-category103"></span><span class="name">캠핑</span></a></li>
				</ul>
				<div class="btn-group">
					<button type="button" class="btn-open">모든 카테고리<span class="icon icon-arrow">열기</span></button>
					<button type="button" class="btn-close">모든 카테고리<span class="icon icon-arrow">닫기</span></button>
				</div>
			</section>

			<%'-- new --%>
			<section id="newSwiper" class="item-carousel new-items" v-cloak>
				<div class="hgroup">
					<h2 class="headline headline-speech"><span lang="en">NEW</span> <small>방금 도착한 따끈한 신상!</small></h2>
					<a href="<%=newUrl%>" class="btn-more btn-arrow">더보기</a>
				</div>

				<div class="swiper-container items type-box-grey">
					<ul class="swiper-wrapper" v-for="item in items" :item="item" :key="item.id" v-if="item.gubun2">
						<main-itemlist v-for="(sub,index) in item.gubun2" :sub="sub" :index="index" :key="sub.id"></main-itemlist>
					</ul>
				</div>
			</section>

			<%'투데이이벤트 10~12 %>
			<section id="enjoyevent4" class="exhibition-list" v-cloak>
				<h2 class="hidden">기획전</h2>
				<div class="list-card type-align-left">
					<ul>
						<main-eventban v-for="item in items" :item="item" :key="item.id" v-if="item.id > 9 && item.id < 13"></main-eventban>
					</ul>
				</div>
			</section>
<%'//가이드배너 추가 위치 최종원 20180807%>
			<%'// guide %>
			<div id="guideList" class="marketing-bnr" v-cloak>
				<main-banner v-for="item in items" :item="item" :key="item.poscode" v-if="item.poscode == 2083"></main-banner>
			</div>
<%'//가이드배너 추가 위치 최종원 20180807%>

			<%'!-- diaryitems 2019 2019-07-24 주석 처리 2020 다이어리때 다시 사용 할 수 있음 --%>
			<%' server.Execute("/chtml/main/loader/2017loader/exc_diarystoryitems.asp") %>

			<%'링크%>
			<div class="menu-etc">
				<ul>
					<li><a href="/shoppingtoday/couponshop.asp?gaparam=today_menu_coupon"><span class="icon icon-coupon"></span><span class="name">쿠폰</span> <% If cTotcnt > 0 Then %><span class="badge"><%=cTotcnt%><%=chkiif(cTotcnt>99,"+","")%></span><% End If %></a></li>
					<li><a href="/gift/gifttalk/?gaparam=today_menu_gift?gaparam=today_menu_gift"><span class="icon icon-gift"></span><span class="name">기프트</span></a></li>
					<li><a href="/shoppingtoday/shoppingchance_allevent.asp?scTgb=planevt&gaparam=today_menu_salepromo"><span class="icon icon-exhibition"></span><span class="name">기획전</span></a></li>
					<li><a href="/shoppingtoday/shoppingchance_allevent.asp?scTgb=mktevt&gaparam=today_menu_event"><span class="icon icon-event"></span><span class="name">이벤트</span></a></li>
				</ul>
			</div>

			<%'// HCPlist %>
			<div id="HCPlist" class="contents-bnr" v-cloak>
				<div v-for="item in items" :item="item" :key="item.id" v-if="item.poscode == 2082">
					<section class="playing-bnr" v-if="item.cgubun == 3" id="hcp1">
						<hcp-list :item="item" v-if="item.cgubun == 3"></hcp-list>
					</section>
					<section class="hitchhiker-bnr" v-else-if="item.cgubun == 1" id="hcp2">
						<hcp-list :item="item" v-if="item.cgubun == 1"></hcp-list>
					</section>
					<section class="culture-bnr" v-else-if="item.cgubun == 2" id="hcp3">
						<hcp-list :item="item" v-if="item.cgubun == 2"></hcp-list>
						<div class="btn-group"><a href="/culturestation/index.asp?gaparam=today_HCP_c0" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> 더 많은 컬쳐스테이션</a></div>
					</section>
				</div>
			</div>

			<%'!-- tenten shipping --%>
			<div class="shipping-bnr">
				<a href="/search/search_product2020.asp?keyword=텐바이텐배송&gaparam=today_menu_delivery"><p>빛보다 빠른<br /> <em>텐텐배송 상품</em><span class="icon icon-car"></span></p></a>
			</div>

			<%'// Today 더보기 카테고리%>
			<div class="category-item-content bg-grey" id="todaymore" v-if="show" v-cloak>
				<section class="category-item-list" v-for="item in sliced" :item="item" :key="item.id" v-if="sliced" >
					<h2 class="headline"><span :class="item.cateclass"></span>{{item.catename}}</h2>

					<div class="items">
						<ul>
							<cateitem-more v-for="sub in item.cateitem" :sub="sub"></cateitem-more>
						</ul>
					</div>

					<section class="exhibition-list">
						<h3 class="hidden">디자인문구 기획전</h3>
						<div class="list-card type-align-left">
							<ul>
								<event-more v-for="sub in item.cateevent" :sub="sub"></event-more>
							</ul>
						</div>
					</section>

					<div class="btn-group"><a :href="item.cateurl" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> {{item.catename}} 더보기</a></div>
                </section>
			</div>
            <div class="category_banner">
                <a href="/diarystory2022/index.asp?gaparam=today_banner"><img src="http://fiximage.10x10.co.kr/m/2021/diary/bnr_big_diary2022_01.png" alt="2022 다이어리 준비하셨나요?"></a>
            </div>
		</main>
	</div>
	<!-- //contents -->
	<% if application("Svr_Info")="staging" Then %>
		<script type="text/javascript" src="/lib/js/amplitudestaging.js?v=1.02"></script>
	<% elseIf application("Svr_Info")="Dev" Then %>
		<script type="text/javascript" src="/lib/js/amplitudestaging.js?v=1.02"></script>
	<% else %>
		<script type="text/javascript" src="/lib/js/amplitude.js?v=1.02"></script>
	<% End If %>
	<script type="text/javascript" src="https://cdn.branch.io/branch-2.52.2.min.js"></script>
	<script src="/lib/js/common.js?v=<%= CC_currentyyyymmdd %>"></script>
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
	<div class="btnTouch">
		<% If Now() < #08/10/2017 23:59:59# Then %>
			<a href="/subgnb/gnbeventmain.asp?eventid=79495">여기를 터치하면<br /><b>'수능 100일'</b>로 이동합니다</a>
		<% End If %>
	</div>
<script type="text/javascript" src="/lib/js/js.cookie.min.js"></script>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/vue.min.js"></script>
<% End If %>
<script src="/vue/vuex.min.js"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/data-pipeline/pipeline.min.js"></script>
<% if date() <> Cdate("2019-12-16") then '스페셜브랜드 노출 제어%>
<script src="/vue/specialbrand/main-pb-itemlist.js?v=1.03"></script>
<% end if %>
<script type="text/javascript" src="/lib/js/iscroll.js"></script>
<script src="/vue/list/best/renewal/prd_item_today_best.js?v=1.00"></script>
<script src="/vue/components/product/prd_img.js?v=1.0"></script>
<script src="/vue/components/product/prd_price.js?v=1.0"></script>
<script src="/vue/components/product/prd_name.js?v=1.0"></script>

<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script src="/vue/today/store.js?v=1.0"></script>
<script src="/vue/today/index.js?v=1.0"></script>

<%' 크리테오 스크립트 설치 %>
<script type="text/javascript" src="//static.criteo.net/js/ld/ld.js" async="true"></script>
<script type="text/javascript">
window.criteo_q = window.criteo_q || [];
var deviceType = /iPad/.test(navigator.userAgent) ? "t" : /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "m" : "d";
window.criteo_q.push(
	{ event: "setAccount", account: 8262},
	{ event: "setEmail", email: "<%=CriteoUserMailMD5%>" },
	{ event: "setSiteType", type: deviceType},
	{ event: "viewHome"}
);
</script>
<%'// 크리테오 스크립트 설치 %>
<script type="text/javascript" src="/lib/js/fp.min.js?v=1.0"></script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
