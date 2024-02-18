<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'###########################################################
' Description :  Today Main (index)
' History : 2017-05-29 이종화 생성 - 모바일
'###########################################################

    Dim C_WEBVIEWURL, C_WEBVIEWURL_SSL
    IF application("Svr_Info")="Dev" THEN
	    C_WEBVIEWURL = "http://testm.10x10.co.kr/apps/appcom/wish/web2014"
	    C_WEBVIEWURL_SSL = "http://testm.10x10.co.kr/apps/appcom/wish/web2014"
	Else
	    C_WEBVIEWURL = "http://m.10x10.co.kr/apps/appcom/wish/web2014"
	    C_WEBVIEWURL_SSL = "https://m.10x10.co.kr/apps/appcom/wish/web2014"
	End if

    '' 앱 구분 //2014/02/17
    Dim CGLBAppName
    CGLBAppName = "app_wish2"  ''/web2014 폴더 app_wish2
    uAgent = Lcase(Request.ServerVariables("HTTP_USER_AGENT"))
    if InStr(uAgent,"tencolorapp")>0 then
        CGLBAppName = "app_cal"
    end if

	'' iScroll Click옵션 여부 //2014.03.27
	dim vIsClick: vIsClick = false
	if instr(uAgent,"ipod")>0 or instr(uAgent,"iphone")>0 or instr(uAgent,"ipad")>0 then
		vIsClick = true
	elseif instr(uAgent,"android")>0 then
		dim vAdrVer: vAdrVer = mid(uAgent,instr(uAgent,"android")+8,3)
		if vAdrVer>="4.4" then
			vIsClick = true
		end if
	end if

	'//20180724 전면배너 버전 체크
	dim vAdrVer2
	vAdrVer2 = mid(uAgent,instr(uAgent,"tenapp")+8,5)
	Dim strPageTitle
	if strPageTitle="" then strPageTitle = "10X10"

	'###### 제휴사 flag 관련 - 주문 저장시/회원가입시  제휴사 Flag 저장 ######
	dim irdsite20, arrRdSite, irdData
	irdsite20 = request("rdsite")
	irdData = request("rddata")	'기타 전송 데이터 (회원ID,이벤트 번호 등)
	'//파라메터가 겹쳐있는 경우 중복 제거
	if irdsite20<>"" then
		arrRdSite = split(irdsite20,",")
		irdsite20 = arrRdSite(0)
	end if

	if (irdsite20<>"") then
		if (request.cookies("rdsite")<>irdsite20) then
			response.cookies("rdsite").domain = "10x10.co.kr"
			response.cookies("rdsite") = Left("mobile_"&trim(irdsite20),32)
		end if
		if (request.cookies("rddata")<>irdData) then
			response.cookies("rddata") = irdData
		end if
	end if
	'#########################################################################

	'//쿠폰북 쿠폰 totalcount
	Dim cntSqlstr , rsMem , cTotcnt : cTotcnt = 0
		cntSqlstr = "db_item.[dbo].[sp_Ten_couponshop_couponTotalCnt]"

	on Error Resume Next
	set rsMem = getDBCacheSQL(dbget, rsget, "todaycnt", cntSqlstr, 60*60)
	IF Not (rsMem.EOF OR rsMem.BOF) THEN
		cTotcnt = rsMem(0)
	END IF
	rsMem.close
	on Error Goto 0

	Dim RvSelNum : RvSelNum = Session.SessionID Mod 2
%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=5.0">
<meta name="format-detection" content="telephone=no" />
<title><%= strPageTitle %></title>
<link rel="stylesheet" type="text/css" href="/lib/css/common.css?v=1.74" />
<link rel="stylesheet" type="text/css" href="/lib/css/main.css?v=1.40" />
<link rel="stylesheet" type="text/css" href="/lib/css/app.css?v=1.20" />
<link rel="stylesheet" type="text/css" href="/lib/css/temp_a.css?v=1.05" />
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="/lib/js/jquery.swiper-3.1.2.min.js"></script>
<script>
var chkSwiper=0;
var arrCancelP= new Array();

function rectPosition(oSwp) {
	var recX1 = parseInt(window.innerWidth * 0.1);
	var recY1 = parseInt($(oSwp+' .swiper-container').offset().top);
	var recX2 = parseInt(window.innerWidth * 0.9);
	var recY2 = recY1+parseInt($(oSwp + ' .swiper-container').height());

	arrCancelP.push({"x1":recX1, "y1":recY1, "x2":recX2, "y2":recY2, "width":window.innerWidth});

	//console.log(recX1,recY1,recX2,recY2);

	<% if flgDevice="A" then %>
	fnSetSwipeCancelAreasAND(arrCancelP);	// 복수형
	<% end if %>
}

//SwipeCancelArea(복수)
function fnSetSwipeCancelAreasAND(vAreas){
    callNativeFunction('setSwipeCancelAreas', {'item':vAreas});
    return false;
}

$(function() {

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
	
	// 전면배너 20180724
<% if flgDevice="I" and vAdrVer2 >= "2.35" and Now() > #07/24/2018 00:00:00# AND Now() < #08/01/2018 23:59:59# then %>		
	var maskW = $(document).width();
	var maskH = $(document).height();
	$('#mask').css({'width':maskW,'height':maskH});		

	mainPopup();
	$('#mask').click(function(){
		$(".front-Bnr").hide();
		$('#mask').hide();
	});
	// setPopupCookie("todayPopupCookie", "done", -1)
	// mainPopUpCloseJustToday();
<% end if %>	
});

function mainPopup(){//팝업띄우기
	var popCookie = getPopupCookie("todayPopupCookie");
	if(!popCookie){
		$(".front-Bnr").show();
		$('#mask').show();						
	}
}

function mainPopUpClose(){
	$(".front-Bnr").hide();
	$('#mask').hide();	
}
function mainPopUpCloseJustToday(){	//오늘 그만보기
	setPopupCookie("todayPopupCookie", "done", 1)
	$(".front-Bnr").hide();
	$('#mask').hide();
}
function goPlay(callback){		
	var instance = {
		func0: function(){
			this.func1().func2();
		},
		func1: function(){
			mainPopUpClose();	
			return this;
		},
		func2: function(){
			fnAPPselectGNBMenu('PLAY','');
		}
	}
	instance.func0();
	// fnAPPselectGNBMenu('PLAY','');	
}

// 쿠키 가져오기  
function getPopupCookie( name ) {  
   var nameOfCookie = name + "=";  
   var x = 0;  
   while ( x <= document.cookie.length )  
   {  
       var y = (x+nameOfCookie.length);  
       if ( document.cookie.substring( x, y ) == nameOfCookie ) {  
           if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 )  
               endOfCookie = document.cookie.length;  
           return unescape( document.cookie.substring( y, endOfCookie ) );  
       }  
       x = document.cookie.indexOf( " ", x ) + 1;  
       if ( x == 0 )  
           break;  
   }  
   return "";  
}  
  
// 24시간 기준 쿠키 설정하기  
// expiredays 후의 클릭한 시간까지 쿠키 설정  
function setPopupCookie( name, value, expiredays ) {   
   var todayDate = new Date();   
   todayDate.setDate( todayDate.getDate() + expiredays );   
   document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"   
}  
<%
	'//구버전 height (리뉴얼 이후버전 2.0)
	if not((InStr(uAgent,"tenapp i2.")>0) or (InStr(uAgent,"tenapp a2.")>0)) then
%>
	$(function(){ $("body-main").css({"padding-top":"0"}); });
<%
	end if
%>
</script>
<style>
	[v-cloak] {display:none;}
	#mdpickSwiperV2 {margin-top:4.05rem; padding-bottom:2.47rem;}
</style>
</head>
<body class="default-font body-main">
<%'<!-- // 전면배너(2018/07/23) -->%>
<% if flgDevice="I" and vAdrVer2 >= "2.35" and Now() > #07/24/2018 00:00:00# AND Now() < #08/01/2018 23:59:59# then %>		
<style>
.mask {z-index:10; background-color:rgba(0,0,0,.85);}
.front-Bnr {position:fixed; left:50%; top:50%; z-index:99999; width:24.16rem; margin:-14.75rem 0 0 -12.08rem; display:none;}
.front-Bnr a {display:block; width:100%;}
.front-Bnr .btn-group {display:flex; position:absolute; bottom:-3.29rem; width:100%; height:3.29rem; background-color:#fff;}
.front-Bnr button {justify-content:flex-start; width:50%; border-right:solid 1px #383838; border-top:solid 1px #383838; color:#000; font-size:1.1rem; line-height:3.3rem; font-weight:bold; background-color:transparent;}
.front-Bnr .btn-close {border-right:0;}
</style>
	<div class="front-Bnr">
		<a href="javascript:void(0);" onclick="goPlay();">
			<img src="http://webimage.10x10.co.kr/eventIMG/2018/87941/m/bnr_front_v3.png" alt="조각과 플레잉의 play 보고, 듣고, 즐기며 쇼핑하세요! play 구경하러가기" />
		</a>
		<div class="btn-group">
			<button type="button" onclick="mainPopUpCloseJustToday();" class="btn-anymore">오늘 그만 보기</button>
			<button type="button" onclick="mainPopUpClose();" class="btn-close">닫기</button>
		</div>
	</div>
	<div class="mask" id="mask"></div>
<%'<!-- // 전면배너(2018/07/23) -->%>
<% end if %>
<div id="content" class="content">
	<main>
		<h1 class="hidden">투데이</h1>

		<%'// 메인롤링 %>
		<% server.Execute("/chtml/main/loader/2017loader/exc_mainRolling.asp") %>

		<% ' 기존 best에 있던 .. 부분 %>
		<% if (GetLoginUserID="icommang") Or (GetLoginUserID="10x10green") Or (GetLoginUserID="thensi7") Or (GetLoginUserID="tozzinet") Or (GetLoginUserID="motions") Or (GetLoginUserID="qpark99") Or (GetLoginUserID="happyngirl") Or (GetLoginUserID="kobula") Or (GetLoginUserID="greenteenz") Or (GetLoginUserID="kyungae13") Or (GetLoginUserID="ajung611") Or (GetLoginUserID="phsman1") Or (GetLoginUserID="bjh2546") Or (GetLoginUserID="kjy8517") Or (GetLoginUserID="jj999a") Or (GetLoginUserID="ascreem") Or (GetLoginUserID="ppono2") Or (GetLoginUserID="seoboreum") Or (GetLoginUserID="corpse2") Or (GetLoginUserID="ysys1418") Or (GetLoginUserID="skyer9") Or (GetLoginUserID="ttlforyou") Or (GetLoginUserID="ley330") Or (GetLoginUserID="cjw0515") Or (GetLoginUserID="tmdcjs1010") then %>
		<div style="position:absolute; top:250px; right:0; z-index:50; width:80px; height:80px; padding-top:30px; background-color:rgba(0, 0, 0, 0.7); color:#fff; font-size:12px; text-align:center;"><a href="/apps/appCom/wish/web2014/pagelist.asp"><strong>드루와<br /> (관리자용)</strong></a></div>
		<% end if %>

		<%'!-- just one day --%>
		<% server.Execute("/chtml/main/loader/2017loader/exc_just1day_2018.asp") %>

		<%'// 마케팅 배너 %>
		<div id="mktbanner" class="marketing-bnr" v-cloak>
			<main-banner v-for="item in items" :item="item" :key="item.poscode" v-if="item.poscode == 2078" :isapp="1"></main-banner>
		</div>

		<%'!-- md's pick --%>
		<section id="mdpickSwiper" class="item-carousel md-pick">
			<div class="hgroup">
				<h2 class="headline headline-speech"><span lang="en">MD&#39;S PICK</span> <small>MD가 주목한 바로 그 상품!</small></h2>
				<a @click="fnAPPpopupMdPick_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/mdpicklist/index.asp');" class="btn-more btn-arrow">더보기</a>
			</div>

			<div class="items type-multi-row swiper-container">
				<ul class="swiper-wrapper" v-for="item in items" :item="item" :key="item.id" v-if="item.gubun1">
					<li class="swiper-slide">
						<main-mdpick v-for="(sub,index) in item.gubun1" :sub="sub" :key="sub.id" v-if="index < 2" :isapp="1"></main-mdpick>
					</li>
					<li class="swiper-slide">
						<main-mdpick v-for="(sub,index) in item.gubun1" :sub="sub" :key="sub.id" v-if="index > 1 && index < 4" :isapp="1"></main-mdpick>
					</li>
					<li class="swiper-slide">
						<main-mdpick v-for="(sub,index) in item.gubun1" :sub="sub" :key="sub.id" v-if="index > 3 && index < 6" :isapp="1"></main-mdpick>
					</li>
					<li class="swiper-slide">
						<main-mdpick v-for="(sub,index) in item.gubun1" :sub="sub" :key="sub.id" v-if="index > 5 && index < 8" :isapp="1"></main-mdpick>
					</li>
					<li class="swiper-slide">
						<main-mdpick v-for="(sub,index) in item.gubun1" :sub="sub" :key="sub.id" v-if="index > 7 && index < 10" :isapp="1"></main-mdpick>
					</li>
					<li class="swiper-slide">
						<main-mdpick v-for="(sub,index) in item.gubun1" :sub="sub" :key="sub.id" v-if="index > 9 && index < 12" :isapp="1"></main-mdpick>
					</li>
					<li class="swiper-slide">
						<main-mdpick v-for="(sub,index) in item.gubun1" :sub="sub" :key="sub.id" v-if="index > 11 && index < 14" :isapp="1"></main-mdpick>
					</li>
					<li class="swiper-slide">
						<main-mdpick v-for="(sub,index) in item.gubun1" :sub="sub" :key="sub.id" v-if="index == 14" :isapp="1"></main-mdpick>
						<a @click="fnAPPpopupMdPick_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/mdpicklist/index.asp?gaparam=today_mdpick_plus');" title="md&#39;s pick 더 보러가기" class="btn-more">+45</a>
					</li>
				</ul>
			</div>
		</section>
		<%'!-- md's pick --%>

		<%'// 이미지 C타입 %>
		<div id="imgbanC" class="gif-bnr" v-cloak>
			<main-banner v-for="item in items" :item="item" :key="item.poscode" v-if="item.poscode == 2081" :isapp="1"></main-banner>
		</div>

		<%' 후기 A/B 테스트용 %>
		<% If Date() >= "2018-07-25" And Date() <= "2018-07-31" Then %>
		<% server.Execute("/chtml/main/loader/2017loader/exc_evaltest.asp") %>
		<% End If %>

		<%'!-- for you --%>
		<div class="for-you" id="foryou" v-cloak v-if="openlayer">
			<div v-for="item in items" :item="item" :key="item.id">
				<h2 class="headline headline-speech" v-once>
					<strong class="label label-color"><em class="color-blue">For You</em></strong>{{username}}님께 추천합니다!
				</h2>
				<div class="items">
					<ul>
						<cateitem-more v-for="sub in item.listitems" :sub="sub" :isapp="1"></cateitem-more>
					</ul>
				</div>
			</div>
		</div>

		<%' 실시간 인기 검색어%>
		<% ''server.Execute("/chtml/main/loader/2017loader/realtime_keyword.asp") %>
		<%
			On Error resume Next ''2017/10/24 by eastone
			server.Execute("/chtml/main/html/realtime_keyword_app.html")
			On Error Goto 0
		%>
		<%' 실시간 인기 검색어%>

		<%'투데이이벤트 1~3 %>
		<section id="enjoyevent1" class="exhibition-list" v-cloak>
			<h2 class="hidden">기획전</h2>
			<div class="list-card type-align-left">
				<ul>
					<main-eventban v-for="item in items" :item="item" :key="item.id" v-if="item.id < 4" :isapp="1"></main-eventban>
				</ul>
			</div>
		</section>

		<%'// 이미지 A타입 %>
		<section id="imgbanA" class="text-bnr" v-cloak>
			<img-banner v-for="item in items" :item="item" :key="item.poscode" v-if="item.poscode == 2079" :isapp="1"></img-banner>
		</section>

		<%'//twinitems %>
		<div id="twinitems" class="items-single-bnr" v-cloak>
			<ul class="items" v-for="item in items" :item="item">
				<li>
					<a @click="fnAPPpopupAutoUrl(item.L_itemurl);">
						<span class="label label-triangle" v-if="item.L_newbest > 0"><em v-if="item.L_newbest == 1">NEW</em><em v-if="item.L_newbest == 2">BEST</em></span>
						<div class="thumbnail"><img :src="item.L_img" alt=""></div>
						<div class="desc">
							<b class="headline">{{item.L_maincopy}} <u>{{item.L_itemname}}</u></b>
							<span class="price"><b class="discount color-red" v-if="item.L_saleper">{{item.L_saleper}}</b> <b class="sum">{{item.L_price}}<span class="won">원</span></b></span>
						</div>
					</a>
				</li>
				<li>
					<a @click="fnAPPpopupAutoUrl(item.R_itemurl);">
						<span class="label label-triangle" v-if="item.R_newbest > 0"><em v-if="item.R_newbest == 1">NEW</em><em v-if="item.R_newbest == 2">BEST</em></span>
						<div class="thumbnail"><img :src="item.R_img" alt=""></div>
						<div class="desc">
							<b class="headline">{{item.R_maincopy}} <u>{{item.R_itemname}}</u></b>
							<span class="price"><b class="discount color-red" v-if="item.R_saleper">{{item.R_saleper}}</b> <b class="sum">{{item.R_price}}<span class="won">원</span></b></span>
						</div>
					</a>
				</li>
			</ul>
		</div>

		<%'!-- on sale --%>
		<section id="saleSwiper" class="item-carousel on-sale-items" v-cloak>
			<div class="hgroup">
				<h2 class="headline headline-speech"><span lang="en">ON SALE</span> <small>세일 상품 모두 모여라</small></h2>
				<a @click="fnAPPpopupSALE_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/sale/saleitem.asp?gaparam=today_sale_0');" class="btn-more btn-arrow">더보기</a>
			</div>
			<div class="items type-multi-row swiper-container">
				<ul class="swiper-wrapper" v-for="item in items" :item="item" :key="item.id" v-if="item.gubun4">
					<li class="swiper-slide">
						<main-sale v-for="(sub,index) in item.gubun4" :sub="sub" :key="sub.id" v-if="index < 2" :isapp="1"></main-sale>
					</li>
					<li class="swiper-slide">
						<main-sale v-for="(sub,index) in item.gubun4" :sub="sub" :key="sub.id" v-if="index > 1 && index < 4" :isapp="1"></main-sale>
					</li>
					<li class="swiper-slide">
						<main-sale v-for="(sub,index) in item.gubun4" :sub="sub" :key="sub.id" v-if="index > 3 && index < 6" :isapp="1"></main-sale>
					</li>
					<li class="swiper-slide">
						<main-sale v-for="(sub,index) in item.gubun4" :sub="sub" :key="sub.id" v-if="index > 5 && index < 8" :isapp="1"></main-sale>
					</li>
					<li class="swiper-slide">
						<main-sale v-for="(sub,index) in item.gubun4" :sub="sub" :key="sub.id" v-if="index > 7 && index < 10" :isapp="1"></main-sale>
					</li>
					<li class="swiper-slide">
						<main-sale v-for="(sub,index) in item.gubun4" :sub="sub" :key="sub.id" v-if="index > 9 && index < 12" :isapp="1"></main-sale>
					</li>
					<li class="swiper-slide">
						<main-sale v-for="(sub,index) in item.gubun4" :sub="sub" :key="sub.id" v-if="index > 11 && index < 14" :isapp="1"></main-sale>
					</li>
					<li class="swiper-slide">
						<main-sale v-for="(sub,index) in item.gubun4" :sub="sub" :key="sub.id" v-if="index > 13 && index < 16" :isapp="1"></main-sale>
					</li>
				</ul>
			</div>
		</section>

		<%'투데이이벤트 4~6 %>
		<section id="enjoyevent2" class="exhibition-list" v-cloak>
			<h2 class="hidden">기획전</h2>
			<div class="list-card type-align-left">
				<ul>
					<main-eventban v-for="item in items" :item="item" :key="item.id" v-if="item.id > 3 && item.id < 7" :isapp="1"></main-eventban>
				</ul>
			</div>
		</section>

		<%'//today-keyword %>
		<div id="mainkeyword" v-cloak>
			<section class="hot-keyword" v-for="item in items" :item="item" :key="item.id" :style="{background:item.bgcolor}">
				<h2 class="headline">
					<span>HOT <em>KEYWORD <span class="vol">v.{{item.ver_no}}</span></em></span>
					<small><a @click="fnAPPpopupAutoUrl(item.link);return false;">#{{item.maincopy}}</a></small>
				</h2>
				<ul>
					<li>
						<a @click="fnAPPpopupAutoUrl(item.itemid1url);return false;">
							<span class="label label-star" v-if="item.picknum == 1"><svg viewBox="0 0 45 45"><path fill="#000" fill-rule="evenodd" d="M22.5 41.73l-5.385 2.616-3.552-4.818-5.983-.187-.907-5.917-5.21-2.945 1.947-5.661-3.246-5.03L4.52 15.68l-.536-5.962 5.765-1.613 2.296-5.529 5.854 1.251L22.5 0l4.602 3.828 5.854-1.25 2.296 5.528 5.765 1.613-.536 5.962 4.355 4.107-3.246 5.03 1.948 5.66-5.211 2.946-.907 5.917-5.983.187-3.552 4.818z"/></svg><em>pick</em></span>
							<div class="thumbnail"><img :src="item.imgsrc1" alt="" /></div>
						</a>
					</li>
					<li>
						<a @click="fnAPPpopupAutoUrl(item.itemid2url);return false;">
							<span class="label label-star" v-if="item.picknum == 2"><svg viewBox="0 0 45 45"><path fill="#000" fill-rule="evenodd" d="M22.5 41.73l-5.385 2.616-3.552-4.818-5.983-.187-.907-5.917-5.21-2.945 1.947-5.661-3.246-5.03L4.52 15.68l-.536-5.962 5.765-1.613 2.296-5.529 5.854 1.251L22.5 0l4.602 3.828 5.854-1.25 2.296 5.528 5.765 1.613-.536 5.962 4.355 4.107-3.246 5.03 1.948 5.66-5.211 2.946-.907 5.917-5.983.187-3.552 4.818z"/></svg><em>pick</em></span>
							<div class="thumbnail"><img :src="item.imgsrc2" alt="" /></div>
						</a>
					</li>
					<li>
						<a @click="fnAPPpopupAutoUrl(item.itemid3url);return false;">
							<span class="label label-star" v-if="item.picknum == 3"><svg viewBox="0 0 45 45"><path fill="#000" fill-rule="evenodd" d="M22.5 41.73l-5.385 2.616-3.552-4.818-5.983-.187-.907-5.917-5.21-2.945 1.947-5.661-3.246-5.03L4.52 15.68l-.536-5.962 5.765-1.613 2.296-5.529 5.854 1.251L22.5 0l4.602 3.828 5.854-1.25 2.296 5.528 5.765 1.613-.536 5.962 4.355 4.107-3.246 5.03 1.948 5.66-5.211 2.946-.907 5.917-5.983.187-3.552 4.818z"/></svg><em>pick</em></span>
							<div class="thumbnail"><img :src="item.imgsrc3" alt="" /></div>
						</a>
					</li>
					<li>
						<a @click="fnAPPpopupAutoUrl(item.itemid4url);return false;">
							<span class="label label-star" v-if="item.picknum == 4"><svg viewBox="0 0 45 45"><path fill="#000" fill-rule="evenodd" d="M22.5 41.73l-5.385 2.616-3.552-4.818-5.983-.187-.907-5.917-5.21-2.945 1.947-5.661-3.246-5.03L4.52 15.68l-.536-5.962 5.765-1.613 2.296-5.529 5.854 1.251L22.5 0l4.602 3.828 5.854-1.25 2.296 5.528 5.765 1.613-.536 5.962 4.355 4.107-3.246 5.03 1.948 5.66-5.211 2.946-.907 5.917-5.983.187-3.552 4.818z"/></svg><em>pick</em></span>
							<div class="thumbnail"><img :src="item.imgsrc4" alt="" /></div>
						</a>
					</li>
				</ul>
			</section>
		</div>

		<%'!-- enjoy --%>
		<div id="enjoySwiper">
			<section class="item-carousel enjoy-items" v-cloak v-for="item in items" :item="item" :key="item.id">
				<div class="hgroup">
					<h2 class="headline headline-speech"><span lang="en">ENJOY</span> <small>{{item.extitle1}}</small></h2>
					<a @click="fnAPPpopupAutoUrl(item.link1)" v-if="item.link1" class="btn-more btn-arrow">더보기</a>
				</div>

				<div class="swiper-container items type-box-grey">
					<ul class="swiper-wrapper">
						<main-itemlist v-for="(sub,index) in item.exhibition1" :sub="sub" :index="index" :key="sub.id" :isapp="1"></main-itemlist>
					</ul>
				</div>
			</section>
		</div>

		<%'!-- brand banner --%>
		<section id="mainbrand" class="brand-bnr" v-cloak>
			<brand-banner v-for="item in items" :item="item" :isapp="1"></brand-banner>
		</section>

		<%'이미지 배너 B타입%>
		<section id="imgbanB" class="text-bnr" v-cloak>
			<img-banner v-for="item in items" :item="item" :key="item.poscode" v-if="item.poscode == 2080" :isapp="1"></img-banner>
		</section>

		<%'투데이이벤트 7~9  %>
		<section id="enjoyevent3" class="exhibition-list" v-cloak>
			<h2 class="hidden">기획전</h2>
			<div class="list-card type-align-left">
				<ul>
					<main-eventban v-for="item in items" :item="item" :key="item.id" v-if="item.id > 6 && item.id < 10" :isapp="1"></main-eventban>
				</ul>
			</div>
		</section>

		<%'!-- category --%>
		<section class="menu-category">
			<h2 class="hidden">카테고리</h2>
			<ul>
				<li><a href="" onclick="fnAPPpopupCategory(101);return false;" class="on"><span class="icon icon-category101"></span><span class="name">디자인문구</span></a></li>
				<li><a href="" onclick="fnAPPpopupCategory(102);return false;"><span class="icon icon-category102"></span><span class="name">디지털/핸드폰</span></a></li>
				<li><a href="" onclick="fnAPPpopupCategory(124);return false;"><span class="icon icon-category124"></span><span class="name">디자인가전</span></a></li>
				<li><a href="" onclick="fnAPPpopupCategory(121);return false;"><span class="icon icon-category121"></span><span class="name">가구/수납</span></a></li>
				<li><a href="" onclick="fnAPPpopupCategory(122);return false;"><span class="icon icon-category122"></span><span class="name">데코/조명</span></a></li>
				<li><a href="" onclick="fnAPPpopupCategory(120);return false;" class="on"><span class="icon icon-category120"></span><span class="name">패브릭/생활</span></a></li>
				<li><a href="" onclick="fnAPPpopupCategory(112);return false;"><span class="icon icon-category112"></span><span class="name">키친</span></a></li>
				<li><a href="" onclick="fnAPPpopupCategory(119);return false;"><span class="icon icon-category119"></span><span class="name">푸드</span></a></li>
				<li><a href="" onclick="fnAPPpopupCategory(117);return false;"><span class="icon icon-category117"></span><span class="name">패션의류</span></a></li>
				<li><a href="" onclick="fnAPPpopupCategory(116);return false;"><span class="icon icon-category116"></span><span class="name">패션잡화</span></a></li>
				<li><a href="" onclick="fnAPPpopupCategory(125);return false;"><span class="icon icon-category125"></span><span class="name">주얼리/시계</span></a></li>
				<li><a href="" onclick="fnAPPpopupCategory(118);return false;"><span class="icon icon-category118"></span><span class="name">뷰티</span></a></li>
				<li><a href="" onclick="fnAPPpopupCategory(103);return false;"><span class="icon icon-category103"></span><span class="name">캠핑/트래블</span></a></li>
				<li><a href="" onclick="fnAPPpopupCategory(104);return false;"><span class="icon icon-category104"></span><span class="name">토이</span></a></li>
				<li><a href="" onclick="fnAPPpopupCategory(115);return false;"><span class="icon icon-category115"></span><span class="name">베이비/키즈</span></a></li>
				<li><a href="" onclick="fnAPPpopupCategory(110);return false;"><span class="icon icon-category110"></span><span class="name">캣앤독</span></a></li>
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
				<a @click="fnAPPpopupNEW_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/newitem/newitem.asp?gaparam=today_new_0');" class="btn-more btn-arrow">더보기</a>
			</div>

			<div class="swiper-container items type-box-grey">
				<ul class="swiper-wrapper" v-for="item in items" :item="item" :key="item.id" v-if="item.gubun2">
					<main-itemlist v-for="(sub,index) in item.gubun2" :sub="sub" :index="index" :key="sub.id" :isapp="1"></main-itemlist>
				</ul>
			</div>
		</section>

		<%'투데이이벤트 10~12  %>
		<section id="enjoyevent4" class="exhibition-list" v-cloak>
			<h2 class="hidden">기획전</h2>
			<div class="list-card type-align-left">
				<ul>
					<main-eventban v-for="item in items" :item="item" :key="item.id" v-if="item.id > 9 && item.id < 13" :isapp="1"></main-eventban>
				</ul>
			</div>
		</section>

		<div class="bnr gift-guide-bnr">
			<a href="" onclick="fnAPPpopupBrowserURL('선물포장 서비스','<%=wwwUrl%>/apps/appCom/wish/web2014/shoppingtoday/gift_recommend.asp?gaparam=main_menu_warpping','right','','sc'); return false;"><span>선물의 감동을 더해줄<br /> 텐바이텐 선물포장 서비스</span></a>
		</div>

		<%'링크%>
		<div class="menu-etc">
			<ul>
				<li><a href="" onclick="fnAPPpopupCouponBook_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/shoppingtoday/couponshop.asp?gaparam=today_menu_coupon');return false;"><span class="icon icon-coupon"></span><span class="name">쿠폰</span> <% If cTotcnt > 0 Then %><span class="badge"><%=cTotcnt%><%=chkiif(cTotcnt>99,"+","")%></span><% End If %></a></li>
				<li><a href="" onclick="fnAPPpopupGiftToday_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/gift/gifttalk/?gaparam=today_menu_gift');return false;"><span class="icon icon-gift"></span><span class="name">기프트</span></a></li>
				<li><a href="" onclick="fnAPPpopupEventMain_S(1);return false;"><span class="icon icon-exhibition"></span><span class="name">기획전</span></a></li>
				<li><a href="" onclick="fnAPPpopupEventMain_S(2);return false;"><span class="icon icon-event"></span><span class="name">이벤트</span></a></li>
			</ul>
		</div>

		<%'// HCPlist %>
		<div id="HCPlist" class="contents-bnr" v-cloak>
			<div v-for="item in items" :item="item" :key="item.id" v-if="item.poscode == 2082">
				<section class="playing-bnr" v-if="item.cgubun == 3" id="hcp1">
					<hcp-list :item="item" v-if="item.cgubun == 3" :isapp="1"></hcp-list>
				</section>
				<section class="hitchhiker-bnr" v-else-if="item.cgubun == 1" id="hcp2">
					<hcp-list :item="item" v-if="item.cgubun == 1" :isapp="1"></hcp-list>
				</section>
				<section class="culture-bnr" v-else-if="item.cgubun == 2" id="hcp3">
					<hcp-list :item="item" v-if="item.cgubun == 2" :isapp="1"></hcp-list>
					<div class="btn-group"><a href="" onclick="fnAPPpopupCulture_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/culturestation/index.asp?gaparam=today_HCP_c0');return false;" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> 더 많은 컬쳐스테이션</a></div>
				</section>
			</div>
		</div>

		<div class="shipping-bnr">
			<a href="" onclick="fnAPPpopupSearch('텐바이텐배송');return false;"><p>빛보다 빠른<br /> <em>텐텐배송 상품</em><span class="icon icon-car"></span></p></a>
		</div>

		<%'// Today 더보기 카테고리%>
		<div class="category-item-content bg-grey" id="todaymore" v-if="show">
			<section class="category-item-list" v-for="item in sliced" :item="item" :key="item.id" v-if="sliced" >
				<h2 class="headline"><span :class="item.cateclass"></span>{{item.catename}}</h2>

				<div class="items">
					<ul>
						<cateitem-more v-for="sub in item.cateitem" :sub="sub" :isapp="1"></cateitem-more>
					</ul>
				</div>

				<section class="exhibition-list">
					<h3 class="hidden">디자인문구 기획전</h3>
					<div class="list-card type-align-left">
						<ul>
							<event-more v-for="sub in item.cateevent" :sub="sub" :isapp="1"></event-more>
						</ul>
					</div>
				</section>

				<div class="btn-group"><a @click="fnAPPpopupCategory(item.cateurl)" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> {{item.catename}} 더보기</a></div>
			</section>
		</div>
	</main>
</div>
<script src="/vue/vue.min.js"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/contents.js?v=1.1"></script>
<script src="/apps/appCom/wish/web2014/lib/js/common.js?v=2.122"></script>
<script src="/apps/appCom/wish/web2014/lib/js/customapp.js?v=2.45"></script>
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/incfooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->