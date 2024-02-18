<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : LET’S GO OUT! / MD기획전 (GNB)
' History : 2015.05.07 허진원 생성
'			2015.05.19 한용민 수정
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include Virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
	dim eCode
	dim cEvent, cEventItem, arrItem, arrGroup, intI, intG
	dim egCode, itemlimitcnt,iTotCnt
	dim eitemsort

	'// 메인 상품 표시를 위한 이벤트 코드
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  "61781"
	Else
		eCode   =  "62315"
	End If

	IF egCode = "" THEN egCode = 0
	itemlimitcnt = 10	'상품최대갯수
	eitemsort = 1		'정렬방법

	'메인 이벤트 상품목록 접수 (랜덤 1)
	dim renloop
	dim dmIID, dmINM, dmMkr, dmIMg, dmPrc, dmDsc
	set cEventItem = new ClsEvtItem
	cEventItem.FECode 	= eCode
	cEventItem.FEGCode 	= egCode
	cEventItem.FEItemCnt= itemlimitcnt
	cEventItem.FItemsort= eitemsort
	cEventItem.fnGetEventItem
	iTotCnt = cEventItem.FTotCnt
	IF (iTotCnt >= 0) THEN
		randomize
		renloop=int(Rnd*(iTotCnt+1))
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

%>
<style type="text/css">
.mEvt62313 img {width:100%; vertical-align:top;}
.mEvt62313 .anotherEvent {padding-bottom:9.5%;}
.mEvt62313 .anotherEvent li {position:relative; overflow:hidden; width:100%; padding-bottom:0.6%;}
.mEvt62313 .anotherEvent li.half {float:left; width:50%;}
.mEvt62313 .anotherEvent li a {display:block; position:absolute; left:0; top:0; width:100%; height:100%; color:transparent; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%;}
.mEvt62313 .dontMiss {padding-bottom:40px; background:#88ddbe url(http://webimage.10x10.co.kr/eventIMG/2015/62313/bg_product.gif) 0 0 no-repeat; background-size:100% auto;}
.mEvt62313 .dontMiss .missBox {position:relative; text-align:center; width:72%; padding:0 4px 20px; margin:0 auto; border-radius:22px; background:#fff;}
.mEvt62313 .dontMiss .missBox h3 {width:74%; margin:0 auto;}
.mEvt62313 .dontMiss .missBox .pName {padding-top:14px;}
.mEvt62313 .dontMiss .missBox .pPrice {padding-top:5px;}
.mEvt62313 .dontMiss .missBox .viewMore {position:absolute; left:50%; bottom:-3.5%; width:28%; margin-left:-14%;}
.mEvt62313 .mustHaveItem {overflow:hidden;}
.mEvt62313 .navigator {overflow:hidden; width:101%;}
.mEvt62313 .navigator li {position:relative; float:left; width:33%; padding:0 1px 9px 0;}
.mEvt62313 .navigator li:last-child {width:34%; padding-right:0;}
.mEvt62313 .navigator li a {display:block; width:100%; padding:25px 0; text-align:center; font-size:15px; color:#fff; font-weight:600; background:#36ab8e;}
.mEvt62313 .navigator li span {display:none; position:absolute; left:50%; bottom:1px; width:19px; height:8px; margin-left:-10px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/62313/blt_tab_on.png) left top repeat-x; background-size:100% 100%;}
.mEvt62313 .navigator li.on a {background:#ff8975;}
.mEvt62313 .navigator li.on span {display:block;}
@media all and (min-width:480px){
	.mEvt62313 .dontMiss {padding-bottom:60px;}
	.mEvt62313 .dontMiss .missBox {padding:0 6px 30px; border-radius:33px;}
	.mEvt62313 .dontMiss .missBox .pName {padding-top:21px;}
	.mEvt62313 .dontMiss .missBox .pPrice {padding-top:7px;}
	.mEvt62313 .navigator li {padding:0 1px 13px 0;}
	.mEvt62313 .navigator li a {padding:38px 0; font-size:23px;}
	.mEvt62313 .navigator li span {width:29px; height:12px; margin-left:-15px;}
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

	//초기 상품목록 세팅
	getEvtItemList('nav01',<%=chkIIF(application("Svr_Info")="Dev","133525","141674")%>);
});

// 상품 목록 출력
function getEvtItemList(no,egc) {
	$(".navigator li").removeClass("on");
	$("#"+no).addClass("on");
	$.ajax({
		type:"POST",
		url: "/event/etc/inc_62313_itemlist.asp",
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
</script>
<!-- LET'S GO OUT! 캠핑기획전 -->
<div class="mEvt62313">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/62313/tit_go_camping_ver2.gif" alt="LET'S GO OUT! 돌아온 야외의 계절 아웃도어를 즐기자!" /></h2>
	<!-- DON'T MISS -->
	<div class="dontMiss">
		<div class="missBox">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/62313/tit_dont_miss.gif" alt="DON'T MISS" /></h3>
			<div class="missPdt">
				<div class="pPhoto">
					<a href="/category/category_itemPrd.asp?itemid=<%= dmIID %>" class="mw" target="_top"><img src="<%=dmIMg%>" alt="<%=replace(dmINM,"""","")%>" /></a>
					<a href="#" onclick="fnAPPpopupProduct('<%= dmIID %>'); return false;" class="ma"><img src="<%=dmIMg%>" alt="<%=replace(dmINM,"""","")%>" /></a>
				</div>
				<p class="pName">[<%=dmMkr%>] <%=dmINM%></p>
				<p class="pPrice"><%=formatNumber(dmPrc,0)%> 원
					<% if dmDsc<>"" then %><span class="cRd1">[<%=dmDsc%>]</span><% end if %>
				</p>
			</div>
			<div class="viewMore">
				<a href="/event/eventmain.asp?eventid=62315" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62313/btn_view_more.png" alt="MORE" /></a>
				<a href="#" onclick="fnAPPpopupEvent('62315'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62313/btn_view_more.png" alt="MORE" /></a>
			</div>
		</div>
	</div>
	<!--// DON'T MISS -->
	<ul class="anotherEvent">
		<li>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/62313/bnr_event01.jpg" alt="" />
			<a href="/event/eventmain.asp?eventid=62316" class="mw">CAMPING - 캠핑도 멀티 플레이 시대</a>
			<a href="#" onclick="fnAPPpopupEvent('62316'); return false;" class="ma">CAMPING - 캠핑도 멀티 플레이 시대</a>
		</li>
		<li class="half">
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/62313/bnr_event02.jpg" alt="" />
			<a href="/event/eventmain.asp?eventid=62317" class="mw">TRAVEL - 아직도 휴양지 가니? 우린 도시로 떠난다!</a>
			<a href="#" onclick="fnAPPpopupEvent('62317'); return false;" class="ma">TRAVEL - 아직도 휴양지 가니? 우린 도시로 떠난다!</a>
		</li>
		<li class="half">
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/62313/bnr_event03.jpg" alt="" />
			<a href="/event/eventmain.asp?eventid=62320" class="mw">PICNIC - 당신은 착한 피크닉 입니까?</a>
			<a href="#" onclick="fnAPPpopupEvent('62320'); return false;" class="ma">PICNIC - 당신은 착한 피크닉 입니까?</a>
		</li>
		<li>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/62313/bnr_event04.jpg" alt="" />
			<a href="/event/eventmain.asp?eventid=62321" class="mw">ACTIVE LIFE - 이제 슬슬 몸 좀 풀어볼까</a>
			<a href="#" onclick="fnAPPpopupEvent('62321'); return false;" class="ma">ACTIVE LIFE - 이제 슬슬 몸 좀 풀어볼까</a>
		</li>
		<li>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/62313/bnr_event05.jpg" alt="" />
			<a href="/event/eventmain.asp?eventid=62324" class="mw">FESTIVAL - 여러분! 즐길 준비 되셨나요?</a>
			<a href="#" onclick="fnAPPpopupEvent('62324'); return false;" class="ma">FESTIVAL - 여러분! 즐길 준비 되셨나요?</a>
		</li>
	</ul>
	<!-- MUST HAVE ITEM -->
	<div class="mustHaveItem">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/62313/tit_must_have_item.gif" alt="즐거운 아웃도어를 위한 MUST HAVE ITEM" /></h3>
		<div class="navigator">
			<ul>
				<li id="nav01" class="nav01"><span></span><a href="#" onclick="getEvtItemList('nav01',<%=chkIIF(application("Svr_Info")="Dev","133525","141674")%>); return false;">데이캠핑</a></li>
				<li id="nav02" class="nav02"><span></span><a href="#" onclick="getEvtItemList('nav02',<%=chkIIF(application("Svr_Info")="Dev","133526","141675")%>); return false;">솔로캠핑</a></li>
				<li id="nav03" class="nav03"><span></span><a href="#" onclick="getEvtItemList('nav03',<%=chkIIF(application("Svr_Info")="Dev","133527","141676")%>); return false;">패밀리캠핑</a></li>
			</ul>
		</div>
		<div id="lyrTabItemList"></div>
	</div>
	<!--// MUST HAVE ITEM -->
</div>
<!--// LET'S GO OUT! 캠핑기획전 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->