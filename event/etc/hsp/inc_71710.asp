<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 39
' History : 2016-07-05 김진영 생성
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
	eCode   =  66166
Else
	eCode   =  71710
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
.heySomething .swiper-slide {background:#fff;}
.heySomething .swiper-slide .hey {position:absolute; top:6.5%; left:0; width:100%;}
.heySomething .swiper-slide-buy {-webkit-text-size-adjust:none; background:#fdfdfd;}
.heySomething .swiper-slide-buy a {display:block;}
.heySomething .swiper-slide-buy .option {text-align:center;}
.heySomething .swiper-slide-buy .name {font-size:1.65rem; font-family:arial;}
.heySomething .desc p {position:absolute; left:0; bottom:0; width:100%;}
.heySomething .feature {overflow:hidden; background:#a0e9ef;}
.heySomething .feature p {position:absolute; left:0; top:0; width:100%;}
.beyondCollection {position:relative;}
.beyondCollection ul {position:absolute; left:0; top:0; width:100%; height:100%;}
.beyondCollection li {float:left; width:33.33333%; height:33.33333%;}
.beyondCollection li a {display:block; width:100%; height:100%; text-indent:-999em;}
.beyondCollection li.item07 {width:66.66666%;}

/* comment */
.heySomething .form .choice {margin-right:-1.5%;}
.heySomething .form .choice li {width:25%; height:auto !important; margin:0; padding:0 0.5%;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/ico_01.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/ico_02.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/ico_03.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/ico_04.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/ico_04_on.png);}
.heySomething .commentlist ul li {position:relative; min-height:91px; padding:15px 0 15px 78px;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:1%; width:70px; height:70px; margin-top:-35px; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/ico_01.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/ico_02.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/ico_03.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/ico_04.png);}

@media all and (min-width:480px){
	.heySomething .swiper-slide-buy .pre {margin-bottom:7px; padding:6px 15px 3px; font-size:17px;border-radius:15px;}
	.heySomething .option .name {font-size:27px;}
	.heySomething .commentlist ul li {min-height:135px; padding:22px 0 22px 135px;}
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
		<% If not( left(currenttime,10)>="2016-07-05" and left(currenttime,10)<="2016-07-12" ) Then %>
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
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/img_slide_01.jpg" alt="" />
						<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project.png" alt="Hey, something project" /></strong>
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
							itemid = 1523830
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
					<%' for dev msg : 상품 링크 %>
					<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1523830&amp;pEtr=71710'); return false;">
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1523830&amp;pEtr=71710">
					<% End If %>	
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/img_slide_03.gif" alt="" />
							<div class="option">
						<% If oItem.FResultCount > 0 then %>
							<%' for dev msg : 상품코드 1523830, 할인기간 7/6 ~ 7/12, 할인 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <div class="price priceEnd">...<div> / <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
							<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
								<strong class="discount">텐바이텐에서만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
								<p class="name">Preppy Logo Patch Vest (2colors)</p>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% Else %>
								<p class="name">Preppy Logo Patch Vest (2colors)</p>
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
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/img_slide_04.jpg" alt="" /></div>
					<div class="swiper-slide feature">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/txt_feature.png" alt="온라인에서는 오직 텐바이텐에서만 만나 볼 수 있는 상품으로 유니크합니다. 고밀도 원단으로 세탁 시 수축을 최소화 하여 오래도록 착용이 가능합니다. 반팔, 긴팔, 셔츠 등을 레이어드하여 여러가지 스타일을 연출 할 수 있습니다." /></p>
						<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/img_slide_05.jpg" alt="" /></div>
					</div>
					<div class="swiper-slide desc">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/img_slide_06.jpg" alt="" />
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/txt_desc_01.png" alt="#GIRLISH" /></p>
					</div>
					<div class="swiper-slide desc">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/img_slide_07.jpg" alt="" />
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/txt_desc_02.png" alt="#CASUAL" /></p>
					</div>
					<div class="swiper-slide desc">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/img_slide_08.jpg" alt="" />
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/txt_desc_03.png" alt="#SPORTY" /></p>
					</div>
					<div class="swiper-slide desc">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/img_slide_09.jpg" alt="" />
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/txt_desc_04.png" alt="#COUPLE&amp;TWIN" /></p>
					</div>
					<div class="swiper-slide beyoundInstagram">
						<p class="mw"><a href="https://www.instagram.com/your10x10_style/" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/img_beyond_instagram.png" alt="텐바이텐 인스타그램 바로가기" /></a></p>
						<p class="ma"><a href="" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/your10x10_style/'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/img_beyond_instagram.png" alt="텐바이텐 인스타그램 바로가기" /></a></p>
						<div class="beyondCollection">
							<ul class="mw">
								<li class="item01"><a href="/category/category_itemPrd.asp?itemid=1515432&amp;pEtr=71710">TROPICAL DOG PRINT 1/2 TS INDI PINK</a></li>
								<li class="item02"><a href="/category/category_itemPrd.asp?itemid=1509892&amp;pEtr=71710">PREPPY LOGO STRIPE 12 TS INDI PINK</a></li>
								<li class="item03"><a href="/category/category_itemPrd.asp?itemid=1519386&amp;pEtr=71710">NOMANTIC HEART LOGO SLEEVELESS WHITE</a></li>
								<li class="item04"><a href="/category/category_itemPrd.asp?itemid=1482788&amp;pEtr=71710">NEW APOLLO DOG SOCKS</a></li>
								<li class="item05"><a href="/category/category_itemPrd.asp?itemid=1476919&amp;pEtr=71710">PREPPY LOGO PATCH VEST NAVY</a></li>
								<li class="item06"><a href="/category/category_itemPrd.asp?itemid=1490770&amp;pEtr=71710">JOHN-MUSIC DOG I PHONE6 & 6S INDI PINK</a></li>
								<li class="item07"><a href="/category/category_itemPrd.asp?itemid=1523830&amp;pEtr=71710">PREPPY LOGO PATCH VEST WHITE (2colors)</a></li>
								<li class="item08"><a href="/category/category_itemPrd.asp?itemid=1484607&amp;pEtr=71710">PREPPY LOGO 1/2 SWEAT SHIRT YELLOW</a></li>
							</ul>
							<ul class="ma">
								<li class="item01"><a href="" onclick="fnAPPpopupProduct('1515432&amp;pEtr=71710');return false;">TROPICAL DOG PRINT 1/2 TS INDI PINK</a></li>
								<li class="item02"><a href="" onclick="fnAPPpopupProduct('1509892&amp;pEtr=71710');return false;">PREPPY LOGO STRIPE 12 TS INDI PINK</a></li>
								<li class="item03"><a href="" onclick="fnAPPpopupProduct('1519386&amp;pEtr=71710');return false;">NOMANTIC HEART LOGO SLEEVELESS WHITE</a></li>
								<li class="item04"><a href="" onclick="fnAPPpopupProduct('1482788&amp;pEtr=71710');return false;">NEW APOLLO DOG SOCKS</a></li>
								<li class="item05"><a href="" onclick="fnAPPpopupProduct('1476919&amp;pEtr=71710');return false;">PREPPY LOGO PATCH VEST NAVY</a></li>
								<li class="item06"><a href="" onclick="fnAPPpopupProduct('1490770&amp;pEtr=71710');return false;">JOHN-MUSIC DOG I PHONE6 & 6S INDI PINK</a></li>
								<li class="item07"><a href="" onclick="fnAPPpopupProduct('1523830&amp;pEtr=71710');return false;">PREPPY LOGO PATCH VEST WHITE (2colors)</a></li>
								<li class="item08"><a href="" onclick="fnAPPpopupProduct('1484607&amp;pEtr=71710');return false;">PREPPY LOGO 1/2 SWEAT SHIRT YELLOW</a></li>
							</ul>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/img_item.jpg" alt="" /></div>
						</div>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/txt_finish.png" alt="당신이 가장 입고 싶은 스타일은 무엇인가요? 그 이유를 코멘트로 남겨주세요. 코멘트를 남겨주신 5분을 추첨하여 비욘드클로젯의 핸드폰 케이스를 드립니다.(랜덤 증정)" /></p>
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
		<div class="btnget">
		<% If isApp = 1 Then %>
			<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1523830&amp;pEtr=71710'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" /></a>
		<% Else %>
			<a href="/category/category_itemPrd.asp?itemid=1523830&amp;pEtr=71710"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" /></a>
		<% End If %>	
		</div>
	</div>
	<%' //main contents %>
	<%' comment event %>
	<div id="commentevt" class="section commentevt">
		<%' for dev msg : form %>
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
				<legend>코멘트 쓰기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/txt_comment.png" alt="당신이 가장 입고 싶은 스타일은 무엇인가요? 그 이유를 코멘트로 남겨주세요. 코멘트를 남겨주신 5분을 추첨하여 비욘드클로젯의 핸드폰케이스를 드립니다. (랜덤증정)" /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/ico_01.png" alt="#GIRLISH" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/ico_02.png" alt="#CASUAL" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/ico_03.png" alt="#SPORTY" /></button>
							</li>
							<li class="ico4">
								<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71710/m/ico_04.png" alt="#COUPLE&amp;TWIN" /></button>
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
							GIRLISH
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
							CASUAL
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
							SPORTY
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>
							COUPLE&amp;TWIN
						<% Else %>
							Greece
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
	<div id="dimmed"></div>
</div>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery.slides.min.js"></script>
<script type="text/javascript">
$(function(){
	$(".hey").css({"opacity":"0"});
	mySwiper = new Swiper('.swiper1',{
		//initialSlide:10,
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
			$(".swiper-slide").find(".hey").delay(100).animate({"top":"8.5%", "opacity":"0"},300);
			$(".swiper-slide-active").find(".hey").animate({"top":"6.5%", "opacity":"1"},600);

			$(".swiper-slide.desc").find("p").delay(100).animate({"margin-bottom":"-2%", "opacity":"0"},400);
			$(".swiper-slide-active.desc").find("p").delay(50).animate({"margin-bottom":"0", "opacity":"1"},300);

			$(".swiper-slide.feature").find("p").delay(100).animate({"margin-top":"2%", "opacity":"0"},400);
			$(".swiper-slide-active.feature").find("p").delay(50).animate({"margin-top":"0", "opacity":"1"},400);
		}
	});
	$('.pagingNo .page strong').text(1);
	$('.pagingNo .page span').text(mySwiper.slides.length-2);

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper.reInit();
			clearInterval(oTm);
		}, 500);
	});

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
		$(".ma").show();
		$(".mw").hide();
	}else{
		$(".ma").hide();
		$(".mw").show();
	}
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->