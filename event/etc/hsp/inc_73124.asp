<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 48
' History : 2016-09-20 원승현 생성
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
	eCode   =  66203
Else
	eCode   =  73124
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
.heySomething .swiper-slide-buy {background-color:#fdfdfd;}
.heySomething .swiper-slide-buy a {display:block;}
.heySomething .swiper-slide-buy .option {text-align:center;}
.heySomething .swiper-slide-buy .name span {display:block; margin-top:5px; color:#333; font-size:10px; font-weight:bold;}
@media all and (min-width:480px){
	.heySomething .swiper-slide-buy .name span {margin-top:7px; font-size:15px;}
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
	animation-name:twinkle; animation-iteration-count:3; animation-duration:1.2s; animation-fill-mode:both;
	-webkit-animation-name:twinkle; -webkit-animation-iteration-count:3; -webkit-animation-duration:1.2s; -webkit-animation-fill-mode:both;
}
@keyframes twinkle {
	0% {opacity:0;}
	100% {opacity:1;}
}
@-webkit-keyframes twinkle {
	0% {opacity:0;}
	100% {opacity:1;}
}

/* detail */
.swiper-slide-detail .desc {position:absolute; top:10.8333%; left:0; width:100%;}

/* brand */
.heySomething .swiper-slide-brand .letter1 {top:13.02%;}
.heySomething .swiper-slide-brand .letter2 {top:46.56%;}

/* finish */
.swiper-slide-finish {overflow:hidden;}
.swiper-slide-finish p,
.swiper-slide-finish .white {position:absolute; top:0; left:0; width:100%;}
.swiper-slide-finish .white {height:100%; background-color:rgba(256, 256, 256, 0.7);}

/* comment */
.heySomething .swiper-slide .btngo {top:70%;}

.heySomething .form .inner {padding:0 5%;}
.heySomething .form .choice {padding:3% 4% 0 5%;}
.heySomething .form .choice li {width:25%; height:auto !important; margin:0; padding:0 3% 0 0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/ico_01_off.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/ico_02_off.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/ico_03_off.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/ico_04_off.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/ico_04_on.png);}

.heySomething .field {margin-top:10%;}

.heySomething .commentlist ul li {position:relative; min-height:9rem; padding:1.5rem 0 1.5rem 7.75rem;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:0.1rem; width:5.6rem; height:7rem; margin-top:-3.5rem; background-repeat:no-repeat; background-position:50% 0 !important; background-size:100% auto;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/ico_01_off.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/ico_02_off.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/ico_03_off.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/ico_04_off.png);}

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
		<% If not( left(currenttime,10)>="2016-09-21" and left(currenttime,10)<"2016-09-28" ) Then %>
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
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/img_slide_01.jpg" alt="matches navy pattern socks" />
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>

					<%' buy %>
					<%
						Dim itemid, oItem
						IF application("Svr_Info") = "Dev" THEN
							itemid = 1239230
						Else
							itemid = 1540234
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy swiper-slide-buy-ani">
					<%' for dev msg : 상품 링크 %>
					<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1540234&amp;pEtr=73124'); return false;">
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1540234&amp;pEtr=73124">
					<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/img_slide_03_01.jpg" alt="삭스어필과 스티키 몬스터랩의 콜라보레이션 apple Fruits socks" />
							<div class="ani">
								<span class="ani1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/img_slide_03_02.jpg" alt="" /></span>
								<span class="ani2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/img_slide_03_01.jpg" alt="" /></span>
								<span class="ani3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/img_slide_03_02.jpg" alt="" /></span>
								<span class="ani4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/img_slide_03_01.jpg" alt="" /></span>
							</div>
							<div class="option">
						<% If oItem.FResultCount > 0 then %>
								<%' for dev msg : 상품코드 1561880 할인기간 9/7~9/13 할인기간이 지나면  <strong class="discount">...</strong> 숨겨주세요 %>
							<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
								<strong class="discount">단 일주일만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
								<span class="name">KLEINE SACHE <span>올인원 파우치 SUM - BURGUNDY</span></span>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% Else %>
								<span class="name">KLEINE SACHE <span>올인원 파우치 SUM - BURGUNDY</span></span>
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

					<div class="swiper-slide swiper-slide-detail">
						<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/txt_meet.png" alt="당신의 스마트폰에 맞는 사이즈로 만나보세요 " /></p>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/img_slide_04.jpg" alt="SUM은 iPhone 6, 6S, SUM+는 iPhone 6Plus, 6S Plus, GALAXY NOTE, LG G5" /></p>
					</div>

					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/img_slide_05.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-brand">
						<p class="brand letter1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/txt_brand_01.png" alt="KLEINE SACHE" /></p>
						<p class="brand letter2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/txt_brand_02.png" alt="우리는 자주 떨어뜨리게 되고, 깜빡하기 쉬운 작지만 매일 필요한 소품들을 하나로 묶을 파우치를 만들었습니다. 손에 쥐었을 때, 그립감이 좋고 시선을 방해하지 않는 심플함, 스스로 자리잡는 탄탄함을 전달하고 싶었습니다. 우리는 이 파우치로 작은 소품들과 함께하는  당신의 일상이 좀 더 멋져지길 기대합니다" /></p>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1540234&pEtr=73124" title="썸플러스 SUM, SUM+ 2color 보러가기" class="mo">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/img_slide_07.jpg" alt="#WORK 지갑과 펜 케이스가 만나다!  간단한 필기구부터, 체크리스트, 카드 수납까지! 올인원 파우치에 쏙!" /></p>
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1540234&pEtr=73124" title="썸플러스 SUM, SUM+ 2color 보러가기" onclick="fnAPPpopupProduct('1540234&pEtr=73124');return false;" class="app">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/img_slide_07.jpg" alt="#WORK 지갑과 펜 케이스가 만나다!  간단한 필기구부터, 체크리스트, 카드 수납까지! 올인원 파우치에 쏙!" /></p>
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1540234&pEtr=73124" title="썸플러스 SUM, SUM+ 2color 보러가기" class="mo">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/img_slide_08.jpg" alt="#DAILY 스마트폰 시대에 꼭 필요한 데일리 아이템 보조배터리, 이어폰, 연결선 까지 쏙 들어가는 사이즈" /></p>
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1540234&pEtr=73124" title="썸플러스 SUM, SUM+ 2color 보러가기" onclick="fnAPPpopupProduct('1540234&pEtr=73124');return false;" class="app">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/img_slide_08.jpg" alt="#DAILY 스마트폰 시대에 꼭 필요한 데일리 아이템 보조배터리, 이어폰, 연결선 까지 쏙 들어가는 사이즈" /></p>
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1540234&pEtr=73124" title="썸플러스 SUM, SUM+ 2color 보러가기" class="mo">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/img_slide_09.jpg" alt="#MAKE-UP 메이크업파우치 따로, 폰 파우치 따로는 이제 그만! 매일 쓰는 필수품들만 넣어다니세요." /></p>
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1540234&pEtr=73124" title="썸플러스 SUM, SUM+ 2color 보러가기" onclick="fnAPPpopupProduct('1540234&pEtr=73124');return false;" class="app">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/img_slide_09.jpg" alt="#MAKE-UP 메이크업파우치 따로, 폰 파우치 따로는 이제 그만! 매일 쓰는 필수품들만 넣어다니세요." /></p>
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1540234&pEtr=73124" title="썸플러스 SUM, SUM+ 2color 보러가기" class="mo">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/img_slide_10.jpg" alt="#FOR MAN 심플한 디자인으로, 내 남자친구 선물로도 딱! 한손에 쏙 들어오는 사이즈로, 그를 위해 센스를 보여주세요." /></p>
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1540234&pEtr=73124" title="썸플러스 SUM, SUM+ 2color 보러가기" onclick="fnAPPpopupProduct('1540234&pEtr=73124');return false;" class="app">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/img_slide_10.jpg" alt="#FOR MAN 심플한 디자인으로, 내 남자친구 선물로도 딱! 한손에 쏙 들어오는 사이즈로, 그를 위해 센스를 보여주세요." /></p>
						</a>
					</div>

					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/img_slide_11.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-finish">
						<div class="visual"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/img_slide_12.jpg" alt="" /></div>
						<div class="white"></div>
						<p class="finish"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/txt_finish.png" alt="매일 내 일상에 함께하는 작은 물건들 그 물건들을 하나로 묶어주는 똑똑한 파우치, KLEINE SACHE" /></p>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/img_slide_13.png" alt="Hey, something project 당신이 갖고 싶은 것" /></p>
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
			<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1540234&amp;pEtr=73124'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="썸플러스 SUM, SUM+ 2color 구매하러 가기" /></a>
		<% Else %>
			<a href="/category/category_itemPrd.asp?itemid=1540234&pEtr=73124" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="썸플러스 SUM, SUM+ 2color 구매하러 가기" /></a>
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
					<legend>클라이네자케 SUM 코멘트 쓰기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/txt_comment.png" alt="정성껏 코멘트를 남겨주신 3분을 추첨하여 클라이네자케 SUM 제품을 선물로 드립니다. 색상 랜덤이며, 코멘트 작성기간은 2016년 9월 21일부터 9월 27일까지며, 발표는 9월 29일 입니다." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/ico_01_off.png" alt="WORK" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/ico_02_off.png" alt="DAILY" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/ico_03_off.png" alt="MAKE-UP" /></button>
							</li>
							<li class="ico4">
								<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73124/m/ico_04_off.png" alt="FOR MAN" /></button>
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
							WORK
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
							DAILY
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
							MAKE-UP
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>
							FOR MAN
						<% Else %>
							WORK
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

			$(".swiper-slide-buy-ani").find(".ani").hide();
			$(".swiper-slide-active.swiper-slide-buy-ani").find(".ani").show();
			$(".swiper-slide-buy-ani").find(".ani span").removeClass("twinkle");
			$(".swiper-slide-active.swiper-slide-buy-ani").find(".ani span").addClass("twinkle");

			$(".swiper-slide-detail").find(".desc").delay(100).animate({"margin-top":"8.5%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-detail").find(".desc").delay(50).animate({"margin-top":"0", "opacity":"1"},600);

			$(".swiper-slide-brand").find(".letter1").delay(100).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide-brand").find(".letter2").delay(300).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-brand").find(".letter1").delay(50).animate({"margin-top":"0", "opacity":"1"},600);
			$(".swiper-slide-active.swiper-slide-brand").find(".letter2").delay(50).animate({"margin-top":"0", "opacity":"1"},600);

			$(".swiper-slide-finish").find(".white").delay(10).animate({"opacity":"0"},300);
			$(".swiper-slide-finish").find("p").delay(100).animate({"margin-top":"-3%", "opacity":"0"},100);
			$(".swiper-slide-active.swiper-slide-finish").find(".white").delay(50).animate({"opacity":"1"},300);
			$(".swiper-slide-active.swiper-slide-finish").find("p").delay(500).animate({"margin-top":"0", "opacity":"1"},600);
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