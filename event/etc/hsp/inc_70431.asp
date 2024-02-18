<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 18 MA
' History : 2016-01-19 유태욱 생성
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
	eCode   =  66118
Else
	eCode   =  70431
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

dim itemid, itemid1,itemid2
IF application("Svr_Info") = "Dev" THEN
	itemid1   =  1239115
	itemid2   =  1239227
Else
	itemid1   =  1480689
	itemid2   =  1480688
End If

dim oItem
'set oItem = new CatePrdCls
'	oItem.GetItemData itemid
%>
<style type="text/css">
 .heySomething {-webkit-text-size-adjust:none;}
.finishEvt {display:none;}

.heySomething .app {display:none;}

/* title */
.heySomething .swiper-slide .hey {position:absolute; top:6.5%; left:0; width:100%;}

/* buy */
.heySomething .swiper-slide-buy a {display:block;}
.heySomething .swiper-slide-buy .option {position:absolute; top:0; left:0; width:100%; height:100%; padding-top:85%; text-align:center;}
.heySomething .swiper-slide-buy .option div.priceEnd {margin-top:1rem;}
.heySomething .swiper-slide-buy .gift {margin-top:0.5rem; color:#fbb21b; font-weight:bold;}
.heySomething .swiper-slide-buy .gift span {display:inline-block; padding:0.1rem 0.4rem; background-color:#ffba2a; color:#fff; font-family:arial, tahoma, sans-serif;}

/* story */
.heySomething .swiper-slide .desc {position:absolute; bottom:11%; width:100%;}

/* comment */
.heySomething .form .choice {padding:3% 4% 0 0;}
.heySomething .form .choice li {width:33%; height:auto !important; margin:0; padding:0 1.5% 0;}
.heySomething .form .choice li:last-child {padding-right:0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_01_off.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_02_off.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_03_off.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_04_off.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_04_on.png);}
.heySomething .form .choice li.ico5 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_05_off.png);}
.heySomething .form .choice li.ico5 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_05_on.png);}
.heySomething .form .choice li.ico6 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_06_off.png);}
.heySomething .form .choice li.ico6 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_06_on.png);}

.heySomething .commentlist ul li {position:relative; min-height:7rem; }
.heySomething .commentlist ul li strong {position:absolute; top:50%;  width:6.8rem; height:6.8rem; margin-top:-3.4rem; background-repeat:no-repeat; background-position:50% 0 !important; background-size:6.8rem auto;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_01_off.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_02_off.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_03_off.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_04_off.png);}
.heySomething .commentlist ul li .ico5 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_05_off.png);}
.heySomething .commentlist ul li .ico6 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_06_off.png);}
.heySomething .commentlist ul li .letterWrap {position:relative; padding:1rem; background-color:#ffeb00; border-radius:0.2rem; -webkit-border-radius:0.2rem;}
.heySomething .commentlist ul li .letterWrap:after {display:block; position:absolute; top:0.5rem; width:0.5rem; height:0.55rem; content:''; background-position:0 0; background-repeat:no-repeat;}

.heySomething .commentlist ul li:nth-child(2n+1) {padding:0.8rem 0.25rem 0.8rem 7.5rem;}
.heySomething .commentlist ul li:nth-child(2n+1) strong {left:0;}
.heySomething .commentlist ul li:nth-child(2n+1) .letterWrap:after {left:-0.5rem; background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/pointer_lt.png); background-size:100% auto;}
.heySomething .commentlist ul li:nth-child(2n) {padding:0.8rem 7.5rem 0.8rem 0.25rem;}
.heySomething .commentlist ul li:nth-child(2n) strong {left:auto; right:0;}
.heySomething .commentlist ul li:nth-child(2n) .letterWrap:after {right:-0.5rem; background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/pointer_rt.png); background-size:100% auto;}
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
		<% If not( left(currenttime,10)>="2016-05-03" and left(currenttime,10)<"2016-05-19" ) Then %>
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

<%'' [Hey, something project_28] 디즈니 크림글라스 / 이벤트 코드 70431 %>
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

	<% '' main contents  %>
	<div class="section article" id="toparticle">
		<%'' swiper %>
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/img_slide_01.jpg" alt="" />
						<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project.png" alt="Hey, something project" /></strong>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>

					<%'' buy %>
					<div class="swiper-slide swiper-slide-buy">
					<%
					itemid = itemid1
					set oItem = new CatePrdCls
						oItem.GetItemData itemid
					%>
						<% ' for dev msg : 상품 링크 %>
						<% if isApp=1 then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1480689&amp;pEtr=70431'); return false;">
						<% else %>
							<a href="/category/category_itemPrd.asp?itemid=1480689&amp;pEtr=70431" target="_blank">
						<% end if %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/img_slide_03.png" alt="" />
							<div class="option">
								<!--strong class="discount" style="background-color:#24965f;">단, 일주일만 ONLY 10%</strong-->
								<em class="name">삭스어필 x 카카오프렌즈<span>Fake socks edition</span></em>
								<% if oItem.FResultCount > 0 then %>
									<% if oItem.Prd.isCouponItem then %>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong style="color:#24965f;"><%= FormatNumber(oItem.Prd.GetCouponAssignPrice,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
											<p class="gift"><span>GIFT</span> 3개 구매 시, 1개 랜덤 증정</p>
										</div>
									<% else %>
										<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
											<div class="price">
												<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
												<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												<p class="gift"><span>GIFT</span> 3개 구매 시, 1개 랜덤 증정</p>
											</div>
										<% else %>
											<div class="priceEnd">
												<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												<p class="gift"><span>GIFT</span> 3개 구매 시, 1개 랜덤 증정</p>
											</div>
										<% end if %>
									<% end if %>
								<% end if %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
							</div>
						</a>
					<% set oItem=nothing %>
					</div>

					<div class="swiper-slide swiper-slide-buy">
					<%
					itemid = itemid2
					set oItem = new CatePrdCls
						oItem.GetItemData itemid
					%>
						<%'' for dev msg : 상품 링크 %>
						<% if isApp=1 then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1480688&amp;pEtr=70431'); return false;">
						<% else %>
							<a href="/category/category_itemPrd.asp?itemid=1480688&amp;pEtr=70431" target="_blank">
						<% end if %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/img_slide_04.png" alt="" />
							<div class="option">
								<!--strong class="discount">단, 일주일만 ONLY 33%</strong-->
								<em class="name">삭스어필 x 카카오프렌즈<span>Long socks edition</span></em>
								<% if oItem.FResultCount > 0 then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% else %>
										<div class="priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% end if %>
								<% end if %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
							</div>
						</a>
					<% set oItem=nothing %>
					</div>

					<div class="swiper-slide swiper-slide-brand">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/img_slide_05.png" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-brand">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/img_slide_06.png" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-story">
						<p class="desc desc1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/txt_desc_01.png" alt="" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/img_slide_07.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-story">
						<p class="desc desc2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/txt_desc_02.png" alt="" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/img_slide_08.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-story">
						<p class="desc desc3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/txt_desc_03.png" alt="" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/img_slide_09.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-story">
						<p class="desc desc4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/txt_desc_04.png" alt="" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/img_slide_10.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-story">
						<p class="desc desc5"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/txt_desc_05.png" alt="" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/img_slide_11.jpg" alt="" />
					</div>

					<div class="swiper-slide swiper-slide-story">
						<p class="desc desc6"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/txt_desc_06.png" alt="" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/img_slide_12.jpg" alt="" />
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/img_slide_13.jpg" alt="" /></p>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/img_slide_14.jpg" alt="" /></p>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/img_slide_15.png" alt="SOCKS APPEAL X KAKAO FRIENDS 상품 중 가장 탐나는 상품은 무엇인가요? 코멘트를 남겨주신 3분을 추첨하여, 해당 컬렉션의 상품을 드립니다. (랜덤 발송) 코멘트 작성기간은 2016년 5월 3일부터 5월 10일까지며, 발표는 5월 16일 입니다." /></p>
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

		<%'' 구매하기 버튼 %>
		<!--  for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/hey/70431_get.asp -->
		<div class="btnget">
			<% if isApp=1 then %>
				<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_70431_item.asp?isApp=<%= isApp %>'); return false;">
			<% Else %>
				<a href="/event/etc/hsp/inc_70431_item.asp?isApp=<%= isApp %>" target="_blank">
			<% End If %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="Buy" />
			</a>
		</div>
	</div>
	<%'' //main contents %>

	<%'' comment event %>
	<div id="commentevt" class="section commentevt">
		<%'' for dev msg : form %>
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
				<legend>SOCKS APPEAL X KAKAO FRIENDS 코멘트 쓰기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/txt_comment.png" alt="SOCKS APPEAL X KAKAO FRIENDS 상품 중 가장 탐나는 상품은 무엇인가요? 코멘트를 남겨주신 3분을 추첨하여, 해당 컬렉션의 상품을 드립니다. (랜덤 발송) 코멘트 작성기간은 2016년 5월 4일부터 5월 10일까지며, 발표는 5월 16일 입니다." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_01_off.png" alt="MUJI&CON" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_02_off.png" alt="FRODO" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_03_off.png" alt="NEO" /></button>
							</li>
							<li class="ico4">
								<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_04_off.png" alt="JAY-G" /></button>
							</li>
							<li class="ico5">
								<button type="button" value="5"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_05_off.png" alt="APEACH" /></button>
							</li>
							<li class="ico6">
								<button type="button" value="6"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/ico_06_off.png" alt="TUBE" /></button>
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

		<%'' for dev msg : comment list %>
		<div class="commentlist">
			<p class="total">total <%= iCTotCnt %></p>
			<% IF isArray(arrCList) THEN %>
			<ul>
				<% For intCLoop = 0 To UBound(arrCList,2) %>
				<li>
					<% if isarray(split(arrCList(1,intCLoop),"!@#")) then %>
						<strong class="ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>">
							<% if split(arrCList(1,intCLoop),"!@#")(0)="1" then %>
								MUJI&CON
							<% elseif split(arrCList(1,intCLoop),"!@#")(0)="2" then %>
								FRODO
							<% elseif split(arrCList(1,intCLoop),"!@#")(0)="3" then %>
								NEO
							<% elseif split(arrCList(1,intCLoop),"!@#")(0)="4" then %>
								JAY-G
							<% elseif split(arrCList(1,intCLoop),"!@#")(0)="5" then %>
								APEACH
							<% elseif split(arrCList(1,intCLoop),"!@#")(0)="6" then %>
								TUBE
							<% else %>
								MUJI&CON
							<% end if %>								
						</strong>
					<% end if %>					
					<div class="letterWrap">
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
						<% If arrCList(8,i) <> "W" Then %>
							 <span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성"></span></div>
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
	<%'' //comment event %>

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

			$(".swiper-slide.swiper-slide-detail").find(".detail").delay(100).animate({"width":"70%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-detail").find(".detail").delay(300).animate({"width":"74.375%", "opacity":"1"},500);

			$(".swiper-slide.swiper-slide-story").find(".desc").delay(100).animate({"margin-top":"5%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-story").find(".desc").delay(50).animate({"margin-bottom":"0", "opacity":"1"},600);

			$(".swiper-slide.swiper-slide-brand").find(".logo").delay(100).animate({"margin-top":"-5%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-brand").find(".logo").delay(50).animate({"margin-top":"0", "opacity":"1"},600);
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