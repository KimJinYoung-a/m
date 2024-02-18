<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : PLAYing 백문이 불여일수
' History : 2017-02-10 이종화 생성
'####################################################
Dim eCode , userid , pagereload , vDIdx

IF application("Svr_Info") = "Dev" THEN
	eCode   =  66277
Else
	eCode   =  76172
End If

vDIdx = request("didx")
pagereload	= requestCheckVar(request("pagereload"),2)

If GetEncLoginUserID <> "" then
	commentcount = getcommentexistscount(GetEncLoginUserID, eCode, "", "", "", "Y")
Else
	commentcount = 0
End If 


dim com_egCode, bidx , commentcount
	Dim cEComment
	Dim iCTotCnt, arrCList,intCLoop, iSelTotCnt
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt, eCC, txtcomm1, txtcomm2, txtcomm3, tmptxtcomm

	'파라미터값 받기 & 기본 변수 값 세팅
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)
	eCC = requestCheckVar(Request("eCC"), 1) 

	IF iCCurrpage = "" THEN iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 3		'한 페이지의 보여지는 열의 수
	iCPerCnt = 6		'보여지는 페이지 간격

	'선택범위 리플개수 접수
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iSelTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	'코멘트 데이터 가져오기
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	'cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
'response.end
%>
<style type="text/css">
.signs {background-color:#eae6dc;}
.signs button {background-color:transparent;}
.signs textarea::-webkit-input-placeholder {color:#fff;}
.signs textarea::-moz-placeholder {color:#fff;} /* firefox 19+ */
.signs textarea:-ms-input-placeholder {color:#fff;} /* ie */
.signs textarea:-moz-placeholder {color:#fff;}

.signs .topic .hgroup {position:relative;}
.signs .topic h2 {margin-top:0;}
.signs .topic h2 span {position:absolute; top:38.54%; width:100%;}
.signs .topic h2 .letter1,
.signs .topic h2 .letter2 {left:0;}
.signs .topic h2 .letter2 {top:67.57%;}
.signs .topic h2 .letter3 {right:13.9%; top:63.94%; width:20.625%;}

.signs .topic h2 .letter1 {animation:slideUp 1.2s 1; animation-fill-mode:both; -webkit-animation:slideUp 1.2s 1; -webkit-animation-fill-mode:both;}
.signs .topic h2 .letter2 {animation:slideUp 1.2s 1; animation-fill-mode:both; animation-delay:0.3s; -webkit-animation:slideUp 1.2s 1; -webkit-animation-fill-mode:both; -webkit-animation-delay:0.3s;}
@keyframes slideUp {
	0% {transform:translateY(10px); opacity:0;}
	100% {transform:translateY(0); opacity:1;}
}
@-webkit-keyframes slideUp {
	0% {-webkit-transform:translateY(10px); opacity:0;}
	100% {-webkit-transform:translateY(0); opacity:1;}
}
.signs .topic h2 .letter3 {animation:rotate 2s; -webkit-animation:rotate 2s;}
@keyframes rotate {
	0% {transform:rotateZ(-180deg) scale(0.2); opacity:0;}
	100% {transform:rotateZ(0) scale(1); opacity:1;}
}
@-webkit-keyframes rotate {
	0% {-webkit-transform:rotateZ(-180deg) scale(0.2); opacity:0;}
	100% {-webkit-transform:rotateZ(0) scale(1); opacity:1;}
}

.signs .story .scene {position:relative;}
.signs .story .scene > div {position:relative;}
.signs .story .scene .btnSign {position:absolute; top:0; left:0; width:100%; height:100%;}
.signs .story .scene .btnSign img {position:absolute; bottom:0; left:0; width:100%;}
.signs .story .scene .btnBack {position:absolute; top:0; right:0; width:100%; height:100%;}
.signs .story .scene .btnBack img {position:absolute; bottom:9.61%; left:50%; width:16.875%; margin-left:-8.4375%;}
.bounce {animation:bounce 5 0.7s; animation-delay:0.5s; -webkit-animation:bounce 5 0.7s; -webkit-animation-delay:0.5s;}
@keyframes bounce {
	from, to{margin-bottom:0; animation-timing-function:ease-out;}
	50% {margin-bottom:5px; animation-timing-function:ease-in;}
}
@-webkit-keyframes bounce {
	from, to{margin-bottom:0; animation-timing-function:ease-out;}
	50% {margin-bottom:5px; animation-timing-function:ease-in;}
}

.signs .story .scene .on {position:absolute; top:0; width:100%;}
.signs .story .scene01 .on {right:0;}
.signs .story .scene02 .on,
.signs .story .scene03 .on {left:0;}
.signs .story .scene .line {position:absolute; bottom:-1.2%; left:0; z-index:5; width:100%;}

.rolling {position:relative;}
.rolling .swiper-container {width:100%;}
.rolling .btnNav {position:absolute; top:40%; z-index:5; width:7.5%; padding:5% 0;}
.rolling .btnPrev {left:0;}
.rolling .btnNext {right:0;}
.rolling .pagination {position:absolute; bottom:5.85%; left:0; z-index:5; width:100%; height:auto; z-index:50; padding-top:0; text-align:center;}
.rolling .pagination .swiper-pagination-switch {display:inline-block; width:8px; height:8px; margin:0 0.4rem; border:2px solid #fff; background-color:transparent; cursor:pointer; transition:all 0.7s ease;}
.rolling .pagination .swiper-active-switch {background-color:#fff;}

@media all and (min-width:360px){
	.rolling .pagination .swiper-pagination-switch {width:8px; height:8px;}
}
@media all and (min-width:768px){
	.rolling .pagination .swiper-pagination-switch {width:14px; height:14px; border:4px solid #fff;}
}

.signs .comment {padding-bottom:4.5rem; background-color:#eae6db;}
.signs .swiperCarousel {margin-top:0; padding:1.7rem 0 1.4rem; border-bottom:0; background-color:#e0dbce;}
.signs .swiperCarousel .swiper-container {margin-top:0; padding:0 1.25rem 0 1.9rem;}
.signs .swiperCarousel .swiper-container .swiper-slide {width:19.68%; margin-right:0.65rem; padding-bottom:1.9rem;}
.signs .swiperCarousel .swiper-container .card08,
.signs .swiperCarousel .swiper-container .card09,
.signs .swiperCarousel .swiper-container .card10 {width:30.3125%;}
.signs .swiperCarousel .swiper-slide {
	display:-webkit-box; display:-ms-flexbox; display:-webkit-flex; display:flex;
	-webkit-box-pack:center; -ms-flex-pack:center; -webkit-justify-content:center; justify-content:center;
	-webkit-box-align:center; -ms-flex-align:center; -webkit-align-items:center; align-items:center;
}
.signs .swiperCarousel .swiper-slide input {position:absolute; bottom:0; left:50%; width:12px; height:12px; margin-bottom:0.1rem; border:2px solid #979797; border-radius:50%; margin-left:-6px;}
.signs .swiperCarousel .swiper-slide input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_input_radio_checked.png) no-repeat 50% 50%; background-size:12px;}
@media all and (min-width:360px){
	.signs .swiperCarousel .swiper-slide input {width:14px; height:14px;}
	.signs .swiperCarousel .swiper-slide input[type=radio]:checked {background-size:14px;}
}
@media all and (min-width:768px){
	.signs .swiperCarousel .swiper-slide input {width:16px; height:16px;}
	.signs .swiperCarousel .swiper-slide input[type=radio]:checked {background-size:16px;}
}

.signs .swiperCarousel .other input {bottom:15.2%;}

.signs .form textarea {display:block; width:89%; height:12.75rem; margin:10% auto 0; padding:2.2rem 2.8rem; border:0; background:#ae9e71 url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_01.png) 50% 50% no-repeat; background-size:100%; color:#fff; font-size:1.2rem; font-weight:bold; transition:background 0.5s;}
.signs .form .bg01 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_01.png);}
.signs .form .bg02 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_02.png);}
.signs .form .bg03 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_03.png);}
.signs .form .bg04 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_04.png);}
.signs .form .bg05 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_05.png);}
.signs .form .bg06 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_07.png);}
.signs .form .bg07 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_06.png);}
.signs .form .bg08 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_08.png);}
.signs .form .bg09 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_09.png);}
.signs .form .bg10 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_10.png);}

.signs .form .btnSubmit,
.signs .form .btnDone {width:60.46%; margin:5% auto 0;}
.signs .form .btnSubmit input {width:100%;}

.signs .commentList {padding-top:5%;}
.signs .commentList ul {width:27.25rem; margin:0 auto;}
.signs .commentList ul li {position:relative; min-height:9.75rem; margin-top:1.1rem; padding:2rem 2.3rem 4.3rem 9.6rem; border-radius:0.4rem; background-color:#fff;  background-position:0 50%; background-repeat:no-repeat; background-size:9.6rem auto; font-size:1.1rem; line-height:1.688rem;}
.signs .commentList ul .bg01 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_small_01.png);}
.signs .commentList ul .bg02 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_small_02.png);}
.signs .commentList ul .bg03 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_small_03.png);}
.signs .commentList ul .bg04 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_small_04.png);}
.signs .commentList ul .bg05 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_small_05.png);}
.signs .commentList ul .bg06 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_small_06_v1.png);}
.signs .commentList ul .bg07 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_small_07_v1.png);}
.signs .commentList ul .bg08 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_small_08.png);}
.signs .commentList ul .bg09 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_small_09.png);}
.signs .commentList ul .bg10 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_card_small_10.png);}
.signs .commentList ul li p {padding-bottom:1.2rem; color:#909090;}
.signs .commentList ul li .writer {position:absolute; bottom:2.1rem; left:0; width:100%; padding:0 2.3rem 0 9.6rem; color:#2c3943;}
.signs .commentList ul li .writer .id {overflow:hidden; display:inline-block; width:75%; text-overflow:ellipsis; white-space:nowrap;}
.signs .commentList ul li .writer .id span {font-weight:bold;}
.signs .commentList ul li .writer .id img {width:0.6rem; vertical-align:-2px;}
.signs .commentList ul li .no {position:absolute; top:0; right:2.3rem;}
.signs .commentList .btndel {position:absolute; top:-0.75rem; right:-0.65rem; width:2.5rem;}

.pagingV15a span {color:#958b6e;}
.pagingV15a .current {color:#133e5c;}
/*.pagingV15a {margin-top:2.1rem; width:100%;}
.pagingV15a span {width:3rem; height:3rem; margin:0; border:0; border-radius:50%;}
.pagingV15a span a {color:#7a7a7a; font-size:1.2rem; font-weight:bold; line-height:1.5rem;}
.pagingV15a span.current {background-color:#1f3f5b;}
.pagingV15a span.current a {color:#fff;}
.pagingV15a span.arrow {border:0; background:url(http://webimage.10x10.co.kr/playing/thing/vol008/m/btn_pagination_nav.png) 50% 0 no-repeat; background-size:100% auto;}
.pagingV15a span.nextBtn {background-position:50% 100%;}*/
</style>
<script type="text/javascript">
$(function(){
	$("#story .scene .on").hide();
	$("#story .scene02 .on, #story .scene03 .on").css({"margin-left":"-50%"});
	$("#story .scene01 .on").css({"margin-right":"-50%"});

	$("#story .scene .btnSign").on("click", function(e){
		$(".btnBack img").addClass("bounce");
		if ( $(this).parent().parent().hasClass("scene01")) {
			$(this).parent().next().show();
			$(this).parent().next().animate({"margin-right":"0"},500);
			$("#story .scene .line").hide();
			return false;
		} else {
			$(this).parent().next().show();
			$(this).parent().next().animate({"margin-left":"0"},400);
			$("#story .scene .line").hide();
			return false;
		}
	});

	$("#story .scene .btnBack").on("click", function(e){
		$(".btnBack img").removeClass("bounce");
		if ( $(this).parent().parent().hasClass("scene01")) {
			$(this).parent().animate({"margin-right":"-100%"},500);
			$("#story .scene .line").show();
			return false;
		} else {
			$(this).parent().animate({"margin-left":"-100%"},400);
			$("#story .scene .line").show();
			return false;
		}
	});

	/* swipe */
	var goodsSwiper = new Swiper('#rolling .swiper-container',{
		loop:true,
		autoplay:3000,
		speed:800,
		pagination:"#rolling .pagination",
		paginationClickable:true,
		nextButton:'#rolling .btnNext',
		prevButton:'#rolling .btnPrev'
	});

	var cardSwiper = new Swiper("#cardSwiper .swiper-container", {
		slidesPerView:"auto",
		freeMode:true
	});

	$("#cardSwiper .swiper-slide label, #cardSwiper .swiper-slide input").on("click", function(e){
		frmcom.spoint.value = $(this).attr("val");
		$(".form textarea").removeClass();
		if ( $(this).parent().hasClass("card01")) {
			$(".form textarea").addClass("bg01");
		}
		if ( $(this).parent().hasClass("card02")) {
			$(".form textarea").addClass("bg02");
		}
		if ( $(this).parent().hasClass("card03")) {
			$(".form textarea").addClass("bg03");
		}
		if ( $(this).parent().hasClass("card04")) {
			$(".form textarea").addClass("bg04");
		}
		if ( $(this).parent().hasClass("card05")) {
			$(".form textarea").addClass("bg05");
		}
		if ( $(this).parent().hasClass("card06")) {
			$(".form textarea").addClass("bg06");
		}
		if ( $(this).parent().hasClass("card07")) {
			$(".form textarea").addClass("bg07");
		}
		if ( $(this).parent().hasClass("card08")) {
			$(".form textarea").addClass("bg08");
		}
		if ( $(this).parent().hasClass("card09")) {
			$(".form textarea").addClass("bg09");
		}
		if ( $(this).parent().hasClass("card10")) {
			$(".form textarea").addClass("bg10");
		}
	});

	<% if pagereload<>"" then %>
		setTimeout("pagedown()",200);
	<% end if %>
});


function pagedown(){
	window.$('html,body').animate({scrollTop:$(".commentList").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% if Not(IsUserLoginOK) then %>
		<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
		<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
		<% end if %>			
	<% end if %>
	
	<% if date() >="2017-02-13" and date() <= "2017-02-22" then %>
		<% if commentcount>4 then %>
			alert("이벤트는 5회까지 참여 가능 합니다.");
			return false;
		<% else %>
			if (!frm.spoint.value){
				alert('원하는 손 모양을 선택해 주세요.');
				return false;
			}
		
			if(!frm.txtcomm.value){
				alert("팁을 남겨주세요!");
				document.frmcom.txtcomm.value="";
				frm.txtcomm.focus();
				return false;
			}

			if (GetByteLength(frm.txtcomm.value) > 160){
				alert("제한길이를 초과하였습니다. 80자 까지 작성 가능합니다.");
				frm.txtcomm.focus();
				return false;
			}

			frm.action = "/event/lib/doEventComment.asp";
			frm.submit();
		<% end if %>
	<% else %>
		alert("이벤트 응모 기간이 아닙니다.");
		return false;
	<% end if %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmactNew.Cidx.value = cidx;
   		document.frmactNew.submit();
	}
}

function jsChklogin22(blnLogin)
{
	if (blnLogin == "True"){
		return true;
	} else {
		<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
		<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
		<% end if %>			
	}
	return false;
}
</script>
<div class="thingVol008 signs">
	<div class="section topic">
		<div class="hgroup">
			<h2>
				<span class="letter letter1"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/tit_signs_01.png" alt="백문이" /></span>
				<span class="letter letter2"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/tit_signs_02.png" alt="불여일" /></span>
				<span class="letter letter3"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/tit_signs_03.png" alt="수" /></span>
			</h2>
			<img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/img_hand.png" alt="" />
		</div>
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/txt_signs.gif" alt="백 번 말하는 것 보다 한 번 손짓 하는 게 낫다" /></p>
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/txt_situation.png" alt="때로는 말 대신 손으로 표현해야할 때가 있죠. 말보다 손짓 카드로 필요한 상황에 센스있게 소통하세요! 이런 상황에 이렇게!" /></p>
	</div>

	<div id="story" class="story">
		<div class="scene scene01">
			<div id="scene011" class="off">
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/txt_story_01_01.gif" alt="회사편 나신입, 날이 춥지? 오리가 얼면? 언덕! 팀장님의 아재개그" /></p>
				<a href="#scene011" class="btnSign"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/btn_sign_01_v2.gif" alt="필요한 손짓?" /></a>
			</div>
			<div id="scene012" class="on">
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/txt_story_01_02_v1.png" alt="팀장님..조..존..경합니다!!! (사실은 뒤집고 싶다)" /></p>
				<a href="#scene012" class="btnBack"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/btn_back.png" alt="Back" /></a>
			</div>
			<div class="line"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_line.png" alt="" /></div>
		</div>

		<div class="scene scene02">
			<div id="scene021" class="off">
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/txt_story_02_01.gif" alt="대학편 동기와의 몰래 접선" /></p>
				<a href="#scene021" class="btnSign"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/btn_sign_02_v1.gif" alt="필요한 손짓?" /></a>
			</div>
			<div id="scene022" class="on">
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/txt_story_02_02_v1.png" alt="(말안해도 센스있게) 티안나게 나와주길" /></p>
				<a href="#scene022" class="btnBack"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/btn_back.png" alt="Back" /></a>
			</div>
			<div class="line"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/bg_line.png" alt="" /></div>
		</div>

		<div class="scene scene03">
			<div id="scene031" class="off">
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/txt_story_03_01.gif" alt="연애편 질투나는 남친의 행동" /></p>
				<a href="#scene031" class="btnSign"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/btn_sign_03_v1.gif" alt="필요한 손짓?" /></a>
			</div>
			<div id="scene032" class="on">
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/txt_story_03_02_v1.png" alt="카드를 얼굴에 올리고 웃자 (쿨내 나는 나란 여자)" /></p>
				<a href="#scene032" class="btnBack"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/btn_back.png" alt="Back" /></a>
			</div>
		</div>
	</div>

	<div class="section goods">
		<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/tit_goods.png" alt="여러분의 상황을 대신해줄 백문이불여일수 카드&amp;포스터를 만나보세요! " /></h3>
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/img_goods.jpg" alt="엽서카드 10종 100x148 mm, 포스터 3종 297x420 mm 포스터는 두번 접어 발송됩니다." /></p>
		<div id="rolling" class="rolling">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/img_slide_01.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/img_slide_02.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/img_slide_03.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/img_slide_04.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/img_slide_05.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/img_slide_06.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/img_slide_07.jpg" alt="" /></div>
				</div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="btnNav btnPrev"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btnNav btnNext"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/btn_next.png" alt="다음" /></button>
		</div>
	</div>

	<div class="comment">
		<div class="form">
			<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
			<input type="hidden" name="mode" value="add">
			<input type="hidden" name="pagereload" value="ON">
			<input type="hidden" name="iCC" value="1">
			<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
			<input type="hidden" name="eventid" value="<%= eCode %>">
			<input type="hidden" name="linkevt" value="<%= eCode %>">
			<input type="hidden" name="blnB" value="">
			<input type="hidden" name="returnurl" value="<%= appUrlPath %>/playing/view.asp?didx=<%=vDIdx%>&pagereload=ON">
			<input type="hidden" name="isApp" value="<%= isApp %>">	
			<input type="hidden" name="spoint"/>
				<fieldset>
				<legend class="hidden">어떤 상황에서 백문이불여일수 어떤 카드를 쓸지 선택하고 팁 작성하기</legend>
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/txt_comment.png" alt="백문이불여일수 카드를 어떤 상황에 쓸지 팁을 남겨주세요! 센스있는 사용팁을 남긴 100분께 백문이불여일수 카드&amp;포스터 세트를 드립니다. 이벤트기간 2월 13일부터 2월 22일까지, 당첨자 발표 2월 23일" /></p>
					<div id="cardSwiper" class="swiperCarousel">
						<div class="swiper-container">
							<div class="swiper-wrapper">
								<div class="swiper-slide card01">
									<label for="card01" val="1"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/img_card_01.png" alt="주먹"/></label>
									<input type="radio" id="card01" name="card" val="1" />
								</div>
								<div class="swiper-slide card02">
									<label for="card02" val="2"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/img_card_02.png" alt="검지"/></label>
									<input type="radio" id="card02" name="card" val="2" />
								</div>
								<div class="swiper-slide card03">
									<label for="card03" val="3"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/img_card_03.png" alt="새끼 손가락"/></label>
									<input type="radio" id="card03" name="card" val="3"/>
								</div>
								<div class="swiper-slide card04">
									<label for="card04" val="4"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/img_card_04.png" alt="엄지척"/></label>
									<input type="radio" id="card04" name="card" val="4"/>
								</div>
								<div class="swiper-slide card05">
									<label for="card05" val="5"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/img_card_05.png" alt="오케이"/></label>
									<input type="radio" id="card05" name="card" val="5"/>
								</div>
								<div class="swiper-slide card06">
									<label for="card06" val="6"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/img_card_06_v1.png" alt="하트"/></label>
									<input type="radio" id="card06" name="card" val="6" />
								</div>
								<div class="swiper-slide card07">
									<label for="card07" val="7"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/img_card_07_v1.png" alt="짱이요"/></label>
									<input type="radio" id="card07" name="card" val="7" />
								</div>
								<div class="swiper-slide card08 other">
									<label for="card08" val="8"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/img_card_08.png" alt="망원경"/></label>
									<input type="radio" id="card08" name="card" val="8"/>
								</div>
								<div class="swiper-slide card09 other">
									<label for="card09" val="9"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/img_card_09.png" alt="TT"/></label>
									<input type="radio" id="card09" name="card" val="9"/>
								</div>
								<div class="swiper-slide card10 other">
									<label for="card10" val="10"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/img_card_10.png" alt="빵야빵야"/></label>
									<input type="radio" id="card10" name="card" val="10"/>
								</div>
							</div>
						</div>
					</div>

					<textarea cols="50" rows="6" title="어떤 상황에서 백문이불여일수 카드를 쓸지 팁 작성" placeholder="80자 이내로 입력해주세요!" id="txtcomm" name="txtcomm" onClick="jsChklogin22('<%=IsUserLoginOK%>');" ></textarea>
					<% If commentcount < 5 Then %>
					<div class="btnSubmit"><input type="image" src="http://webimage.10x10.co.kr/playing/thing/vol008/m/btn_submit.png" alt="응모하기" onclick="jsSubmitComment(document.frmcom);return false;"/></div>
					<% Else %>
					<div class="btnDone"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/btn_done.png" alt="응모완료" onclick="jsSubmitComment(document.frmcom);return false;"/></div>
					<% End If %>
				</fieldset>
			</form>

			<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
			<input type="hidden" name="mode" value="del">
			<input type="hidden" name="pagereload" value="ON">
			<input type="hidden" name="Cidx" value="">
			<input type="hidden" name="returnurl" value="<%= appUrlPath %>/playing/view.asp?didx=<%=vDIdx%>&pagereload=ON">
			<input type="hidden" name="eventid" value="<%= eCode %>">
			<input type="hidden" name="linkevt" value="<%= eCode %>">
			<input type="hidden" name="isApp" value="<%= isApp %>">
			</form>
		</div>

		<% IF isArray(arrCList) THEN %>
		<div class="commentList">
			<ul>
				<%' for dev msg : 한페이지당 3개씩 보여주세요 선택한 카드에 따라 클래스명 bg01 ~ bg10 붙여주세요%>
				<% For intCLoop = 0 To UBound(arrCList,2) %>
				<li class="bg<%=chkiif(arrCList(3,intCLoop)<10,"0","")%><%=arrCList(3,intCLoop)%>">
					<p><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
					<div class="writer">
						<span class="id">
							<% If arrCList(8,intCLoop) <> "W" Then %><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/ico_mobile.png" alt="모바일에서 작성된 글" /> <% End If %><%=printUserId(arrCList(2,intCLoop),4,"*")%>
						</span>
						<span class="no">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
					</div>
					<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
					<button type="button" class="btndel" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/btn_delete.png" alt="내 글 삭제하기" /></button>
					<% End If %>
				</li>
				<% Next %>
			</ul>

			<div class="paging pagingV15a">
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
			</div>
		</div>
		<% End If %>
	</div>

	<div class="section volume">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol008/m/txt_vol008.png" alt="Volume 8 Thing의 사물에 대한 생각 때로는 말보다 손짓이 강하다" /></p>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->