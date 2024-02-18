<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 82 노리타케
' History : 2017-08-01 유태욱 생성
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
	eCode   =  66408
Else
	eCode   =  79740
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
.heySomethingV17 .option .price strong {color:#000;}

.heySomethingV17 .article .btn-go {margin-top:2rem;}

.heySomethingV17 .hsp-brand {position:relative;}
.heySomethingV17 .hsp-brand div {position:absolute; top:32.5%; left:0%; width:100%;}

.heySomethingV17 .hsp-prd .movingImg{position:absolute; top:27.51%; left:10.31%; width:79.68%; height:35.2%;}

.heySomethingV17 .hsp-insta {position:relative;}
.heySomethingV17 .hsp-insta ul {overflow:hidden;position:absolute; top:16%; left:0; width:100%; height:8%;}
.heySomethingV17 .hsp-insta ul li {float:left; width:50%; height:100%;}
.heySomethingV17 .hsp-insta ul li a {display:inline-block; width:100%; height:100%; text-indent:-999em;}

.heySomethingV17 .hsp-finish .txt2 {font-weight:bold;}

.heySomethingV17 .comment-write .choice li {width:5.8rem; height:5.8rem; margin-right:.6rem;}
.heySomethingV17 .form .choice li:last-child {margin-right:0;}
.heySomethingV17 .comment-write .choice li.on:before,
.heySomethingV17 .comment-write .choice li.on:after {display:none;}
.heySomethingV17 .comment-write .choice li button {width:100%; height:100%; background-color:transparent; color:transparent; background-repeat:no-repeat; background-position:50% 50% !important; background-size:100% 100%;}
.heySomethingV17 .comment-write .choice li.ico1 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/ico_01_off.png);}
.heySomethingV17 .comment-write .choice li.ico1.on button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/ico_01_on.png);}
.heySomethingV17 .comment-write .choice li.ico2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/ico_02_off.png);}
.heySomethingV17 .comment-write .choice li.ico2.on button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/ico_02_on.png);}
.heySomethingV17 .comment-write .choice li.ico3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/ico_03_off.png);}
.heySomethingV17 .comment-write .choice li.ico3.on button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/ico_03_on.png);}
.heySomethingV17 .comment-write .choice li.ico4 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/ico_04_off.png);}
.heySomethingV17 .comment-write .choice li.ico4.on button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/ico_04_on.png);}

.heySomethingV17 .comment-evt .comment-list ul li {position:relative; min-height:5.8rem; padding:2.5rem  0 2.5rem 7.7rem;}
.heySomethingV17 .comment-evt .comment-list ul li .ico {position:absolute; top:50%; left:0.5rem; width:5.8rem; height:5.8rem; margin-top:-2.9rem; padding:1rem 0; background-repeat:no-repeat; background-position:0 0; background-size:100% 100%; color:transparent;}
.heySomethingV17 .comment-evt .comment-list ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/ico_01_off.png);}
.heySomethingV17 .comment-evt .comment-list ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/ico_02_off.png);}
.heySomethingV17 .comment-evt .comment-list ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/ico_03_off.png);}
.heySomethingV17 .comment-evt .comment-list ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/ico_04_off.png);}
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
	window.$('html,body').animate({scrollTop:$("#comment-evt").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2017-08-07" and left(currenttime,10)<"2017-08-16" ) Then %>
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
		initialSlide:0,
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
	frmcom.gubunval.value = '1';
	$(".heySomethingV17 .choice li").click(function(){
		frmcom.gubunval.value = $(this).val();
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
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/img_represent.jpg" alt="Hey, something project" /></div>
						</div>

						<!-- about -->
						<div class="swiper-slide hsp-about">
							<h3>About</h3>
							<p class="txt1">Hey,<br />something<br />project</p>
							<p class="txt2">텐바이텐만의 시각으로<br />주목해야 할 상품을 선별해 소개하고<br />새로운 트렌드를 제안하는<br />ONLY 텐바이텐만의 프로젝트</p>
						</div>

						<!-- buy -->
						<div class="swiper-slide hsp-buy">
							<a href="/category/category_itemPrd.asp?itemid=1760616&pEtr=79740" class="mWeb">
								<div class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/img_slide_03.jpg" alt="" /></div>
								<div class="option">
									<!-- for dev msg : 상품코드 1760616 // 할인 없이 진행 // 이벤트 기간 08/09 ~ 08/15 -->
									<p class="name">[NORITAKE] REPEAT BOY</p>
									<p class="txt">A5, 180 Page / Paper / MADE IN JAPAN</p>
									<div class="price">
										<strong>23,000won</strong>
									</div>
									<div class="btn-go">구매하러 가기<i></i></div>
								</div>
							</a>
							<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1760616&pEtr=79740" onclick="fnAPPpopupProduct('1760616&pEtr=79740');return false;" class="mApp">
								<div class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/img_slide_03.jpg" alt="" /></div>
								<div class="option">
									<!-- for dev msg : 상품코드 1760616 // 할인 없이 진행 // 이벤트 기간 08/09 ~ 08/15 -->
									<p class="name">[NORITAKE] REPEAT BOY</p>
									<p class="txt">A5, 180 Page / Paper / MADE IN JAPAN</p>
									<div class="price">
										<strong>23,000won</strong>
									</div>
									<div class="btn-go">구매하러 가기<i></i></div>
								</div>
							</a>
						</div>

						<div class="swiper-slide hsp-brand">
							<a href="/street/street_brand.asp?makerid=noritake" class="mWeb">
								<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72536/m/txt_slide_04_v1.png" alt="NORITAKE는 일본의 일러스트레이터입니다. 심플한 흑백 드로잉으로 광고, 서적, 패션까지 다양한 장르에서 활동하고 있으며 개인전과 벽화 작업으로 국, 내외에서 많은 사랑을 받고 있습니다. 또한 NORITAKE만의 감성으로 문구, 잡화 등의 자체 상품을 제작, 판매하고 있습니다." /></div>
								<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72536/m/img_slide_04_v1.png" alt="N" />
							</a>
							<a href="/street/street_brand.asp?makerid=noritake" onclick="fnAPPpopupBrand('noritake'); return false;" class="mApp">
								<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72536/m/txt_slide_04_v1.png" alt="NORITAKE는 일본의 일러스트레이터입니다. 심플한 흑백 드로잉으로 광고, 서적, 패션까지 다양한 장르에서 활동하고 있으며 개인전과 벽화 작업으로 국, 내외에서 많은 사랑을 받고 있습니다. 또한 NORITAKE만의 감성으로 문구, 잡화 등의 자체 상품을 제작, 판매하고 있습니다." /></div>
								<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72536/m/img_slide_04_v1.png" alt="N" />
							</a>
						</div>

						<div class="swiper-slide hsp-prd">
							<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/img_slide_05.jpg" alt="" />
							<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/img_item_visual_big.gif" alt="" class="movingImg"/>
						</div>


						<!-- story -->
						<div class="swiper-slide hsp-desc">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/img_slide_06.jpg" alt="" /></div>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/txt_desc_06.jpg" alt="#FALL IN LOVE #OPEN EYES #TOTE BAG #에코백 #FACE #ILLUSTRATION #SIMPLE #SENSIBIL" /></p>
						</div>
						<div class="swiper-slide hsp-desc">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/img_slide_07.jpg" alt="" /></div>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/txt_desc_07.jpg" alt="#RAINY DAY #비 #장마 #우산 #블루 #시 #노트 #RAIN #BLUE #POEM #FRANCIS PONGE" /></p>
						</div>
						<div class="swiper-slide hsp-desc">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/img_slide_08.jpg" alt="" /></div>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/txt_desc_08.jpg" alt="#DAILY LIFE #일상 #반복 #아트북 #일러스트 #노트 #REPEAT BOY #FLIP BOOK #ART BOOK" /></p>
						</div>
						<div class="swiper-slide hsp-desc">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/img_slide_09.jpg" alt="" /></div>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/txt_desc_09.jpg" alt="#GROWN UP #펜 #黑 #白 #ILLUSTRATION #SIMPLE #PEN #BLACK #WHITE" /></p>
						</div>

						<div class="swiper-slide hsp-gallery">
							<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/img_slide_10.jpg" alt="" />
						</div>

						<div class="swiper-slide hsp-insta">
							<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/img_slide_11.jpg" alt="" />
							<ul>
								<li>
									<a href="https://www.instagram.com/noritake_org" target="_blank" class="mWeb">@noritake_org</a>
									<a href="" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/noritake_org');return false;" class="mApp">@noritake_org</a>
								</li>
								<li>
									<a href="https://www.instagram.com/noritake_korea/" target="_blank" class="mWeb">@noritake_korea</a>
									<a href="" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/noritake_korea/');return false;" class="mApp">@noritake_korea</a>
								</li>
							</ul>
						</div>

						<!-- comment Evt -->
						<div class="swiper-slide hsp-finish">
							<p class="txt1"><span>Hey, something project</span>심플함의 미학</p>
							<p class="txt2">일상에서 함께 하고픈 NORITAKE 상품은 무엇인가요?<br />정성껏 코멘트를 남겨주신 5분을 추첨하여<br />노리타케 상품을 드립니다 (랜덤증정)</p>
							<p class="txt3">기간 : <b>2017.08.09 ~ 08.15</b> / 발표 : <b>08.16</b></p>
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
			<!-- 구매버튼 -->
			<div class="btn-get">
				<% if isApp=1 then %>
					<a href="" onclick="fnAPPpopupBrowserURL('구매하기','<%= wwwUrl %>/event/etc/hsp/inc_79740_item.asp?isApp=<%= isApp %>'); return false;" title="구매하러 가기" class="mApp">BUY<i></i></a>
				<% else %>
					<a href="/event/etc/hsp/inc_79740_item.asp?isApp=<%= isApp %>" title="구매하러 가기" class="mWeb">BUY<i></i></a>
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
						<h3><span>Hey, something project</span>심플함의 미학</h3>
						<p class="txt">일상에서 함께 하고픈 NORITAKE의 <br/ > 상품은 무엇인가요? 정성껏 코멘트를 남겨주신<br />5분을 추첨하여 노리타케 상품을 드립니다 (랜덤증정)</p>
						<p class="date">기간 : <b>2017.08.09 ~ 08.15</b> / 발표 : <b>08.16</b></p>
						<div class="inner">
							<ul class="choice">
								<li class="ico ico1" value="1">
									<button type="button">#FALL IN LOVE</button>
								</li>
								<li class="ico ico2" value="2">
									<button type="button">#RAINYDAY</button>
								</li>
								<li class="ico ico3" value="3">
									<button type="button">#DAILY LIFE</button>
								</li>
								<li class="ico ico4" value="4">
									<button type="button">#GROWNUP</button>
								</li>
							</ul>
							<div class="field">
								<textarea name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="코멘트 작성" cols="60" rows="5"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
								<input type="submit" value="응모하기" onclick="jsSubmitComment(document.frmcom); return false;" class="btnsubmit" />
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
											#FALL IN LOVE
										<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
											#RAINYDAY
										<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
											#DAILY LIFE
										<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>
											#GROWNUP
										<% Else %>
											#FALL IN LOVE
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
									<% end if %>
									<p class="date">
										<span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span> / <span><%= FormatDate(arrCList(4,intCLoop),"0000.00.00") %></span> 
										<% If arrCList(8,intCLoop) <> "W" Then %><span class="mob">모바일에서 작성</span><% end if %>
									</p>
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
		<!-- //comment event -->
		<div id="dimmed"></div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->