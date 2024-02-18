<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [2015 FW 웨딩] 모바일 main 
' History : 2015-09-15 유태욱 생성
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
dim eCode, renloop, egCode
dim currenttime
	currenttime =  now()
	'currenttime = #09/23/2015 09:00:00#

IF application("Svr_Info") = "Dev" THEN
	eCode   =  64886
Else
	eCode   =  66144 '//이벤트 메인 상품리스트
End If

dim userid, i
	userid = GetEncLoginUserID()

randomize
renloop=int(Rnd*10)+1

if renloop = 1 then
	IF application("Svr_Info") = "Dev" THEN
		egCode="136711"
	else
		egCode="160002"
	end if
elseif renloop = 2 then
	IF application("Svr_Info") = "Dev" THEN
		egCode="136712"
	else
		egCode="160003"
	end if
elseif renloop = 3 then
	IF application("Svr_Info") = "Dev" THEN
		egCode="136713"
	else
		egCode="160004"
	end if
elseif renloop = 4 then
	IF application("Svr_Info") = "Dev" THEN
		egCode="136714"
	else
		egCode="160005"
	end if
elseif renloop = 5 then
	IF application("Svr_Info") = "Dev" THEN
		egCode="136715"
	else
		egCode="160006"
	end if	
elseif renloop = 6 then
	IF application("Svr_Info") = "Dev" THEN
		egCode="136716"
	else
		egCode="160007"
	end if
elseif renloop = 7 then
	IF application("Svr_Info") = "Dev" THEN
		egCode="136717"
	else
		egCode="160008"
	end if
elseif renloop = 8 then
	IF application("Svr_Info") = "Dev" THEN
		egCode="136718"
	else
		egCode="160009"
	end if
elseif renloop = 9 then
	IF application("Svr_Info") = "Dev" THEN
		egCode="136719"
	else
		egCode="160010"
	end if
else
	IF application("Svr_Info") = "Dev" THEN
		egCode="136720"
	else
		egCode="160011"
	end if
end if
	
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt66144 {padding-bottom:8%; background:#ebeded;}
.mEvt66144 .btnMore {display:block; width:38%; margin:0 auto;}
.todayItem {position:relative; padding-bottom:12%; background:#f2f2f2 url(http://webimage.10x10.co.kr/eventIMG/2015/66144/bg_stripe_v1.png) no-repeat 0 0; background-size:100% auto;}
.todayItem h3 {display:none;}
.todayItem .figure {position:relative; width:88%; margin:0 auto; padding:4px; border:3px solid #fff; text-align:center;}
.todayItem .relatedPdt {overflow:hidden; width:89%; margin:0 auto; padding:5.3% 0;}
.todayItem .relatedPdt li {float:left; width:33.33333%; padding:0 3%; text-align:center;}
.todayItem .relatedPdt li .pName {position:relative; height:23px; font-size:11px; font-weight:600; padding-top:0; margin-top:-5px; color:#222; z-index:100; overflow:hidden; text-overflow:ellipsis; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; word-wrap:break-word;}
.todayItem .relatedPdt li .pPrice {font-size:11px; color:#999; padding-top:2px;}
.todayItem .relatedPdt li .pPrice span {display:block;}
.todayItem .relatedPdt li .num {position:relative; display:block; width:30px; margin:-12px auto 0; z-index:50;}
.goOthers {overflow:hidden;}
.goOthers li {padding-top:2px;}
.weddingKwd {padding:13% 0; background:#fff;}
.weddingKwd h3 {width:32%; margin:0 auto;}
.weddingKwd ul {overflow:hidden; padding:2% 3.125% 0;}
.weddingKwd li {float:left; width:33.33333%; padding:4.8% 0 0;}
.specialSale {padding:7% 6.25% 10%; background:#f6d2d5;}
.specialSale h3 {width:57%; margin:0 auto; padding:4.5% 0 10%;}
.specialSale .mainItem {position:relative; padding:50px 14% 25px; text-align:center; background:#fff url(http://webimage.10x10.co.kr/eventIMG/2015/66144/bg_ribon.gif) no-repeat 50% 18px; background-size:11% auto;}
.specialSale .mainItem:after {content:' '; display:inline-block; position:absolute; left:0; top:-5px; width:100%; height:5px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/66144/bg_wave.png) repeat-x 0 0; background-size:auto 5px;}
.specialSale .mainItem .pName {font-size:12px; color:#222; padding-top:14px;}
.specialSale .mainItem .pPrice {font-size:11px; color:#000; padding:7px 0 14px;}
.specialSale .btnMore {width:60%;}
.brandSale h3 {width:35%; margin:0 auto; padding:27px 0 15px;}
.brandSale ul {padding:0 6.25%;}
.brandSale li {padding-top:6px;}
@media all and (min-width:480px){
	.todayItem .figure {padding:6px; border:4px solid #fff;}
	.todayItem .relatedPdt li .pName {height:35px; font-size:17px; margin-top:-7px;}
	.todayItem .relatedPdt li .pPrice {font-size:17px; padding-top:3px;}
	.todayItem .relatedPdt li .num {width:45px; margin:-18px auto 0;}
	.goOthers li {padding-top:3px;}
	.specialSale .mainItem {padding:75px 14% 38px;}
	.specialSale .mainItem:after {top:-7px; height:7px; background-size:auto 7px;}
	.specialSale .mainItem .pName {font-size:18px; padding-top:21px;}
	.specialSale .mainItem .pPrice {font-size:17px; padding:11px 0 21px;}
	.brandSale h3 {padding:41px 0 23px;}
	.brandSale li {padding-top:9px;}
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
	getEvtItemList(<%=egCode%>);
});

function pageup(){
	window.$('html,body').animate({scrollTop:$("#itemlist").offset().top+600}, 0);
}

// 꿀팁 상품 출력
function getTipItemInfo() {
	$.ajax({
		type:"POST",
		url: "/event/etc/inc_66144_rndItem.asp",
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
function getEvtItemList(egc) {
	$.ajax({
		type:"POST",
		url: "/event/etc/inc_66144_itemlist.asp",
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

</script>
	<!-- 내게 너무 완벽한 웨딩 -->
	<div class="mEvt66144">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/tit_perfect_wedding_v1.gif" alt="내게 너무 완벽한 Wedding - 복잡하고 번거로운 웨딩이 싫다면 주목 해주세요" /></h2>
		<div id="lyrTabItemList"><!-- 상품 목록 --></div>

		<ul class="goOthers">
			<li><a href="" onclick="goEventLink('66145'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_evt_01.gif" alt="가구 고르는 노하우" /></a></li>
			<li><a href="" onclick="goEventLink('66146'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_evt_02.gif" alt="신혼 공간 스타일링" /></a></li>
			<li><a href="" onclick="goEventLink('66147'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_evt_03.gif" alt="센스있는 셀프웨딩" /></a></li>
		</ul>
		<div class="weddingKwd">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/tit_keyword_v1.gif" alt="KEYWORD" /></h3>
			<ul>
				<li><a href="" onclick="goEventLink('66148'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/img_keyword01.jpg" alt="#화장대" /></a></li>
				<li><a href="" onclick="goEventLink('66149'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/img_keyword02.jpg" alt="#2인소파" /></a></li>
				<li><a href="" onclick="goEventLink('66150'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/img_keyword03.jpg" alt="#침실조명" /></a></li>
				<li><a href="" onclick="goEventLink('66151'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/img_keyword04.jpg" alt="#포토테이블" /></a></li>
				<li><a href="" onclick="goEventLink('66152'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/img_keyword05.jpg" alt="#식기세트" /></a></li>
				<li><a href="" onclick="goEventLink('66153'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/img_keyword06.jpg" alt="#침구세트" /></a></li>
			</ul>
		</div>
		<!-- SPECIAL SALE -->
		<div class="specialSale">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/tit_special_sale_v2.png" alt="WEDDING SPECIAL SALE" /></h3>
			<div class="mainItem" id="lyrRcmItem">
			</div>
		</div>
		<!--// SPECIAL SALE -->
		<% If left(currenttime,10)<"2015-10-06" Then %>
			<div><a href="" onclick="goEventLink('66174'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_love_house.png" alt="LOVE HOUSE 이벤트 참여하러 가기" /></a></div>
		<% else %>
			<div><a href="" onclick="goEventLink('66393'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_love_house_v2.png" alt="LOVE HOUSE 이벤트 참여하러 가기" /></a></div>
		<% end if %>
		<!-- BRAND BIG SALE(17일 확정배너 들어갈 예정) -->
		<div class="brandSale">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/tit_brand_sale.png" alt="BRAND BIG SALE" /></h3>
			<ul>
				<li><a href="" onclick="goEventLink('66155'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_brand01.jpg" alt="디자이너스룸" /></a></li>
				<li><a href="" onclick="goEventLink('66156'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_brand02.jpg" alt="블루밍앤미" /></a></li>
				<li><a href="" onclick="goEventLink('66163'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_brand03.jpg" alt="데코뷰" /></a></li>
				<li><a href="" onclick="goEventLink('66158'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_brand04.jpg" alt="바이빔" /></a></li>
				<li><a href="" onclick="goEventLink('66169'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_brand05.jpg" alt="카모메키친" /></a></li>
				<li><a href="" onclick="goEventLink('66159'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_brand06.jpg" alt="두닷" /></a></li>
				<li><a href="" onclick="goEventLink('66162'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_brand07.jpg" alt="마틸라" /></a></li>
				<li><a href="" onclick="goEventLink('66157'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_brand08.jpg" alt="60세컨즈" /></a></li>
				<li><a href="" onclick="goEventLink('66167'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_brand09.jpg" alt="큐티폴" /></a></li>
				<li><a href="" onclick="goEventLink('66160'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_brand10.jpg" alt="판다스틱" /></a></li>
				<li><a href="" onclick="goEventLink('66164'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_brand11.jpg" alt="노르딕윈터" /></a></li>
				<li><a href="" onclick="goEventLink('66161'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_brand12.jpg" alt="스타일케이" /></a></li>
				<li><a href="" onclick="goEventLink('66168'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_brand13.jpg" alt="쓰임" /></a></li>
				<li><a href="" onclick="goEventLink('66165'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_brand14.jpg" alt="하우스레시피" /></a></li>
				<li><a href="" onclick="goEventLink('66166'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/bnr_brand15.jpg" alt="창신" /></a></li>
			</ul>
		</div>
		<!--// BRAND BIG SALE -->
	</div>
	<!--// 내게 너무 완벽한 웨딩 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->