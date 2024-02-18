<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 9
' History : 2015.10.27 원승현 생성
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
	eCode   =  65941
Else
	eCode   =  67157
End If

dim userid, i
	userid = GetEncLoginUserID()

dim commentcount
commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim itemid
IF application("Svr_Info") = "Dev" THEN
	itemid   =  1239115
Else
	itemid   =  1378143
End If

dim oItem
set oItem = new CatePrdCls
	oItem.GetItemData itemid

dim itemid2, itemid3
IF application("Svr_Info") = "Dev" THEN
	itemid2   =  1239115
	itemid3   =  1239115
Else
	itemid2   =  1378234
	itemid3   =  1378199
End If
   
dim oItem2
set oItem2 = new CatePrdCls
	oItem2.GetItemData itemid2

dim oItem3
set oItem3 = new CatePrdCls
	oItem3.GetItemData itemid3

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

/* title */
.heySomething .swiper-slide .hey {position:absolute; top:6%; left:0; width:100%;}

/* buy */
.heySomething .swiper-slide-buy .option {width:100%; text-align:center;}
.heySomething .swiper-slide-buy .option a {display:block;}
.heySomething .swiper-slide-buy .option .discount {margin-top:3%;}

/* item */
.heySomething .siwper-slide-item .item {overflow:hidden; position:absolute; top:15%; left:50%; width:98%; margin-left:-49%;}
.heySomething .siwper-slide-item .item ul li {float:left; width:50%; margin-bottom:7%;}
.heySomething .siwper-slide-item .item ul li a {overflow:hidden; display:block; position:relative; height:0; margin:0 8%; padding-bottom:76.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.heySomething .siwper-slide-item .item ul li a span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter: alpha(opacity=0); cursor:pointer;}

/* brand */
.heySomething .swiper-slide-brand .brand {position:absolute; top:40%; left:0; width:100%;}
.heySomething .swiper-slide-brand .brand p {margin-top:7%;}

/* story */
.heySomething .swiper-slide .desc {position:absolute; bottom:12.6%; left:0; width:100%;}

/* finish */
.heySomething .swiper-slide .finish {position:absolute; top:9%; left:0; width:100%;}

/* comment */
.heySomething .form .choice li {width:33.333%; height:auto !important; margin:0; padding:0 8% 4% 0;}
.heySomething .form .choice li button {width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% auto;}
.heySomething .form .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_01.png);}
.heySomething .form .choice li.ico1 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_01_on.png);}
.heySomething .form .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_02.png);}
.heySomething .form .choice li.ico2 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_02_on.png);}
.heySomething .form .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_03.png);}
.heySomething .form .choice li.ico3 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_03_on.png);}
.heySomething .form .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_04.png);}
.heySomething .form .choice li.ico4 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_04_on.png);}
.heySomething .form .choice li.ico5 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_05.png);}
.heySomething .form .choice li.ico5 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_05_on.png);}
.heySomething .form .choice li.ico6 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_06.png);}
.heySomething .form .choice li.ico6 button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_06_on.png);}

.heySomething .commentlist ul li {position:relative; min-height:91px; padding:15px 0 15px 78px;}
.heySomething .commentlist ul li strong {position:absolute; top:50%; left:0; width:61px; height:61px; margin-top:-29px; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% auto;}
.heySomething .commentlist ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_01.png);}
.heySomething .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_02.png);}
.heySomething .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_03.png);}
.heySomething .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_04.png);}
.heySomething .commentlist ul li .ico5 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_05.png);}
.heySomething .commentlist ul li .ico6 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_06.png);}

@media all and (min-width:480px){
	.heySomething .commentlist ul li {min-height:135px; padding:22px 0 22px 135px;}
	.heySomething .commentlist ul li strong {width:91px; height:91px; margin-top:-45px;}
}

@media all and (min-width:768px){
	.heySomething .commentlist ul li {min-height:166px; padding:22px 0 22px 135px;}
	.heySomething .commentlist ul li strong {width:122px; height:122px; margin-top:-58px;}
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
	window.$('html,body').animate({scrollTop:$(".mEvt67157").offset().top}, 0);
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
		<% If not( left(currenttime,10)>="2015-11-04" and left(currenttime,10)<"2015-11-12" ) Then %>
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
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 2000){
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
	<%' main contents %>
	<div class="section article">
		<%' swiper %>
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_slide_01.jpg" alt="" />
						<strong class="hey"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/tit_hey_something_project.png" alt="Hey, something project" /></strong>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>

					<%' buy %>
					<div class="swiper-slide swiper-slide-buy">
						<!-- for dev msg : 상품 링크 -->
						<% If isapp="1" Then %>
							<a href="" onclick="fnAPPpopupProduct('1378164'); return false;">
						<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=1378164">
						<% End If %>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_slide_03.jpg" alt="Motherpiano X thence" /></p>
							<div class="option">
								<% 
									'for dev msg : 구매하기 10/21~10/27까지 할인 / 종료 후 <strong class="discount">....</strong>숨겨 주시고 
									'<div class="price">...</div>에는 클래스 priceEnd을 붙이고 <s>....<s>숨겨주세요 
								%>
								<% if oItem.FResultCount > 0 then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<% If oItem.Prd.FOrgprice = 0 Then %>
										<% else %>
											<strong class="discount">텐바이텐에서만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
										<% End If %>
										<em class="name">미러리스카메라 클러치백<span>MATE</span></em>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<em class="name">미러리스카메라 클러치백<span>MATE</span></em>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
								<% End If %>
								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_buy.png" alt="카메라케이스 구매하러 가기" /></div>
							</div>
						</a>
					</div>

					<%' item %>
					<div class="swiper-slide siwper-slide-item">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_slide_04.jpg" alt="간만에 바꾼 네일 컬러처럼 계속 꺼내 보고 싶은 기분 좋은 변화 손으로 쥐었을 때 더욱 아름다운 이 케이스가 당신의 스타일을 어떻게 완성하는지 확인해보세요" />
						<%' for dev msg : 상품 링크 %>
						<div class="item">
							<ul>
								<li>
									<% If isapp="1" Then %>
										<a href="" onclick="fnAPPpopupProduct('1378164'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1378164">
									<% End If %>
										<span></span>미러리스카메라 클러치백_MATE
									</a>
								</li>
								<li>
									<% If isapp="1" Then %>
										<a href="" onclick="fnAPPpopupProduct('1378143'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1378143">
									<% End If %>
										<span></span>미러리스카메라 클러치백_EVERYONE ENJOY
									</a>
								</li>
								<li>
									<% If isapp="1" Then %>
										<a href="" onclick="fnAPPpopupProduct('1378234'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1378234">
									<% End If %>
										<span></span>Sony a5000 / a5100 속사케이스_MATE
									</a>
								</li>
								<li>
									<% If isapp="1" Then %>
										<a href="" onclick="fnAPPpopupProduct('1378228'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1378228">
									<% End If %>
										<span></span>Sony a5000 / a5100 속사케이스_EVERYONE ENJOY
									</a>
								</li>
							</ul>
						</div>
					</div>

					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_slide_05.jpg" alt="DETAIL" /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_slide_06.jpg" alt="DETAIL" /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_slide_07.jpg" alt="DETAIL" /></p>
					</div>


					<%' brand %>
					<div class="swiper-slide swiper-slide-brand">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_slide_08.jpg" alt="" />
						<div class="brand">
							<p class="letter1"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/txt_brand_01.png" alt="마더 피아노와 덴스의 새로운 시각 혹은 시작으로 만들어진 '당신의 시간'" /></p>
							<p class="letter2"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/txt_brand_02.png" alt="당신의 일상에 inspiration을 드리는 카메라 감성 브랜드 마더피아노와, 새로운 시작을 모토로 생각과 변화를담는 제품을 디자인하는 덴스가 만났습니다" /></p>
							<p class="letter3"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/txt_brand_03.png" alt="당신의 순간의 기억이 더욱 좋은 추억으로 남도록 즐겁게 제작되었습니다." /></p>
						</div>
					</div>

					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_slide_09.jpg" alt="" />
						<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/txt_desc_01.png" alt="함께 걷던 그 거리의 느낌, 분위기 모두 다 사진 한 컷에 담고 싶을만큼, 너와 함께 하는 시간이 소중해" /></p>
					</div>
					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_slide_10.jpg" alt="" />
						<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/txt_desc_02.png" alt="약속이 있는 날 뭘 입을지 이렇게 저렇게 고민해봐도 잘 어울리는 데일리 아이템 하나만 있어도 왠지 기분이 좋아요." /></p>
					</div>
					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_slide_11.jpg" alt="" />
						<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/txt_desc_03.png" alt="웃고 떠드는 그 순간을 더욱 의미있게 기념일이 더욱 즐거웠던 날로 기억될거에요." /></p>
					</div>
					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_slide_12.jpg" alt="" />
						<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/txt_desc_04.png" alt="어릴적 추억부터 지금의 순간까지 당신 대신해서 기억해 줄게요!" /></p>
					</div>
					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_slide_13.jpg" alt="" />
						<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/txt_desc_05.png" alt="한개씩 다른 컨셉 다른 디자인 콜라보 상품 모두를 모으는 재미를 느껴보세요!" /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_slide_14.jpg" alt="" /></p>
						<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/txt_desc_06.png" alt="새로운 세계로의 여행도 함께 한다면 더욱 즐거운 여행이 될 수 있을거에요~" /></p>
					</div>

					<div class="swiper-slide">
						<strong class="finish"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/txt_finish.png" alt="작은 우쿨렐레가  들려주는 기분 좋은 노래 Shaun the Sheep" /></strong>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_slide_15.jpg" alt="" />
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_slide_16.jpg" alt="정성껏 코멘트를 남겨주신 1분을 추첨하여 마더피아노X덴스 카메라 케이스 세트를 선물로 드립니다. 옵션은 랜덤으로 배송됩니다. 기간은 2015년 11월 4일부터 11월 11일까지며, 발표는 11월 12일 입니다." /></p>
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
		<%'  for dev msg : 구매하기 버튼 클릭시 페이지 http://testm.10x10.co.kr/event/inc_66855_item.asp %>
		<div class="btnget">
			<% if isApp then %>
				<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/inc_67157_item.asp?isApp=<%= isApp %>'); return false;" >
			<% else %>
				<a href="/event/etc/inc_67157_item.asp?isApp=<%= isApp %>" target="_blank">
			<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/common/m/btn_get.png" alt="BUY" />
			</a>
		</div>
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
					<legend>Motherpiano X thence 코멘트 쓰기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/txt_comment.png" alt="정성껏 코멘트를 남겨주신 1분을 추첨하여 마더피아노X덴스 메라 케이스 세트를 선물로 드립니다. 옵션은 랜덤으로 배송됩니다. 기간은 2015년 11월 4일부터 11월 11일까지며, 발표는 11월 12일 입니다." /></p>
					<div class="inner">
						<ul class="choice">
							<li class="ico1">
								<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_01.png" alt="MATE" /></button>
							</li>
							<li class="ico2">
								<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_02.png" alt="STYLE" /></button>
							</li>
							<li class="ico3">
								<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_03.png" alt="ENJOY" /></button>
							</li>
							<li class="ico4">
								<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_04.png" alt="MEMORY" /></button>
							</li>
							<li class="ico5">
								<button type="button" value="5"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_05.png" alt="COLLECTION" /></button>
							</li>
							<li class="ico6">
								<button type="button" value="6"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/ico_06.png" alt="TRAVEL" /></button>
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
									MATE
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="2" then %>
									STYLE
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="3" then %>
									ENJOY
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="4" then %>
									MEMORY
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="5" then %>
									COLLECTION
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="6" then %>
									TRAVEL
								<% Else %>
									MATE
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
	<%' //comment event %>

	<div id="dimmed"></div>
</div>


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
		onSlideChangeStart: function (mySwiper) {
			var vActIdx = parseInt(mySwiper.activeIndex);
			if (vActIdx<=0) {
				vActIdx = mySwiper.slides.length-2;
			} else if(vActIdx>(mySwiper.slides.length-2)) {
				vActIdx = 1;
			}
			$(".pagingNo .page strong").text(vActIdx);
			$(".swiper-slide").find(".brand .letter1").delay(100).animate({"margin-top":"8%", "opacity":"0"},200);
			$(".swiper-slide").find(".brand .letter2").delay(200).animate({"margin-top":"8%", "opacity":"0"},200);
			$(".swiper-slide").find(".brand .letter3").delay(300).animate({"margin-top":"8%", "opacity":"0"},200);
			$(".swiper-slide").find(".brand .letter4").delay(400).animate({"margin-top":"8%", "opacity":"0"},200);
			$(".swiper-slide-active").find(".brand .letter1").delay(50).animate({"margin-top":"7%", "opacity":"1"},400);
			$(".swiper-slide-active").find(".brand .letter2").delay(50).animate({"margin-top":"7%", "opacity":"1"},400);
			$(".swiper-slide-active").find(".brand .letter3").delay(50).animate({"margin-top":"7%", "opacity":"1"},400);
			$(".swiper-slide-active").find(".brand .letter4").delay(50).animate({"margin-top":"7%", "opacity":"1"},400);

			$(".swiper-slide").find(".hey").delay(100).animate({"top":"6%", "opacity":"0"},300);
			$(".swiper-slide-active").find(".hey").delay(50).animate({"top":"0", "opacity":"1"},600);
			$(".swiper-slide").find(".finish").delay(100).animate({"top":"9.5%", "opacity":"0"},300);
			$(".swiper-slide-active").find(".finish").delay(50).animate({"top":"7.5%", "opacity":"1"},600);

			$(".swiper-slide").find(".desc").delay(100).animate({"bottom":"11%", "opacity":"0"},300);
			$(".swiper-slide-active").find(".desc").delay(50).animate({"bottom":"12.6%", "opacity":"1"},600);
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
<%
set oItem=nothing
set oItem2=nothing
set oItem3=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->