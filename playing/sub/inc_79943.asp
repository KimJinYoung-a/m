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
' Description : Playing Thing Vol.21 튜브 향초
' History : 2017-08-17 유태욱 생성
'####################################################
Dim eCode , userid, vDIdx, commentcount, pagereload
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66412
Else
	eCode   =  79943
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

iCPerCnt = 4		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 4		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 4		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
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
.topic .label {position:absolute; left:25%; top:6.4%; width:50%;}
.topic h2 {position:absolute; left:7%; top:12.82%; z-index:40;width:86%;}
.topic .what {position:absolute; left:23%; top:32%; width:54%; margin-top:8px; opacity:0; transition:all .8s 1s;}
.topic .deco {position:absolute; left:16.8%; top:15%; z-index:20; width:34.68%; height:5.12%; opacity:0; background:url(http://webimage.10x10.co.kr/playing/thing/vol021/m/bg_brush.png) 0 0 no-repeat; background-size:100% 100%; transition:all .6s .5s;}
.topic .rank {position:absolute; left:25%; bottom:6.2%; width:50%;}
.topic .rank li {position:relative; left:10px; opacity:0;}
.topic.animation .what {margin-top:0; opacity:1;}
.topic.animation .deco {opacity:1;}
.topic .rank.show li {left:0; opacity:1; transition:all .8s;}
.topic .rank.show li:nth-child(2) {transition-delay:.2s;}
.topic .rank.show li:nth-child(3) {transition-delay:.4s;}
.section {position:relative;}
.section2 .manicure {position:absolute; left:50%; bottom:21%; width:44%; margin-left:-22%; opacity:0;}
.section2 .manicure.show {animation:flash .4s 3 forwards;}
.section4 {background:#ffc6cd;}
.section4 .cmtWrite {width:90%; margin:0 auto 5.5rem; padding:3.8rem 0 3.5rem; font-size:2.1rem; text-align:center; background:#fff;}
.section4 .cmtWrite .answer {display:block; width:86%; height:6.3rem; margin:1.7rem auto 1.9rem; color:#000; font-size:2rem; text-align:center; border:0; background:#d9d9d9;}
.section4 .cmtWrite .submit {display:block; width:75%; margin:2.5rem auto 0; background:transparent;}
.section4 .cmtList {padding:4rem 0 3.5rem; background:#f8f3ec;}
.section4 .cmtList ul {width:90%; margin:0 auto;}
.section4 .cmtList li {position:relative; margin-bottom:1.9rem; padding:1.6rem 1.2rem 1.3rem; font-size:0.9rem; background:#fff;}
.section4 .cmtList .num {color:#123d89; font-weight:bold;}
.section4 .cmtList .writer {padding-left:.8rem; color:#ff929f; font-weight:bold;}
.section4 .cmtList .txt {padding-top:1rem; font-size:1.6rem; line-height:1.4; letter-spacing:-0.02em;}
.section4 .cmtList .txt em {font-weight:bold;}
.section4 .cmtList li .delete {position:absolute; right:0; top:0; width:1.8rem; height:1.8rem; color:#fff; font:400 1.2rem/1 arial; background:#222;}
.pagingV15a span {color:#ea8b97;}
.pagingV15a .current {color:#063787;}
.pagingV15a .arrow a:after {background-position:-5.8rem -9.56rem;}
/*.section4 .pagingV15a {margin-top:2.5rem;}
.section4 .pagingV15a span {width:3.2rem; height:3.2rem; border:0; border-radius:50%;}
.section4 .pagingV15a span a {padding-top:0; color:#000; font-size:1.5rem; line-height:3.2rem; font-weight:normal !important;}
.section4 .pagingV15a span.current {background-color:#ffc6cd;}
.section4 .pagingV15a span.arrow {position:relative; border:0; background:transparent;}
.section4 .pagingV15a span.arrow:after {content:''; display:inline-block; position:absolute; left:50%; top:50%; width:0.7rem; height:0.7rem; margin:-0.35rem 0 0 -0.35rem; border-top:0.25rem solid #000; border-left:0.25rem solid #000;}
.section4 .pagingV15a span.prevBtn {transform:rotate(-45deg); -webkit-transform:rotate(-45deg);}
.section4 .pagingV15a span.nextBtn {transform:rotate(135deg); -webkit-transform:rotate(135deg);}*/
@keyframes flash {
	0% {opacity:0; margin-bottom:3px;}
	100% {opacity:1; margin-bottom:0; transition-timing-function:ease-out;}
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
	$(window.parent).scroll(function(){
		var scrollTop = $(window.parent).scrollTop();
		if (scrollTop > 400) {
			$(".topic .rank").addClass("show");
		}
		if (scrollTop > 1400) {
			$(".section2 .manicure").addClass("show");
		}
	});

	<% if pagereload<>"" then %>
		//pagedown();
		setTimeout("pagedown()",500);
	<% end if %>
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#commentList").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% if date() >="2017-08-17" and date() < "2017-08-29" then %>
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
	<div class="thingVol021">
		<div class="topic">
			<p class="label"><img src="http://webimage.10x10.co.kr/playing/thing/vol021/m/txt_label.png" alt="장바구니 탐구생활_향초편" /></p>
			<h2><img src="http://webimage.10x10.co.kr/playing/thing/vol021/m/tit_candle.png" alt="향초를 사는 사람들의 숨겨진 진실!" /></h2>
			<span class="deco"></span>
			<p class="what"><img src="http://webimage.10x10.co.kr/playing/thing/vol021/m/txt_what.png" alt="향초를 산 사람들의 장바구니에 가장 많이 담겨있던 물건은 뭘까?" /></p>
			<ol class="rank">
				<li><img src="http://webimage.10x10.co.kr/playing/thing/vol021/m/txt_rank_1.png" alt="1위 캔들홀더/디퓨저" /></li>
				<li><img src="http://webimage.10x10.co.kr/playing/thing/vol021/m/txt_rank_2.png" alt="2위 포장지/꽃" /></li>
				<li><img src="http://webimage.10x10.co.kr/playing/thing/vol021/m/txt_rank_3.png" alt="3위 책" /></li>
			</ol>
			<div><img src="http://webimage.10x10.co.kr/playing/thing/vol021/m/bg_topic.jpg" alt="" /></div>
		</div>
		<div class="section section1">
			<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol021/m/txt_why.png" alt="예상했던 결과들과 달리, 이 물건들은 도대체 왜?" /></h3>
			<div><img src="http://webimage.10x10.co.kr/playing/thing/vol021/m/img_why.png" alt="매니큐어, 악세사리, 풍선, 고기, 반려동물 간식" /></div>
		</div>
		<div class="section section2">
			<p><img src="http://webimage.10x10.co.kr/playing/thing/vol021/m/txt_cart.png" alt="고기? 매니큐어? 반려동물 간식? 향초와 함께 담은 예상외의 장바구니 물건들! 가장 많이 담은 의외의 물건" /></p>
			<p class="manicure"><img src="http://webimage.10x10.co.kr/playing/thing/vol021/m/txt_manicure.png" alt="매니큐어" /></p>
		</div>
		<div class="section section3">
			<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol021/m/txt_question.png" alt="예상했던 결과들과 달리, 이 물건들은 도대체 왜?" /></h3>
			<div><img src="http://webimage.10x10.co.kr/playing/thing/vol021/m/txt_talk.png" alt="" /></div>
			<p class="conclusion">
				<a href="/event/eventmain.asp?eventid=79943" class="mWeb"><img src="http://webimage.10x10.co.kr/playing/thing/vol021/m/txt_conclusion.png" alt="매니큐어&amp;향초 추천 아이템 보기" /></a>
				<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=79943" onclick="fnAPPpopupEvent('79943'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/playing/thing/vol021/m/txt_conclusion.png" alt="매니큐어&amp;향초 추천 아이템 보기" /></a>
			</p>
		</div>
		<!-- COMMENT -->
		<div class="section section4">
			<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol021/m/txt_comment.jpg" alt="향초는 매니큐어와 함께, 그렇다면 매니큐어는 무엇과 함께 주문하시나요? " /></h3>
			<div class="cmtWrite">
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
				<p>나는 <strong>매니큐어 살 때,</strong></p>
				<input type="text" class="answer" placeholder="10자이내로 입력해주세요." id="txtcomm" name="txtcomm"  onclick="maxLengthCheck(this)" maxlength="10" />
				<p><strong>과(와) 함께 사요!</strong></p>
				<button class="submit" onclick="jsSubmitComment(document.frmcom); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol021/m/btn_submit.png" alt="응모하기" /></button>
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
				<div class="cmtList" id="commentList">
					<ul>
						<% For intCLoop = 0 To UBound(arrCList,2) %>
							<li>
								<p>
									<span class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
									<span class="writer"><%=printUserId(arrCList(2,intCLoop),4,"*")%>님</span>
								</p>
								<p class="txt">나는 매니큐어 살 때,<br /><em><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></em>과(와) 함께 사요</p>
								<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
									<button class="delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">X</button>
								<% end if %>
							</li>
						<% Next %>
					</ul>
					<div class="paging pagingV15a">
						<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
					</div>
				</div>
			<% end if %>
		</div>
		<!--// COMMENT -->
		<!-- volume -->
		<div class="volume">
			<p><img src="http://webimage.10x10.co.kr/playing/thing/vol021/m/txt_instagram.png" alt="강아지 간식과 삼겹살은 도대체 왜 같이 샀을까? 아무리 머리를 맞대고 고민해도 결론을 찾을 수 없었습니다. 혹시 이유를 아시는 분은 플레잉 인스타그램[@10x10playing]으로 메시지 주세요.(정말 궁금합니다! 추첨을 통해 소정의 선물을 드리겠습니다)" /></p>
		</div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->