<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : cool
' History : 2015.05.29 한용민 생성
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
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim currenttime
	currenttime =  now()
	'currenttime = #06/01/2015 09:00:00#

dim eCode, eCodedisp
IF application("Svr_Info") = "Dev" THEN
	eCode   =  63793
	eCodedisp = 63793
Else
	eCode   =  63941
	eCodedisp = 63941
End If

dim topeCode, topeCodedisp
IF application("Svr_Info") = "Dev" THEN
	topeCode   =  63780
	topeCodedisp = 63780
Else
	topeCode   =  63234
	topeCodedisp = 63234
End If

dim userid, i
	userid = getloginuserid()

dim commentcount
commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, pagereload
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),2)

IF blnFull = "" THEN blnFull = True
IF blnBlogURL = "" THEN blnBlogURL = False

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 4		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 5		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 5		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end if

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEComment.FUserID = userid
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수
	
	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
set cEComment = nothing

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
	
dim cEvent, cEventItem, arrItem, arrGroup, intI, intG
dim egCode, itemlimitcnt,iTotCnt
dim eitemsort

	IF egCode = "" THEN egCode = 0
	itemlimitcnt = 105	'상품최대갯수
	eitemsort = 1		'정렬방법

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
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.container {background-color:#ebfbff;}
.content {padding-bottom:0;}
.mEvt63082 {background-color:#f4f7f7;}
.dontMiss {padding-bottom:10%; background:#83e6ff url(http://webimage.10x10.co.kr/eventIMG/2015/63082/bg_sea.png) 50% 0 no-repeat; background-size:100% auto;}
.dontMiss .item {position:relative; width:84.2%; margin:0 auto; padding:8% 0 10%; border-top-right-radius:20px; border-top-left-radius:20px; background-color:#fff;}
.dontMiss .item {-webkit-box-shadow: 10px 10px 24px 2px rgba(37,135,160,0.2);
-moz-box-shadow: 10px 10px 24px 2px rgba(37,135,160,0.2);
box-shadow: 10px 10px 24px 2px rgba(37,135,160,0.2);}
.dontMiss .item .inner {display:block; width:74%; margin:7% auto 0; text-align:center;}
.dontMiss .item .pBrand {color:#000;}
.dontMiss .item .pPrice {margin-top:12px;}
.dontMiss .item .btnmore {width:24%; position:absolute; bottom:-3.4%; left:50%; margin-left:-12%;}

.bnr {padding-top:10%;}
.bnr ul {overflow:hidden;}
.bnr ul li {margin-bottom:3%;}
.bnr ul li a {display:block;}
.bnr ul li:nth-child(2), .bnr ul li:nth-child(3) {float:left; width:50%;}
.bnr ul li:nth-child(2) a {margin-right:3%;}
.bnr ul li:nth-child(3) a {margin-left:3%;}

.coolKeyword {position:relative; padding:15% 3%;}
.coolKeyword h3 {position:absolute; top:9%; left:50%; width:54%; margin-left:-27%;}
.coolKeyword ul {overflow:hidden; padding:8% 5%; border:2px solid #e2e6e6; border-radius:20px; background-color:#fff;}
.coolKeyword ul li {float:left; width:33.333%;}

.coolItem .navigator {width:100%;}
.coolItem .navigator:after {content:' '; display:block; clear:both;}
.coolItem .navigator {background-color:#2db7da;}
.coolItem .navigator li {float:left; width:33.333%; text-align:center;}
.coolItem .navigator li a {display:block; position:relative; height:0; padding:20% 0 35%; border-left:3px solid #8cdff4; color:#046078; font-size:15px; font-weight:bold; line-height:1.5em;}
.coolItem .navigator li:first-child a {border-left:1px solid #2db7da;}
.coolItem .navigator li a span {position:absolute; top:0; left:0; width:100%; height:100%;}
.coolItem .navigator li a img {display:none; position:absolute; bottom:-10px; left:50%; width:20px; margin-left:-10px;}
.coolItem .navigator li a.on {background-color:#04708c; color:#fff;}
.coolItem .navigator li:first-child a.on {border-left:1px solid #04708c;}
.coolItem .navigator li a.on img {display:block;}

#lyrTabItemList {padding:7% 3%;}

#lyrTabItemList .moreView {position:relative; z-index:50; display:block; text-align:center; margin-top:-2px; padding:6px 0 8px 0; font-size:15px; line-height:1; border:1px solid #000; background:#f4f7f7; font-family:helveticaNeue, helvetica, sans-serif !important; cursor:pointer;}
#lyrTabItemList .moreView span {display:inline-block; padding-right:13px; background-image:url(http://fiximage.10x10.co.kr/m/2015/today/blt_up_down.png); background-repeat:no-repeat; background-size:9px 50px; background-position:100% -39px;}
#lyrTabItemList .hide span {background-position:100% 7px;}

.field {background-color:#a2e5f5;}
.field .inner {position:relative; padding:20px 105px 20px 30px;}
.field textarea {width:100%; height:75px; border:2px solid #2b85a2; border-radius:0; color:#999; font-size:12px;}
.field textarea:focus {color:#333;}
.field .inner .btnsubmit {position:absolute; top:20px; right:20px; width:75px;}
.field .inner .btnsubmit input {width:100%;}

.commentlist {padding-bottom:10%; background-color:#ebfbff;}
.commentlist ul {padding:0 15px;}
.commentlist li {position:relative; padding:15px 13px 12px; border-bottom:2px solid #dae7e9; font-size:11px; line-height:1.5em;}
.commentlist li strong {color:#333; font-weight:normal;}
.commentlist .no {display:block; color:#37b2cf;}
.commentlist .no img {width:8px; margin-left:3px; vertical-align:-2px;}
.commentlist p {margin-top:12px;}
.commentlist .id {display:block; margin-top:3px; color:#999; text-align:right;}
.btndel {position:absolute; top:13px; right:0; width:18px; height:18px; background:url(http://webimage.10x10.co.kr/playmo/ground/20150518/btn_del.png) no-repeat 50% 0; background-size:100% 100%; text-indent:-999em;}

@media all and (min-width:480px){
	.coolItem .navigator li a {font-size:17px;}
	#lyrTabItemList .moreView {padding:22px 0; margin-top:-3px; font-size:23px;}
	#lyrTabItemList .moreView span {padding-right:23px; background-size:14px 75px; background-position:right -57px;}
	#lyrTabItemList .hide span {background-position:right 9px;}

	.field textarea {font-size:16px;}
	.commentlist li {padding:28px 37px 27px; font-size:16px;}
	.commentlist .no img {width:12px; margin-left:3px; vertical-align:-4px;}
	.btndel {width:27px; height:27px;}
}

@media all and (min-width:600px){
	.coolItem .navigator li a {font-size:22px;}
	.coolItem .navigator li a img {display:none; position:absolute; bottom:-15px; left:50%; width:30px; margin-left:-15px;}
	.field textarea {height:130px; font-size:20px;}
	.field .inner {padding-right:170px;}
	.field .inner .btnsubmit {width:130px;}
}
</style>
<script type='text/javascript'>

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
	getEvtItemList('nav02',<%=chkIIF(application("Svr_Info")="Dev","135386","149107")%>);
	
	<% if pagereload<>"" then %>
		//pagedown();
		setTimeout("pagedown()",500);
	<% end if %>
});

function pagedown(){
	//document.getElementById('commentlist').scrollIntoView();
	window.$('html,body').animate({scrollTop:$("#commentlist").offset().top}, 0);
}

function pageup(){
	//document.getElementById('commentlist').scrollIntoView();
	window.$('html,body').animate({scrollTop:$("#itemlist").offset().top+600}, 0);
}

// 상품 목록 출력
function getEvtItemList(no,egc) {
	$(".navigator li a").removeClass("on");
	$("#"+no).addClass("on");

	$.ajax({
		type:"POST",
		url: "/event/etc/inc_63941_itemlist.asp",
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

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-06-01" and left(currenttime,10)<"2015-07-06" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>0 then %>
				alert("이벤트는 한번만 참여 가능 합니다.");
				return false;
			<% else %>
				if (frm.txtcomm.value == '' || GetByteLength(frm.txtcomm.value) > 400){
					alert("코맨트를 남겨주세요.\n400자 까지 작성 가능합니다.");
					frm.txtcomm.focus();
					return false;
				}

			   frm.action = "/event/lib/doEventComment.asp";
			   frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCodedisp)%>');
			return false;
		<% end if %>
		return false;
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmactNew.Cidx.value = cidx;
   		document.frmactNew.submit();
	}
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCodedisp)%>');
			return false;
		<% end if %>
		return false;
	}

	if (frmcom.txtcomm.value == '나만의 꿀팁을 공유해 주세요!'){
		frmcom.txtcomm.value = '';
	}	
}

//내코멘트 보기
function fnMyComment() {
	document.frmcom.isMC.value="<%=chkIIF(isMyComm="Y","N","Y")%>";
	document.frmcom.iCC.value=1;
	document.frmcom.submit();
}

</script>
</head>
<body>
<div class="mEvt63082">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/tit_cool_summer.png" alt="Cool SUMMER 오감꽁꽁 프로젝트" /></h2>

	<div class="dontMiss">
		<div class="item">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/tit_dont_miss.png" alt="DON&apos;T MISS" /></h3>
			<% '<!-- for dev msg : 매일 매일 상품 업데이트 됩니다. --> %>
			<% if isApp then %>
				<a href="" onclick="fnAPPpopupProduct('<%= dmIID %>'); return false;" class="inner">
			<% else %>
				<a href="/category/category_itemPrd.asp?itemid=<%= dmIID %>" target="_top" class="inner">
			<% end if %>
				<span class="pPhoto"><img src="<%=dmIMg%>" alt="<%=replace(dmINM,"""","")%>" /></span>
				<p class="pBrand">[<%= dmMkr %>]</p>
				<p class="pName"><%=dmINM%></p>
				<p class="pPrice">
					<%=formatNumber(dmPrc,0)%>원
					<% if dmDsc<>"" then %> <span class="cRd1">[<%=dmDsc%>]</span><% end if %>
				</p>
			</a>
			<div class="btnmore">
				<% if isApp then %>
					<a href="" onclick="fnAPPpopupEvent('63234'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/btn_more.png" alt="DON&apos;T MISS 상품 더보기" /></a>
				<% else %>
					<a href="/event/eventmain.asp?eventid=63234" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/btn_more.png" alt="DON&apos;T MISS 상품 더보기" /></a>
				<% end if %>
			</div>
		</div>
	</div>

	<div class="bnr">
		<ul>
			<% if isApp then %>
				<li><a href="" onclick="fnAPPpopupEvent('62949'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_bnr_01.gif" alt="또 치맥이야? 맥주와 어울리는 내 친구" /></a></li>
				<li><a href="" onclick="fnAPPpopupEvent('62950'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_bnr_02.jpg" alt="시원한 향기 프로방스의 시원함 가득" /></a></li>
				<li><a href="" onclick="fnAPPpopupEvent('62951'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_bnr_03.jpg" alt="앗, 차가워! 닭살돋는 느낌적인 느낌" /></a></li>
				<li><a href="" onclick="fnAPPpopupEvent('62953'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_bnr_04.gif" alt="어디까지 얼려봤니? 모두 다 얼려버려" /></a></li>
				<li><a href="" onclick="fnAPPpopupEvent('62954'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_bnr_05.gif" alt="잘 돌아간다 이거 없으면 잠 못 자" /></a></li>
			<% else %>
				<li><a href="/event/eventmain.asp?eventid=62949" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_bnr_01.gif" alt="또 치맥이야? 맥주와 어울리는 내 친구" /></a></li>
				<li><a href="/event/eventmain.asp?eventid=62950" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_bnr_02.jpg" alt="시원한 향기 프로방스의 시원함 가득" /></a></li>
				<li><a href="/event/eventmain.asp?eventid=62951" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_bnr_03.jpg" alt="앗, 차가워! 닭살돋는 느낌적인 느낌" /></a></li>
				<li><a href="/event/eventmain.asp?eventid=62953" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_bnr_04.gif" alt="어디까지 얼려봤니? 모두 다 얼려버려" /></a></li>
				<li><a href="/event/eventmain.asp?eventid=62954" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_bnr_05.gif" alt="잘 돌아간다 이거 없으면 잠 못 자" /></a></li>
			<% end if %>
		</ul>
	</div>

	<div class="coolKeyword">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/tit_cool_keyword.png" alt="COOL KEYWORD" /></h3>
		<ul>
			<% if isApp then %>
				<li><a href="" onclick="fnAPPpopupEvent('62991'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_keyword_01.jpg" alt="사무실" /></a></li>
				<li><a href="" onclick="fnAPPpopupEvent('62992'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_keyword_02.jpg" alt="린넨" /></a></li>
				<li><a href="" onclick="fnAPPpopupEvent('62993'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_keyword_03.jpg" alt="베이비" /></a></li>
				<li><a href="" onclick="fnAPPpopupEvent('63004'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_keyword_04.jpg" alt="애인선물" /></a></li>
				<li><a href="" onclick="fnAPPpopupEvent('62995'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_keyword_05.jpg" alt="캠핑" /></a></li>
				<li><a href="" onclick="fnAPPpopupEvent('62996'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_keyword_06.jpg" alt="간식" /></a></li>
			<% else %>
				<li><a href="/event/eventmain.asp?eventid=62991" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_keyword_01.jpg" alt="사무실" /></a></li>
				<li><a href="/event/eventmain.asp?eventid=62992" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_keyword_02.jpg" alt="린넨" /></a></li>
				<li><a href="/event/eventmain.asp?eventid=62993" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_keyword_03.jpg" alt="베이비" /></a></li>
				<li><a href="/event/eventmain.asp?eventid=63004" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_keyword_04.jpg" alt="애인선물" /></a></li>
				<li><a href="/event/eventmain.asp?eventid=62995" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_keyword_05.jpg" alt="캠핑" /></a></li>
				<li><a href="/event/eventmain.asp?eventid=62996" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/img_keyword_06.jpg" alt="간식" /></a></li>
			<% end if %>
		</ul>
	</div>

	<div class="coolItem">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/tit_cool_item.png" alt="COOL ITEM" /></h3>
		<ul class="navigator">
			<% '<!--  for dev msg : 선택된 탭에 클래스 on 붙여주세요 --> %>
			<li><a href="" id="nav01" onclick="getEvtItemList('nav01',<%=chkIIF(application("Svr_Info")="Dev","135385","149106")%>); return false;"><span></span>3만원 미만 <img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/bg_tab_on.png" alt="" /></a></li>
			<li><a href="" id="nav02" onclick="getEvtItemList('nav02',<%=chkIIF(application("Svr_Info")="Dev","135386","149107")%>); return false;"><span></span>5만원 미만 <img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/bg_tab_on.png" alt="" /></a></li>
			<li><a href="" id="nav03" onclick="getEvtItemList('nav03',<%=chkIIF(application("Svr_Info")="Dev","135387","149108")%>); return false;"><span></span>10만원 미만 <img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/bg_tab_on.png" alt="" /></a></li>
		</ul>

		<% '<!--  for dev msg : 가격대별 상품 뿌려지는 부분입니다. --> %>
		<div id="lyrTabItemList"></div>
	</div>

	<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
	<input type="hidden" name="mode" value="add">
	<input type="hidden" name="pagereload" value="ON">
	<input type="hidden" name="iCC" value="1">
	<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
	<input type="hidden" name="userid" value="<%= userid %>">
	<input type="hidden" name="eventid" value="<%= eCodedisp %>">
	<input type="hidden" name="linkevt" value="<%= eCode %>">
	<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
	<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCodedisp %>">
	<!-- comment event -->
	<div class="commentevt" id="commentlist">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/txt_comment_v3.jpg" alt="이 더위를 날려버릴 나만의 꿀팁을 공개해주세요! 베스트 팁을 남겨주신 20분을 추첨하여 조쿠 트리플 퀵팝 메이커를 드립니다. 이벤트 기간은 2015년 6월 1일부터 6월 15일까지며 당첨자 발표는 2015년 6월 17일입니다." /></p>
		<div class="field">
				<fieldset>
					<div class="inner">
						<textarea name="txtcomm" id="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> cols="50" rows="6" title="나만의 꿀팁 입력"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>나만의 꿀팁을 공유해 주세요!<%END IF%></textarea>
						<div class="btnsubmit"><input type="image" onclick="jsSubmitComment(frmcom); return false;" src="http://webimage.10x10.co.kr/eventIMG/2015/63082/btn_submit.png" alt="꿀 팁 작성하기" /></div>
					</div>
				</fieldset>
		</div>
	</div>
	</form>
	<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="pagereload" value="ON">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCodedisp %>">
	<input type="hidden" name="userid" value="<%= userid %>">
	<input type="hidden" name="eventid" value="<%= eCodedisp %>">
	<input type="hidden" name="linkevt" value="<%= eCode %>">
	</form>
	<!-- comment list -->
	<div class="commentlist">
		<ul>
			<% '<!-- for dev msg : 한 페이지당 5개씩 보여주세요 --> %>
			<%
			IF isArray(arrCList) THEN
				dim rndNo : rndNo = 1
				
				For intCLoop = 0 To UBound(arrCList,2)
				
				randomize
				rndNo = Int((12 * Rnd) + 1)
			%>
			<li>
				<span class="no">
					no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%>
					<% If arrCList(8,i) <> "W" Then %>
						 <img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/ico_mobile.png" alt="모바일에서 작성된 글" /></span>
					<% end if %>
					<p>
						<%=ReplaceBracket(db2html( arrCList(1,intCLoop) ))%>
					</p>
					<span class="id"><%=formatdate(arrCList(4,intCLoop),"00.00.00")%> / <%=printUserId(arrCList(2,intCLoop),2,"*")%></span>
					
					<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
						<button type="button" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;" class="btndel">삭제</button>
					<% end if %>
				</span>
			</li>

			<%
				Next
			end if
			%>
		</ul>

		<% IF isArray(arrCList) THEN %>
			<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
		<% end if %>
	</div>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->