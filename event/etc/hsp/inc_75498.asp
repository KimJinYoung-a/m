<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈
' History : 2017-01-10 원승현 생성
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
	eCode   =  66263
Else
	eCode   =  75498
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
.heySomething .swiper-slide-brand {position:relative;}
.heySomething .swiper-slide-brand a {display:block; position:absolute; top:0; left:0;  width:100%; height:100%; z-index:10;}
.heySomething .swiper-slide-brand .brand {position:absolute; z-index:5;}
.heySomething .swiper-slide-brand .brand1 {top:28.95%; padding:0 25.5%;}
.heySomething .swiper-slide-brand .brand2 {top:35.41%; padding:0 17.8%;}
.heySomething .swiper-slide-brand .fg {position:absolute; top:0; left:0; }
.heySomething .swiper-slide-brand .fg01 {width:48.1%; top:0; left:25.8%; animation:swing2 1.5s infinite forwards ease-in-out; transform-origin:50% 100%;}
.heySomething .swiper-slide-brand .fg02 {width:23.6%; top:47.9%; left:7.18%;}
.heySomething .swiper-slide-brand .fg03 {width:54%; top:60%; left:44.84%; z-index:10;}
.heySomething .swiper-slide-brand .fg04 {width:28%; top:49%; left:70.3%; animation:bounce 1.3s infinite ease-in;}
@keyframes bounce { 
	0%,100%{transform:translateY(0);} 
	50% {transform:translateY(0.5rem);} 
}
@keyframes swing2 { 
	0%,100%{transform:rotate(1deg);} 
	50% {transform:rotate(-1deg);} 
}

/* buy */
.heySomething .swiper-slide-buy {background-color:#fff;}
.heySomething .swiper-slide-buy .item01 {margin-bottom:1.3rem;}
.heySomething .swiper-slide-buy a {display:block;}
.heySomething .swiper-slide-buy .option .discountOne {position:absolute; top:66%; right:13%; width:2.5rem;border-radius:25%;}
.heySomething .swiper-slide-buy .option {text-align:center;}
.heySomething .swiper-slide-buy .name {font-weight:bold; font-size:2rem}
.heySomething .swiper-slide-buy .name span {display:block; margin-top:1.2rem; color:#999; font-size:1.1rem; font-weight:bold; line-height:1.4rem;}
.heySomething .swiper-slide-buy .price {margin-top:0.5rem ;}
.heySomething .swiper-slide-buy .price strong {font-size:1.5rem; font-weight:bold; line-height:1.5rem;}
.heySomething .swiper-slide-buy .option .btnbuy {margin-top:2rem;}

/* gallery */
.heySomething .swiper-slide-gallery ul{overflow:hidden;}
.heySomething .swiper-slide-gallery ul li{position:absolute; top:0; left:0; width:50%; }
.heySomething .swiper-slide-gallery ul li:nth-child(1){width:35%; background-color:#dfcbf3;}
.heySomething .swiper-slide-gallery ul li:nth-child(2){width:65%; left:35%; background-color:#f3f3f5;}
.heySomething .swiper-slide-gallery ul li:nth-child(3){width:65%; top:22.91%; left:35%; background-color:#ccf1ff;}
.heySomething .swiper-slide-gallery ul li:nth-child(4){width:35%; top:46.1%; left:0%; background-color:#ff8bb6;}
.heySomething .swiper-slide-gallery ul li:nth-child(5){width:50%; top:69.1%; left:0%; background-color:#6babec;}
.heySomething .swiper-slide-gallery ul li:nth-child(6){width:50%; top:69.1%; left:50%; background-color:#ffe3fe;}

/* finish */
.swiper-slide-finish p {position:absolute; top:19%; width:100%; margin:0 13.6%;}
.swiper-slide-finish p .t01 {display:inline-block; width:40%;}
.swiper-slide-finish p .t02 {display:inline-block; width:29.8%}

/* comment Evt */
.heySomething .swiper-slide .btngo {top:70%;}
.heySomething .form .inner {padding:0.5rem 5% 0;}
.heySomething .form .choice li {width:20.2%; height:auto !important; margin:0 0.4rem;}
.heySomething .form .choice li.ico2 {width:23.9%;}
.heySomething .form .choice li.ico1, .heySomething .form .choice li.ico2, .heySomething .form .choice li.ico3 {margin-top:0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/ico_01_off.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/ico_02_off.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/ico_03_off.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/ico_03_on.png);}
.heySomething .field {margin-top:1.5rem;}
.heySomething .field textarea {height:5.5rem;}
.heySomething .field input {width:5.5rem; height:5.5rem; font-size:0.9rem;}
.heySomething .commentlist ul li {position:relative; min-height:10rem; padding:1.7rem  0 1.7rem 8rem;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:0.1rem; width:6.5rem; height:7.7rem; margin-top:-4.2rem; background-repeat:no-repeat; background-position:50% 0 !important; background-size:100% auto;}
.heySomething .commentlist ul li .ico2 {width:7.3rem; height:7.3rem;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/ico_01_off.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/ico_02_off.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/ico_03_off.png);}
.heySomething .commentlist ul li .mob img {width:0.9rem; margin-top:-0.1rem; margin-left:0.2rem;}
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
		<% If not( left(currenttime,10)>="2017-01-10" and left(currenttime,10)<="2017-01-18" ) Then %>
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
		<div class="section article">
			<!-- swiper -->
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<!-- 1 -->
						<div class="swiper-slide">
							<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project.png" alt="Hey, something project" /></strong>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/img_slide_01.jpg" alt="" /></div>
						</div>

						<!-- 2 -->
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
						</div>

						<!-- brand -->
						<div class="swiper-slide swiper-slide-brand">
							<p class="brand brand1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/txt_brand_01.png" alt="True colors!" /></p>
							<p class="brand brand2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/txt_brand_02.png" alt="매일 노래하고, 춤추고, 허그하는 흥 터지는 생명체 ”트롤” 잠깐의 행복을 위해 트롤을 잡아가는 우울한 생명체 “버겐” 귀여운 트롤친구들은 이 위기를 어떻게 극복할까요? 트롤과 함께 진정한 행복을 찾으러 떠나볼까요?" /></p>
							<div class="figure">
								<span class="fg fg01"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/img_troll_01.png" alt="" /></span>
								<span class="fg fg02"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/img_troll_02.png" alt="" /></span>
								<span class="fg fg03"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/img_troll_03.png" alt="" /></span>
								<span class="fg fg04"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/img_troll_04.png" alt="" /></span>
							</div>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/img_slide_02.jpg" alt="" /></div>
						</div>

						<%
							Dim itemid, oItem
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1621114
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
						%>
						<!-- buy -->
						<div class="swiper-slide swiper-slide-buy">
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1621114&amp;pEtr=75498'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1621114&amp;pEtr=75498">
							<% End If %>
								<div><img class="item01" src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/img_slide_04.png" alt="Trolls 10x10" /></div>
								<div class="option">
									<% If oItem.FResultCount > 0 then %>
										<%'' for dev msg : 상품코드 1621114 , 할인기간 01/11 ~ 01/17, 할인 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <div class="price priceEnd">...<div> / <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
										<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
											<span class="name">Trolls_Blind bag (랜덤토이) <span>Size : 10cm (제품별 상이) <br/> 소재 : PVC  l  제조사 : Hasbro</span></span>
											<div class="price">
												<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
											</div>
										<% else %>
											<span class="name">Trolls_Blind bag (랜덤토이) <span>Size : 10cm (제품별 상이) <br/> 소재 : PVC  l  제조사 : Hasbro</span></span>
											<div class="price">
												<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
											</div>
										<% end if %>
									<% end if %>
									<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
								</div>
							</a>
						</div>
						<% Set oItem = Nothing %>

						<!-- gallery -->
						<div class="swiper-slide swiper-slide-gallery">
							<a href="/category/category_itemPrd.asp?itemid=1621114&pEtr=75498">
								<ul class="gallery">
									<li class="pulse"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/img_slide_05_01.jpg" alt="" /></li>
									<li class="pulse"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/img_slide_05_02.jpg" alt="" /></li>
									<li class="pulse"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/img_slide_05_03.jpg" alt="" /></li>
									<li class="pulse"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/img_slide_05_04.jpg" alt="" /></li>
									<li class="pulse"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/img_slide_05_05.jpg" alt="" /></li>
									<li class="pulse"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/img_slide_05_06.jpg" alt="" /></li>
								</ul>
							</a>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/img_slide_05.png" alt="" /></div>
						</div>

						<!-- story -->
						<div class="swiper-slide swiper-slide-story">
							<a href="/category/category_itemPrd.asp?itemid=1621114&pEtr=75498" onclick="fnAPPpopupProduct('1621114&pEtr=75498');return false;" title="">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/img_slide_06_01.jpg" alt="#PLAY TIME 노는 게 제일 좋아! 누구보다 천진난만하고 사랑스러운 트롤!" /></p>
							</a>
						</div>
						<div class="swiper-slide swiper-slide-story">
							<a href="/category/category_itemPrd.asp?itemid=1621114&pEtr=75498" onclick="fnAPPpopupProduct('1621114&pEtr=75498');return false;" title="">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/img_slide_06_02.jpg" alt="#ADVENTURE TIME 행복은 어디에? 호기심 가득한 눈망울로 모험을 떠난 트롤!" /></p>
							</a>
						</div>
						<div class="swiper-slide swiper-slide-story">
							<a href="/category/category_itemPrd.asp?itemid=1621114&pEtr=75498" onclick="fnAPPpopupProduct('1621114&pEtr=75498');return false;" title="">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/img_slide_06_03_v2.jpg" alt= "#PARTY TIME Drop The Beat!  흥부자 트롤과 미친듯이 놀아볼까요!" /></p>
							</a>
						</div>

						<!-- finish -->
						<div class="swiper-slide swiper-slide-finish">
							<p class="finish">
								<span class="t01"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/txt_finish_01.png" alt="" /></span>
								<span class="t02"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/txt_finish_02.png" alt="" /></span>
							</p>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/img_slide_07.jpg" alt="" /></div>
						</div>

						<!-- comment Evt -->
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/img_slide_08.png" alt="Hey, something project ‘True Colors! 나만의 모토’를  소개해주세요! 행복을 최고의 모토로 생각하는 트롤처럼 나만의 모토를 소개해주세요! 정성껏 코멘트를 남겨주신 5분을 추첨하여 ‘Trolls_Blind bag(랜덤토이)’를 랜덤 발송 해드립니다 기간 : 2017.01.11 ~ 01.17 / 발표 : 01.18" /></p>
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
			<!--  for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/hey/75018_get.asp -->
			<% if isApp=1 then %>
				<div class="btnget"><a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1621114&amp;pEtr=75498'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a></div>
			<% Else %>
				<div class="btnget"><a href="/category/category_itemPrd.asp?itemid=1621114&pEtr=75498" title=""><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a></div>
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
					<legend>나만의 모토 작성</legend>
						<p class="evntTit"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/txt_comment.png" alt="행복을 최고의 모토로 생각하는 트롤처럼 나만의 모토를 소개해주세요! 정성껏 코멘트를 남겨주신 5분을 추첨하여 ‘Trolls_Blind bag(랜덤토이)’를 랜덤 발송 해드립니다 " /></p>
						<div class="inner">
							<ul class="choice">
								<li class="ico1">
									<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/ico_01_off.png" alt="#Play Time" /></button>
								</li>
								<li class="ico2">
									<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/ico_02_off.png" alt="#Adventure Time" /></button>
								</li>
								<li class="ico3">
									<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/75498/m/ico_03_off.png" alt="#Party Time" /></button>
								</li>
							</ul>
							<div class="field">
								<textarea name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="코멘트 작성" cols="60" rows="5"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
								<input type="submit" value="응모하기" onclick="jsSubmitComment(document.frmcom); return false;" class="btnsubmit" />
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
								#Play Time
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
								#Adventure Time
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
								#Party Time
							<% Else %>
								#Play Time
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

<script type="text/javascript">
$(function(){
	$(".hey").css({"opacity":"0"});
	mySwiper = new Swiper('.swiper1',{
		/*initialSlide: 2,*/
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
			$(".swiper-slide-brand").find(".brand3").delay(400).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-brand").find(".brand1").delay(50).animate({"margin-top":"0", "opacity":"1"},600);
			$(".swiper-slide-active.swiper-slide-brand").find(".brand2").delay(50).animate({"margin-top":"0", "opacity":"1"},600);
			$(".swiper-slide-active.swiper-slide-brand").find(".brand3").delay(50).animate({"margin-top":"0", "opacity":"1"},600);

			$(".swiper-slide-gallery").find("ul.gallery li img").delay(100).animate({"opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-gallery").find("ul.gallery li:nth-child(1) img").delay(100).animate({"opacity":"1"},600);
			$(".swiper-slide-active.swiper-slide-gallery").find("ul.gallery li:nth-child(2) img").delay(300).animate({"opacity":"1"},600);
			$(".swiper-slide-active.swiper-slide-gallery").find("ul.gallery li:nth-child(3) img").delay(100).animate({"opacity":"1"},600);
			$(".swiper-slide-active.swiper-slide-gallery").find("ul.gallery li:nth-child(4) img").delay(300).animate({"opacity":"1"},600);
			$(".swiper-slide-active.swiper-slide-gallery").find("ul.gallery li:nth-child(5) img").delay(100).animate({"opacity":"1"},600);
			$(".swiper-slide-active.swiper-slide-gallery").find("ul.gallery li:nth-child(6) img").delay(300).animate({"opacity":"1"},600);

			$(".swiper-slide-buy").find(".animation .opacity").removeClass("twinkle");
			$(".swiper-slide-active.swiper-slide-buy").find(".animation .opacity").addClass("twinkle");

			$(".swiper-slide-finish").find(".finish .t01").delay(100).animate({"padding-left":"5%", "opacity":"0"},200);
			$(".swiper-slide-finish").find(".finish .t02").delay(200).animate({"padding-left":"10%", "opacity":"0"},200);
			$(".swiper-slide-active.swiper-slide-finish").find(".finish .t01").delay(50).animate({"padding-left":"0", "opacity":"1"},600);
			$(".swiper-slide-active.swiper-slide-finish").find(".finish .t02").delay(50).animate({"padding-left":"0", "opacity":"1"},600);
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
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->