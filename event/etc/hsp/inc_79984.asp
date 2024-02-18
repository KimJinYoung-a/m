<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 84 칼로리컷
' History : 2017-08-21 정태훈 생성
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
	eCode   =  66414
Else
	eCode   =  79984
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
.heySomethingV17 .article .btn-go {margin-top:2rem;}
.heySomethingV17 .hsp-buy .option .txt {padding-top:0;}
.heySomethingV17 .hsp-buy .option .price s {display:inline-block;}
.heySomethingV17 .hsp-finish .txt2 {font-weight:bold;}
.heySomethingV17 .comment-write .choice li {width:5.8rem; height:5.8rem; margin-right:.6rem;}
.heySomethingV17 .form .choice li:last-child {margin-right:0;}
.heySomethingV17 .comment-write .choice li.on:before,
.heySomethingV17 .comment-write .choice li.on:after {display:none;}
.heySomethingV17 .comment-write .choice li button {width:100%; height:100%; background-color:transparent; color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomethingV17 .comment-write .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/ico_01_off.jpg);}
.heySomethingV17 .comment-write .choice li.ico1.on button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/ico_01_on_v2.jpg);}
.heySomethingV17 .comment-write .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/ico_02_off.jpg);}
.heySomethingV17 .comment-write .choice li.ico2.on button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/ico_02_on_v2.jpg);}
.heySomethingV17 .comment-write .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/ico_03_off.jpg);}
.heySomethingV17 .comment-write .choice li.ico3.on button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/ico_03_on_v2.jpg);}
.heySomethingV17 .comment-write .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/ico_04_off.jpg);}
.heySomethingV17 .comment-write .choice li.ico4.on button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/ico_04_on_v2.jpg);}

.heySomethingV17 .comment-evt .comment-list ul li {position:relative; min-height:5.8rem; padding:2.5rem 0 2.5rem 7.7rem;}
.heySomethingV17 .comment-evt .comment-list ul li .ico {position:absolute; top:50%; left:0.5rem; width:5.8rem !important; height:5.8rem !important; margin-top:-2.9rem; padding:1rem 0; background-repeat:no-repeat; background-position:50% 0 !important; background-size:100% auto; color:transparent;}
.heySomethingV17 .comment-evt .comment-list ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/ico_01_off.jpg);}
.heySomethingV17 .comment-evt .comment-list ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/ico_02_off.jpg);}
.heySomethingV17 .comment-evt .comment-list ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/ico_03_off.jpg);}
.heySomethingV17 .comment-evt .comment-list ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/ico_04_off.jpg);}
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
		<% If not( left(currenttime,10)>="2017-08-23" and left(currenttime,10)<"2017-09-06" ) Then %>
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

			$(".swiper-slide.hsp-brand").find("div").delay(100).animate({"margin-top":"20%", "opacity":"0"},300);
			$(".swiper-slide-active.hsp-brand").find("div").delay(50).animate({"margin-top":"0", "opacity":"1"},500);
		}
	});
	$('.pagingNo .page strong').text(1);
	$('.pagingNo .page span').text(mySwiper.slides.length-2);

	/* skip to comment */
	$(".btn-go").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},800);
	});

	$(".heySomethingV17 .choice li:first-child").addClass("on");
	$(".heySomethingV17 .choice li").click(function(){
		$(".heySomethingV17 .choice li").removeClass("on");
		$(this).addClass("on");
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
						<!-- main contents -->
						<div class="section article">
							<!-- swiper -->
							<div class="swiper">
								<div class="swiper-container swiper1">
									<div class="swiper-wrapper">
										<!-- topic -->
										<div class="swiper-slide hsp-topic">
											<h2>Hey,<br /><b>something</b><br />project</h2>
											<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/img_represent.jpg" alt="Hey, something project" /></div>
										</div>

										<!-- about -->
										<div class="swiper-slide hsp-about">
											<h3>About</h3>
											<p class="txt1">Hey,<br />something<br />project</p>
											<p class="txt2">텐바이텐만의 시각으로<br />주목해야 할 상품을 선별해 소개하고<br />새로운 트렌드를 제안하는<br />ONLY 텐바이텐만의 프로젝트</p>
										</div>

										<div class="swiper-slide hsp-brand">
											<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/txt_brand.jpg" alt=" 인테이크푸즈는 'Eating' 과 'Intake'는 같지 않다라는 전제를 바탕으로 식문화의 혁신을 선도하는 식품 브랜드 전문 기업입니다. " />
										</div>

										<!-- buy1 -->
										<%
											Dim itemid, oItem
											IF application("Svr_Info") = "Dev" THEN
												itemid = 786868
											Else
												itemid = 1774239
											End If
											set oItem = new CatePrdCls
												oItem.GetItemData itemid
										%>
										<div class="swiper-slide hsp-buy">
										<% If isApp = 1 Then %>
											<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1774239&amp;pEtr=79984'); return false;">
										<% Else %>
											<a href="/category/category_itemPrd.asp?itemid=1774239&amp;pEtr=79984">
										<% End If %>
												<div class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/img_slide_04_v2.gif" alt="칼로리컷 츄어블" /></div>
												<div class="option">
													<p class="name"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/txt_prd_name.jpg" alt="칼로리컷 츄어블" /></p>
													<p class="txt">구성 : 2000mg X 42정 (84g)</p>
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
										<% Set oItem = Nothing %>
										<div class="swiper-slide">
											<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/img_slide_05.jpg" alt="칼로리컷 츄어블 체지방 감소에 도움을 주는 가르시니아 캄보지아 추출물 함유되어 탄수화물이 지방으로 합성되는 것을 억제하여,체지방 감소에 도움을 줍니다.어디서나 즐길 수 있는 간편한 포장법으로 식사 후에 가볍고 맛있게 씹어먹을 수 있답니다. " />
										</div>

										<div class="swiper-slide">
											<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/img_slide_06.jpg" alt="" />
										</div>

										<!-- story -->
										<div class="swiper-slide hsp-desc">
											<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/img_slide_07.jpg" alt="" /></div>
											<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/txt_desc_07.jpg" alt="#NEW 기존에 없던 칼로리컷의 새로운 맛, 상큼한 레몬맛" /></p>
										</div>
										<div class="swiper-slide hsp-desc">
											<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/img_slide_08.jpg" alt="" /></div>
											<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/txt_desc_08.jpg" alt="#CUTE 귀엽고 앙증맞은 크기의 박스 패키지" /></p>
										</div>
										<div class="swiper-slide hsp-desc">
											<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/img_slide_09.jpg" alt="" /></div>
											<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/txt_desc_09.jpg" alt="#CONVENIENT 가방 속에 쏙 넣고 다닐 수 있는 편리한 라미네이션 포장" /></p>
										</div>
										<div class="swiper-slide hsp-desc">
											<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/img_slide_10.jpg" alt="" /></div>
											<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/txt_desc_10.jpg" alt="#CHEWABLE 간편하고 맛있게 씹어먹을 수 있는 츄어블 체형" /></p>
										</div>

										<div class="swiper-slide">
											<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79984/m/img_slide_11.jpg" alt="맛있게 먹고 칼로리를 CUT 하세요! 개별 포장으로 편리해진 휴대성과 상큼한 레몬맛이 추가되어 돌아온 씹어먹는 츄어블 형태의 NEW 칼로리컷" />
										</div>

										<!-- comment Evt -->
										<div class="swiper-slide hsp-finish">
											<p class="txt1"><span>Hey, something project</span>새로워진 칼로리컷의</br > 가장 기대되는 점</p>
											<p class="txt2">칼로리를 CUT! 해주는 칼로리컷의 새로운 모습 중</br >가장 기대되는 점 무엇인가요?</br >정성껏 코멘트를 남겨주신 분을 추첨하여</br >인테이크 다이어트 키트 증정(5만원 상당)을 선물로 드립니다.</br ></p>
											<p class="txt3">기간 : <b>2017.08.23 ~ 09.06</b> / 발표 : <b>09.07</b></p>
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
							<!-- 구매버튼 1774239 연결 -->
							<div class="btn-get">
								<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1774239&amp;pEtr=79984'); return false;">
								<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1774239&amp;pEtr=79984">
								<% End If %>BUY<i></i></a>
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
										<h3><span>Hey, something project</span>새로워진 칼로리컷의</br >가장 기대되는 점</h3>
										<p class="txt">칼로리를 CUT! 해주는 칼로리컷의 새로운 모습 중 </br >가장 기대되는 점 무엇인가요?</br > 정성껏 코멘트를 남겨주신 분을 추첨하여 인테이크 </br >다이어트 키트 증정(5만원 상당)을 선물로 드립니다.</p>
										<p class="date">기간 : <b>2017.08.23 ~ 09.06</b> / 발표 : <b>09.07</b></p>
										<div class="inner">
											<ul class="choice">
												<li class="ico ico1">
													<button type="button" value="1">#NEW</button>
												</li>
												<li class="ico ico2">
													<button type="button" value="2">#CUTE</button>
												</li>
												<li class="ico ico3">
													<button type="button" value="3">#CONVENIENT</button>
												</li>
												<li class="ico ico4">
													<button type="button" value="4">#CHEWABLE</button>
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
												#NEW
											<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
												#CUTE
											<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
												#CONV
											<% Else %>
												#CHEWA
											<% End if %>
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
											<p class="date"><span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span> / <span><%= FormatDate(arrCList(4,intCLoop),"0000.00.00") %></span> <% If arrCList(8,intCLoop) <> "W" Then %> <span class="mob">모바일에서 작성</span><% end if %></p>
										</div>
									</li>
									<% next %>
								</ul>
								<% IF isArray(arrCList) THEN %>
								<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
								<% end if %>
							</div>
							<% end if %>
						</div>
						<!-- //comment event -->
						<div id="dimmed"></div>
					</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->