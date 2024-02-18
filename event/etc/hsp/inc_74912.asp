<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈
' History : 2016-12-13 유태욱 생성
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
	eCode   =  66251
Else
	eCode   =  74912
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
.heySomething .swiper-slide .btngo {top:76.5%;}
.heySomething .app {display:none;}
.heySomething .swiper-slide {background:#fff;}
.heySomething .swiper-slide .hey {position:absolute; top:6.5%; left:0; width:100%;}

/* brand*/
.heySomething .swiper-slide-brand {position:relative;}
.heySomething .swiper-slide-brand .brandTxt{position:absolute; width:59.37%; top:11.16%; left:20.46%; opacity:0; }

/* items */
.heySomething .swiper-slide-items {position:relative; color:transparent;}
.heySomething .swiper-slide-items ul {position:absolute; top:0; left:0; width:100%; height:100%;}
.heySomething .swiper-slide-items ul li{position:absolute; top:0; left:0;}
.heySomething .swiper-slide-items ul li a {display:block; width:100%; height:100%;}
.heySomething .swiper-slide-items ul li.item01{width:65%; height:22.91%;}
.heySomething .swiper-slide-items ul li.item02{top:0; left:65%; width:35%; height:22.91%;}
.heySomething .swiper-slide-items ul li.item03{top:23%; width:35%; height:23%;}
.heySomething .swiper-slide-items ul li.item04{top:46%; width:35%; height:23%;}
.heySomething .swiper-slide-items ul li.item05{top:23%; left:35%; width:65%; height:46%;}
.heySomething .swiper-slide-items ul li.item06{top:69%; width:50%; height:30%;}
.heySomething .swiper-slide-items ul li.item07{top:69%; left:50%; width:50%; height:30%;}

/* buy */
.heySomething .swiper-slide-buy {-webkit-text-size-adjust:none; background:#fff;}
.heySomething .swiper-slide-buy a {display:block;}
.heySomething .swiper-slide-buy .option {margin-top:1rem; text-align:center;}
.heySomething .swiper-slide-buy .name {font-size:1.7rem;}
.heySomething .swiper-slide-buy .price {margin:0.7rem 0;}
.heySomething .swiper-slide-buy .price s{font-size:15px;}
.heySomething .swiper-slide-buy .price strong{font-size:19px;}
.heySomething .swiper-slide-buy .btnbuy {margin-top:0}
.heySomething .swiper-slide-desc p {position:absolute; left:0; bottom:0; width:100%;}

.heySomething .swiper-slide-monster .txt span {position:absolute; left:28.12%; }
.heySomething .swiper-slide-monster .txt span.t01 {width:43.75%; top:41.6%;}
.heySomething .swiper-slide-monster .txt span.t02 {width:66.88%; top:45.83%; left:16.71%;}

/* comment */
.heySomething .form .choice {margin-right:-1.5%;}
.heySomething .form .choice li {width:6.7rem; height:8rem; margin:0 0.4rem 2rem 0;}
.heySomething .form .choice li:last-child {margin-right:0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/ico_01.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/ico_02.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/ico_03.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/ico_04.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/ico_04_on.png);}
.heySomething .commentlist ul li {position:relative; min-height:120px; padding:1.7rem 0 1.7rem 7.8rem;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:0rem; width:6.5rem; height:7.75rem; margin-top:-3.9rem; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/ico_01.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/ico_02.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/ico_03.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/ico_04.png);}
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
		<% If not( left(currenttime,10)>="2016-12-13" and left(currenttime,10)<="2016-12-20" ) Then %>
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
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/img_main.jpg" alt="" />
							<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project.png" alt="Hey, something project" /></strong>
						</div>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
						</div>
						<div class="swiper-slide swiper-slide-brand">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/img_brand.jpg" alt="" />
							<p class="brandTxt"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/txt_brand.png" alt="작은 위로를 줄 수 있는 달콤한 존재! 스위트몬스터! 달콤한 선물로 사람들에게 행복함을 전하고 즐거운 기분을 주는 " /></p>
							
						</div>
						<div class="swiper-slide swiper-slide-items">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/img_items_v2.jpg" alt="" />
							<ul class="mWeb">
								<li class="item01"><a href="/category/category_itemPrd.asp?itemid=1618388&pEtr=74961">몬스터 원형 틴케이스&에어퍼프 세트</a></li>
								<li class="item02"><a href="/category/category_itemPrd.asp?itemid=1618381&pEtr=74961">몬스터 롱 틴케이스</a></li>
								<li class="item03"><a href="/category/category_itemPrd.asp?itemid=1617790&pEtr=74961">배터리파우치</a></li>
								<li class="item04"><a href="/category/category_itemPrd.asp?itemid=1617788&pEtr=74961">몬스터 파우치 (L)</a></li>
								<li class="item05"><a href="/category/category_itemPrd.asp?itemid=1618509&pEtr=74961">몬스터 밀크 뮤직 토이</a></li>
								<li class="item06"><a href="/category/category_itemPrd.asp?itemid=1617789&pEtr=74961">몬스터 핸디 노트</a></li>
								<li class="item07"><a href="/category/category_itemPrd.asp?itemid=1618513&pEtr=74961">몬스터 핸디 노트</a></li>
							</ul>
							<ul class="mApp">
								<li class="item01"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1618388&pEtr=74961" onclick="fnAPPpopupProduct('1618388&pEtr=74961');return false;">몬스터 원형 틴케이스&에어퍼프 세트</a></li>
								<li class="item02"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1618381&pEtr=74961" onclick="fnAPPpopupProduct('1618381&pEtr=74961');return false;">몬스터 롱 틴케이스</a></li>
								<li class="item03"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1617790&pEtr=74961" onclick="fnAPPpopupProduct('1617790&pEtr=74961');return false;">배터리파우치</a></li>
								<li class="item04"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1617788&pEtr=74961" onclick="fnAPPpopupProduct('1617788&pEtr=74961');return false;">몬스터 파우치 (L)</a></li>
								<li class="item05"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1618509&pEtr=74961" onclick="fnAPPpopupProduct('1618509&pEtr=74961');return false;">몬스터 밀크 뮤직 토이</a></li>
								<li class="item06"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1617789&pEtr=74961" onclick="fnAPPpopupProduct('1617789&pEtr=74961');return false;">몬스터 핸디 노트</a></li>
								<li class="item07"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1618513&pEtr=74961" onclick="fnAPPpopupProduct('1618513&pEtr=74961');return false;">몬스터 핸디 노트</a></li>
							</ul>
						</div>

						<!-- buy (4개) -->
						<!-- ★★★ 상품수정 12/14 ★★★ -->
						<%
							Dim itemid, oItem
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1618383
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
						%>
						<div class="swiper-slide swiper-slide-buy">
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1618383&amp;pEtr=74912'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1618383&amp;pEtr=74912">
							<% End If %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/txt_sweet_monster.png" alt="MARK'S" />
								<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/img_item_01.jpg" alt="" />
								<div class="option">
								<% If oItem.FResultCount > 0 then %>
									<% '' for dev msg : 상품코드 1618383, 할인기간 12/14 ~ 12/20, 할인 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <div class="price priceEnd">...<div> / <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
									<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
										<strong class="discount">단 일주일만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
										<p class="name">몬스터 동전 지갑</p>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% else %>
										<p class="name">몬스터 동전 지갑</p>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% end if %>
									<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
								<% end if %>
								</div>
							</a>
						</div>
						<%
							Set oItem = Nothing
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1617788
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
						%>
						<div class="swiper-slide swiper-slide-buy">
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1617788&amp;pEtr=74912'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1617788&amp;pEtr=74912">
							<% End If %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/txt_sweet_monster.png" alt="MARK'S" />
								<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/img_item_02.jpg" alt="" />
								<div class="option">
								<% If oItem.FResultCount > 0 then %>
									<%'' for dev msg : 상품코드 1617788 , 할인기간 12/14 ~ 12/20, 할인 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <div class="price priceEnd">...<div> / <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
									<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
										<strong class="discount">단 일주일만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
										<p class="name">몬스터 파우치(L)</p>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% else %>
										<p class="name">몬스터 파우치(L)</p>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% end if %>
									<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
								<% end if %>
								</div>
							</a>
						</div>
						<%
							Set oItem = Nothing
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1618509
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
						%>
						<div class="swiper-slide swiper-slide-buy">
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1618509&amp;pEtr=74912'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1618509&amp;pEtr=74912">
							<% End If %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/txt_sweet_monster.png" alt="MARK'S" />
								<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/img_item_03.jpg" alt="" />
								<div class="option">
								<% If oItem.FResultCount > 0 then %>
									<%'for dev msg : 상품코드 1618509 , 할인기간 12/14 ~ 12/20, 할인 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <div class="price priceEnd">...<div> / <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
									<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
										<strong class="discount">단 일주일만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
										<p class="name">몬스터 밀크 뮤직 토이</p>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% else %>
										<p class="name">몬스터 밀크 뮤직 토이</p>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% end if %>
									<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
								<% end if %>
								</div>
							</a>
						</div>
						<%
							Set oItem = Nothing
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1618385
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
						%>
						<div class="swiper-slide swiper-slide-buy">
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1618385&amp;pEtr=74912'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1618385&amp;pEtr=74912">
							<% End If %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/txt_sweet_monster.png" alt="MARK'S" />
								<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/img_item_04.jpg" alt="" />
								<div class="option">
								<% If oItem.FResultCount > 0 then %>
									<% '' for dev msg : 상품코드 1618385 , 할인기간 12/14 ~ 12/20, 할인 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <div class="price priceEnd">...<div> / <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
									<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
										<strong class="discount">단 일주일만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
										<p class="name">몬스터 밀크 캔디 30정</p>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% else %>
										<p class="name">몬스터 밀크 캔디 30정</p>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% end if %>
									<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
								<% end if %>
								</div>
							</a>
						</div>
						<% Set oItem = Nothing %>

						<div class="swiper-slide swiper-slide-desc">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/img_story_01.jpg" alt="" />
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/txt_story_01.png" alt="#ORANGE 까칠한 성격을 소유자로 헤어 스타일링과 메이크업에 관심이 많으며 사람들에게 행운을 주는 것을 즐기는 행운의 아이콘" /></p>
						</div>
						<div class="swiper-slide swiper-slide-desc">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/img_story_02.jpg" alt="" />
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/txt_story_02.png" alt="#CHOCOMON 감성적인 로맨티시스트로 사람들에게 선물하는 것을 좋아한다 듬직한 등치지만 내면은 달콤함으로 무장되어 친구들이 힘들" /></p>
						</div>
						<div class="swiper-slide swiper-slide-desc">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/img_story_03.jpg" alt="" />
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/txt_story_03.png" alt="#BLUEMON 산만한 덩치로 엉뚱한 표정, 익살스러우면서도 귀여운 면이 있다 세상에 없는 재미있는 아이스크림을 만드는 것이 취미이고 팝몬이 베스트 프렌즈이다" /></p>
						</div>
						<div class="swiper-slide swiper-slide-desc">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/img_story_04.jpg" alt="" />
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/txt_story_04.png" alt="#COOKIEMON 항상 다른 컬러의 염색으로 녹차, 초코 등의 작은 가루의 크런치로 변신 마술이 가능하며 사람들 눈에 안 띄는 것을 즐기는 소심함을 가지고 있다" /></p>
						</div>

						<div class="swiper-slide swiper-slide-monster">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/img_monster.jpg" alt="" />
							<div class="txt">
								<span class="t01"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/txt_monster_01.png" alt="행복하고 즐거운 기분을 주는" /></span>
								<span class="t02"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/txt_monster_02.png" alt="스위트몬스터" /></span>
							</div>
						</div>

						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/txt_finish.jpg" alt="Hey, something project 작은 위로를 줄 수 있는 달콤함" /></p>
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
			<%''  for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/hey/74912_get.asp %>
			<div class="btnget">
				<% if isApp=1 then %>
					<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_74912_item.asp?isApp=<%= isApp %>'); return false;" title="Buy" alt="Buy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a>
				<% Else %>
					<a href="/event/etc/hsp/inc_74912_item.asp?isApp=<%= isApp %>" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a>
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
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/txt_comment.png" alt="두근두근 행복한 크리스마스! 올해 산타 할아버지는 나에게 어떤 선물을 주실까요? 정성껏 코멘트를 남겨주신 10분을 추첨해 빈티지 크리스마스 카드를 드립니다. (랜덤발송)" /></p>
						<div class="inner">
							<ul class="choice">
								<li class="ico1">
									<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/ico_01.png" alt="#ORANGEMON" /></button>
								</li>
								<li class="ico2">
									<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/ico_02.png" alt="#CHOCOMON" /></button>
								</li>
								<li class="ico3">
									<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/ico_03.png" alt="#BLUEMON" /></button>
								</li>
								<li class="ico4">
									<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912 /m/ico_04.png" alt="#COOKIEMON" /></button>
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
						<% If isarray(split(arrCList(1,intCLoop),"!@#")) Then %>
						<strong class="ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>">
							<% If split(arrCList(1,intCLoop),"!@#")(0)="1" Then %>
								#ORANGEMON
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
								#CHOCOMON
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
								#BLUEMON
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>
								#COOKIEMON
							<% Else %>
								#ORANGEMON
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

			$(".swiper-slide-brand").find(".brandTxt").delay(100).animate({"top":"7%", "opacity":"0"});
			$(".swiper-slide-active.swiper-slide-brand").find(".brandTxt").delay(100).animate({"top":"11.16%", "opacity":"1"},500);

			$(".swiper-slide-desc").find("p").delay(100).animate({"margin-bottom":"-2%", "opacity":"0"},400);
			$(".swiper-slide-active.swiper-slide-desc").find("p").delay(50).animate({"margin-bottom":"0", "opacity":"1"},300);

			$(".swiper-slide-monster").find(".txt .t01").delay(100).animate({"margin-left":"5%", "opacity":"0"},300);
			$(".swiper-slide-monster").find(".txt .t02").delay(100).animate({"margin-left":"-5%", "opacity":"0"},300);
			$(".swiper-slide-monster").find(".txt .t03").delay(100).animate({"margin-left":"5%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-monster").find(".txt span").animate({"margin-left":"0", "opacity":"1"},900);
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