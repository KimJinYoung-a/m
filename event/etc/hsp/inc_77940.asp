<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 70 무도 MA
' History : 2017-05-16 유태욱 생성
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
	eCode   =  66327
Else
	eCode   =  77940
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
<style type="text/css">
.finishEvt {display:none;}

/* title */
.heySomething .swiper-slide .hey {position:absolute; top:6.6%; left:0; width:100%;}

/* brand */
.swiper-slide-brand {position:relative;}
.swiper-slide-brand p {position:absolute; top:9.3%; left:23.5%; width:53%;}
.swiper-slide-brand p:nth-child(2) {width:71.5%; top:28.6%; left:14.2%;}
.swiper-slide-brand p:nth-child(3) {width:62.8%; top:56.7%; left:18.2%;}

/* buy */
.heySomething .swiper-slide-buy .prdSlide{width:43.28%; margin:0 auto; padding:1.2rem 0;}
.heySomething .swiper-slide-buy .option {text-align:center;}
.heySomething .option .name {font-size:1.4rem;}
.heySomething .option .price {margin:0.5rem 0 1.3rem;}
.heySomething .option .price s,
.heySomething .option .price strong{display:inline-block;}
.heySomething .option .price s {font-size:1.2rem;}
.heySomething .option .price strong,
.heySomething .option .priceEnd strong {margin-left:0.5rem; font-size:1.4rem;}
.heySomething .option .priceEnd strong {color:#000;}
.heySomething .option .info {font-family:'Arial'; font-size:0.85rem; letter-spacing:0.005rem; color:#7d7d7d;}
.heySomething .option .btnbuy {margin-top:2rem;}

/* story */
.heySomething .swiper-slide-desc p {position:absolute; left:0; bottom:0; width:100%;}

/* comment */
.heySomething .swiper-slide .btngo {top:70%;}
.heySomething .form .inner {padding:0 6.25%;}
.heySomething .field {margin-top:3rem;}
.heySomething .form .choice li {width:15.5%; height:auto !important; margin: 0 2.39% 0;}
.heySomething .form .choice li.ico3 {width:20.5%; margin: 0 1.19% 0;}
.heySomething .form .choice li:last-child{margin-right:0;}
.heySomething .form .choice li:first-child{margin-left:0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_01_off.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_02_off.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_03_off.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_04_off.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_04_on.png);}
.heySomething .form .choice li.ico5 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_05_off.png);}
.heySomething .form .choice li.ico5 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_05_on.png);}
.heySomething .commentlist ul li {position:relative; min-height:10rem; padding:1.5rem  0 1.5rem 8rem;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:0.1rem; width:4.65rem; height:4.65rem; margin:-2.3rem 0 0 0.5rem; background-repeat:no-repeat; background-position:50% 0 !important; background-size:100% auto;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_01.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_02.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_03.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_04.png);}
.heySomething .commentlist ul li .ico5 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_05.png);}
</style>
<script type="text/javascript">
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

	$(".hey").css({"opacity":"0"});
	mySwiper = new Swiper('.swiper1',{
		//initialSlide:3,
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
			$(".swiper-slide-active").find(".hey").delay(50).animate({"top":"6.6%", "opacity":"1"},400);

			$(".swiper-slide-brand").find("p:nth-child(1)").delay(100).animate({"margin-top:":"-3%", "opacity":"0"},400);
			$(".swiper-slide-brand").find("p:nth-child(2)").delay(100).animate({"top:":"20%", "opacity":"0"},400);
			$(".swiper-slide-brand").find("p:nth-child(3)").delay(100).animate({"top:":"46%", "opacity":"0"},400);
			$(".swiper-slide-active.swiper-slide-brand").find("p:nth-child(1)").delay(50).animate({"margin-top":"0", "opacity":"1"},200);
			$(".swiper-slide-active.swiper-slide-brand").find("p:nth-child(2)").delay(100).animate({"top":"28.6%", "opacity":"1"},250);
			$(".swiper-slide-active.swiper-slide-brand").find("p:nth-child(3)").delay(150).animate({"top":"56.7%", "opacity":"1"},350);

			$(".swiper-slide-desc").find(".t1").delay(100).animate({"margin-bottom":"25%", "opacity":"0"},400);
			$(".swiper-slide-desc").find(".t2").delay(100).animate({"margin-bottom":"-2%", "opacity":"0"},400);
			$(".swiper-slide-active.swiper-slide-desc").find(".t1").delay(50).animate({"margin-bottom":"26%", "opacity":"1"},200);
			$(".swiper-slide-active.swiper-slide-desc").find(".t2").delay(100).animate({"margin-bottom":"0%", "opacity":"1"},200);

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
		<% If not( left(currenttime,10)>="2017-05-17" and left(currenttime,10)<="2017-05-24" ) Then %>
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
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 800){
					alert("코멘트를 남겨주세요.\n 한글400자 까지 작성 가능합니다.");
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
		<div class="section article">
			<!-- swiper -->
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project_white.png" alt="Hey, something project" /></strong>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/img_slide_01.jpg" alt="" /></div>
						</div>

						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
						</div>

						<!-- brand -->
						<div class="swiper-slide swiper-slide-brand">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/img_logo_1.png" alt="스티키 몬스터 랩 콜라보 무한도전" /></p>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/txt_brand_1.png" alt="올해로 방송 11년, 500회를 훌쩍 넘긴 ‘무한도전’의 다섯 남자가‘스티키몬스터랩’을 만나 ‘무도몬’으로 돌아왔어요." /></p>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/txt_brand_2.png" alt="이제 다섯 무도몬 피규어에 이은 무도몬 버전2 봉제인형을 만나볼까요?" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/img_slide_02.jpg" alt="" />
						</div>

						<!-- buy -->
						<%
							Dim itemid, oItem
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1706097
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
						%>
						<div class="swiper-slide swiper-slide-buy">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/img_logo_2.png" alt="" /></div>
							<!-- for dev msg : 상품코드  -->
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1706097&amp;pEtr=77940'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1706097&amp;pEtr=77940">
							<% End If %>
								<div class="prdSlide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/mudomon_gif_1.gif" alt="" /></div>
								<div class="option">
									<% If oItem.FResultCount > 0 then %>
										<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
											<span class="name">무도몬 쫄쫄이 인형</span>
											<!-- for dev msg : 상품코드 1706097 할인기간 2017.05.17 ~ 05.24 할인기간 -->
											<div class="price">
												<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
												<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %>(<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%)</strong>
											</div>
										<% else %>
											<div class="price priceEnd">
												<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
											</div>
										<% end if %>
									<% end if %>
									<p class="info">사이즈 : 18x33x12 cm / 무게 : 210g / 재질 : 폴리에스테르</p>
									<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
								</div>
							</a>
						</div>
						<% Set oItem = Nothing %>

						<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1706096
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
						%>
						<div class="swiper-slide swiper-slide-buy">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/img_logo_2.png" alt="" /></div>
							<!-- for dev msg : 상품코드 1706096 -->
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1706096&amp;pEtr=77940'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1706096&amp;pEtr=77940">
							<% End If %>
								<div class="prdSlide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/mudomon_gif_2.gif" alt="" /></div>
								<div class="option">
									<span class="name">무도몬 트레이닝 인형</span>
									<!-- for dev msg : 상품코드 1706097 할인기간 2017.05.17 ~ 05.24 할인기간 -->
									<% If oItem.FResultCount > 0 then %>
										<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
											<div class="price">
												<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
												<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %>(<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%)</strong>
											</div>
										<% else %>
											<div class="price priceEnd">
												<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
											</div>
										<% end if %>
									<% end if %>
									<p class="info">사이즈 : 18x33x12cm / 무게 : 210g / 재질 : 폴리에스테르</p>
									<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
								</div>
							</a>
						</div>
						<% Set oItem = Nothing %>

						<div class="swiper-slide swiper-slide-item">
							<a href="/category/category_itemPrd.asp?itemid=1706097&pEtr=77940" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/img_slide_05.jpg" alt="무도몬 쫄쫄이 인형" /></a>
							<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1706097&pEtr=77940" onclick="fnAPPpopupProduct('1706097&pEtr=77940');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/img_slide_05.jpg" alt="무도몬 쫄쫄이 인형" /></a>
						</div>

						<div class="swiper-slide swiper-slide-item">
							<a href="/category/category_itemPrd.asp?itemid=1706096&pEtr=77940" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/img_slide_06.jpg" alt="무도몬 트레이닝 인형" /></a>
							<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1706096&pEtr=77940" onclick="fnAPPpopupProduct('1706096&pEtr=77940');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/img_slide_06.jpg" alt="무도몬 트레이닝 인형" /></a>
						</div>


						<!-- story -->
						<div class="swiper-slide swiper-slide-desc">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/img_slide_07.jpg" alt="" /></div>
							<p class="t1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/txt_desc_1_1.jpg" alt="Episode #1 진실게임" /></p>
							<p class="t2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/txt_desc_1_2.jpg" alt="" /></p>
						</div>
						<div class="swiper-slide swiper-slide-desc">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/img_slide_08.jpg" alt="" /></div>
							<p class="t1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/txt_desc_2_1.jpg" alt="Episode #2 여드름 브레이크" /></p>
							<p class="t2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/txt_desc_2_2.jpg" alt="" /></p>
						</div>
						<div class="swiper-slide swiper-slide-desc">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/img_slide_09.jpg" alt="" /></div>
							<p class="t1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/txt_desc_3_1.jpg" alt="Episode #3 돈가방을 갖고 튀어라" /></p>
							<p class="t2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/txt_desc_3_2.jpg" alt="" /></p>
						</div>
						<div class="swiper-slide swiper-slide-desc">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/img_slide_10.jpg" alt="" /></div>
							<p class="t1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/txt_desc_4_1.jpg" alt="Episode #4 의상한 형제" /></p>
							<p class="t2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/txt_desc_4_2.jpg" alt="" /></p>
						</div>
						<div class="swiper-slide swiper-slide-desc">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/img_slide_11.jpg" alt="" /></div>
							<p class="t1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/txt_desc_5_1.jpg" alt="Episode #5 스피드" /></p>
							<p class="t2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/txt_desc_5_2.jpg" alt="" /></p>
						</div>

						<!-- finish -->
						<div class="swiper-slide swiper-slide-finish">
							<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/img_slide_12.jpg" alt="MUHAN DOJEON 콜라보 STICKY MONSTER LAB" />
						</div>

						<!-- comment Evt -->
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/txt_finish.png" alt="Hey, something project 무한도전 추격전 에피소드 중 best를 찾아주세요!" /></p>
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

			<!-- 구매하기 버튼 -->
			<!--  for dev msg : 구매하기 버튼 클릭시 1706097 상품으로 이동 -->
			<% if isApp=1 then %>
				<div class="btnget"><a href="" onclick="fnAPPpopupProduct('1706097&pEtr=77940'); return false;" title="구매하러 가기" alt="Buy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a></div>
			<% Else %>
				<div class="btnget"><a href="/category/category_itemPrd.asp?itemid=1706097&pEtr=77940" title="구매하러 가기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a></div>
			<% End If %>
			
		</div>
		<!-- //main contents -->

		<!-- comment event -->
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
					<legend>코멘트 작성 폼</legend>
						<p class="evntTit"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/txt_comment.png" alt="무한도전 추격전 중 제일 재밌었다고 생각되는 제목을 클릭하고 이유를 적어주세요. 정성껏 코멘트를 남겨주신 8분을 뽑아 무도몬 인형 1종(랜덤발송)을 보내드립니다. 이벤트 기간은 2017년 5월 17일 수요일 부터 5월 24일 수요일 까지 입니다. 발표일은 5월 26일 금요일 입니다." /></p>
						<div class="inner">
							<ul class="choice">
								<li class="ico1">
									<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_01_off.png" alt="진실게임" /></button>
								</li>
								<li class="ico2">
									<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_02_off.png" alt="여드름 브레이크" /></button>
								</li>
								<li class="ico3">
									<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_03_off.png" alt="돈가방을 갖고 튀어라" /></button>
								</li>
								<li class="ico4">
									<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_04_off.png" alt="의상한 형제" /></button>
								</li>
								<li class="ico5">
									<button type="button" value="5"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77940/m/ico_05_off.png" alt="스피드" /></button>
								</li>
							</ul>
							<div class="field">
								<textarea name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="코멘트 작성" cols="60" rows="5"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
								<input type="submit" value="응모하기" onclick="jsSubmitComment(document.frmcom);" class="btnsubmit" />
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

			<!-- for dev msg : comment list -->
			<div class="commentlist">
				<p class="total">total <%=iCTotCnt%></p>
				<% IF isArray(arrCList) THEN %>
				<ul>
					<% For intCLoop = 0 To UBound(arrCList,2) %>
						<li>
							<% If isarray(split(arrCList(1,intCLoop),"!@#")) Then %>
							<strong class="ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>">
								<% If split(arrCList(1,intCLoop),"!@#")(0)="1" Then %>
									진실게임
								<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
									여드름 브레이크
								<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
									돈가방을 갖고 튀어라
								<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>
									의상한 형제
								<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="5" Then %>
									스피드
								<% Else %>
									진실게임
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
		<!-- //comment event -->

		<div id="dimmed"></div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->