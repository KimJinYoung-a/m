<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 26 MA
' History : 2016-03-29 유태욱 생성
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
dim currenttime, itemid
	currenttime =  now()
'	currenttime = #03/02/2016 09:00:00#

dim eCode
dim oItem
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66097
Else
	eCode   =  69641
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
	iCPageSize = 6
else
	iCPageSize = 6
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

.heySomething .swiper {overflow:visible;}
.heySomething .article .btnget {width:43.125%; margin-left:-21.5625%;}
.heySomething .swiper-slide {}
.heySomething .app {display:none;}

/* title */
.heySomething .swiper-slide .hey {position:absolute; top:6.5%; left:0; width:100%;}

/* item */
.itemList li {position:absolute; width:21.875%;}
.bounce {animation-name:bounce; animation-iteration-count:2; animation-duration:1s; -webkit-animation-name:bounce; -webkit-animation-iteration-count:2; -webkit-animation-duration:1s;}
@keyframes bounce {
	from, to{margin-top:0; animation-timing-function:linear;}
	50% {margin-top:5px; animation-timing-function:linear;}
}

@-webkit-keyframes bounce {
	from, to{margin-top:0; -webkit-animation-timing-function:linear;}
	50% {margin-top:5px; -webkit-animation-timing-function:linear;}
}

.swiper-slide-item01 .itemList li.item01 {top:17%; left:11.5%;}
.swiper-slide-item01 .itemList li.item02 {top:40.5%; left:60.5%;}
.swiper-slide-item01 .itemList li.item03 {top:64%; left:20%;}
.swiper-slide-item01 .itemList li.item04 {top:69%; right:5%;}

.swiper-slide-item02 .itemList li.item01 {top:15%; left:6%;}
.swiper-slide-item02 .itemList li.item02 {top:19.5%; left:55.5%;}
.swiper-slide-item02 .itemList li.item03 {top:41%; right:14%;}
.swiper-slide-item02 .itemList li.item04 {top:69%; left:19%;}

.swiper-slide-get .get {overflow:hidden; position:absolute; bottom:7.3%; left:0; width:100%; height:12%;}
.swiper-slide-get .get p {position:absolute; top:0; left:0; width:100%; }
.swiper-slide-get .get .btnGroup {position:absolute; bottom:0; left:0; width:100%; text-align:center;}
.swiper-slide-get .get .btnGroup a {display:inline-block; width:31.09%; margin:0 0.5%;}

.typeA .get .btnGroup a {width:32.65%;}

/* video */
.video {position:absolute; top:25%; left:50%; width:75.3%; margin-left:-37.65%;}
.video .youtube {overflow:hidden; position:relative; height:0; padding-bottom:100.25%; background:#000;}
.video .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%}

/* comment */
.heySomething .form .choice {margin-right:0; padding-left:2%;}
.heySomething .form .choice li {width:25%; height:auto !important; margin:0; padding:0 1% 1%;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_01.jpg);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_01_on.jpg);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_02.jpg);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_02_on.jpg);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_03.jpg);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_03_on.jpg);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_04.jpg);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_04_on.jpg);}
.heySomething .form .choice li.ico5 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_05.jpg);}
.heySomething .form .choice li.ico5 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_05_on.jpg);}
.heySomething .form .choice li.ico6 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_06.jpg);}
.heySomething .form .choice li.ico6 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_06_on.jpg);}

.heySomething .commentlist ul li {position:relative; min-height:91px; padding:15px 0 15px 78px;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:1%; width:61px; height:61px; margin-top:-30px; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_01.jpg);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_02.jpg);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_03.jpg);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_04.jpg);}
.heySomething .commentlist ul li .ico5 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_05.jpg);}
.heySomething .commentlist ul li .ico6 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_06.jpg);}

@media all and (min-width:480px){
	.heySomething .commentlist ul li {min-height:135px; padding:22px 0 22px 110px;}
	.heySomething .commentlist ul li strong {width:78px; height:78px; margin-top:-39px;}
}

@media all and (min-width:768px){
	.heySomething .commentlist ul li {min-height:180px; padding:30px 0 30px 150px;}
	.heySomething .commentlist ul li strong {width:90px; height:90px; margin-top:-45px;}
}
</style>
<script type='text/javascript'>

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
		<% if commentcount>0 then %>
			alert("이벤트는 한번만 참여 가능 합니다.");
			return false;
		<% else %>
			if (frm.gubunval.value == ''){
				alert('원하는 항목을 선택해 주세요.');
				return false;
			}
			if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 800){
				alert("코맨트를 남겨주세요.\n한글 400자 까지 작성 가능합니다.");
				frm.txtcomm1.focus();
				return false;
			}
			frm.txtcomm.value = frm.gubunval.value + '!@#' + frm.txtcomm1.value
			frm.action = "/event/lib/doEventComment.asp";
			frm.submit();
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

<% ''[Hey, something project_26] CLASKA / 이벤트 코드 69641 %>
<div class="heySomething" id="toparticle">
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
	<% '' main contents  %>
	<div class="section article">
		<%'' swiper %>
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide swiper-slide-topic">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/img_slide_01_v2.jpg" alt="" />
						<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project.png" alt="Hey, something project" /></strong>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>

					<div class="swiper-slide swiper-slide-brand">
						<p class="mo"><a href="/street/street_brand.asp?makerid=CLASKA"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/img_slide_03.jpg" alt="CLASKA는 일본의 유명 부띠끄 호텔입니다. 메구로 거리의 오래된 호텔을 리모델링하여  다이닝&amp;카페&amp;갤러리샵 등을 갖춘 복합 시설로 재탄생시키면서 핫한 명소로 이름을 알리게 되었습니다." /></a></p>
						<p class="app"><a href="" onclick="fnAPPpopupBrand('CLASKA'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/img_slide_03.jpg" alt="CLASKA는 일본의 유명 부띠끄 호텔입니다. 메구로 거리의 오래된 호텔을 리모델링하여  다이닝&amp;카페&amp;갤러리샵 등을 갖춘 복합 시설로 재탄생시키면서 핫한 명소로 이름을 알리게 되었습니다." /></a></p>
					</div>

					<div class="swiper-slide swiper-slide-brand">
						<p class="mo"><a href="/street/street_brand.asp?makerid=CLASKA"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/img_slide_04.jpg" alt="CLASKA 2층에 본점을 둔 Gallery &amp; Shop DO는 전통적인 수공예품에서부터 신진 디자이너들의 제품까지 다양한 아이템을 갖춘 라이프 스타일 샵입니다. 내추럴하고 깔끔한 디자인의 상품 위주로 진행하고 있습니다." /></a></p>
						<p class="app"><a href="" onclick="fnAPPpopupBrand('CLASKA'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/img_slide_04.jpg" alt="CLASKA 2층에 본점을 둔 Gallery &amp; Shop DO는 전통적인 수공예품에서부터 신진 디자이너들의 제품까지 다양한 아이템을 갖춘 라이프 스타일 샵입니다. 내추럴하고 깔끔한 디자인의 상품 위주로 진행하고 있습니다." /></a></p>
					</div>

					<%'' item %>
					<div class="swiper-slide swiper-slide-item swiper-slide-item01">
						<ul class="itemList mo">
							<li class="item01"><a href="/category/category_itemPrd.asp?itemid=1449827&amp;pEtr=69641"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_plus.png" alt="Canvas Tote Bag G&amp;S DO" /></a></li>
							<li class="item02"><a href="/category/category_itemPrd.asp?itemid=1449824&amp;pEtr=69641"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_plus.png" alt="MAMBO Zippered Pouch" /></a></li>
							<li class="item03"><a href="/category/category_itemPrd.asp?itemid=1449828&amp;pEtr=69641"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_plus.png" alt="SWAY TOKYO Tote Bag Large" /></a></li>
							<li class="item04"><a href="/category/category_itemPrd.asp?itemid=1449829&amp;pEtr=69641"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_plus.png" alt="SWAY TOKYO Tote Bag Small" /></a></li>
						</ul>
						<ul class="itemList app">
							<li class="item01"><a href="/category/category_itemPrd.asp?itemid=1449827&amp;pEtr=69641" onclick="fnAPPpopupProduct('1449827&amp;pEtr=69641');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_plus.png" alt="Canvas Tote Bag G&amp;S DO" /></a></li>
							<li class="item02"><a href="/category/category_itemPrd.asp?itemid=1449824&amp;pEtr=69641" onclick="fnAPPpopupProduct('1449824&amp;pEtr=69641');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_plus.png" alt="MAMBO Zippered Pouch" /></a></li>
							<li class="item03"><a href="/category/category_itemPrd.asp?itemid=1449828&amp;pEtr=69641" onclick="fnAPPpopupProduct('1449828&amp;pEtr=69641');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_plus.png" alt="SWAY TOKYO Tote Bag Large" /></a></li>
							<li class="item04"><a href="/category/category_itemPrd.asp?itemid=1449829&amp;pEtr=69641" onclick="fnAPPpopupProduct('1449829&amp;pEtr=69641');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_plus.png" alt="SWAY TOKYO Tote Bag Small" /></a></li>
						</ul>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/img_slide_05.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-item swiper-slide-item02">
						<ul class="itemList mo">
							<li class="item01"><a href="/category/category_itemPrd.asp?itemid=1449827&amp;pEtr=69641"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_plus.png" alt="Canvas Tote Bag G&amp;S DO" /></a></li>
							<li class="item02"><a href="/category/category_itemPrd.asp?itemid=1449822&amp;pEtr=68959"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_plus.png" alt="Straw Hat Brim" /></a></li>
							<li class="item03"><a href="/category/category_itemPrd.asp?itemid=1449830&amp;pEtr=69641"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_plus.png" alt="SWAY TOKYO Tote Bag Large" /></a></li>
							<li class="item04"><a href="/category/category_itemPrd.asp?itemid=1449826&amp;pEtr=69641"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_plus.png" alt="Canvas Zippered Pouch G&amp;S DO" /></a></li>
						</ul>
						<ul class="itemList app">
							<li class="item01"><a href="/category/category_itemPrd.asp?itemid=1449827&amp;pEtr=69641" onclick="fnAPPpopupProduct('1449827&amp;pEtr=69641');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_plus.png" alt="Canvas Tote Bag G&amp;S DO" /></a></li>
							<li class="item02"><a href="/category/category_itemPrd.asp?itemid=1449822&amp;pEtr=68959" onclick="fnAPPpopupProduct('1449822&amp;pEtr=69641');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_plus.png" alt="Straw Hat Brim" /></a></li>
							<li class="item03"><a href="/category/category_itemPrd.asp?itemid=1449830&amp;pEtr=69641" onclick="fnAPPpopupProduct('1449830&amp;pEtr=69641');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_plus.png" alt="SWAY TOKYO Tote Bag Large" /></a></li>
							<li class="item04"><a href="/category/category_itemPrd.asp?itemid=1449826&amp;pEtr=69641" onclick="fnAPPpopupProduct('1449826&amp;pEtr=69641');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_plus.png" alt="Canvas Zippered Pouch G&amp;S DO" /></a></li>
						</ul>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/img_slide_06.jpg" alt="" />
					</div>

					<%'' 구매하러 가기 %>
					<div class="swiper-slide swiper-slide-get">
						<div class="get">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/txt_item_canvas_tote_bag.png" alt="Canvas Tote Bag G&amp;S DO" /></p>
							<div class="btnGroup mo">
								<a href="/category/category_itemPrd.asp?itemid=1449827&amp;pEtr=69641"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop.png" alt="Canvas Tote Bag G&amp;S DO 구매하러 가기" /></a>
							</div>
							<div class="btnGroup app">
								<a href="/category/category_itemPrd.asp?itemid=1449827&amp;pEtr=69641" onclick="fnAPPpopupProduct('1449827&amp;pEtr=69641');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop.png" alt="Canvas Tote Bag G&amp;S DO 구매하러 가기" /></a>
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/img_slide_07.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-get typeA">
						<div class="get">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/txt_straw_hat.png" alt="Straw hat" /></p>
							<div class="btnGroup mo">
								<a href="/category/category_itemPrd.asp?itemid=1449823&amp;pEtr=69641"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop_hanon.png" alt="Straw hat Hanon 구매하러 가기" /></a>
								<a href="/category/category_itemPrd.asp?itemid=1449822&amp;pEtr=69641"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop_brim.png" alt="Straw hat Brim 구매하러 가기" /></a>
							</div>
							<div class="btnGroup app">
								<a href="/category/category_itemPrd.asp?itemid=1449823&amp;pEtr=69641" onclick="fnAPPpopupProduct('1449823&amp;pEtr=69641');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop_hanon.png" alt="Straw hat Hanon 구매하러 가기" /></a>
								<a href="/category/category_itemPrd.asp?itemid=1449822&amp;pEtr=69641" onclick="fnAPPpopupProduct('1449822&amp;pEtr=69641');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop_brim.png" alt="Straw hat Brim 구매하러 가기" /></a>
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/img_slide_08.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-get typeA">
						<div class="get">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/txt_item_canvas_zippered_pouch.png" alt="Canvas Zippered Pouch G&amp;S DO" /></p>
							<div class="btnGroup mo">
								<a href="/category/category_itemPrd.asp?itemid=1449825&amp;pEtr=69641"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop_small.png" alt="Canvas Zippered Pouch G&amp;S DO 스몰 구매하러 가기" /></a>
								<a href="/category/category_itemPrd.asp?itemid=1449826&amp;pEtr=69641"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop_large.png" alt="Canvas Zippered Pouch G&amp;S DO 라지 구매하러 가기" /></a>
							</div>
							<div class="btnGroup app">
								<a href="/category/category_itemPrd.asp?itemid=1449825&amp;pEtr=69641" onclick="fnAPPpopupProduct('1449825&amp;pEtr=69641');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop_small.png" alt="Canvas Zippered Pouch G&amp;S DO 스몰 구매하러 가기" /></a>
								<a href="/category/category_itemPrd.asp?itemid=1449826&amp;pEtr=69641" onclick="fnAPPpopupProduct('1449826&amp;pEtr=69641');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop_large.png" alt="Canvas Zippered Pouch G&amp;S DO 라지 구매하러 가기" /></a>
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/img_slide_09.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-get typeA">
						<div class="get">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/txt_item_sway_tokyo_tote_bag.png" alt="SWAY TOKYO tote Bag" /></p>
							<div class="btnGroup mo">
								<a href="/category/category_itemPrd.asp?itemid=1449831&amp;pEtr=69641"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop_small.png" alt="SWAY TOKYO tote Bag 스몰 구매하러 가기" /></a>
								<a href="/category/category_itemPrd.asp?itemid=1449830&amp;pEtr=69641"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop_large.png" alt="SWAY TOKYO tote Bag 라지 구매하러 가기" /></a>
							</div>
							<div class="btnGroup app">
								<a href="/category/category_itemPrd.asp?itemid=1449831&amp;pEtr=69641" onclick="fnAPPpopupProduct('1449831&amp;pEtr=69641');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop_small.png" alt="SWAY TOKYO tote Bag 스몰 구매하러 가기" /></a>
								<a href="/category/category_itemPrd.asp?itemid=1449830&amp;pEtr=69641" onclick="fnAPPpopupProduct('1449830&amp;pEtr=69641');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop_large.png" alt="SWAY TOKYO tote Bag 라지 구매하러 가기" /></a>
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/img_slide_10.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-get typeA">
						<div class="get">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/txt_item_mambo_tote_bag.png" alt="MAMBO Tote Bag" /></p>
							<div class="btnGroup mo">
								<a href="/category/category_itemPrd.asp?itemid=1449829&amp;pEtr=69641"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop_small.png" alt="MAMBO Tote Bag 스몰 구매하러 가기" /></a>
								<a href="/category/category_itemPrd.asp?itemid=1449828&amp;pEtr=69641"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop_large.png" alt="MAMBO Tote Bag 라지 구매하러 가기" /></a>
							</div>
							<div class="btnGroup app">
								<a href="/category/category_itemPrd.asp?itemid=1449829&amp;pEtr=69641" onclick="fnAPPpopupProduct('1449829&amp;pEtr=69641');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop_small.png" alt="MAMBO Tote Bag 스몰 구매하러 가기" /></a>
								<a href="/category/category_itemPrd.asp?itemid=1449828&amp;pEtr=69641" onclick="fnAPPpopupProduct('1449828&amp;pEtr=69641');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop_large.png" alt="MAMBO Tote Bag 라지 구매하러 가기" /></a>
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/img_slide_11.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-get">
						<div class="get">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/txt_item_mambo_zippered_pouch.png" alt="MAMBO Zippered Pouch" /></p>
							<div class="btnGroup mo">
								<a href="/category/category_itemPrd.asp?itemid=1449824&amp;pEtr=69641"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop.png" alt="MAMBO Zippered Pouch 구매하러 가기" /></a>
							</div>
							<div class="btnGroup app">
								<a href="/category/category_itemPrd.asp?itemid=1449824&amp;pEtr=69641" onclick="fnAPPpopupProduct('1449824&amp;pEtr=69641');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/btn_shop.png" alt="MAMBO Zippered Pouch 구매하러 가기" /></a>
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/img_slide_12.jpg" alt="" />
					</div>

					<div class="swiper-slide">
						<div class="video">
							<div class="youtube">
								<iframe src="//player.vimeo.com/video/160825453" frameborder="0" title="Claska" allowfullscreen></iframe>
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/img_slide_13.jpg" alt="" />
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/img_slide_14.png" alt="여행에도 일상에도 꼭 지니고 싶은 CLASKA! CLASKA의 특별한 제품들 중 가장 가지고 싶은 것은 무엇인가요? 코멘트를 남겨주신 3분을 추첨하여 해당 제품을 드립니다. 디자인, 사이즈, 컬러는 랜덤으로 발송됩니다. 코멘트 작성기간은 2016년 3월 30일부터 4월 5일까지며, 발표는 4월 7일 입니다." /></p>
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
	</div>
	<%'' //main contents %>

	<%'' comment event %>
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
				<legend>Claska 코멘트 쓰기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/txt_comment.png" alt="여행에도 일상에도 꼭 지니고 싶은 CLASKA! CLASKA의 특별한 제품들 중 가장 가지고 싶은 것은 무엇인가요? 코멘트를 남겨주신 3분을 추첨하여 해당 제품을 드립니다. 디자인, 사이즈, 컬러는 랜덤으로 발송됩니다. 코멘트 작성기간은 2016년 3월 30일부터 4월 5일까지며, 발표는 4월 7일 입니다." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_01.jpg" alt="Canvas Tote Bag" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_02.jpg" alt="Straw Hat" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_03.jpg" alt="Canvas Zippered Pouch" /></button>
							</li>
							<li class="ico4">
								<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_04.jpg" alt="Sway Tokyo tote Bag" /></button>
							</li>
							<li class="ico5">
								<button type="button" value="5"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_05.jpg" alt="Mambo Tote Bag" /></button>
							</li>
							<li class="ico6">
								<button type="button" value="6"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69641/m/ico_06.jpg" alt="Mambo Zippered Pouch" /></button>
							</li>
						</ul>
						<div class="field">
							<textarea name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="" cols="60" rows="5"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
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

		<%'' for dev msg : comment list %>
		<div class="commentlist">
			<p class="total">total <%= iCTotCnt %></p>
			<% IF isArray(arrCList) THEN %>
			<ul>
				<% For intCLoop = 0 To UBound(arrCList,2) %>
					<li>
						<% if isarray(split(arrCList(1,intCLoop),"!@#")) then %>
							<strong class="ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>">
								<% if split(arrCList(1,intCLoop),"!@#")(0)="1" then %>
									Canvas Tote Bag
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="2" then %>
									Straw Hat
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="3" then %>
									Canvas Zippered Pouch
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="4" then %>
									Sway Tokyo tote Bag
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="5" then %>
									Mambo Tote Bag
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="6" then %>
									Mambo Zippered Pouch
								<% Else %>
									Canvas Tote Bag
								<% end if %>								
							</strong>
						<% end if %>
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
						<% If arrCList(8,i) <> "W" Then %>
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
	<%'' //comment event %>

	<div id="dimmed"></div>
</div>
<%'' //[Hey, something project_19] 감성고기 %>

<script type="text/javascript">
$(function(){
	$(".hey").css({"opacity":"0"});
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:false,
		paginationClickable:true,
		speed:700,
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
			$(".swiper-slide.swiper-slide-topic").find(".hey").delay(100).animate({"top":"8.5%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-topic").find(".hey").delay(50).animate({"top":"6.5%", "opacity":"1"},600);

			$(".swiper-slide.swiper-slide-item").find(".itemList li a img").removeClass("bounce");
			$(".swiper-slide-active.swiper-slide-item").find(".itemList li a img").addClass("bounce");

			$(".swiper-slide.swiper-slide-get").find(".get p").delay(100).animate({"top":"-30%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-get").find(".get p").delay(50).animate({"top":"0%", "opacity":"1"},600);

			$(".swiper-slide.swiper-slide-get").find(".get .btnGroup").delay(100).animate({"bottom":"5%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-get").find(".get .btnGroup").delay(50).animate({"bottom":"0%", "opacity":"1"},600);
		}
	});
	$('.pagingNo .page strong').text(1);
	$('.pagingNo .page span').text(mySwiper.slides.length-2);

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".heySomething .app").show();
			$(".heySomething .mo").hide();
	}else{
			$(".heySomething .app").hide();
			$(".heySomething .mo").show();
	}

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
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->