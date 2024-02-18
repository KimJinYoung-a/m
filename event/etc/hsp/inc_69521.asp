<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 23 MA
' History : 2016-03-08 유태욱 생성
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
	eCode   =  66060
Else
	eCode   =  69521
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
.heySomething .swiper-slide-buy .option {position:absolute; top:0; left:0; width:100%; height:100%; padding-top:100%; text-align:center;}
.heySomething .swiper-slide-buy .option .price strong {color:#000; font-family:verdana, tahoma, sans-serif;}
.heySomething .option .name {min-height:28px;}
.heySomething .swiper-slide-buy .pdtLink {overflow:hidden; position:absolute; top:0; left:0; width:100%; height:100%; padding-top:19%; padding-bottom:10%; text-align:center;}
.heySomething .swiper-slide-buy .pdtLink li {float:left; width:50%; height:50%;}
.heySomething .swiper-slide-buy .pdtLink li a {width:100%; height:100%; padding-top:93%; color:#777; font-size:11px; line-height:1.3; font-weight:bold}

/* info */
.swiper-slide-info .info {position:absolute; top:29%; left:0; width:100%;}

/* desc */
.heySomething .desc p {position:absolute; left:0; bottom:0; width:100%;}

/* comment */
.heySomething .form .choice {padding:3% 5% 0 0;}
.heySomething .form .choice li {width:25%; height:auto !important; margin:0; padding:0 2% 0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/ico_01.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/ico_02.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/ico_03.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/ico_04.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/ico_04_on.png);}

.heySomething .commentlist ul li {position:relative; min-height:91px; padding:15px 0 15px 78px;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:1%; width:60px; height:60px; margin-top:-30px; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/ico_01.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/ico_02.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/ico_03.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/ico_04.png);}

@media all and (min-width:480px){
	.heySomething .swiper-slide-buy .pdtLink li a {font-size:16px;}
	.heySomething .commentlist ul li {min-height:135px; padding:22px 0 22px 110px;}
	.heySomething .commentlist ul li strong {width:90px; height:90px; margin-top:-45px;}
}

@media all and (min-width:768px){
	.heySomething .swiper-slide-buy .pdtLink li a {font-size:22px;}
	.heySomething .commentlist ul li {min-height:180px; padding:30px 0 30px 150px;}
	.heySomething .commentlist ul li strong {width:120px; height:120px; margin-top:-60px;}
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
		<% if commentcount>0 then %>
			alert("이벤트는 한번만 참여 가능 합니다.");
			return false;
		<% else %>
			if (frm.gubunval.value == ''){
				alert('원하는 항목을 선택해 주세요.');
				return false;
			}
			if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 800){
				alert("코맨트를 남겨주세요.\n한글 400자 까지 작성 가능합니다.");
				frm.txtcomm1.focus();
				return false;
			}
			frm.txtcomm.value = frm.gubunval.value + '!@#' + frm.txtcomm1.value
			frm.action = "/event/lib/doEventComment.asp";
			frm.submit();
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

<% ''[Hey, something project_22] Disney Vintage Edition / 이벤트 코드 69521 %>
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
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/img_slide_01.jpg" alt="" />
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
							itemid   =  1448011
						end if
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="swiper-slide swiper-slide-buy">
						<% ' for dev msg : 상품 링크 %>
						<% if isApp=1 then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1448011&amp;pEtr=69521'); return false;">
						<% else %>
							<a href="/category/category_itemPrd.asp?itemid=1448011&amp;pEtr=69521">
						<% end if %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/img_slide_03_v2.jpg" alt="" />
							<div class="option">
								<em class="name">[꼬까참새] 댄디 삼총사<span>EASY ROUNGEWEAR</span></em>
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
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="[꼬까참새] 댄디 삼총사 구매하러 가기" /></div>
							</div>
						</a>
					</div>
					<% set oItem=nothing %>

					<div class="swiper-slide swiper-slide-buy">
						<ul class="pdtLink">
							<%'' buy2 %>
							<%
								IF application("Svr_Info") = "Dev" THEN
									itemid   =  786868
								else
									itemid   =  1448019
								end if
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
								<li>
								<% ' for dev msg : 상품 링크 %>
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1448019&amp;pEtr=69521'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1448019&amp;pEtr=69521">
								<% end if %>
										<p>[꼬까참새] 심플체크</p>
										<span><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span><!-- for dev msg : 현재 가격 적용될 수 있게 해주세요!(이하동일) -->
									</a>
								</li>
							<% set oItem=nothing %>

							<%'' buy3 %>
							<%
								IF application("Svr_Info") = "Dev" THEN
									itemid   =  279397
								else
									itemid   =  1448019
								end if
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
								<li>
								<% ' for dev msg : 상품 링크 %>
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1448043&amp;pEtr=69521'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1448043&amp;pEtr=69521">
								<% end if %>
										<p>[꼬까참새] 골든아티스트</p>
										<span><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
									</a>
								</li>
							<% set oItem=nothing %>

							<%'' buy4 %>
							<%
								IF application("Svr_Info") = "Dev" THEN
									itemid   =  1158976
								else
									itemid   =  1448019
								end if
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
								<li>
								<% ' for dev msg : 상품 링크 %>
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1448030&amp;pEtr=69521'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1448030&amp;pEtr=69521">
								<% end if %>
										<p>[꼬까참새] 캔디바</p>
										<span><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
									</a>
								</li>
							<% set oItem=nothing %>

							<%'' buy5 %>
							<%
								IF application("Svr_Info") = "Dev" THEN
									itemid   =  1176228
								else
									itemid   =  1445498
								end if
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
								<li>
								<% ' for dev msg : 상품 링크 %>
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1445498&amp;pEtr=69521'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1445498&amp;pEtr=69521">
								<% end if %>
										<p>[꼬까참새] 정글삭스</p>
										<span><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
									</a>
								</li>
							<% set oItem=nothing %>
						</ul>
						<% if isApp=1 then %>
							<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_69521_item.asp?isApp=<%= isApp %>'); return false;">
						<% Else %>
							<a href="/event/etc/hsp/inc_69521_item.asp?isApp=<%= isApp %>" target="_blank">
						<% End If %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/img_slide_04_v2.jpg" alt="MORE ITEMS" />
						</a>
					</div>

					<div class="swiper-slide swiper-slide-info">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/img_slide_05.jpg" alt="" />
						<% ' for dev msg : 사은품 링크 %>
						<% if isApp=1 then %>
							<p class="info"><a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1133678&amp;pEtr=69521'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/img_slide_05_txt.png" alt="이벤트 기간동안 꼬까참새 상품을 5만원 이상 구매하신 모든 분께 스마일조명을 선물로 드립니다. (컬러랜덤)" /></a></p>
						<% else %>
							<p class="info"><a href="/category/category_itemPrd.asp?itemid=1133678&amp;pEtr=69521"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/img_slide_05_txt.png" alt="이벤트 기간동안 꼬까참새 상품을 5만원 이상 구매하신 모든 분께 스마일조명을 선물로 드립니다. (컬러랜덤)" /></a></p>
						<% end if %>
					</div>

					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/img_slide_06.jpg" alt="단조롭고 심심한 일상에서 소소한 즐거움을 드리고 싶었습니다. 눈에 띄는 화려함 대신 입힐수록 손이 가고 마음이 가는 아이들이 있습니다. 간결함과 베이직함 속에 디테일은 놓치지 않은 그 즐거움을 공감하고 소통하며 일상에서의 특별함을 차곡차곡 담아낼 것입니다. / designer 박선영 2016" />
					</div>

					<div class="swiper-slide desc">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/img_slide_07.jpg" alt="" />
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/txt_desc_01.png" alt="" /></p>
					</div>
					<div class="swiper-slide desc">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/img_slide_08.jpg" alt="" />
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/txt_desc_02.png" alt="" /></p>
					</div>
					<div class="swiper-slide desc">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/img_slide_09.jpg" alt="" />
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/txt_desc_03.png" alt="" /></p>
					</div>
					<div class="swiper-slide desc">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/img_slide_10.jpg" alt="" />
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/txt_desc_04.png" alt="" /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/img_slide_11.jpg" alt="우리아이, 우리조카에게 꼭 해주고 싶은 말이 있나요? 정성껏 코멘트를 남겨주신 3분을 추첨하여, 꼬까참새의 신상 내의와 양말을 드립니다. (코멘트 작성시 사이즈,성별 꼭 기재해주시기 바랍니다) / 기간 : 2016.03.09 ~ 03.15 / 발표 : 03.16" /></p>
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
			<% if isApp=1 then %>
				<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_69521_item.asp?isApp=<%= isApp %>'); return false;">
			<% Else %>
				<a href="/event/etc/hsp/inc_69521_item.asp?isApp=<%= isApp %>" target="_blank">
			<% End If %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" /></a>
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
				<legend>TOGETHER SPRING! 코멘트 쓰기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/txt_comment.png" alt="가장 마음에 드는 디즈니 노트 활용법과 그 이유를 코멘트로 남겨주세요. 정성껏 코멘트를 남겨주신 5분을 추첨하여 Disney vintage Note set를 증정합니다. 코멘트 작성기간은 2016년 3월 2일부터 3월 8일까지며, 발표는 3월 14일 입니다." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/ico_01.png" alt="EASY" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/ico_02.png" alt="FUN" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/ico_03.png" alt="PRESENT" /></button>
							</li>
							<li class="ico4">
								<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/ico_04.png" alt="TOGETHER" /></button>
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
									EASY
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="2" then %>
									FUN
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="3" then %>
									PRESENT
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="4" then %>
									TOGETHER
								<% Else %>
									EASY
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
						<div class="date"><span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span> / <span><%= FormatDate(arrCList(4,intCLoop),"0000.00.00") %></span> 
						<% If arrCList(8,i) <> "W" Then %>
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
	<%'' //comment event %>

	<div id="dimmed"></div>
</div>
<%'' //[Hey, something project_23] %>

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
			$(".swiper-slide-active.swiper-slide-info").find(".info").delay(100).animate({"width":"100%", "opacity":"1"},500);

			$(".swiper-slide.desc").find("p").delay(100).animate({"margin-left":"3%", "opacity":"0"},400);
			$(".swiper-slide-active.desc").find("p").delay(50).animate({"margin-left":"0", "opacity":"1"},300);
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