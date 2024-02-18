<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈
' History : 2017-06-27 원승현 생성
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
	eCode   =  66372
Else
	eCode   =  78730
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
/* title */
.heySomething .swiper-slide .hey {position:absolute; top:6.6%; left:0; width:100%;}

/* buy */
.heySomething .swiper-slide-buy {-webkit-text-size-adjust:none;}
.heySomething .swiper-slide-buy .option {text-align:center;}
.heySomething .option .price {margin-top:0; margin-bottom:2rem;}
.heySomething .option .price strong {padding-top:0.3rem; font-size:1.6rem; line-height:1;}

/* story */
.heySomething .swiper-slide-desc {background-color:#f6f6f6;}
.heySomething .swiper-slide-desc p {position:absolute; left:0; bottom:0; width:100%;}

/* comment */
.heySomething .swiper-slide .btngo {top:70%;}
.heySomething .form .inner {padding:0 6.5%;}
.heySomething .field {margin-top:1rem;}
.heySomething .form .choice li {width:6.1rem; height:auto !important; margin-right:2%;}
.heySomething .form .choice li:last-child {margin-right:0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/ico_01_off.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/ico_02_off.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/ico_03_off.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/ico_04_off.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/ico_04_on.png);}

.heySomething .commentlist ul li {position:relative; min-height:7.1rem; padding:1.6rem  0 1.6rem 7.7rem;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:0; width:6.15rem; height:6.15rem; margin-top:-3.1rem; background-repeat:no-repeat; background-position:50% 0 !important; background-size:100% auto;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/ico_01.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/ico_02.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/ico_03.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/ico_04.png);}
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
		<% If not( left(currenttime,10)>="2017-06-27" and left(currenttime,10)<"2017-07-20" ) Then %>
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
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/img_main.jpg" alt="" /></div>
						</div>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
						</div>
						<div class="swiper-slide">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/img_slide_03.jpg" alt="“당신이 사랑하는, 당신의 소중한 반려견과 늘 함께하세요.” 조금 느리지만 따뜻한 손길로 추억을 만드는 소소한 쌀이공방 반려동물의 사진을 이용하여 모색, 표정까지 꼭 닮은 핸드메이드 니들펠트 키링을 텐바이텐에서 만나보세요." /></div>
						</div>

						<%' buy %>
						<%' 상품코드 1737147 // 할인전후 가격 동일 %>
						<div class="swiper-slide swiper-slide-buy">
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1737147&amp;pEtr=78730'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1737147&amp;pEtr=78730">
							<% End If %>
								<div class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/img_item_1.jpg" alt="ONLY 10X10 [한정] 반려견 시그니처키링" /></div>
								<div class="option">
									<div class="price">
										<%
											Dim itemid, oItem
											IF application("Svr_Info") = "Dev" THEN
												itemid = 786868
											Else
												itemid = 1737147
											End If
											set oItem = new CatePrdCls
												oItem.GetItemData itemid
										%>
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										<% Set oItem = Nothing %>
									</div>
									<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
								</div>
							</a>
						</div>

						<%' 상품코드 1737148 // 할인전후 가격 동일 %>
						<div class="swiper-slide swiper-slide-buy">
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1737148&amp;pEtr=78730'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1737148&amp;pEtr=78730">
							<% End If %>
								<div class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/img_item_2.jpg" alt="ONLY 10X10 시그니처 키링" /></div>
								<div class="option">
									<div class="price">
										<%
											IF application("Svr_Info") = "Dev" THEN
												itemid = 786868
											Else
												itemid = 1737148
											End If
											set oItem = new CatePrdCls
												oItem.GetItemData itemid
										%>
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										<% Set oItem = Nothing %>
									</div>
									<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
								</div>
							</a>
						</div>

						<div class="swiper-slide">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/img_slide_06.jpg" alt="" /></div>
						</div>

						<%' story %>
						<%' 상품코드 1737147 %>
						<div class="swiper-slide swiper-slide-desc">
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1737147&amp;pEtr=78730'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1737147&amp;pEtr=78730">
							<% End If %>
								<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/img_slide_story_1.jpg" alt="" /></div>
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/txt_slide_story_1.jpg" alt="# 차량고리 항상 지니고 다니는 차 키 또는 열쇠고리로 이용해보세요. 늘 함께하는 기분일 거예요." /></p>
							</a>
						</div>
						<div class="swiper-slide swiper-slide-desc">
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1737147&amp;pEtr=78730'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1737147&amp;pEtr=78730">
							<% End If %>
								<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/img_slide_story_2.jpg" alt="" /></div>
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/txt_slide_story_2.jpg" alt="# 가방고리 우리는 지역 사회를 지원하고 전통 공예를 보전하는 것을 목표로 합니다. 미니미가 요기있네! 반려동물을 꼭 닮은 키링과 함께 외출하세요." /></p>
							</a>
						</div>
						<div class="swiper-slide swiper-slide-desc">
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1737147&amp;pEtr=78730'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1737147&amp;pEtr=78730">
							<% End If %>
								<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/img_slide_story_3.jpg" alt="" /></div>
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/txt_slide_story_3.jpg" alt="# 핸드폰고리 자꾸 뒤를 돌아보게 만드는 귀여움! 키링 하나로 세상에 단 하나뿐인 케이스가 돼요." /></p>
							</a>
						</div>
						<div class="swiper-slide swiper-slide-desc">
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1737147&amp;pEtr=78730'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1737147&amp;pEtr=78730">
							<% End If %>
								<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/img_slide_story_4.jpg" alt="" /></div>
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/txt_slide_story_4.jpg" alt="# 하네스장식 평범한 하네스도 특별하게 변신! 외출시간이 더 즐거워 지겠죠?" /></p>
							</a>
						</div>

						<%' finish %>
						<div class="swiper-slide">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/img_slide_11.jpg" alt="반려동물과 함께하는 행복한 일상을 만들어보세요." /></div>
						</div>

						<%' comment Evt %>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/img_slide_event.jpg" alt="Hey, something project 당신이 갖고 싶은 것 쌀이공방 키링을 사용하고 싶은 곳과 이유를 남겨주세요! 정성스러운 댓글을 남겨주신 5분께 텐바이텐 상품권 1만원 권을 선물로 드립니다." /></p>
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
			<%'  for dev msg : 구매하기 버튼 클릭시 상품으로 이동 %>
			<% if isApp=1 then %>
				<div class="btnget"><a href="" onclick="fnAPPpopupProduct('1737147&pEtr=78730'); return false;" title="구매하러 가기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a></div>
			<% Else %>
				<div class="btnget"><a href="/category/category_itemPrd.asp?itemid=1737147&pEtr=78730" title="구매하러 가기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" /></a></div>
			<% End If %>
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
						<p class="evntTit"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/txt_comment.png" alt="Hey, something project 당신이 갖고 싶은 것 쌀이공방 키링을 사용하고 싶은 곳과 이유를 남겨주세요! 정성스러운 댓글을 남겨주신 5분께 텐바이텐 상품권 1만원 권을 선물로 드립니다. 이벤트 기간은 2017년 06월 28일 부터 07월19일 발표일은 07월 21일 입니다." /></p>
						<div class="inner">
							<ul class="choice">
								<li class="ico1">
									<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/ico_01_off.png" alt="# 차량고리" /></button>
								</li>
								<li class="ico2">
									<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/ico_02_off.png" alt="# 가방고리" /></button>
								</li>
								<li class="ico3">
									<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/ico_03_off.png" alt="# 핸드폰고리" /></button>
								</li>
								<li class="ico4">
									<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78730/m/ico_04_off.png" alt="# 하네스장식" /></button>
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
								# 차량고리
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
								# 가방고리
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
								# 핸드폰고리
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>
								# 하네스장식
							<% Else %>
								# 차량고리
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
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->