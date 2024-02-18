<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : hey, something project 시리즈 85 Hello Brown!
' History : 2017-09-05 정태훈 생성
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
	eCode   =  66422
Else
	eCode   =  80243
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
.heySomethingV17 .hsp-buy .option .name i {font-family:serif;}
.heySomethingV17 .hsp-buy .option .only10 {width:34.68%; height:2rem; margin:0 auto; background-color:#ff3131; border-radius:1rem; font-size:1rem; color:#fff; line-height:2rem;}
.heySomethingV17 .hsp-buy .option .price {margin-top:0.9rem;}
.heySomethingV17 .hsp-buy .option .price s {display:inline-block; padding-right:0.3rem;}
.heySomethingV17 .hsp-buy .option .txt {padding-top:1.3rem; font-size:1.2rem;}
.heySomethingV17 .article .btn-go{margin-top:2.5rem;}

.heySomethingV17 .hsp-intro,
.heySomethingV17 .hsp-app{position:relative;}
.heySomethingV17 .hsp-intro p{position:absolute; bottom:13.12%; left:50%; width:80.62%; margin-left:-40.31%;}
.heySomethingV17 .hsp-app p{position:absolute; top:12.5%; left:50%; width:62.5%; margin-left:-31.25%;}

.heySomethingV17 .hsp-finish .txt1 {width:85.78%; font-size:1.4rem; line-height:1.4; letter-spacing:0.1rem;}
.heySomethingV17 .hsp-finish .txt2 {padding-top:2.3rem; font-size:1.2rem;}
.heySomethingV17 .hsp-finish .txt3 {padding-top:2rem; font-size:.9rem;}

.heySomethingV17 .comment-write {padding:0 2rem;}
.heySomethingV17 .comment-write h3 {padding:0 .5rem; font-size:1.3rem; line-height:1.3; letter-spacing:.1rem;}
.heySomethingV17 .comment-write h3 span {padding-bottom:1.2rem;}
.heySomethingV17 .comment-write .date {padding:.5rem;}
.heySomethingV17 .comment-write .txt {padding:1.2rem .5rem .9rem; line-height:1.5;}
.heySomethingV17 .comment-write .choice {padding:1.1rem 0 0;}
.heySomethingV17 .comment-evt .ico {left:.6rem; margin-right:.8rem; border-radius:50%;}
.heySomethingV17 .comment-evt .ico4 {margin-right:0;}
.heySomethingV17 .comment-evt .comment-write .choice li button {padding-top:0.1rem; letter-spacing:-0.03em;}
.heySomethingV17 .comment-evt .comment-write .choice li:last-child {margin-right:0;}
.heySomethingV17 .comment-evt .comment-list .ico {width:58px; margin-top:-29px;}
.heySomethingV17 .comment-evt .comment-list .ico strong {font-weight:600; letter-spacing:-0.03em;}
.heySomethingV17 .comment-evt .comment-list li {min-height:58px; padding-left:77px;}

@media all and (min-width:360px){
	.heySomethingV17 .comment-evt .ico {width:72px;}
	.heySomethingV17 .comment-evt .comment-list li {min-height:72px; padding-left:85px;}
}
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
		<% If not( left(currenttime,10)>="2017-09-05" and left(currenttime,10)<"2017-09-13" ) Then %>
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

$(function(){
	mySwiper = new Swiper('.swiper1',{
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

			$(".hsp-intro").find("p").delay(100).animate({"margin-bottom":"-2%", "opacity":"0"},400);
			$(".swiper-slide-active.hsp-intro").find("p").delay(50).animate({"margin-bottom":"0", "opacity":"1"},300);

			$(".hsp-app").find("p").delay(100).animate({"margin-top":"-2%", "opacity":"0"},400);
			$(".swiper-slide-active.hsp-app").find("p").delay(50).animate({"margin-top":"0", "opacity":"1"},300);
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
											<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/img_represent.jpg" alt="브라이언 스마트펜" /></div>
										</div>

										<!-- about -->
										<div class="swiper-slide hsp-about">
											<h3>About</h3>
											<p class="txt1">Hey,<br />something<br />project</p>
											<p class="txt2">텐바이텐만의 시각으로<br />주목해야 할 상품을 선별해 소개하고<br />새로운 트렌드를 제안하는<br />ONLY 텐바이텐만의 프로젝트</p>
										</div>

										<div class="swiper-slide">
											<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/txt_brand.jpg" alt="neo smartpen 우리는 종이에 디지털 정보를 저장하는 Ncode 기술을 바탕으로종이에 그려지는 펜의 움직임을 연구합니다 Ncode 기술로 펜으로 책을 읽어 주거나, 볼펜으로 노트에 기록한 내용을 디지털화하여 저장/전송하는 솔루션으로 새로운 가치를 창출하고 펜과 종이(paper 2.0)의 역사를 이어가려 합니다." /></p>
										</div>
										<%
											Dim itemid, oItem
											IF application("Svr_Info") = "Dev" THEN
												itemid = 786868
											Else
												itemid = 1782554
											End If
											set oItem = new CatePrdCls
												oItem.GetItemData itemid
										%>
										<!-- buy -->
										<div class="swiper-slide hsp-buy">
										<% If isApp = 1 Then %>
											<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1782554&amp;pEtr=80243'); return false;">
										<% Else %>
											<a href="/category/category_itemPrd.asp?itemid=1782554&amp;pEtr=80243">
										<% End If %>
												<div class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/img_item.jpg" alt="Neo smartpen Brown Limited Edition" /></div>
												<div class="option">
													<!-- for dev msg : 상품코드 1782554, 할인없으니 실시간 가격만 불러와주세요 -->
													<div class="only10">텐바이텐 단독 선오픈</div>
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
													<p class="txt">※ 네오 스마트펜 브라운 리미티드 에디션 구매 시<br />N 프로페셔널 미니 노트 증정</p>
													<div class="btn-go">구매하러 가기<i></i></div>
												</div>
											</a>
										</div>
										<% Set oItem = Nothing %>
										<div class="swiper-slide hsp-intro">
											<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/img_intro.jpg" alt="" />
											<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/txt_intro.png" alt="라인프렌즈 브라운과 캐주얼한 옷으로 갈아입은 네오 스마트펜의 특별한 만남!이제 종이에 쓰고 디지털로 저장하세요" /></p>
										</div>

										<div class="swiper-slide hsp-app">
											<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/img_app.jpg" alt="" />
											<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/txt_app.png" alt="네오 스마트펜 전용 어플리케이션 Neo Notes 네오 스마트펜 전용 APP인 Neo Notes는앱스토어와 구글플레이스토어에서 무료로 다운받으실 수 있습니다" /></p>
										</div>

										<!-- story -->
										<div class="swiper-slide hsp-desc">
											<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/img_story_1.jpg" alt="" /></div>
											<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/txt_desc_1.png" alt="package 네오 스마트펜 라인프렌즈 에디션은 캐주얼한 디자인을 바탕으로 브라운을 상징하는 컬러를 패키지에 적용하였습니다" /></p>
										</div>
										<div class="swiper-slide hsp-desc">
											<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/img_story_2.jpg" alt="" /></div>
											<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/txt_desc_2.png" alt="smartpen 네오 스마트펜 라인프렌즈 에디션은 세계에서 가장 얇은 광학식 필기펜으로 특별함에 특별함을 더했습니다" /></p>
										</div>
										<div class="swiper-slide hsp-desc">
											<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/img_story_3.jpg" alt="" /></div>
											<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/txt_desc_3.png" alt="notebook 노트 우측 상단의 라인 아이콘을 체크하면 해당 페이지는 라인 앱을 통해 쉽고 간편하게 공유 할 수 있습니다 (이메일 박스 체크 시 해당 페이지 자동 이메일 전송 가능)" /></p>
										</div>
										<div class="swiper-slide hsp-desc">
											<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/img_story_4.jpg" alt="" /></div>
											<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/txt_desc_4.png" alt="kidult 브라운 피규어 악세서리는 네오스마트펜 상단 부분에 끼워 사용할 수 있는 아이템으로, 오직 네오 스마트펜 라인프렌즈 에디션에서만 만나 볼 수 있습니다" /></p>
										</div>

										<!-- comment Evt -->
										<div class="swiper-slide hsp-finish">
											<p class="txt1"><span>Hey, something project</span>네오 스마트펜 라인프렌즈 에디션의 가장<br/ >기대되는점은 무엇인가요?</p>
											<p class="txt2">정성껏 코멘트를 남겨주신 3분을 추첨하여</br >1등(1명) 네오스마트펜 N2,</br>2등(2명) N 프로페셔널 노트를 증정 합니다</p>
											<p class="txt3">기간 : <b>2017.9.6(수) ~ 09.12(화)</b> / 발표 : <b>09.13(수)</b></p>
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
							<div class="btn-get"><% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1782554&amp;pEtr=80243'); return false;">
								<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1782554&amp;pEtr=80243">
								<% End If %>BUY<i></i></a></div>
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
										<h3><span>Hey, something project</span>네오 스마트펜 라인프렌즈 에디션의 가장<br/ >기대되는점은 무엇인가요?</h3>
										<p class="txt">정성껏 코멘트를 남겨주신 3분을 추첨하여<br/ >1등(1명) 네오스마트펜 N2,<br/ >2등(2명) N 프로페셔널 노트를 증정 합니다.</p>
										<p class="date">기간 : <b>2017.9.6(수) ~ 09.12(화)</b> / 발표 : <b>09.13(수)</b></p>
										<div class="inner">
											<ul class="choice">
												<li class="ico ico1">
													<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/bg_ico_1.png" alt="PACKAGE" /></button>
												</li>
												<li class="ico ico2">
													<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/bg_ico_2.png" alt="SMART PEN" /></button>
												</li>
												<li class="ico ico3">
													<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/bg_ico_3.png" alt="NOTE BOOK" /></button>
												</li>
												<li class="ico ico4">
													<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/bg_ico_4.png" alt="KIDULT" /></button>
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
										<div class="ico ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>"><strong><% If split(arrCList(1,intCLoop),"!@#")(0)="1" Then %><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/bg_ico_1.png" alt="PACKAGEY" /><% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/bg_ico_2.png" alt="SMART PENF" /><% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/bg_ico_3.png" alt="NOTE BOOK" /><% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/bg_ico_4.png" alt="KIDULT" /><% Else %><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80243/m/bg_ico_1.png" alt="PACKAGEY" /><% End If %></strong></div>
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
											<p class="date"><span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span> / <span><%= FormatDate(arrCList(4,intCLoop),"0000.00.00") %></span><% If arrCList(8,intCLoop) <> "W" Then %> <span class="mob">모바일에서 작성</span><% end if %></p>
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
					<!-- //[Hey, something project] -->
<!-- #include virtual="/lib/db/dbclose.asp" -->