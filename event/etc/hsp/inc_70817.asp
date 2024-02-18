<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 33
' History : 2016-05-24 원승현 생성
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
	eCode   =  66137
Else
	eCode   =  70817
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
.heySomething .swiper-slide-buy {background-color:#f8f8f8;}
.heySomething .swiper-slide-buy a {display:block;}
.heySomething .swiper-slide-buy .option {position:absolute; top:0; left:0; width:100%; height:100%; padding-top:90%; text-align:center;}

/* illust */
.swiper-slide-illust .pooh {position:absolute; top:2.7%; left:13.43%; width:32.34%;}
.swiper-slide-illust .butterfly {position:absolute; top:51.45%; right:31.25%; width:14.375%;}
.swiper-slide-illust p {position:absolute; top:16.56%; left:32.03%; width:36.09%;}
.updown {animation-name:updown; animation-iteration-count:5; animation-duration:1.5s; -webkit-animation-name:updown; -webkit-animation-iteration-count:5; -webkit-animation-duration:1.5s;}
@keyframes updown {
	from, to{margin-top:0; animation-timing-function:linear;}
	50% {margin-top:5px; animation-timing-function:linear;}
}
@-webkit-keyframes updown {
	from, to{margin-top:0; animation-timing-function:linear;}
	50% {margin-top:5px; animation-timing-function:linear;}
}
.shake {animation-name:shake; animation-iteration-count:4; animation-duration:2s; -webkit-animation-name:shake; -webkit-animation-iteration-count:4; -webkit-animation-duration:2s;}
@keyframes shake {
	from, to{margin-right:-10px; animation-timing-function:ease-out;}
	50% {margin-right:0; animation-timing-function:ease-in;}
}
@-webkit-keyframes shake {
	from, to{margin-right:-10px; animation-timing-function:ease-out;}
	50% {margin-right:0; animation-timing-function:ease-in;}
}

/* video */
.video {position:absolute; top:25%; left:50%; width:75.3%; margin-left:-37.65%;}
.video .youtube {overflow:hidden; position:relative; height:0; padding-bottom:100.25%; background:#000;}
.video .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%}

/* brand */
.swiper-slide-brand .pooh {position:absolute; top:26.14%; left:50%; width:36.25%; margin-left:-18.125%; text-align:center;}

/* story */
.heySomething .swiper-slide .desc {position:absolute; top:77.08%; left:0; width:100%;}

/* comment */
.heySomething .swiper-slide .btngo {top:70%;}

.heySomething .form .choice {padding:3% 8% 0 0;}
.heySomething .form .choice li {width:33.333%; height:auto !important; margin:0; padding:0 3% 5%;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_01_v1_off.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_01_v1_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_02_v1_off.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_02_v1_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_03_v1_off.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_03_v1_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_04_v1_off.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_04_v1_on.png);}
.heySomething .form .choice li.ico5 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_05_v1_off.png);}
.heySomething .form .choice li.ico5 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_05_v1_on.png);}

.heySomething .field {margin-top:3%;}

.heySomething .commentlist ul li {position:relative; min-height:80px; padding:15px 0 15px 78px;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:1%; width:66px; height:66px; margin-top:-33px; background-repeat:no-repeat; background-position:50% 0 !important; background-size:66px auto;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_01_v1_off.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_02_v1_off.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_03_v1_off.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_04_v1_off.png);}
.heySomething .commentlist ul li .ico5 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_05_v1_off.png);}

@media all and (min-width:480px){
	.heySomething .commentlist ul li {min-height:99px; padding:22px 0 22px 110px;}
	.heySomething .commentlist ul li strong {width:99px; height:99px; margin-top:-49px; background-size:99px auto;}
}

@media all and (min-width:768px){
	.heySomething .commentlist ul li {min-height:110px; padding:30px 0 30px 150px;}
	.heySomething .commentlist ul li strong {width:110px; height:110px; margin-top:-55px; background-size:110px auto;}
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
		<% If not( left(currenttime,10)>="2016-05-24" and left(currenttime,10)<"2016-06-02" ) Then %>
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

	<!-- main contents -->
	<div class="section article">
		<!-- swiper -->
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_slide_01.jpg" alt="" />
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
							itemid = 1488140
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
						<%' for dev msg : 상품 링크 %>
						<% if isApp=1 then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1488140&amp;pEtr=70817'); return false;">
						<% else %>
							<a href="/category/category_itemPrd.asp?itemid=1488140&amp;pEtr=70817">
						<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_slide_03.gif" alt="" />
							<div class="option">
						<% If oItem.FResultCount > 0 then %>
							<%' for dev msg : 상품코드 1490116, 할인기간 5/18~5/24, 할인 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <div class="price priceEnd">...<div> / <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
							<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
								<strong class="discount">텐바이텐에서만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
								<span class="name">[Disney] Pooh Tea Infuser</span>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% Else %>
								<span class="name">[Disney] Pooh Tea Infuser</span>
								<div class="price priceEnd">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% End If %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/btn_buy.png" alt="구매하러 가기" /></div>
						<% End If %>
							</div>
						</a>
					</div>
					<%
						Set oItem = Nothing
					%>
					<div class="swiper-slide swiper-slide-illust">
						<div class="pooh updown"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_animation_pooh.png" alt="" /></div>
						<div class="butterfly shake"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_animation_butterfly.png" alt="" /></div>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/txt_disney_winnie_the_pooh.png" alt="Disney Winnie the Pooh" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_slide_04_v1.png" alt="" />
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_slide_05.jpg" alt="Disney Pooh Tea Infuser의 사이즈는 가로 11.5센치, 세로 68센치며, 소재는 푸드 그레이드 실리콘이며, 무게는 21g입니다." /></p>
					</div>

					<div class="swiper-slide swiper-slide-brand">
						<div class="pooh"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_pooh.png" alt="" /></div>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_slide_06.png" alt="마음이 답답하고 힘들 때, 배가 나오고 어리석지만 사랑스러운 곰돌이 푸와 함께 오감을 자극하는 힐랭 캠푸를 떠나보세요! 푸와 함께 하는 Healing Campooh" /></p>
					</div>

					<div class="swiper-slide">
						<div class="video">
							<div class="youtube">
								<iframe src="//player.vimeo.com/video/167360146" frameborder="0" title="Disney Pooh Tea Infuser" allowfullscreen></iframe>
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_slide_07.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1488140&amp;pEtr=70817" class="mo">
							<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/txt_story_desc_01.png" alt="#Sight 고운 색감의 잎차가 사랑스럽게 우러나오는 힐링 타임" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_slide_08.jpg" alt="" />
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1488140&amp;pEtr=70817" onclick="fnAPPpopupProduct('1488140&amp;pEtr=70817');return false;" class="app">
							<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/txt_story_desc_01.png" alt="#Sight 고운 색감의 잎차가 사랑스럽게 우러나오는 힐링 타임" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_slide_08.jpg" alt="" />
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1488140&amp;pEtr=70817" class="mo">
							<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/txt_story_desc_02.png" alt="#Hearing 또르르~ 푸를 향해 떨어지는 물소리가 주는 여유로움" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_slide_09.jpg" alt="" />
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1488140&amp;pEtr=70817" onclick="fnAPPpopupProduct('1488140&amp;pEtr=70817');return false;" class="app">
							<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/txt_story_desc_02.png" alt="#Hearing 또르르~ 푸를 향해 떨어지는 물소리가 주는 여유로움" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_slide_09.jpg" alt="" />
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1488140&amp;pEtr=70817" class="mo">
							<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/txt_story_desc_03.png" alt="#Smell 음~ 푸가 전해준 행복한 향기" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_slide_10.jpg" alt="" />
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1488140&amp;pEtr=70817" onclick="fnAPPpopupProduct('1488140&amp;pEtr=70817');return false;" class="app">
							<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/txt_story_desc_03.png" alt="#Smell 음~ 푸가 전해준 행복한 향기" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_slide_10.jpg" alt="" />
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1488140&amp;pEtr=70817" class="mo">
							<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/txt_story_desc_04.png" alt="#Taste 달콤한 디저트와 함께하면 행복감은 두 배!" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_slide_11.jpg" alt="" />
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1488140&amp;pEtr=70817" onclick="fnAPPpopupProduct('1488140&amp;pEtr=70817');return false;" class="app">
							<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/txt_story_desc_04.png" alt="#Taste 달콤한 디저트와 함께하면 행복감은 두 배!" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_slide_11.jpg" alt="" />
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1488140&amp;pEtr=70817" class="mo">
							<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/txt_story_desc_05.png" alt="" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_slide_12.jpg" alt="#Touch 통통한 푸의 배에 향긋한 잎차를 넣는 즐거움!" />
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1488140&amp;pEtr=70817" onclick="fnAPPpopupProduct('1488140&amp;pEtr=70817');return false;" class="app">
							<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/txt_story_desc_05.png" alt="" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_slide_12.jpg" alt="#Touch 통통한 푸의 배에 향긋한 잎차를 넣는 즐거움!" />
						</a>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_slide_13.jpg" alt="매일 행복하진 않지만, 행복한 일은 매일 있어! 푸와 함께하는, 오감 자극 Healing Campooh" /></p>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/img_slide_14.png" alt="Hey, something project 당신이 갖고 싶은 것 귀염둥이 푸와 함께 일상 속 힐링 캠푸를 떠나고 싶은 이유를 들려주세요! 정성껏 코멘트를 남겨주신 10분을 추첨하여 푸우 인퓨저를 선물로 드립니다 . 코멘트 작성기간은 2016년 5월 25일부터 6월 1일까지며, 발표는 6월 3일 입니다." /></p>
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
			<% If isapp="1" Then %>
				<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1488140&amp;pEtr=70817'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a>
			<% Else %>
				<a href="/category/category_itemPrd.asp?itemid=1488140&amp;pEtr=70817" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a>
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
			<form>
				<fieldset>
				<legend>Disney Pooh Tea Infuse 코멘트 쓰기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/txt_comment.png" alt="귀염둥이 푸와 함께 일상 속 힐링 캠푸를 떠나고 싶은 이유를 들려주세요! 정성껏 코멘트를 남겨주신 10분을 추첨하여 푸우 인퓨저를 선물로 드립니다 . 코멘트 작성기간은 2016년 5월 25일부터 6월 1일까지며, 발표는 6월 3일 입니다." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_01_v1_off.png" alt="Sight" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_02_v1_off.png" alt="Hearing" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_03_v1_off.png" alt="Smell" /></button>
							</li>
							<li class="ico4">
								<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_04_v1_off.png" alt="Taste" /></button>
							</li>
							<li class="ico5">
								<button type="button" value="5"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70817/m/ico_05_v1_off.png" alt="Touch" /></button>
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
					<% if isarray(split(arrCList(1,intCLoop),"!@#")) then %>
					<strong class="ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>">
						<% if split(arrCList(1,intCLoop),"!@#")(0)="1" then %>
							Sight
						<% elseif split(arrCList(1,intCLoop),"!@#")(0)="2" then %>
							Hearing
						<% elseif split(arrCList(1,intCLoop),"!@#")(0)="3" then %>
							Smell
						<% elseif split(arrCList(1,intCLoop),"!@#")(0)="4" then %>
							Taste
						<% elseif split(arrCList(1,intCLoop),"!@#")(0)="5" then %>
							Touch
						<% Else %>
							Sight
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
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery.slides.min.js"></script>
<script type="text/javascript">
$(function(){

	$(".hey").css({"opacity":"0"});
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		pagination:false,
		speed:800,
		nextButton:".btn-next",
		prevButton:".btn-prev",
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

			$(".swiper-slide.swiper-slide-illust").find(".pooh").delay(100).animate({"top":"2.7%", "left":"13.43%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-illust").find(".pooh").delay(50).animate({"top":"13.85%", "left":"26.71%", "opacity":"1"},1000);
			$(".swiper-slide.swiper-slide-illust").find(".pooh").removeClass("updown");
			$(".swiper-slide-active.swiper-slide-illust").find(".pooh").addClass("updown");

			$(".swiper-slide.swiper-slide-illust").find(".butterfly").delay(100).animate({"opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-illust").find(".butterfly").delay(800).animate({"opacity":"1"},800);
			$(".swiper-slide.swiper-slide-illust").find(".butterfly").removeClass("shake");
			$(".swiper-slide-active.swiper-slide-illust").find(".butterfly").addClass("shake");

			$(".swiper-slide.swiper-slide-brand").find(".pooh img").delay(100).animate({"width":"90%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-brand").find(".pooh img").delay(300).animate({"width":"100%", "opacity":"1"},500);

			$(".swiper-slide.swiper-slide-story").find(".desc").delay(100).animate({"margin-top":"2%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-story").find(".desc").delay(50).animate({"margin-top":"0", "opacity":"1"},500);
		}
	});

	$(".pagingNo .page strong").text(1);
	$(".pagingNo .page span").text(mySwiper.slides.length-2);

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