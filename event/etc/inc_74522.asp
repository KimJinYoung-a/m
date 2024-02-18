<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [컬쳐이벤트] 스텐딩 에그 컬쳐 콘서트
' History : 2016-11-30 원승현 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<%
	dim currenttime
		currenttime =  now()
		'currenttime = #10/07/2015 09:00:00#

	dim eCode
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66246
	Else
		eCode   =  74522
	End If

	dim userid, commentcount, i
		userid = GetEncLoginUserID()

	commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

	dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
	dim iCTotCnt, arrCList,intCLoop, pagereload, page, ecc
	dim iCPageSize, iCCurrpage, isMyComm
	dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
		iCCurrpage	= getNumeric(requestCheckVar(Request("iCC"),10))	'현재 페이지 번호
		cdl			= requestCheckVar(Request("cdl"),3)
		blnFull		= requestCheckVar(Request("blnF"),10)
		blnBlogURL	= requestCheckVar(Request("blnB"),10)
		isMyComm	= requestCheckVar(request("isMC"),1)
		pagereload	= requestCheckVar(request("pagereload"),10)

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
		iCPageSize = 5		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
	else
		iCPageSize = 5		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
	end if
	'iCPageSize = 1

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
.mEvt74522 button {background:transparent;}
.eggMail {position:relative;}
.eggMail .viewMsg {position:absolute; left:50%; top:0; width:92%; margin-left:-46%; z-index:40; cursor:pointer; -webkit-animation:bounce 50 1s;}
.eggMail .movie {display:none; position:absolute; left:50%; top:4.5%; width:86%; margin-left:-43%; z-index:30;}
.eggMail .movie div {overflow:hidden; position:relative; height:100%; padding-bottom:57.25%; background:#000;}
.eggMail .movie div iframe {position:absolute; top:0; left:0; bottom:0; width:100%; height:100%; vertical-align:top;}
.bookInfo {background:#767676;}
.bookInfo .btnGroup {padding:0 6.25% 2rem;}
.bookInfo .btnGroup a {display:inline-block; width:100%; border-radius:0.2rem; background:#f9f9f9;}
.bookInfo .btnGroup .goApply {margin-bottom:1rem; background:#f2e47d; -webkit-animation:fadeBg 50 1.2s .8s;}
.preview {padding-bottom:2.4rem;}
.preview .swiper-container {width:87.4%; margin:0 auto;}
.preview button {position:absolute; top:42%; width:11.7%; z-index:30;}
.preview .btnPrev {left:0;}
.preview .btnNext {right:0;}
.preview .pagination {padding-top:0; margin-top:1.2rem; height:0.6rem;}
.preview .pagination span {width:0.6rem; height:0.6rem; margin:0 0.4rem; background:#dfdbdb;}
.preview .pagination span.swiper-active-switch {background:#5b9fc7;}
.voiceWrite .inner {padding:0 6.25% 3.3rem; background:#efebdf url(http://webimage.10x10.co.kr/eventIMG/2016/74522/m/bg_comment.png) 0 0 no-repeat; background-size:100%;}
.voiceWrite ul {padding-bottom:0.3rem; }
.voiceWrite li {position:relative; margin-bottom:1.7rem; padding-left:30%; text-align:left;}
.voiceWrite li span {position:absolute; left:0; top:50%; margin-top:-0.5rem; font-size:1.1rem; font-weight:bold; color:#8f7b5a;}
.voiceWrite li input,
.voiceWrite li textarea {width:100%; height:2.9rem; border:1px solid #e7e3cf; border-radius:0; color:#6d6d6d; vertical-align:top;}
.voiceList {padding:1.6rem 4.68% 2.5rem; background:#fff;}
.voiceList li {position:relative; margin-bottom:2rem; padding-top:2.5rem; color:#a8a8a8; text-align:center; border:1px solid #eee; border-radius:0.5rem; background:#fbfbfb;}
.voiceList li .num {position:absolute; left:1.7rem; top:1rem; text-align:left; font-size:0.9rem; font-weight:bold;}
.voiceList li .song {padding:0 2.2rem; font-size:1.2rem; font-weight:bold; color:#5b5b5b;}
.voiceList li .question {padding:1rem 2.2rem 1.2rem; font-size:1rem; line-height:1.4;}
.voiceList li .writer {padding:1rem 0; font-size:0.9rem; line-height:0.9rem; font-weight:bold; background:#f3f3f3;}
.voiceList li .writer span {color:#4383ce; text-decoration:underline;}
.voiceList li .btnDelete {position:absolute; right:0; top:0; width:8.125%;}
@-webkit-keyframes fadeBg {
	from, to{background:#f9f9f9; animation-timing-function:ease-in;}
	50% {background:#f2e47d; animation-timing-function:ease-out;}
}
@-webkit-keyframes bounce {
	from, to{margin-top:10px; animation-timing-function:ease-in;}
	50% {margin-top:0; animation-timing-function:ease-out;}
}
</style>
<script type="text/javascript">

$(function(){
	bookSwiper = new Swiper('.preview .swiper-container',{
		loop:true,
		autoplay:3000,
		autoplayDisableOnInteraction:false,
		speed:800,
		pagination:".preview .pagination",
		paginationClickable:true,
		nextButton:'.preview .btnNext',
		prevButton:'.preview .btnPrev'
	});
	$(".viewMsg").click(function(){
		$(this).fadeOut(200);
		$(".movie").show();
	});
	$(".goApply").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 800);
	});

	<% if pagereload<>"" then %>
		//pagedown();
		setTimeout("pagedown()",200);
	<% else %>
		setTimeout("pagup()",200);
	<% end if %>
});



function pagup(){
	window.$('html,body').animate({scrollTop:$("#toparticle").offset().top}, 0);
}

function pagedown(){
	window.$('html,body').animate({scrollTop:$(".voiceList").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-11-30" and left(currenttime,10)<"2016-12-12" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>4 then %>
				alert("최대로 응모하셨습니다.\n12월 12일 당첨자 발표를 기대해주세요!");
				return false;
			<% else %>
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 30 || frm.txtcomm1.value == '신청곡을 적어주세요.'){
					alert("신청곡을 적어주세요");
					frm.txtcomm1.focus();
					return false;
				}
				if (frm.txtcomm2.value == '' || GetByteLength(frm.txtcomm2.value) > 800 || frm.txtcomm2.value == '400자 이내로 적어주세요.'){
					alert("띄어쓰기 포함\n최대 한글 400자 이내로 적어주세요.");
					frm.txtcomm2.focus();
					return false;
				}
				frm.txtcommURL.value = frm.txtcomm1.value
				frm.txtcomm.value = frm.txtcomm2.value
				frm.action = "/event/lib/doEventComment.asp";
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmdelcom.Cidx.value = cidx;
   		document.frmdelcom.submit();
	}
}

function jsCheckLimit(textgb) {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	}

	if (textgb =='text1'){
		if (frmcom.txtcomm1.value == '신청곡을 적어주세요.'){
			frmcom.txtcomm1.value = '';
		}
	}else if(textgb =='text2'){
		if (frmcom.txtcomm2.value == '400자 이내로 적어주세요.'){
			frmcom.txtcomm2.value = '';
		}
	}else{
		alert('잠시 후 다시 시도해 주세요');
		return;
	}
}

//내코멘트 보기
function fnMyComment() {
	document.frmcom.isMC.value="<%=chkIIF(isMyComm="Y","N","Y")%>";
	document.frmcom.iCC.value=1;
	document.frmcom.submit();
}

</script>

<%' voice mail %>
<div class="mEvt74522">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/74522/m/tit_voice_mail.jpg" alt="Voice Mail" /></h2>
	<div class="eggMail">
		<div class="viewMsg"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74522/m/img_msg.png" alt="메세지 확인하기" /></div>
		<div class="movie">
			<div><iframe src="https://player.vimeo.com/video/193643633" frameborder="0" allowfullscreen></iframe></div>
		</div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/74522/m/bg_mail.jpg" alt="" /></div>
	</div>
	<div class="bookInfo">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74522/m/txt_book_info.jpg" alt="따뜻한 위로의 음악, 뮤지션 스탠딩에그의 VOICE [보이스]는 스탠딩에그에서 노래를 만들고 부르는 에그 2호의 일상과 음악, 여행과 관계에 대한 공감의 이야기를 담은 책이다. 직접 찍은 사진들과 글로 에그 2호의 감성을 느껴보자" /></p>
		<div class="btnGroup">
			<a href="#voiceWrite" class="goApply"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74522/m/btn_go_apply.png" alt="초대권 신청하기" /></a>
			<a href="eventmain.asp?eventid=74342" class="goBuy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74522/m/btn_go_buy_v2.png" alt="도서 구매하기" /></a>
		</div>
	</div>
	<div class="preview">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/74522/m/tit_preview.png" alt="도서 [VOICE] 미리보기" /></h3>
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74522/m/img_preview_01.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74522/m/img_preview_02.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74522/m/img_preview_03.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74522/m/img_preview_04.jpg" alt="" /></div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74522/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74522/m/btn_next.png" alt="다음" /></button>
		</div>
	</div>

	<%' 코멘트 작성 %>
	<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
	<input type="hidden" name="mode" value="add">
	<input type="hidden" name="pagereload" value="ON">
	<input type="hidden" name="iCC" value="1">
	<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
	<input type="hidden" name="eventid" value="<%= eCode %>">
	<input type="hidden" name="linkevt" value="<%= eCode %>">
	<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
	<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
	<input type="hidden" name="txtcomm">
	<input type="hidden" name="txtcommURL">
	<input type="hidden" name="gubunval">
	<input type="hidden" name="isApp" value="<%= isApp %>">	
	<div id="voiceWrite" class="voiceWrite">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/74522/m/tit_comment_v2.png" alt="COMMENT EVENT - 스탠딩에그 에그 2호의 보이스로 듣고 싶은 신청곡과, 건네고 싶은 질문을 코멘트로 남겨주세요" /></h3>
		<div class="inner">
			<ul>
				<li>
					<span>신청곡</span>
					<input type="text" name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit('text1');" onKeyUp="jsCheckLimit('text1');"  value="<%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>신청곡을 적어주세요.<%END IF%>"/>
				</li>
				<li>
					<span>건네고 싶은 질문</span>
					<textarea style="height:6rem;" cols="30" rows="5" name="txtcomm2" id="txtcomm2" onClick="jsCheckLimit('text2');" onKeyUp="jsCheckLimit('text2');"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>400자 이내로 적어주세요.<%END IF%></textarea>
				</li>
			</ul>
			<button type="submit" class="btnSubmit" onclick="jsSubmitComment(document.frmcom); return false;" ><img src="http://webimage.10x10.co.kr/eventIMG/2016/74522/m/btn_apply.png" alt="초대권 신청하기" /><button>
		</div>
	</div>
	<%'// 코멘트 작성 %>
	</form>
	<form name="frmdelcom" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="pagereload" value="ON">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
	<input type="hidden" name="eventid" value="<%= eCode %>">
	<input type="hidden" name="linkevt" value="<%= eCode %>">
	<input type="hidden" name="isApp" value="<%= isApp %>">
	</form>

	<%' 코멘트 목록 %>
	<% IF isArray(arrCList) THEN %>
		<div class="voiceList">
			<ul>
				<% For intCLoop = 0 To UBound(arrCList,2) %>
					<li>
						<span class="num">NO.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%></span>
						<p class="song"><%=ReplaceBracket(db2html(arrCList(7,intCLoop)))%></p>
						<p class="question"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
						<p class="writer"><span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span></p>
						<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
							<button type="button" class="btnDelete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74522/m/btn_delete.png" alt="삭제" /></button>
						<% End If %>
					</li>
				<% Next %>
			</ul>
			<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
		</div>
	<% End If %>
	<%'// 코멘트 목록 %>
</div>
<div id="mask"></div>
<%'// voice mail %>

<!-- #include virtual="/lib/db/dbclose.asp" -->