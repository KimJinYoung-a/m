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
'#################################################################
' Description : PLAYing 남자들은 왜 그럴까?
' History : 2018-01-12 이종화 생성
'#################################################################
%>
<%

dim oItem
dim currenttime
	currenttime =  now()
'	currenttime = #11/09/2016 09:00:00#

Dim eCode , userid , pagereload , vDIdx
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66277
Else
	eCode   =  83552
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
	iCPageSize = 5		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 5		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
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
.topic h2 {position:absolute; left:0; top:17%; z-index:40; width:100%;}
.topic .desp {position:absolute; left:0; top:34%; width:100%; margin-top:8px; opacity:0; transition:all .8s 0.5s;}
.topic .viewTag {position:absolute; left:0; top:70%; width:100%; margin-top:10px; z-index:20; opacity:0; transition:all .6s 1.2s;}
.topic .rank {position:absolute; left:0; bottom:6.5%; width:100%; margin-top:10px; opacity:0; transition:all .6s 1.5s;}
.topic .rank > div {position:relative; width:100%;}
.topic .rank > div span {display:block; position:absolute; left:0; top:28%; animation:blink 1.7s 50 2s; animation-fill-mode:both;}
.topic.animation .desp {margin-top:0; opacity:1;}
.topic.animation .viewTag {margin-top:0; opacity:1;}
.topic.animation .rank {margin-top:0; opacity:1;}
.section {position:relative;}
.section3 .conclusion {position:absolute; left:13.5%; top:72%; width:73%;}
.section4 {background:#fff9df;}
.section4 .cmtWrite {width:90%; margin:0 auto 5.5rem; padding:3.29rem 0 0; font-size:1.79rem; text-align:center; background:#fff; }
.section4 .cmtWrite p {padding-bottom:1.96rem;}
.section4 .cmtWrite .answer1 {width:33%; height:2.3rem; margin-top:-0.7rem; color:#000; font-size:1.79rem; text-align:center; border:0; background:#fff; letter-spacing:-1px; border-bottom:2px solid #000;}
.section4 .cmtWrite .answer2 {width:70%; height:2.3rem; color:#000; font-size:1.79rem; text-align:center; border:0; background:#fff; letter-spacing:-1px; border-bottom:2px solid #000;}
.section4 .cmtWrite .submit {display:block; width:100%; margin:1.5rem auto 0; background:transparent;}
.section4 .cmtList {padding:4rem 0 3.5rem; background:#ece5c8;}
.section4 .cmtList ul {width:90%; margin:0 auto;}
.section4 .cmtList li {position:relative; margin-bottom:1.9rem; padding:1.71rem 2.5rem 1.3rem; font-size:0.9rem; background:#fff;}
.section4 .cmtList .num {color:#000; font-weight:bold; font-size:0.77rem;}
.section4 .cmtList .writer {position:absolute; right:2.2rem; top:1.7rem; color:#888; font-weight:bold; font-size:0.77rem;}
.section4 .cmtList .date {padding-top:1.02rem; font-size:1.45rem; color:#ff5f2e; font-weight:bold;}
.section4 .cmtList .txt {padding-top:0.95rem; font-size:1.45rem; line-height:1.55; letter-spacing:-0.02em;}
.section4 .cmtList .txt em {font-weight:bold;}
.section4 .cmtList li .delete {position:absolute; right:0; top:0; width:1.8rem; height:1.8rem; color:#fff; font:400 1.2rem/1 arial; background:#222;}
.blink {animation:blink 1.7s 50 3.8s; animation-fill-mode:both;}
@keyframes  blink {
	0%, 100% {opacity:0;}
	10%, 30%, 50%, 70%, 90% {opacity:1;}
	20%, 40%, 60%, 80% {opacity:0;}
}
</style>
<script type="text/javascript">
$(function(){
	var position = $('.thingVol021').offset(); // 위치값
	$('html,body').animate({ scrollTop : position.top },300); // 이동

	titleAnimation();
	$(".topic h2").css({"margin-top":"10px","opacity":"0"});
	function titleAnimation() {
		$(".topic h2").delay(100).animate({"margin-top":"-5px","opacity":"1"},600).animate({"margin-top":"0"},400);
	}
	$(".topic").addClass("animation");
});

$(function(){
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",200);
	<% end if %>
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$(".comment").offset().top}, 0);
}

function jsGoComPage(iP){
	location.replace('/playing/view.asp?didx=<%=vDIdx%>&iCC=' + iP);
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% if date() >="2018-01-15" and date() <= "2018-01-28" then %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if(!frm.txtcommURL.value){
					alert("기간을 입력 해주세요.");
					document.frmcom.txtcomm.value="";
					frm.txtcommURL.focus();
					return false;
				}

				if(!frm.txtcomm.value){
					alert("여러분은 남자친구에게 무엇을 선물하시겠어요?");
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
<div class="thingVol021">
	<div class="topic">
		<h2><img src="http://webimage.10x10.co.kr/playing/thing/vol032/m/tit_gift_v2.png" alt="남자들은 왜 그럴까?" /></h2>
		<p class="desp"><img src="http://webimage.10x10.co.kr/playing/thing/vol032/m/tit_gift_desp.png" alt="선물을 마주하는 남자들의 숨은 속마음" /></p>
		<p class="viewTag"><img src="http://webimage.10x10.co.kr/playing/thing/vol032/m/tag_view.png" alt="" /></p>
		<div class="rank">
			<div>
				<span class="deco"><img src="http://webimage.10x10.co.kr/playing/thing/vol032/m/line_dot.png" alt="무표정 57%" /></span>
				<img src="http://webimage.10x10.co.kr/playing/thing/vol032/m/img_graph.png" alt="미소 10% / 무표정 57% / 기쁨 27% / 화남 6%" />
			</div>
		</div>
		<div><img src="http://webimage.10x10.co.kr/playing/thing/vol032/m/img_topic.jpg" alt="" /></div>
	</div>
	<div class="section section2">
		<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol032/m/tit_what.png" alt="발렌타인데이 한 달 전부터 고심해서 선물을 샀는데 반응이 무심한 그. 뭘까? 도대체 뭘 사줘야, 어떻게 해야 그가 좋아할까?" /></h3>
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol032/m/txt_talk.png" alt="" /></p>
	</div>
	<div class="section section3">
		<div><img src="http://webimage.10x10.co.kr/playing/thing/vol032/m/txt_conclusion.jpg" alt="혹시 그 동안 너무 앞서가거나 너무 마음을 몰랐던 건 아닐까요? - 이번에는 연애기간에 맞게 센스있는 발렌타인 데이 선물을 주자!" /></div>
		<p class="conclusion">
			<a href="/event/eventmain.asp?eventid=83552" class="mWeb"><img src="http://webimage.10x10.co.kr/playing/thing/vol032/m/btn_item.png" alt="기간별 추천 선물 보기" /></a>
			<a href="/apps/appCom/wish/web2014//event/eventmain.asp?eventid=83552" onclick="fnAPPpopupEvent('83552'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/playing/thing/vol032/m/btn_item.png" alt="기간별 추천 선물 보기" /></a>
		</p>
	</div>
	
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
		<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol032/m/txt_comment.png" alt="여러분은 남자친구에게 무엇을 선물하시겠어요?" /></h3>
		<div class="cmtWrite">
			<p>
				저희는 <input type="text" class="answer1" id="txtcommURL" name="txtcommURL" onClick="jsCheckLimit();"placeholder="100일/1년" /> 되었어요.
			</p>
			<p>이번 기념일엔 <strong>남자친구에게</strong></p>
			<p>
				<input type="text" class="answer2" id="txtcomm" name="txtcomm" onClick="jsCheckLimit();" placeholder="10자 이내로 입력해주세요." /> <strong>을(를)</strong>
			</p>
			<p><strong>선물할래요</strong></p>
			<button class="submit" onclick="jsSubmitComment(document.frmcom);return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol032/m/btn_submit.png" alt="응모하기" /></button>
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
		<div class="cmtList">
			<ul>
				<%'!-- for dev msg : 코멘트 6개씩 노출 --%>
				<% For intCLoop = 0 To UBound(arrCList,2) %>
				<li>
					<p>
						<span class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
						<span class="writer"><%=printUserId(arrCList(2,intCLoop),4,"*")%>님</span>
					</p>
					<p class="txt">
						저희는 <span class="date"><%=arrCList(7,intCLoop)%></span> 되었어요.<br />
						이번 기념일엔 남자친구에게<br /><em><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></em>을(를) 선물할래요.
					</p>
					<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
					<button class="delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">X</button>
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

	<div class="volume">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol032/m/txt_thanks.png" alt="앞으로도 더 평등하고 많은 기회를 주도록 노력하겠습니다 여러분 새해 복 많이 받으세요!" /></p>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->