<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈
' History : 2017-02-28 이종화 생성
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
	eCode   =  66285
Else
	eCode   =  76405
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

/* title */
.heySomething .swiper-slide .hey {position:absolute; top:6.6%; left:0; width:100%;}

/* brand */
.heySomething .swiper-slide-brand {position:relative;}
.heySomething .swiper-slide-brand .brand {position:absolute; left:0; width:100%;}
.heySomething .swiper-slide-brand .brand1 {top:65.41%;}
.heySomething .swiper-slide-brand .brand2 {top:76.77%;}

/* buy */
.heySomething .swiper-slide-buy .option {text-align:center;}
.heySomething .swiper-slide-buy .option .name {font-weight:bold; font-size: 1.5rem}
.heySomething .swiper-slide-buy .option .name span {display:block; margin-top:.5rem; color:#999; font-size:.8rem; line-height:.82rem;}
.heySomething .swiper-slide-buy .price {margin-top:1.3rem ;}
.heySomething .swiper-slide-buy .price strong {display:inline-block; font-size:1.5rem; font-weight:bold; line-height:1.5rem;}
.heySomething .swiper-slide-buy .option .btnbuy {margin-top:1.3rem;}
.heySomething .option .name + p {margin-top:1rem; padding:0 1rem; color:#777; font-size:1.1rem; line-height:1.375em;}
.swiper-slide-buy ul {overflow:hidden; width:88.43%; margin:0 auto;}
.swiper-slide-buy ul li {float:left; width:50%; padding:0.75%;}
.swiper-slide-buy ul li a {display:block; position:relative;}
.swiper-slide-buy ul li span {position:absolute; bottom:14.83%; left:0; width:100%; color:#d60000; font-size:1rem; text-align:center;}
.acc ul li span {bottom:9.677%;}

/* visual */
.swiper-slide-visual p {position:absolute; bottom:25.41%; left:0;width:100%;}

/* story */
.swiper-slide-story .itemList {position:absolute; top:0; left:0; width:100%; height:100%;}
.swiper-slide-story .itemList li {position:absolute; top:18%; left:36%; width:15.625%;}
.swiper-slide-story .itemList li.item2 {top:31%; left:46.5%;}
.swiper-slide-story .itemList li.item3 {top:14.5%; left:76%;}
.swiper-slide-story .itemList li.item4 {top:44%; left:11%;}
.swiper-slide-story .itemList li.item5 {top:56%; left:38%;}
.quality .itemList li {top:13%; left:29%;}
.quality .itemList li.item2 {top:37%; left:6.5%;}
.quality .itemList li.item3 {top:23.5%; left:63%;}
.quality .itemList li.item4 {top:49.5%; left:58%;}
.quality .itemList li.item5 {top:57.2%; left:60%;}

/* comment */
.heySomething .swiper-slide .btngo {top:70%;}
.heySomething .form .inner {padding:0 6.25%;}
.heySomething .form .choice li {width:21.42%; height:auto !important; margin-right:3%;}
.heySomething .form .choice li:last-child {margin-right:0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/ico_01_off.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/ico_02_off.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/ico_03_off.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/ico_04_off.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/ico_04_on.png);}
.heySomething .field {margin-top:1.5rem;}
.heySomething .field textarea {height:5.5rem;}
.heySomething .field input {width:5.5rem; height:5.5rem; font-size:0.9rem;}
.heySomething .commentlist ul li {position:relative; min-height:10rem; padding:1.5rem  0 1.5rem 8rem;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:0.1rem; width:5.25rem; height:5.25rem; margin:-2.625rem 0 0 0.5rem; background-repeat:no-repeat; background-position:50% 0 !important; background-size:100% auto;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/ico_01_off.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/ico_02_off.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/ico_03_off.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/ico_04_off.png);}
.heySomething .commentlist ul li .mob img {width:0.9rem; margin-top:-0.1rem; margin-left:0.2rem;}

/* css3 animation */
.bounce {animation:bounce 5 1s; -webkit-animation:bounce 5 1s;}
@keyframes bounce {
	from, to{margin-top:0; animation-timing-function:linear;}
	50% {margin-top:5px; animation-timing-function:linear;}
}

@-webkit-keyframes bounce {
	from, to{margin-top:0; -webkit-animation-timing-function:linear;}
	50% {margin-top:5px; -webkit-animation-timing-function:linear;}
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
		<% If not( left(currenttime,10)>="2017-03-01" and left(currenttime,10)<"2017-03-08" ) Then %>
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
		<div class="swiper" id="toparticle">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project.png" alt="Hey, something project" /></strong>
						<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/img_slide_01.jpg" alt="" /></div>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>

					<div class="swiper-slide swiper-slide-brand">
						<p class="brand brand1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/txt_brand_01.png" alt="Japanism Product를 컨셉으로 2015년부터 MOONSTAR의 구루메 지역에서 탄생한 브랜드 PRAS입니다" /></p>
						<p class="brand brand2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/txt_brand_02.png" alt="Japanism Product는 단순히 일본 제품이라는 것이 아니라, 진지, 섬세함, 우직함, 겸손, 친절함과 같은 눈에 보이지 않는 내면의 일본적 특성을 담아내는 것으로 목표로 하고 있습니다" /></p>
						<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/img_slide_03.jpg" alt="" /></div>
					</div>

					<%' buy %>
					<% '1차 %>
					<%
						Dim itemid, oItem
						Set oItem = Nothing
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786869
						Else
							itemid = 1652915
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
						<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1652915&amp;pEtr=76405'); return false;">
						<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1652915&amp;pEtr=76405">
						<% End If %>
							<div class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/img_slide_04.gif" alt="" /></div>
							<div class="option">
								<span class="name">Shellcap Low<br /> KINARI x BLACK</span>
								<p>Size: 220-260 사이즈 (10단위) / UPPER: NO.10 HANPU COTTON 100%</p>
								<div class="price">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
							</div>
						</a>
					</div>
					<% Set oItem = Nothing %>
					
					<% 
						Dim itemarr , itemaltarr
						IF application("Svr_Info") = "Dev" THEN
							itemarr = array(786868,786868,786868,786868)
							itemaltarr = array("Shellcap Low KINARI OFF x WHITE","Shellcap Low KURO OFF x WHITE","Shellcap Low KURO x BLACK","Shellcap Low Hanelca SUMI x BLACK")
						Else
							itemarr = array(1652916,1652927,1652926,1652933)
							itemaltarr = array("Shellcap Low KINARI OFF x WHITE","Shellcap Low KURO OFF x WHITE","Shellcap Low KURO x BLACK","Shellcap Low Hanelca SUMI x BLACK")
						End If
					%>
					
					<div class="swiper-slide swiper-slide-buy">
						<div class="logo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/img_logo_pras.gif" alt="" /></div>
						<ul>
							<%
								Dim lp 
								For lp = 0 To ubound(itemarr) '4개

								set oItem = new CatePrdCls
									oItem.GetItemData itemarr(lp)
							%>
							<% If oItem.FResultCount > 0 Then %>
							<li>
								<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=itemarr(lp)%>&pEtr=76405'); return false;">
								<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=<%=itemarr(lp)%>&pEtr=76405">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/img_slide_05_0<%=lp+1%>_v1.jpg" alt="<%=itemaltarr(lp)%>" />
									<span><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
							<% End If %>
							<% 
								set oItem=nothing
								Next 
							%>
						</ul>
					</div>
					<% '1차 %>

					<% '2차 %>
					<%
						Set oItem = Nothing
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786869
						Else
							itemid = 1652967
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
						<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1652967&amp;pEtr=76405'); return false;">
						<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1652967&amp;pEtr=76405">
						<% End If %>
							<div class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/img_slide_06.gif" alt="" /></div>
							<div class="option">
								<span class="name">Shoulder Tote<br /> KINARI x SUMI</span>
								<p>Size: 30cm×40cm×10cm / UPPER: NO.10 HANPU COTTON 100%</p>
								<div class="price">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
							</div>
						</a>
					</div>
					<% Set oItem = Nothing %>

					<% 
						Dim itemarr2 , itemaltarr2
						IF application("Svr_Info") = "Dev" THEN
							itemarr2 = array(786868,786868,786868,786868)
							itemaltarr2 = array("Passport Case KINARI x SUMI","Document Case KINARI x SUMI","Kamibukuro KINARI x SUMI","Shose Case KINARI 100% cotton")
						Else
							itemarr2 = array(1652934,1652966,1652968,1654154)
							itemaltarr2 = array("Passport Case KINARI x SUMI","Document Case KINARI x SUMI","Kamibukuro KINARI x SUMI","Shose Case KINARI 100% cotton")
						End If
					%>
					<div class="swiper-slide swiper-slide-buy acc">
						<div class="logo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/img_logo_pras.gif" alt="" /></div>
						<ul>
							<%
								Dim lp2 
								For lp2 = 0 To ubound(itemarr2) '5개

								set oItem = new CatePrdCls
									oItem.GetItemData itemarr2(lp2)
							%>
							<% If oItem.FResultCount > 0 Then %>
							<li>
								<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=itemarr2(lp2)%>&pEtr=76405'); return false;">
								<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=<%=itemarr2(lp2)%>&pEtr=76405">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/img_slide_06_0<%=(lp2+1)%>_v1.jpg" alt="Passport Case KINARI x SUMI" />
									<span><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
							<% End If %>
							<% 
								set oItem=nothing

								Next 
							%>
						</ul>
					</div>
					<% '2차 %>

					<div class="swiper-slide swiper-slide-visual">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/txt_visual.png" alt="Anywhere You Go" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/img_slide_08.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-story">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/img_slide_09.jpg" alt="Value 제작 기간만 4-5개월로, 그들의 가치와 시간이 녹여진 브랜드입니다." /></p>
					</div>
					<div class="swiper-slide swiper-slide-story">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/img_slide_10.jpg" alt="Minimalism 블랙 앤 화이트가 주를 이루는 PRAS 제품은 군더더기를 뺀 미니멀 디자인을 추구합니다" /></p>
					</div>
					<div class="swiper-slide swiper-slide-story feet">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/img_slide_11.jpg" alt="Feet 점토처럼 유연한 생고무를 덧대어 발모양에 따라 편안한 핏을 구현합니다" /></p>
						<ul class="itemList mWeb">
							<li class="item1"><a href="/category/category_itemPrd.asp?itemid=1652933&pEtr=76405"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt="Shellcap Low Hanelca SUMI x BLACK" /></a></li>
							<li class="item2"><a href="/category/category_itemPrd.asp?itemid=1652916&pEtr=76405"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt="Shellcap Low KINARI x OFF WHITE" /></a></li>
							<li class="item3"><a href="/category/category_itemPrd.asp?itemid=1652927&pEtr=76405"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt="hellcap Low KURO x OFF WHITE" /></a></li>
							<li class="item4"><a href="/category/category_itemPrd.asp?itemid=1652915&pEtr=76405"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt="Shellcap Low KINARI x BLACK" /></a></li>
							<li class="item5"><a href="/category/category_itemPrd.asp?itemid=1652926&pEtr=76405"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt="Shellcap Low KURO x BLACK" /></a></li>
						</ul>
						<ul class="itemList mApp">
							<li class="item1"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1652933&pEtr=76405" onclick="fnAPPpopupProduct('1652933&pEtr=76405');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt="Shellcap Low Hanelca SUMI x BLACK" /></a></li>
							<li class="item2"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1652916&pEtr=76405" onclick="fnAPPpopupProduct('1652916&pEtr=76405');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt="Shellcap Low KINARI x OFF WHITE" /></a></li>
							<li class="item3"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1652927&pEtr=76405" onclick="fnAPPpopupProduct('1652927&pEtr=76405');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt="hellcap Low KURO x OFF WHITE" /></a></li>
							<li class="item4"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1652915&pEtr=76405" onclick="fnAPPpopupProduct('1652915&pEtr=76405');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt="Shellcap Low KINARI x BLACK" /></a></li>
							<li class="item5"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1652926&pEtr=76405" onclick="fnAPPpopupProduct('1652926&pEtr=76405');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt="Shellcap Low KURO x BLACK" /></a></li>
						</ul>
					</div>
					<div class="swiper-slide swiper-slide-story quality">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/img_slide_12.jpg" alt="Quality 코지마 캔버스를 사용하며, 솔(Sole)은 vulcanized 제법으로 완성도를 높였습니다" /></p>
						<ul class="itemList mWeb">
							<li class="item1"><a href="/category/category_itemPrd.asp?itemid=1652967&pEtr=76405"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt="Shoulder Tote KINARI x SUMI" /></a></li>
							<li class="item2"><a href="/category/category_itemPrd.asp?itemid=1652933&pEtr=76405"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt="Shellcap Low Hanelca SUMI x BLACK" /></a></li>
							<li class="item3"><a href="/category/category_itemPrd.asp?itemid=1652968&pEtr=76405"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt="Kamibukuro KINARI x SUM" /></a></li>
							<li class="item4"><a href="/category/category_itemPrd.asp?itemid=1652934&pEtr=76405"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt=" Passport Case KINARI x SUMI" /></a></li>
							<li class="item5"><a href="/category/category_itemPrd.asp?itemid=1652966&pEtr=76405"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt="Document Case KINARI x SUMI" /></a></li>
						</ul>
						<ul class="itemList mApp">
							<li class="item1"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1652967&pEtr=76405" onclick="fnAPPpopupProduct('1652967&pEtr=76405');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt="Shoulder Tote KINARI x SUMI" /></a></li>
							<li class="item2"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1652933&pEtr=76405" onclick="fnAPPpopupProduct('1652933&pEtr=76405');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt="Shellcap Low Hanelca SUMI x BLACK" /></a></li>
							<li class="item3"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1652968&pEtr=76405" onclick="fnAPPpopupProduct('1652968&pEtr=76405');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt="Kamibukuro KINARI x SUM" /></a></li>
							<li class="item4"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1652934&pEtr=76405" onclick="fnAPPpopupProduct('1652934&pEtr=76405');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt=" Passport Case KINARI x SUMI" /></a></li>
							<li class="item5"><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1652966&pEtr=76405" onclick="fnAPPpopupProduct('1652966&pEtr=76405');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/btn_plus.png" alt="Document Case KINARI x SUMI" /></a></li>
						</ul>
					</div>

					<div class="swiper-slide swiper-slide-finish">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/img_slide_13.jpg" alt="PRAS made in Japan" />
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/img_slide_14.png" alt="Hey, something project 당신이 신고 싶은 것 내가 가장 신고 싶은 신발은 무엇인가요?" /></p>
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
			<% if isApp=1 then %>
			<a href="" onclick="fnAPPpopupBrand('PRAS1010'); return false;" title="프라스 브랜드 페이지로 이동" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_brand_shop_v1.png" alt="BRAND SHOP" /></a>
			<% Else %>
			<a href="/street/street_brand.asp?makerid=PRAS1010" title="프라스 브랜드 페이지로 이동" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_brand_shop_v1.png" alt="BRAND SHOP" /></a>
			<% End If %>
		</div>
	</div>

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
				<fieldset>
				<legend>코멘트 작성 폼</legend>
					<p class="evntTit"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/txt_comment.png" alt="정성껏 코멘트를 남겨주신 1분을 추첨하여 PRAS 슈즈를 선물로 드립니다. 코멘트 기재시, 사이즈 기재 필수며, 스타일은 랜덤으로 배송됩니다. 코멘트 작성기간은 2017년 3월 1일부터 3월 7일까지며, 발표는 2017년 3월 8일 입니다.." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/ico_01_off.png" alt="Value" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/ico_02_off.png" alt="Minimal" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/ico_03_off.png" alt="Feet" /></button>
							</li>
							<li class="ico4">
								<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76405/m/ico_04_off.png" alt="Quality" /></button>
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
							Value
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
							Minimal
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
							Feet
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>
							Quality
						<% Else %>
							Value
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
	<%' //comment event %>
	<div id="dimmed"></div>
</div>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery.slides.min.js"></script>
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

			$(".swiper-slide-brand").find(".brand1").delay(100).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide-brand").find(".brand2").delay(300).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-brand").find(".brand1").delay(50).animate({"margin-top":"0", "opacity":"1"},500);
			$(".swiper-slide-active.swiper-slide-brand").find(".brand2").delay(100).animate({"margin-top":"0", "opacity":"1"},500);

			$(".swiper-slide.swiper-slide-story").find(".itemList li a img").removeClass("bounce");
			$(".swiper-slide-active.swiper-slide-story").find(".itemList li a img").addClass("bounce");

			$(".swiper-slide-visual").find("p").delay(100).animate({"margin-bottom":"7%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-visual").find("p").delay(50).animate({"margin-bottom":"0", "opacity":"1"},500);
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