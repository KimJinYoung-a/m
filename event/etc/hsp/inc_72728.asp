<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 46
' History : 2016-08-30 김진영 생성
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
	eCode   =  66190
Else
	eCode   =  72728
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
.heySomething .swiper-slide .btngo {top:76.5%;}
.heySomething .app {display:none;}
.heySomething .swiper-slide {background:#fff;}
.heySomething .swiper-slide .hey {position:absolute; top:6.5%; left:0; width:100%;}
.heySomething .swiper-slide-buy {-webkit-text-size-adjust:none; background:#fff;}
.heySomething .swiper-slide-buy a {display:block;}
.heySomething .swiper-slide-buy .option {text-align:center;}
.heySomething .swiper-slide-buy .name {font-size:1.6rem;}
.heySomething .swiper-slide-desc p {position:absolute; left:0; bottom:0; width:100%;}
.heySomething .swiper-slide-gallery li {overflow:hidden; position:absolute; width:50%; height:33.33333%;}
.heySomething .swiper-slide-gallery li.pic01 {left:0; top:0;}
.heySomething .swiper-slide-gallery li.pic02 {right:0; top:0;}
.heySomething .swiper-slide-gallery li.pic03 {left:0; top:33.33333%;}
.heySomething .swiper-slide-gallery li.pic04 {right:0; top:33.33333%;}
.heySomething .swiper-slide-gallery li.pic05 {left:0; bottom:0;}
.heySomething .swiper-slide-gallery li.pic06 {right:0; bottom:0;}
.heySomething .swiper-slide-gallery li span {position:relative; display:block; width:100%; height:100%;}

/* comment */
.heySomething .form .choice {margin:1rem -1.5% 0 0;}
.heySomething .form .choice li {width:6.2rem; height:6.2rem; margin:0; margin-right:0.5rem;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/ico_01.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/ico_02.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/ico_03.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/ico_04.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/ico_04_on.png);}
.heySomething .commentlist ul li {position:relative; min-height:91px; padding:1.5rem 0 1.5rem 7.8rem;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:1%; width:6rem; height:6rem; margin-top:-3rem; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/ico_01.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/ico_02.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/ico_03.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/ico_04.png);}
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
		<% If not( left(currenttime,10)>="2016-08-30" and left(currenttime,10)<="2016-09-06" ) Then %>
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
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/img_main.jpg" alt="" />
						<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project.png" alt="Hey, something project" /></strong>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>
					<%' buy(총3개) %>
					<%
						Dim itemid, oItem
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1553684
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
					<%' for dev msg : 상품 링크 %>
					<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1553684&amp;pEtr=72728'); return false;">
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1553684&amp;pEtr=72728">
					<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/img_item_01.jpg" alt="" />
							<div class="option">
						<% If oItem.FResultCount > 0 then %>
							<%' for dev msg : 상품코드 1553684, 할인기간 8/31 ~ 9/6, 할인 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <div class="price priceEnd">...<div> / <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
							<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
								<strong class="discount">단 일주일만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
								<p class="name">과일 워터팩 7days</p>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% Else %>
								<p class="name">과일 워터팩 7days</p>
								<div class="price priceEnd">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% End If %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
						<% End If %>
							</div>
						</a>
					</div>
					<%
						Set oItem = Nothing
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1553685
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
					<%' for dev msg : 상품 링크 %>
					<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1553685&amp;pEtr=72728'); return false;">
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1553685&amp;pEtr=72728">
					<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/img_item_02.jpg" alt="" />
							<div class="option">
						<% If oItem.FResultCount > 0 then %>
							<%' for dev msg : 상품코드 1553685, 할인기간 8/31 ~ 9/6, 할인 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <div class="price priceEnd">...<div> / <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
							<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
								<strong class="discount">단 일주일만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
								<p class="name">과일 워터팩 15days</p>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% Else %>
								<p class="name">과일 워터팩 15days</p>
								<div class="price priceEnd">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% End If %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
						<% End If %>
							</div>
						</a>
					</div>
					<%
						Set oItem = Nothing
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1553686
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
					<%' for dev msg : 상품 링크 %>
					<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1553686&amp;pEtr=72728'); return false;">
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1553686&amp;pEtr=72728">
					<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/img_item_03.jpg" alt="" />
							<div class="option">
						<% If oItem.FResultCount > 0 then %>
							<%' for dev msg : 상품코드 1553686, 할인기간 8/31 ~ 9/6, 할인 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <div class="price priceEnd">...<div> / <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
							<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
								<strong class="discount">단 일주일만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
								<p class="name">과일 워터팩 30days</p>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% Else %>
								<p class="name">과일 워터팩 30days</p>
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

					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/txt_brand.jpg" alt="반테이블은 음식을 선물화하여 판매하는 먹거리 선물가게 입니다. ‘(   ) 보다 프로젝트’ 는 우리 주변의 소외된 곳을 둘러보고 식탁의 가치를 사람들과 함께 나누는 활동을 하고 싶어 진행하게된 프로젝트입니다. 시각 중심 사고인 보는 것에 의미를 가둬두지 않고, 경험의 의미를 담아 ‘~해보다’라는 뜻입니다. 또한 시각 장애인의 활동 확장성을 높이고, 일반인의 참여로 시각 장애에 대한 인식 개선을 꾀하고자 하는 프로젝트입니다." /></div>

					<div class="swiper-slide swiper-slide-gallery">
						<ul>
							<li class="pic01"><span><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/img_pack_01.jpg" alt="생기돋는 베리베리" /></span></li>
							<li class="pic02"><span><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/img_pack_02.jpg" alt="달콤쌉쌀 자몽허브" /></span></li>
							<li class="pic03"><span><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/img_pack_03.jpg" alt="은은하게 레몬진저" /></span></li>
							<li class="pic04"><span><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/img_pack_04.jpg" alt="초록빛깔 사과케일" /></span></li>
							<li class="pic05"><span><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/img_pack_05.jpg" alt="가뿐할거야 우엉도라지" /></span></li>
							<li class="pic06"><span><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/img_pack_06.jpg" alt="매일매일 보리귀리" /></span></li>
						</ul>
						<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/bg_type.jpg" alt="" /></div>
					</div>

					<div class="swiper-slide">
						<a href="https://www.instagram.com/your10x10/" target="_blank" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/txt_instagram.jpg" alt="텐바이텐 인스타그램을 통해 텐바이텐X반테이블이 함께하는 ()보다 프로젝트에 참여해 주세요! 이벤트에 참여해주시는 분들 중 50분을 선정하여 ‘반테이블의 워터팩’을 선물로 드립니다." /></a>
						<a href="" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/your10x10');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/txt_instagram.jpg" alt="텐바이텐 인스타그램을 통해 텐바이텐X반테이블이 함께하는 ()보다 프로젝트에 참여해 주세요! 이벤트에 참여해주시는 분들 중 50분을 선정하여 ‘반테이블의 워터팩’을 선물로 드립니다." /></a>
					</div>

					<div class="swiper-slide swiper-slide-desc">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/img_story_01.jpg" alt="" />
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/txt_desc_01.png" alt="#마셔보다 - 다가오는 가을, 향긋하고 산뜻한 워터팩으로 촉촉한 하루로 관리해 보세요." /></p>
					</div>
					<div class="swiper-slide swiper-slide-desc">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/img_story_02.jpg" alt="" />
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/txt_desc_02.png" alt="#선물해보다 - No 색소, No 카페인으로 남녀노소 누구나 편안하게 즐길 수 있는 워터팩을 선물해보세요." /></p>
					</div>
					<div class="swiper-slide swiper-slide-desc">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/img_story_03.jpg" alt="" />
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/txt_desc_03.png" alt="#만들어보다 - 최상의 블랜딩 조합으로 맛과 향이 좋은 당신만의 워터팩을 만들어 보세요." /></p>
					</div>
					<div class="swiper-slide swiper-slide-desc">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/img_story_04.jpg" alt="" />
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/txt_desc_04.png" alt="#나눠보다 - 점자도 하나의 언어로 생각하도록 하는 보다프로젝트데 동참해주세요." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/txt_finish.png" alt="Hey, something project 함께 하고 싶은 나만의 [   ]보다" /></p>
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
		
		<%' 브랜드샵 바로가기 버튼 %>
		<div class="btnget mo"><a href="/street/street_brand.asp?makerid=bantable"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" /></a></div>
		<div class="btnget app"><a href="/street/street_brand.asp?makerid=bantable" onclick="fnAPPpopupBrand('bantable'); return false;" ><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" /></a></div>
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
				<legend>코멘트 쓰기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/txt_comment.png" alt="워터팩과 함께하고 싶은 프로젝트는 무엇인가요? 정성껏 코멘트를 남겨주신 5분을 추첨하여 ‘반테이블 디톡스워터팩 만들기 클래스권’을 선물로 드립니다." /></p>
					<div class="inner">
						<ul class="choice">

							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/ico_01.png" alt="#마셔보다" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/ico_02.png" alt="#선물해보다" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/ico_03.png" alt="#만들어보다" /></button>
							</li>
							<li class="ico4">
								<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72728/m/ico_04.png" alt="#나눠보다" /></button>
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
							#마셔보다
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
							#선물해보다
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
							#만들어보다
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>
							#나눠보다
						<% Else %>
							#마셔보다
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
		//initialSlide:6,
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

			$(".swiper-slide-gallery li.pic01 span").animate({"top":"100%"},600);
			$(".swiper-slide-gallery li.pic02 span").animate({"left":"-100%"},600);
			$(".swiper-slide-gallery li.pic03 span").animate({"left":"-100%"},600);
			$(".swiper-slide-gallery li.pic04 span").animate({"top":"100%"},600);
			$(".swiper-slide-gallery li.pic05 span").animate({"bottom":"100%"},600);
			$(".swiper-slide-gallery li.pic06 span").animate({"bottom":"-100%"},600);
			$(".swiper-slide-active.swiper-slide-gallery li.pic01 span").animate({"top":"0"},600);
			$(".swiper-slide-active.swiper-slide-gallery li.pic02 span").animate({"left":"0"},600);
			$(".swiper-slide-active.swiper-slide-gallery li.pic03 span").animate({"left":"0"},600);
			$(".swiper-slide-active.swiper-slide-gallery li.pic04 span").animate({"top":"0"},600);
			$(".swiper-slide-active.swiper-slide-gallery li.pic05 span").animate({"bottom":"0"},600);
			$(".swiper-slide-active.swiper-slide-gallery li.pic06 span").animate({"bottom":"0"},600);

			$(".swiper-slide-desc").find("p").delay(100).animate({"margin-bottom":"-2%", "opacity":"0"},400);
			$(".swiper-slide-active.swiper-slide-desc").find("p").delay(50).animate({"margin-bottom":"0", "opacity":"1"},300);
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
			$(".heySomething .app").show();
			$(".heySomething .mo").hide();
	}else{
			$(".heySomething .app").hide();
			$(".heySomething .mo").show();
	}
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->