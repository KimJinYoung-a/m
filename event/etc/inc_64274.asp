<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : vacance for mobile & app
' History : 2015-07-01 이종화 생성
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
dim eCode, eCodecmt
dim topeCode 

IF application("Svr_Info") = "Dev" THEN
	eCode   =  63793
	eCodecmt = 63793
	topeCode   =  63780
Else
	eCode   =  64274 '//이벤트 메인 상품리스트
	eCodecmt = 64302 '//코멘트 이벤트 코드
	topeCode   =  64275 '//이벤트 top 롤링 이벤트 코드
End If

dim userid, i
	userid = getloginuserid()

dim commentcount
commentcount = getcommentexistscount(userid, eCodecmt, "", "", "", "Y")

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
	iCPageSize = 5
else
	iCPageSize = 5
end if

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCodecmt
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
<style type="text/css">
img {vertical-align:top;}
.dontMiss {padding:18px 25px 47px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64274/bg_pool.gif) 0 0 no-repeat; background-size:100% 100%;}
.dontMiss .todayItem {position:relative; padding:10px 23px 25px; text-align:center; background:#fff; border-radius:6px; box-shadow:0 0 6px 0 rgba(0,61,218,.7);}
.dontMiss .todayItem h3 {width:48%; margin:0 auto; padding-bottom:10px;}
.dontMiss .todayItem .btnMore {position:absolute; left:50%; bottom:-13px; width:26%; margin-left:-13%;}
.dontMiss .todayItem .pBrand {font-size:11px;}
.dontMiss .todayItem .pName {font-size:13px;}
.dontMiss .todayItem .pPrice {font-size:12px;}
.anotherEvent {position:relative; background:#fff;}
.anotherEvent ul {overflow:hidden; padding-top:6px;}
.anotherEvent li {float:left; width:50%; padding:15px 1.5% 0;}
.anotherEvent li.fullBnr {width:100%; padding-left:0; padding-right:0;}
.anotherEvent .wave {position:absolute; left:0; bottom:0; width:100%; height:17px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64274/bg_wave01.png) 0 0 repeat-x; background-size:56px 100%;}
.vacanceKeyword h3 {width:63%; margin:0 auto; padding:23px 0 18px;}
.vacanceKeyword ul {overflow:hidden; padding:0 6px 20px;}
.vacanceKeyword li {float:left; width:33.33333%; padding:0 6px 20px;}
.travelItem {position:relative;}
.travelItem .trTab {padding:0 17px; background:#7ddcfb;}
.travelItem .trTab ul {overflow:hidden; padding-bottom:15px;}
.travelItem .trTab li {position:relative; float:left; width:33.33333%; padding:0 10px 7px; text-align:center;}
.travelItem .trTab li:after {content:' '; display:inline-block; position:absolute; left:50%; bottom:0; width:0; height:0; margin-left:-4px; border-style: solid; border-width:8px 5px 0 5px; border-color: #4ebfe5 transparent transparent transparent;}
.travelItem .trTab li a {display:block; font-size:15px; padding:8px 0 6px; font-weight:bold; color:#fff; background:#4ec0e5; border-radius:15px;}
.travelItem .trTab li.current a {color:#000; background:#fff;}
.travelItem .trTab li.current:after {border-color: #fff transparent transparent transparent;}
.travelItem .wave {position:absolute; left:0; top:0; width:100%; height:17px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64274/bg_wave02.png) 0 0 repeat-x; background-size:56px 100%;}
.travelItem .travelPdt {padding:0 10px 40px; text-align:center; background:#fff;}
.travelItem .pdtList li {padding-top:21px; padding-bottom:25px;}
.travelItem .pdtCont {min-height:50px;}
.travelItem .pBrand {font-size:11px;}
.travelItem .pName {font-size:13px;}
.travelItem .pPrice {font-size:12px;}
.travelItem .moreViewV15 {position:relative; margin-top:-2px; z-index:50; background:#fff;}
.travelItem .moreViewV15.fold span {min-width:35px; background-position:100% -41px;}
.vacationPlan {position:relative;}
.vacationPlan .wave {position:absolute; left:0; top:0; width:100%; height:17px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64274/bg_wave03.png) 0 0 repeat-x; background-size:56px 100%;}
.selectPlan {padding:1.5%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64274/bg_sea.jpg) 0 0 no-repeat; background-size:100% 100%;}
.selectPlan div {padding:0 3.2%; border:1px solid #d4d4d4; background:#fff; border-radius:3px;}
.selectPlan ul {padding:6px 0 20px;}
.selectPlan li {overflow:hidden; position:relative; border-bottom:1px solid #d4d4d4;}
.selectPlan li p {position:absolute; left:0; top:50%; margin-top:-11px; width:10%; text-align:center;}
.selectPlan li label {display:inline-block; width:100%; padding-left:10%;}
.selectPlan li label img {width:100%;}
.selectPlan textarea {display:block; width:100%; height:100px; padding:12px 8px; font-size:12px; color:#999; border:1px solid #d4d4d4; background:#f0feff;}
.selectPlan .button {display:block; width:48%; margin:15px auto;}
.planList {padding:50px 1% 0; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64274/bg_sand.jpg) 0 0 no-repeat; background-size:100% auto;}
.planList ul {padding-bottom:12px; background:url(http://fiximage.10x10.co.kr/m/2014/common/double_line.gif) 0 100% repeat-x; background-size:1px 1px;}
.planList ul li {padding:0 1.6% 15px; background-position:2% 0; background-repeat:no-repeat; background-size:66px auto;}
.planList ul li .pBox {position:relative; margin-left:22%; padding:0 8px; background:#fff; border-radius:8px;}
.planList ul li .pBox:after {content:' '; display:inline-block; position:absolute; left:-10px; top:11px; width:0; height:0; border-style: solid; border-width: 5px 10px 5px 0; border-color: transparent #fff transparent transparent; z-index:50;}
.planList ul li .pBox:before {content:' '; display:inline-block; position:absolute; left:-13px; top:8px; width:0; height:0; border-style: solid; border-width: 8px 13px 8px 0; z-index:40;}
.planList ul li .info {overflow:hidden; font-size:12px; padding:10px 6px 6px;color:#000; border-bottom:1px solid #e0e0e0;}
.planList ul li .info span {display:inline-block;}
.planList ul li .info .num {float:left;}
.planList ul li .info .writer {float:right;}
.planList ul li .txt {padding:9px 6px 12px; font-size:13px; line-height:1.2; color:#555;}
.planList ul li.p01 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64274/ico_plan01.png);}
.planList ul li.p01 .pBox {border:2px solid #ecd11b;}
.planList ul li.p02 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64274/ico_plan02.png);}
.planList ul li.p02 .pBox {border:2px solid #43baec;}
.planList ul li.p03 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64274/ico_plan03.png);}
.planList ul li.p03 .pBox {border:2px solid #7d8ce9;}
.planList ul li.p04 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64274/ico_plan04.png);}
.planList ul li.p04 .pBox {border:2px solid #f8a052;}
.planList ul li.p01 .pBox:before {border-color: transparent #ecd11b transparent transparent;}
.planList ul li.p02 .pBox:before {border-color: transparent #43baec transparent transparent;}
.planList ul li.p03 .pBox:before {border-color: transparent #7d8ce9 transparent transparent;}
.planList ul li.p04 .pBox:before {border-color: transparent #f8a052 transparent transparent;}
@media all and (min-width:480px){
	.dontMiss {padding:27px 38px 70px;}
	.dontMiss .todayItem {padding:15px 35px 43px; border-radius:9px;}
	.dontMiss .todayItem h3 {padding-bottom:15px;}
	.dontMiss .todayItem .btnMore {bottom:-22px;}
	.dontMiss .todayItem .pBrand {font-size:17px;}
	.dontMiss .todayItem .pName {font-size:20px;}
	.dontMiss .todayItem .pPrice {font-size:18px;}
	.anotherEvent ul {padding-top:9px;}
	.anotherEvent li {padding:23px 1.5% 0;}
	.anotherEvent .wave {height:26px; background-size:84px 100%;}
	.vacanceKeyword h3 {padding:35px 0 24px;}
	.vacanceKeyword ul {padding:0 9px 30px;}
	.vacanceKeyword li {padding:0 9px 30px;}
	.travelItem .trTab {padding:0 26px;}
	.travelItem .trTab ul {padding-bottom:23px;}
	.travelItem .trTab li {padding:0 15px 11px;}
	.travelItem .trTab li:after {margin-left:-6px; border-width:12px 7px 0 7px;}
	.travelItem .trTab li a {font-size:23px; padding:12px 0 9px; border-radius:23px;}
	.travelItem .wave {height:26px; background-size:84px 100%;}
	.travelItem .travelPdt {padding:0 15px 60px;}
	.travelItem .pdtList li {padding-top:30px; padding-bottom:38px;}
	.travelItem .pdtCont {min-height:75px;}
	.travelItem .pBrand {font-size:17px;}
	.travelItem .pName {font-size:20px;}
	.travelItem .pPrice {font-size:18px;}
	.travelItem .moreViewV15 {margin-top:-3px;}
	.travelItem .moreViewV15 span {background-position:100% 6px;}
	.travelItem .moreViewV15.fold span {background-position:100% -59px;}
	.vacationPlan .wave {height:26px; background-size:84px 100%;}
	.selectPlan div {border-radius:4px;}
	.selectPlan ul {padding:9px 0 30px;}
	.selectPlan li p {margin-top:-17px;}
	.selectPlan textarea {height:150px; padding:18px 12px; font-size:18px;}
	.selectPlan .button {margin:23px auto;}
	.planList {padding:75px 1% 0;}
	.planList ul {padding-bottom:18px;}
	.planList ul li {padding:0 1.6% 24px; background-size:99px auto;}
	.planList ul li .pBox {padding:0 12px; border-radius:12px;}
	.planList ul li .pBox:after {left:-15px; top:17px; border-width: 7px 15px 7px 0;}
	.planList ul li .pBox:before {left:-20px; top:12px;border-width: 12px 20px 12px 0;}
	.planList ul li .info {font-size:18px; padding:15px 9px 9px;}
	.planList ul li .txt {padding:12px 9px 18px; font-size:20px;}
	.planList ul li.p01 .pBox {border:3px solid #ecd11b;}
	.planList ul li.p02 .pBox {border:3px solid #43baec;}
	.planList ul li.p03 .pBox {border:3px solid #7d8ce9;}
	.planList ul li.p04 .pBox {border:3px solid #f8a052;}
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
	getEvtItemList('nav01',<%=chkIIF(application("Svr_Info")="Dev","135386","150376")%>);

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
	$(".trTab li").removeClass("current");
	$("#"+no).addClass("current");

	$.ajax({
		type:"POST",
		url: "/event/etc/inc_64274_itemlist.asp",
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
		<% If not( date() >= "2015-07-06" and date() <"2015-08-11" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>1 then %>
				alert("이벤트는 한번만 참여 가능 합니다.");
				return false;
			<% else %>
				var tmpspoint='';
				for (var i=0; i < frmcom.spoint.length ; i++){
					if (frmcom.spoint[i].checked){
						tmpspoint=frmcom.spoint[i].value;
					}
				}
				if (tmpspoint==''){
					alert('휴가일정을 선택 해주세요');
					return false;
				}

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
			parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
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
			parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	}

	if (frmcom.txtcomm.value == '어디로 여행가세요?'){
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
<div class="mEvt64274">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/tit_summer_vacance.gif" alt="SUMMER VACANCE - 여름휴가 어디로 떠나 볼까?" /></h2>

	<!-- Don't Miss -->
	<div class="dontMiss">
		<div class="todayItem">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/tit_dont_miss.gif" alt="Don't Miss" /></h3>
			<% if isApp then %>
			<a href="" onclick="fnAPPpopupProduct('<%= dmIID %>'); return false;">
			<% else %>
			<a href="/category/category_itemPrd.asp?itemid=<%= dmIID %>" target="_top">
			<% End If %>
				<div class="pPhoto"><img src="<%=dmIMg%>" alt="<%=replace(dmINM,"""","")%>" /></div>
				<p class="pBrand">[<%= dmMkr %>]</p>
				<p class="pName"><%=dmINM%></p>
				<p class="pPrice"><%=formatNumber(dmPrc,0)%>원 <% if dmDsc<>"" then %><span class="cRd1">[<%=dmDsc%>]</span><% end if %></p>
			</a>
			<div class="btnMore">
				<% if isApp then %>
				<a href="" onclick="fnAPPpopupEvent('64275'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/btn_more.png" alt="MORE" /></a>
				<% else %>
				<a href="/event/eventmain.asp?eventid=64275" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/btn_more.png" alt="MORE" /></a>
				<% end if %>
			</div>
		</div>
	</div>
	<!--// Don't Miss -->

	<!-- 관련 이벤트 -->
	<div class="anotherEvent">
		<% if isApp then %>
		<ul class="ma">
			<li class="fullBnr"><a href="#" onclick="fnAPPpopupEvent('64276'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/bnr_event01.jpg" alt="여행 가방은 쌌니?" /></a></li>
			<li><a href="#" onclick="fnAPPpopupEvent('64277'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/bnr_event02.jpg" alt="몸매 한번 봅시다" /></a></li>
			<li><a href="#" onclick="fnAPPpopupEvent('64278'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/bnr_event03.jpg" alt="따가운 햇빛 싫어" /></a></li>
			<li class="fullBnr"><a href="#" onclick="fnAPPpopupEvent('64279'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/bnr_event04.jpg" alt="한 살 이라도 어릴 때" /></a></li>
			<li class="fullBnr"><a href="#" onclick="fnAPPpopupEvent('64280'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/bnr_event05.jpg" alt="캠핑장, 예약 되나요?" /></a></li>
		</ul>
		<% Else %>
		<ul class="mw">
			<li class="fullBnr"><a href="/event/eventmain.asp?eventid=64276" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/bnr_event01.jpg" alt="여행 가방은 쌌니?" /></a></li>
			<li><a href="/event/eventmain.asp?eventid=64277" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/bnr_event02.jpg" alt="몸매 한번 봅시다" /></a></li>
			<li><a href="/event/eventmain.asp?eventid=64278" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/bnr_event03.jpg" alt="따가운 햇빛 싫어" /></a></li>
			<li class="fullBnr"><a href="/event/eventmain.asp?eventid=64279" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/bnr_event04.jpg" alt="한 살 이라도 어릴 때" /></a></li>
			<li class="fullBnr"><a href="/event/eventmain.asp?eventid=64280" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/bnr_event05.jpg" alt="캠핑장, 예약 되나요?" /></a></li>
		</ul>
		<% End If %>
		<div class="wave"></div>
	</div>
	<!--// 관련 이벤트 -->

	<!-- 바캉스 키워드 -->
	<div class="vacanceKeyword">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/tit_keyword.gif" alt="VACANCE KEYWORD" /></h3>
		<% if isApp then %>
		<ul class="ma">
			<li><a href="#" onclick="fnAPPpopupEvent('64282'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/img_keyword01.png" alt="#지도" /></a></li>
			<li><a href="#" onclick="fnAPPpopupEvent('64297'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/img_keyword02.png" alt="#안전" /></a></li>
			<li><a href="#" onclick="fnAPPpopupEvent('64298'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/img_keyword03.png" alt="#여권첩" /></a></li>
			<li><a href="#" onclick="fnAPPpopupEvent('64299'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/img_keyword04.png" alt="#PET" /></a></li>
			<li><a href="#" onclick="fnAPPpopupEvent('64300'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/img_keyword05.png" alt="#COOL" /></a></li>
			<li><a href="#" onclick="fnAPPpopupEvent('64301'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/img_keyword06.png" alt="#드라이브" /></a></li>
		</ul>
		<% Else %>
		<ul class="mw">
			<li><a href="/event/eventmain.asp?eventid=64282" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/img_keyword01.png" alt="#지도" /></a></li>
			<li><a href="/event/eventmain.asp?eventid=64297" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/img_keyword02.png" alt="#안전" /></a></li>
			<li><a href="/event/eventmain.asp?eventid=64298" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/img_keyword03.png" alt="#여권첩" /></a></li>
			<li><a href="/event/eventmain.asp?eventid=64299" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/img_keyword04.png" alt="#PET" /></a></li>
			<li><a href="/event/eventmain.asp?eventid=64300" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/img_keyword05.png" alt="#COOL" /></a></li>
			<li><a href="/event/eventmain.asp?eventid=64301" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/img_keyword06.png" alt="#드라이브" /></a></li>
		</ul>
		<% End If %>
	</div>
	<!--// 바캉스 키워드 -->

	<!-- 없으면 트러블 있으면 트래블 -->
	<div class="travelItem">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/tit_travel.gif" alt="없으면 트러블 있으면 트래블" /></h3>
		<div class="trTab">
			<ul>
				<li id="nav01"><a href="" onclick="getEvtItemList('nav01',<%=chkIIF(application("Svr_Info")="Dev","135385","150376")%>); return false;">디지털</a></li>
				<li id="nav02"><a href="" onclick="getEvtItemList('nav02',<%=chkIIF(application("Svr_Info")="Dev","135386","150377")%>); return false;">기내</a></li>
				<li id="nav03"><a href="" onclick="getEvtItemList('nav03',<%=chkIIF(application("Svr_Info")="Dev","135387","150378")%>); return false;">방수</a></li>
			</ul>
		</div>
		<% '아이템 리스트 %>
		<div class="travelPdt" id="lyrTabItemList"></div>
		<div class="wave"></div>
	</div>
	<!--// 없으면 트러블 있으면 트래블 -->

	<!--  코멘트 이벤트 참여 -->
	<div class="vacationPlan">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/tit_vacation.gif" alt="사장님, 휴가!! 다녀오겠습니다!" /></h3>
		<div class="selectPlan" id="commentlist">
		<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
		<input type="hidden" name="mode" value="add">
		<input type="hidden" name="pagereload" value="ON">
		<input type="hidden" name="iCC" value="1">
		<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
		<input type="hidden" name="userid" value="<%= userid %>">
		<input type="hidden" name="eventid" value="<%= eCodecmt %>">
		<input type="hidden" name="linkevt" value="<%= eCodecmt %>">
		<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
		<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>">
			<div>
				<ul>
					<li>
						<p><input type="radio" id="plan01" name="spoint" value="1" /></p>
						<label for="plan01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/txt_select01.jpg" alt="방콕:남이 대신 즐겨준 여행" /></label>
					</li>
					<li>
						<p><input type="radio" id="plan02" name="spoint" value="2" /></p>
						<label for="plan02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/txt_select02.jpg" alt="1박2일:하루 갈 건데, 귀찮죠?" /></label>
					</li>
					<li>
						<p><input type="radio" id="plan03" name="spoint" value="3" /></p>
						<label for="plan03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/txt_select03.jpg" alt="3박4일:여행 기분 좀 냅시다!" /></label>
					</li>
					<li>
						<p><input type="radio" id="plan04" name="spoint" value="4" /></p>
						<label for="plan04"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64274/txt_select04.jpg" alt="장기휴가:김대리~다시 올거지?" /></label>
					</li>
				</ul>
				<textarea name="txtcomm" id="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%>title="어디로 여행가세요?"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>어디로 여행가세요?<%END IF%></textarea>
				<span class="button btB1 btRed cWh1"><a href="" onclick="jsSubmitComment(frmcom); return false;">등록하기</a></span>
			</div>
		</form>
		<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
		<input type="hidden" name="mode" value="del">
		<input type="hidden" name="pagereload" value="ON">
		<input type="hidden" name="Cidx" value="">
		<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>">
		<input type="hidden" name="userid" value="<%= userid %>">
		<input type="hidden" name="eventid" value="<%= eCodecmt %>">
		<input type="hidden" name="linkevt" value="<%= eCodecmt %>">
		</form>
		</div>
		<div class="planList">
			<ul>
				<%
				IF isArray(arrCList) THEN
					For intCLoop = 0 To UBound(arrCList,2)
				%>
				<li class="p0<%=arrCList(3,intCLoop)%>">
					<div class="pBox">
						<div class="info">
							<span class="num">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%></span>
							<span class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%></span>
						</div>
						<p class="txt"><%=ReplaceBracket(db2html( arrCList(1,intCLoop) ))%></p>
					</div>
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
		<div class="wave"></div>
	</div>
	<!--// 코멘트 이벤트 참여 -->
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->