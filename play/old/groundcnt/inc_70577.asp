<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAY 29-4 M/A
' History : 2016-04-22 이종화 생성
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
Dim eCode , userid , strSql , totcnt , pagereload , totcntall
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66117
Else
	eCode   =  70577
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

	iCPageSize = 6		'한 페이지의 보여지는 열의 수
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
.mPlay20160509 {-webkit-text-size-adjust:none;}
.swiper {position:relative;}
.swiper .swiper-container {width:100%; background:url(http://webimage.10x10.co.kr/playmo/ground/20160509/bg_slide.png) no-repeat 0 0; background-size:100% 100%;}
.swiper-slide {position:relative;}
.swiper button {position:absolute; top:43.6%; z-index:20; width:10%; background:transparent;}
.swiper .btn-prev {left:0;}
.swiper .btn-next {right:0;}
.swiper .pagination {overflow:hidden; position:absolute; bottom:1.7rem; left:0; width:100%; height:auto; z-index:50; padding-top:0; text-align:center;}
.swiper .pagination .swiper-pagination-switch {width:0.5rem; height:0.5rem; background-color:rgba(0,0,0,.5); transition:all .4s;}
.swiper .pagination .swiper-active-switch {width:1.4rem; background-color:#ffdf82; border-radius:12px;}

/* comment */
.festivalWrite .myFestivalIs {position:relative;}
.festivalWrite .myFestivalIs input {display:block; position:absolute; left:22.18%; top:41.5%; width:47.6%; height:3.6rem; font-size:1.4rem; text-align:center; border-radius:0;}
.festivalWrite .btnSubmit {display:block; width:100%; vertical-align:top;}
.festivalList {padding:1.1rem 0 4rem; background:#fff;}
.festivalList ul {overflow:hidden; padding:0 4.68%; }
.festivalList li {float:left; width:50%; padding:1.4rem 3.4% 0;}
.festivalList li div {position:relative; width:100%; height:10.7rem; color:#b4dcfa; background:url(http://webimage.10x10.co.kr/playmo/ground/20160509/bg_fold.png) no-repeat 100% 100%; background-size:auto 100%;}
.festivalList li div .num {padding:1.5rem 1.5rem 1rem; font-size:1rem;}
.festivalList li div .txt {text-align:center; font-size:1.4rem; line-height:1.4; letter-spacing:-0.025em; color:#fff;}
.festivalList li div .txt strong {color:#fef503;}
.festivalList li div .writer {padding:0.9rem 1.5rem 0 0; font-size:1rem; font-weight:bold; text-align:right;}
.festivalList li div .btnDel {display:block; position:absolute; right:0; top:0; width:3.2rem; padding:1rem;}
.festivalList li div .btnDel span {display:block; width:1.2rem;}
.festivalList .paging {margin-top:4rem;}
</style>
<script type="text/javascript">
$(function(){
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",500);
	<% end if %>
});

$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:false,
		autoplay:false,
		speed:800,
		//freeMode: true,
		pagination:".pagination",
		paginationClickable:true,
		nextButton:".btn-next",
		prevButton:".btn-prev",
		effect:"slide"
	});
});


function pagedown(){
	window.$('html,body').animate({scrollTop:$("#festivalList").offset().top}, 0);
}

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
		alert("여러분의 소소한 축제는 어떤 축제인가요?");
		document.frmcom.txtcomm.value="";
		frm.txtcomm.focus();
		return false;
	}

	if (GetByteLength(frm.txtcomm.value) > 11){
		alert("제한길이를 초과하였습니다. 5자 까지 작성 가능합니다.");
		frm.txtcomm.focus();
		return;
	}

	frm.action = "/play/groundcnt/doEventSubscript70577.asp";
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
		if(document.frmcom.txtcomm.value =="5자 이내"){
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

function fnOverNumberCut(){
	var t = $("#txtcomm").val();
	if($("#txtcomm").val().length >= 5){
		$("#txtcomm").val(t.substr(0, 5));
	}
}
</script>
<div class="mPlay20160509">
	<article>
		<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20160509/tit_soso_festival.png" alt="소소한 축제" /></h2>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160509/txt_proposal.png" alt="바쁘게만 살다 지쳐 일상의 소소한 축제들을 모르고 지나쳤을지도 몰라요 일상에 지친 당신에게 매일을 축제처럼 보내는 방법을 제안합니다!" /></p>
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160509/img_slide_01.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160509/img_slide_02.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160509/img_slide_03.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160509/img_slide_04.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160509/img_slide_05.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160509/img_slide_06_v3.png" alt="" /></div>
				</div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/playmo/ground/20160509/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/playmo/ground/20160509/btn_next.png" alt="다음" /></button>
		</div>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160509/txt_always.png" alt="쏘쏘하기만 했던 일상 그 일상 속에서 우리는 소소한 축제들을 만납니다 오늘 하루 쏘쏘했다면 내일은 일상에서 벗어나 소소한 일탈을 해보면 어떨까요? 축제는 일상 속에서 언제나 있습니다" /></p>
		<!-- 코멘트 작성 -->
		<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>"/>
		<input type="hidden" name="bidx" value="<%=bidx%>"/>
		<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
		<input type="hidden" name="iCTot" value=""/>
		<input type="hidden" name="mode" value="add"/>
		<input type="hidden" name="userid" value="<%=GetEncLoginUserID%>"/>
		<input type="hidden" name="eCC" value="1">
		<div class="festivalWrite">
			<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20160509/tit_your_festival_v2.png" alt="여러분이 생각하는 소소한 축제는 어떤 건가요? 코멘트를 남겨주신 분들 중 추첨을 통해 5분께 기프트카드 5만원권을 드립니다." /></h3>
			<div class="myFestivalIs">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160509/my_festival_is.png" alt="나의 소소한 축제는" /></p>
				<input type="text" placeholder="5자 이내" id="txtcomm" name="txtcomm" onkeyup="fnOverNumberCut();" onClick="jsChklogin22('<%=IsUserLoginOK%>');" maxlength="5" />
			</div>
			<button type="button" class="btnSubmit" onclick="jsSubmitComment(document.frmcom);"><img src="http://webimage.10x10.co.kr/playmo/ground/20160509/btn_enroll.png" alt="등록하기" /></button>
		</div>
		</form>
		<form name="frmdelcom" method="post" action="/event/lib/comment_process.asp" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="Cidx" value="">
		<input type="hidden" name="mode" value="del">
		<input type="hidden" name="userid" value="<%=GetEncLoginUserID%>">
		</form>
		<!--// 코멘트 작성 -->

		<!-- 코멘트 목록 (코멘트는 6개씩 노출) -->
		<% IF isArray(arrCList) THEN %>
		<div class="festivalList" id="commentlist">
			<ul>
				<% For intCLoop = 0 To UBound(arrCList,2) %>
				<li>
					<div>
						<p class="num">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
						<p class="txt">나의 소소한 축제는<br /><strong><%=arrCList(1,intCLoop)%></strong>다.</p>
						<p class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%></p>
						<% if ((GetEncLoginUserID = arrCList(2,intCLoop)) or (GetEncLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
						<a href="#" class="btnDel" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;"><span><img src="http://webimage.10x10.co.kr/playmo/ground/20160509/btn_delete.png" alt="삭제하기" /></span></a>
						<% End If %>
					</div>
				</li>
				<% Next %>
			</ul>
			<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
		</div>
		<% End If %>
		<!--// 코멘트 목록 -->
	</article>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->