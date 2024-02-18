<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 31 MA
' History : 2016-05-10 유태욱 생성
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
'	currenttime = #05/11/2016 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66122
Else
	eCode   =  70582
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

dim itemid
IF application("Svr_Info") = "Dev" THEN
	itemid   =  1239115
Else
	itemid   =  1479124
End If

dim oItem
set oItem = new CatePrdCls
	oItem.GetItemData itemid
%>
<style type="text/css">
.finishEvt {display:none;}

.heySomething .app {display:none;}

/* title */
.heySomething .swiper-slide .hey {position:absolute; top:6.5%; left:0; width:100%;}

/* buy */
.heySomething .swiper-slide-buy a {display:block;}
.heySomething .swiper-slide-buy .option {position:absolute; top:0; left:0; width:100%; height:100%; padding-top:90%; text-align:center;}

/* detail */
.swiper-slide-detail .detail {position:absolute; left:50%; top:43%; width:74.375%; margin-left:-37.1875%;}

/* brand */
.swiper-slide-brand .photo {position:absolute; top:17.18%; left:0; width:100%;}

/* story */
.heySomething .swiper-slide .desc {position:absolute; bottom:12.5%; width:100%;}

/* comment */
.heySomething .swiper-slide .btngo {top:70%;}

.heySomething .form .choice {padding:3% 6% 0 1%;}
.heySomething .form .choice li {width:25%; height:auto !important; margin:0; padding:0 1.5% 0;}
.heySomething .form .choice li:last-child {padding-right:0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/ico_01_off.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/ico_02_off.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/ico_03_off.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/ico_04_off.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/ico_04_on.png);}

.heySomething .commentlist ul li {position:relative; min-height:91px; padding:15px 0 15px 78px;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:1%; width:56px; height:56px; margin-top:-28px; background-repeat:no-repeat; background-position:50% 0 !important; background-size:56px auto;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/ico_01_off.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/ico_02_off.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/ico_03_off.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/ico_04_off.png);}

@media all and (min-width:480px){
	.heySomething .commentlist ul li {min-height:135px; padding:22px 0 22px 110px;}
	.heySomething .commentlist ul li strong {width:84px; height:84px; margin-top:-42px; background-size:84px auto;}
}

@media all and (min-width:768px){
	.heySomething .commentlist ul li {min-height:180px; padding:30px 0 30px 150px;}
	.heySomething .commentlist ul li strong {width:110px; height:110px; margin-top:-55px; background-size:110px auto;}
}
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
				alert('원하는 것을 선택해 주세요.');
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

			$(".swiper-slide.swiper-slide-story").find(".desc").delay(100).animate({"margin-left":"3%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-story").find(".desc").delay(50).animate({"margin-left":"0", "opacity":"1"},500);

			$(".swiper-slide.swiper-slide-brand").find(".photo").delay(100).animate({"width":"102%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-brand").find(".photo").delay(50).animate({"width":"100%", "opacity":"1"},800);
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
		frmcom.gubunval.value = $(this).val()
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

<%''  [Hey, something project_30] EMIE Bluetooth speaker / 이벤트 코드 70582 %>
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

	<% '' main contents  %>
	<div class="section article" id="toparticle">
		<%'' swiper %>
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/img_slide_01.jpg" alt="" />
						<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project.png" alt="Hey, something project" /></strong>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>

					<%'' buy %>
					<div class="swiper-slide swiper-slide-buy">
						<% ' for dev msg : 상품 링크 %>
						<% if isApp=1 then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1479124&amp;pEtr=70582'); return false;">
						<% else %>
							<a href="/category/category_itemPrd.asp?itemid=1479124&amp;pEtr=70582">
						<% end if %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/img_slide_03.gif" alt="" />
							<div class="option">
								<!-- for dev msg : 상품코드 1479124 할인기간 5/11~5/17 할인기간이 지나면 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 -->
								<% If not( left(currenttime,10)>="2016-05-11" and left(currenttime,10)<"2016-05-19" ) Then %>
								<% else %>
									<strong class="discount"> 텐바이텐에서만 ONLY 5%</strong>
								<% end if %>
								<p class="name">EMIE Bluetooth speaker <span>본 상품은 예약판매 상품으로 5.18일 순차배송됩니다</span></p>
								<% if oItem.FResultCount > 0 then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% else %>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% end if %>
								<% end if %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="EMIE Bluetooth speaker 구매하러 가기" /></div>
							</div>
						</a>
					</div>

					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/img_slide_04.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-brand">
						<div class="photo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/img_brand_v1.jpg" alt="" /></div>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/img_slide_05.png" alt="크레이티브 디자인 그룹의 첫 블루투스 스피커 EMIE는 2011년 10월 중국 Shenzhen에서 설립된, 중국내 타 업체와 다르게 뛰어난 디자인과 성능에 초점을 맞춘 젊고 크리에이티브한 디자인 그룹입니다. 2013년 ~ 2015년 레드닷 어워드 디자인 부분에서 수상하는 등 젊고 아름다운 제품으로 꾸준히 소비자들의 사랑을 받고 있습니다." /></p>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1479124&amp;pEtr=70582" class="mo">
							<p class="desc desc1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/txt_desc_01.png" alt="잔잔하게 잔잔한 음악이 듣고 싶을 때 당신의 시간을 동행합니다" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/img_slide_06.jpg" alt="" />
						</a>
						<a href="/category/category_itemPrd.asp?itemid=1479124&amp;pEtr=70582" onclick="fnAPPpopupProduct('1479124&amp;pEtr=70582');return false;" class="app">
							<p class="desc desc1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/txt_desc_01.png" alt="잔잔하게 잔잔한 음악이 듣고 싶을 때 당신의 시간을 동행합니다" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/img_slide_06.jpg" alt="" />
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1479124&amp;pEtr=70582" class="mo">
							<p class="desc desc2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/txt_desc_02.png" alt="아담하게 손바닥 크기 집안 어디에 놓아도 부담스럽지 않은 크기" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/img_slide_07.jpg" alt="" />
						</a>
						<a href="/category/category_itemPrd.asp?itemid=1479124&amp;pEtr=70582" onclick="fnAPPpopupProduct('1479124&amp;pEtr=70582');return false;" class="app">
							<p class="desc desc2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/txt_desc_02.png" alt="아담하게 손바닥 크기 집안 어디에 놓아도 부담스럽지 않은 크기" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/img_slide_07.jpg" alt="" />
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1479124&amp;pEtr=70582" class="mo">
							<p class="desc desc3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/txt_desc_03.png" alt="간단하게 어렵지 않아요 버튼을 누르거나 노브를 천천히 돌려 주세요" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/img_slide_08.jpg" alt="" />
						</a>
						<a href="/category/category_itemPrd.asp?itemid=1479124&amp;pEtr=70582" onclick="fnAPPpopupProduct('1479124&amp;pEtr=70582');return false;" class="app">
							<p class="desc desc3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/txt_desc_03.png" alt="간단하게 어렵지 않아요 버튼을 누르거나 노브를 천천히 돌려 주세요" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/img_slide_08.jpg" alt="" />
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1479124&amp;pEtr=70582" class="mo">
							<p class="desc desc4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/txt_desc_04.png" alt="똑똑하게 비 작동 상태가 되면 자동으로 종료 됩니다" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/img_slide_09.jpg" alt="" />
						</a>
						<a href="/category/category_itemPrd.asp?itemid=1479124&amp;pEtr=70582" onclick="fnAPPpopupProduct('1479124&amp;pEtr=70582');return false;" class="app">
							<p class="desc desc4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/txt_desc_04.png" alt="똑똑하게 비 작동 상태가 되면 자동으로 종료 됩니다" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/img_slide_09.jpg" alt="" />
						</a>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/img_slide_10.jpg" alt="꺼짐 2초 동안 버튼을 누르세요. 볼륨 증가/감소 시계/시계 반대 방향으로 회전, 일시정지 블루투스 연결 상태에서 노브를 누르세요. 페어링 모드 두번 빠르게 누르면 푸른 빛이 납니다. 배터리 부족 시 배터리 경보 빛이 1분 켜집니다. 충전 팁 충전 중 레드라이트가 꺼지면 충전이 완료된 것 입니다" /></p>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/img_slide_11.jpg" alt="제조사명 EMIE, 모델명 MR04, 블루투스 CSR 블루투스 3.0, 스피커 1.5인치 2W 스테레오 서라운드, 주파수대역 20Hz ~ 20kHz, 배터리 520MAH 리튬이온 충전지, 사용시간 최대 6시간, 사이즈 가로 115mm 세로 68mm 대각선 30mm" /></p>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/img_slide_12.png" alt="Hey, something project 당신이 갖고싶은 것 EMIE 블루투스 스피커의 텐바이텐 런칭을 축하해주세요 정성스러운 코멘트를 남겨주신 5분을 선정하여 EMIE 블루투스 스피커를 선물로 드립니다. 코멘트 작성기간은 2016년 5월 11일부터 5월 17일까지며, 발표는 5월 8일 입니다." /></p>
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

		<%'' 구매하기 버튼 %>
		<!--  for dev msg : 구매하기 버튼 클릭시 상품상세로 링크 -->
		<div class="btnget">
			<a href="/category/category_itemPrd.asp?itemid=1479124&amp;pEtr=70582" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a>
			<a href="/category/category_itemPrd.asp?itemid=1479124&amp;pEtr=70582" onclick="fnAPPpopupProduct('1479124&amp;pEtr=70582');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a>
		</div>
	</div>
	<%'' //main contents %>

	<%'' comment event %>
	<div id="commentevt" class="section commentevt">
		<%'' for dev msg : form %>
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
				<legend>EMIE 블루투스 스피커 코멘트 쓰기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/txt_comment.png" alt="EMIE 블루투스 스피커의 텐바이텐 런칭을 축하해주세요 정성스러운 코멘트를 남겨주신 5분을 선정하여 EMIE 블루투스 스피커를 선물로 드립니다. 코멘트 작성기간은 2016년 5월 11일부터 5월 17일까지며, 발표는 5월 8일 입니다." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/ico_01_off.png" alt="잔잔하게" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/ico_02_off.png" alt="아담하게" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/ico_03_off.png" alt="간단하게" /></button>
							</li>
							<li class="ico4">
								<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70582/m/ico_04_off.png" alt="스마트하게" /></button>
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
								잔잔하게
							<% elseif split(arrCList(1,intCLoop),"!@#")(0)="2" then %>
								아담하게
							<% elseif split(arrCList(1,intCLoop),"!@#")(0)="3" then %>
								간단하게
							<% elseif split(arrCList(1,intCLoop),"!@#")(0)="4" then %>
								스마트하게
							<% else %>
								잔잔하게
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
						 <span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성"></span></div>
					<% end if %>
				</li>
				<% Next %>
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
<!-- #include virtual="/lib/db/dbclose.asp" -->