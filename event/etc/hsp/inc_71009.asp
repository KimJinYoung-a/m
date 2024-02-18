<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 34
' History : 2016-05-31 유태욱 생성
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
	eCode   =  66140
Else
	eCode   =  71009
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
.heySomething .swiper-slide-buy .option {width:100%; padding-top:5.5%; text-align:center;}
.heySomething .swiper-slide-buy .option a {display:block;}
.heySomething .swiper-slide-buy .pre {display:inline-block; margin-bottom:5px; padding:5px 10px 2px; color:#fff; font-size:11px; font-weight:bold; background:#000; border-radius:12px;}
.heySomething .option .name {font-size:18px; line-height:1.2; font-weight:bold; font-family:arial;}
.heySomething .option .name span {display:inline-block; color:#777;}
.heySomething .brand .pic {position:absolute; left:16.8%; top:25.52%; width:66.4%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_clothes.jpg) 50% 50% no-repeat; background-size:130% 130%;}
.heySomething .desc p {position:absolute; left:0; bottom:0; width:100%;}
.heySomething .intro p {position:absolute; left:0;top:13.3%; width:100%;}
.heySomething .duckooItem ul {position:absolute; left:0; top:42%; width:100%; height:50%;}
.heySomething .duckooItem li {float:left; width:33%; height:50%;}
.heySomething .duckooItem li:first-child {margin-left:17%;}
.heySomething .duckooItem li a {display:block; width:100%; height:100%; background:transparent; text-indent:-999em;}
/* comment */
.heySomething .form .choice {margin-right:-1.5%;}
.heySomething .form .choice li {width:33.33333%; height:auto !important; margin:0; padding:0 1.8%;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_01.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_02.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_03.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_04.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_04_on.png);}
.heySomething .form .choice li.ico5 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_05.png);}
.heySomething .form .choice li.ico5 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_05_on.png);}
.heySomething .commentlist ul li {position:relative; min-height:91px; padding:15px 0 15px 78px;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:1%; width:70px; height:70px; margin-top:-35px; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_01.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_02.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_03.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_04.png);}
.heySomething .commentlist ul li .ico5 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_05.png);}

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
	window.$('html,body').animate({scrollTop:$("#commentevt").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-05-31" and left(currenttime,10)<"2017-01-01" ) Then %>
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
					alert("코맨트를 남겨주세요.\n한글 400자 까지 작성 가능합니다.");
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
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_slide_01.jpg" alt="" />
						<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project.png" alt="Hey, something project" /></strong>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>
					<div class="swiper-slide intro">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_slide_03.jpg" alt="" />
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/txt_intro.png" alt="갑자기 더워진 날씨에 튜브만 들고 뛰쳐나온 더쿠! 미쳐 숨기지 못한 볼록한 배와 봉긋 솟은 꼬리. 더쿠의 매력 속으로 빠져볼까요!" /></p>
					</div>

					<!-- buy1 -->
					<%
						Dim itemid, oItem
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1500617
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
						<!-- for dev msg : 상품 링크 -->
						<% if isApp=1 then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1500617&amp;pEtr=71009'); return false;">
						<% else %>
							<a href="/category/category_itemPrd.asp?itemid=1500617&amp;pEtr=71009">
						<% End If %>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_slide_04.jpg" alt="" /></p>
							<div class="option">
							<% If oItem.FResultCount > 0 then %>
								<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
									<span class="pre">텐바이텐 단독 선오픈</span>
									<em class="name">DUCKOO Series Figure<br /><span>Size : W7 X H10 (cm)</span></em>
									<div class="price">
										<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
									</div>
								<% Else %>
									<span class="pre">텐바이텐 단독 선오픈</span>
									<em class="name">DUCKOO Series Figure<br /><span>Size : W7 X H10 (cm)</span></em>
									<div class="price">
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
									</div>
								<% end if %>
									<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
							<% End If %>
							</div>
						</a>
					</div>
					<% Set oItem = Nothing %>

					<div class="swiper-slide duckooItem">
						<ul>
							<li><a href="/category/category_itemPrd.asp?itemid=1500617&amp;pEtr=71009" onclick="fnAPPpopupProduct('1500617&amp;pEtr=71009');return false;">BASIC</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1464413&amp;pEtr=71009" onclick="fnAPPpopupProduct('1464413&amp;pEtr=71009');return false;">BEING</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1464414&amp;pEtr=71009" onclick="fnAPPpopupProduct('1464414&amp;pEtr=71009');return false;">CAMPING</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1464415&amp;pEtr=71009" onclick="fnAPPpopupProduct('1464415&amp;pEtr=71009');return false;">WORKING</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1464416&amp;pEtr=71009" onclick="fnAPPpopupProduct('1464416&amp;pEtr=71009');return false;">SWIMMING</a></li>
						</ul>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_slide_05.jpg" alt="귀여운 더쿠 피규어가 여름을 맞이하여 베이직 버전으로 돌아왔어요! 튜브를 타고 있는 더쿠!  더쿠와 함께 이번 여름을 맞이하세요!" />
					</div>

					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_slide_06.jpg" alt="" /></div>

					<!-- buy2 -->
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1500618
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
						<!-- for dev msg : 상품 링크 -->
						<% if isApp=1 then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1500618&amp;pEtr=71009'); return false;">
						<% else %>
							<a href="/category/category_itemPrd.asp?itemid=1500618&amp;pEtr=71009">
						<% End If %>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_slide_07.jpg" alt="" /></p>
							<div class="option">
							<% If oItem.FResultCount > 0 then %>
								<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
									<span class="pre">텐바이텐 선오픈</span>
									<em class="name">DUCKOO Series Figure<br /><span>Size : W7 X H10 (cm)</span></em>
									<div class="price">
										<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
									</div>
								<% Else %>
									<span class="pre">텐바이텐 선오픈</span>
									<em class="name">DUCKOO NOTE<br /><span>W105 x H170 (mm)</span></em>
									<div class="price">
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
									</div>
								<% end if %>
									<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
							<% End If %>
							</div>
						</a>
					</div>
					<% Set oItem = Nothing %>

					<div class="swiper-slide duckooItem">
						<ul>
							<li><a href="/category/category_itemPrd.asp?itemid=1500618&amp;pEtr=71009" onclick="fnAPPpopupProduct('1500618&amp;pEtr=71009');return false;">냠냠노트</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1500619&amp;pEtr=71009" onclick="fnAPPpopupProduct('1500619&amp;pEtr=71009');return false;">킁킁노트</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1500621&amp;pEtr=71009" onclick="fnAPPpopupProduct('1500621&amp;pEtr=71009');return false;">톡톡노트</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1500620&amp;pEtr=71009" onclick="fnAPPpopupProduct('1500620&amp;pEtr=71009');return false;">봄봄노트</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1500623&amp;pEtr=71009" onclick="fnAPPpopupProduct('1500623&amp;pEtr=71009');return false;">유후노트</a></li>
						</ul>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_slide_note.jpg" alt="품질을 자랑하는 한국 폼텍과 콜라보한 더쿠의 오감노트 더쿠피규어가 그려진 매력적인 노트! 언제나 더쿠와 함께해요!" />
					</div>

					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_slide_08.gif" alt="초코사이다는 쓰고, 그리고, 만드는 콘텐츠 창작 집단입니다. 우리는 ‘더쿠(DUCKOO)’라는 캐릭터를 통해 누구나 가진 소소한 것에 대한 호기심을 이야기합니다. 그리고 진정 하고 싶은 일을 스스로 알아가는 콘텐츠를 만들며 이러한 주제를 조금 엉뚱하고 단순하게 표현합니다. 우리의 콘텐츠와 제품을 접하는 사람들이 즐거움과 위안, 작은 동기까지도 얻기를 바랍니다. 그래서 새로운 이야기가 더 많이 생겨나고, 공유되면 좋겠습니다." /></div>

					<div class="swiper-slide desc">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_slide_09.jpg" alt="" />
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/txt_desc_01.png" alt="미쳐 숨기지 못한 볼록한 배와 봉긋 솟은 꼬리. 갑자기 더워진 날씨에 튜브만 들고 뛰쳐나온 더쿠" /></p>
					</div>
					<div class="swiper-slide desc">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_slide_10.jpg" alt="" />
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/txt_desc_02.png" alt="우연히 본 패션 잡지 기사를 따라 멀쩡한 깔깔이에 염색을 한 더쿠" /></p>
					</div>
					<div class="swiper-slide desc">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_slide_11.jpg" alt="" />
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/txt_desc_03.png" alt="침낭에 꽂혀 추운 겨울 갑작스레 홀로 캠핑을 떠난 더쿠" /></p>
					</div>
					<div class="swiper-slide desc">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_slide_12.jpg" alt="" />
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/txt_desc_04.png" alt="드라마 속 실장님의 매력에 반해 워커홀릭을 자처한 더쿠" /></p>
					</div>
					<div class="swiper-slide desc">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_slide_13.jpg" alt="" />
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/txt_desc_05.png" alt="해양 다큐멘터리를 보고 난 뒤에는 해녀의 물질을 배운 더쿠" /></p>
					</div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_slide_14.jpg" alt="" /></div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_slide_15_v2.png" alt="내 모습을 가장 많이 닮은 더쿠는 무엇인가요?! 정성스러운 코멘트를 남겨주신 15분을 추첨하여 베이직 더쿠 5개/노트5개/스티커5개를 드립니다(랜덤발송)" /></p>
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
		<div class="btnget">
			<% If isapp="1" Then %>
				<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_71009_item.asp?isApp=<%= isApp %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a>
			<% Else %>
				<a href="/event/etc/hsp/inc_71009_item.asp?isApp=<%= isApp %>" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a>
			<% End If %>
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
				<legend>코멘트 쓰기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/txt_comment_v2.png" alt="내 모습을 가장 많이 닮은 더쿠는 무엇인가요?! 정성스러운 코멘트를 남겨주신 15분을 추첨하여 베이직 더쿠 4개/노트 5개/스티커 5개를 드립니다. (랜덤발송)" /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_01.png" alt="BASIC" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_02.png" alt="BEING" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_03.png" alt="CAMPING" /></button>
							</li>
							<li class="ico4">
								<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_04.png" alt="WORKING" /></button>
							</li>
							<li class="ico5">
								<button type="button" value="5"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/ico_05.png" alt="SWIMMING" /></button>
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

		<!-- for dev msg : comment list -->
		<div class="commentlist">
			<p class="total">total <%=iCTotCnt%></p>
			<% IF isArray(arrCList) THEN %>
			<ul>
				<% For intCLoop = 0 To UBound(arrCList,2) %>
				<li>
					<% if isarray(split(arrCList(1,intCLoop),"!@#")) then %>
					<strong class="ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>">
						<% if split(arrCList(1,intCLoop),"!@#")(0)="1" then %>
							BASIC
						<% elseif split(arrCList(1,intCLoop),"!@#")(0)="2" then %>
							BEING
						<% elseif split(arrCList(1,intCLoop),"!@#")(0)="3" then %>
							CAMPING
						<% elseif split(arrCList(1,intCLoop),"!@#")(0)="4" then %>
							WORKING
						<% elseif split(arrCList(1,intCLoop),"!@#")(0)="5" then %>
							SWIMMING
						<% Else %>
							BASIC
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
	<div id="dimmed"></div>
</div>

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
			$(".swiper-slide.intro").find("p").delay(100).animate({"margin-top":"10px", "opacity":"0"},300);
			$(".swiper-slide-active.intro").find("p").animate({"margin-top":"0", "opacity":"1"},600);
			$(".swiper-slide.desc").find("p").delay(100).animate({"margin-bottom":"-2%", "opacity":"0"},400);
			$(".swiper-slide-active.desc").find("p").delay(50).animate({"margin-bottom":"0", "opacity":"1"},300);
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
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->