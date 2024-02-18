<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 22 MA
' History : 2016-02-29 유태욱 생성
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
	eCode   =  66051
Else
	eCode   =  69341
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
.heySomething .swiper-slide .hey {position:absolute; top:6.5%; left:0; width:100%;}

/* buy */
.heySomething .swiper-slide-buy a {display:block;}
.heySomething .swiper-slide-buy .option {position:absolute; top:0; left:0; width:100%; height:100%; padding-top:92%; text-align:center;}
.heySomething .option .name {min-height:28px;}

/* info */
.swiper-slide-info .info {position:absolute; top:29%; left:0; width:100%;}

/* animation */
.heySomething .swiper-slide .violin {position:absolute; top:10%; left:46%; width:23.75%;}
.heySomething .swiper-slide .airplane {position:absolute; top:54%; left:1.2%; width:35.156%;}
.heySomething .swiper-slide .fight {position:absolute; right:6.5%; bottom:8%; width:34.218%;}
.heySomething .swiper-slide .seesaw {position:absolute; top:8.2%; left:32.1%; width:38.75%;}
.heySomething .swiper-slide .balloon {position:absolute; top:65%; left:5.2%; width:19.687%;}
.heySomething .swiper-slide .climbing {position:absolute; top:0; right:24%; width:22.656%;}
.heySomething .swiper-slide .pull {position:absolute; top:55.5%; left:1.2%; width:31.25%;}
.heySomething .swiper-slide .voyage {position:absolute; right:6.5%; bottom:14%; width:25.3125%;}

/* mickey */
.swiper-slide-mickey .mickey {position:absolute; top:25%; left:0; width:100%;}

/* story */
.heySomething .swiper-slide .desc {position:absolute; top:7.5%; width:100%;}
.heySomething .swiper-slide .desc1 {left:0;}
.heySomething .swiper-slide .desc2 {right:0; top:9%;}
.heySomething .swiper-slide .desc3 {left:0; top:9%;}
.heySomething .swiper-slide .desc4 {right:0; top:15.3%;}

/* finish */
.heySomething .swiper-slide .finish {position:absolute; top:15%; left:0; width:100%;}

/* comment */
.heySomething .form .choice {padding:3% 5% 0 0;}
.heySomething .form .choice li {width:25%; height:auto !important; margin:0; padding:0 2% 0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/ico_01_off.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/ico_02_off.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/ico_03_off.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/ico_04_off.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/ico_04_on.png);}

.heySomething .commentlist ul li {position:relative; min-height:91px; padding:15px 0 15px 78px;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:1%; width:60px; height:60px; margin-top:-30px; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/ico_01.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/ico_02.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/ico_03.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/ico_04.png);}

@media all and (min-width:480px){
	.heySomething .commentlist ul li {min-height:135px; padding:22px 0 22px 110px;}
	.heySomething .commentlist ul li strong {width:90px; height:90px; margin-top:-45px;}
}

@media all and (min-width:768px){
	.heySomething .commentlist ul li {min-height:180px; padding:30px 0 30px 150px;}
	.heySomething .commentlist ul li strong {width:120px; height:120px; margin-top:-60px;}
}

/* css3 animation */
.shake {animation-name:shake; animation-duration:3s; animation-fill-mode:both; animation-iteration-count:5;}
.shake {-webkit-animation-name:shake; -webkit-animation-duration:3s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:5;}
@keyframes shake {
	0% {transform:translateX(0);}
	50% {transform:translateX(-15px);}
	100% {transform:translateX(0);}
}
@-webkit-keyframes shake {
	0% {-webkit-transform:translateX(0);}
	50% {-webkit-transform:translateX(-15px);}
	100% {-webkit-transform:translateX(0);}
}

.bouncing {animation-name:bouncing; animation-duration:3s; animation-fill-mode:both; animation-iteration-count:5;}
.bouncing {-webkit-animation-name:bouncing; -webkit-animation-duration:3s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:5;}
@keyframes bouncing {
	0%, 20%, 50%, 80%, 100% {transform:translateY(0);}
	40% {transform:translateY(-30px);}
	60% {transform:translateY(-15px);}
}
@-webkit-keyframes bouncing {
	0%, 20%, 50%, 80%, 100% {-webkit-transform:translateY(0);}
	40% {-webkit-transform:translateY(-30px);}
	60% {-webkit-transform:translateY(-15px);}
}

.updown {animation-name:updown; animation-duration:3s; animation-fill-mode:both; animation-iteration-count:5;}
.updown {-webkit-animation-name:updown; -webkit-animation-duration:3s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:5;}
@keyframes updown {
	0% {transform:translateY(0);}
	50% {transform:translateY(-15px);}
	100% {transform:translateY(0);}
}
@-webkit-keyframes updown {
	0% {-webkit-transform:translateY(0);}
	50% {-webkit-transform:translateY(-15px);}
	100% {-webkit-transform:translateY(0);}
}

.rollIn {animation-name:rollIn; animation-duration:3s; animation-fill-mode:both; animation-iteration-count:1;}
.rollIn {-webkit-animation-name:rollIn; -webkit-animation-duration:3s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:1;}
@keyframes rollIn {
	0% {opacity:0; transform:translateX(-100%) rotate(-120deg);}
	100% {opacity:1; transform:translateX(0px) rotate(0deg);}
}
@-webkit-keyframes rollIn {
	0% {opacity:0; -webkit-transform:translateX(-100%) rotate(-120deg);}
	100% {opacity:1; -webkit-transform:translateX(0px) rotate(0deg);}
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
		<% If not( left(currenttime,10)>="2016-03-02" and left(currenttime,10)<"2016-03-09" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>0 then %>
				alert("이벤트는 한번만 참여 가능 합니다.");
				return false;
			<% else %>
				if (frm.gubunval.value == ''){
					alert('가장 마음에 드는 디즈니 노트 활용법을 선택해 주세요.');
					return false;
				}
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 400){
					alert("코맨트를 남겨주세요.\n한글 400자 까지 작성 가능합니다.");
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

<%'' [Hey, something project_22] Disney Vintage Edition / 이벤트 코드 69341 %>
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
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_slide_01.jpg" alt="" />
						<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project.png" alt="Hey, something project" /></strong>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>

					<%'' buy1 %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid   =  1239226
						else
							itemid   =  1431913
						end if
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
						<% ' for dev msg : 상품 링크 %>
						<% if isApp=1 then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1431913&amp;pEtr=69341'); return false;">
						<% else %>
							<a href="/category/category_itemPrd.asp?itemid=1431913&amp;pEtr=69341">
						<% end if %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_slide_03_v1.gif" alt="" />
							<div class="option">
								<em class="name">Disney Vintage Note Set <span>텐바이텐 단독 제작</span></em>
								<% if oItem.FResultCount > 0 then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% else %>
										<div class="price">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% end if %>
								<% end if %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="Disney Vintage Note Set 구매하러 가기" /></div>
							</div>
						</a>
					</div>
					<% set oItem=nothing %>

					<%'' buy2 %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid   =  1239226
						else
							itemid   =  1434283
						end if
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
						<% ' for dev msg : 상품 링크 %>
						<% if isApp=1 then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1434283&amp;pEtr=69341'); return false;">
						<% else %>
							<a href="/category/category_itemPrd.asp?itemid=1434283&amp;pEtr=69341">
						<% end if %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_slide_04.jpg" alt="" />
							<div class="option">
								<em class="name">Disney Vintage playing card <span>텐바이텐 단독 제작</span></em>
								<% if oItem.FResultCount > 0 then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% else %>
										<div class="price">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% end if %>
								<% end if %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="Disney Vintage playing card 구매하러 가기" /></div>
							</div>
						</a>
					</div>
					<% set oItem=nothing %>

					<%'' buy3 %>
					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid   =  1239226
						else
							itemid   =  1418361
						end if
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
						<% ' for dev msg : 상품 링크 %>
						<% if isApp=1 then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=69341'); return false;">
						<% else %>
							<a href="/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=69341">
						<% end if %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_slide_05.jpg" alt="" />
							<div class="option">
								<em class="name">Disney Vintage 아이폰6/6S 케이스<span>텐바이텐 단독 제작</span></em>
								<% if oItem.FResultCount > 0 then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% else %>
										<div class="price">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% end if %>
								<% end if %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="Disney Vintage 아이폰6/6S 케이스 구매하러 가기" /></div>
							</div>
						</a>
					</div>
					<% set oItem=nothing %>

					<div class="swiper-slide swiper-slide-info">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_slide_06.jpg" alt="" />
						<p class="info"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/txt_info.png" alt="Disney Vintage Note Set는 가로 14.8센치 세로 21센치며, 소재는 종이입니다." /></p>
					</div>

					<%' brand %>
					<div class="swiper-slide swiper-slide-brand">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_slide_07.png" alt="Money doesn&apos;t excite me, my ideas excited me. Walt Disney 디즈니는 1923 설립 이래로 필름스케치, 드로잉, 포스터 등 다양한 작업을 통해 디즈니 고유의 아트워크를 창조하고있습니다. 디즈니의 빈티지 컬렉션은 클래식 감성을 간직한 사랑스러운 디즈니 캐릭터를 통해 어린 시절의 추억과 향수를 불러일으킵니다." /></p>
					</div>

					<div class="swiper-slide swiper-slide-animation01">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_slide_08.jpg" alt="" />
						<span class="violin"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_character_violin.png" alt="" /></span>
						<span class="airplane"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_character_airplane.png" alt="" /></span>
						<span class="fight"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_character_fight.png" alt="" /></span>
					</div>
					<div class="swiper-slide swiper-slide-animation02">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_slide_09_v1.jpg" alt="" />
						<span class="balloon"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_character_balloon.png" alt="" /></span>
						<span class="seesaw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_character_seesaw.png" alt="" /></span>
					</div>
					<div class="swiper-slide swiper-slide-animation03">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_slide_10_v2.jpg" alt="" />
						<span class="climbing"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_character_climbing.png" /></span>
						<span class="pull"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_character_pull.png" alt="" /></span>
						<span class="voyage"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_character_voyage.png" alt="" /></span>
					</div>
					<div class="swiper-slide swiper-slide-mickey">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_slide_11.png" alt="" />
						<div class="mickey"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_mickey_v1.png" alt="미키마우스" /></div>
					</div>

					<div class="swiper-slide swiper-slide-story01">
						<p class="desc desc1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/txt_desc_01.png" alt="요리가 즐거워지는 레시피북" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_slide_12.jpg" alt="" />
					</div>
					<div class="swiper-slide swiper-slide-story02">
						<p class="desc desc2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/txt_desc_02.png" alt="익살스러운 미키와 함께하는 행복한 스쿨노트" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_slide_13.jpg" alt="" />
					</div>
					<div class="swiper-slide swiper-slide-story03">
						<p class="desc desc3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/txt_desc_03.png" alt="소중한 기억들을 간직해 줄 스크랩북" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_slide_14.jpg" alt="" />
					</div>
					<div class="swiper-slide swiper-slide-story04">
						<p class="desc desc4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/txt_desc_04.png" alt="하얀 도화지 위 컬러를 담은 드로잉북" /></p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_slide_15.jpg" alt="" />
					</div>

					<%''// finish %>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_slide_16.jpg" alt="디즈니 빈티지 에디션" /></p>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/img_slide_17.png" alt="가장 마음에 드는 디즈니 노트 활용법과 그 이유를 코멘트로 남겨주세요. 정성껏 코멘트를 남겨주신 5분을 추첨하여 Disney vintage Note set를 증정합니다. 코멘트 작성기간은 2016년 3월 2일부터 3월 8일까지며, 발표는 3월 14일 입니다." /></p>
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

		<%''  for dev msg : 구매하기 버튼 %>
		<div class="btnget">
			<% If isapp="1" Then %>
				<a href="" onclick="fnAPPpopupProduct('1431913'); return false;" title="Disney Vintage Note Set 구매하러 가기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" /></a>
			<% Else %>
				<a href="/category/category_itemPrd.asp?itemid=1431913"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" /></a>
			<% End If %>
		</div>
	</div>
	<%'' //main contents %>

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
				<legend>Disney Vintage Note Set 코멘트 쓰기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/txt_comment.png" alt="가장 마음에 드는 디즈니 노트 활용법과 그 이유를 코멘트로 남겨주세요. 정성껏 코멘트를 남겨주신 5분을 추첨하여 Disney vintage Note set를 증정합니다. 코멘트 작성기간은 2016년 3월 2일부터 3월 8일까지며, 발표는 3월 14일 입니다." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/ico_01_off.png" alt="레시피북" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/ico_02_off.png" alt="스쿨노트" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/ico_03_off.png" alt="스크랩북" /></button>
							</li>
							<li class="ico4">
								<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69341/m/ico_04_off.png" alt="드로잉북" /></button>
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
									레시피북
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="2" then %>
									스쿨노트
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="3" then %>
									스크랩북
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="4" then %>
									드로잉북
								<% Else %>
									레시피북
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
	<%'' //comment event %>

	<div id="dimmed"></div>
</div>
<%'' //[Hey, something project_22] %>

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

			$(".swiper-slide.swiper-slide-info").find(".info").delay(100).animate({"width":"95%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-info").find(".info").delay(300).animate({"width":"100%", "opacity":"1"},500);

			$(".swiper-slide.swiper-slide-animation01").find(".airplane").delay(100).animate({"margin-left":"-5%","margin-top":"5%", "opacity":"0"},300);
			$(".swiper-slide.swiper-slide-animation01").find(".violin").delay(100).animate({"margin-top":"-5%", "opacity":"0"},300);
			$(".swiper-slide.swiper-slide-animation01").find(".violin").removeClass("shake");
			$(".swiper-slide.swiper-slide-animation01").find(".fight").delay(100).animate({"margin-right":"-5%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-animation01").find(".violin").delay(100).animate({"margin-top":"0", "opacity":"1"},500);
			$(".swiper-slide-active.swiper-slide-animation01").find(".violin").addClass("shake");
			$(".swiper-slide-active.swiper-slide-animation01").find(".airplane").delay(200).animate({"margin-left":"0","margin-top":"0", "opacity":"1"},500);
			$(".swiper-slide-active.swiper-slide-animation01").find(".fight").delay(300).animate({"margin-right":"0", "opacity":"1"},600);

			$(".swiper-slide.swiper-slide-animation02").find(".seesaw").delay(100).animate({"margin-top":"10%", "opacity":"0"},300);
			$(".swiper-slide.swiper-slide-animation02").find(".balloon").delay(200).animate({"opacity":"0"},300);
			$(".swiper-slide.swiper-slide-animation02").find(".balloon").removeClass("bouncing");
			$(".swiper-slide-active.swiper-slide-animation02").find(".seesaw").delay(100).animate({"margin-top":"0", "opacity":"1"},600);
			$(".swiper-slide-active.swiper-slide-animation02").find(".balloon").delay(100).animate({"opacity":"1"},500);
			$(".swiper-slide-active.swiper-slide-animation02").find(".balloon").addClass("bouncing");

			$(".swiper-slide.swiper-slide-animation03").find(".climbing").delay(100).animate({"margin-left":"-5%", "opacity":"0"},300);
			$(".swiper-slide.swiper-slide-animation03").find(".climbing").removeClass("updown");
			$(".swiper-slide.swiper-slide-animation03").find(".pull").delay(100).animate({"margin-left":"-5%", "opacity":"0"},300);
			$(".swiper-slide.swiper-slide-animation03").find(".voyage").delay(100).animate({"margin-right":"-5%", "opacity":"0"},300);
			$(".swiper-slide-active.swiper-slide-animation03").find(".climbing").delay(100).animate({"margin-top":"0", "opacity":"1"},500);
			$(".swiper-slide-active.swiper-slide-animation03").find(".climbing").addClass("updown");
			$(".swiper-slide-active.swiper-slide-animation03").find(".pull").delay(200).animate({"margin-left":"0", "opacity":"1"},500);
			$(".swiper-slide-active.swiper-slide-animation03").find(".voyage").delay(500).animate({"margin-right":"0", "opacity":"1"},500);

			$(".swiper-slide.swiper-slide-mickey").find(".mickey").removeClass("rollIn");
			$(".swiper-slide-active.swiper-slide-mickey").find(".mickey").addClass("rollIn");

			$(".swiper-slide").find(".desc1, .desc3").delay(100).animate({"margin-top":"10%", "opacity":"0"},300);
			$(".swiper-slide-active").find(".desc1, .desc3").delay(50).animate({"margin-top":"0", "opacity":"1"},600);

			$(".swiper-slide").find(".desc2, .desc4").delay(100).animate({"margin-right":"-10%", "opacity":"0"},300);
			$(".swiper-slide-active").find(".desc2, .desc4").delay(50).animate({"margin-right":"0", "opacity":"1"},600);
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