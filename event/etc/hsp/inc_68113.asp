<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 16
' History : 2015-12-22 원승현 생성
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
	eCode   =  65993
Else
	eCode   =  68133
End If

dim userid, i
	userid = GetEncLoginUserID()

dim commentcount
commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim itemid
IF application("Svr_Info") = "Dev" THEN
	itemid   =  1239115
Else
	itemid   =  1405559
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

/* title */
.heySomething .swiper-slide .hey {position:absolute; top:6.5%; left:0; width:100%;}

/* buy */
.heySomething .swiper-slide-buy .option {position:absolute; top:58%; left:0; width:100%; text-align:center;}
.heySomething .swiper-slide-buy .option a {display:block;}
.heySomething .option .name {min-height:28px;}

/* item */
.heySomething .siwper-slide-item .item {overflow:hidden; position:absolute; top:12%; left:50%; width:98%; margin-left:-49%;}
.heySomething .siwper-slide-item .item a {overflow:hidden; display:block; position:relative; height:0; margin:0 8%; padding-bottom:88.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.heySomething .siwper-slide-item .item a span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter: alpha(opacity=0); cursor:pointer;}

/* copy */
.heySomething .copy {position:absolute; left:0; top:10%; width:100%; height:6%;}
.heySomething .copy .line {position:absolute; left:50%; top:0; width:5%; height:1px; margin-left:-2.5%; background:#adadaf;}
.heySomething .copy p {position:absolute; left:0; bottom:0; width:100%;}

/* brand */
.heySomething .swiper-slide-brand .brand {position:absolute; top:7%; left:0; width:100%;}
.heySomething .swiper-slide-brand .brand p {margin-top:8%;}

/* story */
.heySomething .swiper-slide .desc {position:absolute; top:19%; left:0; width:100%;}
.heySomething .swiper-slide .desc3 {top:78.5%;}
.heySomething .swiper-slide .desc4 {top:10%;}
.heySomething .swiper-slide .desc5 {top:19%;}
.heySomething .swiper-slide .desc6 {top:9%;}

/* finish */
.heySomething .swiper-slide .finish {position:absolute; top:25%; left:0; width:100%;}

/* comment */
.heySomething .swiper-slide .btngo {top:78%;}

.heySomething .form .choice {margin:2% 0 5%;}
.heySomething .form .choice li {width:33.33%; height:auto !important; margin:0; padding:0 5% 3% 1%;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_01.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_02.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_03.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_04.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_04_on.png);}
.heySomething .form .choice li.ico5 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_05.png);}
.heySomething .form .choice li.ico5 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_05_on.png);}
.heySomething .form .choice li.ico6 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_06.png);}
.heySomething .form .choice li.ico6 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_06_on.png);}

.heySomething .commentlist ul li {position:relative; min-height:91px; padding:15px 0 15px 78px;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:1%; width:61px; height:61px; margin-top:-29px; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_01.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_02.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_03.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_04.png);}
.heySomething .commentlist ul li .ico5 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_05.png);}
.heySomething .commentlist ul li .ico6 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_06.png);}

@media all and (min-width:480px){
	.heySomething .option .name {min-height:42px;}
	.heySomething .commentlist ul li {min-height:135px; padding:22px 0 22px 135px;}
	.heySomething .commentlist ul li strong {width:91px; height:91px; margin-top:-45px;}
}

@media all and (min-width:768px){
	.heySomething .commentlist ul li {min-height:166px; padding:22px 0 22px 135px;}
	.heySomething .commentlist ul li strong {width:122px; height:122px; margin-top:-58px;}
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
	window.$('html,body').animate({scrollTop:$(".mEvt68113").offset().top}, 0);
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
		<% If not( left(currenttime,10)>="2015-12-23" and left(currenttime,10)<"2015-12-30" ) Then %>
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
	<%' main contents %>
	<div class="section article">
		<%' swiper %>
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">

					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_slide_01_v1.jpg" alt="" />
						<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project.png" alt="Hey, something project" /></strong>
						<div class="btnget">
							<% if isApp then %>
								<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_68113_item.asp?isApp=<%= isApp %>'); return false;" >
							<% else %>
								<a href="/event/etc/hsp/inc_68113_item.asp?isApp=<%= isApp %>" target="_blank">
							<% end if %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" />
							</a>
						</div>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
						<div class="btnget">
							<% if isApp then %>
								<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_68113_item.asp?isApp=<%= isApp %>'); return false;" >
							<% else %>
								<a href="/event/etc/hsp/inc_68113_item.asp?isApp=<%= isApp %>" target="_blank">
							<% end if %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" />
							</a>
						</div>
					</div>

					<%' buy %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid   =  1046389
						else
							itemid   =  1403591
						end if
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
						<% If isapp="1" Then %>
							<a href="" onclick="fnAPPpopupProduct('1403591'); return false;">
						<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=1403591&pEtr=68133">
						<% End If %>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_slide_03.jpg" alt="" /></p>
							<div class="option">
								<%
									''//<div class="price">...</div>에는 클래스 priceEnd을 붙이고 <s>....<s>숨겨주세요
								%>
								<% if oItem.FResultCount > 0 then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<% If oItem.Prd.FOrgprice = 0 Then %>
										<% else %>
											<strong class="discount">텐바이텐에서만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
										<% End If %>
										<em class="name">WOOUF Laptop Sleeve <span>13형</span></em>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<em class="name">WOOUF Laptop Sleeve <span>13형</span></em>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
								<% End If %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="WOOUF Laptop Sleeve 구매하러 가기" /></div>
							</div>
						</a>
						<%' for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/68133_get_pineapple.asp %>
						<div class="btnget">
							<% If isapp="1" Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_68113_pineapple.asp?isApp=<%= isApp %>'); return false;" >
							<% Else %>
								<a href="/event/etc/hsp/inc_68113_pineapple.asp?isApp=<%= isApp %>" target="_blank">
							<% End If %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" />
							</a>
						</div>
					</div>
					<% set oItem=nothing %>

					<%' item %>
					<div class="swiper-slide siwper-slide-item">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_slide_04_v1.jpg" alt="늘 비슷한 옷으로 지루해하던 노트북과 태블릿PC가 풍성한 패턴 속에 푹 빠졌어요! 스페인의 젊은 감각이 모여 만들어 낸 재미있는 상상을 부르는 6개의 슬리브 이야기" /></p>
						<%' for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/68133_get.asp %>
						<div class="btnget">
							<% if isApp then %>
								<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_68113_item.asp?isApp=<%= isApp %>'); return false;" >
							<% else %>
								<a href="/event/etc/hsp/inc_68113_item.asp?isApp=<%= isApp %>" target="_blank">
							<% end if %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" />
							</a>
						</div>
					</div>

					<div class="swiper-slide siwper-slide-item">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_slide_05.jpg" alt="소재는 캔버스로 생활방수가 되며, 보호 쿠션은 5mm며, 사이즈는 랩탑13인치, 11인치, iPad, iPad Mini가 있으며, 친환경 잉크를 사용한 디지털 프린팅으로 Made in Barcelona입니다." /></p>
						<%' for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/68133_get.asp %>
						<div class="btnget">
							<% if isApp then %>
								<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_68113_item.asp?isApp=<%= isApp %>'); return false;" >
							<% else %>
								<a href="/event/etc/hsp/inc_68113_item.asp?isApp=<%= isApp %>" target="_blank">
							<% end if %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" />
							</a>
						</div>
					</div>

					<%' brand %>
					<div class="swiper-slide swiper-slide-brand">
						<div class="brand">
							<p class="letter1"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/txt_brand_01.png" alt="" /></p>
							<p class="letter2"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/txt_brand_02.png" alt="" /></p>
							<p class="letter3"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/txt_brand_03.png" alt="" /></p>
						</div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_slide_06.png" alt="" />
						<%' for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/68133_get.asp %>
						<div class="btnget">
							<% if isApp then %>
								<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_68113_item.asp?isApp=<%= isApp %>'); return false;" >
							<% else %>
								<a href="/event/etc/hsp/inc_68113_item.asp?isApp=<%= isApp %>" target="_blank">
							<% end if %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" />
							</a>
						</div>
					</div>

					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_slide_07_v1.jpg" alt="" />
						<p class="desc desc1"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/txt_desc_01.png" alt="바나나, 하면 떠오르는 말장난. 바나나를 먹으면 나한테 반하나?" /></p>
						<%' for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/68133_get_banana.asp %>
						<div class="btnget">
							<% If isapp="1" Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_68113_banana.asp?isApp=<%= isApp %>'); return false;" >
							<% Else %>
								<a href="/event/etc/hsp/inc_68113_banana.asp?isApp=<%= isApp %>" target="_blank">
							<% End If %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" />
							</a>
						</div>
					</div>
					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_slide_08_v1.jpg" alt="" />
						<p class="desc desc2"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/txt_desc_02.png" alt="선인장은 짝사랑 같다. 물을 주지 않아도, 어루만져 주지 않아도 어딘가에서 조용히 꽃을 피우는 수많은 짝사랑들..!" /></p>
						<%' for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/68133_get_cactus.asp %>
						<div class="btnget">
							<% If isapp="1" Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_68113_cactus.asp?isApp=<%= isApp %>'); return false;" >
							<% Else %>
								<a href="/event/etc/hsp/inc_68113_cactus.asp?isApp=<%= isApp %>" target="_blank">
							<% End If %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" />
							</a>
						</div>
					</div>
					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_slide_09.jpg" alt="" />
						<p class="desc desc3"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/txt_desc_03.png" alt="파인애플, 통통하고 거친 우리 엄마의 손을 닮았다" /></p>
						<%' for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/68133_get_pineapple.asp %>
						<div class="btnget">
							<% If isapp="1" Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_68113_pineapple.asp?isApp=<%= isApp %>'); return false;" >
							<% Else %>
								<a href="/event/etc/hsp/inc_68113_pineapple.asp?isApp=<%= isApp %>" target="_blank">
							<% End If %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" />
							</a>
						</div>
					</div>
					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_slide_10.jpg" alt="" />
						<p class="desc desc4"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/txt_desc_04.png" alt="어린 마음에도 불쌍했던 추억의 애니메이션 꾸러기 수비대의 고양이. 오도카니 앉아 있는 고양이들을 보면 가끔 그 생각이 나 측은하다." /></p>
						<%' for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/68133_get_cat.asp %>
						<div class="btnget">
							<% If isapp="1" Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_68113_cat.asp?isApp=<%= isApp %>'); return false;" >
							<% Else %>
								<a href="/event/etc/hsp/inc_68113_cat.asp?isApp=<%= isApp %>" target="_blank">
							<% End If %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" />
							</a>
						</div>
					</div>
					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_slide_11.jpg" alt="" />
						<p class="desc desc5"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/txt_desc_05.png" alt="다 먹은 우유갑을 접을 때 입구에서 퐁퐁 나오던 우유 방울, 아니면 에에에취! 영혼까지 빠져나갈 것만 같은 시원한 재채기" /></p>
						<%' for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/68133_get_dripping.asp %>
						<div class="btnget">
							<% If isapp="1" Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_68113_dripping.asp?isApp=<%= isApp %>'); return false;" >
							<% Else %>
								<a href="/event/etc/hsp/inc_68113_dripping.asp?isApp=<%= isApp %>" target="_blank">
							<% End If %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" />
							</a>
						</div>
					</div>
					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_slide_12.jpg" alt="" />
						<p class="desc desc6"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/txt_desc_06.png" alt="이제는 추억의 드라마나 영화에서나 볼 수 있는 교련복, 혹은 개학 전날 새벽 잠결에 봤던 텔레비전 노이즈 화면" /></p>
						<%' for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/68133_get_school.asp %>
						<div class="btnget">
							<% If isapp="1" Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_68113_school.asp?isApp=<%= isApp %>'); return false;" >
							<% Else %>
								<a href="/event/etc/hsp/inc_68113_school.asp?isApp=<%= isApp %>" target="_blank">
							<% End If %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get_white.png" alt="BUY" />
							</a>
						</div>
					</div>

					<%' finish %>
					<div class="swiper-slide swiper-slide-finish">
						<p class="finish"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/txt_finish.png" alt="즐거운 상상으로 가득한 일상" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_slide_13.jpg" alt="" />
						<%' for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/68133_get.asp %>
						<div class="btnget">
							<% if isApp then %>
								<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_68113_item.asp?isApp=<%= isApp %>'); return false;" >
							<% else %>
								<a href="/event/etc/hsp/inc_68113_item.asp?isApp=<%= isApp %>" target="_blank">
							<% end if %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" />
							</a>
						</div>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_slide_14_v1.png" alt="WOOUF 슬리브의 패턴을 보면 어떤 것이 떠오르나요? 정성껏 코멘트를 남겨주신 3분을 추첨하여 WOOUF 아이패드 슬리브를 드립니다. 원하는 사이즈를 꼭 기재해 주세요  13인치, 11인치, iPad, iPand Mini 중 택1 디자인은 랜덤 발송됩니다. 코멘트 작성기간은 2015년 12월 23일부터 12월 29일까지며, 발표는 12월 31일 입니다." /></p>
						<a href="#commentevt" class="btngo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_go.gif" alt="응모하러 가기" /></a>
						<%' for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/68133_get.asp %>
						<div class="btnget">
							<% if isApp then %>
								<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_68113_item.asp?isApp=<%= isApp %>'); return false;" >
							<% else %>
								<a href="/event/etc/hsp/inc_68113_item.asp?isApp=<%= isApp %>" target="_blank">
							<% end if %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" />
							</a>
						</div>
					</div>
				</div>
			</div>
			<div class="pagingNo">
				<p class="page"><strong></strong>/<span></span></p>
			</div>

			<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_next.png" alt="다음" /></button>
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
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/txt_comment_v1.png" alt="WOOUF 슬리브의 패턴을 보면 어떤 것이 떠오르나요? 정성껏 코멘트를 남겨주신 3분을 추첨하여 WOOUF 아이패드 슬리브를 드립니다. 원하는 사이즈를 꼭 기재해 주세요  13인치, 11인치, iPad, iPand Mini 중 택1 디자인은 랜덤 발송됩니다. 코멘트 작성기간은 2015년 12월 23일부터 12월 29일까지며, 발표는 12월 31일 입니다." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_01.png" alt="Banana" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_02.png" alt="Cactus" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_03.png" alt="Pineapple" /></button>
							</li>
							<li class="ico4">
								<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_04.png" alt="Cats" /></button>
							</li>
							<li class="ico5">
								<button type="button" value="5"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_05.png" alt="Dripping" /></button>
							</li>
							<li class="ico6">
								<button type="button" value="6"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/ico_06.png" alt="School" /></button>
							</li>
						</ul>
						<div class="field">
							<textarea name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="" cols="60" rows="5"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
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
			<p class="total">total <%= iCTotCnt %></p>
			<% IF isArray(arrCList) THEN %>
				<ul>
					<% For intCLoop = 0 To UBound(arrCList,2) %>
					<li>
						<% if isarray(split(arrCList(1,intCLoop),"!@#")) then %>
							<strong class="ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>">
								<% if split(arrCList(1,intCLoop),"!@#")(0)="1" then %>
									Banana
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="2" then %>
									Cactus
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="3" then %>
									Pineapple
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="4" then %>
									Cats
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="5" then %>
									Dripping
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="6" then %>
									School
								<% Else %>
									Banana
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
	<%' //comment event %>

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
		speed:500,
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
			$(".swiper-slide").find(".brand .letter1").delay(100).animate({"margin-top":"10%", "opacity":"0"},300);
			$(".swiper-slide").find(".brand .letter2").delay(200).animate({"margin-top":"10%", "opacity":"0"},300);
			$(".swiper-slide").find(".brand .letter3").delay(300).animate({"margin-top":"10%", "opacity":"0"},300);
			$(".swiper-slide-active").find(".brand .letter1").animate({"margin-top":"8%", "opacity":"1"},500);
			$(".swiper-slide-active").find(".brand .letter2").animate({"margin-top":"8%", "opacity":"1"},500);
			$(".swiper-slide-active").find(".brand .letter3").animate({"margin-top":"8%", "opacity":"1"},500);

			$(".swiper-slide").find(".hey").delay(100).animate({"top":"8.5%", "opacity":"0"},300);
			$(".swiper-slide-active").find(".hey").delay(50).animate({"top":"6.5%", "opacity":"1"},600);

			$(".swiper-slide").find(".desc").delay(100).animate({"margin-top":"1.5%","opacity":"0"},500);
			$(".swiper-slide-active").find(".desc").animate({"margin-top":"0","opacity":"1"},400);

			$(".swiper-slide").find(".finish").delay(100).animate({"margin-top":"1.5%", "opacity":"0"},300);
			$(".swiper-slide-active").find(".finish").animate({"margin-top":"0", "opacity":"1"},500);
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
<%
set oItem=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->