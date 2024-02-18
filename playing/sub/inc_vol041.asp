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
	eCode   =  68519
Else
	eCode   =  86803
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
.topic h2 {display:block; position:absolute; left:0; z-index:20; top:16%; width:100%; opacity:0; transition:all 1s .3s;}
.topic.animation h2 {margin-top:1rem; opacity:1;}
.section {position:relative;}
.section1 .hash-link {position:relative; overflow:hidden;}
.section1 .hash-link a {overflow:hidden; display:block; position:absolute; left:8%; top:63%; width:42%; height:14.5%; text-indent:-999em;}
.section1 .hash-link a + a {left:50%; top:63%;}
.section1 .hash-link a + a + a {left:8%; top:77.5%;}
.section1 .hash-link a + a + a + a {left:50%; top:77.5%;}
.section1 ul li {position:relative;}
.section1 ul li a {display:block; position:absolute; left:13%; top:85%; width:74%; height:5%; text-indent:-999em;}
.section1 ul li:nth-child(4) a {top:72%;}
.section1 .go-shopping {position:relative;}
.section1 .go-shopping a {display:block; position:absolute; left:13%; top:52%; width:74%; height:26%; text-indent:-999em;}
.section2 {background-color:#39cd74;}
.section2 .search-input {width:100%; padding:0 8%;}
.section2 .search-input p {background-color:#fff;}
.section2 .search-input textarea {width:100%; height:7rem; border:none; padding:1rem; font-size:1.11rem; color:#000;}
.section2 .search-input button {width:100%; height:4.2rem; background-color:#ff80aa; color:#fff; font-size:1.28rem; font-weight:bold; border:none;}
.section2 .cmtList {padding:4rem 0 3.5rem;}
.section2 .cmtList ul {width:84%; margin:0 auto;}
.section2 .cmtList li {position:relative; margin-bottom:1.28rem;}
.section2 .cmtList li .inner {position:relative; width:100%; padding:1.71rem; background-color:#299856; color:#fff;}
.section2 .cmtList li .inner p {overflow:hidden; padding:0.21rem 0; border-bottom:1px solid #39cd74;}
.section2 .cmtList li .inner span.writer {float:left; font-size:0.9rem; text-align:left;}
.section2 .cmtList li .inner span.num {float:right; font-size:0.9rem; text-align:right;}
.section2 .cmtList li .inner .question {min-height:5rem; margin-top:0.64rem; font-size:1.02rem; line-height:1.3; text-align:left;}
.section2 .cmtList li .delete {position:absolute; right:-0.7rem; top:-0.7rem; width:1.66rem; height:1.66rem; background-color:transparent;}
.pagingV15a span {color:#fff;}
.pagingV15a .current {background-color:#fff; color:#1d5119; border-radius:50%;}
.pagingV15a .arrow a:after {background-position:-7.55rem -9.56rem;}
</style>
<script src="/lib/js/jquery.lazyload.min.js"></script>
<script type="text/javascript">
$(function(){
	var position = $('.thingvol041').offset(); // 위치값
	$('html,body').animate({ scrollTop : position.top },300); // 이동

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
	location.replace('/playing/view.asp?didx=<%=vDIdx%>&iCC=' + iP);
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% if date() >="2018-05-25" and date() <= "2018-06-05" then %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if(!frm.txtcomm.value){
					alert("여행 꿀템을 입력해주세요.");
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
					<div class="thingvol041">
						<div class="topic">
							<h2><img src="http://webimage.10x10.co.kr/playing/thing/vol041/m/tit_travel.png" alt="떠나고 나니 깨닫게 되는것. feat. 여행꿀템" /></h2>
							<div><img src="http://webimage.10x10.co.kr/playing/thing/vol041/m/bg_topic.jpg" alt="" /></div>
						</div>
						<div class="section section1">
							<div class="hash-link">
								<a href="#cont1">천천히 즐길래 - #뚜벅이 여행 으로 이동</a>
								<a href="#cont2">먹고, 놀고, 자고 - #휴양 여행 으로 이동</a>
								<a href="#cont3">질러보자! - #해외여행 으로 이동</a>
								<a href="#cont4">멀리는 못가도 - #당일여행 으로 이동</a>
								<img src="http://webimage.10x10.co.kr/playing/thing/vol041/m/txt_question.png" alt="여러분은 어떤 여행을 계획하고 있나요?" />
							</div>
							<ul>
								<li id="cont1">
									<a href="/event/eventmain.asp?eventid=86803#group247872" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=86803#group247872');return false;">뚜벅이 여행 소품 보러 가기</a>
									<img src="http://webimage.10x10.co.kr/playing/thing/vol041/m/txt_content1.png" alt="천천히 즐길래 - #뚜벅이 여행" /></li>
								<li id="cont2">
									<a href="/event/eventmain.asp?eventid=86803#group247873" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=86803#group247873');return false;">휴양 여행 소품 보러 가기</a>
									<img src="http://webimage.10x10.co.kr/playing/thing/vol041/m/txt_content2.png" alt="먹고, 놀고, 자고 - #휴양 여행" />
								</li>
								<li id="cont3">
									<a href="/event/eventmain.asp?eventid=86803#group247874" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=86803#group247874');return false;">해외여행 소품 보러 가기</a>
									<img src="http://webimage.10x10.co.kr/playing/thing/vol041/m/txt_content3.png" alt="질러보자! - #해외여행" />
								</li>
								<li id="cont4">
									<a href="/event/eventmain.asp?eventid=86803#group247875" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=86803#group247875');return false;">당일여행 소품 보러 가기</a>
									<img src="http://webimage.10x10.co.kr/playing/thing/vol041/m/txt_content4.png" alt="멀리는 못가도 - #당일여행" />
								</li>
							</ul>
							<p class="go-shopping">
								<a href="/event/eventmain.asp?eventid=86803" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=86803');return false;">여행별 소품 보러 가기</a>
								<img src="http://webimage.10x10.co.kr/playing/thing/vol041/m/btn_go_shopping.png" alt="이번 계획하고 있는 여행, 완벽하게 준비하고 떠나세요!" />
							</p>
						</div>
						<!-- COMMENT -->
						<div class="section section2">
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
							<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol041/m/txt_cmt.png" alt="여러분은 무엇이 궁금하시나요?" /></h3>
							<div class="search-input">
								<p><textarea id="txtcomm" name="txtcomm" onClick="jsCheckLimit();" placeholder="80자 이내로 입력"></textarea></p>
								<p><button type="button" onclick="jsSubmitComment(document.frmcom);return false;">추천하기</button></p>
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
							
							<div class="cmtList" id="comment">
								<% If isArray(arrCList) Then %>
								<ul>
									<% For intCLoop = 0 To UBound(arrCList,2) %>
									<li>
										<div class="inner">
											<p>
												<span class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%> 님</span>
												<span class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
											</p>
											<div class="question"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></div>
										</div>
										<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
										<button type="button" class="delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol041/m/btn_delete.png" alt="삭제" /></button>
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
<!-- #include virtual="/lib/db/dbclose.asp" -->