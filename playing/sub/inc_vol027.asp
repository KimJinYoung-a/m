<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#################################################################
' Description : 진심을 꺼내세요.
' History : 2017.11.10 정태훈
'#################################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, vUserID, myevt, vDIdx, myselect
dim arrList, sqlStr

IF application("Svr_Info") = "Dev" THEN
	eCode = "67457"
Else
	eCode = "81508"
End If

vDIdx = request("didx")
vUserID = getEncLoginUserID
myselect = 0

'참여했는지 체크
myevt = getevent_subscriptexistscount(eCode, vUserID,"","","")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL, pagereload
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
	iCPageSize = 3		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 3		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
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
	
	arrCList = cEComment.fnGetSubScriptComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
set cEComment = nothing

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
%>
<style type="text/css">
.tit {padding:4.5rem 16.87% 4.5rem 19.21%; background-color:#00759b; text-align:center;}
.tit h2 span {display:inline-block; opacity:0; animation:slideY 2.5s .3s cubic-bezier(0.1, 1, 0.2, 1) forwards;}
.tit .t2{margin:0.45rem 0 2.2rem; animation-delay:.5s;}
.subcopy {opacity:0;animation:slideY 2.5s .7s cubic-bezier(0.1, 1, 0.2, 1) forwards;}
@keyframes slideY {
	0% {transform:translateY(8%); opacity:0;}
	100% {transform:translateY(0); opacity:1;}
}

.slideTemplateV15 .slideNav {top:50%; width:2.4rem; height:3.8rem; margin-top:-1.9rem;}
.slideTemplateV15 .btnPrev {background:url(http://webimage.10x10.co.kr/playing/thing/vol027/m/btn_prev.png); background-size:100%;}
.slideTemplateV15 .btnNext {background:url(http://webimage.10x10.co.kr/playing/thing/vol027/m/btn_next.png); background-size:100%;}
.slideTemplateV15 .pagination {bottom:1.5rem;}
.slideTemplateV15 .pagination span {width:1rem; height:1rem; margin:0 0.4rem; border:0.25rem solid #fff;}
.slideTemplateV15 .pagination span.swiper-active-switch {width:2.5rem;}

.word1 {background-color:#fbded0;}
.word2 {background-color:#ffe575;}
.word3 {background-color:#ff926f;}

.cmt-evt {position:relative; background-color:#f97754;}
.cmt-evt .bg {position:absolute; top:29.2rem; right:1rem; z-index:1; width:90.62%; height:88rem; background-color:#e06b4b;}
.cmt-evt .inner {position:relative; z-index:10; margin:0 4.68%; padding:4rem 1.7rem 1.5rem; background-color:#fff;}
.cmt-evt p {color:#3b3b3b; font-size:1.3rem; font-weight:600; font-family:helveticaNeue, helvetica, sans-serif; text-align:center; letter-spacing:-.2px;}
.cmt-evt .ques2{line-height:1.9rem;}
.cmt-evt .sub {margin-top:1.1rem; font-size:1rem; line-height:1.5rem; color:#9c9c9c; letter-spacing:-.4px;}

.select-word {margin:2.2rem 0 4.5rem}
.select-word li {position:relative; margin:0 13.6% 2rem; padding:3rem 2.8rem 3.3rem 3rem; text-align:center; cursor:pointer;}
.select-word li span {display:none;}
.select-word li.on span {display:inline-block; position:absolute; top:0; left:0; width:100%; height:100%; background:rgba(0, 0, 0, 0.55) url(http://webimage.10x10.co.kr/playing/thing/vol027/m/icon_on.png) no-repeat 50% 50%; background-size:4.15rem auto;}

.reason-box .textarea {margin-top:0.35rem;}
.reason-box {margin-top:2.1rem; padding:2.3rem 2.3rem;}
.reason-box p {position:relative; padding-bottom:.68rem; font-size:1.6rem; line-height:1.8rem;}
.reason-box p:after {display:inline-block; content:' '; position:absolute; bottom:0; left:50%; width:10rem; height:.26rem; margin-left:-5.2rem; text-align:center;}
.reason-box span {display:inline-block; margin-right:0.8rem;}
.reason-box input {width:6rem; padding:0; margin-top:-.2rem; height:1.8rem; border:none; background-color:transparent; font-size:1.6rem; line-height:1.8rem;}
.reason-box textarea {width:100%; height:9.1rem; margin-top:1.5rem; padding:0; border:none; background-color:transparent;}
.reason-box .phone {margin-top:1.3rem;}
.reason-box .phone:after {width:17.2rem; margin-left:-8.8rem;}
.reason-box .phone input {width:11.5rem; letter-spacing:-.3px;}
.reason-box.word1 p {color:#218aad;}
.reason-box.word1 p:after {background-color:#218aad;}
.reason-box.word1 input, .reason-box.word1 input::-webkit-input-placeholder, .reason-box.word1 textarea, .reason-box.word1 textarea::-webkit-input-placeholder {color:#a08d84;}
.reason-box.word2 p {color:#079083;}
.reason-box.word2 p:after {background-color:#079083;}
.reason-box.word2 input, .reason-box.word2 input::-webkit-input-placeholder, .reason-box.word2 textarea, .reason-box.word2 textarea::-webkit-input-placeholder {color:#a39148;}
.reason-box.word3 p {color:#203252;}
.reason-box.word3 p:after {background-color:#203252;}
.reason-box.word3 input, .reason-box.word3 input::-webkit-input-placeholder, .reason-box.word3 textarea, .reason-box.word3 textarea::-webkit-input-placeholder {color:#a35b44;}

.cmt-list {margin-top:2.5rem; padding:0 4.68% 2.9rem;}
.cmt-list li {position:relative; margin-bottom:1.5rem; padding:1.6rem 1.7rem; text-align:left;}
.cmt-list li.word3 {background-color:#ffab6d;}
.cmt-list li p {width:12rem; margin:1.8rem 0 1.6rem;}
.cmt-list .word3 p {width:11.45rem;}
.cmt-list .writer {position:relative; font-size:1.2rem; color:#3b3b3b; font-weight:bold;}
.cmt-list .writer.mob {padding-left:1.4rem;}
.cmt-list .writer.mob:before {display:inline-block; content:' '; position:absolute; top:0; left:0; z-index:10; width:1rem; height:1.2rem; background:url(http://webimage.10x10.co.kr/playing/thing/vol027/m/icon_mob.png) no-repeat 50% 50%; background-size:100%;}
.cmt-list .writer .no {position:absolute; top:0; right:0;}
.cmt-list .conts {overflow:hidden; height:8rem; color:#333; font-size:1.2rem; line-height:2rem; font-weight:600;}
.cmt-list .btn-del {position:absolute; top:-.5rem; right:-.5rem; background-color:transparent;}

.pagingV15a span {color:#a33113;}
.pagingV15a .current {color:#fff;}
.pagingV15a .arrow a:after {background-position:-7.55rem -9.56rem;}
</style>
<script type="text/javascript">
$(function(){
	var position = $('.thingVol027').offset(); // 위치값
	//$('html,body').animate({ scrollTop : position.top }, 100); // 이동

	slideTemplate = new Swiper('.slideTemplateV15 .swiper-container',{
		loop:true,
		autoplay:3000,
		autoplayDisableOnInteraction:false,
		speed:800,
		pagination:".slideTemplateV15 .pagination",
		paginationClickable:true,
		nextButton:'.slideTemplateV15 .btnNext',
		prevButton:'.slideTemplateV15 .btnPrev'
	});

	$('.select-word li').click(function(){
		$('.select-word li').removeClass("on");
		$(this).addClass("on");
		$('.reason-box').removeClass("word1");
		$('.reason-box').removeClass("word2");
		$('.reason-box').removeClass("word3");
		if ( $(this).hasClass("word1")) {
			$('.reason-box').addClass("word1");
		}
		if ($(this).hasClass("word2")) {
			 $('.reason-box').addClass("word2");
		}
		if ($(this).hasClass("word3")) {
			 $('.reason-box').addClass("word3");
		}
	});
});

function jsGoComPage(iP){
	<% If isApp="1" or isApp="2" Then %>
	location.replace('/apps/appcom/wish/web2014/playing/view.asp?didx=<%=vDIdx%>&iCC=' + iP + '#card_list');
	<% else %>
	location.replace('/playing/view.asp?didx=<%=vDIdx%>&iCC=' + iP + '#card_list');
	<% end if %>
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% if date() >="2017-11-10" and date() < "2017-11-28" then %>
			<% if myevt>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if(frm.username.value==""){
					alert("모든 내용을 입력해야 응모가 완료됩니다");
					frm.username.focus();
					return false;
				}
				if(frm.hp.value==""){
					alert("모든 내용을 입력해야 응모가 완료됩니다.");
					frm.hp.focus();
					return false;
				}
				if(frm.txtcomm.value==""){
					alert("내용을 적어주세요!");
					document.frmcom.txtcomm.value="";
					frm.txtcomm.focus();
					return false;
				}

				if (GetByteLength(frm.txtcomm.value) > 200){
					alert("제한길이를 초과하였습니다. 100자 까지 작성 가능합니다.");
					frm.txtcomm.focus();
					return false;
				}

				frm.action = "/playing/sub/doEventSubscriptvol027.asp";
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
		document.frmdelcom.Cidx.value = cidx;
   		document.frmdelcom.submit();
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

function fnSelectWord(word){
	document.frmcom.word.value=word;
}

</script>
					<div class="thingVol027">
						<div class="tit">
							<h2>
								<span class="t1"><img src="http://webimage.10x10.co.kr/playing/thing/vol027/m/tit_1.png" alt="진심을 " /></span>
								<span class="t2"><img src="http://webimage.10x10.co.kr/playing/thing/vol027/m/tit_2.png" alt=" 꺼내세요 " /></span>
							</h2>
							<p class="subcopy"><img src="http://webimage.10x10.co.kr/playing/thing/vol027/m/txt_subcopy.png" alt="빈말대신, 진말 건네기 캠페인 " /></p>
						</div>
						<div class="webtoon"><img src="http://webimage.10x10.co.kr/playing/thing/vol027/m/txt_webtoon.jpg" alt="" /></div>
						<div class="intro"><img src="http://webimage.10x10.co.kr/playing/thing/vol027/m/txt_intro.jpg" alt="빈말대신, 진말 건네기 캠페인 “언제 한번 밥먹자”, “언제 얼굴 한번 보자” 인사치레로 뱉던 말들, 누군가는 그 말을 곧이 곧 대로 믿어 버리곤 하죠. 이제는 그 말에 기대조차 하지 않는 우리. 이번 연말엔 인사치레가 아닌 진심을 건네보는 건 어떨까요?" /></div>
						<div class="campaign">
							<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol027/m/txt_lets_campaign.png" alt="진심을 꺼내세요 명함카드로 캠페인에 동참하세요! " /></h3>
							<div class="slideTemplateV15">
								<div class="swiper-container">
									<div class="swiper-wrapper">
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol027/m/img_slide_1.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol027/m/img_slide_2.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol027/m/img_slide_3.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol027/m/img_slide_4.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol027/m/img_slide_5.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol027/m/img_slide_6.jpg" alt="" /></div>
									</div>
								</div>
								<div class="pagination"></div>
								<button type="button" class="slideNav btnPrev">이전</button>
								<button type="button" class="slideNav btnNext">다음</button>
							</div>
							<div class="cmt-evt">
								<h4><img src="http://webimage.10x10.co.kr/playing/thing/vol027/m/tit_cmt_evt.png" alt="진심명함받기 이벤트 가장 많이 하는 빈말과 함께 진심 명함 카드가 필요한 이유를 적어주세요! 추첨을 통해 50명에게 진심 명함 카드(96장)를 만들어 드립니다.  이벤트 기간  2017.11.13 - 11.27" /></h4>
								<div class="inner">
									<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
									<input type="hidden" name="eventid" value="<%=eCode%>">
									<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
									<input type="hidden" name="iCTot" value="">
									<input type="hidden" name="word" value="1">
									<input type="hidden" name="mode" value="add">
									<fieldset>
										<div class="field">
											<p class="ques1">1. 가장 많이 하는 빈말을 선택해주세요.</p>
											<ul id="select-word" class="select-word">
												<li class="word1 on" onClick="fnSelectWord(1);"><img src="http://webimage.10x10.co.kr/playing/thing/vol027/m/txt_word1_v3.png" alt="누구야 밥 한번 먹자!" /><span></span></li>
												<li class="word2" onClick="fnSelectWord(2);"><img src="http://webimage.10x10.co.kr/playing/thing/vol027/m/txt_word2_v3.png" alt="누구야 술 한잔 하자!" /><span></span></li>
												<li class="word3" onClick="fnSelectWord(3);"><img src="http://webimage.10x10.co.kr/playing/thing/vol027/m/txt_word3_v3.png" alt="누구야 커피 마시자!" /><span></span></li>
											</ul>
											<div class="textarea">
												<p class="ques2">2. 본인의 이름과 번호, 명함이 필요한 이유를 적어주세요. </p>
												<p class="sub">※ 이름과 번호는 응모 후 사이트에 노출 되지 않으며,<br/ >이벤트를 위한 정보 입력일 뿐 이벤트 용도 외에 이용되지 않습니다.</p>
												<div class="reason-box word1">
													<p class="name"><span>이름</span><input type="text" placeholder="김누구" name="username" onclick="maxLengthCheck(this); return false" maxlength="16"  /></p>
													<p class="phone"><span>전화번호</span><input type="tel" placeholder="010-0000-0000" name="hp" onclick="maxLengthCheck(this); return false" maxlength="16" /></p>
													<textarea cols="30" rows="10" title="이름과 번호, 명함이 필요한 이유 작성" placeholder="100자 이내로 입력해주세요." name="txtcomm" onclick="maxLengthCheck(this); return false" maxlength="100"></textarea>
												</div>
											</div>
											<button class="btn-submit tMar20" onclick="jsSubmitComment(document.frmcom);return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol027/btn_submit.png" alt="응모하기" /></button>
										</div>
									</fieldset>
									</form>
									<form name="frmdelcom" method="post" action = "/playing/sub/doEventSubscriptvol027.asp" style="margin:0px;">
										<input type="hidden" name="eventid" value="<%=eCode%>">
										<input type="hidden" name="mode" value="del">
										<input type="hidden" name="Cidx" value="">
										<input type="hidden" name="pagereload" value="ON">
									</form>
								</div>
								<div class="bg"></div>
								<div class="position" id="card_list"></div>
								<% If isArray(arrCList) Then %>
								<div class="cmt-list">
									<ul>
										<% For intCLoop = 0 To UBound(arrCList,2) %>
										<li class="word<%=arrCList(3,intCLoop)%>">
											<div class="writer<% If arrCList(6,intCLoop)<>"W" Then Response.write " mob" %>">
												<span class="id"><%=printUserId(arrCList(1,intCLoop),4,"*")%></span>
												<span class="no">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
											</div>
											<p><img src="http://webimage.10x10.co.kr/playing/thing/vol027/m/txt_cmt_<%=arrCList(3,intCLoop)%>.png" /></p>
											<div class="conts"><%=ReplaceBracket(db2html(arrCList(4,intCLoop)))%></div>
											<% if ((GetLoginUserID = arrCList(1,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(1,intCLoop)<>"") then %>
											<button type="button" class="btn-del" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol027/btn_delet.png" alt="내 글 삭제하기" /></button>
											<% End If %>
										</li>
										<% Next %>
									</ul>
									<!-- pagination -->
									<div class="pagingV15a">
										<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage")%>
									</div>
								</div>
								<% End If %>
							</div>
						</div>
						<div class="how-to"><img src="http://webimage.10x10.co.kr/playing/thing/vol027/m/txt_how_to.jpg" alt="진심 명함 카드 이용방법 1. 반가운 지인들에게 명함에 날짜를 적어 건넵니다. (직접 만든 명함 카드도 괜찮아요!) 2. 약속한 날짜에 지인과 즐거운 시간을 보냅니다. 3. 여러분의 즐거운 시간을 인증해주세요!" /></div>
					</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->