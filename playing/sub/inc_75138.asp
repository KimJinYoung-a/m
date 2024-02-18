<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAYing Vol.4 M/A
' History : 2016-12-16 원승현 생성
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
	eCode   =  66253
Else
	eCode   =  75138
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

	iCPageSize = 4		'한 페이지의 보여지는 열의 수
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
.boxingDay .topic {position:relative; background-color:#fdcb61;}
.boxingDay .topic .title {position:absolute; top:29.29%; left:50%; width:26.875%; margin-left:-13.4375%; padding:0;}
.boxingDay .topic .title:after {background:none;}
.boxingDay .topic .title span {position:absolute; width:47.09%;}
.boxingDay .topic .title .letter1 {top:0; left:0;}
.boxingDay .topic .title .letter2 {top:0; right:0;}
.boxingDay .topic .title .letter3 {bottom:0; left:0;}
.boxingDay .topic .title .letter4 {right:0; bottom:0;}

.boxingDay .kit,
.boxingDay .howto {background-color:#d7ebf1;}

.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper .pagination {position:absolute; bottom:4.85%; left:0; z-index:5; width:100%; height:auto; z-index:50; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; width:1.5rem; height:0.5rem; margin:0 0.3rem; border-radius:1.5rem; border:0.15rem solid #fff; background-color:transparent; cursor:pointer; transition:all 0.7s ease; box-shadow:0 0.1rem 0.5rem rgba(0, 0, 0, 0.2);}
.rolling .swiper .pagination .swiper-active-switch {background-color:#fff;}

.boxingDay .form,
.boxingDay .comment {background-color:#5faecb;}

.boxingDay .form {background-color:#5faecb;}
.boxingDay .form legend {overflow:hidden; visibility:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}
.boxingDay .form .inner {position:relative; width:25.8rem; margin:2% auto 0; padding-top:2.5rem;}
.boxingDay .form ul {position:relative; z-index:5; height:14.9rem; padding:2.8rem 3.4rem 0; background:url(http://webimage.10x10.co.kr/playing/thing/vol004/m/bg_note.png) 50% 50% no-repeat; background-size:100% auto;}
.boxingDay .form ul li {position:relative; margin-top:1rem; padding-left:2.5rem;}
.boxingDay .form ul li:first-child {margin-top:0;}
.boxingDay .form ul li span {position:absolute; top:0; left:0; width:2.5rem; height:2.5rem; color:#131313; font-size:1.2rem; font-style:italic; font-weight:bold; line-height:2.6rem;}
.boxingDay .form input[type=text] {width:100%; height:2.5rem; padding:0; border:0; border-radius:0; background-color:#fff; color:#111; font-size:1.2rem; line-height:2.5rem; text-align:left;}
.boxingDay .form input::-webkit-input-placeholder {color:#aad1e1;}
.boxingDay .form input::-moz-placeholder {color:#aad1e1;} /* firefox 19+ */
.boxingDay .form input:-ms-input-placeholder {color:#aad1e1;} /* ie */
.boxingDay .form input:-moz-placeholder {color:#aad1e1;}
.boxingDay .form .pen {position:absolute; right:0; z-index:10; bottom:2.5rem; width:3.85rem;}
.boxingDay .form .forbid {position:absolute; top:0; right:-1.9rem; width:6.85rem;}
.boxingDay .btnSubmit {width:17.7rem; margin:0.5rem auto 0;}
.boxingDay .btnSubmit input {width:100%; height:auto;}

.boxingDay .comment {padding-bottom:4.8rem;}
.boxingDay .comment .commentList {overflow:hidden; width:28.8rem; margin:0 auto;}
.boxingDay .comment .commentList .article {float:left; position:relative; width:13.6rem; height:19.7rem; margin:0 0.4rem; padding:9.9rem 1.5rem 0; background:url(http://webimage.10x10.co.kr/playing/thing/vol004/m/bg_comment_01.png) 50% 100% no-repeat ; background-size:100% auto;}
.boxingDay .comment .commentList .article:nth-child(2) {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol004/m/bg_comment_02.png);}
.boxingDay .comment .commentList .article:nth-child(3),
.boxingDay .comment .commentList .article:nth-child(4) {margin-top:1.5rem; padding-top:4.5rem; height:14.45rem;}
.boxingDay .comment .commentList .article:nth-child(3) {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol004/m/bg_comment_03.png);}
.boxingDay .comment .commentList .article:nth-child(4) {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol004/m/bg_comment_04.png);}
.boxingDay .comment .commentList .article .info {position:relative; color:#000; font-size:1rem;}
.boxingDay .comment .commentList .article .info .no {position:absolute; top:0; right:0;}
.boxingDay .comment .commentList .article ul {margin-top:1.2rem;}
.boxingDay .comment .commentList .article ul li {overflow:hidden; height:1.3rem; margin-top:0.5rem; padding-top:0.05rem; color:#919191; font-size:1.1rem; text-overflow:ellipsis; white-space:nowrap;}
.boxingDay .comment .commentList .article .id {display:block; overflow:hidden; width:50%; height:1.1rem; text-overflow:ellipsis; white-space:nowrap;}
.boxingDay .comment .commentList .article .no img {width:0.6rem;}
.boxingDay .comment .commentList .article .btndel {position:absolute; bottom:0.3rem; right:0.4rem; width:1.3rem; background-color:transparent;}

.pagingV15a span {color:#216a85;}
.pagingV15a .current {color:#000;}
.pagingV15a .arrow a:after {background-position:-5.8rem -9.56rem;}
/*.pagingV15a {margin-top:2.1rem;}
.pagingV15a span {width:3.05rem; height:2.35rem; margin:0; border:0; border-radius:0.4rem;}
.pagingV15a span a {color:#fff;  font-size:1.2rem; font-weight:bold; line-height:0.75rem;}
.pagingV15a span.current {border:2px solid #000; background-color:#eb3939;}
.pagingV15a span.current a {color:#fff;}
.pagingV15a span.arrow {border:0; background:url(http://webimage.10x10.co.kr/playing/thing/vol004/m/btn_pagination_prev.png) 50% 50% no-repeat; background-size:100% auto;}
.pagingV15a span.nextBtn {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol004/m/btn_pagination_next.png);}*/

/* css3 animation */
.move {animation:move 2s; -webkit-animation:move 2s;}

@keyframes move {
	0% {right:50%;}
	100% {margin-right:0;}
}
@-webkit-keyframes move {
	0% {right:50%;}
	100% {margin-right:0;}
}
</style>
<script type="text/javascript">
$(function(){
	/* swiper js */
	mySwiper = new Swiper('#rolling .swiper-container',{
		loop:true,
		autoplay:2000,
		speed:800,
		pagination:"#rolling .pagination",
		paginationClickable:true,
		effect:"fade"
	});

	/* ttle animation */
	titleAnimation();
	$("#animation .title span").css({"opacity":"0"});
	$("#animation .title .letter1").css({"top":"-40%", "left":"-30%"});
	$("#animation .title .letter2").css({"top":"-40%", "right":"-30%"});
	$("#animation .title .letter3").css({"bottom":"-40%", "left":"-30%"});
	$("#animation .title .letter4").css({"bottom":"-40%", "right":"-30%"});
	function titleAnimation() {
		$("#animation .title .letter1").delay(100).animate({"top":"0", "left":"0", "opacity":"1"},700);
		$("#animation .title .letter2").delay(100).animate({"top":"0", "right":"0", "opacity":"1"},700);
		$("#animation .title .letter3").delay(100).animate({"bottom":"0", "left":"0", "opacity":"1"},700);
		$("#animation .title .letter4").delay(100).animate({"bottom":"0", "right":"0", "opacity":"1"},700);
	}

	/* pen animation */
	$("#form .pen").css({"opacity":"0"});
	function penAnimation() {
		var window_top = $(window).scrollTop();
		var div_top = $("#form").offset().top;
		if (window_top > div_top){
			$("#form .pen").addClass("move");
			$("#form .pen").css({"opacity":"1"});
		} else {
			$("#form .pen").removeClass("move");
			$("#form .pen").css({"opacity":"0"});
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
	window.$('html,body').animate({scrollTop:$(".commentList").offset().top}, 0);
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

	<% if commentcount>4 then %>
		alert("이벤트는 5회까지 참여 가능 합니다.");
		return false;
	<% else %>
		if(!frm.txtcomm1.value){
			alert("상자에 3가지 모두 담아주세요!");
			document.frmcom.txtcomm1.value="";
			frm.txtcomm1.focus();
			return false;
		}

		if (GetByteLength(frm.txtcomm1.value) > 18){
			alert("제한길이를 초과하였습니다. 9자 까지 작성 가능합니다.");
			frm.txtcomm1.focus();
			return;
		}

		if(!frm.txtcomm2.value){
			alert("상자에 3가지 모두 담아주세요!");
			document.frmcom.txtcomm2.value="";
			frm.txtcomm2.focus();
			return false;
		}

		if (GetByteLength(frm.txtcomm2.value) > 18){
			alert("제한길이를 초과하였습니다. 9자 까지 작성 가능합니다.");
			frm.txtcomm2.focus();
			return;
		}

		if(!frm.txtcomm3.value){
			alert("상자에 3가지 모두 담아주세요!");
			document.frmcom.txtcomm3.value="";
			frm.txtcomm3.focus();
			return false;
		}

		if (GetByteLength(frm.txtcomm3.value) > 18){
			alert("제한길이를 초과하였습니다. 9자 까지 작성 가능합니다.");
			frm.txtcomm3.focus();
			return;
		}

		document.frmcom.txtcomm.value = document.frmcom.txtcomm1.value+"||"+document.frmcom.txtcomm2.value+"||"+document.frmcom.txtcomm3.value;

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


<div class="thingVol004 boxingDay">
	<div id="animation" class="section topic">
		<p class="title">
			<img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/tit_white_v1.png" alt="" />
			<span class="letter letter1"><img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/tit_boxing_day_01_v1.png" alt="박" /></span>
			<span class="letter letter2"><img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/tit_boxing_day_02_v1.png" alt="싱" /></span>
			<span class="letter letter3"><img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/tit_boxing_day_03_v1.png" alt="데" /></span>
			<span class="letter letter4"><img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/tit_boxing_day_04_v1.png" alt="이" /></span>
		</p>
		<div class="box"><img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/img_box_animmation_v1.gif" alt="" /></div>
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/txt_boxsing_day_v1.png" alt="크리스마스 다음 날은 Boxing Day! 텐바이텐 플레잉의 박싱 데이는 상자에 지난 추억들을 담고 내년을 준비하는, 한 해를 정리하는 날입니다. 텐텐 Boxing Day에 여러분의 추억을 정리해주세요!" /></p>
	</div>

	<div id="rolling" class="section rolling">
		<div class="swiper">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<p class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/img_slide_01_v1.jpg" alt="2016년 마지막 달 12월, 남은 한 달이 아쉽나요?" /></p>
					<p class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/img_slide_02_v1.jpg" alt="2016년 동안 무얼 해왔는지 정리해보셨나요?" /></p>
					<p class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/img_slide_03_v1.jpg" alt="소중하게 생각하던 것들을 어디에 뒀는지 기억나지 않은 적 있다면," /></p>
					<p class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/img_slide_04_v1.jpg" alt="당신의 기억들을 잘 정리해  상자에 담아주세요!" /></p>
				</div>
			</div>
			<div class="pagination"></div>
		</div>
	</div>

	<div class="section kit">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/txt_kit_v1.jpg" alt="박싱데이 키트는 박스 3개, 스티커 10개, 체크리스크 엽서 3개, 테이프, 비닐팩으로 구성되어 있습니다." /></p>
	</div>

	<div class="section howto">
		<p>
			<img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/txt_how_to_01_v2.jpg" alt="How to boxing Step 1 2016년의 정리해야 될 것들을 담아주세요! Step 2 정리된 추억들이 새지 않도록 테이프로 단단히 봉해주세요. Step 3 담은 물건이 무엇인지 구분할 수 있도록 스티커를 붙입니다. Step 4 정리 후 남은 버릴 것들을 봉투에 꽁꽁 묶어 버려주세요!" />
			<img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/txt_how_to_02_v2.gif" alt="정리 상자 완성!" />
		</p>
	</div>

	<div class="section cheer">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/txt_cheer_v1.jpg" alt="깔끔하게 정리한 당신의 2016년 행복한 2017년의 시작 텐바이텐 Boxing Day는 여러분의 마지막과 새로운 시작을 응원합니다!" /></p>
	</div>

	<%' form %>
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
		<input type="hidden" name="txtcomm">
		<input type="hidden" name="gubunval">
		<input type="hidden" name="isApp" value="<%= isApp %>">	
			<fieldset>
			<legend>상자에 담고 싶은 물건 적고 응모하기</legend>
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/txt_comment_v3.gif" alt="텐바이텐 박싱데이에  정리상자를 만나보세요! 여러분은 2016년 상자에 무엇을 담아 정리하고 싶나요? 상자에 담고 싶은 물건을 적고 응모해주세요! 당첨된 50분께는 Boxing Day Kit를 드립니다. 이벤트기간은 12월 19일부터 1월 1일이며, 당첨자발표는 1월 2일 월요일입니다." /></p>
				<div class="inner">
					<ul>
						<li>
							<span>1)</span><input type="text" id="txtcomm1" name="txtcomm1" onClick="jsChklogin22('<%=IsUserLoginOK%>');"  title="상자에 담고 싶은 첫번째 물건 입력" placeholder="9자 이내로 입력해 주세요." maxlength="9"/>
						</li>
						<li>
							<span>2)</span><input type="text" id="txtcomm2" name="txtcomm2" onClick="jsChklogin22('<%=IsUserLoginOK%>');" title="상자에 담고 싶은 두번째 물건 입력" placeholder="9자 이내로 입력해 주세요." maxlength="9"/>
						</li>
						<li>
							<span>3)</span><input type="text" id="txtcomm3" name="txtcomm3" onClick="jsChklogin22('<%=IsUserLoginOK%>');" title="상자에 담고 싶은 세번째 물건 입력" placeholder="9자 이내로 입력해 주세요." maxlength="9"/>
						</li>
					</ul>
					<span class="pen"><img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/img_pen.png" alt="" /></span>
					<span class="forbid"><img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/txt_forbid.png" alt="" /></span>
				</div>
				<div class="btnSubmit"><input type="image" src="http://webimage.10x10.co.kr/playing/thing/vol004/m/btn_submit_v1.gif" alt="상자에 담기" onclick="jsSubmitComment(document.frmcom);return false;" /></div>
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

	<%' comment list %>
	<% IF isArray(arrCList) THEN %>
	<div class="section comment">
		<div class="commentList" id="commentList">
			<%' for dev msg : 한 페이지당 4개씩 보여주세요 %>
			<% For intCLoop = 0 To UBound(arrCList,2) %>
			<div class="article">
				<div class="info"><span class="id"><%=printUserId(arrCList(2,intCLoop),2,"*")%></span> <span class="no">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %> <% If arrCList(8,intCLoop) <> "W" Then %> <img src="http://webimage.10x10.co.kr/playmo/ground/20160215/ico_mobile.png" alt="모바일에서 작성된 글" /><% End If %></span></div>
				<ul>
					<% if isarray(split(arrCList(1,intCLoop),"||")) then %>
						<% if ubound(split(arrCList(1,intCLoop),"||")) > 0 then %>
							<li>1) <%=ReplaceBracket(db2html( split(arrCList(1,intCLoop),"||")(0) ))%></li>
							<li>2) <%=ReplaceBracket(db2html( split(arrCList(1,intCLoop),"||")(1) ))%></li>
							<li>3) <%=ReplaceBracket(db2html( split(arrCList(1,intCLoop),"||")(2) ))%></li>
						<% end if %>
					<% end if %>						
				</ul>
				<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
					<button type="button" class="btndel" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/btn_del.png" alt="내 코멘트 삭제하기" /></button>
				<% End If %>
			</div>
			<% Next %>
		</div>
		<%' pagination %>
		<div class="paging pagingV15a">
			<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
		</div>
	</div>
	<% End If %>
	<%' volume %>
	<div class="section volume">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol004/m/txt_vol004_v1.png" alt="Volume 4 Thing의 사물에 대한 생각 박싱데이" /></p>
	</div>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->