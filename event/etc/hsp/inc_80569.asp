<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : hey, something project 시리즈 88
' 언제 어디서나,편안하게,당신곁에
' History : 2017-09-19 정태훈 생성
'###########################################################
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
	eCode   =  66431
Else
	eCode   =  80569
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
.finish-event {display:none;}

.hsp-topic h2 {color:#fff;}
.heySomethingV17 .hps-brand {position:relative;}
.heySomethingV17 .hps-brand p {position:absolute; bottom:11.56%; left:14.15%; width:71.7%; }

.heySomethingV17 .hsp-buy .option .name i {font-family:serif;}
.heySomethingV17 .hsp-buy .option .only10 {width:21.6%; height:1.9rem; margin:0 auto .85rem; background-color:#000; font-size:1rem; color:#fff; line-height:1.9rem; font-weight:bold;}
.heySomethingV17 .hsp-buy .option .price {margin-top:.9rem; font-size:1.5rem;}
.heySomethingV17 .hsp-buy .option .price s {display:inline-block; font-size:1.2rem; font-weight:bold;}
.heySomethingV17 .hsp-buy .option .txt {padding-top:1.6rem; font-size:1rem; line-height:1.3rem;}
.heySomethingV17 .article .btn-go{margin-top:2.5rem;}

.heySomethingV17 .hsp-finish p {font-weight:bold;}
.heySomethingV17 .hsp-finish .txt1 {width:73.125%; font-size:1.4rem; line-height:1.88rem; letter-spacing:0.1rem; padding:1.8rem 0 1.6rem;}
.heySomethingV17 .hsp-finish .txt1 b{font-size:1.7rem; line-height:2.2rem;}
.heySomethingV17 .hsp-finish .txt2 {padding-top:2.3rem;}
.heySomethingV17 .hsp-finish .txt3 {padding-top:2.2rem; font-size:1.2rem; font-weight:normal;}

.heySomethingV17 .comment-write {padding:0 2rem;}
.heySomethingV17 .comment-write h3 {padding:0 .5rem; line-height:2.4rem;}
.heySomethingV17 .comment-write h3 span {padding-bottom:1.2rem;}
.heySomethingV17 .comment-write .date {padding:.5rem 0 .5rem .5rem;}
.heySomethingV17 .comment-write .txt {padding:1.2rem .5rem .9rem; line-height:1.5;}
.heySomethingV17 .comment-write .choice {padding:1.1rem 0 0;}
.heySomethingV17 .comment-write .choice li {width:5.8rem; margin-right:1.2rem;}
.heySomethingV17 .comment-write .choice li:last-child {margin-right:0;}
.heySomethingV17 .comment-write .choice li.on:before {width:100%; height:100%; border-radius:50%; background-color:rgba(134, 164, 55,0.5);}
.heySomethingV17 .comment-write .choice li.ico2.on:before {background-color:rgba(205, 129, 81,0.5);}
.heySomethingV17 .comment-write .choice li.ico3.on:before {background-color:rgba(98, 100, 146,0.5);}

.heySomethingV17 .comment-evt .ico {left:.6rem;}
.heySomethingV17 .comment-evt .comment-list .ico {width:5.8rem; height:5.8rem; margin-top:-2.9rem;}
.heySomethingV17 .comment-evt .comment-list li {min-height:8rem; padding-left:7.7rem;}
</style>
<script type="text/javascript">
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
		<% If not( left(currenttime,10)>="2017-09-20" and left(currenttime,10)<"2017-09-27" ) Then %>
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
			<div class="heySomethingV17">
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
								<!-- topic -->
								<div class="swiper-slide hsp-topic">
									<h2>Hey,<br /><b>something</b><br />project</h2>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80569/m/img_represent.jpg" alt="카렌 화이트" /></div>
								</div>

								<!-- about -->
								<div class="swiper-slide hsp-about">
									<h3>About</h3>
									<p class="txt1">Hey,<br />something<br />project</p>
									<p class="txt2">텐바이텐만의 시각으로<br />주목해야 할 상품을 선별해 소개하고<br />새로운 트렌드를 제안하는<br />ONLY 텐바이텐만의 프로젝트</p>
								</div>

								<div class="swiper-slide hps-brand"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80569/m/txt_brand.jpg" alt="karen white 클래식한 디자인에 고급스러운 소재와 섬세한 디테일, 꼼꼼한 마무리와 공정에 집중한 디자이너 슈즈 브랜드 입니다. " /></div>
								<%
									Dim itemid, oItem
									IF application("Svr_Info") = "Dev" THEN
										itemid = 786868
									Else
										itemid = 1789493
									End If
									set oItem = new CatePrdCls
										oItem.GetItemData itemid
								%>
								<div class="swiper-slide hsp-buy">
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1789493&amp;pEtr=80569'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1789493&pEtr=80569">
									<% End If %>
										<div class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80569/m/img_prd1.jpg" alt="School 블랙" /></div>
										<div class="option">
											<p class="only10">ONLY 10X10</p>
											<p class="name">School 블랙</p>
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
												<div class="price">
													<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong>
												</div>
												<% else %>
												<div class="price priceEnd">
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
												<% end if %>
											 <% end if %>
											<div class="btn-go">구매하러 가기<i></i></div>
										</div>
									</a>
								</div>
								<% set oItem = nothing %>
								<%
									IF application("Svr_Info") = "Dev" THEN
										itemid = 786868
									Else
										itemid = 1789494
									End If
									set oItem = new CatePrdCls
										oItem.GetItemData itemid
								%>
								<!-- buy -->
								<div class="swiper-slide hsp-buy">
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1789494&amp;pEtr=80569'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1789494&pEtr=80569">
									<% End If %>
										<div class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80569/m/img_prd2.jpg" alt="Tomorrow 브라운" /></div>
										<div class="option">
											<p class="only10">ONLY 10X10</p>
											<p class="name">Tomorrow 브라운</p>
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
												<div class="price">
													<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong>
												</div>
												<% else %>
												<div class="price priceEnd">
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
												<% end if %>
											 <% end if %>
											<div class="btn-go">구매하러 가기<i></i></div>
										</div>
									</a>
								</div>
								<% set oItem = nothing %>
								<%
									IF application("Svr_Info") = "Dev" THEN
										itemid = 786868
									Else
										itemid = 1789492
									End If
									set oItem = new CatePrdCls
										oItem.GetItemData itemid
								%>
								<div class="swiper-slide hsp-buy">
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1789492&amp;pEtr=80569'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1789492&pEtr=80569">
									<% End If %>
										<div class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80569/m/img_prd3.jpg" alt="Today 블랙" /></div>
										<div class="option">
											<p class="only10">ONLY 10X10</p>
											<p class="name">Today 블랙</p>
											<% If oItem.FResultCount > 0 then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
												<div class="price">
													<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong>
												</div>
												<% else %>
												<div class="price priceEnd">
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
												<% end if %>
											 <% end if %>
											<div class="btn-go">구매하러 가기<i></i></div>
										</div>
									</a>
								</div>
								<% set oItem = nothing %>
								<div class="swiper-slide hsp-collabo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80569/m/txt_collabo.jpg" alt="꾸미지 않은 듯한 내츄럴함 편안한 착화감 합리적인 럭셔리 karen white ENBYTEN" /></div>

								<!-- story -->
								<div class="swiper-slide hsp-desc">
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80569/m/img_story_1.jpg" alt="" /></div>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80569/m/txt_desc_1.png" alt="#Comfort 편안한 착화감을 우선으로 생각합니다 " /></p>
								</div>
								<div class="swiper-slide hsp-desc">
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80569/m/img_story_2.jpg" alt="" /></div>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80569/m/txt_desc_2.png" alt="#Natural 어디에나 신어도 자연스럽게 어울리는 디자인 " /></p>
								</div>
								<div class="swiper-slide hsp-desc">
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80569/m/img_story_3.jpg" alt="" /></div>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80569/m/txt_desc_3.png" alt="#Luxury 고급스럽지만 부담스럽지 않은 합리적인 가격 " /></p>
								</div>

								<div class="swiper-slide hsp-gallery">
									<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80569/m/img_gallery.jpg" alt="언제 어디서나 편안하게 당신곁에 karen white" />
								</div>

								<!-- comment Evt -->
								<div class="swiper-slide hsp-finish">
									<p class="txt1"><span>Hey, something project</span><b>당신은 어떤 구두를<br/ >좋아하시나요?</b></p>
									<p class="txt2">텐바이텐 X 카렌화이트 상품을 보고<br/ >마음에 드는 상품 이름과, 마음에 드는 이유를<br/ >남겨주세요! 정성스러운 댓글을 남겨주신<br/ >3분을 선정해 텐바이텐 상품권 1만원권을 선물로 드립니다.</p>
									<p class="txt3">기간 : 2017.09.20 ~ 09.26 / 발표 : 09.27</b></p>
									<a href="#comment-evt" class="btn-go">응모하러 가기<i></i></a>
								</div>
							</div>
						</div>
						<div class="pagingNo">
							<p class="page"><strong></strong>/<span></span></p>
						</div>
						<button type="button" class="btn-nav prev"><span>이전</span></button>
						<button type="button" class="btn-nav next"><span>다음</span></button>
					</div>
					<!-- for dev msg 구매버튼 http://testm.10x10.co.kr/html/event/hey/80569_get.asp 연결 -->
					<div class="btn-get">
						<% if isApp=1 then %>
							<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_80569_item.asp?isApp=<%= isApp %>'); return false;" title="구매하러 가기" class="mApp">BUY<i></i></a>
						<% else %>
							<a href="/event/etc/hsp/inc_80569_item.asp?isApp=<%= isApp %>" title="구매하러 가기" class="mWeb">BUY<i></i></a>
						<% end if %>
					</div>
				</div>
				<!-- //main contents -->

				<!-- comment event -->
				<div id="comment-evt" class="section comment-evt">
					<!-- for dev msg : comment write -->
					<div class="comment-write">
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
								<h3><span>Hey, something project</span>당신은 어떤 구두를<br/ >좋아하시나요?</h3>
								<p class="txt">텐바이텐 X 카렌화이트 상품을 보고 마음에 드는<br/ >상품 이름과, 마음에 드는 이유를 남겨주세요!<br/ >정성스러운 댓글을 남겨주신 3분을 선정해 텐바이텐<br/ >1만원권 상품권을 드립니다! </p>
								<p class="date">기간 : 2017.09.20 ~ 09.26 / 발표 : 09.27</p>
								<div class="inner">
									<ul class="choice">
										<li class="ico ico1">
											<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80569/m/bg_ico_1.png" alt="Comfort" /></button>
										</li>
										<li class="ico ico2">
											<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80569/m/bg_ico_2.png" alt="Natural" /></button>
										</li>
										<li class="ico ico3">
											<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80569/m/bg_ico_3.png" alt="Luxury" /></button>
										</li>
									</ul>
									<div class="field">
										<textarea title="코멘트 작성" cols="60" rows="5" name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="코멘트 작성" cols="60" rows="5"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
										<input type="submit" value="응모하기" class="btnsubmit" onclick="jsSubmitComment(document.frmcom); return false;" />
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
					<div class="comment-list">
						<p class="total">total <%=iCTotCnt%></p>
						<% IF isArray(arrCList) THEN %>
						<ul>
							<% For intCLoop = 0 To UBound(arrCList,2) %>
							<li>
								<% If isarray(split(arrCList(1,intCLoop),"!@#")) Then %>
								<div class="ico ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>">
								<strong>
								<% If split(arrCList(1,intCLoop),"!@#")(0)="1" Then %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80461/m/bg_ico_1.png" alt="Comfort" />
								<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80461/m/bg_ico_2.png" alt="Natural" />
								<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80461/m/bg_ico_3.png" alt="Luxury" />
								<% Else %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80461/m/bg_ico_1.png" alt="Comfort" />
								<% End If %>
								</strong>
								</div>
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
									<% End If %>
									<p class="date"><span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span> / <span><%= FormatDate(arrCList(4,intCLoop),"0000.00.00") %></span><% If arrCList(8,intCLoop) <> "W" Then %> <span class="mob">모바일에서 작성</span><% End If %></p>
								</div>
							</li>
							<% next %>
						</ul>
						<% end if %>
						<div class="paging">
							<% IF isArray(arrCList) THEN %>
							<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
							<% end if %>
						</div>
					</div>
				</div>
				<!-- //comment event -->

				<div id="dimmed"></div>
			</div>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		//initialSlide:9,
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		speed:800,
		autoplay:false,
		nextButton:'.next',
		prevButton:'.prev',
		autoplayDisableOnInteraction:false,
		onSlideChangeStart: function (mySwiper) {
			var vActIdx = parseInt(mySwiper.activeIndex);
			if (vActIdx<=0) {
				vActIdx = mySwiper.slides.length-2;
			} else if(vActIdx>(mySwiper.slides.length-2)) {
				vActIdx = 1;
			}
			$(".pagingNo .page strong").text(vActIdx);

			$(".hps-brand").find("p").delay(100).animate({"margin-bottom":"-2%", "opacity":"0"},400);
			$(".swiper-slide-active.hps-brand").find("p").delay(50).animate({"margin-bottom":"0", "opacity":"1"},300);
		}
	});
	$('.pagingNo .page strong').text(1);
	$('.pagingNo .page span').text(mySwiper.slides.length-2);

	/* skip to comment */
	$(".btn-go").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},800);
	});

	/* comment write ico select */
	$(".comment-write .choice li:first-child button").addClass("on");
	frmcom.gubunval.value = '1';
	$(".comment-write .choice li button").click(function(){
		frmcom.gubunval.value = $(this).val();
		$(".comment-write .choice li button").removeClass("on");
		if ( $(this).hasClass("on")) {
			$(this).removeClass("on");
		} else {
			$(this).addClass("on");
		}
	});

	$(".heySomethingV17 .choice li:first-child").addClass("on");
	$(".heySomethingV17 .choice li").click(function(){
		$(".heySomethingV17 .choice li").removeClass("on");
		$(this).addClass("on");
	});

});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->