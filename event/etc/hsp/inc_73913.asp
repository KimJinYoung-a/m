<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 일상의 +@ Tehtava
' History : 2016-11-08 유태욱 생성
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
	eCode   =  66230
Else
	eCode   =  73913
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
.heySomething .swiper-slide .hey {position:absolute; top:6.5%; left:0; width:100%;}

/* bramd */
.heySomething .swiper-slide-brand .brand1 {top:11.45%;}
.heySomething .swiper-slide-brand .brand2 {top:26.04%;}

/* buy */
.heySomething .swiper-slide-buy {background-color:#fdfdfd;}
.heySomething .swiper-slide-buy a {display:block;}
.heySomething .swiper-slide-buy .option {text-align:center;}
.heySomething .swiper-slide-buy .name span {display:block; margin-top:5px; color:#999; font-size:10px; font-weight:bold;}
@media all and (min-width:480px){
	.heySomething .swiper-slide-buy .name span {margin-top:7px; font-size:15px;}
}
.heySomething .swiper-slide-buy .animation {position:absolute; top:0; left:0; width:100%;}
.heySomething .swiper-slide-buy .animation .opacity {position:absolute; top:0; left:0; width:100%;}

.twinkle {
	animation-name:twinkle; animation-iteration-count:3; animation-duration:4s; animation-fill-mode:both;
	-webkit-animation-name:twinkle; -webkit-animation-iteration-count:3; -webkit-animation-duration:4s; -webkit-animation-fill-mode:both;
}
@keyframes twinkle {
	0% {opacity:0;}
	50% {opacity:1;}
	100% {opacity:0;}
}
@-webkit-keyframes twinkle {
	0% {opacity:0;}
	50% {opacity:1;}
	100% {opacity:0;}
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
.swiper-slide-finish p {position:absolute; top:21.56%; left:0; width:100%;}

/* comment */
.heySomething .swiper-slide .btngo {top:70%;}

.heySomething .form .inner {padding:0 5%;}
.heySomething .form .choice {padding:3% 0 0 3%;}
.heySomething .form .choice li {width:33.333%; height:auto !important; margin:8% 0 0; padding:0 9% 0 0;}
.heySomething .form .choice li.ico1,
.heySomething .form .choice li.ico2,
.heySomething .form .choice li.ico3 {margin-top:0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_01_off.jpg);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_01_on.jpg);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_02_off.jpg);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_02_on.jpg);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_03_off.jpg);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_03_on.jpg);}
.heySomething .form .choice li.ico4 {clear:left;}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_04_off.jpg);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_04_on.jpg);}
.heySomething .form .choice li.ico5 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_05_off.jpg);}
.heySomething .form .choice li.ico5 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_05_on.jpg);}

.heySomething .field {margin-top:9%;}

.heySomething .commentlist ul li {position:relative; min-height:11.2rem; padding:1.5rem 0 1.5rem 7.75rem;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:0.1rem; width:6.7rem; height:8.4rem; margin-top:-4.2rem; background-repeat:no-repeat; background-position:50% 0 !important; background-size:100% auto;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_01_off.jpg);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_02_off.jpg);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_03_off.jpg);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_04_off.jpg);}
.heySomething .commentlist ul li .ico5 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_05_off.jpg);}
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
			$(".swiper-slide-active").find(".hey").delay(50).animate({"top":"6.5%", "opacity":"1"},600);

			$(".swiper-slide-brand").find(".brand1").delay(100).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide-brand").find(".brand2").delay(300).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-brand").find(".brand1").delay(50).animate({"margin-top":"0", "opacity":"1"},600);
			$(".swiper-slide-active.swiper-slide-brand").find(".brand2").delay(50).animate({"margin-top":"0", "opacity":"1"},600);

			$(".swiper-slide-buy").find(".animation .opacity").removeClass("twinkle");
			$(".swiper-slide-active.swiper-slide-buy").find(".animation .opacity").addClass("twinkle");

			$(".swiper-slide-gallery").find("ul li img").delay(100).animate({"opacity":"0"},300);
			$(".swiper-slide-active,swiper-slide-gallery").find("ul li:nth-child(1) img").delay(50).animate({"opacity":"1"},600);
			$(".swiper-slide-active,swiper-slide-gallery").find("ul li:nth-child(2) img").delay(150).animate({"opacity":"1"},600);
			$(".swiper-slide-active,swiper-slide-gallery").find("ul li:nth-child(3) img").delay(350).animate({"opacity":"1"},600);
			$(".swiper-slide-active,swiper-slide-gallery").find("ul li:nth-child(4) img").delay(50).animate({"opacity":"1"},600);
			$(".swiper-slide-active,swiper-slide-gallery").find("ul li:nth-child(5) img").delay(450).animate({"opacity":"1"},600);
			$(".swiper-slide-active,swiper-slide-gallery").find("ul li:nth-child(6) img").delay(550).animate({"opacity":"1"},600);

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
});

$(function(){
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
		<% If not( left(currenttime,10)>="2016-11-08" and left(currenttime,10)<"2016-11-16" ) Then %>
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
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_01.jpg" alt="Disney Alice Scratch Book" />
						</div>

						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
						</div>


						<div class="swiper-slide swiper-slide-brand">
							<p class="brand brand1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/txt_brand_01.png" alt="디자인에 실용을 담다 TEHTAVA 플러스" /></p>
							<p class="brand brand2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/txt_brand_02.png" alt="테스타바는 핀란드어로 기능이라는 뜻을 가진 단어입니다. 테스타바 플러스에서는 기능성 있는 소재와 아이템을 소비자가 선택하는 재미를 더했습니다. 세련된 북유럽 스타일의 패브릭 제품과 생활 소품을 만나보세요. 당신의 매일 매일을 돋보이게하는 기능 아이템을 소개합니다." /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_03.jpg" alt="" />
						</div>

						<%' buy %>
						<%
							Dim itemid, oItem
							Set oItem = Nothing
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786869
							Else
								itemid = 1578118
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
						%>
						<div class="swiper-slide swiper-slide-buy">
							<% If isApp = 1 Then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1578118&amp;pEtr=73913'); return false;">
							<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=1578118&amp;pEtr=73913">
							<% End If %>
								<div class="animation">
									<span class="opacity"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_04_02.jpg" alt="" /></span>
								</div>
								<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_04.jpg" alt="" />
								<div class="option">
								<% If oItem.FResultCount > 0 then %>
									<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
										<%' for dev msg : 상품코드 1578118 할인 중, 11/9~11/15 할인기간이 지나면 <strong class="discount">...</strong> 숨겨주세요 %>
										<% if left(currenttime,10)>="2016-11-08" and left(currenttime,10)<"2016-11-16" then %>
											<strong class="discount">단 일주일만 ONLY 10%</strong>
										<% end if %>
										<span class="name">REVERSIBLE ROOM SOCKS <span>TEHTAVA+</span></span>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<span class="name">REVERSIBLE ROOM SOCKS <span>TEHTAVA+</span></span>
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

						<div class="swiper-slide swiper-slide-event">
							<ul>
								<li><a href="eventmain.asp?eventid=74091&eGc=192662"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_05_01.jpg" alt="Reversible Room Socks 더 보러 가기 2017 Tehtava+ 신상출시 기획전으로 이동" /></a></li>
								<li><a href="eventmain.asp?eventid=74091&eGc=192663"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_05_02.jpg" alt="Touch Screen Gloves 더 보러 가기 2017 Tehtava+ 신상출시 기획전으로 이동" /></a></li>
								<li><a href="eventmain.asp?eventid=74091&eGc=192664"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_05_03.jpg" alt="Knit Gloves 더 보러 가기 2017 Tehtava+ 신상출시 기획전으로 이동" /></a></li>
							</ul>
						</div>

						<div class="swiper-slide swiper-slide-gallery">
							<a href="/street/street_brand.asp?makerid=tehtava" onclick="fnAPPpopupBrand('tehtava'); return false;" title="테스타바 브랜드 페이지로 이동">
								<ul>
									<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_06_01.jpg" alt="Reversible Room Socks" /></li>
									<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_06_02.jpg" alt="Touch Screen Gloves" /></li>
									<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_06_03.jpg" alt="Reversible Room Socks" /></li>
									<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_06_04.jpg" alt="Reversible Room Socks" /></li>
									<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_06_05.jpg" alt="Touch Screen Gloves" /></li>
									<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_06_06.jpg" alt="Reversible Room Socks" /></li>
								</ul>
							</a>
						</div>

						<div class="swiper-slide swiper-slide-story">
							<a href="/category/category_itemPrd.asp?itemid=1578149&pEtr=73913" onclick="fnAPPpopupProduct('1578149&pEtr=73913');return false;" title="Reversible Room Socks 베이지 컬러 보러가기">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_07.jpg" alt="#Cozy 나른한 주말, 혼자만의 티 타임과 함께! 느긋하게 독서를 즐기고 싶다면" /></p>
							</a>
						</div>
						<div class="swiper-slide swiper-slide-story">
							<a href="/category/category_itemPrd.asp?itemid=1578129&pEtr=73913" onclick="fnAPPpopupProduct('1578129&pEtr=73913');return false;" title="Reversible Room Socks 핑크 컬러 보러가기">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_08.jpg" alt="#Warm 차가운 마루에서도 온 몸이 움츠려 들지 않아도 되는 나만의 비결" /></p>
							</a>
						</div>
						<div class="swiper-slide swiper-slide-story">
							<a href="/category/category_itemPrd.asp?itemid=1578118&pEtr=73913" onclick="fnAPPpopupProduct('1578118&pEtr=73913');return false;" title="Reversible Room Socks 보러가기">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_09.jpg" alt="#Family 오늘은 어떤색을 신어볼까? 따뜻한 겨울을 위한 우리 가족 필수템" /></p>
							</a>
						</div>
						<div class="swiper-slide swiper-slide-story">
							<a href="eventmain.asp?eventid=74091&eGc=192663" title="Touch Screen Gloves 더 보러 가기 2017 Tehtava+ 신상출시 기획전으로 이동">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_10_v1.jpg" alt="#Slim 따뜻하고 싶지만 투박하여 미뤄왔던 터치 장갑에 대한 고민은 이제 그만!" /></p>
							</a>
						</div>
						<div class="swiper-slide swiper-slide-story">
							<a href="eventmain.asp?eventid=74091&eGc=192663" title="Touch Screen Gloves 더 보러 가기 2017 Tehtava+ 신상출시 기획전으로 이동">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_11_v1.jpg" alt="#Touch 너를 기다리는 이 순간에도 너에게 문자를 보내는 나의 손은 오늘도 따뜻" /></p>
							</a>
						</div>
					
						<div class="swiper-slide swiper-slide-finish">
							<p class="finish"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/txt_finish.png" alt="겨울에 감성을 더하는 TEHTAVA 플러스" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_12.jpg" alt="" />
						</div>

						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_13.png" alt="Hey, something project 나와 잘 맞는 룸삭스 컬러는?" /></p>
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
				<a href="" onclick="fnAPPpopupBrowserURL('기획전','<%= wwwUrl %>/event/etc/hsp/inc_73913_item.asp?isApp=<%= isApp %>'); return false;" title="Disney Alice Scratch Book 구매하러 가기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a>
			<% Else %>
				<a href="/event/etc/hsp/inc_73913_item.asp?isApp=<%= isApp %>" target="_blank" title="Disney Alice Scratch Book 구매하러 가기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a>
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
					<legend>현실 속에서 상상하던 나만의 빛나는 순간 선택하고 코멘트 쓰기</legend>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/txt_comment.png" alt="가장 마음에 드는 룸삭스의 컬러와 컨셉을 선정해주세요. 정성껏 코멘트를 남겨주신 5분을 추첨하여, 테스타바 장갑을 선물로 드립니다. 코멘트 작성기간은 2016년 11월 9일부터 11월 215일까지며, 발표는 11월 16일 입니다." /></p>
						<div class="inner">
							<ul class="choice">
								<li class="ico1">
									<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_01_off.jpg" alt="Cozy" /></button>
								</li>
								<li class="ico2">
									<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_02_off.jpg" alt="Warm" /></button>
								</li>
								<li class="ico3">
									<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_03_off.jpg" alt="Family" /></button>
								</li>
								<li class="ico4">
									<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_04_off.jpg" alt="Slim" /></button>
								</li>
								<li class="ico5">
									<button type="button" value="5"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/ico_05_off.jpg" alt="Touch" /></button>
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
								Cozy
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
								Warm
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
								Family
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>
								Slim
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="5" Then %>
								Touch
							<% Else %>
								Cozy
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