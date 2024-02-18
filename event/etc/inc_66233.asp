<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 2
' History : 2015.09.15 한용민 생성
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
	'currenttime = #09/16/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  64885
Else
	eCode   =  66233
End If

dim userid, i
	userid = GetEncLoginUserID()

dim commentcount
commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim itemid
IF application("Svr_Info") = "Dev" THEN
	itemid   =  1239115
Else
	itemid   =  1354701
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

.item {overflow:hidden; position:absolute; top:15%; left:50%; z-index:100; width:97.6%; margin-left:-48.8%;}
.item li {float:left; width:50%; margin-bottom:2.5%;}
.item li a {overflow:hidden; display:block; position:relative; height:0; margin:0 5%; padding-bottom:80.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.item li a span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter: alpha(opacity=0); cursor:pointer;}

/* item */
.heySomething .swiper-slide-buy .option {position:absolute; top:56%; left:0; width:100%; text-align:center;}

/* brand */
.heySomething .swiper-slide-brand .brand {position:absolute; top:5%; left:0; width:100%;}
.heySomething .swiper-slide-brand .brand p {margin-top:7%;}

/* comment */
.heySomething .form .choice li button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/66233/m/bg_ico.png); background-size:348px auto;}

.heySomething .commentlist ul li strong {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/66233/m/bg_ico.png); background-size:348px auto;}

@media all and (min-width:480px){
	.heySomething .form .choice li button {background-size:522px auto;}

	.heySomething .commentlist ul li strong {background-size:522px auto;}
}

@media all and (min-width:768px){
	.heySomething .form .choice li button {background-size:696px auto;}
	
	.heySomething .commentlist ul li strong {background-size:696px auto;}
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
		<% If not( left(currenttime,10)>="2015-09-16" and left(currenttime,10)<"2015-10-07" ) Then %>
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
</head>
<body>

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
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/img_slide_01.jpg" alt="Hey, something project DESIGN FINGERS VOL.2" /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/img_slide_02.png" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>

					<!-- for dev msg : 9/9~9/16까지 할인 -->
					<div class="swiper-slide swiper-slide-buy">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/img_slide_03.jpg" alt="" />
						<div class="option">
							<% if isApp then %>
								<a href="" onclick="fnAPPpopupProduct('1354701'); return false;">
							<% else %>
								<a href="/category/category_itemPrd.asp?itemid=1354701">
							<% end if %>
								
								<%
								'<!--img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/img_animation.gif" alt="" /-->
								'<!-- for dev msg : 9/9~9/16까지 할인 / 종료 후 <strong class="discount">....</strong>숨겨 주시고 
								'<div class="price">...</div>에는 클래스 priceEnd을 붙이고 <del>....<del>숨겨주세요 -->
								%>
								<% if oItem.FResultCount > 0 then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<% If oItem.Prd.FOrgprice = 0 Then %>
										<% else %>
											<strong class="discount">텐바이텐에서만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
										<% end if %>

										<em class="name">VWMS-STANDING <span>BURGUNDY</span></em>
										<div class="price">
											<del><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></del>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% else %>
										<em class="name">VWMS-STANDING <span>BURGUNDY</span></em>
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
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/img_slide_04.jpg" alt="새롭게 내딛는 당신의 걸음에 세심한 배려를 더합니다. 이 심플한 슈즈에 어떠한 특별한 감성이 담겨 있는지 확인하세요." />
						<ul class="item">
							<% if isApp then %>
								<li><a href="" onclick="fnAPPpopupProduct('1354701'); return false;"><span></span>WHITE</a></li>
								<li><a href="" onclick="fnAPPpopupProduct('1354701'); return false;"><span></span>HEIGE</a></li>
								<li><a href="" onclick="fnAPPpopupProduct('1354701'); return false;"><span></span>RED BROWN</a></li>
								<li><a href="" onclick="fnAPPpopupProduct('1354701'); return false;"><span></span>BLACK</a></li>
							<% else %>
								<li><a href="/category/category_itemPrd.asp?itemid=1354701"><span></span>WHITE</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1354701"><span></span>HEIGE</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1354701"><span></span>RED BROWN</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1354701"><span></span>BLACK</a></li>
							<% end if %>
						</ul>
					</div>

					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/img_slide_05.jpg" alt="SIZE INFO 210mm-270mm 발볼 1-3단계 굽높이 3.5cm" />
					</div>
					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/img_slide_06.jpg" alt="Just love, simple and high quality" />
					</div>
					<div class="swiper-slide swiper-slide-brand">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/img_slide_07.jpg" alt="" />
						<div class="brand">
							<p class="letter1"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/txt_plan_01.png" alt="veronica For LONDON" /></p>
							<p class="letter2"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/txt_plan_02.png" alt="디자이너 아내의 세례명 veronica와 결혼 직 후, 런던으로 떠난 2년간의 신혼여행에서 얻은 영감을 바탕으로 탄생한 브랜드입니다. 런던의 작은 공방에서 어느 60대 노인이 생일을 맞이 한 아내를 위해 플랫 슈즈를 만들고 있는 모습에서 감동을 받게 됩니다." /></p>
							<p class="letter3"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/txt_plan_03.png" alt="결국 그곳에서 얻은 영감을 바탕으로 아기를 가진 아내가 힐을 신지 못하게 되자 평소에 신고 싶어 했던 영국 남성의 comfortable classic shoes를 여성화에 맞게 디자인하여 지금의 베로니카 포 런던이 탄생하게 되었습니다." /></p>
						</div>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/img_slide_08.jpg" alt="모든 것의 시작은 사랑이다. 아기를 가진 아내가 힐을 신지 못하게 되어 만든 Comfortable Classic Shoes." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/img_slide_09.jpg" alt="자체 개발한 라텍스 중창과 자연 친화적인 소재를 사용하여 제작합니다." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/img_slide_10.jpg" alt="부드러운 가죽과 현대적인 스포티 아웃솔을 매치하여 베로니카의 활동성을 고려하였습니다." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/img_slide_11.jpg" alt="기성화에 발을 맞추느라 지친 당신을 위해. 3단계로 선택할 수 있는 발볼 사이즈로 조금 더 편안해지세요." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/img_slide_12.jpg" alt="발 끝으로 서로를 느끼다. 유행에 구애받지 않는 디자인과 편안함으로 소중한 이와 함께 신을 수 있습니다." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/img_slide_13.jpg" alt="좋은 곳으로, 향기가 가득한 길로 데려가 줄 좋은 신발입니다. 오랫동안 함께 가는 신발을 선물하세요." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/img_slide_14.jpg" alt="세상에 변하지 않는 것이 있다면... veronica For LONDON" /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/img_slide_15.png" alt="정성껏 코멘트를 남겨주신 1분을 추첨하여 베로니카포런던의 VWMS-STANDING을 선물로 드립니다. 코멘트 작성시 희망하는 사이즈, 발볼 단계, 컬러는 꼭 기재해주세요. 기간은 2015년 9월 16일부터 10월 6일까지며, 발표는 10월 8일 입니다." /></p>
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
		<div class="btnget">
			<% if isApp then %>
				<% IF application("Svr_Info") = "Dev" THEN %>
					<a href="" onclick="fnAPPpopupBrowserURL('구매하기','http://testm.10x10.co.kr/event/etc/inc_66233_item.asp?isApp=<%= isApp %>'); return false;" >
				<% Else %>
					<a href="" onclick="fnAPPpopupBrowserURL('구매하기','http://m.10x10.co.kr/event/etc/inc_66233_item.asp?isApp=<%= isApp %>'); return false;" >
				<% End If %>
			<% else %>
				<a href="/event/etc/inc_66233_item.asp?isApp=<%= isApp %>" target="_blank" >
			<% end if %>
			
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/btn_get.png" alt="BUY" /></a>
		</div>
	</div>
	<!-- //main contents -->

	<!-- comment event -->
	<div id="commentevt" class="section commentevt">
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
		<div class="form">
			<fieldset>
			<legend>갖고 싶은 활용도 선택하고 코멘트 쓰기</legend>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/txt_comment_v1.png" alt="정성껏 코멘트를 남겨주신 1분을 추첨하여 베로니카포런던의 VWMS-STANDING을 선물로 드립니다. 코멘트 작성시 희망하는 사이즈, 발볼 단계, 컬러는 꼭 기재해주세요. 기간은 2015년 9월 16일부터 10월 6일까지며, 발표는 10월 8일 입니다." /></p>
				<div class="inner">
					<ul class="choice">
						<li class="ico1"><button type="button" value="1">Love</button></li>
						<li class="ico2"><button type="button" value="2">Well</button></li>
						<li class="ico3"><button type="button" value="3">Active</button></li>
						<li class="ico4"><button type="button" value="4">Relax</button></li>
						<li class="ico5"><button type="button" value="5">Together</button></li>
						<li class="ico6"><button type="button" value="6">Present</button></li>
					</ul>
					<div class="field">
						<textarea name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="" cols="60" rows="5"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
						<input type="submit" onclick="jsSubmitComment(document.frmcom); return false;" value="응모하기" class="btnsubmit" />
					</div>
				</div>
			</fieldset>
		</div>
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

		<!-- for dev msg : comment list -->
		<div class="commentlist"  id="commentlist">
			<div class="total">total <%= iCTotCnt %></div>
			
			<% IF isArray(arrCList) THEN %>
				<ul>
					<% For intCLoop = 0 To UBound(arrCList,2) %>
					<li>
						<% if isarray(split(arrCList(1,intCLoop),"!@#")) then %>
							<strong class="ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>">
								<% if split(arrCList(1,intCLoop),"!@#")(0)="1" then %>
									채우기
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="2" then %>
									담기
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="3" then %>
									여유갖기
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="4" then %>
									쉬어가기
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="5" then %>
									비우기
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="6" then %>
									다가가기
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="7" then %>
									시간보내기
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
								<span class="button btS1 btWht cBk1"><button onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;" type="button">삭제</button></span>
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
			$(".swiper-slide").find(".brand .letter1").delay(100).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide").find(".brand .letter2").delay(300).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide").find(".brand .letter3").delay(500).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide-active").find(".brand .letter1").delay(50).animate({"margin-top":"6%", "opacity":"1"},600);
			$(".swiper-slide-active").find(".brand .letter2").delay(50).animate({"margin-top":"6%", "opacity":"1"},600);
			$(".swiper-slide-active").find(".brand .letter3").delay(50).animate({"margin-top":"6%", "opacity":"1"},600);
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