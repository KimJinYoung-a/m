<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 47
' History : 2016-09-06 원승현 생성
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
	eCode   =  66196
Else
	eCode   =  72882
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

/* buy */
.heySomething .swiper-slide-buy a {display:block;}
.heySomething .swiper-slide-buy .option {text-align:center;}
.heySomething .swiper-slide-buy .preorder {display:block; margin-top:7px; color:#999; font-size:10px;}
@media all and (min-width:480px){
	.heySomething .swiper-slide-buy .preorder {margin-top:10px; font-size:15px;}
}
.heySomething .swiper-slide-buy .ani {position:absolute; top:0; left:0; width:100%;}
.swiper-slide-buy .ani {display:none;}
.swiper-slide-buy .ani span {position:absolute; top:0; left:0; width:100%;}
.swiper-slide-buy .ani .ani2 {animation-delay:1.2s; -webkit-animation-delay:1.2s;}
.swiper-slide-buy .ani .ani3 {animation-delay:2.4s; -webkit-animation-delay:2.4s;}
.swiper-slide-buy .ani .ani4 {animation-delay:3.6s; -webkit-animation-delay:3.6s;}
.swiper-slide-buy .ani .ani5 {animation-delay:4.6s; -webkit-animation-delay:4.6s;}
.swiper-slide-buy .ani .ani6 {animation-delay:5.8s; -webkit-animation-delay:5.8s;}
.twinkle {
	animation-name:twinkle; animation-iteration-count:1; animation-duration:1.2s; animation-fill-mode:both;
	-webkit-animation-name:twinkle; -webkit-animation-iteration-count:1; -webkit-animation-duration:1.2s; -webkit-animation-fill-mode:both;
}
@keyframes twinkle {
	0% {opacity:0;}
	100% {opacity:1;}
}
@-webkit-keyframes twinkle {
	0% {opacity:0;}
	100% {opacity:1;}
}

/* story */
.heySomething .swiper-slide-story span {position:absolute; top:77.6%; left:15%; width:12.5%;}
.heySomething .swiper-slide-story .ico2 {top:76.3%; left:9.21%;}
.heySomething .swiper-slide-story .ico3 {top:78.6%; left:13.12%;}
.heySomething .swiper-slide-story .ico4 {top:77.9%; left:12.8%;}

/* finish */
.swiper-slide-finish {overflow:hidden; background-color:#ff1928;}
.swiper-slide-finish div {position:absolute; top:0; left:0; width:100%;}

/* comment */
.heySomething .swiper-slide .btngo {top:70%;}

.heySomething .form .inner {padding:0 5%;}
.heySomething .form .choice {padding:3% 4% 0 5%;}
.heySomething .form .choice li {width:25%; height:auto !important; margin:0; padding:0 2.2% 0 0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/ico_01_off.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/ico_02_off.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/ico_03_off.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/ico_04_off.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/ico_04_on.png);}

.heySomething .field {margin-top:4%;}

.heySomething .commentlist ul li {position:relative; min-height:9rem; padding:1.5rem 0 1.5rem 7.75rem;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:0.1rem; width:6.6rem; height:6.6rem; margin-top:-3.3rem; background-repeat:no-repeat; background-position:50% 0 !important; background-size:100% auto;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/ico_01_off.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/ico_02_off.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/ico_03_off.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/ico_04_off.png);}

/* css3 animation */
.pulse {animation-name:pulse; animation-duration:1.5s; animation-iteration-count:1; -webkit-animation-name:pulse; -webkit-animation-duration:1.5s; -webkit-animation-iteration-count:1;}
@keyframes pulse {
	0% {transform:scale(1.5);}
	100% {transform:scale(1);}
}
@-webkit-keyframes pulse {
	0% {-webkit-transform:scale(1.5);}
	100% {-webkit-transform:scale(1);}
}

.bounce {animation-name:bounce; animation-iteration-count:2; animation-duration:1s; -webkit-animation-name:bounce; -webkit-animation-iteration-count:2; -webkit-animation-duration:1s;}
@keyframes bounce {
	from, to{margin-top:0; animation-timing-function:linear;}
	50% {margin-top:5px; animation-timing-function:linear;}
}

@-webkit-keyframes bounce {
	from, to{margin-top:0; -webkit-animation-timing-function:linear;}
	50% {margin-top:5px; -webkit-animation-timing-function:linear;}
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
		<% If not( left(currenttime,10)>="2016-09-06" and left(currenttime,10)<"2016-09-14" ) Then %>
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
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project.png" alt="Hey, something project" /></strong>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_01.jpg" alt="matches navy pattern socks" />
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>

					<%' buy %>
					<%
						Dim itemid, oItem
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1561880
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy swiper-slide-buy-ani-1">
					<%' for dev msg : 상품 링크 %>
					<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1561880&amp;pEtr=72882'); return false;">
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1561880&amp;pEtr=72882">
					<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_03_01.jpg" alt="삭스어필과 스티키 몬스터랩의 콜라보레이션 apple Fruits socks" />
							<div class="ani">
								<span class="ani1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_03_02.jpg" alt="cherry Fruits socks" /></span>
								<span class="ani2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_03_03.jpg" alt="orange Fruits socks" /></span>
								<span class="ani3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_03_04.jpg" alt="pineapple Fruits socks" /></span>
								<span class="ani4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_03_05.jpg" alt="burgundy stripe Pattern socks" /></span>
								<span class="ani5"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_03_06.jpg" alt="navy stripe Pattern socks" /></span>
								<span class="ani6"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_03_01.jpg" alt="apple Fruits socks" /></span>
							</div>
							<div class="option">
						<% If oItem.FResultCount > 0 then %>
								<%' for dev msg : 상품코드 1561880 할인기간 9/7~9/13 할인기간이 지나면  <strong class="discount">...</strong> 숨겨주세요 %>
							<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
								<strong class="discount">단 일주일만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
								<span class="name">Fruits / Pattern socks</span>
								<span class="preorder">19일 예약 발송</span>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% Else %>
								<span class="name">Fruits / Pattern socks</span>
								<span class="preorder">19일 예약 발송</span>
								<div class="price priceEnd">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% End If %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
							</div>
						<% End If %>
						</a>
					</div>

					<%' buy %>
					<%
						Set oItem = Nothing
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786869
						Else
							itemid = 1561881
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy swiper-slide-buy-ani-2">
						<%' for dev msg : 상품 링크 %>
					<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1561881&amp;pEtr=72882'); return false;">
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1561881&amp;pEtr=72882">
					<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_04_01.jpg" alt="rain Pattern socks" />
							<div class="ani">
								<span class="ani1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_04_02.jpg" alt="rainbow Pattern socks" /></span>
								<span class="ani2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_04_03.jpg" alt="french fries Pattern socks" /></span>
								<span class="ani3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_04_04.jpg" alt="hamburger Pattern socks" /></span>
								<span class="ani4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_04_05.jpg" alt="matches navy Pattern socks" /></span>
								<span class="ani5"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_04_06.jpg" alt="matches yellow Pattern socks" /></span>
								<span class="ani6"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_04_01.jpg" alt="rain Pattern socks" /></span>
							</div>
							<div class="option">
								<%' for dev msg : 상품코드 1561881, 할인기간 9/7~9/13 할인기간이 지나면  <strong class="discount">...</strong> 숨겨주세요 %>
						<% If oItem.FResultCount > 0 then %>
							<%' for dev msg : 상품코드 1553685, 할인기간 8/31 ~ 9/6, 할인 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <div class="price priceEnd">...<div> / <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
							<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
								<strong class="discount">단 일주일만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
								<span class="name">Pattern socks</span>
								<span class="preorder">19일 예약 발송</span>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% Else %>
								<span class="name">Pattern socks</span>
								<span class="preorder">19일 예약 발송</span>
								<div class="price priceEnd">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% End If %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
							</div>
						<% End If %>
						</a>
					</div>
					<% Set oItem = Nothing %>

					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_05.jpg" alt="rainbow pattern socks" />
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_06.jpg" alt="삭스어필은 일상의 모든 것들을 재미있는 시선으로 바라봅니다. 재미있는 일상이 삭스어필에게는 곧 모티브가 됩니다. 일상의 위트를 발견하고 좋은 레그웨어에 담아내는 것, 그리고 전달하는 것, 그래서 유쾌한 신사 숙녀들이 그들의 재치를 더욱 어필할 수 있도록 하는 것. 그것이 삭스어필이 하는 일입니다." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_07.jpg" alt="STICKY MONSTER LAB 그들은 다양한 창작자들로 구성되어 2007년에 설립 된 창의적인 스튜디오 입니다. 우리의 현실을 반영하여 공감할 수 있을만한 괴물세계의 일상 애니메이션을 생산했습니다. 현재 그들은 일러스트레이션, 그래픽 디자인, 제품 디자인 등 다방면에서 활동하며 여러 분야에서 두각을 나타내고 있습니다." /></p>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1561880&amp;pEtr=72882" title="apple fruit socks 보러가기" class="mo">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_08.jpg" alt="#Fruits 음~! 과일과 함께할 땐 언제나 기분이 좋아져 내 얼굴같이 예쁜 사과, 앙증맞은 체리, 상큼한 오렌지, 멋쟁이 파인애플 오늘은 어떤 과일로 기분이 좋아질까?" />
							<span class="ico1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_ico_01.png" alt="" /></span>
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1561880&amp;pEtr=72882" onclick="fnAPPpopupProduct('1561880&amp;pEtr=72882');return false;" title="apple fruit socks 보러가기" class="app">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_08.jpg" alt="#Fruits 음~! 과일과 함께할 땐 언제나 기분이 좋아져 내 얼굴같이 예쁜 사과, 앙증맞은 체리, 상큼한 오렌지, 멋쟁이 파인애플 오늘은 어떤 과일로 기분이 좋아질까?" />
							<span class="ico1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_ico_01.png" alt="" /></span>
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1561881&amp;pEtr=72882" title="hamburger pattern socks 보러가기" class="mo">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_09.jpg" alt="#Yum-yum 냠냐암~ 햄버거를 먹을 때 나는 너무나도 행복해! 특히 난 먹음직스러운 브라운패티의 불고기버거를 좋아한다구~ 아참! 햄버거에 감자튀김이 빠질 순 없지" />
							<span class="ico2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_ico_02.png" alt="" /></span>
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1561881&amp;pEtr=72882" onclick="fnAPPpopupProduct('1561881&amp;pEtr=72882');return false;" title="hamburger pattern socks 보러가기" class="app">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_09.jpg" alt="#Yum-yum 냠냐암~ 햄버거를 먹을 때 나는 너무나도 행복해! 특히 난 먹음직스러운 브라운패티의 불고기버거를 좋아한다구~ 아참! 햄버거에 감자튀김이 빠질 순 없지" />
							<span class="ico2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_ico_02.png" alt="" /></span>
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1561881&amp;pEtr=72882" title="rain pattern socks 보러가기" class="mo">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_10.jpg" alt="#Weather 오늘은 웬지 모르게 기분이 꿀꿀한 날이야… 예쁜 양말로 기분을 풀어볼까? 혹시 모르잖아, 번개같던 마음에 햇빛이 들어올지" />
							<span class="ico3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_ico_03.png" alt="" /></span>
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1561881&amp;pEtr=72882" onclick="fnAPPpopupProduct('1561881&amp;pEtr=72882');return false;" title="rain pattern socks 보러가기" class="app">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_10.jpg" alt="#Weather 오늘은 웬지 모르게 기분이 꿀꿀한 날이야… 예쁜 양말로 기분을 풀어볼까? 혹시 모르잖아, 번개같던 마음에 햇빛이 들어올지" />
							<span class="ico3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_ico_03.png" alt="" /></span>
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1561881&amp;pEtr=72882" title="matches yellow pattern socks 보러가기" class="mo">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_11.jpg" alt="#Heart 점점 추워지는 날씨… 따뜻한 마음이 필요해! 혹시 성냥팔이 소녀 이야기 들어봤어? 작은 성냥이 소녀를 따뜻하게 해준 것처럼 포근해지는거 말야" />
							<span class="ico4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_ico_04.png" alt="" /></span>
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1561881&amp;pEtr=72882" onclick="fnAPPpopupProduct('1561881&amp;pEtr=72882');return false;" title="matches yellow pattern socks 보러가기" class="app">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_11.jpg" alt="#Heart 점점 추워지는 날씨… 따뜻한 마음이 필요해! 혹시 성냥팔이 소녀 이야기 들어봤어? 작은 성냥이 소녀를 따뜻하게 해준 것처럼 포근해지는거 말야" />
							<span class="ico4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_ico_04.png" alt="" /></span>
						</a>
					</div>

					<div class="swiper-slide swiper-slide-finish">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_blank.png" alt="" />
						<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_12.jpg" alt="삭스어필과 스티키 몬스터랩의 콜라보레이션" /></div>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_13.png" alt="Hey, something project 당신이 원하는 행복 당신이 신었을 때 가장 행복할 것 같은 양말은 무엇인가요?" /></p>
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
		<%'  for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/hey/72882_get.asp %>
		<div class="btnget">
		<% if isApp=1 then %>
			<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_72882_item.asp?isApp=<%= isApp %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="DENY 타피스트리 구매하러 가기" /></a>
		<% Else %>
			<a href="/event/etc/hsp/inc_72882_item.asp?isApp=<%= isApp %>" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="DENY 타피스트리 구매하러 가기" /></a>
		<% End If %>
			</a>
		</div>
	</div>
	<!-- //main contents -->

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
				<legend>당신이 신었을 때 가장 행복할 것 같은 양말은 무엇인지 그 이유를 코멘트로 써주세요</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/txt_comment.png" alt="그 이유를 코멘트로 남겨주세요 정성껏 코멘트를 남겨주신 10분을 추첨하여 양말2개가 랜덤으로 담긴 미스테리박스를 증정합니다. 코멘트 작성기간은 2016년 9월 7일부터 9월 13일까지며, 발표는 9월 19일 입니다." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/ico_01_off.png" alt="Fruits" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/ico_02_off.png" alt="Yum-yum" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/ico_03_off.png" alt="Weather" /></button>
							</li>
							<li class="ico4">
								<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/ico_04_off.png" alt="Heart" /></button>
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
							#Fruits
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
							#Yum-yum
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
							#Weather
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>
							#Heart
						<% Else %>
							#Fruits
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
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery.slides.min.js"></script>
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

			$(".swiper-slide-buy-ani-1").find(".ani").hide();
			$(".swiper-slide-active.swiper-slide-buy-ani-1").find(".ani").show();
			$(".swiper-slide-buy-ani-1").find(".ani span").removeClass("twinkle");
			$(".swiper-slide-active.swiper-slide-buy-ani-1").find(".ani span").addClass("twinkle");

			$(".swiper-slide-buy-ani-2").find(".ani").hide();
			$(".swiper-slide-active.swiper-slide-buy-ani-2").find(".ani").show();
			$(".swiper-slide-buy-ani-2").find(".ani span").removeClass("twinkle");
			$(".swiper-slide-active.swiper-slide-buy-ani-2").find(".ani span").addClass("twinkle");
			
			$(".swiper-slide.swiper-slide-story").find("span").removeClass("bounce");
			$(".swiper-slide-active.swiper-slide-story").find("span").addClass("bounce");

			$(".swiper-slide.swiper-slide-finish").find("div").removeClass("pulse");
			$(".swiper-slide-active.swiper-slide-finish").find("div").addClass("pulse");
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

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".heySomething .app").show();
			$(".heySomething .mo").hide();
	}else{
			$(".heySomething .app").hide();
			$(".heySomething .mo").show();
	}
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->