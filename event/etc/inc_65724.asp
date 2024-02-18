<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 한가위만 같아라(M,A) MAIN
' History : 2015-08-28 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim eCode

IF application("Svr_Info") = "Dev" THEN
	eCode   =  64869
Else
	eCode   =  65724 '//이벤트 메인 상품리스트
End If

dim userid, i
	userid = GetEncLoginUserID()
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt65724 {overflow:hidden;}
.todayItem {position:relative; padding-bottom:12%; background:#07236b url(http://webimage.10x10.co.kr/eventIMG/2015/65724/bg_sky_v2.gif) no-repeat 0 0; background-size:100% 100%;}
.todayItem .mainItem {position:relative; padding:7% 7% 8%; width:76.5%; border:3px solid #f3d9b0; margin:0 auto; text-align:center; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65724/bg_paper.gif) no-repeat 0 100%; background-size:100% 100%; box-shadow:0 0 4px 3px rgba(0,0,0,.3);}
.todayItem .mainItem .figure {margin-bottom:16%;}
.todayItem .mainItem .pName {overflow:hidden; padding-top:0; color:#000; text-overflow:ellipsis; white-space:nowrap;}
.todayItem .btnMore {display:inline-block; position:absolute; left:40%; bottom:7.5%; width:20%;}
.todayItem .btnRefresh {position:absolute; left:43%; top:67.5%; width:14%; background:transparent;}
.goOthers {overflow:hidden;}
.goOthers li {float:left; width:100%; padding-top:2.5px;}
.goOthers li.half {width:50%;}
.thanksgivingKwd {padding:21px 0 12px; background:#f3f3f3;}
.thanksgivingKwd h3 {width:52%; margin:0 auto; padding-bottom:20px;}
.thanksgivingKwd ul {overflow:hidden; padding:0 6.25%;}
.thanksgivingKwd li {float:left; width:33.33333%; padding:0 3.2% 25px; text-align:center;}
.giftItemList .priceTab {overflow:hidden; width:101%;}
.giftItemList .priceTab li {float:left; width:33.33333%; text-align:center;}
.giftItemList .priceTab li a {display:block; margin-right:2px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65724/bg_tab_off.png) no-repeat 0 0; background-size:100% 100%;}
.giftItemList .priceTab li a.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/65724/bg_tab_on.png);}
.giftItemList .pdtListWrap {overflow:hidden;}.
.giftItemList .pdtList li {padding-bottom:0;}
.giftItemList .pdtList .pdtCont {min-height:85px;}
@media all and (min-width:480px){
	.giftItemList .pdtList li {padding-bottom:0;}
	.giftItemList .pdtList .pdtCont {min-height:140px;}
}
</style>
<script type="text/javascript">
$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$(".ma").show();
		$(".mw").hide();
	}else{
		$(".ma").hide();
		$(".mw").show();
	}

	//초기 꿀팁 상품 세팅
	getTipItemInfo();

	//초기 상품목록 세팅
	getEvtItemList('nav01',<%=chkIIF(application("Svr_Info")="Dev","136698","157450")%>);
});

function pageup(){
	window.$('html,body').animate({scrollTop:$("#itemlist").offset().top+600}, 0);
}

// 꿀팁 상품 출력
function getTipItemInfo() {
	$.ajax({
		type:"POST",
		url: "/event/etc/inc_65820_rndItem.asp",
		cache: false,
		success: function(message) {
			$("#lyrRcmItem").html(message);
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}

// 상품 목록 출력
function getEvtItemList(no,egc) {
	$(".priceTab li a").removeClass("on");
	$("#"+no+">a").addClass("on");

	$.ajax({
		type:"POST",
		url: "/event/etc/inc_65724_itemlist.asp",
		data: "eGC="+egc,
		cache: false,
		success: function(message) {
			$("#lyrTabItemList").html(message);
			<% if isApp then %>
			// 순차 로딩
			$("img.lazy").lazyload().removeClass("lazy");
			<% end if %>
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
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

// 탭구분상품 이벤트 이동
function goEventLinktab(evt,eGc) {
	<% if isApp then %>
		fnAPPpopupBrowserURL("이벤트","<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid="+evt+"&eGc="+eGc,"","");
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt+'&eGc='+eGc;
	<% end if %>
	return false;
}
</script>

	<!-- 한가위만 같아라(추석메인) -->
	<div class="mEvt65724">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/tit_thanksgiving_v2.gif" alt="한가위만 같아라" /></h2>
		<!--<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/img_rooftop.gif" alt="지붕이미지" /></div>-->
		<!-- 오늘의 상품 -->
		<div class="todayItem">
			<div class="mainItem">
				<div id="lyrRcmItem"><!-- 꿀팁 상품 정보 --></div>
				<button type="button" onclick="getTipItemInfo()" class="btnRefresh"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/btn_refresh.png" alt="새로고침"></button>
			</div>
			<a href="eventmain.asp?eventid=65820" onclick="goEventLink('65820');return false;" class="btnMore"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/btn_more_v2.png" alt="more"></a>
		</div>
		<!--// 오늘의 상품 -->
		<ul class="goOthers">
			<li class="half"><a href="eventmain.asp?eventid=65699" onclick="goEventLinktab('65699','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/bnr_evt_65699_01.jpg" alt="옛 정성 그대로" /></a></li>
			<li class="half"><a href="eventmain.asp?eventid=65699&amp;eGc=157378" onclick="goEventLinktab('65699','157378');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/bnr_evt_65699_02.jpg" alt="트렌디한 선물" /></a></li>
			<li><a href="eventmain.asp?eventid=65699&amp;eGc=157379" onclick="goEventLinktab('65699','157379');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/bnr_evt_65699_03.jpg" alt="추석 상차림 어렵지 않아요" /></a></li>
			<li><a href="eventmain.asp?eventid=65725" onclick="goEventLink('65725');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/bnr_evt_65725.gif" alt="상차림, 반조리식품으로" /></a></li>
			<li><a href="eventmain.asp?eventid=65666" onclick="goEventLink('65666');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/bnr_evt_65666.gif" alt="나 그대에게~용돈 드리리~!" /></a></li>
			<li><a href="eventmain.asp?eventid=65735" onclick="goEventLink('65735');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/bnr_evt_65735.gif" alt="나 추석에 여행갔다 올게!" /></a></li>
		</ul>
		<div class="thanksgivingKwd">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/tit_keyword.gif" alt="KEYWORD" /></h3>
			<ul>
				<li><a href="eventmain.asp?eventid=65818" onclick="goEventLink('65818');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/img_keyword01.jpg" alt="#곶감" /></a></li>
				<li><a href="eventmain.asp?eventid=65821" onclick="goEventLink('65821');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/img_keyword02.jpg" alt="#손맛비결" /></a></li>
				<li><a href="eventmain.asp?eventid=65824" onclick="goEventLink('65824');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/img_keyword03.jpg" alt="#커피타임" /></a></li>
				<li><a href="eventmain.asp?eventid=65825" onclick="goEventLink('65825');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/img_keyword04.jpg" alt="#이너뷰티" /></a></li>
				<li><a href="eventmain.asp?eventid=65822" onclick="goEventLink('65822');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/img_keyword05.jpg" alt="#조리도구" /></a></li>
				<li><a href="eventmain.asp?eventid=65827" onclick="goEventLink('65827');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/img_keyword06.jpg" alt="#추석빔" /></a></li>
			</ul>
		</div>
		<!-- 가격대별 추석선물 -->
		<div class="giftItemList">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/tit_vip_gift.gif" alt="귀빈 대접받는 추석선물" /></h3>
			<ul class="priceTab">
				<!-- for dev msg : 현재 선택된 탭에 클래스 on 붙여주세요 -->
				<li id="nav01"><a href="" onclick="getEvtItemList('nav01',<%=chkIIF(application("Svr_Info")="Dev","136698","157450")%>); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/txt_price01.png" alt="1~3만원" /></a></li>
				<li id="nav02"><a href="" onclick="getEvtItemList('nav02',<%=chkIIF(application("Svr_Info")="Dev","136700","157456")%>); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/txt_price02.png" alt="3~5만원" /></a></li>
				<li id="nav03"><a href="" onclick="getEvtItemList('nav03',<%=chkIIF(application("Svr_Info")="Dev","136701","157462")%>); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/txt_price03.png" alt="5~10만원" /></a></li>
			</ul>
			<div id="lyrTabItemList"><!-- 상품 목록 --></div>
		</div>
		<!--// 가격대별 추석선물 -->
		<div><a href="eventmain.asp?eventid=65723" onclick="goEventLink('65723');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65724/bnr_go_wish.gif" alt="소원을 말해봐 이벤트 참여하러 가기" /></a></div>
	</div>
	<!--// 한가위만 같아라 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->