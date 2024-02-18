<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈
' History : 2017-03-14 원승현 생성
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
	eCode   =  66299
Else
	eCode   =  77234
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

.mApp {display:none;}

/* title */
.heySomething .swiper-slide .hey {position:absolute; top:6.6%; left:0; width:100%;}

/* brand */
.heySomething .swiper-slide-brand {position:relative;}
.heySomething .logo {width:38.28%; margin:11% auto 0;}
.heySomething .swiper-slide-brand .brand {position:static; margin-top:10%;}
.videowrap {width:86.56%; margin:8.5% auto 0; }
.video {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background:#000;}
.video iframe {position:absolute; top:0; left:0; width:100%; height:100%}

/* buy */
.heySomething .swiper-slide-buy .option {text-align:center;}
.heySomething .option .name {margin-top:0.4rem;}
.heySomething .option .price {margin-top:0.6rem;}
.heySomething .option .price strong {color:#000;}
.swiper-slide-buy p {margin-top:1.5rem; color:#777; font-size:0.9rem;}
.swiper-slide-buy .option .btnbuy {margin-top:2.2rem;}
.ani,
.ani span {position:absolute; top:0; left:0; width:100%;}
.ani {display:none;}
.twinkle {animation:twinkle 3 4s; animation-fill-mode:both; -webkit-animation:twinkle 3 4s; -webkit-animation-fill-mode:both;s}
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

/* item */
.swiper-slide-item ul {overflow:hidden; margin-top:3.5rem; padding:0 0.75%;}
.swiper-slide-item ul li {float:left; width:50%; color:#777; font-size:1rem; text-align:center;}
.swiper-slide-item ul li a {display:block; margin:1.5rem 1.56% 0;}
.swiper-slide-item ul li span {overflow:hidden;display:block; margin-top:1rem; text-overflow:ellipsis; white-space:nowrap;}
.swiper-slide-item ul li div {margin-top:0.3rem;}
.swiper-slide-item ul li b {font-weight:bold;}

/* author */
.author .ani {top:47.29%; left:50%; width:87.65%; margin-left:-43.825%;}

/* comment */
.heySomething .form .inner {padding:0 6.25%;}
.heySomething .field {margin-top:2.3rem;}
.heySomething .form .choice li {width:21%; height:auto !important; margin-right:1.5%;}
.heySomething .form .choice li:last-child {margin-right:0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/ico_01_off.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/ico_02_off.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/ico_03_off.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/ico_04_off.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/ico_04_on.png);}
.heySomething .commentlist ul li {position:relative; min-height:10rem; padding:1.5rem  0 1.5rem 8rem;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:0.1rem; width:6.4rem; height:6.4rem; margin:-3.2rem 0 0 0.5rem; background-repeat:no-repeat; background-position:50% 0 !important; background-size:100% auto;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/ico_01_off.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/ico_02_off.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/ico_03_off.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/ico_04_off.png);}
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
		<% If not( left(currenttime,10)>="2017-04-04" and left(currenttime,10)<="2017-04-12" ) Then %>
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
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 1600){
					alert("코맨트는 400자 까지 작성 가능합니다.");
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
			<%' swiper %>
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						
						<%' 1 %>
						<div class="swiper-slide">
							<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project.png" alt="Hey, something project" /></strong>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_slide_01.jpg" alt="" /></div>
						</div>

						<%' 2 %>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
						</div>

						<%' brand %>
						<div class="swiper-slide swiper-slide-brand">
							<h3 class="logo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_logo_d_museum.png" alt="디뮤지엄" /></h3>
							<div class="videowrap">
								<div class="video">
									<iframe src="https://www.youtube.com/embed/1B-Z3Qie5Ts" title="디뮤지엄 유스 청춘의 열병, 그 못다한 이야기" frameborder="0" allowfullscreen></iframe>
								</div>
							</div>
							<p class="brand"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/txt_brand_v1.gif" alt="지금, 당신의 YOUTH를 깨워라! 디뮤지엄(D MUSEUM)은 오는 5월 28일까지 자유, 반항, 순수, 열정 등 유스컬처의 다양한 감성을 새로운 방식과 시각으로 선보이는 YOUTH 청춘의 열병, 그 못다한 이야기 전시를 개최합니다. 텐바이텐에서 유스컬처의 역동성을 담은 특별한 오리지널 굿즈를 만나보세요." /></p>
						</div>

						<%' buy %>
						<%
							Dim itemid, oItem
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1673277
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
						%>
						<div class="swiper-slide swiper-slide-buy">
						<%' for dev msg : 상품코드 1673277 가격부분 개발해주세요! 할인 없이 진행됩니다. %>
						<% If isApp = 1 Then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1673277&amp;pEtr=77234'); return false;">
						<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=1673277&amp;pEtr=77234">
						<% End If %>
								<div class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_slide_04_01_v1.jpg" alt="" /></div>
								<div class="ani">
									<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_slide_04_02_v1.jpg" alt="" /></span>
								</div>
								<div class="option">
								<% If oItem.FResultCount > 0 then %>
									<strong class="discount">텐바이텐 온라인 단독 판매</strong>
									<span class="name">디뮤지엄 YOUTH 에코백</span>
									<div class="price">
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
									</div>
									<p class="info">종류 : LOVER, MAN | 코튼 100% | MADE IN KOREA</p>
									<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
								<% End If %>
								</div>
							</a>
						</div>
						<% Set oItem = Nothing %>


						<%' item %>
						<div class="swiper-slide swiper-slide-item">
							<%' for dev msg : 가격 부분 개발 해주세요 %>
							<ul>
								<li>
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1673281&amp;pEtr=77234'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1673281&amp;pEtr=77234">
									<% End If %>
									<%
										IF application("Svr_Info") = "Dev" THEN
											itemid = 786868
										Else
											itemid = 1673281
										End If
										set oItem = new CatePrdCls
											oItem.GetItemData itemid
									%>
										<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_with_item_01.jpg" alt="" />
										<span>대림미술관&amp;디뮤지엄X카웨코 만년필</span>
										<div><b><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></b></div>
									</a>
									<% Set oItem = Nothing %>
								</li>
								<li>
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1673279&amp;pEtr=77234'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1673279&amp;pEtr=77234">
									<% End If %>
									<%
										IF application("Svr_Info") = "Dev" THEN
											itemid = 786868
										Else
											itemid = 1673279
										End If
										set oItem = new CatePrdCls
											oItem.GetItemData itemid
									%>
										<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_with_item_02.jpg" alt="" />
										<span>디뮤지엄 YOUTH 노트</span>
										<div><b><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></b></div>
									</a>
									<% Set oItem = Nothing %>
								</li>
								<li>
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1673276&amp;pEtr=77234'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1673276&amp;pEtr=77234">
									<% End If %>
									<%
										IF application("Svr_Info") = "Dev" THEN
											itemid = 786868
										Else
											itemid = 1673276
										End If
										set oItem = new CatePrdCls
											oItem.GetItemData itemid
									%>
										<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_with_item_03.jpg" alt="" />
										<span>디뮤지엄 YOUTH 핀버튼</span>
										<div><b><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></b></div>
									</a>
									<% Set oItem = Nothing %>
								</li>
								<li>
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1673275&amp;pEtr=77234'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1673275&amp;pEtr=77234">
									<% End If %>
									<%
										IF application("Svr_Info") = "Dev" THEN
											itemid = 786868
										Else
											itemid = 1673275
										End If
										set oItem = new CatePrdCls
											oItem.GetItemData itemid
									%>
										<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_with_item_04.jpg" alt="" />
										<span>디뮤지엄 YOUTH 토트백</span>
										<div><b><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></b></div>
									</a>
									<% Set oItem = Nothing %>
								</li>
								<li>
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1673273&amp;pEtr=77234'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1673273&amp;pEtr=77234">
									<% End If %>
									<%
										IF application("Svr_Info") = "Dev" THEN
											itemid = 786868
										Else
											itemid = 1673273
										End If
										set oItem = new CatePrdCls
											oItem.GetItemData itemid
									%>
										<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_with_item_05.jpg" alt="" />
										<span>디뮤지엄 YOUTH 아이폰 케이스 (6/6S/7)</span>
										<div><b><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></b></div>
									</a>
									<% Set oItem = Nothing %>
								</li>
								<li>
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1673274&amp;pEtr=77234'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1673274&amp;pEtr=77234">
									<% End If %>
									<%
										IF application("Svr_Info") = "Dev" THEN
											itemid = 786868
										Else
											itemid = 1673274
										End If
										set oItem = new CatePrdCls
											oItem.GetItemData itemid
									%>
										<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_with_item_06.jpg" alt="" />
										<span>디뮤지엄 YOUTH 필통</span>
										<div><b><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></b></div>
									</a>
									<% Set oItem = Nothing %>
								</li>
							</ul>
						</div>

						<div class="swiper-slide author">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_slide_06.jpg" alt="Masha Demianova 러시아 출신으로 모스크바와 뉴욕을 중심으로 활동하고 있는 사진작가 마샤 데미아노바는 여성의 시선 female gaze을 주제로 섬세하면서도 강인한 여인들의 모습을 사진으로 담는다. 그의 사진은 대체적으로 간결한 구성을 취하며 황량하고 몽환적인 분위기로 자유롭지만 동시에 쓸쓸하고 고독한 유스(Youth)의 단면을 보여준다." /></p>
							<div class="ani">
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_slide_06_ani.jpg" alt="" /></span>
							</div>
						</div>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_slide_07.jpg" alt="파올로 라엘리는 가까운 친구들이 경험한 인생의 아름다운 순간들과 일상을 카메라에 담아냄으로써 청춘이라는 시기에 겪을 수 있는 모호한 측면들을 다채롭게 녹여낸다. 사전 계획없이 피사체들이 움직이는 생동감 넘치는 순간을 포착하는 그의 사진들은 종종 초점이 맞지 않은 모습 그대로 자연스럽게 기록된다." /></p>
						</div>

						<%' story %>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_slide_08.jpg" alt="순수 영원히 늙고 싶지 않다. 청춘을 위한 우리의 자세" /></p>
						</div>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_slide_09.jpg" alt="반항 반항이 세상을 바꾼다. 거침없이 저항하라" /></p>
						</div>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_slide_10.jpg" alt="자유 두려움 없이 표현할 수 있는 용기" /></p>
						</div>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_slide_11.jpg" alt="열정 청춘은 아름답다. 설령 모자라거나 서툴러도" /></p>
						</div>

						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_slide_12.jpg" alt="한남동의 문화예술 아지트 2016년 설립 20주년을 맞이하는 대림문화재단은 한남동 독서당로에 디뮤지엄을 개관하고 기존의 대림미술관에서 선보여온 다양한 콘텐츠들을 더 확장된 공간에서 보다 많은 이들에게 문화 예술의 수준 높은 감성을 제시할 것입니다." /></p>
						</div>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_slide_13.jpg" alt="SPECIAL GIFT 디뮤지엄 YOUTH의 상품을 구매하신 고객님께 구매금액대별 유스 전시 티켓을 드립니다 15,000원 이상 구매시 유스 전시 프리티켓 1매 증정 30,000원 이상 구매스 유스 전시 프리티켓 2매 증정 2017. 4. 5~소진 시까지. 제공되는 티켓은 1인 1매 사용가능하며, 티켓이용기간 2017.02.08~ 2017.05.28 중 제한 없이 재관람이 가능합니다. 단, 대림미술관&디뮤지엄 모바일 앱 다운로드 및 인포데스크에서 회원 로그인 인증 후 입장가능하며, 대기인원이 있는 경우 입장이 지연될 수 있습니다. 대림미술관 인포데스크에서 온라인회원 가입 후 사용하셔도 무방하나, 미리 가입하시고 스마트폰 앱을 설치 하시고 오시면 입장이 보다 빠르고 편리하며,  앱을 통해 무료로 전시 오디오 가이드도 들으실 수 있습니다" /></p>
						</div>

						<%' comment Evt %>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/img_slide_14.gif" alt="Hey, something project 당신의 YOUTH 당신에게 YOUTH란 무엇인가요?" /></p>
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
		<% If isApp = 1 Then %>
			<div class="btnget"><a href="" onclick="fnAPPpopupBrand('daelimmuseum10'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_brand_shop_v1.png" alt="BRAND SHOP" /></a></div>
		<% Else %>
			<div class="btnget"><a href="/street/street_brand.asp?makerid=daelimmuseum10"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_brand_shop_v1.png" alt="BRAND SHOP" /></a></div>
		<% End If %>
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
					<legend>코멘트 작성 폼</legend>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/txt_comment.gif" alt="당신에게 YOUTH란 무엇인가요? 정성껏 코멘트를 남겨주신 10분을 추첨하여 유스 토트백과 전시티켓 2매를 드립니다. 토트백 디자인 랜덤 발송. 코멘트 작성기간은 2017년 4월 5일부터 4월 11일까지며, 발표는 4월 12일 입니다." /></p>
						<div class="inner">
							<ul class="choice">
								<li class="ico1">
									<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/ico_01_off.png" alt="순수" /></button>
								</li>
								<li class="ico2">
									<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/ico_02_off.png" alt="반항" /></button>
								</li>
								<li class="ico3">
									<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/ico_03_off.png" alt="자유" /></button>
								</li>
								<li class="ico4">
									<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/77234/m/ico_04_off.png" alt="열정" /></button>
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
								순수
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
								반항
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
								자유
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>
								열정
							<% Else %>
								순수
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
		//initialSlide:6,
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

			$(".swiper-slide-buy").find(".ani").hide();
			$(".swiper-slide-active.swiper-slide-buy").find(".ani").show();
			$(".swiper-slide-buy").find(".ani span").removeClass("twinkle");
			$(".swiper-slide-active.swiper-slide-buy").find(".ani span").addClass("twinkle");

			$(".author").find(".ani").hide();
			$(".swiper-slide-active.author").find(".ani").show();
			$(".author").find(".ani span").removeClass("twinkle");
			$(".swiper-slide-active.author").find(".ani span").addClass("twinkle");
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