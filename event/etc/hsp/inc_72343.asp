<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 43
' History : 2016-08-09 김진영 생성
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
	eCode   =  66180
Else
	eCode   =  72343
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

.heySomething .article .btnget {width:38.43%; margin-left:-19.215%;}
.heySomething .app {display:none;}

/* title */
.heySomething .swiper-slide .hey {position:absolute; top:6.5%; left:0; width:100%;}

/* buy */
.heySomething .option .discount {background-color:#3a940e;}
.heySomething .option .price strong {color:#3a940e;}
.heySomething .option .priceEnd strong {color:#000;}
.heySomething .swiper-slide-buy {background-color:#f8f8f8;}
.heySomething .swiper-slide-buy a {display:block;}
.heySomething .swiper-slide-buy .option {text-align:center;}
.heySomething .swiper-slide-buy .animation {position:absolute; top:0; left:0; width:100%;}
.heySomething .swiper-slide-buy .animation .opacity {position:absolute; top:0; left:0; width:100%;}

.twinkle {
	animation-name:twinkle; animation-iteration-count:3; animation-duration:4s; animation-fill-mode:both;
	-webkit-animation-name:twinkle; -webkit-animation-iteration-count:3; -webkit-animation-duration:4s; -webkit-animation-fill-mode:both;
}
@keyframes twinkle {
	0% {opacity:0;}
	50% {opacity:1;}
	100% {opacity:0;}
}
@-webkit-keyframes twinkle {
	0% {opacity:0;}
	50% {opacity:1;}
	100% {opacity:0;}
}

/* item*/
.swiper-slide-item {background-color:#f4f4f4;}
.swiper-slide-item ul li {float:left; width:50%;}
.swiper-slide-item ul li:nth-child(1), .swiper-slide-item ul li:nth-child(4), .swiper-slide-item ul li:nth-child(5) {background-color:#b0e7f6;}
.swiper-slide-item ul li a {display:block; position:relative;}
.swiper-slide-item ul li a span {overflow:hidden; position:absolute; top:0; left:0; width:100%;}
.pulse {animation-name:pulse; animation-duration:2s; animation-iteration-count:1; -webkit-animation-name:pulse; -webkit-animation-duration:2s; -webkit-animation-iteration-count:1;}
@keyframes pulse {
	0% {transform:scale(2);}
	100% {transform:scale(1);}
}
@-webkit-keyframes pulse {
	0% {-webkit-transform:scale(2);}
	100% {-webkit-transform:scale(1);}
}

/* video */
.video {position:absolute; top:20.93%; left:50%; width:76.4%; margin-left:-38.2%;}
.video .youtube {overflow:hidden; position:relative; height:0; padding-bottom:100.25%; background:#000;}
.video .youtube iframe {overflow:hidden; position:absolute; top:0; left:0; width:100%; height:100%;}

/* story */
.heySomething .swiper-slide .desc {position:absolute; top:80.93%; left:0; width:100%;}

/* finish */
.heySomething .swiper-slide-finish p {position:absolute; top:17.34%; left:54.68%; width:37.65%;}

/* comment */
.heySomething .swiper-slide .btngo {top:70%;}

.heySomething .form .inner {padding:0 5%;}
.heySomething .form .choice {padding:3% 4% 0 3%;}
.heySomething .form .choice li {width:33.333%; height:auto !important; margin:0; padding:0 7% 0 0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/ico_01_off.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/ico_02_off.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/ico_03_off.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/ico_03_on.png);}

.heySomething .field {margin-top:4%;}

.heySomething .commentlist ul li {position:relative; min-height:9rem; padding:1.5rem 0 1.5rem 7.75rem;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:0.1rem; width:6.6rem; height:6.6rem; margin-top:-3.3rem; background-repeat:no-repeat; background-position:50% 0 !important; background-size:100% auto;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/ico_01_off.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/ico_02_off.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/ico_03_off.png);}
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
		<% If not( left(currenttime,10)>="2016-08-09" and left(currenttime,10)<="2016-08-16" ) Then %>
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
	<%' main contents %>
	<div class="section article">
		<%' swiper %>
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project_white.png" alt="Hey, something project" /></strong>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_slide_01.jpg" alt="MBC와 옥스포드 블록의 콜라보레이션 상품 MBC 라디오 스튜디오, MBC 라디오 중계차, MBC 방송헬기" />
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
							itemid = 1543277
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy swiper-slide-animation">
					<%' for dev msg : 상품 링크 %>
					<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1543277&amp;pEtr=72343'); return false;">
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1543277&amp;pEtr=72343">
					<% End If %>
							<div class="animation">
								<span class="opacity"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_slide_03_animation.jpg" alt="" /></span>
							</div>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_slide_03.jpg" alt="" />
							<div class="option">
						<% If oItem.FResultCount > 0 then %>
							<%' for dev msg : 상품코드 1543277 할인 중 %>
							<% If (oItem.Prd.FItemCouponYN="Y") Then %>
								<strong class="discount">텐바이텐 단독 선오픈</strong>
								<span class="name">MBC 라디오 스튜디오</span>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.GetCouponAssignPrice,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% Else %>
								<span class="name">MBC 라디오 스튜디오</span>
								<div class="price priceEnd">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% End If %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
						<% End If %>
							</div>
						</a>
					</div>
					<%
						Set oItem = Nothing
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1543276
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
					<%' for dev msg : 상품 링크 %>
					<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1543276&amp;pEtr=72343'); return false;">
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1543276&amp;pEtr=72343">
					<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_slide_04.jpg" alt="" />
							<div class="option">
						<% If oItem.FResultCount > 0 then %>
							<%' for dev msg : 상품코드 1543276 할인 중 %>
							<% If (oItem.Prd.FItemCouponYN="Y") Then %>
								<strong class="discount">텐바이텐 단독 선오픈</strong>
								<span class="name">MBC 라디오 중계차</span>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.GetCouponAssignPrice,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% Else %>
								<span class="name">MBC 라디오 중계차</span>
								<div class="price priceEnd">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% End If %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
						<% End If %>
							</div>
						</a>
					</div>
					<%
						Set oItem = Nothing
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1543275
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
					<%' for dev msg : 상품 링크 %>
					<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1543275&amp;pEtr=72343'); return false;">
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1543275&amp;pEtr=72343">
					<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_slide_05.jpg" alt="" />
							<div class="option">
						<% If oItem.FResultCount > 0 then %>
							<%' for dev msg : 상품코드 1543275 할인 중 %>
							<% If (oItem.Prd.FItemCouponYN="Y") Then %>
								<strong class="discount">텐바이텐 온라인몰 단독 판매!</strong>
								<span class="name">MBC 방송 헬기</span>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.GetCouponAssignPrice,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% Else %>
								<span class="name">MBC 방송 헬기</span>
								<div class="price priceEnd">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% End If %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
						<% End If %>
							</div>
						</a>
					</div>

					<div class="swiper-slide swiper-slide-item">
						<ul class="mo">
							<li>
								<a href="/category/category_itemPrd.asp?itemid=1543286&amp;pEtr=72343">
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_white.png" alt="" />
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_01.png" alt="엠빅 비치볼" /></span>
								</a>
							</li>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=1543282&amp;pEtr=72343">
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_white.png" alt="" />
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_02.png" alt="엠빅 마이크 인형 2종" /></span>
								</a>
							</li>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=1543105&amp;pEtr=72343">
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_white.png" alt="" />
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_03.png" alt="방송사 사람들 뱃지 6종" /></span>
								</a>
							</li>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=1543295&amp;pEtr=72343">
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_white.png" alt="" />
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_04.png" alt="엠빅 세라믹 머그컵 2종" /></span>
								</a>
							</li>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=1543278&amp;pEtr=72343">
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_white.png" alt="" />
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_05.png" alt="엠빅 인형 중형" /></span>
								</a>
							</li>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=1543284&amp;pEtr=72343">
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_white.png" alt="" />
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_06.png" alt="MBC 엽서세트" /></span>
								</a>
							</li>
						</ul>
						<ul class="app">
							<li>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1543286&amp;pEtr=72343" onclick="fnAPPpopupProduct('1543286&amp;pEtr=72343');return false;">
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_white.png" alt="" />
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_01.png" alt="엠빅 비치볼" /></span>
								</a>
							</li>
							<li>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1543282&amp;pEtr=72343" onclick="fnAPPpopupProduct('1543282&amp;pEtr=72343');return false;">
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_white.png" alt="" />
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_02.png" alt="엠빅 마이크 인형 2종" /></span>
								</a>
							</li>
							<li>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1543105&amp;pEtr=72343" onclick="fnAPPpopupProduct('1543105&amp;pEtr=72343');return false;">
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_white.png" alt="" />
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_03.png" alt="방송사 사람들 뱃지 6종" /></span>
								</a>
							</li>
							<li>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1543295&amp;pEtr=72343" onclick="fnAPPpopupProduct('1543295&amp;pEtr=72343');return false;">
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_white.png" alt="" />
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_04.png" alt="엠빅 세라믹 머그컵 2종" /></span>
								</a>
							</li>
							<li>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1543278&amp;pEtr=72343" onclick="fnAPPpopupProduct('1543278&amp;pEtr=72343');return false;">
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_white.png" alt="" />
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_05.png" alt="엠빅 인형 중형" /></span>
								</a>
							</li>
							<li>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1543284&amp;pEtr=72343" onclick="fnAPPpopupProduct('1543284&amp;pEtr=72343');return false;">
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_white.png" alt="" />
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_item_06.png" alt="MBC 엽서세트" /></span>
								</a>
							</li>
						</ul>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_slide_07.png" alt="MBC 브랜드 스토어는 MBC브랜드와 주요 프로그램 이미지를 활용하여 MBC의 핵심가치인 신뢰, 즐거움, 감동을 녹인 제품을 만들고 있습니다." /></p>
					</div>

					<div class="swiper-slide">
						<div class="video">
							<div class="youtube">
								<iframe src="//player.vimeo.com/video/177643392" frameborder="0" title="MBC와 옥스포드 볼록의 콜라보레이션" allowfullscreen></iframe>
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_slide_08.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1543277&amp;pEtr=72343" title="MBC라디오 스튜디오 보러가기" class="mo">
							<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/txt_desc_01.png" alt="상암동의 명물로 자리 잡은 MBC라디오 가든 스튜디오! 1층 광장을 지나 정문쪽에 커다란 통유리창 스튜디오가 바로 가든 스튜디오입니다." /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_slide_09.jpg" alt="" />
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1543277&amp;pEtr=72343" onclick="fnAPPpopupProduct('1543277&amp;pEtr=72343');return false;" title="MBC라디오 스튜디오 보러가기" class="app">
							<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/txt_desc_01.png" alt="상암동의 명물로 자리 잡은 MBC라디오 가든 스튜디오! 1층 광장을 지나 정문쪽에 커다란 통유리창 스튜디오가 바로 가든 스튜디오입니다." /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_slide_09.jpg" alt="" />
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1543276&amp;pEtr=72343" title="MBC 라디오 중계차 보러가기" class="mo">
							<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/txt_desc_02.png" alt="MBC 라디오 이동식 스튜디오 청취자들과 눈을 마주보며 이야기를 나눌 수 있는 라디오 교류의 장 라디오 중계차!" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_slide_10.jpg" alt="" />
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1543276&amp;pEtr=72343" onclick="fnAPPpopupProduct('1543276&amp;pEtr=72343');return false;" title="MBC 라디오 중계차 보러가기" class="app">
							<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/txt_desc_02.png" alt="MBC 라디오 이동식 스튜디오 청취자들과 눈을 마주보며 이야기를 나눌 수 있는 라디오 교류의 장 라디오 중계차!" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_slide_10.jpg" alt="" />
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1543275&amp;pEtr=72343" title="MBC 방송헬기 보러가기" class="mo">
							<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/txt_desc_03.png" alt="독도 진입이 가능한 MBC헬기 답게 전국 방방 곡곡을 누비며 대한민국의 생생한 이야기를 전달 하고 있는 방송 헬기!" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_slide_11.jpg" alt="" />
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1543275&amp;pEtr=72343" onclick="fnAPPpopupProduct('1543275&amp;pEtr=72343');return false;" title="MBC 방송헬기 보러가기" class="app">
							<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/txt_desc_03.png" alt="독도 진입이 가능한 MBC헬기 답게 전국 방방 곡곡을 누비며 대한민국의 생생한 이야기를 전달 하고 있는 방송 헬기!" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_slide_11.jpg" alt="" />
						</a>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/img_slide_12.png" alt="Hey, something project 어떤 상품을 갖고 싶나요?" /></p>
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

		<%' 브랜드샵 바로가기 버튼 %>
		<div class="btnget mo"><a href="/street/street_brand.asp?makerid=mbcbrandstore"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_brand_shop_v1.png" alt="MBC브랜드스토어 브랜드 샵으로 이동" /></a></div>
		<div class="btnget app"><a href="/street/street_brand.asp?makerid=mbcbrandstore" onclick="fnAPPpopupBrand('mbcbrandstore'); return false;" ><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_brand_shop_v1.png" alt="MBC브랜드스토어 브랜드 샵으로 이동" /></a></div>
	</div>
	<%' //main contents %>
	<%' comment event %>
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
				<legend>MBC 브랜드 스토어와 옥스포드 콜라보 상품 중 가장 갖고 상품을 선택하고 라디오로 멋진 삼행시 짓기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/txt_comment.png" alt="MBC라디오 스튜디오, 라디오 중계차의 모티브가된 라디오! 라디오로 멋진 삼행시를 지으신 분 중 7분을 추첨하여 MBC라디오 중계차 블록 2명, 엠빅 마이크인형 2명, 엠빅인형 3명을 선정하여 드립니다. 랜덤으로 증정합니다. 코멘트 작성기간은 2016년 8월 10일부터 8월 16일까지며, 발표는 8월 17일 입니다." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/ico_01_off.png" alt="Garden studio" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/ico_02_off.png" alt="Broadcast van" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72343/m/ico_03_off.png" alt="Helicopter" /></button>
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
					<% If isarray(split(arrCList(1,intCLoop),"!@#")) Then %>
					<strong class="ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>">
						<% If split(arrCList(1,intCLoop),"!@#")(0)="1" Then %>
							Garden studio
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
							Broadcast van
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
							Helicopter
						<% Else %>
							Garden studio
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
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery.slides.min.js"></script>
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

			$(".swiper-slide").find(".hey").delay(100).animate({"top":"8.5%", "opacity":"0"},300);
			$(".swiper-slide-active").find(".hey").delay(50).animate({"top":"6.5%", "opacity":"1"},600);

			$(".swiper-slide-animation").find(".animation .opacity").removeClass("twinkle");
			$(".swiper-slide-active.swiper-slide-animation").find(".animation .opacity").addClass("twinkle");

			$(".swiper-slide.swiper-slide-item").find("ul li span").delay(100).animate({"opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-item").find("ul li:nth-child(1) span").delay(100).animate({"opacity":"1"},500);
			$(".swiper-slide-active.swiper-slide-item").find("ul li:nth-child(2) span").delay(500).animate({"opacity":"1"},500);
			$(".swiper-slide-active.swiper-slide-item").find("ul li:nth-child(3) span").delay(300).animate({"opacity":"1"},500);
			$(".swiper-slide-active.swiper-slide-item").find("ul li:nth-child(4) span").delay(100).animate({"opacity":"1"},500);
			$(".swiper-slide-active.swiper-slide-item").find("ul li:nth-child(5) span").delay(100).animate({"opacity":"1"},500);
			$(".swiper-slide-active.swiper-slide-item").find("ul li:nth-child(6) span").delay(800).animate({"opacity":"1"},500);
			$(".swiper-slide-item").find("ul li span img").removeClass("pulse");
			$(".swiper-slide-active.swiper-slide-item").find("ul li span img").addClass("pulse");

			$(".swiper-slide.swiper-slide-story").find(".desc").delay(100).animate({"margin-top":"3%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-story").find(".desc").delay(50).animate({"margin-top":"0", "opacity":"1"},500);
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