<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 20 M&A
' History : 2016-02-16 원승현 생성
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
	eCode   =  66031
Else
	eCode   =  68959
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
	itemid   =  1418254
End If

dim oItem
%>
<style type="text/css">
.finishEvt {display:none;}

.heySomething .article .btnget {width:38.43%; margin-left:-19.215%;}
.heySomething .swiper-slide {overflow:hidden;}
.heySomething .app {display:none;}

/* title */
.heySomething .swiper-slide .hey {position:absolute; top:6.5%; left:0; width:100%;}

/* item */
.heySomething .swiper-slide h3 {position:absolute; top:11%; left:50%; width:90.625%; margin-left:-45.3125%;}
.heySomething .swiper-slide .desc {position:absolute; bottom:9.5%; right:50%; width:93.75%; margin-right:-46.875%;}

.itemList li {position:absolute; width:21.875%;}
.itemList li a {display:block;}
.itemList li a img {transition:transform .7s ease; -webkit-transition:transform .7s ease;}
.itemList li a:active img, .itemList li a:hover img {transform:rotate(360deg); -webkit-transform:rotate(360deg);}

.swiper-slide-item01 .itemList li.item01 {top:15.5%; right:5%;}
.swiper-slide-item01 .itemList li.item02 {top:31.5%; left:16%;}
.swiper-slide-item01 .itemList li.item03 {top:45%; right:25%;}

.swiper-slide-item02 .itemList li.item01 {top:10%; left:16%;}
.swiper-slide-item02 .itemList li.item02 {top:19%; left:53%;}
.swiper-slide-item02 .itemList li.item03 {top:38.5%; left:36%;}
.swiper-slide-item02 .itemList li.item04 {top:60%; right:5.5%;}

.swiper-slide-item03 .itemList li.item01 {top:19.5%; left:8.5%;}
.swiper-slide-item03 .itemList li.item02 {top:46%; left:50.5%;}

.heySomething .swiper-slide-item04 .desc {bottom:12%}
.swiper-slide-item04 .itemList li.item01 {top:18%; left:24.5%;}
.swiper-slide-item04 .itemList li.item02 {top:34%; left:31%;}
.swiper-slide-item04 .itemList li.item03 {top:37.5%; left:3%;}
.swiper-slide-item04 .itemList li.item04 {top:62.5%; left:25.5%;}

.swiper-slide-item05 .itemList li.item01 {top:17.5%; left:32%;}
.swiper-slide-item05 .itemList li.item02 {top:34.5%; left:1%;}
.swiper-slide-item05 .itemList li.item03 {top:59.5%; left:0%;}
.swiper-slide-item05 .itemList li.item04 {top:36%; right:3.5%;}

.swiper-slide-item06 .itemList li.item01 {top:24.5%; left:14%;}
.swiper-slide-item06 .itemList li.item02 {top:17.5%; right:24%;}
.swiper-slide-item06 .itemList li.item03 {top:44%; right:28%;}

.heySomething .swiper-slide-item07 .desc {bottom:12%}
.swiper-slide-item07 .itemList li.item01 {top:48.5%; left:9%;}
.swiper-slide-item07 .itemList li.item02 {top:47%; right:28%;}
.swiper-slide-item07 .itemList li.item03 {top:36%; right:-2%;}

.swiper-slide-item08 .itemList li.item01 {top:45%; left:14%;}
.swiper-slide-item08 .itemList li.item02 {top:33%; right:-5%;}

.swiper-slide-item09 .itemList li.item01 {top:30%; right:10%;}

.heySomething .swiper-slide-item10 .desc {bottom:77%}
.swiper-slide-item10 .itemList li.item01 {top:40%; right:30%;}

/* comment */
.heySomething .form .choice {margin-right:-1.5%;}
.heySomething .form .choice li {width:20%; height:auto !important; margin:0; padding:0 1.5% 4% 0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_01.jpg);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_01_on.jpg);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_02.jpg);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_02_on.jpg);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_03.jpg);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_03_on.jpg);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_04.jpg);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_04_on.jpg);}
.heySomething .form .choice li.ico5 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_05.jpg);}
.heySomething .form .choice li.ico5 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_05_on.jpg);}

.heySomething .commentlist ul li {position:relative; min-height:91px; padding:15px 0 15px 78px;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:1%; width:52px; height:70px; margin-top:-35px; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_01.jpg);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_02.jpg);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_03.jpg);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_04.jpg);}
.heySomething .commentlist ul li .ico5 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_05.jpg);}

@media all and (min-width:480px){
	.heySomething .commentlist ul li {min-height:135px; padding:22px 0 22px 110px;}
	.heySomething .commentlist ul li strong {width:78px; height:105px; margin-top:-52px;}
}

@media all and (min-width:768px){
	.heySomething .commentlist ul li {min-height:180px; padding:30px 0 30px 150px;}
	.heySomething .commentlist ul li strong {width:105px; height:142px; margin-top:-71px;}
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
		<% If not( left(currenttime,10)>="2016-02-16" and left(currenttime,10)<"2016-02-24" ) Then %>
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
	<% '' main contents  %>
	<div class="section article" id="toparticle">
		<%'' swiper %>
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide swiper-slide-topic">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/img_slide_01.jpg" alt="" />
						<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project_white.png" alt="Hey, something project" /></strong>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>

					<div class="swiper-slide swiper-slide-brand">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/img_slide_03.jpg" alt="High tide가 가진 만조라는 뜻처럼 HIGHTIDE라는 이름은 언제나 가득 채워져 있는 느낌을 줍니다. 마음까지 채울 수 있는 제품을 만들고자 하는 생각에서 시작하였습니다. 당신의 개인적인 일상과 작업 공간 사이를 긍정적인 기운으로 풍족하게 채워 주는 제품들. HIGHTIDE로 인해 당신의 생활과 마음 모두, 가득 채워지기를 바랍니다." /></p>
					</div>

					<div class="swiper-slide swiper-slide-item01">
						<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/tit_collection_01.png" alt="Collection #1 OLD-SCHOOL CLIP" /></h3>
						<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/txt_desc_01.png" alt="클릭 몇 번이면 온갖 것들이 한 폴더에 담기는 요즘 시대의 가장 아날로그적인 묶음 도구, 클립과 클립보드." /></p>
						<ul class="itemList mo">
							<li class="item01">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423355&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423355&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Penco Clipboard O/S A4" />
								</a>
							</li>
							<li class="item02">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423342&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423342&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Penco Clampy Clip Color S" />
								</a>
							</li>
							<li class="item03">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423354&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423354&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Penco Clipboard O/S A5" />
								</a>
							</li>
						</ul>
						<ul class="itemList app">
							<li class="item01">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423355&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423355&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Penco Clipboard O/S A4" />
								</a>
							</li>
							<li class="item02">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423342&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423342&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Penco Clampy Clip Color S" />
								</a>
							</li>
							<li class="item03">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423354&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423354&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Penco Clipboard O/S A5" />
								</a>
							</li>
						</ul>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/img_slide_04_v1.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-item02">
						<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/txt_desc_02.png" alt="조금은 투박하지만 종이냄새 물씬 나는, 나만의 빈티지 클립 컬렉션." /></p>
						<ul class="itemList mo">
							<li class="item01">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423339&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423339&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Penco Clampy Clip Silver M" />
								</a>
							</li>
							<li class="item02">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423341&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423341&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Penco Clampy Clip Gold M" />
								</a>
							</li>
							<li class="item03">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423360&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423360&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Penco Clipboard O/S Gold A5" />
								</a>
							</li>
							<li class="item04">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423345&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423345&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Penco Clipboard O/S Check" />
								</a>
							</li>
						</ul>
						<ul class="itemList app">
							<li class="item01">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423339&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423339&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Penco Clampy Clip Silver M" />
								</a>
							</li>
							<li class="item02">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423341&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423341&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Penco Clampy Clip Gold M" />
								</a>
							</li>
							<li class="item03">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423360&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423360&amp;pEtr=68959" onclick="fnAPPpopupProduct('1423360&amp;pEtr=68959');return false;">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Penco Clipboard O/S Gold A5" />
								</a>
							</li>
							<li class="item04">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423345&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423345&amp;pEtr=68959" onclick="fnAPPpopupProduct('1423345&amp;pEtr=68959');return false;">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Penco Clipboard O/S Check" />
								</a>
							</li>
						</ul>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/img_slide_05_v1.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-item03">
						<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/tit_collection_02.png" alt="Collection #2 MY IMPORTANT" /></h3>
						<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/txt_desc_03.png" alt="독일어로 나의 중요한이라는 뜻의 MEINE WICHTIGE. 서류, 통장, 명함, 여권이야말로 종이로 된 것들 중 개인에게 가장 중요한 것." /></p>
						<ul class="itemList mo">
							<li class="item01">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423437&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423437&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Document Case A4 Classic" />
								</a>
							</li>
							<li class="item02">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423443&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423443&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Smart Card Case" />
								</a>
							</li>
						</ul>
						<ul class="itemList app">
							<li class="item01">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423437&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423437&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Document Case A4 Classic" />
								</a>
							</li>
							<li class="item02">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423443&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423443&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Smart Card Case" />
								</a>
							</li>
						</ul>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/img_slide_06.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-item04">
						<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/txt_desc_04.png" alt="중요한 것을 가장 멋스럽게 담을 수 있는 아이템." /></p>
						<ul class="itemList mo">
							<li class="item01">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423442&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423442&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Case Holder 2P Classic" />
								</a>
							</li>
							<li class="item02">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423441&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423441&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Case Holder 1P Classic" />
								</a>
							</li>
							<li class="item03">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423439&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423439&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Bankbook Case Classic" />
								</a>
							</li>
							<li class="item04">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423440&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423440&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Pass&amp;Card Case Classic" />
								</a>
							</li>
						</ul>
						<ul class="itemList app">
							<li class="item01">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423442&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423442&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Case Holder 2P Classic" />
								</a>
							</li>
							<li class="item02">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423441&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423441&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Case Holder 1P Classic" />
								</a>
							</li>
							<li class="item03">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423439&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423439&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Bankbook Case Classic" />
								</a>
							</li>
							<li class="item04">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423440&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423440&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Pass&amp;Card Case Classic" />
								</a>
							</li>
						</ul>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/img_slide_07_v1.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-item05">
						<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/tit_collection_03.png" alt="Collection #3 HAPPY VIRUS" /></h3>
						<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/txt_desc_05.png" alt="생동감 넘치는 접착메모지, 집 모양의 앨범, 야구배트 펜, 책처럼 생긴 수납박스…" /></p>
						<ul class="itemList mo">
							<li class="item01">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423413&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423413&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Standing Notes World Sports" />
								</a>
							</li>
							<li class="item02">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423444&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423444&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Shoehorn Keychain" />
								</a>
							</li>
							<li class="item03">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423449&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423449&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Ifuku Kazuhiko Reading Paper Box" />
								</a>
							</li>
							<li class="item04">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423411&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423411&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Sticky Memo Funny Face" />
								</a>
							</li>
						</ul>
						<ul class="itemList app">
							<li class="item01">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423413&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423413&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Standing Notes World Sports" />
								</a>
							</li>
							<li class="item02">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423444&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423444&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Shoehorn Keychain" />
								</a>
							</li>
							<li class="item03">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423449&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423449&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Ifuku Kazuhiko Reading Paper Box" />
								</a>
							</li>
							<li class="item04">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423411&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423411&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Sticky Memo Funny Face" />
								</a>
							</li>
						</ul>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/img_slide_08.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-item06">
						<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/txt_desc_06.png" alt="소소한 아이디어들이 모여 일상 가득 번지는 해피 바이러스로!" /></p>
						<ul class="itemList mo">
							<li class="item01">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423412&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423412&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Standing Notes" />
								</a>
							</li>
							<li class="item02">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423414&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423414&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Little Toy Pocket Album House" />
								</a>
							</li>
							<li class="item03">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423447&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423447&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Penco Bat pen" />
								</a>
							</li>
						</ul>
						<ul class="itemList app">
							<li class="item01">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423412&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423412&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Standing Notes" />
								</a>
							</li>
							<li class="item02">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423414&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423414&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Little Toy Pocket Album House" />
								</a>
							</li>
							<li class="item03">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423447&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423447&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Penco Bat pen" />
								</a>
							</li>
						</ul>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/img_slide_09.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-item07">
						<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/tit_collection_04.png" alt="Collection #4 BOOKWORM" /></h3>
						<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/txt_desc_07.png" alt="책벌레들의 기본 아이템은 뭐니뭐니해도 북마크와 북스탠드." /></p>
						<ul class="itemList mo">
							<li class="item01">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423445&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423445&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Wire Clip Bookmarker" />
								</a>
							</li>
							<li class="item02">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423429&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423429&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Ifuku Pen Hook Clips" />
								</a>
							</li>
							<li class="item03">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423415&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423415&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Metal Book Stand" />
								</a>
							</li>
						</ul>
						<ul class="itemList app">
							<li class="item01">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423445&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423445&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Wire Clip Bookmarker" />
								</a>
							</li>
							<li class="item02">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423429&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423429&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Ifuku Pen Hook Clips" />
								</a>
							</li>
							<li class="item03">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423415&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423415&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Metal Book Stand" />
								</a>
							</li>
						</ul>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/img_slide_10.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-item08">
						<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/txt_desc_08.png" alt="독서의 품격을 업그레이드시키는 아이템으로 풍성해지는 마음의 양식." /></p>
						<ul class="itemList mo">
							<li class="item01">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423426&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423426&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Viale Book Marker" />
								</a>
							</li>
							<li class="item02">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423419&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423419&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Three Wire Display Stand S" />
								</a>
							</li>
						</ul>
						<ul class="itemList app">
							<li class="item01">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423426&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423426&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Viale Book Marker" />
								</a>
							</li>
							<li class="item02">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423419&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423419&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Three Wire Display Stand S" />
								</a>
							</li>
						</ul>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/img_slide_11_v1.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-item09">
						<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/tit_collection_05.png" alt="Collection #5 STORAGE IN STORAGE" /></h3>
						<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/txt_desc_09.png" alt="선물상자를 열면 또 다른 선물상자가 나오듯, 4개의 선물같은 수납박스가 한 번에." /></p>
						<ul class="itemList">
							<li class="item01">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423410&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423410&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Penco Storage Container" />
								</a>
							</li>
						</ul>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/img_slide_12.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-item10">
						<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/txt_desc_10.png" alt="살 때마다 사이즈로 고민하던 수납박스 대신 하나하나 채워 차곡차곡 쌓아 놓는 재미로 가득." /></p>
						<ul class="itemList">
							<li class="item01">
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1423410&amp;pEtr=68959');return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1423410&amp;pEtr=68959">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/btn_plus.png" alt="Penco Storage Container" />
								</a>
							</li>
						</ul>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/img_slide_13_v1.jpg" alt="" />
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/img_slide_14.jpg" alt="일상 가득히 HIGHTIDE" /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/img_slide_15.png" alt="HIGHTIDE 상품 중 가장 탐나는 상품은 무엇인가요? 정성껏 코멘트를 남겨주신 3분을 추첨하여 해당 컬렉션의 상품을 드립니다. 상품은 랜덤발송입니다. 코멘트 작성 기간은 2016년 2월 17일부터 2월 23일까지며 발표일은 2월 25일입니다." /></p>
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
		
		<!-- 브랜드샵 바로가기 버튼 -->
		<div class="btnget mo">
			<% If isApp="1" Then %>
				<a href="" onclick="fnAPPpopupBrand('HIGHTIDE');return false;">
			<% Else %>
				<a href="/street/street_brand.asp?makerid=HIGHTIDE">
			<% End If %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_brand_shop_v1.png" alt="BRAND SHOP" />
			</a>
		</div>
		<div class="btnget app">
			<% If isApp="1" Then %>
				<a href="" onclick="fnAPPpopupBrand('HIGHTIDE');return false;">
			<% Else %>
				<a href="/street/street_brand.asp?makerid=HIGHTIDE">
			<% End If %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_brand_shop_v1.png" alt="BRAND SHOP" />
			</a>
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
				<legend>코멘트 쓰기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/txt_comment.png" alt="HIGHTIDE 상품 중 가장 탐나는 상품은 무엇인가요? 정성껏 코멘트를 남겨주신 3분을 추첨하여 해당 컬렉션의 상품을 드립니다. 상품은 랜덤발송입니다. 코멘트 작성 기간은 2016년 2월 17일부터 2월 23일까지며 발표일은 2월 25일입니다." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_01.jpg" alt="OLD-SCHOOL CLIP" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_02.jpg" alt="MY IMPORTANT" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_03.jpg" alt="HAPPY VIRUS" /></button>
							</li>
							<li class="ico4">
								<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_04.jpg" alt="BOOKWORM" /></button>
							</li>
							<li class="ico5">
								<button type="button" value="5"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68959/m/ico_05.jpg" alt="STORAGE IN STORAGE" /></button>
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
									OLD-SCHOOL CLIP
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="2" then %>
									MY IMPORTANT
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="3" then %>
									HAPPY VIRUS
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="4" then %>
									BOOKWORM
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="5" then %>
									STORAGE IN STORAGE
								<% Else %>
									OLD-SCHOOL CLIP
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
	<%'' //comment event %>

	<div id="dimmed"></div>
</div>

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

			$(".swiper-slide").find("h3").delay(100).animate({"margin-left":"46%", "opacity":"0"},300);
			$(".swiper-slide-active").find("h3").animate({"margin-left":"-45.3125%", "opacity":"1"},500);
			$(".swiper-slide").find(".desc").delay(100).animate({"margin-right":"45%", "opacity":"0"},400);
			$(".swiper-slide-active").find(".desc").animate({"margin-right":"-46.875%", "opacity":"1"},500);
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