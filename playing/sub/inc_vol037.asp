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
' Description : PLAYing 연말정산
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
	eCode   =  67505
Else
	eCode   =  85276
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

iCPerCnt = 6		'보여지는 페이지 간격
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
.topic h2 {}
.topic h2 span {display:inline-block; position:absolute; left:0; z-index:20; width:100%;}
.topic h2 .t1 {top:13%; opacity:0; transition:all 1s .6s;}
.topic h2 .t2 {top:27%; opacity:0; transition:all 1s 1.7s;}
.topic h2 .line {width:1px; height:0.34rem; top:22%; left:8%; background-color:#000; opacity:0; transition:all 1s .9s;}
.topic.animation h2 .t1 {margin-top:1rem; opacity:1;}
.topic.animation h2 .t2 {margin-top:1.2rem; opacity:1;}
.topic.animation h2 .line {height:3.41rem; opacity:1;}
.section {position:relative;}
.section1 .sch-word {position:absolute; left:37%; top:36.5%; width:13.3%; background-color:transparent;}
.section1 .keyword {position:absolute; left:0; top:54%; width:100%; text-align:center;}
.section1 .keyword  li {display:inline-block; padding:0.7rem 0.5rem 0.5rem; margin:0.32rem; background-color:#f5f5f5; color:#666; text-align:center; font-size:1.02rem; line-height:1; opacity:0;}
.section2 {background-color:#fa4352; padding-bottom:2rem;}
.section2 li {margin-bottom:3.41rem;}
.section3 .conclusion {position:absolute; left:12%; top:71%; width:76%;}
.section4 {background:#84afee;}
.section4 .search-input {position:relative;}
.section4 .cmtWrite {display:table; position:absolute; left:6.7%; top:73.5%; width:86.6%;}
.section4 .cmtWrite span {display:table-cell; width:70%; vertical-align:middle; text-align:center;}
.section4 .cmtWrite span + span {width:30%;}
.section4 .cmtWrite span input {width:80%; border:none; font-size:1.62rem;}
.section4 .cmtWrite .submit {width:100%; font-size:1.28rem; color:#000; font-weight:600; background:transparent;}
.section4 .cmtList {padding:4rem 0 3.5rem; background:#84afee;}
.section4 .cmtList ul {width:90%; margin:0 auto;}
.section4 .cmtList li {position:relative; margin-bottom:1.28rem;}
.section4 .cmtList li div {display:table; position:relative; width:100%; background-color:#d2e4fe; padding:1.2rem 1.49rem 1rem 1.49rem;}
.section4 .cmtList li div span {display:table-cell; vertical-align:middle;}
.section4 .cmtList .num {width:15%; color:#333; font-weight:600; font-size:0.77rem;}
.section4 .cmtList .question {color:#000; font-weight:600; font-size:1.45rem; line-height:1.2;}
.section4 .cmtList .writer {width:22%; color:#2157a6; font-weight:600; font-size:0.77rem; text-align:right;}
.section4 .cmtList li .delete {position:absolute; right:-0.7rem; top:-0.7rem; width:1.66rem; height:1.66rem; background-color:transparent;}
.pagingV15a span {color:#fff;}
.pagingV15a .current {background-color:#fff; color:#ff79b8; border-radius:50%;}
.pagingV15a .arrow a:after {background-position:-7.55rem -9.56rem;}
</style>
<script src="/lib/js/jquery.lazyload.min.js"></script>
<script type="text/javascript">
$(function(){
	var position = $('.thingVol037').offset(); // 위치값
	$('html,body').animate({ scrollTop : position.top },300); // 이동

	$(".topic").addClass("animation");

	$("img.lazy").lazyload();
	$("img.lazy").lazyload({
		effect:"fadeIn",
		load:function(){
			$(".keyword li:nth-child(1)").delay(3300).animate({"opacity":"1"},500);
			$(".keyword li:nth-child(2)").delay(3300).animate({"opacity":"1"},500);
			$(".keyword li:nth-child(3)").delay(3300).animate({"opacity":"1"},500);
			$(".keyword li:nth-child(4)").delay(3300).animate({"opacity":"1"},500);
			$(".keyword li:nth-child(5)").delay(3500).animate({"opacity":"1"},500);
			$(".keyword li:nth-child(6)").delay(3500).animate({"opacity":"1"},500);
			$(".keyword li:nth-child(7)").delay(3500).animate({"opacity":"1"},500);
			$(".keyword li:nth-child(8)").delay(3500).animate({"opacity":"1"},500);
			$(".keyword li:nth-child(9)").delay(3500).animate({"opacity":"1"},500);
			$(".keyword li:nth-child(10)").delay(3700).animate({"opacity":"1"},500);
			$(".keyword li:nth-child(11)").delay(3700).animate({"opacity":"1"},500);
			$(".keyword li:nth-child(12)").delay(3700).animate({"opacity":"1"},500);
			$(".keyword li:nth-child(13)").delay(3700).animate({"opacity":"1"},500);
		}
	});
});

$(function(){
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",200);
	<% end if %>
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#comment").offset().top}, 0);
}

function jsGoComPage(iP){
	location.replace('./view.asp?didx=<%=vDIdx%>&iCC=' + iP);
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% if date() >="2018-03-16" and date() <= "2018-03-25" then %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if(!frm.txtcomm.value){
					alert("여러분의 탐구 주제를 입력해주세요!");
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
					<div class="thingVol037">
						<div class="topic">
							<h2>
								<span class="t1"><img src="http://webimage.10x10.co.kr/playing/thing/vol037/m/tit_clothing1.png" alt="옷에" /></span>
								<span class="line"></span>
								<span class="t2"><img src="http://webimage.10x10.co.kr/playing/thing/vol037/m/tit_clothing2.png" alt="깔려 죽지 않는 방법" /></span>
							</h2>
							<div><img src="http://webimage.10x10.co.kr/playing/thing/vol037/m/bg_head.jpg" alt="" /></div>
							<div><img src="http://webimage.10x10.co.kr/playing/thing/vol037/m/txt_subcopy.png" alt="" /></div>
						</div>
						<div class="section section1">
							<p class="sch-word" style="background-color:transparent;"><img src="http://webimage.10x10.co.kr/playing/thing/vol037/m/blank.gif" data-original="http://webimage.10x10.co.kr/playing/thing/vol037/m/txt_search_v2.gif" alt="옷정리" class="lazy" /></p>
							<ul class="keyword">
								<li>#옷정리노하우</li>
								<li>#옷에깔려죽겠다</li>
								<li>#효율</li>
								<li>#못보던_옷발견</li>
								<li>#옷더미</li>
								<li>#버리기</li>
								<li>#계절_옷보관</li>
								<li>#미니멀</li>
								<li>#대청소</li>
								<li>#마음정리</li>
								<li>#넘쳐나는옷</li>
								<li>#기분전환</li>
								<li>#한숨부터_나오는_옷장</li>
							</ul>
							<div><img src="http://webimage.10x10.co.kr/playing/thing/vol037/m/txt_searching_v2.png" alt="" /></div>
						</div>
						<div class="section section2">
							<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol037/m/tit_story.png" alt="가장 많이 나온 연관 키워드를 바탕으로 프로 옷 정리 위원단이 #옷에 깔려 죽지 않는 방법에 대해 고민했습니다." /></h3>
							<ul>
								<li class="story1"><p><img src="http://webimage.10x10.co.kr/playing/thing/vol037/m/img_story1.jpg" alt="Tip1. 안 입는 옷은 과감히 Out!" /></p></li>
								<li class="story2"><p><img src="http://webimage.10x10.co.kr/playing/thing/vol037/m/img_story2.jpg" alt="Tip2. 옷장엔 옷 길이 별로!" /></p></li>
								<li class="story3"><p><img src="http://webimage.10x10.co.kr/playing/thing/vol037/m/img_story3.jpg" alt="Tip3. 이름 붙여주기" /></p></li>
								<li class="story4"><p><img src="http://webimage.10x10.co.kr/playing/thing/vol037/m/img_story4.jpg" alt="Tip4. 세로로 새롭게!" /></p></li>
								<li class="story5"><p><img src="http://webimage.10x10.co.kr/playing/thing/vol037/m/img_story5.jpg" alt="Tip5. 옷장에게도 여유를" /></p></li>
							</ul>
						</div>
						<div class="section section3">
							<div><img src="http://webimage.10x10.co.kr/playing/thing/vol037/m/txt_conclusion.png" alt="봄맞이 옷 정리, 다들 하셨나요? 아직 안 하셨다면 이 옷정리 tip을 이용해서 정리해보면 어떨까요?" /></div>
							<p class="conclusion">
								<a href="/event/eventmain.asp?eventid=85276" class="mWeb"><img src="http://webimage.10x10.co.kr/playing/thing/vol037/m/btn_item_view.png" alt="옷 정리 도와주는 아이템 보기" /></a>
								<a href="/apps/appCom/wish/web2014//event/eventmain.asp?eventid=85276" onclick="fnAPPpopupEvent('85276'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/playing/thing/vol037/m/btn_item_view.png" alt="옷 정리 도와주는 아이템 보기" /></a>
							</p>
						</div>
						<!-- COMMENT -->
						<div class="section section4">
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
							<div class="search-input">
								<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol037/m/txt_question_v2.png" alt="여러분은 무엇이 궁금하시나요?" /></h3>
								<div class="cmtWrite">
									<span><input type="text" id="txtcomm" name="txtcomm" onClick="jsCheckLimit();" placeholder="10자 이내로 입력" /></span>
									<span><button class="submit" onclick="jsSubmitComment(document.frmcom);return false;">검색 요청</button></span>
								</div>
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
							<% If isArray(arrCList) Then %>
							<div class="cmtList" id="comment">
								<ul>
									<% For intCLoop = 0 To UBound(arrCList,2) %>
									<li>
										<div>
											<span class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
											<span class="question"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></span>
											<span class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%> 님</span>
										</div>
										<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
										<button class="delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol037/m/btn_delete.png" alt="삭제" /></button>
										<% End If %>
									</li>
									<% Next %>
								</ul>
								<div class="paging pagingV15a">
									<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage")%>
								</div>
							</div>
							<% End If %>
						</div>
						<!--// COMMENT -->
					</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->