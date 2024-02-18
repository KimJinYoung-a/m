<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 24 MA
' History : 2016-03-15 김진영 생성
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
dim currenttime, itemid
	currenttime =  now()
'	currenttime = #03/02/2016 09:00:00#

dim eCode
dim oItem
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66064
Else
	eCode   =  69618
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
.heySomething .article .btnget {width:38.43%; margin-left:-19.215%;}
.heySomething .app {display:none;}

/* title */
.heySomething .swiper-slide .hey {position:absolute; top:6.5%; left:0; width:100%;}

/* buy */
.heySomething .swiper-slide-buy a {display:block;}
.heySomething .swiper-slide-buy .option {position:absolute; top:0; left:0; width:100%; height:100%; padding-top:92%; text-align:center;}
.heySomething .option .discount {background-color:#3a940e;}
.heySomething .option .price strong {color:#3a940e;}

/* info */
.swiper-slide-comicbook .speech {position:absolute; width:100%;}
.swiper-slide-comicbook .speech1 {top:10%; left:0;}
.swiper-slide-comicbook .speech2 {top:70%; right:0;}
.swiper-slide-comicbook .speech3 {top:68%; left:0;}
.swiper-slide-comicbook .speech4 {top:15%; right:0;}

/* story */
.heySomething .swiper-slide .desc {position:absolute; bottom:8.5%; width:100%;}

/* finish */
.swiper-slide-finish .finish {position:absolute; top:9%; width:100%;}
.swiper-slide-finish ul {overflow:hidden; position:absolute; top:22%; width:100%; padding:0 5.2%;}
.swiper-slide-finish ul li {float:left; width:50%;}

/* comment */
.heySomething .form .choice {padding:3% 0 0 2%;}
.heySomething .form .choice li {width:20%; height:auto !important; margin:0; padding:0 1% 0;}
.heySomething .form .choice li:last-child {padding-right:0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_01_off.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_02_off.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_03_off.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_04_off.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_04_on.png);}
.heySomething .form .choice li.ico5 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_05_off.png);}
.heySomething .form .choice li.ico5 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_05_on.png);}

.heySomething .commentlist ul li {position:relative; min-height:91px; padding:15px 0 15px 78px;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:1%; width:60px; height:60px; margin-top:-30px; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_01_off.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_02_off.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_03_off.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_04_off.png);}
.heySomething .commentlist ul li .ico5 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_05_off.png);}

@media all and (min-width:480px){
	.heySomething .commentlist ul li {min-height:135px; padding:22px 0 22px 110px;}
	.heySomething .commentlist ul li strong {width:90px; height:90px; margin-top:-45px;}
}

@media all and (min-width:768px){
	.heySomething .commentlist ul li {min-height:180px; padding:30px 0 30px 150px;}
	.heySomething .commentlist ul li strong {width:120px; height:120px; margin-top:-60px;}
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
		<% if commentcount>0 then %>
			alert("이벤트는 한번만 참여 가능 합니다.");
			return false;
		<% else %>
			if (frm.gubunval.value == ''){
				alert('원하는 항목을 선택해 주세요.');
				return false;
			}
			if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 800){
				alert("코맨트를 남겨주세요.\n한글 400자 까지 작성 가능합니다.");
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
</script>

<% ''[Hey, something project_22] Disney Vintage Edition / 이벤트 코드 69521 %>
<div class="heySomething" id="toparticle">
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
	<div class="section article">
		<%'' swiper %>
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_slide_01.jpg" alt="" />
						<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project.png" alt="Hey, something project" /></strong>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>
					<%
						If application("Svr_Info") = "Dev" Then
							itemid   =  1239226
						Else
							itemid   =  1449129
						End If
						Set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<%'' buy1 %>
					<div class="swiper-slide swiper-slide-buy">
					<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1449129&amp;pEtr=69618'); return false;">
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1449129&amp;pEtr=69618">
					<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_slide_03.jpg" alt="" />
							<div class="option">
					<% ' for dev msg : 구매하기 3/16~3/22까지 할인 / 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
					<%
						If oItem.FResultCount > 0 then 
							If (oItem.Prd.FItemCouponYN="Y") Then
								If ( left(currenttime,10)>="2016-03-16" and left(currenttime,10)<"2016-03-23" ) Then 
					%>
								<strong class="discount">단, 일주일만 ONLY 20%</strong>
					<%
								End If 
							End If
					%>
								<em class="name">TINTIN Putsits Trench 8.5cm Keyring</em>
					<%		If (oItem.Prd.FItemCouponYN="Y") Then %>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.GetCouponAssignPrice,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
					<%		Else %>	
								<div class="price priceEnd">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
					<%		End If 
						End If
					%>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="TINTIN Putsits Trench 8.5cm Keyring 구매하러 가기" /></div>
							</div>
						</a>
					</div>
					<% Set oItem = nothing %>

					<%
						If application("Svr_Info") = "Dev" Then
							itemid   =  786868
						Else
							itemid   =  1441776
						End If
						Set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<%'' buy2 %>
					<div class="swiper-slide swiper-slide-buy">
					<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1441776&amp;pEtr=69618'); return false;">
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1441776&amp;pEtr=69618">
					<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_slide_04.jpg" alt="" />
							<div class="option">
					<% ' for dev msg : 구매하기 3/16~3/22까지 할인 / 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
					<%
						If oItem.FResultCount > 0 then 
							If (oItem.Prd.FItemCouponYN="Y") Then
								If ( left(currenttime,10)>="2016-03-16" and left(currenttime,10)<"2016-03-23" ) Then 
					%>
								<strong class="discount">단, 일주일만 ONLY 20%</strong>
					<%
								End If 
							End If
					%>
								<em class="name">BOX SCENE - On the Aurora</em>
					<%		If (oItem.Prd.FItemCouponYN="Y") Then %>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.GetCouponAssignPrice,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
					<%		Else %>	
								<div class="price priceEnd">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
					<%		End If 
						End If
					%>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="BOX SCENE On the Aurora 구매하러 가기" /></div>
							</div>
						</a>
					</div>
					<% Set oItem = nothing %>

					<%
						If application("Svr_Info") = "Dev" Then
							itemid   =  279397
						Else
							itemid   =  1441800
						End If
						Set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<%'' buy3 %>
					<div class="swiper-slide swiper-slide-buy">
					<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1441800&amp;pEtr=69618'); return false;">
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1441800&amp;pEtr=69618">
					<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_slide_05.jpg" alt="" />
							<div class="option">
					<% ' for dev msg : 구매하기 3/16~3/22까지 할인 / 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
					<%
						If oItem.FResultCount > 0 then 
							If (oItem.Prd.FItemCouponYN="Y") Then
								If ( left(currenttime,10)>="2016-03-16" and left(currenttime,10)<"2016-03-23" ) Then 
					%>
								<strong class="discount">단, 일주일만 ONLY 20%</strong>
					<%
								End If 
							End If
					%>
								<em class="name">TINTIN Seated Tibet 5.5cm</em>
					<%		If (oItem.Prd.FItemCouponYN="Y") Then %>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.GetCouponAssignPrice,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
					<%		Else %>	
								<div class="price priceEnd">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
					<%		End If 
						End If
					%>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="TINTIN Seated Tibet 5.5cm 구매하러 가기" /></div>
							</div>
						</a>
					</div>
					<% Set oItem = nothing %>

					<%
						If application("Svr_Info") = "Dev" Then
							itemid   =  1158976
						Else
							itemid   =  1449178
						End If
						Set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<%'' buy4 %>
					<div class="swiper-slide swiper-slide-buy">
					<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1449178&amp;pEtr=69618'); return false;">
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1449178&amp;pEtr=69618">
					<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_slide_06.jpg" alt="" />
							<div class="option">
					<% ' for dev msg : 구매하기 3/16~3/22까지 할인 / 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
					<%
						If oItem.FResultCount > 0 then 
							If (oItem.Prd.FItemCouponYN="Y") Then
								If ( left(currenttime,10)>="2016-03-16" and left(currenttime,10)<"2016-03-23" ) Then 
					%>
								<strong class="discount">단, 일주일만 ONLY 20%</strong>
					<%
								End If 
							End If
					%>
								<em class="name">TINTIN puzzle and poster</em>
					<%		If (oItem.Prd.FItemCouponYN="Y") Then %>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.GetCouponAssignPrice,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
					<%		Else %>	
								<div class="price priceEnd">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
					<%		End If 
						End If
					%>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="TINTIN puzzle and poster 구매하러 가기" /></div>
							</div>
						</a>
					</div>
					<% Set oItem = nothing %>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_slide_07.png" alt="틴틴, 땡땡 혹은 땅땅 소년 기자 틴틴 그의 반려견 스노위와 함께 모험을 떠나다! 유럽 가정의 과반수가 즐겨보았을 정도로 어린이와 어른이 함께 즐기는 가족만화의 고전이자 걸작!" /></p>
					</div>

					<%' comic book %>
					<div class="swiper-slide swiper-slide-comicbook">
						<%' for dev msg : 상품 링크 %>
						<p class="speech speech1">
					<% If isApp = 1 Then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1441809&amp;pEtr=69618'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/txt_speech_bubble_01.png" alt="소년기자 틴틴 주인공으로, 세계를 모험하면서 정의를 실현하는 벨기에기자" /></a>
					<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=1441809&amp;pEtr=69618" title="PUTSITS TRENCH 8.5cm 상품 보러가기"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/txt_speech_bubble_01.png" alt="소년기자 틴틴 주인공으로, 세계를 모험하면서 정의를 실현하는 벨기에기자" /></a>
					<% End If %>
						</p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_slide_08.jpg" alt="" />
					</div>
					<div class="swiper-slide swiper-slide-comicbook">
						<%' for dev msg : 상품 링크 %>
						<p class="speech speech2">
					<% If isApp = 1 Then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1441811&amp;pEtr=69618'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/txt_speech_bubble_02.png" alt="틴틴의 단짝 애견 스노위 가끔 개답지 않은 생각을 하며 뼈다귀를 좋아하고 술을 좋아한다." /></a>
					<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=1441811&amp;pEtr=69618" title="PUTSITS TRENCH 8.5cm 상품 보러가기"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/txt_speech_bubble_02.png" alt="틴틴의 단짝 애견 스노위 가끔 개답지 않은 생각을 하며 뼈다귀를 좋아하고 술을 좋아한다." /></a>
					<% End If %>
						</p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_slide_09.jpg" alt="" />
					</div>
					<div class="swiper-slide swiper-slide-comicbook">
						<%' for dev msg : 상품 링크 %>
						<p class="speech speech3">
					<% If isApp = 1 Then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1449131&amp;pEtr=69618'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/txt_speech_bubble_03.png" alt="틴틴의 조력자 쌍둥이 형사 톰슨 형사임에도 불구하고 멍청한 캐릭터로 어딜가나 사고만 친다" /></a>
					<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=1449131&amp;pEtr=69618" title="PUTSITS TRENCH 8.5cm 상품 보러가기"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/txt_speech_bubble_03.png" alt="틴틴의 조력자 쌍둥이 형사 톰슨 형사임에도 불구하고 멍청한 캐릭터로 어딜가나 사고만 친다" /></a>
					<% End If %>
						</p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_slide_10.jpg" alt="" />
					</div>
					<div class="swiper-slide swiper-slide-comicbook">
						<%' for dev msg : 상품 링크 %>
						<p class="speech speech4">
					<% If isApp = 1 Then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1449129&amp;pEtr=69618'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/txt_speech_bubble_04.png" alt="틴틴의 모험파트너 아독선장 : 평생을 바다에서 보낸 사나이 말랑말랑한 마음이 숨겨져 있다." /></a>
					<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=1449129&amp;pEtr=69618" title="PUTSITS TRENCH 8.5cm 상품 보러가기"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/txt_speech_bubble_04.png" alt="틴틴의 모험파트너 아독선장 : 평생을 바다에서 보낸 사나이 말랑말랑한 마음이 숨겨져 있다." /></a>
					<% End If %>
						</p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_slide_11.jpg" alt="" />
					</div>

					<%' story %>
					<div class="swiper-slide swiper-slide-story">
						<p class="desc desc1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/txt_desc_01.png" alt="CITY 도시로 간 틴틴: #도시여행#쇼핑#먹방찍으러갑니다#활기#야경" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_slide_12.jpg" alt="" />
					</div>
					<div class="swiper-slide swiper-slide-story">
						<p class="desc desc2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/txt_desc_02.png" alt="MOUNTAIN 산으로 간 틴틴: #자연속에서의힐링#피톤치드#꽃놀이" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_slide_13.jpg" alt="" />
					</div>
					<div class="swiper-slide swiper-slide-story">
						<p class="desc desc3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/txt_desc_03.png" alt="PALACE 고궁으로 간 틴틴: #경복궁야간개장#전통이살아숨쉬는곳#고궁" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_slide_14.jpg" alt="" />
					</div>
					<div class="swiper-slide swiper-slide-story">
						<p class="desc desc4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/txt_desc_04.png" alt="CAFE 카페로 간 틴틴: #핫플레이스#여유#커피#예쁜카페는사랑입니다" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_slide_15.jpg" alt="" />
					</div>
					<div class="swiper-slide swiper-slide-story">
						<p class="desc desc4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/txt_desc_05.png" alt="BOOK STORE 서점으로 간 틴틴: #서점에서책한권#여유#힐링#마음의양식" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_slide_16.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-finish">
						<a href="https://www.instagram.com/jskglobal_tintin/" target="_blank" title="틴틴 인스타그램 페이지로 이동 새창">
							<p class="finish"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/txt_finish.png" alt="나는 틴틴주의자! 오랜시간 사랑받는 틴틴! #틴틴 #틴틴과 함께 여행가자! #어디까지 가봤니 #추억을 담는 또 하나의 방법 @jskglobal_tintin" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_slide_17.jpg" alt="" />
						</a>
					</div>

					<div class="swiper-slide swiper-slide-finish">
						<a href="https://www.instagram.com/jskglobal_tintin/" target="_blank" title="틴틴 인스타그램 페이지로 이동 새창">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_slide_18.jpg" alt="틴틴 인스타그램 @jskglobal_tintin" /></p>
							<ul class="instagram">
								<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_instagram_01.png" alt="" /></li>
								<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_instagram_02.png" alt="" /></li>
								<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_instagram_03.png" alt="" /></li>
								<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_instagram_04.png" alt="" /></li>
							</ul>
						</a>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/img_slide_19.png" alt="여러분이 틴틴과 함께 떠나고 싶은 곳은 어디인가요? 가고 싶은곳과 그 이유를 코멘트로 남겨주세요! 정성껏 코멘트를 남겨주신 3분을 추첨하여 틴틴의모험 키링을 증정합니다. 디자인은 랜덤입니다. 코멘트 작성기간은 2016년 3월 16일부터 3월 22일까지며, 발표는 3월 23일 입니다." /></p>
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
		<div class="btnget mo"><a href="/street/street_brand.asp?makerid=tintin1010"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_brand_shop_v1.png" alt="BRAND SHOP" /></a></div>
		<div class="btnget app"><a href="" onclick="fnAPPpopupBrand('tintin1010'); return false;" ><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_brand_shop_v1.png" alt="BRAND SHOP" /></a></div>
	</div>
	<%'' comment event %>
	<div id="commentevt" class="section commentevt">
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
				<legend>틴틴 코멘트 쓰기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/txt_comment.png" alt="여러분이 틴틴과 함께 떠나고 싶은 곳은 어디인가요? 가고 싶은곳과 그 이유를 코멘트로 남겨주세요! 정성껏 코멘트를 남겨주신 3분을 추첨하여 틴틴의모험 키링을 증정합니다. 디자인은 랜덤입니다. 코멘트 작성기간은 2016년 3월 16일부터 3월 22일까지며, 발표는 3월 23일 입니다." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_01_off.png" alt="CITY" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_02_off.png" alt="MOUNTAIN" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_03_off.png" alt="PALACE" /></button>
							</li>
							<li class="ico4">
								<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_04_off.png" alt="CAFE" /></button>
							</li>
							<li class="ico5">
								<button type="button" value="5"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69618/m/ico_05_off.png" alt="BOOK STORE" /></button>
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
									CITY
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="2" then %>
									MOUNTAIN
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="3" then %>
									PALACE
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="4" then %>
									CAFE
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="5" then %>
									BOOK STORE
								<% Else %>
									CITY
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
	<%'' //comment event %>
	<div id="dimmed"></div>
</div>
<%'' //[Hey, something project_23] %>

<script type="text/javascript">
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

			$(".swiper-slide.swiper-slide-comicbook").find(".speech1, .speech3").delay(100).animate({"margin-left":"10%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-comicbook").find(".speech1, .speech3").delay(50).animate({"margin-left":"0", "opacity":"1"},600);
			$(".swiper-slide.swiper-slide-comicbook").find(".speech2, .speech4").delay(100).animate({"margin-right":"10%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-comicbook").find(".speech2, .speech4").delay(50).animate({"margin-right":"0", "opacity":"1"},600);

			$(".swiper-slide").find(".hey").delay(100).animate({"top":"8.5%", "opacity":"0"},300);
			$(".swiper-slide-active").find(".hey").delay(50).animate({"top":"6.5%", "opacity":"1"},600);

			$(".swiper-slide.swiper-slide-story").find(".desc").delay(100).animate({"margin-bottom":"5%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-story").find(".desc").delay(50).animate({"margin-bottom":"0", "opacity":"1"},600);

			$(".swiper-slide.swiper-slide-finish").find(".finish").delay(100).animate({"margin-top":"5%", "opacity":"0"},300);
			$(".swiper-slide.swiper-slide-finish").find(".instagram").delay(100).animate({"width":"90%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-finish").find(".finish").delay(50).animate({"margin-top":"0", "opacity":"1"},600);
			$(".swiper-slide-active.swiper-slide-finish").find(".instagram").delay(100).animate({"width":"100%", "opacity":"1"},600);
		}
	});

	$('.pagingNo .page strong').text(1);
	$('.pagingNo .page span').text(mySwiper.slides.length-2);

	/* skip to comment */
	$(".btngo").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},800);
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".heySomething .app").show();
			$(".heySomething .mo").hide();
	}else{
			$(".heySomething .app").hide();
			$(".heySomething .mo").show();
	}

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