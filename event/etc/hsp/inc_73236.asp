<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 49
' History : 2016-09-27 이종화 생성
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
	eCode   =  66196
Else
	eCode   =  73236
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

/* title */
.heySomething .swiper-slide .hey {position:absolute; top:6.5%; left:0; width:100%;}

/* buy */
.heySomething .swiper-slide-buy a {display:block;}
.heySomething .swiper-slide-buy .option {text-align:center;}
.heySomething .swiper-slide-buy .option .size {display:block; margin-top:4px; color:#858585; font-size:12px; font-weight:bold;}
@media all and (min-width:480px){
	.heySomething .swiper-slide-buy .name span {margin-top:7px; font-size:15px;}
}

/* visual */
.swiper-slide-visual {overflow:hidden; background-color:#a4c03b;}
.swiper-slide-visual div {position:absolute; top:0; left:0; width:100%;}

.pulse {animation-name:pulse; animation-duration:1.5s; animation-iteration-count:1; -webkit-animation-name:pulse; -webkit-animation-duration:1.5s; -webkit-animation-iteration-count:1;}
@keyframes pulse {
	0% {transform:scale(1.2);}
	100% {transform:scale(1);}
}
@-webkit-keyframes pulse {
	0% {-webkit-transform:scale(1.2);}
	100% {-webkit-transform:scale(1);}
}

/* finish */
.swiper-slide-finish {overflow:hidden; background-color:#d4b0c4;}
.swiper-slide-finish div {position:absolute; top:0; left:0; width:100%;}
.swiper-slide-finish p {position:absolute; top:15.8%; left:0; width:100%;}

/* comment */
.heySomething .swiper-slide .btngo {top:70%;}

.heySomething .form .inner {padding:0 5%;}
.heySomething .form .choice {margin-right:-2%; padding:3% 0 0 3%;}
.heySomething .form .choice li {width:25%; height:auto !important; margin:0; padding:0 3% 0 0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/ico_01_off.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/ico_02_off.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/ico_03_off.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/ico_04_off.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/ico_04_on.png);}

.heySomething .field {margin-top:8%;}

.heySomething .commentlist ul li {position:relative; min-height:9rem; padding:1.5rem 0 1.5rem 7.75rem;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:0.1rem; width:6.2rem; height:7.4rem; margin-top:-3.7rem; background-repeat:no-repeat; background-position:50% 0 !important; background-size:100% auto;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/ico_01_off.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/ico_02_off.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/ico_03_off.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/ico_04_off.png);}
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
		<% If not( left(currenttime,10)>="2016-09-28" and left(currenttime,10)<"2016-10-05" ) Then %>
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
						<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/tit_hey_something_project.png" alt="Hey, something project" /></strong>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/img_slide_01.jpg" alt="matches navy pattern socks" />
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>

					<%' buy %>
					<%
						Dim itemid, oItem
						Set oItem = Nothing
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786869
						Else
							itemid = 1569789
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
						<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1569789&amp;pEtr=73236'); return false;">
						<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1569789&pEtr=73236">
						<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/img_slide_03.jpg" alt="" />
							<div class="option">
								<strong class="discount">텐바이텐 단독 선오픈</strong>
								<span class="name">KAKAO PINK APEACH<br /> CLASSICS TINY</span>
								<span class="size">120-180 사이즈 (10단위) </span>
								<% If oItem.FResultCount > 0 then %>
								<div class="price">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
								<% End If %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
							</div>
						</a>
					</div>
					<% Set oItem = Nothing %>

					<%
						Set oItem = Nothing
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786869
						Else
							itemid = 1569790
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
						<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1569790&amp;pEtr=73236'); return false;">
						<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1569790&pEtr=73236">
						<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/img_slide_04.jpg" alt="" />
							<div class="option">
								<strong class="discount">텐바이텐 단독 선오픈</strong>
								<span class="name">KAKAO CHAMBRAY APEACH <br />CLASSICS (W)</span>
								<span class="size">220-260 사이즈 (5단위)</span>
								<% If oItem.FResultCount > 0 then %>
								<div class="price">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
								<% End If %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="구매하러 가기" /></div>
							</div>
						</a>
					</div>
					<% Set oItem = Nothing %>

					<div class="swiper-slide swiper-slide-visual">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_blank.png" alt="" />
						<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/img_slide_05.jpg" alt="" /></div>
					</div>

					<div class="swiper-slide swiper-slide-brand">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/img_slide_06.jpg" alt="2006년 여름, 아르헨티나를 여행중인 미국의 한 청년은 고민했습니다. 수십 킬로미터를 맨발로 걷는 저 아이들에게 도움을 줄 수 있는 방법은 없을까? 한 켤레가 팔릴 때마다, 신발이 없는 아이들에게 한 켤레를 선물하자! 그 따뜻한 관심에서 시작된 우리 아이들의 내일을 위한 신발 TOMorrow&apos;s Shoes, TOMS" /></p>
					</div>
					<div class="swiper-slide swiper-slide-brand">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/img_slide_07_v1.png" alt="8명의 매력적인 친구들로 이루어진 Kakao friends! 그 중, 유전자 변이로 자웅동주가 된 것을 알고 복숭아 나무에서 탈출한 악동 복숭아 APEACH 애교 넘치는 표정과 행동으로 귀요미 역할을 합니다. 우리집에도 이 귀요미가 살고 있는 것 같아요!" /></p>
					</div>

					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1569789&pEtr=73236" title="Kakao pink apeach classics tiny 상품보러 가기" class="mWeb">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/img_slide_08.jpg" alt="#Love 사랑하는 아이에겐, 사랑스러운 신발이 필요해요! 내 인생을 핑크빛으로 물들게 해준 나의 아이에게" /></p>
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1569789&pEtr=73236" title="Kakao pink apeach classics tiny 상품보러 가기" onclick="fnAPPpopupProduct('1569789&pEtr=73236');return false;" class="mApp">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/img_slide_08.jpg" alt="#Love 사랑하는 아이에겐, 사랑스러운 신발이 필요해요! 내 인생을 핑크빛으로 물들게 해준 나의 아이에게" /></p>
						</a>
					</div>
					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1569789&pEtr=73236" title="Kakao pink apeach classics tiny 상품보러 가기" class="mWeb">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/img_slide_09.jpg" alt="#Together 네가 뱃속에 있었을 때부터 꼭 해보고 싶었던 1순위 아장아장 걷기 시작할 때, 너와 함께하는 커플 슈즈" /></p>
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1569789&pEtr=73236" title="Kakao pink apeach classics tiny 상품보러 가기" onclick="fnAPPpopupProduct('1569789&pEtr=73236');return false;" class="mApp">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/img_slide_09.jpg" alt="#Together 네가 뱃속에 있었을 때부터 꼭 해보고 싶었던 1순위 아장아장 걷기 시작할 때, 너와 함께하는 커플 슈즈" /></p>
						</a>
					</div>
					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1569790&pEtr=73236" title="Kakao chambray apeach classics women 상품보러 가기" class="mWeb">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/img_slide_10.jpg" alt="#Play 그래, 이 세상 모든 것이 신기할 나이지! 탐스 위의 인형 참은 즐거운 놀이감이 될 수 있어요" /></p>
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1569790&pEtr=73236" title="Kakao chambray apeach classics women 상품보러 가기" onclick="fnAPPpopupProduct('1569790&pEtr=73236');return false;" class="mApp">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/img_slide_10.jpg" alt="#Play 그래, 이 세상 모든 것이 신기할 나이지! 탐스 위의 인형 참은 즐거운 놀이감이 될 수 있어요" /></p>
						</a>
					</div>
					<div class="swiper-slide swiper-slide-story">
						<a href="/category/category_itemPrd.asp?itemid=1569790&pEtr=73236" title="Kakao chambray apeach classics women 상품보러 가기" class="mWeb">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/img_slide_11.jpg" alt="#One for one 탐스를 사면, 누군가의 아이도 행복해집니다.  따뜻한 그 마음을 함께 누려보세요!" /></p>
						</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1569790&pEtr=73236" title="Kakao chambray apeach classics women 상품보러 가기" onclick="fnAPPpopupProduct('1569790&pEtr=73236');return false;" class="mApp">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/img_slide_11.jpg" alt="#One for one 탐스를 사면, 누군가의 아이도 행복해집니다.  따뜻한 그 마음을 함께 누려보세요!" /></p>
						</a>
					</div>

					<div class="swiper-slide swiper-slide-finish">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_slide_blank.png" alt="" />
						<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/img_slide_12.jpg" alt="" /></div>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/txt_finish.png" alt="매일 매일이 사랑스러운, 우리 아이와 함께하는 슈즈 TOMS" /></p>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/img_slide_13.png" alt="Hey, something project 엄마와 아이의 한 걸음" /></p>
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
		<%'  for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/html/event/hey/72882_get.asp %>
		<div class="btnget">
		<% if isApp=1 then %>
			<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_73236_item.asp?isApp=<%= isApp %>'); return false;" title="Kakao pink apeach classics tiny와 Kakao chambray apeach classics women 구매하러 가기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="DENY 타피스트리 구매하러 가기" /></a>
		<% Else %>
			<a href="/event/etc/hsp/inc_73236_item.asp?isApp=<%= isApp %>" target="_blank" title="Kakao pink apeach classics tiny와 Kakao chambray apeach classics women 구매하러 가기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="DENY 타피스트리 구매하러 가기" /></a>
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
				<legend>우리 아이가 가장 사랑스러워 보일 때는 언제인지 코멘트 쓰기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/txt_comment.png" alt="우리 아이가 가장 사랑스러워 보일 때는 언제인가요? 정성껏 코멘트를 남겨주신 4분을 추첨하여 TOMS와 카카오프렌즈 콜라보레이션 제품을 선물로 드립니다. 코멘트 기재시, 희망 사이즈 기재 필수 Women 2분, TINY 2분 증정, 코멘트 작성기간은 2016년 9월 28일부터 10월 4일까지며, 발표는 10월 5일 입니다." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/ico_01_off.png" alt="Love" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/ico_02_off.png" alt="Together" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/ico_03_off.png" alt="Play" /></button>
							</li>
							<li class="ico4">
								<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/ico_04_off.png" alt="One for one" /></button>
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
							Love
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
							Together
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
							Play
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>
							One for one
						<% Else %>
							Love
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
			$(".swiper-slide-active").find(".hey").delay(50).animate({"top":"6.5%", "opacity":"1"},600);

			$(".swiper-slide.swiper-slide-visual").find("div").removeClass("pulse");
			$(".swiper-slide-active.swiper-slide-visual").find("div").addClass("pulse");

			$(".swiper-slide-finish").find("div").delay(10).animate({"opacity":"0"},300);
			$(".swiper-slide-finish").find("p").delay(100).animate({"margin-top":"-3%", "opacity":"0"},100);
			$(".swiper-slide-active.swiper-slide-finish").find("div").delay(300).animate({"opacity":"1"},800);
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