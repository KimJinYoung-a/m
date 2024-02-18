<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈
' History : 2016-10-04 김진영 생성
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
	eCode   =  66210
Else
	eCode   =  73444
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
.heySomething .swiper-slide .hey {position:absolute; top:6.5%; left:0; width:100%;}

/* buy */
.heySomething .swiper-slide-buy {background-color:#fdfdfd;}
.heySomething .swiper-slide-buy a {display:block;}
.heySomething .swiper-slide-buy .option {text-align:center;}
.heySomething .swiper-slide-buy .option .name span {margin-top:4px; color:#333; font-size:12px; font-weight:bold;}
@media all and (min-width:480px){
	.heySomething .swiper-slide-buy .name span {margin-top:7px; font-size:15px;}
}

/* shake */
.swiper-slide-shake p {position:absolute; top:12.6%; left:50%; width:31.1%; margin-left:-15.55%;}

/* instagram */
.swiper-slide-instagram ul {margin:6% -0.1% 0;}
.swiper-slide-instagram ul li {float:left; width:33.333%; padding:0.4% 0.2% 0;}

/* finish */
.swiper-slide-finish p {position:absolute; top:16.56%; left:50%; width:42.18%; margin-left:-21.09%;}

/* comment */
.heySomething .swiper-slide .btngo {top:70%;}

.heySomething .form .inner {padding:0 5%;}
.heySomething .form .choice {padding:3% 0 0 3%;}
.heySomething .form .choice li {width:25%; height:auto !important; margin:0; padding:0 4.2% 0 0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/ico_01_off.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/ico_02_off.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/ico_03_off.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/ico_04_off.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/ico_04_on.png);}

.heySomething .field {margin-top:8%;}

.heySomething .commentlist ul li {position:relative; min-height:9rem; padding:1.5rem 0 1.5rem 7.75rem;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:0.1rem; width:5.6rem; height:7rem; margin-top:-3.5rem; background-repeat:no-repeat; background-position:50% 0 !important; background-size:100% auto;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/ico_01_off.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/ico_02_off.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/ico_03_off.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/ico_04_off.png);}

/* css3 animation */
.shake {animation-name:shake; animation-duration:3s; animation-fill-mode:both; animation-iteration-count:2;}
.shake {-webkit-animation-name:shake; -webkit-animation-duration:3s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:2;}

@keyframes shake {
	0%, 100% {transform:translateX(0);}
	10%, 30%, 50%, 70%, 90% {transform:translateX(-10px);}
	20%, 40%, 60%, 80% {transform:translateX(10px);}
}
@-webkit-keyframes shake {
	0%, 100% {-webkit-transform:translateX(0);}
	10%, 30%, 50%, 70%, 90% {-webkit-transform:translateX(-10px);}
	20%, 40%, 60%, 80% {-webkit-transform:translateX(10px);}
}

.flip {animation-name:flip; animation-duration:2s; animation-iteration-count:1; backface-visibility:visible;}
.flip {-webkit-animation-name:flip; -webkit-animation-duration:2s; -webkit-animation-iteration-count:1; -webkit-backface-visibility:visible;}
@keyframes flip {
	0% {transform:translateZ(0) rotateY(0); animation-timing-function:ease-out;}
	40% {transform:translateZ(150px) rotateY(170deg); animation-timing-function:ease-out;}
	50% {transform:translateZ(150px) rotateY(190deg); animation-timing-function:ease-in;}
	80% {transform:translateZ(0) rotateY(360deg); animation-timing-function:ease-in;}
	100% {transform:translateZ(0) rotateY(360deg); animation-timing-function:ease-in;}
}
@-webkit-keyframes flip {
	0% {-webkit-transform:translateZ(0) rotateY(0); -webkit-animation-timing-function:ease-out;}
	40% {-webkit-transform:translateZ(150px) rotateY(170deg); -webkit-animation-timing-function:ease-out;}
	50% {-webkit-transform:translateZ(150px) rotateY(190deg); -webkit-animation-timing-function:ease-in;}
	80% {-webkit-transform:translateZ(0) rotateY(360deg); -webkit-animation-timing-function:ease-in;}
	100% {-webkit-transform:translateZ(0) rotateY(360deg); -webkit-animation-timing-function:ease-in;}
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
		<% If not( left(currenttime,10)>="2016-10-04" and left(currenttime,10)<="2016-10-11" ) Then %>
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
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_slide_01.jpg" alt="matches navy pattern socks" />
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>

					<div class="swiper-slide swiper-slide-brand">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_slide_03.jpg" alt="" /></p>
					</div>

					<%' buy %>
					<%
						Dim itemid, oItem
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1563651
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
					<%' for dev msg : 상품 링크 %>
					<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1563651&amp;pEtr=73444'); return false;">
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1563651&pEtr=73444">
					<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_slide_04.jpg" alt="" />
							<div class="option">
						<% If oItem.FResultCount > 0 then %>
							<%' for dev msg : 상품코드 1563651 할인기간 10/5~10/11 할인기간이 지나면 <strong class="discount">...</strong> 숨겨주세요 %>
							<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
								<strong class="discount">단 일주일만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
								<span class="name">W&amp;P <span>The Mason Shaker</span></span>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% Else %>
								<span class="name">W&amp;P <span>The Mason Shaker</span></span>
								<div class="price priceEnd">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% End If %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
						<% End If %>
							</div>
						</a>
					</div>
					<% set oItem = nothing %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1563652
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<!-- buy -->
					<div class="swiper-slide swiper-slide-buy" style="background-color:#fff;">
					<%' for dev msg : 상품 링크 %>
					<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1563652&amp;pEtr=73444'); return false;">
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1563652&pEtr=73444">
					<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_slide_05.jpg" alt="" />
							<div class="option">
						<% If oItem.FResultCount > 0 then %>
							<%' for dev msg : 상품코드 1563652 할인기간 10/5~10/11 할인기간이 지나면 <strong class="discount">...</strong> 숨겨주세요 %>
							<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
								<strong class="discount">단 일주일만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
								<span class="name">SHAKE : <span>A New Perspective On Cocktails</span></span>
								<div class="price">
									<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% Else %>
								<span class="name">SHAKE : <span>A New Perspective On Cocktails</span></span>
								<div class="price priceEnd">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% End If %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
						<% End If %>
							</div>
						</a>
					</div>
					<% set oItem = nothing %>

					<div class="swiper-slide swiper-slide-shake">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/txt_shake.png" alt="&quot;shake&quot;" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_slide_06.jpg" alt="" />
					</div>


					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1563651&pEtr=73444" title="The Mason Shaker 상품보러 가기" class="mWeb">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_slide_07.jpg" alt="#Fun 휴대성 좋은 The Mason Shaker 하나. 가방 안에 쏙 넣으면 어디서든지 칵테일을 즐길 수 있어요. 혼자 여행하면서 홀짝홀짝 혼술하는, 다 함께 칵테일을 마시면서 피크닉을 즐기는 상상해보아요!" /></p>
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1563651&pEtr=73444" onclick="fnAPPpopupProduct('1563651&pEtr=73236');return false;" title="The Mason Shaker 상품보러 가기" class="mApp">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_slide_07.jpg" alt="#Fun 휴대성 좋은 The Mason Shaker 하나. 가방 안에 쏙 넣으면 어디서든지 칵테일을 즐길 수 있어요. 혼자 여행하면서 홀짝홀짝 혼술하는, 다 함께 칵테일을 마시면서 피크닉을 즐기는 상상해보아요!" /></p>
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1563651&pEtr=73444" class="mWeb">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_slide_08.jpg" alt="#Simple SIMPLE IS THE BEST! 재료가 많지 않더라도 맛 좋은 칵테일을 즐길 수 있어요. 5~6가지 재료로 다양하게 제조할 수 있도록 shake가 칵테일의 세계로 안내합니다." /></p>
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1563651&pEtr=73444" onclick="fnAPPpopupProduct('1563651&pEtr=73236');return false;" class="mApp">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_slide_08.jpg" alt="#Simple SIMPLE IS THE BEST! 재료가 많지 않더라도 맛 좋은 칵테일을 즐길 수 있어요. 5~6가지 재료로 다양하게 제조할 수 있도록 shake가 칵테일의 세계로 안내합니다." /></p>
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1563651&pEtr=73444" class="mWeb">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_slide_09.jpg" alt="#Social 칵테일은 같이 즐겨야 제 맛이지! 직접 만든 칵테일을 지인들에게 선보이면서 즐겁고 정답게 칵테일 건배를 해보아요." /></p>
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1563651&pEtr=73444" onclick="fnAPPpopupProduct('1563651&pEtr=73236');return false;" class="mApp">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_slide_09.jpg" alt="#Social 칵테일은 같이 즐겨야 제 맛이지! 직접 만든 칵테일을 지인들에게 선보이면서 즐겁고 정답게 칵테일 건배를 해보아요." /></p>
						</a>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1563651&pEtr=73444" class="mWeb">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_slide_10.jpg" alt="#More 칵테일만 담으라고 있는 메이슨자가 아니죠! 다양한 응용이 가능한 메이슨자에 담고자 하는 음식을 넣어보아요!" /></p>
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1563651&pEtr=73444" onclick="fnAPPpopupProduct('1563651&pEtr=73236');return false;" class="mApp">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_slide_10.jpg" alt="#More 칵테일만 담으라고 있는 메이슨자가 아니죠! 다양한 응용이 가능한 메이슨자에 담고자 하는 음식을 넣어보아요!" /></p>
						</a>
					</div>

					<div class="swiper-slide swiper-slide-instagram">
						<div class="btnInstagram">
							<a href="https://www.instagram.com/wandpdesign/" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/wandpdesign/'); return false;" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/btn_instagram.png" alt="WANDP DESIGN 인스타그램 공식계정으로 이동 새창" /></a>
						</div>

						<ul>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_instagram_01.jpg" alt="" /></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_instagram_02.jpg" alt="" /></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_instagram_03.jpg" alt="" /></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_instagram_04.jpg" alt="" /></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_instagram_05.jpg" alt="" /></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_instagram_06.jpg" alt="" /></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_instagram_07.jpg" alt="" /></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_instagram_08.jpg" alt="" /></li>
							<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_instagram_09.jpg" alt="" /></li>
						</ul>
					</div>

					<div class="swiper-slide swiper-slide-finish">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/txt_finish.png" alt="" /></p>
						<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_slide_11.jpg" alt="" /></div>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/img_slide_12.png" alt="Hey, something project 마시고 싶은 그 순간" /></p>
						<a href="#commentevt" class="btngo" title="코멘트 남기러 가기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_go.gif" alt="응모하러 가기" /></a>
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
		<%' for dev msg : 구매하기 버튼 클릭시 브랜드 페이지로 링크 %>
		<div class="btnget">
		<% If isApp = 1 Then %>
			<a href="" onclick="fnAPPpopupBrand('wandp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_brand_shop_v1.png" alt="BRAND SHOP" /></a>
		<% Else %>
			<a href="/street/street_brand.asp?makerid=wandp"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_brand_shop_v1.png" alt="BRAND SHOP" /></a>
		<% End If %>
		</div>
	</div>
	<%' //main contents %>

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
				<legend>당신은 칵테일이 가장 생각나는 순간이 언제인지 코멘트 쓰기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/txt_comment.png" alt="당신은 칵테일이 가장 생각나는 순간이 언제인가요? 정성껏 코멘트를 남겨주신 5분을 추첨하여 W&P DESIGN의 The Mason Shaker 또는 ShakE 도서를 증정합니다. 랜덤 증정, 코멘트 작성기간은 2016년 10월 5일부터 10월 11일까지며, 발표는 10월 12일 입니다." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/ico_01_off.png" alt="Fun" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/ico_02_off.png" alt="Simple" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/ico_03_off.png" alt="Social" /></button>
							</li>
							<li class="ico4">
								<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73444/m/ico_04_off.png" alt="More" /></button>
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
							Fun
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
							Simple
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
							Social
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>
							More
						<% Else %>
							Fun
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

			$(".swiper-slide-shake").find("p").removeClass("shake");
			$(".swiper-slide-active.swiper-slide-shake").find("p").addClass("shake");

			$(".swiper-slide-finish").find("p").removeClass("flip");
			$(".swiper-slide-active.swiper-slide-finish").find("p").addClass("flip");

			$(".swiper-slide-instagram").find("ul li img").delay(100).animate({"opacity":"0"},300);
			$(".swiper-slide-active,swiper-slide-instagram").find("ul li:nth-child(1) img").delay(50).animate({"opacity":"1"},600);
			$(".swiper-slide-active,swiper-slide-instagram").find("ul li:nth-child(2) img").delay(150).animate({"opacity":"1"},600);
			$(".swiper-slide-active,swiper-slide-instagram").find("ul li:nth-child(3) img").delay(350).animate({"opacity":"1"},600);
			$(".swiper-slide-active,swiper-slide-instagram").find("ul li:nth-child(4) img").delay(50).animate({"opacity":"1"},600);
			$(".swiper-slide-active,swiper-slide-instagram").find("ul li:nth-child(5) img").delay(450).animate({"opacity":"1"},600);
			$(".swiper-slide-active,swiper-slide-instagram").find("ul li:nth-child(6) img").delay(550).animate({"opacity":"1"},600);
			$(".swiper-slide-active,swiper-slide-instagram").find("ul li:nth-child(7) img").delay(350).animate({"opacity":"1"},600);
			$(".swiper-slide-active,swiper-slide-instagram").find("ul li:nth-child(8) img").delay(150).animate({"opacity":"1"},600);
			$(".swiper-slide-active,swiper-slide-instagram").find("ul li:nth-child(9) img").delay(50).animate({"opacity":"1"},600);
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