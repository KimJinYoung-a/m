<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 29
' History : 2016-05-17 김진영 생성
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
	eCode   =  66131
Else
	eCode   =  70746
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
.heySomething .swiper-slide-buy a {display:block;}
.heySomething .swiper-slide-buy .option {position:absolute; top:0; left:0; width:100%; height:100%; padding-top:90%; text-align:center;}
.heySomething .swiper-slide-buy .option .name span span {display:inline; margin:0 2px; color:#333;}

/* story */
.heySomething .swiper-slide .desc {position:absolute; width:100%;}
.heySomething .swiper-slide .desc1 {top:14.58%;}
.heySomething .swiper-slide .desc2 {top:44.89%;}
.heySomething .swiper-slide .desc3 {top:12.39%;}
.heySomething .swiper-slide .desc4, 
.heySomething .swiper-slide .desc5,
.heySomething .swiper-slide .desc6 {bottom:9.375%; left:0;}


/* finish */
.swiper-slide-finish .photo {position:absolute; left:0; bottom:0; width:100%; margin:0 auto;}

/* comment */
.heySomething .swiper-slide .btngo {top:70%;}

.heySomething .form .choice {padding:3% 12% 0 1%;}
.heySomething .form .choice li {width:33.333%; height:auto !important; margin:0; padding:0 3% 0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/ico_01_off.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/ico_02_off.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/ico_03_off.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/ico_03_on.png);}

.heySomething .commentlist ul li {position:relative; min-height:80px; padding:15px 0 15px 78px;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:1%; width:66px; height:66px; margin-top:-33px; background-repeat:no-repeat; background-position:50% 0 !important; background-size:66px auto;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/ico_01_off.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/ico_02_off.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/ico_03_off.png);}

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
		<% If not( left(currenttime,10)>="2016-05-17" and left(currenttime,10)<"2016-05-24" ) Then %>
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
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/img_slide_01.jpg" alt="" />
						<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project.png" alt="Hey, something project" /></strong>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>

					<div class="swiper-slide swiper-slide-story story1">
						<a href="/category/category_itemPrd.asp?itemid=1490115&amp;pEtr=70746" class="mo">
							<p class="desc desc1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/txt_desc_01_01.png" alt="점점 더워지는 날씨, 싱그럽고 기분 좋게 하루를 보내는 방법 없을까요?" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/img_slide_03.jpg" alt="스몰카라" />
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1490115&amp;pEtr=70746" onclick="fnAPPpopupProduct('1490115&amp;pEtr=70746');return false;" class="app">
							<p class="desc desc1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/txt_desc_01_01.png" alt="점점 더워지는 날씨, 싱그럽고 기분 좋게 하루를 보내는 방법 없을까요?" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/img_slide_03.jpg" alt="스몰카라" />
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story story1">
						<a href="/category/category_itemPrd.asp?itemid=1490116&amp;pEtr=70746" class="mo">
							<p class="desc desc2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/txt_desc_01_02.png" alt="블루밍앤미의 그린 leaf 디퓨저와 함께 해보세요" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/img_slide_04.jpg" alt="트로피칼" />
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1490116&amp;pEtr=70746" onclick="fnAPPpopupProduct('1490116&amp;pEtr=70746');return false;" class="app">
							<p class="desc desc2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/txt_desc_01_02.png" alt="블루밍앤미의 그린 leaf 디퓨저와 함께 해보세요" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/img_slide_04.jpg" alt="트로피칼" />
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story story1">
						<a href="/category/category_itemPrd.asp?itemid=1490114&amp;pEtr=70746" class="mo">
							<p class="desc desc3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/txt_desc_01_03.png" alt="그러운 녹색의 식물과 6가지 향기가 여러분의 일상에 힐링을 선물해 드려요" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/img_slide_05.jpg" alt="dried 유칼립투스" />
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1490114&amp;pEtr=70746" onclick="fnAPPpopupProduct('1490114&amp;pEtr=70746');return false;" class="app">
							<p class="desc desc3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/txt_desc_01_03.png" alt="그러운 녹색의 식물과 6가지 향기가 여러분의 일상에 힐링을 선물해 드려요" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/img_slide_05.jpg" alt="dried 유칼립투스" />
						</a>
					</div>

					<%' buy %>
					<%
						Dim itemid, oItem
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1490116
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
						<%' for dev msg : 상품 링크 %>
						<% if isApp=1 then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1490116&amp;pEtr=70746'); return false;">
						<% else %>
							<a href="/category/category_itemPrd.asp?itemid=1490116&amp;pEtr=70746">
						<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/img_slide_06.jpg" alt="" />
							<div class="option">
						<% If oItem.FResultCount > 0 then %>
							<%' for dev msg : 상품코드 1490116, 할인기간 5/18~5/24, 할인 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <div class="price priceEnd">...<div> / <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
							<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
								<strong class="discount">텐바이텐에서만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
								<p class="name">그린 leaf 디퓨저 (트로피칼) <span>스틱까지 높이 : 27.5cm <span>|</span> 유리병 높이 : 11cm</span></p>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% Else %>
								<p class="name">그린 leaf 디퓨저 (트로피칼) <span>스틱까지 높이 : 27.5cm <span>|</span> 유리병 높이 : 11cm</span></p>
								<div class="price priceEnd">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% End If %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="트로피칼 구매하러 가기" /></div>
						<% End If %>
							</div>
						</a>
					</div>
					<%
						Set oItem = Nothing
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1490115
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
						<%' for dev msg : 상품 링크 %>
						<% if isApp=1 then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1490115&amp;pEtr=70746'); return false;">
						<% else %>
							<a href="/category/category_itemPrd.asp?itemid=1490115&amp;pEtr=70746">
						<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/img_slide_07.jpg" alt="" />
							<div class="option">
						<% If oItem.FResultCount > 0 then %>
							<%' for dev msg : 상품코드 1490115, 할인기간 5/18~5/24, 할인 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <div class="price priceEnd">...<div> / <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
							<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
								<strong class="discount">텐바이텐에서만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
								<p class="name">그린 leaf 디퓨저 (스몰카라) <span>스틱까지 높이 : 27.5cm <span>|</span> 유리병 높이 : 11cm</span></p>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% Else %>
								<p class="name">그린 leaf 디퓨저 (스몰카라) <span>스틱까지 높이 : 27.5cm <span>|</span> 유리병 높이 : 11cm</span></p>
								<div class="price priceEnd">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% End If %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="스몰카라 구매하러 가기" /></div>
						<% End If %>
							</div>
						</a>
					</div>
					<%
						Set oItem = Nothing
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1490114
						End If

						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
						<!-- for dev msg : 상품 링크 -->
						<% if isApp=1 then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1490114&amp;pEtr=70746'); return false;">
						<% else %>
							<a href="/category/category_itemPrd.asp?itemid=1490114&amp;pEtr=70746">
						<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/img_slide_08.jpg" alt="" />
						<% If oItem.FResultCount > 0 then %>
							<div class="option">
								<%' for dev msg : 상품코드 1490114, 할인기간 5/18~5/24, 할인 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <div class="price priceEnd">...<div> / <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
							<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
								<strong class="discount">텐바이텐에서만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
								<p class="name">그린 leaf 디퓨저 (dried 유칼립투스) <span>스틱까지 높이 : 27.5cm <span>|</span> 유리병 높이 : 11cm</span></p>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% Else %>
								<p class="name">그린 leaf 디퓨저 (dried 유칼립투스) <span>스틱까지 높이 : 27.5cm <span>|</span> 유리병 높이 : 11cm</span></p>
								<div class="price priceEnd">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% End If %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="dried 유칼립투스 구매하러 가기" /></div>
						<% End If %>
							</div>
						</a>
					</div>
					<% Set oItem = Nothing %>

					<div class="swiper-slide swiper-slide-story story2">
						<a href="/category/category_itemPrd.asp?itemid=1490115&amp;pEtr=70746" class="mo">
							<p class="desc desc4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/txt_desc_02_01.png" alt="자연을 담은 향기와 함께하는 기분 좋은 휴식을 즐겨 보세요" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/img_slide_09.jpg" alt="스몰카라" />
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1490115&amp;pEtr=70746" onclick="fnAPPpopupProduct('1490115&amp;pEtr=70746');return false;" class="app">
							<p class="desc desc4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/txt_desc_02_01.png" alt="자연을 담은 향기와 함께하는 기분 좋은 휴식을 즐겨 보세요" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/img_slide_09.jpg" alt="스몰카라" />
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story story2">
						<a href="/category/category_itemPrd.asp?itemid=1490116&amp;pEtr=70746" class="mo">
							<p class="desc desc5"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/txt_desc_02_02.png" alt="화병 같은 그린 leaf 디퓨져가 카페 같은 주방을 만들어 드려요" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/img_slide_10.jpg" alt="트로피칼" />
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1490116&amp;pEtr=70746" onclick="fnAPPpopupProduct('1490116&amp;pEtr=70746');return false;" class="app">
							<p class="desc desc5"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/txt_desc_02_02.png" alt="화병 같은 그린 leaf 디퓨져가 카페 같은 주방을 만들어 드려요" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/img_slide_10.jpg" alt="트로피칼" />
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story story2">
						<a href="/category/category_itemPrd.asp?itemid=1490114&amp;pEtr=70746" class="mo">
							<p class="desc desc6"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/txt_desc_02_03.png" alt="욕실에서 보내는 시간이 많아지는 여름 시즌을 위해 준비해 보세요" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/img_slide_11.jpg" alt="dried 유칼립투스" />
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1490114&amp;pEtr=70746" onclick="fnAPPpopupProduct('1490114&amp;pEtr=70746');return false;" class="app">
							<p class="desc desc6"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/txt_desc_02_03.png" alt="욕실에서 보내는 시간이 많아지는 여름 시즌을 위해 준비해 보세요" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/img_slide_11.jpg" alt="dried 유칼립투스" />
						</a>
					</div>

					<div class="swiper-slide swiper-slide-finish">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/img_slide_12.jpg" alt="블루밍앤룽 공간을 스타일링하는 여러 가지 방법이 있습니다. 이 중 가장 고급스럽고 세련된 공간 연출법은 향기로 완성하는 공간 디자인이 아닐까 합니다. 내가 머무는 소중한 공간을 향기로 디자인 해보세요. 코끝을 스치는 기분 좋은 향기가 여러분의 일상을 더욱 행복하게 해드릴 거에요." /></p>
						<div class="photo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/img_finish_photo.jpg" alt="" /></div>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/img_slide_13.png" alt="Hey, something project 함께 하고 싶은 향기 여러분은 어떤 공간에 어떤 디퓨저를 두고 싶으세요? 정성껏 코멘트를 남겨주신 분 중 3분을 선정하여 그린 leaf 디퓨저를 보내드려요. 코멘트 작성기간은 2016년 5월 18일부터 5월 24일까지며, 발표는 5월 27일 입니다." /></p>
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
		<%'  for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/hey/70746_get.asp %>
		<div class="btnget">
			<% If isapp="1" Then %>
				<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_70746_item.asp?isApp=<%= isApp %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a>
			<% Else %>
				<a href="/event/etc/hsp/inc_70746_item.asp?isApp=<%= isApp %>" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a>
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
				<legend>그린 leaf 디퓨저 코멘트 쓰기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/txt_comment.png" alt="여러분은 어떤 공간에 어떤 디퓨저를 두고 싶으세요? 정성껏 코멘트를 남겨주신 분 중 3분을 선정하여 그린 leaf 디퓨저를 보내드려요. 코멘트 작성기간은 2016년 5월 18일부터 5월 24일까지며, 발표는 5월 27일 입니다." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/ico_01_off.png" alt="bathroom" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/ico_02_off.png" alt="kitchen" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70746/m/ico_03_off.png" alt="bedroom" /></button>
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
							bathroom
						<% elseif split(arrCList(1,intCLoop),"!@#")(0)="2" then %>
							kitchen
						<% elseif split(arrCList(1,intCLoop),"!@#")(0)="3" then %>
							bedroom
						<% Else %>
							bathroom
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

			$(".swiper-slide.story1").find(".desc").delay(100).animate({"margin-left":"5%", "opacity":"0"},300);
			$(".swiper-slide-active.story1").find(".desc").delay(50).animate({"margin-left":"0", "opacity":"1"},500);

			$(".swiper-slide.story2").find(".desc").delay(100).animate({"margin-bottom":"-3%", "opacity":"0"},300);
			$(".swiper-slide-active.story2").find(".desc").delay(50).animate({"margin-bottom":"0", "opacity":"1"},500);

			$(".swiper-slide.swiper-slide-finish").find(".photo").delay(100).animate({"width":"95%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-finish").find(".photo").delay(50).animate({"width":"100%", "opacity":"1"},500);
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