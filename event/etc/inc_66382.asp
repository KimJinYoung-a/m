<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 4
' History : 2015.09.25 한용민 생성
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
	'currenttime = #09/30/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  64898
Else
	eCode   =  66382
End If

dim userid, i
	userid = GetEncLoginUserID()

dim commentcount
commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim itemid
IF application("Svr_Info") = "Dev" THEN
	itemid   =  1239115
Else
	itemid   =  1358365
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

.item {overflow:hidden; position:absolute; top:14%; left:50%; z-index:100; width:100%; margin-left:-50%;}
.item a {overflow:hidden; display:block; position:relative; height:0; margin:0 5%; padding-bottom:80.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.item a span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter: alpha(opacity=0); cursor:pointer;}

/* buy */
.swiper-slide-buy .option {position:absolute; top:20%; left:0; width:100%; text-align:center;}
.swiper-slide-buy .option a {display:block; padding-top:56%;}

/* brand */
.heySomething .swiper-slide-brand .brand {position:absolute; top:4%; left:0; width:100%;}
.heySomething .swiper-slide-brand .brand p {margin-top:5%;}

.heySomething .form .choice li {width:61px; height:61px; margin:5px 10px 0 4px;}
.heySomething .form .choice li button {width:61px; height:61px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/66382/m/bg_ico.png); background-size:366px auto;}
.heySomething .form .choice li.ico1 button.on {background-position:0 100%;}
.heySomething .form .choice li.ico2 button {background-position:-61px 0;}
.heySomething .form .choice li.ico2 button.on {background-position:-61px 100%;}
.heySomething .form .choice li.ico3 button {background-position:-122px 0;}
.heySomething .form .choice li.ico3 button.on {background-position:-122px 100%;}
.heySomething .form .choice li.ico4 {clear:left;}
.heySomething .form .choice li.ico4 button {background-position:-183px 0;}
.heySomething .form .choice li.ico4 button.on {background-position:-183px 100%;}
.heySomething .form .choice li.ico5 button {background-position:-244px 0;}
.heySomething .form .choice li.ico5 button.on {background-position:-244px 100%;}
.heySomething .form .choice li.ico6 button {background-position:100% 0;}
.heySomething .form .choice li.ico6 button.on {background-position:100% 100%;}

.heySomething .commentlist ul li {min-height:91px; padding:15px 0 15px 78px;}
.heySomething .commentlist ul li strong {width:61px; height:61px; margin-top:-29px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/66382/m/bg_ico.png) no-repeat 0 0;background-size:366px auto;}
.heySomething .commentlist ul li .ico2 {background-position:-61px 0;}
.heySomething .commentlist ul li .ico3 {background-position:-122px 0;}
.heySomething .commentlist ul li .ico4 {background-position:-183px 0;}
.heySomething .commentlist ul li .ico5 {background-position:-244px 0;}
.heySomething .commentlist ul li .ico6 {background-position:100% 0;}

@media all and (min-width:480px){
	.heySomething .form .choice li {width:91px; height:91px; margin:7px 15px 0 7px;}
	.heySomething .form .choice li button {width:91px; height:91px; background-size:546px auto;}
	.heySomething .form .choice li.ico2 button {background-position:-91px 0;}
	.heySomething .form .choice li.ico2 button.on {background-position:-91px 100%;}
	.heySomething .form .choice li.ico3 button {background-position:-182px 0;}
	.heySomething .form .choice li.ico3 button.on {background-position:-182px 100%;}
	.heySomething .form .choice li.ico4 button {background-position:-273px 0;}
	.heySomething .form .choice li.ico4 button.on {background-position:-273px 100%;}
	.heySomething .form .choice li.ico5 button {background-position:-364px 0;}
	.heySomething .form .choice li.ico5 button.on {background-position:-364px 100%;}
	.heySomething .form .choice li.ico6 button {background-position:100% 0;}
	.heySomething .form .choice li.ico6 button.on {background-position:100% 100%;}

	.heySomething .commentlist ul li {min-height:135px; padding:22px 0 22px 135px;}
	.heySomething .commentlist ul li strong {width:91px; height:91px; margin-top:-45px; background-size:546px auto;}
	.heySomething .commentlist ul li .ico2 {background-position:-91px 0;}
	.heySomething .commentlist ul li .ico3 {background-position:-182px 0;}
	.heySomething .commentlist ul li .ico4 {background-position:-273px 0;}
	.heySomething .commentlist ul li .ico5 {background-position:-364px 0;}
	.heySomething .commentlist ul li .ico6 {background-position:100% 0;}
}

@media all and (min-width:768px){
	.heySomething .form .choice li {width:122px; height:122px; margin:15px 30px 0 15px;}
	.heySomething .form .choice li button {width:122px; height:122px; background-size:732px auto;}
	.heySomething .form .choice li.ico2 button {background-position:-122px 0;}
	.heySomething .form .choice li.ico2 button.on {background-position:-122px 100%;}
	.heySomething .form .choice li.ico3 button {background-position:-244px 0;}
	.heySomething .form .choice li.ico3 button.on {background-position:-244px 100%;}
	.heySomething .form .choice li.ico4 {clear:none;}
	.heySomething .form .choice li.ico4 button {background-position:-366px 0;}
	.heySomething .form .choice li.ico4 button.on {background-position:-366px 100%;}
	.heySomething .form .choice li.ico5 button {background-position:-488px 0;}
	.heySomething .form .choice li.ico5 button.on {background-position:-488px 100%;}
	.heySomething .form .choice li.ico6 button {background-position:100% 0;}
	.heySomething .form .choice li.ico6 button.on {background-position:100% 100%;}

	.heySomething .commentlist ul li {min-height:166px; padding:22px 0 22px 135px;}
	.heySomething .commentlist ul li strong {width:122px; height:122px; margin-top:-58px; background-size:732px auto;}
	.heySomething .commentlist ul li .ico2 {background-position:-122px 0;}
	.heySomething .commentlist ul li .ico3 {background-position:-244px 0;}
	.heySomething .commentlist ul li .ico4 {background-position:-366px 0;}
	.heySomething .commentlist ul li .ico5 {background-position:-488px 0;}
	.heySomething .commentlist ul li .ico6 {background-position:100% 0;}
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
	window.$('html,body').animate({scrollTop:$(".mEvt66049").offset().top}, 0);
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
		<% If not( left(currenttime,10)>="2015-09-30" and left(currenttime,10)<"2015-10-07" ) Then %>
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
	<!-- main contents -->
	<div class="section article">
		<!-- swiper -->
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66382/m/img_slide_01.jpg" alt="Hey, something project" /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66382/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>

					<!-- for dev msg : 9/30~10/00까지 할인 -->
					<div class="swiper-slide swiper-slide-buy">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/66382/m/img_slide_03.jpg" alt="" />
						<div class="option">
							<% if isApp then %>
								<a href="" onclick="fnAPPpopupProduct('1358365'); return false;">
							<% else %>
								<a href="/category/category_itemPrd.asp?itemid=1358365">
							<% end if %>
								<%
								'<!--img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/img_animation.gif" alt="" /-->
								'<!-- for dev msg : 9/9~9/16까지 할인 / 종료 후 <strong class="discount">....</strong>숨겨 주시고 
								'<div class="price">...</div>에는 클래스 priceEnd을 붙이고 <s>....<s>숨겨주세요 -->
								%>
								<% if oItem.FResultCount > 0 then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<% If oItem.Prd.FOrgprice = 0 Then %>
										<% else %>
											<strong class="discount">텐바이텐에서만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
										<% end if %>

										<em class="name">Half Pint <span>WARM SAND</span></em>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% else %>
										<em class="name">Half Pint <span>WARM SAND</span></em>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% end if %>
								<% end if %>

								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/btn_buy.png" alt="구매하러 가기" /></div>
							</a>
						</div>
					</div>

					<div class="swiper-slide siwper-slide-item">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/66382/m/img_slide_04.jpg" alt="새롭게 내딛는 당신의 걸음에 세심한 배려를 더합니다. 이 심플한 슈즈에 어떠한 특별한 감성이 담겨 있는지 확인하세요." />
						<% '<!-- for dev msg : 상품 링크 --> %>
						<div class="item">
							<% if isApp then %>
								<a href="" onclick="fnAPPpopupProduct('1358365'); return false;">
							<% else %>
								<a href="/category/category_itemPrd.asp?itemid=1358365">
							<% end if %>

							<span>브릿-스티치</span></a>
						</div>
					</div>

					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/66382/m/img_slide_05.jpg" alt="SIZE INFO 가방 20 x 6.5 x 17cm 스트랩 53~70cm 어깨부터 내려오는 길이" />
					</div>
					<div class="swiper-slide swiper-slide-brand">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/66382/m/img_slide_06.jpg" alt="" />
						<div class="brand">
							<p class="letter1"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66382/m/txt_plan_01.png" alt="When we say our bags have vintage heritage, we really mean it. By. Brit-Stitch" /></p>
							<p class="letter2"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66382/m/txt_plan_02.png" alt="영국의 마스터 장인이었던 피터 존스는 1967년 그가 살던 지역의 우유 배달부 토비의 수금가방을 제작해줍니다." /></p>
							<p class="letter3"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66382/m/txt_plan_04.png" alt="약 45년이 흐른 뒤 토비는 스트랩 교체를 위해 공방을 찾아옵니다. " /></p>
							<p class="letter4"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66382/m/txt_plan_03.png" alt="약 45년이 흐른 뒤 토비는 스트랩 교체를 위해 공방을 찾아옵니다. 시간의 흔적을 그대로 담은 토비의 가방을 보고 감동을 느낀 직원들은 이를 현재적 감각으로 재해석하여 클래식모던 스타일의 가방을 디자인하기에 이르렀으며 이로써 브릿-스티치가 탄생하게 됩니다." /></p>
						</div>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66382/m/img_slide_07.jpg" alt="5년의 역사를 고스란히 간직한 토비의 가방을 보며 브릿-스티치는 매일 그 때의 감동을 기억합니다." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66382/m/img_slide_08.jpg" alt="사용하면 할수록 더더욱 유용한 가방. 작지만 당신에게 꼭 필요한 것들은 거기에 있을 거에요." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66382/m/img_slide_09.jpg" alt="모든 재료 공수와 공정은 영국 현지에서 이루어집니다. MADE IN BRITAIN의 자존심은 한 번도 변한 적이 없습니다." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66382/m/img_slide_10.jpg" alt="과거로부터 배우고 성장합니다. 브릿-스티치를 위한 작은 의견도 놓치지 않습니다." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66382/m/img_slide_11.jpg" alt="브릿-스티치는 고급 프리미엄 소가죽으로 제작됩니다. 세월의 흔적은 가죽에 고스란히 입혀집니다." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66382/m/img_slide_12.jpg" alt="다양한 컬러는 브릿-스티치에게 놀이와 같습니다. 색채가 주는 즐거움은 일상의 활력이 되기도 합니다." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66382/m/img_slide_13.jpg" alt="작은 가방 속에 담긴 수 많은 이야기 브릿-스티치" /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66382/m/img_slide_14.png" alt="정성껏 코멘트를 남겨주신 3분을 추첨하여 브릿-스티치의 Half Pint를 선물로 드립니다. 컬러는 랜덤으로 배송됩니다. 기간은 2015년 9월 30일부터 10월 7일까지며, 발표는 10월 12일 입니다." /></p>

						<a href="#commentevt" class="btngo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/btn_go_v1.gif" alt="응모하러 가기" /></a>
					</div>
				</div>
			</div>
			<div class="pagingNo">
				<p class="page"><strong></strong>/<span></span></p>
			</div>

			<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/btn_next.png" alt="다음" /></button>
		</div>
		
		<!-- 구매하기 버튼 -->
		<% '<!--  for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/66233_get.asp --> %>
		<div class="btnget">
			<% if isApp then %>
				<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/inc_66382_item.asp?isApp=<%= isApp %>'); return false;" >
			<% else %>
				<a href="/event/etc/inc_66382_item.asp?isApp=<%= isApp %>" target="_blank">
			<% end if %>

			<img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/btn_get.png" alt="BUY" /></a>
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
				<legend>갖고 싶은 활용도 선택하고 코멘트 쓰기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66382/m/txt_comment.png" alt="정성껏 코멘트를 남겨주신 3분을 추첨하여 브릿-스티치의 Half Pint를 선물로 드립니다. 컬러는 랜덤으로 배송됩니다. 기간은 2015년 9월 30일부터 10월 7일까지며, 발표는 10월 12일 입니다." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1"><button type="button" value="1">Remember</button></li>
							<li class="ico2"><button type="button" value="2">More</button></li>
							<li class="ico3"><button type="button" value="3">Stay</button></li>
							<li class="ico4"><button type="button" value="4">Learn</button></li>
							<li class="ico5"><button type="button" value="5">Share</button></li>
							<li class="ico6"><button type="button" value="6">Play</button></li>
						</ul>
						<div class="field">
							<textarea name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="" cols="60" rows="5"></textarea>
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
		<div class="commentlist" id="commentlist">
			<div class="total">total <%= iCTotCnt %></div>

			<% IF isArray(arrCList) THEN %>
				<ul>
					<% For intCLoop = 0 To UBound(arrCList,2) %>
					<li>
						<% if isarray(split(arrCList(1,intCLoop),"!@#")) then %>
							<strong class="ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>">
								<% if split(arrCList(1,intCLoop),"!@#")(0)="1" then %>
									Remember
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="2" then %>
									More
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="3" then %>
									Stay
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="4" then %>
									Learn
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="5" then %>
									Share
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="6" then %>
									Play
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
	<!-- //comment event -->

	<div id="dimmed"></div>
</div>


<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:false,
		paginationClickable:true,
		speed:1000,
		autoplay:false,
		nextButton:'.btn-next',
		prevButton:'.btn-prev',
		onSlideChangeStart: function (mySwiper) {
			var vActIdx = parseInt(mySwiper.activeIndex);
			if (vActIdx<=0) {
				vActIdx = mySwiper.slides.length-2;
			} else if(vActIdx>(mySwiper.slides.length-2)) {
				vActIdx = 1;
			}
			$(".pagingNo .page strong").text(vActIdx);
			$(".swiper-slide").find(".brand .letter1").delay(100).animate({"margin-top":"6%", "opacity":"0"},300);
			$(".swiper-slide").find(".brand .letter2").delay(200).animate({"margin-top":"6%", "opacity":"0"},300);
			$(".swiper-slide").find(".brand .letter3").delay(300).animate({"margin-top":"6%", "opacity":"0"},300);
			$(".swiper-slide").find(".brand .letter4").delay(400).animate({"margin-top":"6%", "opacity":"0"},300);
			$(".swiper-slide-active").find(".brand .letter1").delay(50).animate({"margin-top":"5%", "opacity":"1"},500);
			$(".swiper-slide-active").find(".brand .letter2").delay(50).animate({"margin-top":"5%", "opacity":"1"},500);
			$(".swiper-slide-active").find(".brand .letter3").delay(50).animate({"margin-top":"5%", "opacity":"1"},500);
			$(".swiper-slide-active").find(".brand .letter4").delay(50).animate({"margin-top":"5%", "opacity":"1"},500);
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

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper.reInit();
				clearInterval(oTm);
			}, 500);
	});

	/* navigator */
	$(".heySomething .menu").click(function(){
		$("#navigator").show();
		$("#dimmed").show();
		return false;
	});
	$("#navigator .btnclose, #dimmed").click(function(){
		$("#navigator").hide();
		$("#dimmed").fadeOut();
	});

	$(".btngo").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},800);
	});

	$(".form .choice li:first-child button").addClass("on");
	frmcom.gubunval.value = '1';

	$(".form .choice li button").click(function(){
		//alert( $(this).val() );
		frmcom.gubunval.value = $(this).val()
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