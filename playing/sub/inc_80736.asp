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
'##################################################################
' Description : Playing Thing Vol.24 장바구니 탐구생활-매니큐어편
' History : 2017-09-21 정태훈 생성
'##################################################################
Dim eCode , userid, vDIdx, commentcount, pagereload
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66433
Else
	eCode   =  80736
End If

vDIdx = request("didx")
userid	= getencLoginUserid()

If userid <> "" then
	commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")
Else
	commentcount = 0
End If 

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
.topic .label {position:absolute; left:0; top:8.7%; width:100%;}
.topic h2 {position:absolute; left:0; top:18.45%; z-index:40;width:100%;}
.topic .what {position:absolute; left:0; top:57.58%; width:100%; margin-top:8px; opacity:0; transition:all .8s 1s;}
.topic .rank {position:absolute; left:0; top:64.05%; width:100%;}
.topic .rank li {position:relative; left:0; opacity:0; padding-bottom:1.5rem;}
.topic.animation .what {margin-top:0; opacity:1;}
.topic.animation .deco {opacity:1;}
.topic.animation .rank li {left:0; opacity:1; transition:all .8s 1.5s;}
.topic.animation .rank li:nth-child(2) {transition-delay:1.7s;}
.topic.animation .rank li:nth-child(3) {transition-delay:1.9s;}
.section {position:relative;}
.section1 .manicure {position:absolute; left:50%; bottom:30%; width:33.125%; margin-left:7.5%; opacity:0;}
.section1 .manicure.show {animation:flash .4s 3 forwards;}
.section3 {background:#fce2db;}
.section3 .cmtWrite {width:90%; margin:0 auto 5.5rem; padding:3.8rem 0 3.5rem; font-size:2.1rem; text-align:center; background:#fff;}
.section3 .cmtWrite .answer {display:block; width:86%; height:6.3rem; margin:1.7rem auto 1.9rem; padding:1rem; color:#252525; font-size:1.1rem; text-align:left; border:0; background:#d9d9d9;}
.section3 .cmtWrite .submit {display:block; width:75%; margin:2.5rem auto 0; background:transparent;}
.section3 .cmtList {padding:4rem 0 3.5rem; background:#efc3b7;}
.section3 .cmtList ul {width:90%; margin:0 auto;}
.section3 .cmtList li {position:relative; margin-bottom:1.9rem; padding:1.6rem 1.2rem 1.3rem; font-size:0.9rem; background:#fff;}
.section3 .cmtList .num {color:#000; font-weight:bold;}
.section3 .cmtList .writer {position:absolute; right:2.2rem; padding-left:.8rem; color:#888; font-weight:bold;}
.section3 .cmtList .txt {padding-top:1rem; font-size:1.6rem; line-height:1.4; letter-spacing:-0.02em; color:#555;}
.section3 .cmtList .txt em {font-weight:bold;}
.section3 .cmtList li .delete {position:absolute; right:0; top:0; width:1.8rem; height:1.8rem; color:#fff; font:400 1.2rem/1 arial; background:#222;}
.pagingV15a span {color:#92695e;}
.pagingV15a .current {color:#000;}
.pagingV15a .arrow a:after {background-position:-5.8rem -9.56rem;}
/*.section3 .pagingV15a {margin-top:2.5rem;}
.section3 .pagingV15a span {width:3.2rem; height:3.2rem; border:0; border-radius:50%;}
.section3 .pagingV15a span a {padding-top:0; color:#000; font-size:1.5rem; line-height:3.2rem; font-weight:normal !important;}
.section3 .pagingV15a span.current {background-color:#fce2db;}
.section3 .pagingV15a span.arrow {position:relative; border:0; background:transparent;}
.section3 .pagingV15a span.arrow:after {content:''; display:inline-block; position:absolute; left:50%; top:50%; width:0.7rem; height:0.7rem; margin:-0.35rem 0 0 -0.35rem; border-top:0.25rem solid #000; border-left:0.25rem solid #000;}
.section3 .pagingV15a span.prevBtn {transform:rotate(-45deg); -webkit-transform:rotate(-45deg);}
.section3 .pagingV15a span.nextBtn {transform:rotate(135deg); -webkit-transform:rotate(135deg);}*/
@keyframes flash {
	0% {opacity:0; margin-bottom:3px;}
	100% {opacity:1; margin-bottom:0; transition-timing-function:ease-out;}
}
</style>
<script type="text/javascript">
$(function(){
	var position = $('.thingVol024').offset(); // 위치값
	$('html,body').animate({ scrollTop : position.top },300); // 이동

	titleAnimation();
	$(".topic h2").css({"margin-top":"10px","opacity":"0"});
	function titleAnimation() {
		$(".topic h2").delay(100).animate({"margin-top":"-5px","opacity":"1"},600).animate({"margin-top":"0"},400);
	}
	$(".topic").addClass("animation");
	$(window.parent).scroll(function(){
		var scrollTop = $(window.parent).scrollTop();
		if (scrollTop > 450) {
			$(".section1 .manicure").addClass("show");
		}
	});
});

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% if date() >="2017-09-21" and date() < "2017-10-10" then %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if(!frm.txtcomm.value){
					alert("내용을 적어주세요!");
					document.frmcom.txtcomm.value="";
					frm.txtcomm.focus();
					return false;
				}

				if (GetByteLength(frm.txtcomm.value) > 60){
					alert("제한길이를 초과하였습니다. 30자 까지 작성 가능합니다.");
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

function maxLengthCheck(object){
	if ("<%=IsUserLoginOK%>"=="False") {
//		if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
			<% If isApp="1" or isApp="2" Then %>
				calllogin();
				return false;
			<% else %>
				jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
				return false;
			<% end if %>	
//		}
//		return false;
	}
	if (object.value.length > object.maxLength)
	  object.value = object.value.slice(0, object.maxLength)
}
</script>
					<!-- THING. html 코딩 영역 : 클래스명은 thing+볼륨 예) thingVol001 / 이미지폴더는 볼륨을 따라 vol001 -->
					<!-- Vol.024 장바구니 탐구생활_매니큐어편 -->
					<div class="thingVol024">
						<div class="topic">
							<p class="label"><img src="http://webimage.10x10.co.kr/playing/thing/vol024/m/txt_label.png" alt="장바구니 탐구생활_향초편" /></p>
							<h2><img src="http://webimage.10x10.co.kr/playing/thing/vol024/m/tit_manicure.png" alt="향초를 사는 사람들의 숨겨진 진실!" /></h2>
							<p class="what"><img src="http://webimage.10x10.co.kr/playing/thing/vol024/m/txt_what.png" alt="향초를 산 사람들의 장바구니에 가장 많이 담겨있던 물건은 뭘까?" /></p>
							<ol class="rank">
								<li><img src="http://webimage.10x10.co.kr/playing/thing/vol024/m/txt_rank_1.png" alt="1위 캔들홀더/디퓨저" /></li>
								<li><img src="http://webimage.10x10.co.kr/playing/thing/vol024/m/txt_rank_2.png" alt="2위 포장지/꽃" /></li>
								<li><img src="http://webimage.10x10.co.kr/playing/thing/vol024/m/txt_rank_3.png" alt="3위 책" /></li>
							</ol>
							<div><img src="http://webimage.10x10.co.kr/playing/thing/vol024/m/bg_topic.jpg" alt="" /></div>
						</div>
						<div class="section section1">
							<p><img src="http://webimage.10x10.co.kr/playing/thing/vol024/m/img_why.png" alt="예상했던 결과지만" /></p>
							<p class="manicure"><img src="http://webimage.10x10.co.kr/playing/thing/vol024/m/txt_why.png" alt="도대체 왜?" /></p>
						</div>
						<div class="section section2">
							<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol024/m/txt_question.png" alt="매니큐어를 바르는 사람들은 어떤 심리였을까?" /></h3>
							<div><img src="http://webimage.10x10.co.kr/playing/thing/vol024/m/txt_talk.png" alt="" /></div>
							<div><img src="http://webimage.10x10.co.kr/playing/thing/vol024/m/img_conclusion.jpg" alt="각각의 색을 바르는 사람들에게 자문을 들어본 결과, 장소와 상황에 따라 바르는 색이 달라진다는 점을 찾을 수 있었습니다." /></div>
							<p class="conclusion">
								<a href="/event/eventmain.asp?eventid=80736" class="mWeb"><img src="http://webimage.10x10.co.kr/playing/thing/vol024/m/txt_conclusion.jpg" alt="매니큐어 추천 아이템 보기" /></a>
								<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=80736" onclick="fnAPPpopupEvent('80736'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/playing/thing/vol024/m/txt_conclusion.jpg" alt="매니큐어 추천 아이템 보기" /></a>
							</p>
						</div>
						<!-- COMMENT -->
						<div class="section section3" id="cmtfrm">
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
							<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol024/m/txt_comment.png" alt="나만의 매니큐어 활용 Tip을 들려주세요! 매니큐어를 잘 바르는 방법이나 다르게 활용하는 방법 등을 함께 공유해요." /></h3>
							<div class="cmtWrite">
								<p><strong>매니큐어,</strong> 이렇게 활용해요!</p>
								<textarea class="answer" placeholder="30자이내로 입력해주세요." id="txtcomm" name="txtcomm"  onclick="maxLengthCheck(this)" maxlength="30"></textarea>
								<button class="submit" onclick="jsSubmitComment(document.frmcom); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol024/m/btn_submit.png" alt="응모하기" /></button>
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
							
							<div class="cmtList">
								<ul>
									<% IF isArray(arrCList) THEN %>
									<% For intCLoop = 0 To UBound(arrCList,2) %>
									<li>
										<p>
											<span class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
											<span class="writer"><%=printUserId(arrCList(2,intCLoop),4,"*")%>님</span>
										</p>
										<p class="txt"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
										<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
										<button class="delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">X</button>
										<% end if %>
									</li>
									<% Next %>
									<% end if %>
								</ul>
								<div class="paging pagingV15a">
									<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage")%>
								</div>
							</div>
						</div>
						
						<!--// COMMENT -->
						<!-- volume -->
						<div class="volume">
							<p><img src="http://webimage.10x10.co.kr/playing/thing/vol024/m/txt_instagram.png" alt="강아지 간식과 삼겹살은 도대체 왜 같이 샀을까? 아무리 머리를 맞대고 고민해도 결론을 찾을 수 없었습니다. 혹시 이유를 아시는 분은 플레잉 인스타그램[@10x10playing]으로 메시지 주세요.(정말 궁금합니다! 추첨을 통해 소정의 선물을 드리겠습니다)" /></p>
						</div>
					</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->