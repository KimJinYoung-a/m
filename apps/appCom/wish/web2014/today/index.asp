<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'###########################################################
' Description : Today Main (index)
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
	CGLBAppName = "app_wish2"	''/web2014 폴더 app_wish2
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

	'###### 제휴사 flag 관련 - 주문 저장시/회원가입시 제휴사 Flag 저장 ######
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

    Dim mdpickFunction, saleFunction, newFunction
	Dim ckAgent : ckAgent = Lcase(Request.ServerVariables("HTTP_USER_AGENT"))
	If (InStr(ckAgent ,"tenapp i4.")>0) Or (InStr(ckAgent ,"tenapp a4.")>0) Then
	    mdpickFunction = "fnAPPpopupBrowserRenewal('push', 'MDPICK', '" & wwwUrl & "/apps/appCom/wish/web2014/list/mdpick/mdpick_summary2020.asp', 'mdpick');"
	    saleFunction = "fnAPPpopupBrowserRenewal('push', 'SALE', '" & wwwUrl & "/apps/appCom/wish/web2014/list/sale/sale_summary2020.asp', 'mdpick');"
	    newFunction = "fnAPPpopupBrowserRenewal('push', 'NEW', '" & wwwUrl & "/apps/appCom/wish/web2014/list/new/new_summary2020.asp', 'mdpick');"
	Else
	    mdpickFunction = "fnAPPpopupMdPick_URL('" & wwwUrl & "/apps/appcom/wish/web2014/list/mdpick/mdpick_summary2020.asp?gaparam=today_mdpick_0');"
        saleFunction = "fnAPPpopupSALE_URL('" & wwwUrl & "/apps/appcom/wish/web2014/list/sale/sale_summary2020.asp?gaparam=today_sale_0');"
        newFunction = "fnAPPpopupNEW_URL('" & wwwUrl & "/apps/appcom/wish/web2014/list/new/new_summary2020.asp?gaparam=today_new_0');"
	End If
%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=5.0">
<meta name="format-detection" content="telephone=no" />
<title><%= strPageTitle %></title>
<link rel="stylesheet" type="text/css" href="/lib/css/common.css?v=1.80" />
<link rel="stylesheet" type="text/css" href="/lib/css/main.css?v=1.61" />
<link rel="stylesheet" type="text/css" href="/lib/css/app.css" />
<link rel="stylesheet" type="text/css" href="/lib/css/temp_a.css?v=1.06" />
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="/lib/js/jquery.swiper-3.1.2.min.js"></script>
<script type="text/javascript">
var isapp = '<%=isapp%>'
</script>
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
}); 
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
<div id="content" class="content">
	<main>
		<h1 class="hidden">투데이</h1>

		<%'// 메인롤링 %>
		<% server.Execute("/chtml/main/loader/2017loader/exc_mainRolling.asp") %>

		<% ' 기존 best에 있던 .. 부분 %>
		<% if (GetLoginUserID="icommang") Or (GetLoginUserID="10x10green") Or (GetLoginUserID="thensi7") Or (GetLoginUserID="tozzinet") Or (GetLoginUserID="qpark99") Or (GetLoginUserID="kobula") Or (GetLoginUserID="greenteenz") Or (GetLoginUserID="vhfhflsksk") Or (GetLoginUserID="phsman1") Or (GetLoginUserID="kjy8517") Or (GetLoginUserID="corpse2") Or (GetLoginUserID="ysys1418") Or (GetLoginUserID="skyer9") Or (GetLoginUserID="ley330") Or (GetLoginUserID="cjw0515") Or (GetLoginUserID="jeonghyeon1211") Or (GetLoginUserID="rnldusgpfla") Or (GetLoginUserID="jjia94") Or (GetLoginUserID="sse1022") Or (GetLoginUserID="kjh951116") Or (GetLoginUserID="seojb1983") Or (GetLoginUserID="kny9480") Or (GetLoginUserID="bestksy0527") Or (GetLoginUserID="mame234") Or (GetLoginUserID="starsun726") Or (GetLoginUserID="lglee2938") Or (GetLoginUserID="dlwjseh") Or (GetLoginUserID="integerkim") Or (GetLoginUserID="coolhas") Or (GetLoginUserID="winnie") Or (GetLoginUserID="pinokio5600") Or (GetLoginUserID="10x10yellow") Or (GetLoginUserID="10x10blue") Or (GetLoginUserID="10x10vip") Or (GetLoginUserID="10x10vipgold") Or (GetLoginUserID="10x10vvip") Or (GetLoginUserID="madash") Or (GetLoginUserID="cunhng") Or (GetLoginUserID="sonjisuu1014") Or (GetLoginUserID="pepe820") Or (GetLoginUserID="dokyong0401") Or (GetLoginUserID="z0516") Or (GetLoginUserID="pinkmaring") Or (GetLoginUserID="kbm503") Or (GetLoginUserID="jehyeon") Or (GetLoginUserID="yeg0117") Or (GetLoginUserID="angel1094") Or (GetLoginUserID="jimni0114") Or (GetLoginUserID="moonwork13") Or (GetLoginUserID="alice3211") Or (GetLoginUserID="ysyoo89") Or (GetLoginUserID="wldbs4086") then %>
		<div style="position:absolute; top:250px; right:0; z-index:50; width:80px; height:80px; padding-top:30px; background-color:rgba(0, 0, 0, 0.7); color:#fff; font-size:12px; text-align:center;"><a href="/apps/appCom/wish/web2014/pagelist.asp"><strong>드루와<br /> (관리자용)</strong></a></div>
		<% end if %>
		
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
		<% If now() >= #2022-01-26 23:59:59# Then %>
        <a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '다이어리 스토리', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2022/index.asp?gaparam=today_banner')" class="bnr_main_dr mApp"></a>
        <% else %>
        <a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '설 배송안내', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appcom/wish/web2014/common/news/news_view.asp?type=&idx=19266&page=1')" class="bnr_main_dr mApp"></a>
        <% end if %>

		<%'// 마케팅 배너 %>
		<div id="mktbanner" class="marketing-bnr" v-cloak>
			<main-banner v-for="(item,index) in items" v-if="item.type == 'marketingRolling'"
			    :item="item" :index="index" :isapp="1"/>
		</div>
		<%'// 공지사항 %>
		<% server.Execute("/chtml/main/loader/2017loader/main_notice_banner.asp") %>

		<%'// 메인 빅 이벤트 배너 %>
		<% server.Execute("/chtml/main/loader/2017loader/exc_mainBigEvent.asp") %>

		<%'!-- md's pick --%>
		<section id="mdpickSwiper" class="item-carousel md-pick" v-cloak>
			<div class="hgroup">
				<h2 class="headline headline-speech"><span lang="en">MD&#39;S PICK</span> <small>MD가 주목한 상품!</small></h2>
				<a onclick="<%=mdpickFunction%>" class="btn-more btn-arrow">더보기</a>
			</div>

			<div class="items type-multi-row swiper-container">
				<ul class="swiper-wrapper">
					<li v-for="(items,index) in mixItems" class="swiper-slide">
						<main-mdpick v-for="(item,order) in items" :sub="item" :key="item.itemId" :index="(index*2)+order+1" :isapp="true"></main-mdpick>
						<a v-if="items.length === 1" onclick="<%=mdpickFunction%>" title="md&#39;s pick 더 보러가기" class="btn-more">+45</a>
					</li>
                    <li v-if="isEvenItemsLength" class="swiper-slide">
                        <a onclick="<%=mdpickFunction%>" title="md&#39;s pick 더 보러가기" class="btn-more">+45</a>
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
			<main-banner v-for="item in items" :item="item" v-if="item.type == 'imageBannerC'" :isapp="true"/>
		</div>
		
		<!-- 기프트 배너 -->
		<div class="gift-bnr">
			<div class="giftcard">
				<a href="" onclick="fnAPPpopupBrowserURL('기프트카드','http://m.10x10.co.kr/apps/appCom/wish/web2014/giftcard/index.asp?gaparam=today_banner_giftcard','right','','sc');return false;">
					<span><img src="//fiximage.10x10.co.kr/m/2019/today/bg_giftcard.png" alt=""></span>
					<p class="txt">따사로운 마음을 전하는<strong>기프트카드 선물하기</strong></p>
				</a>
			</div>
			<!--<div class="giftwrap">
				<a href="" onclick="fnAPPpopupBrowserURL('선물포장 서비스','http://m.10x10.co.kr/apps/appCom/wish/web2014//shoppingtoday/gift_recommend.asp?gaparam=today_banner_packaging','right','','sc');return false;">
					<span><img src="http://fiximage.10x10.co.kr/m/2018/today/bg_giftwrap.png" alt=""></span>
					<p class="txt">감사의 마음까지 함께 담은 <strong>선물포장 상품 보기</strong></p>
				</a>
			</div>-->
			<div class="giftwrap">
				<a href="" onclick="fnAPPpopupBrowserURL('선물의 참견','http://m.10x10.co.kr/apps/appCom/wish/web2014/gift/gifttalk/','right','','sc');return false;">
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

		<%' new for you %>			
		<%
		On Error resume Next '2019-05-28 최종원
		if IsUserLoginOK() then
			server.Execute("/chtml/main/loader/2017loader/foryou.asp")
		end if
		On Error Goto 0
		%>
		<%' new for you %>		

		<%'투데이이벤트 1~3 %>
		<section id="enjoyevent1" class="exhibition-list" v-cloak>
			<h2 class="hidden">기획전</h2>
			<div class="list-card type-align-left">
				<ul>
					<main-eventban v-for="(item, index) in items" :key="item.title1"
                        :item="item" :index="index+1" :start="0" :isapp="true"/>
				</ul>
			</div>
		</section>

		<%'// 이미지 A타입 %>
		<section id="imgbanA" class="text-bnr" v-cloak>
			<img-banner v-for="item in items" :item="item" :key="item.mainCopy" v-if="item.type == 'imageBannerA'" :isapp="1"/>
		</section>

		<%'//twinitems %>
		<div id="twinitems" class="items-single-bnr" v-cloak>
			<twin-item v-for="twinItem in twinItems" :items="twinItem.items" :isapp="true"/>
		</div>

		<%'!-- on sale --%>
		<section id="saleSwiper" class="item-carousel on-sale-items" v-cloak>
			<div class="hgroup">
				<h2 class="headline headline-speech"><span lang="en">ON SALE</span> <small>세일 상품 모두 모여라</small></h2>
				<a onclick="<%=saleFunction%>" class="btn-more btn-arrow">더보기</a>
			</div>
			<div class="items type-multi-row swiper-container">
				<ul class="swiper-wrapper">
                    <li v-for="(items,index) in mixItems" class="swiper-slide">
                        <main-sale v-for="(item,order) in items" :sub="item" :key="item.itemId"
                            :index="(index*2)+order+1" :isapp="true"/>
                    </li>
                </ul>
			</div>
		</section>

		<%'투데이이벤트 4~6 %>
		<section id="enjoyevent2" class="exhibition-list" v-cloak>
			<h2 class="hidden">기획전</h2>
			<div class="list-card type-align-left">
				<ul>
					<main-eventban v-for="(item, index) in items" :key="item.title1"
                        :item="item" :index="index+1" :start="3" :isapp="true"/>
				</ul>
			</div>
		</section>

		<%'//today-keyword %>
		<div id="mainkeyword" v-cloak>
			<section class="hot-keyword" v-for="item in items" :item="item" :style="{background:item.backgroundColor}">
				<h2 class="headline">
					<span>HOT <em>KEYWORD <span class="vol">v.{{item.version}}</span></em></span>
					<small><a @click="fnAPPpopupAutoUrl(item.link);return false;">#{{item.keyword}}</a></small>
				</h2>
				<ul>
					<li v-for="(product, index) in item.items" :key="product.itemId">
                        <a @click="clickItem(index+1, product.itemId, decodeBase64(product.url))">
                            <span v-if="item.pickNumber == index+1" class="label label-star">
                                <svg viewBox="0 0 45 45">
                                    <path fill="#000" fill-rule="evenodd" d="M22.5 41.73l-5.385 2.616-3.552-4.818-5.983-.187-.907-5.917-5.21-2.945 1.947-5.661-3.246-5.03L4.52 15.68l-.536-5.962 5.765-1.613 2.296-5.529 5.854 1.251L22.5 0l4.602 3.828 5.854-1.25 2.296 5.528 5.765 1.613-.536 5.962 4.355 4.107-3.246 5.03 1.948 5.66-5.211 2.946-.907 5.917-5.983.187-3.552 4.818z"/>
                                </svg>
                                <em>pick</em>
                            </span>
                            <div class="thumbnail"><img :src="decodeBase64(product.image)" alt=""/></div>
                        </a>
                    </li>
				</ul>
			</section>
		</div>

		<%'!-- enjoy --%>
		<div id="enjoySwiper" v-cloak>
			<section class="item-carousel enjoy-items" v-for="item in items" :item="item">
				<div class="hgroup">
					<h2 class="headline headline-speech"><span lang="en">ENJOY</span> <small>{{item.extitle1}}</small></h2>
					<a @click="fnAPPpopupAutoUrl(item.link1)" v-if="item.link1" class="btn-more btn-arrow">더보기</a>
				</div>

				<div class="swiper-container items type-box-grey">
					<ul class="swiper-wrapper">
						<main-itemlist v-for="(sub,index) in item.exhibition1" :sub="sub" :index="index+1" :key="sub.id" :isapp="1"></main-itemlist>
					</ul>
				</div>
			</section>
		</div>

		<%'!-- brand banner --%>
		<section id="mainbrand" class="brand-bnr" v-cloak>
			<brand-banner v-for="item in items" :item="item" :isapp="1"/>
		</section>

		<!-- special brand (20190712) -->
		<div class="special-brand-bnr">
			<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], 'Special Brand', [BtnType.SHARE, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/brand/')">
				<img src="//fiximage.10x10.co.kr/m/2019/pb/bnr_special_brand.jpg" alt="" />
			</a>
		</div>

		<%'이미지 배너 B타입%>
		<section id="imgbanB" class="text-bnr" v-cloak>
			<img-banner v-for="item in items" :item="item" :key="item.mainCopy" v-if="item.type == 'imageBannerB'" :isapp="true"/>
		</section>

		<%'투데이이벤트 7~9 %>
		<section id="enjoyevent3" class="exhibition-list" v-cloak>
			<h2 class="hidden">기획전</h2>
			<div class="list-card type-align-left">
				<ul>
					<main-eventban v-for="(item, index) in items" :key="item.title1"
                        :item="item" :index="index+1" :start="6" :isapp="true"/>
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
				<li><a href="" onclick="fnAPPpopupCategory(104);return false;"><span class="icon icon-category104"></span><span class="name">토이/취미</span></a></li>
				<li><a href="" onclick="fnAPPpopupCategory(110);return false;"><span class="icon icon-category110"></span><span class="name">캣앤독</span></a></li>
				<li><a href="" onclick="fnAPPpopupCategory(103);return false;"><span class="icon icon-category103"></span><span class="name">캠핑</span></a></li>
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
				<a onclick="<%=newFunction%>" class="btn-more btn-arrow">더보기</a>
			</div>

			<div class="swiper-container items type-box-grey">
				<ul class="swiper-wrapper">
					<main-itemlist v-for="(sub,index) in items" :sub="sub" :index="index+1" :key="sub.itemId" :isapp="true"/>
				</ul>
			</div>
		</section>

		<%'투데이이벤트 10~12 %>
		<section id="enjoyevent4" class="exhibition-list" v-cloak>
			<h2 class="hidden">기획전</h2>
			<div class="list-card type-align-left">
				<ul>
					<main-eventban v-for="(item, index) in items" :key="item.title1"
                        :item="item" :index="index+1" :start="9" :isapp="true"/>
				</ul>
			</div>
		</section>
<%'//가이드배너 추가 위치 최종원 20180807%>
		<%'// guide %>									
		<div id="guideList" class="marketing-bnr" v-cloak>
			<main-banner v-for="item in items" :item="item" v-if="item.type == 'guideBanner'" :isapp="true"/>
		</div>					
<%'//가이드배너 추가 위치 최종원 20180807%>

		<%'!-- diaryitems 2019 2019-07-24 주석 처리 2020 다이어리때 다시 사용 할 수 있음 --%>
		<%' server.Execute("/chtml/main/loader/2017loader/exc_diarystoryitems.asp") %>

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
				<section class="playing-bnr" v-if="item.contentsType == 'playing'">
                    <hcp-list :item="item" :isapp="true"/>
                </section>
                <section class="hitchhiker-bnr" v-else-if="item.contentsType == 'hitchhiker'">
                    <hcp-list :item="item" :isapp="true"/>
                </section>
				<section class="culture-bnr" v-else-if="item.contentsType == 'cultureStation'">
					<hcp-list :item="item" :isapp="true"/>
					<div class="btn-group"><a href="" onclick="fnAPPpopupCulture_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/culturestation/index.asp?gaparam=today_HCP_c0');return false;" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> 더 많은 컬쳐스테이션</a></div>
				</section>
			</div>
		</div>

		<div class="shipping-bnr">
			<a href="" onclick="fnAPPpopupSearch('텐바이텐배송');return false;"><p>빛보다 빠른<br /> <em>텐텐배송 상품</em><span class="icon icon-car"></span></p></a>
		</div>

		<%'// Today 더보기 카테고리%>
		<div class="category-item-content bg-grey" id="todaymore" v-if="show" v-cloak>
			<section v-for="item in sliced" :key="item.categoryCode" class="category-item-list">
                <h2 class="headline"><span :class="'icon icon-category' + item.categoryCode"></span>{{item.categoryName}}</h2>

				<div class="items">
                    <ul>
                        <cateitem-more v-for="(sub, index) in item.items" :key="sub.itemId" :item="sub"
                            :code="item.categoryCode" :index="index+1" :isapp="true"/>
                    </ul>
                </div>

                <section class="exhibition-list">
                    <h3 class="hidden">{{item.categoryName}} 기획전</h3>
                    <div class="list-card type-align-left">
                        <ul>
                            <event-more v-for="(sub, index) in item.events" :key="sub.eventCode" :item="sub"
                                :code="item.categoryCode" :index="index+1" :isapp="true"/>
                        </ul>
                    </div>
                </section>

				<div class="btn-group">
				    <a @click="clickMore(item.categoryCode)" class="btn-plus color-blue">
				        <span class="icon icon-plus icon-plus-blue"></span>
				        {{item.categoryName}} 더보기
                    </a>
                </div>
            </section>
		</div>
        <div class="category_banner">
            <a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '다이어리 스토리', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2022/index.asp?gaparam=today_banner')"><img src="http://fiximage.10x10.co.kr/m/2021/diary/bnr_big_diary2022_01.png" alt="2022 다이어리 준비하셨나요?"></a>
        </div>
	</main>
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
<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script src="/vue/today/store.js?v=1.0"></script>
<script src="/vue/contents.js?v=1.74"></script>
<script src="/apps/appCom/wish/web2014/lib/js/common.js?v=2.122"></script>
<script src="/apps/appCom/wish/web2014/lib/js/customapp.js?v=2.48"></script>

<script src="/vue/list/best/renewal/prd_item_today_best.js?v=1.00"></script>
<script src="/vue/components/product/prd_img.js?v=1.0"></script>
<script src="/vue/components/product/prd_price.js?v=1.0"></script>
<script src="/vue/components/product/prd_name.js?v=1.0"></script>

<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/incfooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->