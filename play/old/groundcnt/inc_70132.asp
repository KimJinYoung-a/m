<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAY 29 M/A
' History : 2016-04-07 이종화 생성
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
	eCode   =  66100
Else
	eCode   =  70132
End If

dim com_egCode, bidx , commentcount
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
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}
.swiper {position:relative;}
.swiper .pagination {position:absolute; top:80%; left:5%; width:90%; height:17%; padding-top:0; text-align:center; z-index:50;}
.swiper .pagination span {display:block; float:left; width:20%; height:50%;margin:0; cursor:pointer; vertical-align:top; border-radius:0; border:0;background:transparent;}
.swiper button {position:absolute; top:45%; z-index:150; width:10%; background:transparent;}
.swiper .btnPrev {left:0;}
.swiper .btnNext {right:0;}
.theDayBefore {position:relative;}
.icoDown {position:absolute; right:0; bottom:3.62%; z-index:50; width:8.125%;}
.deco {position:absolute; left:0; top:0; z-index:40; width:48.28%;}
.title {position:absolute; left:7.8125%; top:7.36%; z-index:50; width:46%;}
.title span {position:relative; display:block;}
.title .blank {position:relative; width:100%;}
.title .blank em {display:block; position:absolute; width:0; height:0; background-color:#3a3aa8;}
.title .blank .left {left:0; top:0; width:2px;}
.title .blank .top {left:0; top:0; height:2px;}
.title .blank .right {right:0; top:0; width:2px;}
.title .blank .bottom {right:0; bottom:0; height:2px;}
.swiper .deco {position:absolute; left:0; top:0; z-index:30; width:48%;}
.swiper .story {position:absolute; width:71.25%;}
.swiper .anim {position:absolute;}
.swiper .scene02 .story {right:10.31%; top:41.8%;}
.swiper .scene02 .anim {right:8.6%; bottom:11.2%; width:30%;}
.swiper .scene03 {background-color:#f3f3f3;}
.swiper .scene03 .story {left:8.43%; top:64.6%;}
.swiper .scene04 {background-color:#f3f3f3;}
.swiper .scene04 .story {right:10.31%; top:42.85%;}
.swiper .scene04 .anim {left:0; bottom:12.5%; width:45%;}
.swiper .scene05 {background-color:#f3f3f3;}
.swiper .scene05 .story {right:10.31%; top:43.4%;}
.swiper .scene05 .bg {position:absolute; left:0; bottom:0; width:100%;}
.swiper .word {overflow:hidden; position:absolute; left:7.8125%; top:26%; width:46%;}
.swiper .word p {position:absolute; top:0; left:0; width:50%; height:100%; border:2px solid transparent; background-position:0 0; background-repeat:no-repeat; background-size:200% 100%; text-indent:-999em;}
.swiper .word p.w02 {left:50%; background-position:100% 0;}
.swiper .scene02 .word p {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160411/txt_word_01.png);}
.swiper .scene03 .word p {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160411/txt_word_02.png);}
.swiper .scene04 .word p {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160411/txt_word_03.png);}
.swiper .scene05 .word p {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160411/txt_word_04.png);}
.swiper .scene06 .finish {position:absolute; left:7.8125%; top:7.36%; z-index:50; width:46%;}
.scene01 .purpose {position:absolute; left:0; top:54.6%;}
.numbering {overflow:hidden;position:absolute; left:50%; bottom:3.5%; z-index:50; width:5.32%; margin-left:-2.66%;}
.numbering p {display:none; position:absolute; left:0; top:0; width:100%; vertical-align:top;}
.numbering p.blank {position:static; display:block;}
.commentWrite {padding:0 8% 3.2rem; background:#f9dadf;}
.commentWrite .myToday {padding:1.7rem 15%; font-size:1.7rem; background:#fff;}
.commentWrite .myToday input {width:15rem; height:2.7rem; font-size:1.4rem; text-align:center; border:2px solid #000; color:#000; border-radius:0; vertical-align:top;}
.commentWrite .myToday input::-webkit-input-placeholder {color:#898989;}
.commentWrite .myToday input::-moz-placeholder {color:#898989;}
.commentWrite .myToday input:-ms-input-placeholder {color:#898989;}
.commentWrite .myToday input:-moz-placeholder {color:#898989;}
.commentWrite .myToday strong {position:relative; top:0.5rem;}
.commentWrite .btnSubmit {display:block; width:68.5%; margin:0 auto;}
.commentWrite .selectGift {padding-bottom:0.5rem; text-align:center;}
.commentWrite .selectGift span {display:inline-block; padding:0 0.6rem;}
.commentWrite .selectGift label {display:inline-block; padding:1.5rem 0.6rem 1.5rem 0.4rem; color:#666; font-size:1.2rem; font-weight:bold; vertical-align:middle;}
.commentList {padding-bottom:1rem; background:#fff;}
.commentList ul {overflow:hidden; padding:2rem 0.5rem 1rem;}
.commentList li {float:left; width:50%; padding:0.5rem;}
.commentList li div {position:relative; width:100%; height:11.2rem; padding:1.8rem 1.3rem 0; background:#fcebee;}
.commentList li:nth-child(2) div,
.commentList li:nth-child(3) div,
.commentList li:nth-child(6) div,
.commentList li:nth-child(7) div {background:#e1eafa;}
.commentList li .writer {color:#e75f77; line-height:1.1;}
.commentList li:nth-child(2) .writer,
.commentList li:nth-child(3) .writer,
.commentList li:nth-child(6) .writer,
.commentList li:nth-child(7) .writer {font-size:1rem; color:#3a3aa8;}
.commentList li .writer .mob {display:inline-block; width:0.6rem; height:1rem; font-size:0; line-height:0; color:transparent; background:url(http://webimage.10x10.co.kr/playmo/ground/20160411/ico_mob_01.png) 0 0 no-repeat; background-size:100% 100%; vertical-align:top; margin-right:0.3rem;}
.commentList li:nth-child(2) .writer .mob,
.commentList li:nth-child(3) .writer .mob,
.commentList li:nth-child(6) .writer .mob,
.commentList li:nth-child(7) .writer .mob {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160411/ico_mob_02.png);}
.commentList li .txt {font-size:1.3rem; padding:0.9rem 0 1.1rem;}
.commentList li .txt span {display:block; padding-bottom:0.8rem; letter-spacing:0.15rem;}
.commentList li .num {font-size:0.9rem; text-align:right; padding-top:0.7rem; border-top:1px solid #fff; font-weight:bold; color:#d3919e;}
.commentList li:nth-child(2) .num,
.commentList li:nth-child(3) .num,
.commentList li:nth-child(6) .num,
.commentList li:nth-child(7) .num {color:#7885bf;}
.commentList li .btnDel {display:block; position:absolute; right:0; top:0; width:2.2rem; height:2.2rem; background:url(http://webimage.10x10.co.kr/playmo/ground/20160411/btn_delete.png) 50% 50% no-repeat; background-size:1.2rem 1.2rem; text-indent:-999em;}
.icoDown {-webkit-animation:move 0.3s ease-in-out 0 80 alternate; -moz-animation:move 0.3s ease-in-out 0 80 alternate; -ms-animation:move 0.3s ease-in-out 0 80 alternate; -o-animation:move 0.3s ease-in-out 0 80 alternate; animation:move 0.3s ease-in-out 0 80 alternate;}
@keyframes move {from {transform:translate(0,-6px);} to {transform:translate(0,0);}}
@-webkit-keyframes move { from {-webkit-transform:translate(0,-4px);} to {-webkit-transform:translate(0,0);}}
@-moz-keyframes move {from {-moz-transform:translate(0,-4px);} to{-moz-transform:translate(0,0);}}
@-o-keyframes move {from {-o-transform:translate(0,-4px);} to {-o-transform:translate(0,0);}}
@-ms-keyframes move {from {-ms-transform:translate(0,-4px);} to {-ms-transform:translate(0,0);}}
</style>
<script type="text/javascript">
function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% if Not(IsUserLoginOK) then %>
		<% If isApp="1" or isApp="2" Then %>
		parent.calllogin();
		return false;
		<% else %>
		parent.jsevtlogin();
		return;
		<% end if %>			
	<% end if %>


	if(!frm.txtcomm.value){
		alert("여러분의 오늘은 어떤 일을 하기 전날인가요?");
		document.frmcom.txtcomm.value="";
		frm.txtcomm.focus();
		return false;
	}

	if (GetByteLength(frm.txtcomm.value) > 21){
		alert("제한길이를 초과하였습니다. 10자 까지 작성 가능합니다.");
		frm.txtcomm.focus();
		return;
	}

	frm.action = "/play/groundcnt/doEventSubscript70132.asp";
	frm.submit();
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmdelcom.Cidx.value = cidx;
		document.frmdelcom.submit();
	}
}

function jsChklogin22(blnLogin)
{
	if (blnLogin == "True"){
		if(document.frmcom.txtcomm.value =="100자 이내로 적어주세요."){
			document.frmcom.txtcomm.value="";
		}
		return true;
	} else {
		<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
		<% else %>
		jsevtlogin();
		return;
		<% end if %>			
	}
	return false;
}
</script>
<div class="mPlay20160411">
	<article>
		<div class="theDayBefore">
			<div class="title">
				<span class="t01"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/tit_my.png" alt="" /></span>
				<span class="t02"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/tit_today.png" alt="" /></span>
				<span class="blank">
					<em class="left"></em><em class="top"></em><em class="right"></em><em class="bottom"></em>
					<img src="http://webimage.10x10.co.kr/playmo/ground/20160411/bg_blank.png" alt="" />
				</span>
				<span class="t03"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/tit_before_day.png" alt="" /></span>
			</div>
			<span class="icoDown"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/ico_down.png" alt="" /></span>
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide scene01">
							<div class="purpose">
								<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/tit_time.png" alt="텐바이텐 PLAY 4월 주제는 시간  입니다." /></p>
								<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/txt_purpose.png" alt="여행 전날, 소풍 전날, 첫 출근 전날, 첫 데이트 전날. 무엇이든 하기 전이 더 설렙니다. 텐바이텐 PLAY는 누구나 한 번쯤은 겪었던 설레는 순간들에 대해서 이야기해보고자 합니다. 여러분들은 어떤 설레는 시간을 보내고 있나요? 텐바이텐과 함께 그 시간을 느껴보세요." /></p>
							</div>
							<div class="bg"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/bg_scene_01.png" alt="" /></div>
						</div>
						<div class="swiper-slide scene02">
							<div class="word">
								<p class="w01">아침</p>
								<p class="w02">약속</p>
								<img src="http://webimage.10x10.co.kr/playmo/ground/20160411/bg_blank.png" alt="" />
							</div>
							<div class="anim"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/img_chair.gif" alt="" /></div>
							<p class="story"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/txt_story_01.png" alt="" /></p>
							<div class="bg"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/bg_scene_02.png" alt="" /></div>
							<span class="deco"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/bg_triangle.png" alt="" /></span>
						</div>
						<div class="swiper-slide scene03">
							<div class="word">
								<p class="w01">새해</p>
								<p class="w02">맞이</p>
								<img src="http://webimage.10x10.co.kr/playmo/ground/20160411/bg_blank.png" alt="" />
							</div>
							<p class="story"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/txt_story_02.png" alt="" /></p>
							<div class="bg"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/bg_scene_03.gif" alt="" /></div>
							<span class="deco"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/bg_triangle.png" alt="" /></span>
						</div>
						<div class="swiper-slide scene04">
							<div class="word">
								<p class="w01">서점</p>
								<p class="w02">가기</p>
								<img src="http://webimage.10x10.co.kr/playmo/ground/20160411/bg_blank.png" alt="" />
							</div>
							<div class="anim"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/bg_scene_04.gif" alt="" /></div>
							<p class="story"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/txt_story_03.png" alt="" /></p>
							<span class="deco"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/bg_triangle.png" alt="" /></span>
						</div>
						<div class="swiper-slide scene05">
							<div class="word">
								<p class="w01">여행</p>
								<p class="w02">가기</p>
								<img src="http://webimage.10x10.co.kr/playmo/ground/20160411/bg_blank.png" alt="" />
							</div>
							<p class="story"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/txt_story_04.png" alt="" /></p>
							<div class="bg"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/bg_scene_05.gif" alt="" /></div>
							<span class="deco"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/bg_triangle.png" alt="" /></span>
						</div>
						<div class="swiper-slide scene06">
							<p class="finish"><span><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/txt_finish.png" alt="모든 오늘은 떠나기 전날" /></span></p>
							<div class="bg"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/txt_book_info.jpg" alt="" /></div>
							<span class="deco"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/bg_triangle.png" alt="" /></span>
						</div>
					</div>
				</div>
				<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/btn_prev.png" alt="이전" /></button>
				<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/btn_next.png" alt="다음" /></button>
			</div>
			<div class="numbering">
				<p class="blank"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/bg_num.png" alt="" /></p>
				<p class="n01"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/txt_num_01.png" alt="" /></p>
				<p class="n02"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/txt_num_02.png" alt="" /></p>
				<p class="n03"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/txt_num_03.png" alt="" /></p>
				<p class="n04"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/txt_num_04.png" alt="" /></p>
				<p class="n05"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/txt_num_05.png" alt="" /></p>
				<p class="n06"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/txt_num_06.png" alt="" /></p>
			</div>
		</div>
		<div class="commentEvent">
			<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>"/>
			<input type="hidden" name="bidx" value="<%=bidx%>"/>
			<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
			<input type="hidden" name="iCTot" value=""/>
			<input type="hidden" name="mode" value="add"/>
			<input type="hidden" name="userid" value="<%=GetEncLoginUserID%>"/>
			<input type="hidden" name="eCC" value="1">
			<div class="commentWrite">
				<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/tit_comment.png" alt="무엇이든 하기 전이 가장 설레어요! 여러분의 오늘은 어떤 일을 하기 전날인가요?" /></h3>
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/txt_gift.png" alt="코멘트을 남겨주신 분들 중 추첨을 통해 선물을 드려요!" /></p>
				<div class="myToday">
					<p style="padding-bottom:0.7rem;">나의 오늘은</p>
					<p><input type="text" id="" placeholder="10자 이내" name="txtcomm" onClick="jsChklogin22('<%=IsUserLoginOK%>');" maxlength="10" /> <strong>전날</strong></p>
				</div>
				<div class="selectGift">
					<span><input type="radio" id="gift01" name="spoint" value="1" checked><label for="gift01">도서받기</label></span>
					<span><input type="radio" id="gift02" name="spoint" value="2" ><label for="gift02">초대받기</label></span>
				</div>
				<button type="button" class="btnSubmit"><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/btn_enroll.png" alt="등록하기"  onclick="jsSubmitComment(document.frmcom);"/></button>
			</div>
			</form>
			<form name="frmdelcom" method="post" action="/event/lib/comment_process.asp" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>">
			<input type="hidden" name="bidx" value="<%=bidx%>">
			<input type="hidden" name="Cidx" value="">
			<input type="hidden" name="mode" value="del">
			<input type="hidden" name="userid" value="<%=GetEncLoginUserID%>">
			</form>
			<% IF isArray(arrCList) THEN %>
			<div class="commentList" id="commentlist">
				<ul>
					<% For intCLoop = 0 To UBound(arrCList,2) %>
					<li>
						<div>
							<p class="writer"><% If arrCList(8,intCLoop) = "M"  then%><span class="mob">모바일에서 작성</span><% End If %><%=printUserId(arrCList(2,intCLoop),2,"*")%>님의 설레는</p><% if ((GetEncLoginUserID = arrCList(2,intCLoop)) or (GetEncLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %><span><a href="" class="btnDel" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;">삭제</a></span><% End If %>
							<p class="txt">
								<span><%=arrCList(1,intCLoop)%></span>
								<strong>전날</strong>
							</p>
							<p class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
						</div>
					</li>
					<% Next %>
				</ul>
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
			</div>
			<% End If %>
			<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160411/bg_town.png" alt="" /></div>
		</div>
	</article>
</div>
<script type="text/javascript">
$(function(){
	titleAnimation()
	$(".title .t01").css({"margin-left":"1%", "opacity":"0"});
	$(".title .t02").css({"margin-left":"1%", "opacity":"0"});
	$(".title .t03").css({"margin-left":"1%", "opacity":"0"});
	function titleAnimation() {
		$(".title .t01").delay(300).animate({"margin-left":"0", "opacity":"1"},800);
		$(".title .t02").delay(800).animate({"margin-left":"0", "opacity":"1"},800);
		$(".title .blank .left,.title .blank .right").delay(1400).animate({"height":"100%"},900);
		$(".title .blank .top,.title .blank .bottom").delay(1400).animate({"width":"100%"},900);
		$(".title .t03").delay(2200).animate({"margin-left":"0", "opacity":"1"},800);
	}
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		pagination:false,
		paginationClickable:true,
		speed:800,
		autoplay:false,
		nextButton:'.btnNext',
		prevButton:'.btnPrev',
		autoplayDisableOnInteraction:false,
		onSlideChangeStart: function(swiper){
			$(".swiper-slide").find(".story").delay(100).animate({"margin-top":"2%", "opacity":"0"},300);
			$(".swiper-slide-active").find(".story").delay(400).animate({"margin-top":"0", "opacity":"1"},500);
			$('.numbering p').css('display','none');
			$('.numbering .blank').css('display','block');
			$('.title span').css('display','block');
			$(".scene06 .finish").animate({"margin-left":"2%", "opacity":"0"},200);
			$(".swiper-slide-active.scene06 .finish").animate({"margin-left":"0", "opacity":"1"},900);
			if ($('.swiper-slide-active').is(".scene01")) {$('.numbering .n01').css('display','block');}
			if ($('.swiper-slide-active').is(".scene02")) {$('.numbering .n02').css('display','block');}
			if ($('.swiper-slide-active').is(".scene03")) {$('.numbering .n03').css('display','block');}
			if ($('.swiper-slide-active').is(".scene04")) {$('.numbering .n04').css('display','block');}
			if ($('.swiper-slide-active').is(".scene05")) {$('.numbering .n05').css('display','block');}
			if ($('.swiper-slide-active').is(".scene06")) {$('.numbering .n06').css('display','block');}
			if ($('.swiper-slide-active').is(".scene06")) {
				$('.title span').fadeOut();
			}
		}
	});
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->