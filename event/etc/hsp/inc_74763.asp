<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈
' History : 2016-12-06 이종화 생성
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
	eCode   =  66250
Else
	eCode   =  74763
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

/* 1. title */
.heySomething .swiper-slide .hey {position:absolute; top:6.6%; left:0; width:100%;}

/* 3. brand */
.heySomething .swiper-slide-brand {position:relative;}
.heySomething .swiper-slide-brand a {display:block; position:absolute; top:0; left:0;  width:100%; height:100%; z-index:10;}
.heySomething .swiper-slide-brand .brand {position:absolute;}
.heySomething .swiper-slide-brand .brand1 {top:17.18%; padding:0 15%;}
.heySomething .swiper-slide-brand .brand2 {top:28.64%; padding:0 15.46%;}
.heySomething .swiper-slide-brand .brand3 {top:68.75%; padding:0 29.6%;}

/* 4. buy */
.heySomething .swiper-slide-buy {background-color:#fff;}
.heySomething .swiper-slide-buy .item01 {margin:4rem 0 3.5rem;}
.heySomething .swiper-slide-buy a {display:block;}
.heySomething .swiper-slide-buy .option .discountOne {position:absolute; top:66%; right:13%; width:2.5rem;border-radius:25%;}
.heySomething .swiper-slide-buy .option {text-align:center;}
.heySomething .swiper-slide-buy .name {margin-top:3rem; font-size:1.8rem}
.heySomething .swiper-slide-buy .name span {display:block; margin-top:2px; color:#999; font-size:0.7rem;}
.heySomething .swiper-slide-buy .price s {font-size:14px;}
.heySomething .swiper-slide-buy .price strong {font-size:18px;}
.heySomething .swiper-slide-buy .option .btnbuy {margin-top:1.3rem;}

/* 6*/
.swiper-slide-together p {position:absolute;}
.swiper-slide-together .txt01 {top:17.70%; padding:0 30.23%}
.swiper-slide-together .txt02 {top:23.12%; padding:0 25%;}
/* brand */
.heySomething .swiper-slide-brand .logo {position:absolute; top:5.625%; left:50%; width:20.93%; margin-left:-10.465%;}

/* finish */
.swiper-slide-finish p {position:absolute; top:17.18%; padding:0 27.96%;}

/* comment */
.evntTit {margin-top:4.9rem; padding:0 7.73%}
.heySomething .swiper-slide .btngo {top:70%;}
.heySomething .form .inner {padding:0 5%;}
.heySomething .form .choice {margin-top:1.2rem;}
.heySomething .form .choice li {width:22.5%; height:auto !important; margin:0 0.4rem;}
.heySomething .form .choice li.ico1,
.heySomething .form .choice li.ico2,
.heySomething .form .choice li.ico3 {margin-top:0;}
.heySomething .form .choice li.ico4 {margin-right:0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/ico_01_off.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/ico_02_off.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/ico_03_off.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/ico_04_off.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/ico_04_on.png);}
.heySomething .field {margin-top:1.5rem;}
.heySomething .field textarea {height:5.5rem;}
.heySomething .field input {width:5.5rem; height:5.5rem; font-size:0.9rem;}
.heySomething .commentlist ul li {position:relative; min-height:10rem; padding:1.7rem 0 1.7rem 8rem;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:0.1rem; width:6.7rem; height:8.5rem; margin-top:-3.4rem; background-repeat:no-repeat; background-position:50% 0 !important; background-size:100% auto;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/ico_01.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/ico_02.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/ico_03.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/ico_04.png);}
.heySomething .commentlist ul li .mob img {width:0.9rem; margin-top:-0.1rem; margin-left:0.2rem;}
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
		<% If not( left(currenttime,10)>="2016-12-07" and left(currenttime,10)<"2016-12-14" ) Then %>
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
						<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project_white.png" alt="Hey, something project" /></strong>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/img_slide_01_v2.jpg" alt="" />
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>

					<div class="swiper-slide swiper-slide-brand">
						<a href="/street/street_brand.asp?makerid=laundrymat001" class="mWeb"></a>
						<a href="/street/street_brand.asp?makerid=laundrymat001" onclick="fnAPPpopupBrand('laundrymat001'); return false;" class="mApp"></a>
						<p class="brand brand1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/txt_brand_01.png" alt="laundry.mat +" /></p>
						<p class="brand brand2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/txt_brand_02_v2.png" alt="오늘도 똑같은 하루를 시작합니다. 어찌보면 평범하고 지루하기 짝이 없는 날인 것 같아도 그 안에서 우리는 소소한 하루를 보내고 있습니다. 마음 먹은 일이 뜻대로 되지 않을 때 또는 예기치 못한 행운을 발견하였을 때 이렇게 생각해보면 어떨까요? “이게 다 내가 귀여운 탓이다! " /></p>
						<p class="brand brand3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/txt_brand_03_v2.png" alt="여기, 귀여운 당신에게 어울리는 8가지 머플러를 만나보세요"/></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/img_slide_03.jpg" alt="" />
					</div>

					<%' buy %>
					<%
						Dim itemid, oItem
						Set oItem = Nothing
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786869
						Else
							itemid = 1614923
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
						<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1614923&amp;pEtr=74763'); return false;">
						<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1614923&amp;pEtr=74763">
						<% End If %>
							<img class="item01" src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/txt_slide_04.png" alt="laundry.mat+" />
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/img_slide_04.jpg" alt="" />
							<div class="option">
						<% If oItem.FResultCount > 0 then %>
							<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
								<strong class="discountOne"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/icon_one_plus_one.png" alt="" /></strong>
								<span class="name">PETIT KNIT MUFFLER<span>사이즈 8*112 cm / 소재 Wool 30%, Acrylic 70%</span></span>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% Else %>
								<span class="name">PETIT KNIT MUFFLER<span>사이즈 8*112 cm / 소재 Wool 30%, Acrylic 70%</span></span>
								<div class="price priceEnd">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% End If %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
						<% End If %>
							</div>
						</a>
					</div>
					<% Set oItem = Nothing %>

					<div class="swiper-slide swiper-slide-color">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/img_slide_05_v2.jpg" alt="RASPBERRY BEIGE gray green wine blue brown pink" /></p>
					</div>

					<div class="swiper-slide swiper-slide-together">
						<p class="txt01"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/txt_together_01.png" alt="HAPPY TOGETHER" /></p>
						<p class="txt02"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/txt_together_02.png" alt="함께하면 더욱 따뜻해지는 겨울! 1+1으로 친구와 연인과 가족과 함께따스함을 나누세요" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/img_slide_06.jpg" alt="" />
					</div>


					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1614923&pEtr=74763" onclick="fnAPPpopupProduct('1614923&pEtr=74763');return false;" title="# Coffee Time">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/img_slide_07_01.jpg" alt="# Coffee Time 카페에 흐르던 음악, 그때의 커피 향기 소소한 커피타임에 어울리는 BEIGE & BROWN " /></p>
						</a>
					</div>
					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1614923&pEtr=74763" onclick="fnAPPpopupProduct('1614923&pEtr=74763');return false;" title="# Happy Birthday 보러가기">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/img_slide_07_02.jpg" alt="# Happy Birthday 사랑스러운 너를 위해, 이세상 가장 따뜻한 케익을 준비했어! PINK & RASPBERRY" /></p>
						</a>
					</div>
					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1614923&pEtr=74763" onclick="fnAPPpopupProduct('1614923&pEtr=74763');return false;" title="# Gloomay Day 보러가기">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/img_slide_07_03.jpg" alt= "# Gloomay Day 오늘처럼 조금 우울한 날에는 그 우울함마저도 즐기는 건 어떨까요 GRAY & BLUE" /></p>
						</a>
					</div>
					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1614923&pEtr=74763" onclick="fnAPPpopupProduct('1614923&pEtr=74763');return false;" title="# Merry Christmas 보러가기">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/img_slide_07_04.jpg" alt="# Merry Christmas 올해 크리스마스에도 사랑하는 가족, 연인, 친구와 함께 더 따뜻하게! WINE & GREEN" ></p>
						</a>
					</div>

					<div class="swiper-slide swiper-slide-finish">
						<p class="finish"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/txt_slide_08.png" alt="소소한 나의 하루에 따스한 귀여움 더하기 LAUNDRY.MAT +" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/img_slide_08_v2.jpg" alt="" />
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/txt_slide_09_v2.png" alt="Hey, something project 올 한해, 가장 고마웠던 사람은 누구인가요? 정성껏 코멘트를 남겨주신 5분을 추첨하여 PETIT WOOL MUFFLER 제품을 1+1으로 선물 드립니다. (컬러 랜덤)" /></p>
						<a href="#commentevt" class="btngo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_go.gif" alt="응모하러 가기" /></a>
					</div>
				</div>
			</div>
			<div class="pagingNo">
				<p class="page"><strong></strong>/<span></span></p>
			</div>

			<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/btn_nxt.png" alt="다음" /></button>
		</div>

		<%' 구매하기 버튼 %>
		<%'  for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/hey/74763_get.asp %>
		<div class="btnget">
		<% if isApp=1 then %>
			<a href="" onclick="fnAPPpopupProduct('1614923&pEtr=74763');return false;" title="buy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Disney Alice Scratch Book 구매하러 가기" /></a>
		<% Else %>
			<a href="/category/category_itemPrd.asp?itemid=1614923&pEtr=74763" title=""><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a>
		<% End If %>
			</a>
		</div>
	</div>
	<!-- //main contents -->

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
				<legend>올한해 가장 고마웠던 사람 쓰기</legend>
					<p class="evntTit"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/txt_comment.png" alt="올 한해, 가장 고마웠던 사람은 누구인가요? 정성껏 코멘트를 남겨주신 5분을 추첨하여 PETIT WOOL MUFFLER 제품을 1+1으로 선물 드립니다. (컬러 랜덤)" /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/ico_01_off.png" alt="# coffee time" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/ico_02_off.png" alt="# happy birthday" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/ico_03_off.png" alt="# gloomy day" /></button>
							</li>
							<li class="ico4">
								<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74763/m/ico_04_off.png" alt="# MERRY CHRISTMAS" /></button>
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
							# coffee time
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
							# happy birthday
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
							# gloomy day
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>
							# MERRY CHRISTMAS
						<% Else %>
							# coffee time
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
			$(".swiper-slide-active").find(".hey").delay(50).animate({"top":"6.6%", "opacity":"1"},600);

			$(".swiper-slide-brand").find(".brand1").delay(100).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide-brand").find(".brand2").delay(300).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide-brand").find(".brand3").delay(400).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-brand").find(".brand1").delay(50).animate({"margin-top":"0", "opacity":"1"},600);
			$(".swiper-slide-active.swiper-slide-brand").find(".brand2").delay(50).animate({"margin-top":"0", "opacity":"1"},600);
			$(".swiper-slide-active.swiper-slide-brand").find(".brand3").delay(50).animate({"margin-top":"0", "opacity":"1"},600);

			$(".swiper-slide-together").find(".txt01").delay(100).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide-together").find(".txt02").delay(300).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-together").find(".txt01").delay(50).animate({"margin-top":"0", "opacity":"1"},600);
			$(".swiper-slide-active.swiper-slide-together").find(".txt02").delay(50).animate({"margin-top":"0", "opacity":"1"},600);

			$(".swiper-slide-buy").find(".animation .opacity").removeClass("twinkle");
			$(".swiper-slide-active.swiper-slide-buy").find(".animation .opacity").addClass("twinkle");

			$(".swiper-slide-finish").find("p").delay(100).animate({"margin-top":"3%", "opacity":"0"},100);
			$(".swiper-slide-active.swiper-slide-finish").find("p").delay(50).animate({"margin-top":"0", "opacity":"1"},600);
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