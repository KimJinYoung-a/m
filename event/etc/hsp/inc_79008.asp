<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈
' History : 2017-07-11 원승현 생성
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
	eCode   =  66385
Else
	eCode   =  79008
End If

dim userid, commentcount, i, itemid, oitem
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
.heySomething .article .btnget {width:40.3125%; margin-left:-20.15625%;}

/* title */
.heySomething .swiper-slide .hey {position:absolute; top:6.6%; left:0; width:100%;}

/* buy */
.heySomething .swiper-slide-buy {-webkit-text-size-adjust:none; background-color:#f5f5f5;}
.heySomething .swiper-slide-buy .option {text-align:center;}
.heySomething .option .name {font-size:1.7rem;}
.heySomething .option .name span {display:block; margin-top:1rem; color:#777777; font-size:1.2rem; font-weight:bold;}
.heySomething .option .name span em {padding:0 0.4rem; font-size:1.2rem; color:#d5d5d5; font-weight:bold;}
.heySomething .option .name span i {display:inline-block; width:0.8rem; height:0.8rem; margin-right:0.4rem; border-radius:50%; -webkit-border-radius:50%;}
.heySomething .option .name span i.color1 {background-color:#dedede;}
.heySomething .option .name span i.color2 {background-color:#80706e;}
.heySomething .option .name span i.color3 {background-color:#e7ba42;}
.heySomething .option .name span i.color4 {background-color:#404040;}
.heySomething .option .name span i.color5 {background-color:#955656;}
.heySomething .option .price {margin-top:.7rem;}
.heySomething .option .price s {display:inline-block; font-size:1.2rem; line-height:1; font-weight:bold;}
.heySomething .option .price strong {display:inline-block; padding-top:0.3rem; font-size:1.5rem; line-height:1;}
.heySomething .loopImage {position:relative; width:100%; padding-bottom:97.03%;}
.heySomething .loopImage img {width:100%;}
.heySomething .loopImage div img {display:inline-block; position:absolute; left:50%; top:0; margin-left:-50%;}
.heySomething .option .btnbuy {margin-top:1.9rem;}

/* story */
.heySomething .swiper-slide-desc {background-color:#f5f5f5;}
.heySomething .swiper-slide-desc p {position:absolute; left:0; bottom:0; width:100%;}

/* comment */
.heySomething .swiper-slide .btngo {top:70%;}
.heySomething .form .inner {padding:0 6.25%;}
.heySomething .field {margin-top:1.8rem;}
.heySomething .form .choice li {width:6.4rem; height:auto !important; margin-right:3%;}
.heySomething .form .choice li:last-child {margin-right:0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/ico_01_off.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/ico_02_off.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/ico_03_off.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/ico_03_on.png);}
.heySomething .commentlist ul li {position:relative; min-height:8rem; padding:1.5rem 0 1.5rem 7.8rem;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:1.4rem; width:5.2rem; height:5.2rem; margin-top:-2.56rem; background-repeat:no-repeat; background-position:50% 0 !important; background-size:auto 100%;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/ico_01_off.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/ico_02_off.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/ico_03_off.png);}
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
		<% If not( left(currenttime,10)>="2017-07-11" and left(currenttime,10)<"2017-07-19" ) Then %>
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
						<div class="swiper-slide">
							<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project.png" alt="Hey, something project" /></strong>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/img_slide01.jpg" alt="" /></div>
						</div>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
						</div>
						<div class="swiper-slide">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/img_brand.jpg" alt="RAWROW [RAW] 날것, 본질의 가치에 집중하여, 물건 본연의 역할에 충실한 제품을 만들다. 우리는 안경의 본질에 대해 묻고 또 물었습니다. 누군가에게 안경은 그저 시력을 보호하는 의료용 도구 이기도 하고 누군가에게는 자신의 스타일을 표현하는 도구 입니다. 가장 가벼운 것 중에, 가장 튼튼한 물질 100% '베타티타늄'으로 만든 세계에서 두 번째로 가벼운 안경, 기존 R EYE가 가진 장점은 그대로 남기고 더 많은 사람들이 R EYE를 선택할 수 있도록 컬러와 디자인의 폭을 넓혔습니다." /></div>
						</div>

						<%' buy %>
						<div class="swiper-slide swiper-slide-buy">
							<%' for dev msg : 상품코드 1750257 %>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1750257&amp;pEtr=79008'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1750257&amp;pEtr=79008">
							<% End If %>
								<div class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/img_prd01.jpg" alt="R EYE 240 BETA TITANIUM 46 (5color)" /></div>
								<div class="option">
									<span class="name">R EYE 240 BETA <br />TITANIUM 46 (5color)<br /><span> SIZE : ONE SIZE <em>l</em> COLOR : <i class="color1"></i><i class="color2"></i><i class="color3"></i><i class="color4"></i><i class="color5"></i></span></span>
									<%' for dev msg : 할인%>
									<%
										IF application("Svr_Info") = "Dev" THEN
											itemid = 786868
										Else
											itemid = 1750257
										End If
										set oItem = new CatePrdCls
											oItem.GetItemData itemid
									%>
									<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> (<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%)</strong>
										</div>
									<% Else %>
										<%' for dev msg : 할인 종료후 %>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
									<% Set oItem = Nothing %>
									<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
								</div>
							</a>
						</div>

						<div class="swiper-slide swiper-slide-buy">
							<%' for dev msg : 상품코드 1750261 %>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1750261&amp;pEtr=79008'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1750261&amp;pEtr=79008">
							<% End If %>
								<div class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/img_prd02.jpg" alt="R EYE 250 BETA TITANIUM 46 (5color)" /></div>
								<div class="option">
									<span class="name">R EYE 250 BETA <br />TITANIUM 46 (5color)<br /><span> SIZE : ONE SIZE <em>l</em> COLOR : <i class="color1"></i><i class="color2"></i><i class="color3"></i><i class="color4"></i><i class="color5"></i></span>
									<%' for dev msg : 할인 %>
									<%
										IF application("Svr_Info") = "Dev" THEN
											itemid = 786868
										Else
											itemid = 1750261
										End If
										set oItem = new CatePrdCls
											oItem.GetItemData itemid
									%>
									<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> (<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%)</strong>
										</div>
									<% Else %>
										<%' for dev msg : 할인 종료후 %>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
									<% Set oItem = Nothing %>
									<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
								</div>
							</a>
						</div>

						<div class="swiper-slide">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/img_slide02.jpg" alt="어디 한번 휘어봐요 / 세상에서 두번째로 가벼운 / 코에 자국나지 않는 방법 /숨은 디테일 찾기" /></div>
						</div>

						<%' story %>
						<div class="swiper-slide swiper-slide-desc">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/img_story01.jpg" alt="" /></div>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/txt_story01.png" alt="#보다 가벼운 : 보다 가볍게, 오늘 하루를 시작하세요!" /></p>
						</div>
						<div class="swiper-slide swiper-slide-desc">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/img_story02.jpg" alt="" /></div>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/txt_story02.png" alt="#보다 특별한 : 더 특별해진 R EYE와 함께하는 일상" /></p>
						</div>
						<div class="swiper-slide swiper-slide-desc">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/img_story03.jpg" alt="" /></div>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/txt_story03.png" alt="#보다 오래도록 : 10년 안경이 될 수 있도록, 보다 오래도록 함께 하고싶은 안경" /></p>
						</div>

						<div class="swiper-slide">
							<div>
							<% If isApp="1" Then %>
								<a href="" onclick="fnAPPpopupBrand('rawrow'); return false;" title="BRAND SHOP">
							<% Else %>
								<a href="/street/street_brand.asp?makerid=rawrow" title="BRAND SHOP">
							<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/img_slide03.jpg" alt="우린 앞으로도 계속, 가볍고 편안하고 만만한 안경 다운 안경을 만들거에요 RAWROW" />
								</a>
							</div>
						</div>

						<%' comment Evt %>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/img_slide_event.png" alt="Hey, something project 여러분에게 안경이란 어떤 의미인가요? 정성스런 코멘트을 남겨주신 1분을 추첨하여 로우로우의 R EYE 240 or 250 BETA TITANIUM 제품을 선물 드립니다. 이벤트 기간은 2017년 07월 12일 부터 07월 18일 까지 입니다. 당첨자 발표일은 07월 19일 입니다." /></p>
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
			<div class="btnget">
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupBrand('rawrow'); return false;" title="BRAND SHOP">
				<% Else %>
					<a href="/street/street_brand.asp?makerid=rawrow" title="BRAND SHOP">
				<% End If %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/btn_brand_shop_v4.png" alt="BRAND SHOP" />
				</a>
			</div>
		</div>
		<!-- //main contents -->

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
					<legend>코멘트 작성 폼</legend>
						<p class="evntTit"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/txt_comment.png" alt="여러분에게 안경이란 어떤 의미인가요? 정성껏 코멘트를 남겨주신 1분을 추첨하여 로우로우의 R EYE 240 or 250 BETA TITANIUM 제품을 선물 드립니다 이벤트 기간은 2017년 07월 12일 부터 07월 18일 까지 입니다. 당첨자 발표일은 07월 19일 입니다." /></p>
						<div class="inner">
							<ul class="choice">
								<li class="ico1">
									<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/ico_01_off.png" alt="# Erieol" /></button>
								</li>
								<li class="ico2">
									<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/ico_02_off.png" alt="# Sebastian" /></button>
								</li>
								<li class="ico3">
									<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79008/m/ico_03_off.png" alt="# Flounder" /></button>
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
								# Erieol
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
								# Sebastian
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
								# Flounder
							<% Else %>
								# Erieol
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
		//initialSlide:10,
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

			$(".swiper-slide-desc").find("p").delay(100).animate({"margin-bottom":"-2%", "opacity":"0"},400);
			$(".swiper-slide-active.swiper-slide-desc").find("p").delay(50).animate({"margin-bottom":"0", "opacity":"1"},300);
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

	/* var $elements = $('.loopImage div a ').css('visibility','hidden');
	var $visible = $elements.first().css('visibility','visible');
	var time = null;
	function playing(){
		time=setInterval(function(){
			$visible.css('visibility','hidden');
			var $next = $visible.next('.loopImage div a ');
			if(!$next.length)
				$next = $elements.first();
			$visible = $next.css('visibility','visible');
		},1500);
	} 

	playing();
	*/
	$(".goReview").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 800);
	});
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->