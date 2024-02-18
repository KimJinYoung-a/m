<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : PLAYing 유용한 여행 팁
' History : 2017-12-21 정태훈 생성
'####################################################
%>
<%

dim oItem
dim currenttime
	currenttime =  now()
'	currenttime = #11/09/2016 09:00:00#

Dim eCode , userid , pagereload , vDIdx
IF application("Svr_Info") = "Dev" THEN
	eCode   =  68520
Else
	eCode   =  87142
End If

dim commentcount, i
	userid = GetEncLoginUserID()

If userid <> "" then
	commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")
Else
	commentcount = 0
End If 

vDIdx = request("didx")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),2)

IF blnFull = "" THEN blnFull = True
IF blnBlogURL = "" THEN blnBlogURL = False

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 5		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 6		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 6		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end if

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
.topic {position:relative;}
.topic h2 {position:absolute; left:0; top:16.6%; width:100%;}
.topic .subcopy {position:absolute; left:0; top:44%; width:100%;}
.topic .survey {position:absolute; left:0; bottom:0; width:100%; height:42.08%;}
.topic .survey .tit {position:absolute; left:0; top:0; width:100%;}
.topic .survey .answer {position:absolute; left:0; bottom:0; width:100%;}
.topic .survey .answer:after {content:''; position:absolute; left:0; bottom:0; width:100%; background:url(http://webimage.10x10.co.kr/playing/thing/vol042/m/img_fill.jpg) 0 100% no-repeat; background-size:100% auto;}
.topic .survey .answer.fill:after {animation:fill 1.5s forwards;}
.conclusion {position:relative;}
.conclusion a {position:absolute; left:50%; top:53%; width:74%; margin-left:-37%; animation:bounce 1s 100;}
.comment-write {padding-bottom:3.4rem; background:url(http://webimage.10x10.co.kr/playing/thing/vol042/bg_comment.jpg) 0 0 repeat; background-size:13.3% auto;}
.comment-write div {overflow:hidden; position:relative; width:90%; height:4.69rem; margin:0 auto; padding:0 9.5rem 0 1rem; background:#fff; border-radius:2.13rem;}
.comment-write input {width:100%; height:4.69rem; font-size:1.62rem; font-weight:600; text-align:center; color:#666; border:0;}
.comment-write .btn-recommend {position:absolute; right:0; top:0; width:8.49rem; height:4.69rem; vertical-align:top;}
.comment-list {padding:3.4rem 0 2.47rem; background:url(http://webimage.10x10.co.kr/playing/thing/vol042/m/bg_comment.jpg) 0 0 repeat; background-size:100% auto;}
.comment-list ul {padding:0 6.66%;}
.comment-list li {position:relative; height:4.18rem; margin-top:1.28rem; padding:0 1.7rem; font-size:0.9rem; line-height:4.18rem; letter-spacing:-0.03rem; background:#c0daff;}
.comment-list li:first-child {margin-top:0;}
.comment-list li .btn-delete {position:absolute; right:-4.5%; top:-30%; width:12%; padding:3%;}
.comment-list li p {display:inline-block; float:left;}
.comment-list li .num {width:4.2rem;}
.comment-list li .txt {font-size:1.45rem; font-weight:600;}
.comment-list li .writer {float:right; color:#2157a6;}
.comment-list .pagingV15a {margin-top:2.65rem;}
.comment-list .pagingV15a span {width:2.77rem; height:2.77rem; margin:0 0.34rem; color:#333; font-size:1.28rem; line-height:2.8rem; font-weight:600;}
.comment-list .pagingV15a a {padding-top:0;}
.comment-list .pagingV15a .current {color:#f7dd2e; background:#333; border-radius:50%;}
.comment-list .pagingV15a .arrow a:after {left:0; top:0; width:2.77rem; height:2.77rem; margin:0; background:url(http://webimage.10x10.co.kr/playing/thing/vol042/m/btn_next.png) 0 0 no-repeat; background-size:100% 100%;}
@keyframes bounce {
	from, to {transform:translateY(-5px); animation-timing-function:ease-out;}
	50% {transform:translateY(5px); animation-timing-function:ease-in;}
}
@keyframes fill {
	from {height:0;}
	to {height:100%;}
}
</style>
<script type="text/javascript">
$(function(){
	var position = $('.thingVol042').offset(); // 위치값
	$('html,body').animate({ scrollTop : position.top },300); // 이동

	titleAnimation();
	$(".topic h2").css({"margin-top":"5px","opacity":"0"});
	$(".topic .subcopy").css({"margin-top":"5px","opacity":"0"});
	function titleAnimation() {
		$(".topic h2").delay(100).animate({"margin-top":"0","opacity":"1"},600);
		$(".topic .subcopy").delay(300).animate({"margin-top":"0","opacity":"1"},600);
	}

	function fillAnimation() {
		var window_top = $(window).scrollTop();
		var div_top = $(".topic .label").offset().top;
		if (window_top > div_top){
			$(".topic .survey .answer").addClass("fill");
		}
	}
	$(function() {
		$(window).scroll(fillAnimation);
		fillAnimation();
	});

});
</script>
<script type="text/javascript">
$(function(){
	var position = $('.thingvol041').offset(); // 위치값
	//$('html,body').animate({ scrollTop : position.top },300); // 이동

	$(".topic").addClass("animation");

	$(".hash-link a").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},800);
	});

	<% if pagereload<>"" then %>
		setTimeout("pagedown()",200);
	<% end if %>
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#comment").offset().top}, 0);
}

function jsGoComPage(iP){
	location.replace('/playing/view.asp?didx=<%=vDIdx%>&pagereload=on&iCC=' + iP);
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% if date() >="2018-06-07" and date() <= "2018-06-19" then %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if(!frm.txtcomm.value){
					alert("다음 주제를 입력해주세요.");
					document.frmcom.txtcomm.value="";
					frm.txtcomm.focus();
					return false;
				}

				if (GetByteLength(frm.txtcomm.value) > 20){
					alert("제한길이를 초과하였습니다. 10자 까지 작성 가능합니다.");
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
	<% Else %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
			return false;
		<% end if %>	
	}
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmactNew.Cidx.value = cidx;
   		document.frmactNew.submit();
	}
}
</script>
					<!-- Vol.042 장바구니 탐구생활_우산편 -->
					<div class="thingVol042">
						<div class="topic">
							<p class="label"><img src="http://webimage.10x10.co.kr/playing/thing/vol042/m/txt_label.jpg" alt="장바구니 탐구생활_우산편" /></p>
							<h2><img src="http://webimage.10x10.co.kr/playing/thing/vol042/m/tit_why.png" alt="도대체 왜 매번 우산을 잃어버리는 걸까?" /></h2>
							<p class="subcopy"><img src="http://webimage.10x10.co.kr/playing/thing/vol042/m/txt_subcopy.png" alt="몇 개째 우산을 산 건지 기억도 나지 않는 분들! 그리고 큰맘 먹고 예쁜 우산을 샀는데, 얼마 가지 않아 잃어버린 경험 다들 한 번씩은 있지 않나요?" /></p>
							<div class="survey">
								<p class="tit"><img src="http://webimage.10x10.co.kr/playing/thing/vol042/m/tit_survey.png" alt="우산, 몇 개까지 사봤다" /></p>
								<p class="answer"><img src="http://webimage.10x10.co.kr/playing/thing/vol042/m/img_graph.jpg" alt="" /></p>
							</div>
						</div>
						<div class="question">
							<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol042/m/tit_question.png" alt="어떻게 해야 우산을 잃어 버리지 않을까?" /></h3>
							<ul>
								<li><img src="http://webimage.10x10.co.kr/playing/thing/vol042/m/txt_answer_1.jpg" alt="튀는 색의 우산을 쓰자!" /></li>
								<li><img src="http://webimage.10x10.co.kr/playing/thing/vol042/m/txt_answer_2.jpg" alt="컴팩트하게 가방에 넣자!" /></li>
								<li><img src="http://webimage.10x10.co.kr/playing/thing/vol042/m/txt_answer_3.jpg" alt="스트랩을 이용하자!" /></li>
								<li><img src="http://webimage.10x10.co.kr/playing/thing/vol042/m/txt_answer_4.jpg?v=1" alt="우산 대신 우비를 입자!" /></li>
							</ul>
						</div>
						<div class="conclusion">
							<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol042/m/tit_conclusion.png" alt="우산 잃어버리지 않는 방법으로 이번 장마에는 예쁜 우산 사고 잃어비리지 말아요!" /></h3>
							<a href="/event/eventmain.asp?eventid=87142" class="mWeb"><img src="http://webimage.10x10.co.kr/playing/thing/vol042/m/btn_go.png" alt="우산 관련 소품 보러 가기" /></a>
							<a href="/apps/appCom/wish/web2014//event/eventmain.asp?eventid=87142" onclick="fnAPPpopupEvent('87142'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/playing/thing/vol042/m/btn_go.png" alt="우산 관련 소품 보러 가기" /></a>
						</div>
						<!-- COMMENT -->
						<div class="comment">
							<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol042/m/tit_comment.png" alt="다음 주제는 무엇이 궁금하나요?" /></h3>
							<!-- 코멘트 작성 -->
							<div class="comment-write">
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
								<div>
									<input type="text" id="txtcomm" name="txtcomm" maxlength="10" onClick="jsCheckLimit();" placeholder="10자 이내로 입력" />
									<button type="button" class="btn-recommend" onclick="jsSubmitComment(document.frmcom);return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol042/m/btn_recommend.png" alt="추천" /></button>
								</div>
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
							<!-- 코멘트 목록(6개씩 노출) -->
							<div class="comment-list" id="comment">
								<% If isArray(arrCList) Then %>
								<ul>
									<% For intCLoop = 0 To UBound(arrCList,2) %>
									<li>
										<p class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
										<p class="txt"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
										<p class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%> 님</p>
										<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
										<button type="button" class="btn-delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol042/m/btn_delete.png" alt="코멘트 삭제" /></button>
										<% End If %>
									</li>
									<% Next %>
								</ul>
								<% End If %>
								<div class="paging pagingV15a">
									<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage")%>
								</div>
							</div>
						</div>
						<!--// COMMENT -->
					</div>
					</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->