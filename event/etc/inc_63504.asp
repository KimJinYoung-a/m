<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : Rain for mobile & app
' History : 2015-06-12 이종화 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<%
dim currenttime , egCode , itemlimitcnt , eitemsort , cEventItem , itotcnt
	currenttime =  now()

	'currenttime = #06/01/2015 09:00:00#

dim eCode, eCodedisp
IF application("Svr_Info") = "Dev" THEN
	eCode   =  63775
	eCodedisp = 63775
Else
	eCode   =  63504
	eCodedisp = 63504
End If

dim topeCode, topeCodedisp
IF application("Svr_Info") = "Dev" THEN
	topeCode   =  63780
	topeCodedisp = 63780
Else
	topeCode   =  63492
	topeCodedisp = 63492
End If

dim userid, i
	userid = getloginuserid()

IF egCode = "" THEN egCode = 0
itemlimitcnt = 105	'상품최대갯수
eitemsort = 3		'정렬방법

'메인 이벤트 상품목록 접수 (랜덤 1)
dim renloop
dim dmIID, dmINM, dmMkr, dmIMg, dmPrc, dmDsc
set cEventItem = new ClsEvtItem
cEventItem.FECode 	= topeCode
cEventItem.FEGCode 	= egCode
cEventItem.FEItemCnt= itemlimitcnt
cEventItem.FItemsort= eitemsort
cEventItem.fnGetEventItem
iTotCnt = cEventItem.FTotCnt
IF (iTotCnt >= 0) THEN
	randomize
	renloop=int(Rnd*(10+1))
	dmIID = cEventItem.FCategoryPrdList(renloop).Fitemid
	dmINM = cEventItem.FCategoryPrdList(renloop).FItemName
	dmMkr = cEventItem.FCategoryPrdList(renloop).FBrandName
	dmIMg = cEventItem.FCategoryPrdList(renloop).FImageBasic
	dmPrc = cEventItem.FCategoryPrdList(renloop).getRealPrice
	IF cEventItem.FCategoryPrdList(renloop).IsSaleItem Then
		dmDsc = cEventItem.FCategoryPrdList(renloop).getSalePro
	End IF
end if
set cEventItem = Nothing

Dim ampm
	
	If hour(now()) >= 06 And hour(now()) <= 17 then
		ampm = "am"
	Else 
		ampm = "pm"
	End If 
%>
<style type="text/css">
img {vertical-align:top;}

.item {padding-bottom:10%; background:#cfd5f6 url(http://webimage.10x10.co.kr/eventIMG/2015/63504/am/bg_pattern.png) 50% 0 no-repeat; background-size:100% auto;}
.item .inner {position:relative; width:84.375%; margin:0 auto; padding:8% 0 7%; border-radius:20px; background-color:#fff;}
.item .inner {-webkit-box-shadow: 1px 3px 29px 4px rgba(37,135,160,0.2);
-moz-box-shadow: 1px 3px 29px 4px rgba(37,135,160,0.2);
box-shadow: 1px 3px 29px 4px rgba(37,135,160,0.2);}
.item .inner .linkarea {display:block; width:74%; margin:7% auto 0; text-align:center;}
.item .pPhoto {display:block; margin-bottom:5%; border:1px solid #d2d2d2;}
.item .pName {font-size:13px; line-height:1.375em;}
.item .pPrice {margin-top:2px;}
.item .btnmore {width:24%; position:absolute; bottom:-3.4%; left:50%; margin-left:-12%;}

.bnr {padding-top:12%;}
.bnr ul {overflow:hidden;}
.bnr ul .half {float:left; width:50%; margin:4% 0;}
.bnr ul .half a {display:block;}
.bnr ul li:nth-child(2) {padding-right:1.8%;}
.bnr ul li:nth-child(3) {padding-left:1.8%;}

.rainKeyword {position:relative; padding:20% 3% 15%;}
.rainKeyword h3 {position:absolute; top:8.5%; left:0; width:100%;}
.rainKeyword ul {overflow:hidden; padding:8% 4% 3%; border:2px solid #e2e6e6; border-radius:20px; background-color:#fff;}
.rainKeyword ul li {float:left; width:33.333%;}

.rainItem .navigator {width:100%; border-top:3px solid #fff;}
.rainItem .navigator:after {content:' '; display:block; clear:both;}
.rainItem .navigator li {float:left; width:33.333%; text-align:center;}
.rainItem .navigator li a {display:block; position:relative; height:0; padding:15% 0 30%; border-left:3px solid #fff; background-color:#bdf0f7; color:#36c3d6; font-size:18px; font-weight:bold; line-height:22px;}
.rainItem .navigator li:first-child a {border-left:1px solid #2db7da;}
.rainItem .navigator li a span {position:absolute; top:0; left:0; width:100%; height:100%;}
.rainItem .navigator li a.on {background-color:#6e78e1; color:#fff;}
.rainItem .navigator li a.on:after {content:' '; position:absolute; bottom:-13px; left:50%; width:26px; height:13px; margin-left:-13px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/63504/am/bg_nav_on.png) 50% 0 no-repeat; background-size:100% auto;}
.rainItem .navigator li:first-child a.on {border-left:1px solid #6e78e1;}

#lyrTabItemList {padding:7% 3% 0;}
#lyrTabItemList .pdtListWrap {background:none;}
#lyrTabItemList .pdtList li {background-position:0 0;}
#lyrTabItemList .pdtList li:nth-child(1), #lyrTabItemList .pdtList li:nth-child(2) {background:none;}

@media all and (min-width:480px){
	.item .pName {font-size:19px;}
}

@media all and (min-width:600px){
	.rainItem .navigator li a {font-size:27px; line-height:30px;}
	.rainItem .navigator li a.on:after {bottom:-20px; width:40px; height:20px; margin-left:-20px;}
}
<% if ampm = "pm" then %>
/* pm css */
.item {background:#525a7c url(http://webimage.10x10.co.kr/eventIMG/2015/63504/pm/bg_pattern.png) 50% 0 no-repeat; background-size:100% auto;}

.rainKeyword h3 {top:8%;}

.rainItem .navigator li a {background-color:#a2d7f6; color:#4769b6;}
.rainItem .navigator li a.on:after {background:url(http://webimage.10x10.co.kr/eventIMG/2015/63504/pm/bg_nav_on.png) 50% 0 no-repeat; background-size:100% auto;}
.rainItem .navigator li a.on {background-color:#55587a;}
.rainItem .navigator li:first-child a.on {border-left:1px solid #55587a;}
<% end if %>
</style>
<script type='text/javascript'>
$(function(){
	//초기 상품목록 세팅
	getEvtItemList('nav01',<%=chkIIF(application("Svr_Info")="Dev","135312","148245")%>);
});

// 상품 목록 출력
function getEvtItemList(no,egc) {
	$(".navigator li a").removeClass("on");
	$("#"+no).addClass("on");

	$.ajax({
		type:"POST",
		url: "/event/etc/inc_63504_itemlist.asp",
		data: "eGC="+egc,
		cache: false,
		success: function(message) {
			$("#lyrTabItemList").html(message);
			<% if isApp then %>
			// 순차 로딩
//			$("img.lazy").lazyload().removeClass("lazy");
			<% end if %>
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}
</script>
<div class="mEvt63504">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/<%=ampm%>/tit_rain.gif" alt="Happy Rainy Day 비가 오는 날엔" /></h2>
	<div class="item">
		<div class="inner">
			<!-- for dev msg : 이미지 교체 -->
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/<%=ampm%>/tit_item.png" alt="함께하면 즐거운 아이템!" /></h3>
			<% if isApp then %>
			<a href="" onclick="fnAPPpopupProduct('<%= dmIID %>'); return false;" class="linkarea">
			<% Else %>
			<a href="/category/category_itemPrd.asp?itemid=<%= dmIID %>" target="_top" class="linkarea">
			<% End If %>
				<span class="pPhoto"><img src="<%=dmIMg%>" alt="<%=replace(dmINM,"""","")%>" /></span>
				<p class="pBrand">[<%= dmMkr %>]</p>
				<p class="pName"><%=dmINM%></p>
				<p class="pPrice">
					<%=formatNumber(dmPrc,0)%>원
					<% if dmDsc<>"" then %> <span class="cRd1">[<%=dmDsc%>]</span><% end if %>
				</p>
			</a>
			<% if isApp then %>
				<div class="btnmore"><a href="" onclick="fnAPPpopupEvent('63492'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/btn_more.png" alt="함께하면 즐거운 아이템! 상품 더보기" /></a></div>
			<% Else %>
				<div class="btnmore"><a href="/event/eventmain.asp?eventid=63492" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/btn_more.png" alt="함께하면 즐거운 아이템! 상품 더보기" /></a></div>
			<% End If %>
		</div>
	</div>

	<div class="bnr">
		<ul>
			<% if isApp then %>
				<li><a href="" onclick="fnAPPpopupEvent('63428'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_bnr_01.jpg" alt="조금 젖어도 괜찮아 Rain Bag" /></a></li>
				<li class="half"><a href="" onclick="fnAPPpopupEvent('63493'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_bnr_02.jpg" alt="비오는 날의 Styling" /></a></li>
				<li class="half"><a href="" onclick="fnAPPpopupEvent('63495'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_bnr_03.jpg" alt="패션의 완성 Umbrella" /></a></li>
				<li><a href="" onclick="fnAPPpopupEvent('63503'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_bnr_04.jpg" alt="비가 오면 생각나는 Food" /></a></li>
			<% Else %>
				<li><a href="/event/eventmain.asp?eventid=63428" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_bnr_01.jpg" alt="조금 젖어도 괜찮아 Rain Bag" /></a></li>
				<li class="half"><a href="/event/eventmain.asp?eventid=63493" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_bnr_02.jpg" alt="비오는 날의 Styling" /></a></li>
				<li class="half"><a href="/event/eventmain.asp?eventid=63495" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_bnr_03.jpg" alt="패션의 완성 Umbrella" /></a></li>
				<li><a href="/event/eventmain.asp?eventid=63503" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_bnr_04.jpg" alt="비가 오면 생각나는 Food" /></a></li>
			<% End If %>
		</ul>
	</div>

	<div class="rainKeyword">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/<%=ampm%>/tit_keyword.png" alt="KEYWORD" /></h3>
		<ul>
			<% if isApp then %>
				<li><a href="" onclick="fnAPPpopupEvent('63497'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_keyword_01.jpg" alt="레인코트" /></a></li>
				<li><a href="" onclick="fnAPPpopupEvent('63498'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_keyword_02.jpg" alt="레인슈즈" /></a></li>
				<li><a href="" onclick="fnAPPpopupEvent('63499'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_keyword_03.jpg" alt="워터프루프" /></a></li>
				<li><a href="" onclick="fnAPPpopupEvent('63500'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_keyword_04.jpg" alt="제습기" /></a></li>
				<li><a href="" onclick="fnAPPpopupEvent('63501'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_keyword_05.jpg" alt="우산꽂이" /></a></li>
				<li><a href="" onclick="fnAPPpopupEvent('63502'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_keyword_06.jpg" alt="키즈" /></a></li>
			<% else %>
				<li><a href="/event/eventmain.asp?eventid=63497" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_keyword_01.jpg" alt="레인코트" /></a></li>
				<li><a href="/event/eventmain.asp?eventid=63498" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_keyword_02.jpg" alt="레인슈즈" /></a></li>
				<li><a href="/event/eventmain.asp?eventid=63499" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_keyword_03.jpg" alt="워터프루프" /></a></li>
				<li><a href="/event/eventmain.asp?eventid=63500" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_keyword_04.jpg" alt="제습기" /></a></li>
				<li><a href="/event/eventmain.asp?eventid=63501" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_keyword_05.jpg" alt="우산꽂이" /></a></li>
				<li><a href="/event/eventmain.asp?eventid=63502" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/img_keyword_06.jpg" alt="키즈" /></a></li>
			<% end if %>
		</ul>
	</div>

	<div class="rainItem">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/63504/<%=ampm%>/tit_rain_item.png" alt="RAIN ITEM" /></h3>
		<ul class="navigator">
			<li><a href="" id="nav01" onclick="getEvtItemList('nav01',<%=chkIIF(application("Svr_Info")="Dev","135312","148245")%>); return false;"><span></span>BEST</a></li>
			<li><a href="" id="nav02" onclick="getEvtItemList('nav02',<%=chkIIF(application("Svr_Info")="Dev","135313","148246")%>); return false;"><span></span>NEW</a></li>
			<li><a href="" id="nav03" onclick="getEvtItemList('nav03',<%=chkIIF(application("Svr_Info")="Dev","135314","148247")%>); return false;"><span></span>SALE</a></li>
		</ul>

		<% '상품 list %>
		<div id="lyrTabItemList"></div>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->