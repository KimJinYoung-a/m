<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAY 28 M/A
' History : 2016-03-25 김진영 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim eCode, eCodedisp
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66082
Else
	eCode   =  69930
End If

Dim com_egCode, bidx , commentcount, vreload
	vreload	= requestCheckVar(Request("reload"),2)
Dim cEComment
Dim iCTotCnt, arrCList,intCLoop, iSelTotCnt
Dim iCPageSize, iCCurrpage
Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
Dim timeTern, totComCnt, eCC

'파라미터값 받기 & 기본 변수 값 세팅
iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
com_egCode = requestCheckVar(Request("eGC"),1)
eCC = requestCheckVar(Request("eCC"), 1) 

IF iCCurrpage = "" THEN iCCurrpage = 1
IF iCTotCnt = "" THEN iCTotCnt = -1

'// 그룹번호 랜덤으로 지정
iCPageSize = 8		'한 페이지의 보여지는 열의 수
iCPerCnt = 4		'보여지는 페이지 간격

'선택범위 리플개수 접수
Set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  	'전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iSelTotCnt = cEComment.FTotCnt 			'리스트 총 갯수
Set cEComment = nothing

'코멘트 데이터 가져오기
Set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	'cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수
	
	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
Set cEComment = nothing
iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
commentcount = getcommentexistscount(GetEncLoginUserID, eCode, "", "", "", "Y")
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) {html{font-size:12px;}}
@media (min-width:480px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}
.mShower4 {padding-bottom:1rem; font-family:helveticaNeue, helvetica, sans-serif !important;}
.topic {overflow:hidden; position:relative; width:100%;}
.topic span, .topic h2, .topic em {position:absolute; display:block;}
.topic span {width:40.9375%; left:50%; top:14.5%; margin-left:-20.46875%;}
.topic h2 {width:66.71875%; left:50%; top:20.6%; margin-left:-33.359375%;}
.topic em {width:42.8125%;  left:50%; top:30.7%; margin-left:-1.95rem;}

.story02 {position:relative;}
.story02 .frameMask {position:absolute; left:0; top:0; width:100%; height:100%; z-index:20;}
.story02 p {position:absolute; left:35%; bottom:27%; width:45.15625%; z-index:2;}
.story02 span {position:absolute; left:26%; bottom:29%; width:49.53125%; z-index:1;}
.story02 span.shadow {animation-name:flicker; animation-iteration-count:2; animation-duration:2s; animation-timing-function:cubic-bezier(.45,.18,.76,.25); animation-fill-mode:both; -webkit-animation-name:flicker; -webkit-animation-iteration-count:2; -webkit-animation-duration:2s; -webkit-animation-timing-function:cubic-bezier(.45,.18,.76,.25); -webkit-animation-fill-mode:both;}
@keyframes flicker {
	0% {opacity:1;}
	50% {opacity:0;}
	100% {opacity:1;}
}
@-webkit-keyframes flicker {
	0% {opacity:1;}
	50% {opacity:0;}
	100% {opacity:1;}
}

.story03 {position:relative;}
.story03 .sean2 {position:absolute; left:0; top:0; width:100%;}
.story03 span {position:absolute; left:33.7%; top:30%; width:26.71875%; height:28%; vertical-align:top; z-index:50;}
.story03 em {position:absolute; left:22.8125%; top:37%; width:14.21875%; vertical-align:top; z-index:50;}
.story03 i {position:absolute; left:34.21875%; top:52%; width:8.4375%; vertical-align:top; z-index:50;}

.story04 {position:relative;}
.story04 .sean2 {position:absolute; left:0; top:0; width:100%;}
.story04 span {position:absolute; left:68%; top:37%; width:18.28125%; vertical-align:top; z-index:50; background-color:transparent; animation:1s balloon ease-in-out infinite alternate;}
.story04 button {overflow:hidden; position:absolute; left:33%; top:30%; width:56%; height:35%; z-index:100; background-color:transparent; text-indent:-999em; outline:none;}
.story04 em {position:absolute; left:7.65625%; top:57%; width:21.875%; vertical-align:top; z-index:50;}

.story05 {position:relative;}
.story05 p, .story05 span {position:absolute; display:block;}
.story05 p.spin1, .story05 span.spin1 {transition:.2s ease; transform:rotate(0deg);}
.story05 p.spin2, .story05 span.spin2 {transition:.2s ease; transform:rotate(0deg);}
.story05 .obj1 {left:3.4375%; top:27%; width:29.84375%; animation:1000ms swing2 ease 1;}
.story05 .obj2 {right:5.625%; top:21%; width:23.59375%; animation:700ms swing ease 1;}
.story05 .obj3 {left:47.65625%; top:35.6%; width:23.75%; animation:1200ms swing ease 1;}
.story05 .obj4 {right:3.59375%; top:41.1%; width:18.75%; animation:2000ms swing2 ease 1;}
.story05 .obj5 {left:32.1875%; top:44.3%; width:13.4375%;}
.story05 .deco1 {left:24.21875%; top:47.6%; width:4.53125%; animation:700ms swing ease 1;}
.story05 .deco2 {left:49.0625%; top:43.9%; width:5.3125%; animation:500ms swing2 ease 1;}
.story05 .deco3 {left:71.875%; top:53.7%; width:4.84375%; animation:700ms swing ease 1;}
@keyframes swing {
	0% {transform:rotate(-20deg);}
	50% {transform:rotate(-10deg);}
	100% {transform:rotate(0deg);}
}
@keyframes swing2 {
	0% {transform:rotate(30deg);}
	50% {transform:rotate(15deg);}
	100% {transform:rotate(0deg);}
}

.story06 {position:relative;}
.story06 span {position:absolute; left:55%; top:20%; width:18.28125%; vertical-align:top; z-index:50; background-color:transparent; animation:1s balloon ease-in-out infinite alternate;}
@keyframes balloon {
	0% {margin-top:0;}
	50% {margin-top:-0.5rem;}
	100% {margin-top:0;}
}
.story06 button {position:absolute; left:49%; top:30%; width:30%; height:33%; vertical-align:top; z-index:100; background-color:transparent; text-indent:-99em; outline:none;}
.story06 .sean2 {position:absolute; left:0; top:0; width:100%;}

.story07 {position:relative; overflow:hidden;}
.story07 span {position:absolute; left:53.5%; top:26%; width:18.28125%; vertical-align:top; z-index:50; background-color:transparent; animation:1s balloon ease-in-out infinite alternate;}
.story07 i {position:absolute; right:-5%; top:26%; width:28.4375%; vertical-align:top; z-index:100; background-color:transparent;}
.story07 button {position:absolute; left:51%; top:25%; width:25%; height:25%; vertical-align:top; z-index:100; background-color:transparent; text-indent:-99em; outline:none;}
.story07 p {position:absolute; left:50%; top:32.5%; width:44.6875%; margin-left:-22.34375%;}
.story07 em {position:absolute;}
.story07 em.deco1 {position:absolute; left:49.5%; top:30%; width:19.21875%;}
.story07 em.deco2 {position:absolute; left:75%; top:45%; width:6.71875%;}

.story12 {position:relative; overflow:hidden;}
.story12 span {position:absolute; left:13.125%; top:15%; width:18.4375%; vertical-align:top; z-index:50; background-color:transparent; animation:1s balloon ease-in-out infinite alternate;}
.story12 i {position:absolute; right:-5%; top:26%; width:28.4375%; vertical-align:top; z-index:100; background-color:transparent;}
.story12 button {position:absolute; left:12%; top:13%; width:60%; height:35%; vertical-align:top; z-index:100; background-color:transparent; text-indent:-999em; outline:none;}
.story12 p {position:absolute;}
.story12 p.sean1 {left:13%; top:27%; width:52.34375%;}
.story12 p.sean2 {left:24.3%; top:32.2%; width:39.531255%;}
.story12 em {display:block; position:absolute; right:40%; top:25%; width:36.40625%; height:30%; z-index:30; background:url(http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre12_water.png) 50% 0 no-repeat; background-size:100% auto;}

.story13 {position:relative; overflow:hidden;}
.story13 p {position:absolute; left:0; top:0; width:100%;}

.story14 {position:relative;}
.story14 .sean2 {position:absolute; left:0; top:0; width:100%;}
.story14 span, .story14 p {position:absolute; left:50%;}
.story14 .txt1 {top:30%; width:34.53125%; margin-left:-17.265625%;}
.story14 .txt2 {bottom:20%; width:50.15625%; margin-left:-25.078125%;}
.story14 p {bottom:30%; width:78.125%; margin-left:-39.0625%;}

.writerLink {position:relative; margin-top:-1rem;}
.writerLink a {overflow:hidden; display:block; position:absolute; top:31%; width:18.125%; height:45.5%; text-indent:-999em;}
.writerLink a.blogLink {left:57%;}
.writerLink a.instaLink {left:75%;}

.commentlist {background-color:#f8f8f8; padding-top:5.1rem;}
.commentlist .total {text-align:center; font-size:1.2rem; color:#717171;}
.commentlist .total strong {color:#38b5b2; text-decoration:underline; font-weight:bold; font-family:verdana, tahoma, helveticaNeue, helvetica, sans-serif !important;}
.commentlist ul {overflow:hidden; width:100%; padding:0.8rem; margin-top:1rem;}
.commentlist ul li {float:left; width:50%; padding:0.4rem;}
.commentlist ul li div {position:relative; width:100%;}
.commentlist ul li .msg, .commentlist ul li .id, .commentlist ul li .btndel {position:absolute; }
.commentlist ul li .msg {left:11.765%; top:18.834%; line-height:1.3; color:#000; font-size:1.5rem; font-weight:600; font-family:helveticaNeue, helvetica, sans-serif !important; text-align:left;}
.commentlist ul li .msg img {height:1.6rem; width:auto; vertical-align:middle;}
.commentlist ul li .id {left:11.765%; bottom:12%; right:11.765%; border-top:1px solid #fff; padding:0.5rem 0.2rem; color:#fff; font-size:0.95rem;}
.commentlist ul li .id img {width:0.55rem; height:0.8rem; margin-right:0.2rem;}
.commentlist ul li .btndel {position:absolute; right:0; top:0; width:3rem; height:3rem; background-color:transparent; text-align:center; border:none; z-index:20;}
.commentlist ul li .btndel img {width:1.5rem; height:1.5rem;}
.commentlist ul li:nth-child(2n) div { background-color:#52cfe1;}
.commentlist ul li:nth-child(2n+1) div { background-color:#58c0e7;}
.commentlist ul li:nth-child(4n) div { background-color:#78b2e4;}
.commentlist ul li:nth-child(4n+1) div { background-color:#5acecc;}
.commentlist ul li:first-child div { background-color:#5acecc;}
.commentWrite {position:relative; padding-bottom:7.65rem; background-color:#ace4e3;}
.commentWrite:after {position:absolute; left:50%; top:100%; width:1.3rem; height:1.05rem; margin-left:-0.65rem; content:''; background:url(http://webimage.10x10.co.kr/playmo/ground/20160328/img_cmt_deco.png) 50% 0 no-repeat; background-size:1.3rem auto;}
.commentWrite div {margin-top:2.2rem;}
.commentWrite button {margin-top:3.5rem; margin-left:45%; width:13.5rem; height:4.5rem; border:2px solid #1d9d99; background-color:#38b5b2; border-radius:0.5rem; outline:none;}
.commentWrite button img {width:3.15rem;}
.commentWrite .cmtInpt {width:27.2rem; margin:0 auto; background:url(http://webimage.10x10.co.kr/playmo/ground/20160328/bg_cmt_input.png) 50% 0 no-repeat; background-size:27.2rem auto;}
.commentWrite .cmtInpt input {height:4.6rem; background-color:transparent; border:none; color:#cdcdcd; font-size:2.1rem; text-align:left; letter-spacing:2.7rem; padding:1.35rem; font-family:helveticaNeue, helvetica, sans-serif !important; font-weight:bold;}
.commentWrite i {position:absolute; right:50%; top:50%; display:block; width:11rem; height:9.05rem; margin-right:0.8rem; margin-top:-1rem; background:url(http://webimage.10x10.co.kr/playmo/ground/20160328/img_cmt_char.png) 50% 0 no-repeat; background-size:11rem auto;}
</style>
<script type="text/javascript">
$(function(){
	/* animation */
	$(window.parent).scroll(function(){
		var scrollTop = $(window.parent).scrollTop();
		if (scrollTop > 950.0) {
			storytelling()
		}
		if (scrollTop > 1250.0) {
			sean1()
		}
		if (scrollTop > 2650.0) {
			motion1()
		}
		if (scrollTop > 7000.0) {
			motion2()
		}
		if (scrollTop > 7600.0) {
			endingAnimation()
		}
	});

	$("#titleAnimation span, #titleAnimation h2, #titleAnimation em").css({"opacity":"0"});
	$("#titleAnimation h2").css({"top":"23%"});
	function titleAnimation() {
		$("#titleAnimation h2").delay(100).animate({"top":"20.6%", "opacity":"1"},1200);
		$("#titleAnimation span").delay(50).animate({"opacity":"1"},1500);
		$("#titleAnimation em").delay(300).animate({"opacity":"1"},1500);
	}
	titleAnimation();

	$(".story02 p").css({"left":"0", "opacity":"0"});
	$(".story02 span").css({"opacity":"0"});
	function storytelling() {
		$(".story02 p").delay(100).animate({"left":"37%", "opacity":"1"},1900);
		$(".story02 span").animate({"opacity":"1"},1900).delay(2000).addClass("shadow");
	}

	$(".story03 .sean2, .story03 span, .story03 em, .story03 i").css({"opacity":"0"});
	$('.story03 span').css({"height":"0"});
	function sean1() {
		$(".story03 .sean1").animate({"opacity":"0"},1600);
		$(".story03 .sean2").animate({"opacity":"1"},1600, function(){
			$('.story03 span').animate({"height":"28%", "opacity":"1"},800);
			$('.story03 i').delay(700).animate({"opacity":"1"},500);
			$('.story03 em').delay(900).animate({"opacity":"1"},800);
		});
	}

	$(".story04 .sean2").css({"opacity":"0"});
	$(".story04 .deco2").css({"opacity":"0"});
	$('.story04 button').click(function(){
		$(".story04 .sean1").delay(200).animate({"opacity":"0"},100);
		$(".story04 .sean2").delay(200).animate({"opacity":"1"},150, function(){
			$('.story04 .deco1').delay(500).animate({"opacity":"0"},100);
			$('.story04 .deco2').delay(500).animate({"opacity":"1"},100);
			$('.story04 span').fadeOut();
			$('.story04 button').hide();
		});
	});

	$(".story05 p, .story05 span").css({"opacity":"0"});
	$(".story05 .obj1").css({"left":"5%", "top":"30%"});
	$(".story05 .obj2").css({"right":"7%", "top":"25%"});
	$(".story05 .obj3").css({"top":"37%"});
	$(".story05 .obj4").css({"right":"10%", "top":"45%"});
	$(".story05 .obj5").css({"left":"35%", "top":"53%"});
	function motion1() {
		$(".story05 .obj1").delay(100).animate({"left":"3.4375%", "top":"27%", "opacity":"1"},700);
		$(".story05 .obj2").delay(200).animate({"right":"5.625%", "top":"21%", "opacity":"1"},500);
		$(".story05 .obj3").delay(400).animate({"top":"35.6%", "opacity":"1"},500);
		$(".story05 .obj4").delay(700).animate({"right":"3.59375%", "top":"41.1%", "opacity":"1"},500);
		$(".story05 .obj5").delay(900).animate({"left":"32.1875%", "top":"44.3%", "opacity":"1"},500);
		$(".story05 .deco1").delay(100).animate({"opacity":"1"},500);
		$(".story05 .deco2").delay(500).animate({"opacity":"1"},500);
		$(".story05 .deco3").delay(800).animate({"opacity":"1"},1000);
	}

	$(".story06 .sean2").css({"opacity":"0"});
	$('.story06 button, .story06 span').click(function(){
		$(".story06 .sean1").animate({"opacity":"0"},1500);
		$(".story06 .sean2").animate({"opacity":"1"},1500);
		$('.story06 span').fadeOut();
		$('.story06 button').hide();
	});

	$(".story07 .sean2").hide();
	$(".story07 em").css({"opacity":"0"});
	$('.story07 button').click(function(){
		$(".story07 i").animate({"right":"10%", "top":"30%"}, 650, function(){
			$(".story07 .deco1").delay(400).animate({"opacity":"1"},500);
			$(".story07 .deco2").delay(550).animate({"opacity":"1"},500);
			$(".story07 .sean2").show();
			$(".story07 .sean1").hide();
			$('.story07 span').fadeOut();
			$('.story07 button').hide();
		});
	});

	$(".story12 .sean2").css({"opacity":"0"});
	$(".story12 em").css({"height":"10%", "opacity":"0"});
	$('.story12 button').click(function(){
		$(".story12 em").animate({"height":"30%", "opacity":"1"}, 750, function(){
			$(".story12 .sean2").animate({"opacity":"1"},800);
			$(".story12 .sean1").animate({"opacity":"0"},800);
			$('.story12 span').fadeOut();
			$('.story12 button').hide();
		});
	});

	$(".story13 p").css({"left":"80%", "opacity":"0"});
	function motion2() {
		$(".story13 p").delay(100).animate({"left":"0", "opacity":"1"},2700);
	}

	$(".story14 .sean2").css({"opacity":"0"});
	$(".story14 .sean1 .txt1").css({"top":"20%", "opacity":"0"});
	$(".story14 .sean1 p").css({"bottom":"20%", "opacity":"0"});
	$(".story14 .sean2 .txt2").css({"bottom":"10%", "opacity":"0"});
	function endingAnimation() {
		$(".story14 .sean1 .txt1").delay(100).animate({"top":"30%", "opacity":"1"},1500);
		$(".story14 .sean1 p").delay(100).animate({"bottom":"30%", "opacity":"1"},3000);
		$(".story14 .sean1").delay(4000).animate({"opacity":"0"},2000);
		$(".story14 .sean2").delay(4000).animate({"opacity":"1"},2000);
		$(".story14 .sean2 .txt2").delay(4100).animate({"bottom":"20%", "opacity":"1"},2000);
	}

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".ma").show();
			$(".mw").hide();
	}else{
			$(".ma").hide();
			$(".mw").show();
	}
});
</script>
<script type="text/javascript">
function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If Not(IsUserLoginOK) Then %>
		<% If isApp = "1" or isApp = "2" Then %>
			parent.calllogin();
			return false;
		<% Else %>
			parent.jsevtlogin();
			return;
		<% End If %>			
	<% End If %>
	
	if(!frm.txtcomm.value){
		alert("빈칸을 입력해주세요");
		document.frmcom.txtcomm.value="";
		frm.txtcomm.focus();
		return false;
	}
	if (GetByteLength(frm.txtcomm.value) > 10){
		alert("제한길이를 초과하였습니다. 5자 이내로 적어주세요.");
		frm.txtcomm.focus();
		return false;
	}
	frm.action = "/play/groundcnt/doEventSubscript69930.asp";
	return true;
}
function chkHangul(v){
	var han_check = /([^가-힣ㄱ-ㅎㅏ-ㅣ\x20])/i; 
	if (han_check.test(v)){
		alert("한글만 입력할 수 있습니다.");
		document.frmcom.txtcomm.value = "";
		document.frmcom.txtcomm.focus();
		return false;
	}
}
function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmdelcom.Cidx.value = cidx;
		document.frmdelcom.submit();
	}
}

function jsChklogin22(blnLogin){
	if (blnLogin == "True"){
		if(document.frmcom.txtcomm.value =="5자 이내로 적어주세요."){
			document.frmcom.txtcomm.value="";
		}
		return true;
	} else {
	<% If isApp = "1" or isApp = "2" Then %>
		parent.calllogin();
		return false;
	<% Else %>
		parent.jsevtlogin();
		return;
	<% End If %>			
	}
	return false;
}
</script>
<div class="mShower4">
	<div id="titleAnimation" class="topic">
		<span><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/tit_txt_collabo.png" alt="텐바이텐 x 김그래" /></span>
		<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/tit_txt_shower.png" alt="공감샤워" /></h2>
		<em><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/tit_txt_daily_wash.png" alt="하루를 씻어요" /></em>
		<img src="http://webimage.10x10.co.kr/playmo/ground/20160328/tit_bg_shower.png" alt="" />
	</div>
	<div class="">
		<div style="margin-top:-0.3rem"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre01.jpg" alt="다녀왔습니다" /></div>
		<div class="story02">
			<img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre02_mask.gif" alt="" class="frameMask" />
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre02_char.png" alt="으 피곤..." /></p>
			<span><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre02_char_deco.png" alt="" /></span>
			<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre02.jpg" alt="" /></div>
		</div>
		<div class="story03">
			<p class="sean1"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre03_1.png" alt="" /></p>
			<p class="sean2">
				<span><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre03_light.png" alt="" /></span>
				<i><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre03_sigh.png" alt="" /></i>
				<em><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre03_txt2.png" alt="하아" /></em>
				<img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre03_22.png" alt="" />
			</p>
		</div>
		<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre03_txt.jpg" alt="" /></div>
		<div class="story04">
			<button>클릭</button>
			<span><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_click_btn.png" alt="CLICK" /></span>
			<em class="deco1"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre04_basket.png" alt="" /></em>
			<em class="deco2"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre04_basket2.png" alt="" /></em>
			<p class="sean1"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre04_1.jpg" alt="" /></p>
			<p class="sean2"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre04_2.jpg" alt="" /></p>
		</div>
		<div class="story05">
			<p class="obj1"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre05_object1.png" alt="" /></p>
			<p class="obj2"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre05_object2.png" alt="" /></p>
			<p class="obj3"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre05_object3.png" alt="" /></p>
			<p class="obj4"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre05_object4.png" alt="" /></p>
			<p class="obj5"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre05_object5.png" alt="" /></p>
			<span class="deco1"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre05_deco1.png" alt="" /></span>
			<span class="deco2"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre05_deco2.png" alt="" /></span>
			<span class="deco3"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre05_deco3.png" alt="" /></span>
			<img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre05.png" alt="" />
		</div>
		<div class="story06">
			<button>클릭</button>
			<span><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_click_btn.png" alt="CLICK" /></span>
			<p class="sean1"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre06_1.png" alt="" /></p>
			<p class="sean2"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre06_2.png" alt="" /></p>
		</div>
		<div class="story07">
			<button>클릭</button>
			<span><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_click_btn.png" alt="CLICK" /></span>
			<i><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre07_hand.png" alt="hand" /></i>
			<em class="deco1"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre07_txt.png" alt="달칵" /></em>
			<em class="deco2"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre07_deco.png" alt="" /></em>
			<p class="sean1"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre07_radio_01.png" alt="RADIO" /></p>
			<p class="sean2"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre07_radio_02.png" alt="RADIO" /></p>
			<img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre07.jpg" alt="" />
		</div>
		<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre09.gif" alt="" /></div>
		<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre10.gif" alt="" /></div>
		<div style="margin-top:-1rem"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre11.gif" alt="" /></div>
		<div class="story12">
			<button>클릭</button>
			<span><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_click_btn2.png" alt="CLICK" /></span>
			<em></em>
			<p class="sean1"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre12_char1.png" alt="" /></p>
			<p class="sean2"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre12_char2.png" alt="" /></p>
			<img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre12.jpg" alt="" />
		</div>
		<div class="story13">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre13_2.gif" alt="" /></p>
			<img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre13.jpg" alt="샤워가 모두 끝났습니다" />
		</div>
		<div class="story14">
			<div class="sean1">
				<span class="txt1"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre14_txt1.png" alt="오늘 하루도" /></span>
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre14_bd.png" alt="" /></p>
				<img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre14_1.jpg" alt="" />
			</div>
			<div class="sean2">
				<span class="txt2"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre14_txt2.png" alt="수고했습니다" /></span>
				<img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre14_2.jpg" alt="" />
			</div>
		</div>
	</div>
	<div class="writerLink">
		<a href="http://blog.naver.com/gimgre" target="_blank" class="blogLink mw">blog</a>
		<a href="https://www.instagram.com/gimgre/" target="_blank" class="instaLink mw">Insta</a>
		<a href="" onclick="fnAPPpopupExternalBrowser('http://blog.naver.com/gimgre'); return false;" class="blogLink ma">blog</a>
		<a href="" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/gimgre/'); return false;" class="instaLink ma">Insta</a>
		<img src="http://webimage.10x10.co.kr/playmo/ground/20160328/img_gre_link.png" alt="김그래 - 일상의 이야기들을 그리고 씁니다" />
	</div>

	<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/tit_cmt_description.png" alt="즐거운 샤워 시간 되셨나요? 여러분의 샤워 이야기를 5글자 내로 남겨주세요!" /></h2>
	<div class="commentWrite" id="commentWrite">
		<strong><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/tit_cmt.png" alt="나의 샤워는" /></strong>
		<div>
			<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>"/>
			<input type="hidden" name="bidx" value="<%=bidx%>"/>
			<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
			<input type="hidden" name="iCTot" value=""/>
			<input type="hidden" name="mode" value="add"/>
			<input type="hidden" name="userid" value="<%=GetEncLoginUserID%>"/>
			<input type="hidden" name="eCC" value="1">
			<input type="hidden" name="reload" value="ON">
				<div class="cmtInpt"><input type="text" name="txtcomm" maxlength="5" style="width:100%;" onkeyup="chkHangul(this.value);" onClick="jsChklogin22('<%=IsUserLoginOK%>');" /></div>
				<button><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/btn_cmt_input.png" alt="입력" onclick="jsSubmitComment(this);" /></button>
				<i></i>
			</form>
		</div>
	</div>

	<form name="frmdelcom" method="post" action="/event/lib/comment_process.asp" style="margin:0px;">
	<input type="hidden" name="eventid" value="<%=eCode%>">
	<input type="hidden" name="bidx" value="<%=bidx%>">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="userid" value="<%=GetEncLoginUserID%>">
	</form>
	<% IF isArray(arrCList) THEN %>
	<div class="commentlist">
		<p class="total">현재 <strong><%=FormatNumber(iCTotCnt,0)%></strong>명 샤워 중!</p>
		<ul>
			<% For intCLoop = 0 To UBound(arrCList,2) %>
			<li>
				<div>
					<img src="http://webimage.10x10.co.kr/playmo/ground/20160328/bg_cmtbox.png" alt="" />
					<p class="msg"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/txt_cmt1.png" alt="나의 샤워는" /><br /><%=arrCList(1,intCLoop)%> <img src="http://webimage.10x10.co.kr/playmo/ground/20160328/txt_cmt2.png" alt="다" /></p>
					<p class="id"><% If arrCList(8,intCLoop) = "M" Then %><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/ico_mobile.png" alt="모바일에서 작성된 글" /><% End If %><%=printUserId(arrCList(2,intCLoop),2,"*")%></p>
					<% if ((GetEncLoginUserID = arrCList(2,intCLoop)) or (GetEncLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
					<button type="button" class="btndel" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160328/btn_del.png" alt="삭제" /></button>
					<% End If %>
				</div>
			</li>
			<% Next %>
		</ul>
		<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
	</div>
	<% End If %>
</div>
<script type="text/javascript">
	<% if vreload<>"" then %>
		$('html,body').animate({scrollTop: $("#commentWrite").offset().top},0);
	<% end if %>
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->