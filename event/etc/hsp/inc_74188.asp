<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 DAILYLIKE 전기방석 M&A
' History : 2016-11-15 원승현 생성
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
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<%
dim currenttime
	currenttime =  now()
	'currenttime = #10/07/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66236
Else
	eCode   =  74188
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, pagereload, page
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= getNumeric(requestCheckVar(Request("iCC"),10))	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),2)

	page	= getNumeric(requestCheckVar(Request("page"),10))	'헤이썸띵 메뉴용 페이지 번호

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
'iCPageSize = 1

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
%>
<style type="text/css">
.finishEvt {display:none;}

.heySomething .app {display:none;}

/* title */
.heySomething .swiper-slide .hey {position:absolute; top:6.6%; left:0; width:100%;}

/* brand */
.heySomething .swiper-slide-brand a {display:block; position:absolute; top:0; left:0;  width:100%; height:100%;}
.heySomething .swiper-slide-brand .brand1 {top:11.45%; padding:0 31.25%;}
.heySomething .swiper-slide-brand .brand2 {top:25.04%; padding:0 17.34%;}

/* function */
.heySomething .swiper-slide-function p {position:absolute; top:9.86%; padding:0 14.06%;}

/* buy */
.heySomething .swiper-slide-buy {background-color:#fdfdfd;}
.heySomething .swiper-slide-buy a {display:block;}
.heySomething .swiper-slide-buy .option .discount {margin-bottom:1.7rem;}
.heySomething .swiper-slide-buy .option {text-align:center;}
.heySomething .swiper-slide-buy .name span {display:block; margin-top:5px; color:#999; font-size:10px; font-weight:bold;}
@media all and (min-width:480px){
	.heySomething .swiper-slide-buy .name span {margin-top:7px; font-size:15px;}
}

/* brand */
.heySomething .swiper-slide-brand .logo {position:absolute; top:5.625%; left:50%; width:20.93%; margin-left:-10.465%;}

/* event */
.heySomething .swiper-slide-event ul {padding-top:5%;}
.heySomething .swiper-slide-event ul li {margin-top:1.8%;}
.heySomething .swiper-slide-event ul li:first-child {margin-top:0;}

/* gallery */
.heySomething .swiper-slide-gallery ul {overflow:hidden; margin:-1.8% -1.5%;}
.heySomething .swiper-slide-gallery ul li {float:left; width:50%; padding:1.45% 0.75% 0;}

/* finish */
.swiper-slide-finish p {position:absolute; top:18.56%; left:0; width:100%;}

/* comment */
.heySomething .swiper-slide .btngo {top:70%;}
.heySomething .form .inner {padding:0 5%;}
.heySomething .form .choice {width:84.62%;}
.heySomething .form .choice li {width:33.333%; height:auto !important; margin:8% 0 0; padding:0 6.74% 0 0;}
.heySomething .form .choice li.ico1,
.heySomething .form .choice li.ico2,
.heySomething .form .choice li.ico3 {margin-top:0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/ico_01_off.jpg);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/ico_01_on.jpg);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/ico_02_off.jpg);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/ico_02_on.jpg);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/ico_03_off.jpg);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/ico_03_on.jpg);}
.heySomething .field {margin-top:3.6rem;}
.heySomething .field textarea {height:5.5rem;}
.heySomething .field input {width:5.5rem; height:5.5rem; font-size:0.9rem;}
.heySomething .commentlist ul {border-top:1px solid #ddd;}
.heySomething .commentlist ul li {position:relative; min-height:10rem; padding:2rem 0 2rem 7.75rem;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:0.1rem; width:6.7rem; height:8.5rem; margin-top:-4.2rem; background-repeat:no-repeat; background-position:50% 0 !important; background-size:100% auto;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/ico_01_off.jpg);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/ico_02_off.jpg);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/ico_03_off.jpg);}
.heySomething .commentlist ul li .mob img {width:0.9rem; margin-top:-0.1rem; margin-left:0.2rem;}
</style>
<script type="text/javascript">

$(function(){

	$(".hey").css({"opacity":"0"});
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:false,
		paginationClickable:true,
		speed:800,
		autoplay:false,
		nextButton:'.btn-next',
		prevButton:'.btn-prev',
		autoplayDisableOnInteraction:false,
		onSlideChangeStart: function (mySwiper) {
			var vActIdx = parseInt(mySwiper.activeIndex);
			if (vActIdx<=0) {
				vActIdx = mySwiper.slides.length-2;
			} else if(vActIdx>(mySwiper.slides.length-2)) {
				vActIdx = 1;
			}
			$(".pagingNo .page strong").text(vActIdx);

			$(".swiper-slide").find(".hey").delay(100).animate({"top":"8.5%", "opacity":"0"},300);
			$(".swiper-slide-active").find(".hey").delay(50).animate({"top":"6.6%", "opacity":"1"},600);

			$(".swiper-slide-brand").find(".brand1").delay(100).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide-brand").find(".brand2").delay(300).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-brand").find(".brand1").delay(50).animate({"margin-top":"0", "opacity":"1"},600);
			$(".swiper-slide-active.swiper-slide-brand").find(".brand2").delay(50).animate({"margin-top":"0", "opacity":"1"},600);
			
			$(".swiper-slide-function").find(".function").delay(100).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-function").find(".function").delay(50).animate({"margin-top":"0", "opacity":"1"},600);

			$(".swiper-slide-buy").find(".animation .opacity").removeClass("twinkle");
			$(".swiper-slide-active.swiper-slide-buy").find(".animation .opacity").addClass("twinkle");

			$(".swiper-slide-finish").find("p").delay(100).animate({"margin-top":"3%", "opacity":"0"},100);
			$(".swiper-slide-active.swiper-slide-finish").find("p").delay(50).animate({"margin-top":"0", "opacity":"1"},600);
		}
	});

	$('.pagingNo .page strong').text(1);
	$('.pagingNo .page span').text(mySwiper.slides.length-2);

	/* skip to comment */
	$(".btngo").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},800);
	});

	/* comment write ico select */
	$(".form .choice li:first-child button").addClass("on");
	frmcom.gubunval.value = '1';
	$(".form .choice li button").click(function(){
		frmcom.gubunval.value = $(this).val();
		$(".form .choice li button").removeClass("on");
		if ( $(this).hasClass("on")) {
			$(this).removeClass("on");
		} else {
			$(this).addClass("on");
		}
	});

	<% if pagereload<>"" then %>
		//pagedown();
		setTimeout("pagedown()",500);
	<% else %>
		setTimeout("pagup()",500);
	<% end if %>

	<% ''헤이썸띵 메뉴용 %>
	fnGetListHeader('<%=page%>');

	$("#navHey").hide();
	$("#hamburger").click(function(){
		if ($(this).hasClass("open")){
			$("#navHey").hide();
			$("#dimmed").hide();
			$(this).removeClass("open");
		} else {
			$("#navHey").show();
			$("#dimmed").show();
			$(this).addClass("open");
		}
		return false;
	});

	$("#dimmed").click(function(){
		$("#navHey").hide();
		$("#dimmed").hide();
		$("#hamburger").removeClass("open");
	});
	<% ''// 헤이썸띵 메뉴용 %>

});

function pagup(){
	window.$('html,body').animate({scrollTop:$("#toparticle").offset().top}, 0);
}

function pagedown(){
	//document.getElementById('commentlist').scrollIntoView();
	window.$('html,body').animate({scrollTop:$("#commentevt").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-11-15" and left(currenttime,10)<"2018-01-01" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if (frm.gubunval.value == ''){
					alert('원하는 아이콘을 선택해 주세요.');
					return false;
				}
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 400){
					alert("코맨트를 남겨주세요.\n400자 까지 작성 가능합니다.");
					frm.txtcomm1.focus();
					return false;
				}

				frm.txtcomm.value = frm.gubunval.value + '!@#' + frm.txtcomm1.value
				frm.action = "/event/lib/doEventComment.asp";
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
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
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	}

	//if (frmcom.txtcomm.value == ''){
	//	frmcom.txtcomm.value = '';
	//}	
}

//내코멘트 보기
function fnMyComment() {
	document.frmcom.isMC.value="<%=chkIIF(isMyComm="Y","N","Y")%>";
	document.frmcom.iCC.value=1;
	document.frmcom.submit();
}

<% ''헤이썸띵 메뉴용 %>
function fnGetListHeader(pg) {
	var str = $.ajax({
		type: "GET",
		url: "/event/etc/HSPheader.asp",
		data: "eventid=<%=eCode%>&page="+pg,
		dataType: "text",
		async: false
	}).responseText;
	if(str!="") {
		$("#HSPHeaderNew").empty().html(str);
		//document.getElementById("HSPList").innerHTML=str;
	}
}

function goHSPPageH(pg) {
	var str = $.ajax({
		type: "GET",
		url: "/event/etc/HSPheader.asp",
		data: "eventid=<%=eCode%>&page="+pg,
		dataType: "text",
		async: false
	}).responseText;
	if(str!="") {
		$("#HSPHeaderNew").empty().html(str);
		$("#navHey").show();
		$("#dimmed").show();
		$(this).addClass("open");
		//document.getElementById("HSPList").innerHTML=str;
	}
}
<% ''// 헤이썸띵 메뉴용 %>
</script>
<div class="heySomething">
<%''햄버거 메뉴%>
<a href="#navHey" title="Hey something project 메뉴" id="hamburger" class="hamburger">
	<span>
		<i></i>
		<i></i>
		<i></i>
	</span>
</a>
<div id="HSPHeaderNew"></div>
<%''//햄버거 메뉴%>
<%' main contents %>
	<div class="section article">
		<%' swiper %>
		<div class="swiper" id="toparticle">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project.png" alt="Hey, something project" /></strong>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/img_slide_01_v2.jpg" alt="" />
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>
					<div class="swiper-slide swiper-slide-brand">
						<% If isApp="1" Then %>
							<a href="/street/street_brand.asp?makerid=dailylike" onclick="fnAPPpopupBrand('dailylike'); return false;" class="mApp"></a>
						<% Else %>
							<a href="/street/street_brand.asp?makerid=dailylike" class="mWeb"></a>
						<% End If %>
						<p class="brand brand1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/txt_brand_01.png" alt="Dailylike" /></p>
						<p class="brand brand2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/txt_brand_02.png" alt="소소한 당신의 일상을 응원합니다 차 한 잔의 따뜻하고 작은 수다를 즐기고 직접 구운 쿠키를 나누어 먹을 줄 알며 아끼는 옷은 오래오래 입고 직접 쓴 연필 글씨에 더 감동합니다 누군가의 이야기라면 조용히 귀담아 들을 줄 아는 그 누구보다 자신의 작은 주변을 아끼고 사랑하는 착한 쉼표, 데일리라이크" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/img_slide_03.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-function">
						<p class="function"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/txt_slide_04.png" alt="Temperature Control 안전 온도 조절기로 고/저 2단계 설정이 가능하며 과열에 대비한 자동 차단 기능이 있어 더욱 안전합니다." /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/img_slide_04_v3.jpg" alt="" />
					</div>

					<%' buy %>
					<%
						Dim itemid, oItem
						Set oItem = Nothing
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786869
						Else
							itemid = 1599887
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
						<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1599887&amp;pEtr=74188'); return false;">
						<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1599887&amp;pEtr=74188">
						<% End If %>
							<div class="animation">
								<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/txt_slide_05.png" alt="Dailylike kind&homey" />
								<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/img_items_v4.gif" alt="" />
							</div>
							<div class="option">
							<% If oItem.FResultCount > 0 then %>
								<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
									<%' for dev msg : 상품코드 1578118 할인 중, 11/9~11/15 할인기간이 지나면 <strong class="discount">...</strong> 숨겨주세요 %>
									<% if left(currenttime,10)>="2016-11-08" and left(currenttime,10)<"2016-11-16" then %>
										<strong class="discount">단 일주일만 ONLY 20%</strong>
									<% end if %>
									<span class="name">데일리 라이크 전기방석 <span>사이즈 : 가로43cm x 세로43cm</span></span>
									<div class="price">
										<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
									</div>
								<% Else %>
									<span class="name">데일리 라이크 전기방석 <span>사이즈 : 가로43cm x 세로43cm</span></span>
									<div class="price priceEnd">
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
									</div>
								<% End If %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
							<% End If %>
							</div>
						</a>
					</div>
					<% Set oItem = Nothing %>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1599887&pEtr=74188" onclick="fnAPPpopupProduct('1599887&pEtr=74188');return false;" title="#ALPACA 보러가기">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/img_slide_06.jpg" alt="#ALPACA 촉감이 좋고 부드러운 털을 가진 알파카를 상상하며 작고 귀여운 아기 알파카를 그렸답니다." /></p>
						</a>
					</div>
					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1599887&pEtr=74188" onclick="fnAPPpopupProduct('1599887&pEtr=74188');return false;" title="#FLAMINGO 보러가기">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/img_slide_06_02.jpg" alt="#FLAMINGO 이유없이 좋은 플라밍고 그 오묘한 빛깔과 우아한 자태 때문일까요?" /></p>
						</a>
					</div>
					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1599887&pEtr=74188" onclick="fnAPPpopupProduct('1599887&pEtr=74188');return false;" title="#CHRISTMAS 보러가기">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/img_slide_06_03.jpg" alt="#CHRISTMAS 곧 다가올 크리스마스를 위해 캐럴도 은은하게 틀어놓고 크리스마스 분위기를 연출해 보아요." /></p>
						</a>
					</div>
				
					<div class="swiper-slide swiper-slide-finish">
						<p class="finish"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/txt_slide_07.png" alt="We like Dailylike 소소한 일상처럼, 언제나 당신 곁에 데일리라이크" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/img_slide_07.jpg" alt="" />
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/txt_slide_08.png" alt="Hey, something project 당신이 갖고 싶은것 데일리라이크의 감성이 담긴 패턴 3가지 중 가장 마음에 와닿는 패턴과 그 이유를 남겨주세요 정성껏 코멘트를 남겨주신 3분에게 데일리라이크의 방석을 선물로 드립니다 (랜덤 발송)" /></p>
						<a href="#commentevt" class="btngo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_go.gif" alt="응모하러 가기" /></a>
					</div>
				</div>
			</div>
			<div class="pagingNo">
				<p class="page"><strong></strong>/<span></span></p>
			</div>

			<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_next.png" alt="다음" /></button>
		</div>

		<%' 구매하기 버튼 %>
		<%'  for dev msg : 구매하기 버튼 클릭시 페이지 http://m.10x10.co.kr/event/etc/hsp/inc_73913_item.asp %>
		<div class="btnget">
		<% if isApp=1 then %>
			<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_74188_item.asp?isApp=<%= isApp %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a>
		<% Else %>
			<a href="/event/etc/hsp/inc_74188_item.asp?isApp=<%= isApp %>" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a>
		<% End If %>
		</div>
	</div>
	<%' //main contents %>

	<%' comment event %>
	<div id="commentevt" class="section commentevt">
		<!-- for dev msg : form -->
		<div class="form">
			<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
			<input type="hidden" name="mode" value="add">
			<input type="hidden" name="pagereload" value="ON">
			<input type="hidden" name="iCC" value="1">
			<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
			<input type="hidden" name="eventid" value="<%= eCode %>">
			<input type="hidden" name="linkevt" value="<%= eCode %>">
			<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
			<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
			<input type="hidden" name="txtcomm">
			<input type="hidden" name="gubunval">
			<input type="hidden" name="isApp" value="<%= isApp %>">	
				<fieldset>
					<legend>데일리라이크의 감성이 담긴 패턴3가지 중 가장 마음에 와닿는 패턴과 그 이유 쓰기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/txt_comment.png" alt="데일리라이크의 감성이 담긴 패턴 3가지 중 가장 마음에 와닿는 패턴과 그 이유를 남겨주세요 정성껏 코멘트를 남겨주신 3분에게 데일리라이크의 방석을 선물로 드립니다. (랜덤 발송) 코멘트 작성기간은 2016년 11월 16일부터 11월 22일까지며, 발표는 11월 25일 입니다." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/ico_01_off.jpg" alt="#ALPACA" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/ico_02_off.jpg" alt="#FLAMINGO" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/ico_03_off.jpg" alt="#CHRISTMAS" /></button>
							</li>
					</ul>
						<div class="field">
							<textarea name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="코멘트 작성" cols="60" rows="5"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
							<input type="submit" onclick="jsSubmitComment(document.frmcom); return false;" value="응모하기" class="btnsubmit" />
						</div>
					</div>
				</fieldset>
			</form>
			<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
			<input type="hidden" name="mode" value="del">
			<input type="hidden" name="pagereload" value="ON">
			<input type="hidden" name="Cidx" value="">
			<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
			<input type="hidden" name="eventid" value="<%= eCode %>">
			<input type="hidden" name="linkevt" value="<%= eCode %>">
			<input type="hidden" name="isApp" value="<%= isApp %>">
			</form>
		</div>

		<%' for dev msg : comment list %>
		<div class="commentlist">
			<p class="total">total <%=iCTotCnt%></p>
			<% IF isArray(arrCList) THEN %>
			<ul>
				<% For intCLoop = 0 To UBound(arrCList,2) %>
				<li>
					<% If isarray(split(arrCList(1,intCLoop),"!@#")) Then %>
					<strong class="ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>">
						<% If split(arrCList(1,intCLoop),"!@#")(0)="1" Then %>
							#ALPACA
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
							#FLAMINGO
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
							#CHRISTMAS
						<% Else %>
							#ALPACA
						<% End if %>	
					</strong>
					<% End If %>
					<div class="letter">
						<p>
						<% if isarray(split(arrCList(1,intCLoop),"!@#")) then %>
							<% if ubound(split(arrCList(1,intCLoop),"!@#")) > 0 then %>
								<%=ReplaceBracket(db2html( split(arrCList(1,intCLoop),"!@#")(1) ))%>
							<% end if %>
						<% end if %>
						</p>
						<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
							<span class="button btS1 btWht cBk1"><button type="button" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">삭제</button></span>
						<% end if %>
					</div>
					<div class="date"><span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span> / <span><%= FormatDate(arrCList(4,intCLoop),"0000.00.00") %></span> 
						<% If arrCList(8,intCLoop) <> "W" Then %>
							<span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성"></span>
						<% end if %>							
					</div>
				</li>
				<% next %>
			</ul>
				<% IF isArray(arrCList) THEN %>
					<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
				<% end if %>
			<% end if %>
		</div>
	</div>
	<%' //comment event %>
	<div id="dimmed"></div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->