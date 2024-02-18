<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAYing 1월의 Thing 함께해요 윷마블
' History : 2017-01-13 원승현 생성
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
Dim eCode , userid , strSql , totcnt , pagereload , totcntall, vDIdx

IF application("Svr_Info") = "Dev" THEN
	eCode   =  66265
Else
	eCode   =  75729
End If

vDIdx = request("didx")
pagereload	= requestCheckVar(request("pagereload"),2)
commentcount = getcommentexistscount(GetEncLoginUserID, eCode, "", "", "", "Y")


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
	iCPerCnt = 4		'보여지는 페이지 간격

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

%>
<style type="text/css">
.yutmarble .topic {padding:24% 0 16.78%; background:#65b690 url(http://webimage.10x10.co.kr/playing/thing/vol006/m/bg_yut.png) 50% 0 no-repeat; background-size:100% auto;}
.yutmarble .topic {animation:snowing 7s linear 2; -webkit-animation:snowing 5s linear 3 forwards;}
@keyframes snowing {
	0% {background-position:50% 0;}
	50% {background-position:50% -30px;}
	100%{background-position:50% 0;}
}
@-webkit-keyframes snowing {
	0% {background-position:50% 0;}
	50% {background-position:50% -30px;}
	100%{background-position:50% 0;}
}
.yutmarble .topic .title {position:relative; width:47.65%; margin:0 auto; padding:0;}
.yutmarble .topic .title:after {display:none;}
.yutmarble .topic .title span {display:block; position:absolute; width:24.59%;}
.yutmarble .topic .title .letter1 {top:0; left:4.91%;}
.yutmarble .topic .title .letter2 {top:0; left:29.5%; width:26.22%;}
.yutmarble .topic .title .letter3 {top:0; left:55.7%; width:20.65%;}
.yutmarble .topic .title .letter4 {top:0; left:76.2%; width:18.68%;}
.yutmarble .topic .title .letter5 {bottom:-5%; left:0; width:100%;}
.yutmarble .topic .desc {width:56.718%; margin:14% auto 0;}

.yutmarble .when {background-color:#c2824e;}
.yutmarble .when .family {position:relative;}
.yutmarble .when .family .check {position:absolute; top:59%; left:17.65%; width:3.9%;}
.yutmarble .when .family .check span {display:block;}
.yutmarble .when .family .check span {opacity:0;}
.slideUp {
	animation:slideUp 2s cubic-bezier(0.19, 1, 0.22, 1) forwards;
	-webkit-animation:slideUp 2s cubic-bezier(0.19, 1, 0.22, 1) forwards;
}

.yutmarble .when .family .check span:nth-child(2) {animation-delay:0.3s; -webkit-animation-delay:0.3s;}
.yutmarble .when .family .check span:nth-child(3) {animation-delay:0.6s; -webkit-animation-delay:0.6s;}
.yutmarble .when .family .check span:nth-child(4) {animation-delay:0.9s; -webkit-animation-delay:0.9s;}
@keyframes slideUp {
	0% {margin-top:-50%; opacity:0;}
	100% {margin-top:0; opacity:1;}
}
@-webkit-keyframes slideUp {
	0% {margin-top:-50%; opacity:0;}
	100% {margin-top:0; opacity:1;}
}

.yutmarble .intro {background-color:#8a5b44;}

.yutmarble .letsPlay {background-color:#c9ddc8;}

.yutmarble .form {position:relative; padding-bottom:9%; background-color:#e36841;}
.yutmarble .form legend {overflow:hidden; visibility:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}
.yutmarble .form .textarea {position:relative; width:25.25rem; height:15.35rem; margin:0 auto; padding:2.3rem 2.6rem; border:none; border-radius:0.4rem; background-color:#fff; text-align:left;}
.yutmarble .form .textarea textarea {width:100%; height:100%; border:none; border-radius:0; color:#909090; font-size:1.2rem;}
.yutmarble .form .btnSubmit,
.yutmarble .form .btnDone {width:17.6rem; margin:1.75rem auto 0;}
.yutmarble .form .btnSubmit input {width:100%;}
.yutmarble .form .kids {position:absolute; top:-1.8rem; left:0; width:100%;}
.yutmarble .form .kids span {position:absolute; width:4.05rem;}
.yutmarble .form .kids span:first-child {left:16rem;}
.yutmarble .form .kids span:last-child {right:1rem;}

.yutmarble .comment {padding:3.3rem 0 2.85rem; background-color:#c9ddc8;}
.yutmarble .comment ul {width:27.25rem; margin:0 auto;}
.yutmarble .comment ul li {position:relative; margin-top:1.1rem; padding:2rem 2.3rem; border-radius:0.4rem; background-color:#fff; font-size:1.1rem; line-height:1.688rem;}
.yutmarble .comment ul li .writer {position:relative; color:#86563e;}
.yutmarble .comment ul li .writer .id {overflow:hidden; display:inline-block; width:80%; text-overflow:ellipsis; white-space:nowrap;}
.yutmarble .comment ul li .writer .id span {font-weight:bold;}
.yutmarble .comment ul li .writer .id img {width:0.6rem; vertical-align:-2px;}
.yutmarble .comment ul li .no {position:absolute; top:0; right:0; color:#b0beaf;}
.yutmarble .comment ul li p {margin-top:1.3rem; color:#909090;}
/*.yutmarble .comment ul li p {overflow-y:scroll; -webkit-overflow-scrolling:touch; height:5rem; margin:1.2rem 1rem 0 2.3rem; padding-right:2rem; color:#909090;}
.yutmarble .comment ul li p::-webkit-scrollbar {width:0.5rem;}
.yutmarble .comment ul li p::-webkit-scrollbar-thumb {background-color:#c3d6c2; border-radius:0.5rem;}*/
.yutmarble .comment .btndel {position:absolute; top:-0.75rem; right:-0.65rem; width:2.5rem; background-color:transparent;}

.pagingV15a span {color:#6c846b;}
.pagingV15a .current {color:#86563e;}
.pagingV15a .arrow a:after {background-position:-5.8rem -9.56rem;}
/*.pagingV15a {margin-top:2.1rem; width:100%;}
.pagingV15a span {width:3.05rem; height:2.35rem; margin:0; border:0; border-radius:0.4rem;}
.pagingV15a span a {color:#fff; font-size:1.2rem; font-weight:bold; line-height:0.75rem;}
.pagingV15a span.current {background-color:#86563e;}
.pagingV15a span.current a {color:#fff;}
.pagingV15a span.arrow {border:0; background:url(http://webimage.10x10.co.kr/playing/thing/vol004/m/btn_pagination_prev.png) 50% 50% no-repeat; background-size:100% auto;}
.pagingV15a span.nextBtn {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol004/m/btn_pagination_next.png);}*/

/* css3 animation */
.move {animation:move 1.2s; -webkit-animation:move 1.2s;}
.moveRight {animation:moveRight 1.2s; -webkit-animation:moveRight 1.2s;}
@keyframes move {
	0% {left:70%;}
	100% {left:60.2%;}
}
@-webkit-keyframes move {
	0% {left:70%;}
	100% {left:60.2%;}
}
@keyframes moveRight {
	0% {right:25%;}
	100% {right:14.375%;}
}
@-webkit-keyframes moveRight {
	0% {right:25%;}
	100% {right:14.375%;}
}

.shake1 {animation:shake 6 1s; -webkit-animation:shake 6 1s;}
.shake2 {animation:shake2 6 1s; -webkit-animation:shake2 6 1s;}
@keyframes shake {
	0% {transform: rotate(-1deg);}
	50% {transform: rotate(10deg);}
	100% {transform: rotate(-1deg);}
}
@keyframes shake2 {
	0% {transform: rotate(1deg);}
	50% {transform: rotate(-10deg);}
	100% {transform: rotate(1deg);}
}

@-webkit-keyframes shake {
	0% {-webkit-transform: rotate(-1deg);}
	50% {-webkit-transform: rotate(10deg);}
	100% {-webkit-transform: rotate(-1deg);}
}
@-webkit-keyframes shake2 {
	0% {-webkit-transform: rotate(1deg);}
	50% {-webkit-transform: rotate(-10deg);}
	100% {-webkit-transform: rotate(1deg);}
}
</style>
<script type="text/javascript">
$(function(){
	/* ttle animation */
	titleAnimation();
	$("#topic .title span").css({"margin-top":"3.5%","opacity":"0"});
	$("#topic .title .letter5").css({"margin-bottom":"-7%","opacity":"0"});
	function titleAnimation() {
		$("#topic .title .letter1").delay(200).animate({"margin-top":"-3.5%", "opacity":"1"},400).animate({"margin-top":"0"},300);
		$("#topic .title .letter2").delay(500).animate({"margin-top":"-3.5%", "opacity":"1"},400).animate({"margin-top":"0"},300);
		$("#topic .title .letter3").delay(800).animate({"margin-top":"-3.5%", "opacity":"1"},400).animate({"margin-top":"0"},300);
		$("#topic .title .letter4").delay(1100).animate({"margin-top":"-3.5%", "opacity":"1"},400).animate({"margin-top":"0"},300);
		$("#topic .title .letter5").delay(1500).animate({"margin-bottom":"0", "opacity":"1"},400).animate({"margin-bottom":"-7%", "opacity":"1"},300).animate({"margin-bottom":"0"},300);
	}

	function checkAnimation() {
		var window_top = $(window).scrollTop();
		var div_top = $("#when").offset().top/2;
		if (window_top > div_top){
				$("#check span").addClass("slideUp");
		} else {
				$("#check span").removeClass("slideUp");
		}
	}

	$(function() {
		$(window).scroll(checkAnimation);
		checkAnimation();
	});

	/* kids animation */
	$("#form .kids span").css({"opacity":"0"});
	function penAnimation() {
		var window_top = $(window).scrollTop();
		var div_top = $("#form").offset().top;
		if (window_top > div_top){
			$("#form .kids span:first-child").addClass("shake1");
			$("#form .kids span:last-child").addClass("shake2");
			$("#form .kids span").css({"opacity":"1"});
		} else {
			$("#form .kids span:first-child").removeClass("shake1");
			$("#form .kids span:last-child").removeClass("shake2");
		}
	}

	$(function() {
		$(window).scroll(penAnimation);
		penAnimation();
	});

	<% if pagereload<>"" then %>
		setTimeout("pagedown()",200);
	<% end if %>
});


function pagedown(){
	window.$('html,body').animate({scrollTop:$(".comment").offset().top}, 0);
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

	<% if commentcount>0 then %>
		alert("이벤트는 한번만 참여 가능 합니다.");
		return false;
	<% else %>
		if(!frm.txtcomm.value){
			alert("윷마블이 필요한 사연을 적어주세요.");
			document.frmcom.txtcomm.value="";
			frm.txtcomm.focus();
			return false;
		}

		if (GetByteLength(frm.txtcomm.value) > 300){
			alert("제한길이를 초과하였습니다. 150자 까지 작성 가능합니다.");
			frm.txtcomm.focus();
			return false;
		}

		frm.action = "/event/lib/doEventComment.asp";
		frm.submit();
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
//		if(document.frmcom.txtcomm.value =="9자 이내로 입력"){
//			document.frmcom.txtcomm.value="";
//		}
		<% if commentcount>0 then %>
			alert("이미 신청완료 되었습니다.");
			document.getElementById("txtcomm").disabled=true;
			return false;
		<% end if %>
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
<div class="thingVol006 yutmarble">
	<div id="topic" class="section topic">
		<p class="title">
			<img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/tit_white.png" alt="" />
			<span class="letter letter1"><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/tit_yut_marble_01.png" alt="함" /></span>
			<span class="letter letter2"><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/tit_yut_marble_02.png" alt="께" /></span>
			<span class="letter letter3"><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/tit_yut_marble_03.png" alt="해" /></span>
			<span class="letter letter4"><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/tit_yut_marble_04.png" alt="요" /></span>
			<span class="letter letter5"><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/tit_yut_marble_05.png" alt="윷마블" /></span>
		</p>
		<p class="desc"><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/txt_yut_marble.png" alt="새해 첫 달 1월, 가족들과의 시간 가지셨나요? 텐바이텐 PLAYing에서 다가오는 명절에 온 가족이 함께 즐길 수 있는 놀이를 만들었습니다. 윷마블로 가족들과 함께하세요!" /></p>
	</div>

	<div id="when" class="section when">
		<div class="family">
			<div id="check" class="check">
				<span><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/ico_check_v1.png" alt="" /></span>
				<span><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/ico_check_v1.png" alt="" /></span>
				<span><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/ico_check_v1.png" alt="" /></span>
				<span><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/ico_check_v1.png" alt="" /></span>
			</div>
			<p><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/txt_my_family.gif" alt="우리 가족 이럴 때 있다면 함께 있어도 따로 노는 가족, 핸드폰 게임만 하는 아이들, 식사 시간에 딱히 할 이야기가 없어 조용한 가족,세대차이 때문에 대화에 공감하지 못할 때" /></p>
		</div>
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/txt_start.gif" alt="윷마블을 펼치세요!" /></p>
	</div>
	
	<div id="intro" class="section intro">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/txt_intro_01_v1.png" alt="윷마블이란 전통게임 윷놀이와 카드게임의 융합! 어른과 아이 모두 함께 즐길 수 있는 보드게임" /></p>
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/txt_intro_02.png" alt="말판, 카드 24장, 말 10개, 윷 4개로 구성되어 있어요" /></p>
		<p>
			<img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/txt_intro_03_01.gif" alt="놀이 방법 및 규칙은요! 함께 모여 팀을 만들고, 윷을 던져 말을 이동하세요! 함께 모여 팀을 만들고, 윷을 던져 말을 이동하세요!" />
			<img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/txt_intro_03_02.gif" alt="출발점으로 모든 말이 먼저 돌아오면 승리!" />
		</p>
	</div>

	<div class="section letsPlay">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/txt_lets_play_animation.gif" alt="Let&#39;s Play 윷마블은 PLAYing LIMITED EDITION으로 50개 한정으로 제작한 상품입니다! 이 상품은 PLAYing에서만 만날 수 있습니다." /></p>
	</div>

	<!-- form -->
	<div id="form" class="section form">
		<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
		<input type="hidden" name="mode" value="add">
		<input type="hidden" name="pagereload" value="ON">
		<input type="hidden" name="iCC" value="1">
		<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
		<input type="hidden" name="eventid" value="<%= eCode %>">
		<input type="hidden" name="linkevt" value="<%= eCode %>">
		<input type="hidden" name="blnB" value="">
		<input type="hidden" name="returnurl" value="<%= appUrlPath %>/playing/view.asp?didx=<%=vDIdx%>&pagereload=ON">
		<input type="hidden" name="gubunval">
		<input type="hidden" name="isApp" value="<%= isApp %>">	
			<fieldset>
			<legend>윷마블이 필요한 우리 가족을 소개 글 쓰기</legend>
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/txt_comment_v1.gif" alt="윷마블이 필요한 우리 가족을 소개해주세요! 재미있는 사연 중 추첨을 통해 50분께 윷마블을 드립니다. 이벤트기간은 1월 16일부터 1월 22일까지며, 당첨자 발표는 1월 23일입니다. 설 전 배송 예정. 기본 배송지를 미리 확인해주세요!" /></p>
				<div class="textarea">
					<div class="kids">
						<span><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/img_kids_01.png" alt="" /></span>
						<span><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/img_kids_02.png" alt="" /></span>
					</div>
					<textarea cols="50" rows="6" title="윷마블이 필요한 우리 가족을 소개 글 작성" placeholder="150자 이내로 입력해주세요" id="txtcomm" name="txtcomm" onClick="jsChklogin22('<%=IsUserLoginOK%>');" ></textarea>
				</div>
				<% if commentcount>0 then %>
					<div class="btnDone"><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/btn_done.png" alt="윷마블 신청완료" /></div>
				<% Else %>
					<div class="btnSubmit"><input type="image" src="http://webimage.10x10.co.kr/playing/thing/vol006/m/btn_submit.png" alt="윷마블 신청하기" onclick="jsSubmitComment(document.frmcom);return false;" /></div>
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

	<!-- comment list -->
	<% IF isArray(arrCList) THEN %>
	<div class="section comment">
		<ul>
			<%' for dev msg : 한페이지당 3개씩 보여주세요 %>
			<% For intCLoop = 0 To UBound(arrCList,2) %>
			<li>
				<div class="writer">
					<span class="id">
						<% If arrCList(8,intCLoop) <> "W" Then %><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/ico_mobile.png" alt="모바일에서 작성된 글" /> <% End If %><%=printUserId(arrCList(2,intCLoop),2,"*")%><span>님의 가족은요!</span>
					</span>
					<span class="no">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
				</div>
				<p><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
				<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
					<button type="button" class="btndel" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/btn_delete.png" alt="내 글 삭제하기" /></button>
				<% End If %>
			</li>
			<% Next %>
		</ul>

		<!-- pagination -->
		<div class="paging pagingV15a">
			<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
		</div>
	</div>
	<% End If %>
	
	<!-- volume -->
	<div class="section volume">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol006/m/txt_vol006.png" alt="Volume 6 Thing의 사물에 대한 생각 가족들과 함께 즐길 수 있는 놀이, 윷마블" /></p>
	</div>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->