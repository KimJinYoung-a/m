<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 3
' History : 2015.09.22 한용민 생성
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
	'currenttime = #09/23/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  64893
Else
	eCode   =  66242
End If

dim userid, i
	userid = GetEncLoginUserID()

dim commentcount
commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim itemid
IF application("Svr_Info") = "Dev" THEN
	itemid   =  1239115
Else
	itemid   =  1354437
End If

dim oItem
set oItem = new CatePrdCls
	oItem.GetItemData itemid
	
dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, pagereload, page
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),2)

	page	= requestCheckVar(Request("page"),10)	'헤이썸띵 메뉴용 페이지 번호

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

/* buy */
.heySomething .swiper-slide-buy .option {position:absolute; top:20%; left:0; width:100%; text-align:center;}
.heySomething .swiper-slide-buy .option .animation {display:block; width:65.625%; margin:0 auto;}

.heySomething .item {overflow:hidden; position:absolute; top:14.5%; left:50%; z-index:100; width:98%; margin-left:-49%;}
.heySomething .item li {float:none; margin-bottom:4%;}
.heySomething .item li a {overflow:hidden; display:block; position:relative; height:0; padding-bottom:29.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.heySomething .item li a span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0.3; filter: alpha(opacity=0); cursor:pointer;}

/* brand */
.swiper-slide-brand .brand {position:absolute; top:5%; left:0; width:100%;}
.swiper-slide-brand .brand p {margin-top:7%;}

/* comment */
.heySomething .form .choice li {width:67px; height:67px; margin:5px 20px 12px 0;}
.heySomething .form .choice li button {width:67px; height:67px; background:transparent url(http://webimage.10x10.co.kr/eventIMG/2015/66242/m/bg_ico_v1.png) no-repeat 0 0; background-size:335px auto;}
.heySomething .form .choice li.ico1 button.on {background-position:0 100%;}
.heySomething .form .choice li.ico2 button {background-position:-67px 0;}
.heySomething .form .choice li.ico2 button.on {background-position:-67px 100%;}
.heySomething .form .choice li.ico3 button {background-position:-134px 0;}
.heySomething .form .choice li.ico3 button.on {background-position:-134px 100%;}
.heySomething .form .choice li.ico4 {clear:left;}
.heySomething .form .choice li.ico4 button {background-position:-201px 0;}
.heySomething .form .choice li.ico4 button.on {background-position:-201px 100%;}
.heySomething .form .choice li.ico5 button {background-position:100% 0;}
.heySomething .form .choice li.ico5 button.on {background-position:100% 100%;}

.heySomething .commentlist ul {margin:10px 6.25% 0; border-top:1px solid #ddd;}
.heySomething .commentlist ul li {position:relative; min-height:88px; padding:15px 0 15px 78px; border-bottom:1px solid #ddd; color:#777; font-size:11px; line-height:1.375em;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:0; width:58px; height:58px; margin-top:-29px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/66242/m/bg_ico.png) no-repeat 0 0;background-size:290px auto; text-indent:-999em;}
.heySomething .commentlist ul li .ico2 {background-position:-58px 0;}
.heySomething .commentlist ul li .ico3 {background-position:-116px 0;}
.heySomething .commentlist ul li .ico4 {background-position:-174px 0;}
.heySomething .commentlist ul li .ico5 {background-position:100% 0;}


@media all and (min-width:480px){
	.heySomething .form .choice li {width:100px; height:100px; margin:8px 30px 18px 0;}
	.heySomething .form .choice li button {width:100px; height:100px; background-size:500px auto;}
	.heySomething .form .choice li.ico2 button {background-position:-100px 0;}
	.heySomething .form .choice li.ico2 button.on {background-position:-100px 100%;}
	.heySomething .form .choice li.ico3 button {background-position:-200px 0;}
	.heySomething .form .choice li.ico3 button.on {background-position:-200px 100%;}
	.heySomething .form .choice li.ico4 {clear:none;}
	.heySomething .form .choice li.ico4 button {background-position:-300px 0;}
	.heySomething .form .choice li.ico4 button.on {background-position:-300px 100%;}
	.heySomething .form .choice li.ico5 button {background-position:100% 0;}
	.heySomething .form .choice li.ico5 button.on {background-position:100% 100%;}

	.heySomething .commentlist ul li {min-height:87px; padding:22px 0 22px 117px;}
	.heySomething .commentlist ul li strong {width:87px; height:87px; margin-top:-43px; background-size:435px auto;}
	.heySomething .commentlist ul li .ico2 {background-position:-87px 0;}
	.heySomething .commentlist ul li .ico3 {background-position:-174px 0;}
	.heySomething .commentlist ul li .ico4 {background-position:-261px 0;}
	.heySomething .commentlist ul li .ico5 {background-position:100% 0;}
}

@media all and (min-width:768px){
	.heySomething .form .choice li {width:134px; height:134px;}
	.heySomething .form .choice li button {width:134px; height:134px; background-size:670px auto;}
	.heySomething .form .choice li.ico2 button {background-position:-134px 0;}
	.heySomething .form .choice li.ico2 button.on {background-position:-134px 100%;}
	.heySomething .form .choice li.ico3 button {background-position:-268px 0;}
	.heySomething .form .choice li.ico3 button.on {background-position:-268px 100%;}
	.heySomething .form .choice li.ico4 button {background-position:-402px 0;}
	.heySomething .form .choice li.ico4 button.on {background-position:-402px 100%;}
	.heySomething .form .choice li.ico5 button {background-position:100% 0;}
	.heySomething .form .choice li.ico5 button.on {background-position:100% 100%;}

	.heySomething .commentlist ul li {min-height:160px; padding:22px 0 22px 135px; font-size:16px;}
	.heySomething .commentlist ul li strong {width:116px; height:116px; margin-top:-58px; background-size:580px auto;}
	.heySomething .commentlist ul li .ico2 {background-position:-116px 0;}
	.heySomething .commentlist ul li .ico3 {background-position:-232px 0;}
	.heySomething .commentlist ul li .ico4 {background-position:-348px 0;}
	.heySomething .commentlist ul li .ico5 {background-position:100% 0;}
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

	<% '헤이썸띵 메뉴용 %>
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
	<% '// 헤이썸띵 메뉴용 %>

});

function pagup(){
	window.$('html,body').animate({scrollTop:$(".mEvt66049").offset().top}, 0);
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
		<% If not( left(currenttime,10)>="2015-09-23" and left(currenttime,10)<"2015-10-08" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if (frm.gubunval.value == ''){
					alert('원하는 것을 선택해 주세요.');
					return false;
				}
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 400){
					alert("코맨트는 400자 까지만 작성이 가능합니다. 코맨트를 남겨주세요.");
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

<% '헤이썸띵 메뉴용 %>
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
<% '// 헤이썸띵 메뉴용 %>

</script>

<div class="heySomething">
	<%'햄버거 메뉴%>
	<a href="#navHey" title="Hey something project 메뉴" id="hamburger" class="hamburger">
		<span>
			<i></i>
			<i></i>
			<i></i>
		</span>
	</a>
	<div id="HSPHeaderNew"></div>
	<%'//햄버거 메뉴%>
	<!-- main contents -->
	<div class="section article">
		<!-- swiper -->
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_slide_01.jpg" alt="Hey, something project DESIGN FINGERS" /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>

					<% '<!-- for dev msg : 09/23~10/07까지 할인 --> %>
					<div class="swiper-slide swiper-slide-buy">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_slide_03.jpg" alt="" />
						<div class="option">
							<% if isApp then %>
								<a href="" onclick="fnAPPpopupProduct('1354437'); return false;">
							<% else %>
								<a href="/category/category_itemPrd.asp?itemid=1354437">
							<% end if %>
								<span class="animation"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_animation.gif" alt="" /></span>
								<%
								'<!-- for dev msg :  09/23~10/07까지 할인 / 종료 후 <strong class="discount">....</strong>숨겨 주시고 
								'<div class="price">...</div>에는 클래스 priceEnd을 붙이고 <del>....<del>숨겨주세요 -->
								%>
								<% if oItem.FResultCount > 0 then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<% If oItem.Prd.FOrgprice = 0 Then %>
										<% else %>
											<strong class="discount">단, 일주일만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
										<% end if %>

										<em class="name">스트라이프 티셔츠 <span>5 color, Free to all</span></em>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% else %>
										<em class="name">스트라이프 티셔츠 <span>5 color, Free to all</span></em>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% end if %>
								<% end if %>

								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/btn_buy.png" alt="구매하러 가기" /></div>
							</a>
						</div>
					</div>

					<div class="swiper-slide siwper-slide-item">
						<% '<!-- for dev msg : 할인 종료 후 이미지 파일명 img_slide_04_after.jpg로 변경해주세요 --> %>
						<% if left(currenttime,10)>"2015-10-07" then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_slide_04_after.jpg" alt="서커스 보이밴드와 함께하는 일상의 작은 유쾌함을 느껴보세요." />
						<% else %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_slide_04_v1.jpg" alt="서커스 보이밴드와 함께하는 일상의 작은 유쾌함을 느껴보세요." />
						<% end if %>

						<ul class="item">
							<% if isApp then %>
								<li><a href="" onclick="fnAPPpopupProduct('1354437'); return false;"><span></span>CBB Stripe t-shirts</a></li>
								<li><a href="" onclick="fnAPPpopupProduct('1354335'); return false;"><span></span>Space mouse pad</a></li>
								<li><a href="" onclick="fnAPPpopupProduct('1328744'); return false;"><span></span>Sticker boy desk mat</a></li>
							<% else %>
								<li><a href="/category/category_itemPrd.asp?itemid=1354437"><span></span>CBB Stripe t-shirts</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1354335"><span></span>Space mouse pad</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1328744"><span></span>Sticker boy desk mat</a></li>
							<% end if %>
						</ul>
					</div>

					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_slide_05.jpg" alt="STRIPE-T" />
					</div>
					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_slide_06.jpg" alt="MOUSE PAD" />
					</div>
					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_slide_07.jpg" alt="DESK MAT" />
					</div>

					<div class="swiper-slide swiper-slide-brand">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_slide_08.jpg" alt="" />
						<div class="brand">
							<p class="letter1"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/txt_plan_01.png" alt="CIRCUS BOY BAND" /></p>
							<p class="letter2"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/txt_plan_02.png" alt="빠른 걸음에 치이는 아침부터 피곤에 젖은 저녁까지 일상은 매일이 똑같습니다. 그렇기 때문에 다른 사람보다 좀 더 특별한 무언가를 자꾸 갈망하죠. 생각의 각도를 조금만 바꾸어 보세요. 일상은 이미 그 자체로 특별합니다. 유쾌한 상상만으로 일상에서 재미를 얻을 수 있도록 당신과 가장 가까운 즐거움을 디자인 합니다." /></p>
							<p class="letter3"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/txt_plan_03.png" alt="여기, 보는 것 만으로도 웃음이 나는 서커스 보이밴드를 소개합니다. 나에게 딱 맞는 아이템을 고르는 사이, 새로운 즐거움을 찾게 될 거에요! 당신의 매일에 스며들어 서커스와 같은 일상을 선물합니다" /></p>
						</div>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_slide_09.jpg" alt="일상의 작은 빈틈을 활용하세요. 화분을 기르거나, 반려동물과 산책하는 전환이 당신에게 필요해요." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_slide_10.jpg" alt="친구들과 함께 오늘을 추억하세요. 간단한 스냅사진 한 장이 만들어주는 특별함은 생각보다 크답니다." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_slide_11.jpg" alt="놀러 가기 딱 좋은 선선한 날씨. 여행은 언제나 좋은 결과를 가져다 주죠." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_slide_12.jpg" alt="콘서트, 한정판, 기차표,페스티벌 유연하게 클릭할 일이 많은 요즘, 성공률이 좋은 요즈음^^" /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_slide_13.jpg" alt="가끔 엉뚱한 상상에 빠져 본 적 있지 않아요? 잠시 쉬어가는 타이밍, 난 우주를 여행하는 꿈을 꾸곤 해요." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_slide_14.jpg" alt="당신의 일상에 약간의 유쾌함을 CIRCUS BOY BAND" /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_slide_15.png" alt="정성껏 코멘트를 남겨주신 5분을 추첨하여 CBB 스트라이프 티셔츠를 선물로 드립니다. 기간은 2015년 9월 23일부터 10월 7일까지며, 발표는 10월 8일 입니다." /></p>
						<a href="#commentevt" class="btngo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/btn_go_v1.gif" alt="응모하러 가기" /></a>
					</div>
				</div>
			</div>
			<div class="pagingNo">
				<p class="page"><strong></strong>/<span></span></p>
			</div>

			<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/btn_next.png" alt="다음" /></button>
		</div>
	
		<% '<!--  for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/66242_get.asp --> %>
		<div class="btnget">
			<% if isApp then %>
				<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/inc_66242_item.asp?isApp=<%= isApp %>'); return false;" >
			<% else %>
				<a href="/event/etc/inc_66242_item.asp?isApp=<%= isApp %>" target="_blank">
			<% end if %>

			<img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/btn_get.png" alt="BUY" /></a>
		</div>
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
				<legend>갖고 싶은 것 선택하고 코멘트 쓰기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/txt_comment.png" alt="정성껏 코멘트를 남겨주신 5분을 추첨하여 CBB 스트라이프 티셔츠를 선물로 드립니다. 기간은 2015년 9월 23일부터 10월 7일까지며, 발표는 10월 8일 입니다." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1"><button type="button" value="1">취미 갖기</button></li>
							<li class="ico2"><button type="button" value="2">사진 찍기</button></li>
							<li class="ico3"><button type="button" value="3">여행 가기</button></li>
							<li class="ico4"><button type="button" value="4">콘서트 가기</button></li>
							<li class="ico5"><button type="button" value="5">쉬는 시간</button></li>
						</ul>
						<div class="field">
							<textarea name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="" cols="60" rows="5"></textarea>
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

		<!-- for dev msg : comment list -->
		<div class="commentlist" id="commentlist">
			<div class="total">total <%= iCTotCnt %></div>
			
			<% IF isArray(arrCList) THEN %>
				<ul>
					<% For intCLoop = 0 To UBound(arrCList,2) %>
					<li>
						<% if isarray(split(arrCList(1,intCLoop),"!@#")) then %>
							<strong class="ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>">
								<% if split(arrCList(1,intCLoop),"!@#")(0)="1" then %>
									취미 갖기
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="2" then %>
									사진 찍기
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="3" then %>
									여행 가기
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="4" then %>
									콘서트가기
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="5" then %>
									쉬는 시간
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
						<div class="date">
							<span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span> / <span><%= FormatDate(arrCList(4,intCLoop),"0000.00.00") %></span>

							<% If arrCList(8,i) <> "W" Then %>
								 <span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성"></span>
							<% end if %>
						</div>
					</li>
					<% Next %>
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

<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:false,
		paginationClickable:true,
		speed:1000,
		autoplay:false,
		nextButton:'.btn-next',
		prevButton:'.btn-prev',
		onSlideChangeStart: function (mySwiper) {
			var vActIdx = parseInt(mySwiper.activeIndex);
			if (vActIdx<=0) {
				vActIdx = mySwiper.slides.length-2;
			} else if(vActIdx>(mySwiper.slides.length-2)) {
				vActIdx = 1;
			}
			$(".pagingNo .page strong").text(vActIdx);
			$(".swiper-slide").find(".brand .letter1").delay(100).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide").find(".brand .letter2").delay(300).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide").find(".brand .letter3").delay(500).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide-active").find(".brand .letter1").delay(50).animate({"margin-top":"6%", "opacity":"1"},600);
			$(".swiper-slide-active").find(".brand .letter2").delay(50).animate({"margin-top":"6%", "opacity":"1"},600);
			$(".swiper-slide-active").find(".brand .letter3").delay(50).animate({"margin-top":"6%", "opacity":"1"},600);
		}
	});
	$('.btn-prev').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.btn-next').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
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

	/* navigator */
	$(".heySomething .menu").click(function(){
		$("#navigator").show();
		$("#dimmed").show();
		return false;
	});
	$("#navigator .btnclose, #dimmed").click(function(){
		$("#navigator").hide();
		$("#dimmed").fadeOut();
	});

	$(".btngo").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},800);
	});
	
	$(".form .choice li:first-child button").addClass("on");
	frmcom.gubunval.value = '1';

	$(".form .choice li button").click(function(){
		//alert( $(this).val() );
		frmcom.gubunval.value = $(this).val()
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