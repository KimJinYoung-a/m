<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAY 28 M/A
' History : 2016-03-02 이종화 생성
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
	eCode   =  66033
Else
	eCode   =  69489
End If

dim com_egCode, bidx , commentcount , vreload
	vreload	= requestCheckVar(Request("reload"),2)
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

	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	Dim vTitle, vLink, vPre, vImg

	dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
	snpTitle = Server.URLEncode("[텐바이텐] Play#28 SHOWER #1")
	snpLink = Server.URLEncode("http://m.10x10.co.kr/play/playGround.asp?idx=1384&contentsidx=110") 'http://bit.ly/10x10play_3
	snpPre = Server.URLEncode("이석원 토크 콘서트 <민낯 토크>")

	'기본 태그
	snpTag = Server.URLEncode("텐바이텐")
	snpTag2 = Server.URLEncode("#10x10")

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[텐바이텐 x 달출판사] 10x10 PLAY Ground#28 SHOWER\n\n도서 <보통의 존재> 작가 이석원과 함께하는\n특별한 토크 콘서트에 여러분을 초대합니다."
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/playmo/ground/20160307/img_kakao.jpg"
	Dim kakaoimg_width : kakaoimg_width = "200"
	Dim kakaoimg_height : kakaoimg_height = "200"
	Dim kakaolink_url
		If isapp = "1" Then '앱일경우
			kakaolink_url = "http://m.10x10.co.kr/play/playGround.asp?idx=1384&contentsidx=110"
		Else '앱이 아닐경우
			kakaolink_url = "http://m.10x10.co.kr/play/playGround.asp?idx=1384&contentsidx=110"
		end If
		
	commentcount = getcommentexistscount(GetEncLoginUserID, eCode, "", "", "", "Y")

%>
<meta property="og:title" content="<%=snpTitle%>"/>
<meta property="og:description" content="<%=snpTitle%>"/>
<meta property="og:type" content="website"/>
<meta property="og:url" content="<%=snpLink%>"/>
<meta property="og:image" content="<%=kakaoimage%>"/>
<link rel="image_src" href="<%=kakaoimage%>"/>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.topic {position:relative; }
.topic .off {position:absolute; top:0; left:0; width:100%;}
.topic .off {animation-name:twinkle; animation-iteration-count:3; animation-duration:3s; animation-fill-mode:both;}
.topic .off {-webkit-animation-name:twinkle; -webkit-animation-iteration-count:3; -webkit-animation-duration:3s; -webkit-animation-fill-mode:both;}
@keyframes twinkle {
	0% {opacity:0;}
	50% {opacity:1;}
	100% {opacity:0;}
}
@-webkit-keyframes twinkle {
	0% {opacity:0;}
	50% {opacity:1;}
	100% {opacity:0;}
}
.topic h2 {position:absolute; top:22%; left:0; width:100%;}
@keyframes fadeInSlideUp {
	0% {transform:translateY(0);}
	50% {transform:translateY(30px);}
	100% {transform:translateY(0);}
}
@-webkit-keyframes fadeInSlideUp {
	0% {-webkit-transform:translateY(0);}
	50% {-webkit-transform:translateY(30px);}
	100% {-webkit-transform:translateY(0);}
}
.fadeInSlideUp {animation:fadeInSlideUp 1.5s cubic-bezier(0.2, 0.3, 0.25, 0.9) forwards; animation-delay:0.5s; animation-iteration-count:2;}
.fadeInSlideUp {-webkit-animation:fadeInSlideUp 1.5s cubic-bezier(0.2, 0.3, 0.25, 0.9) forwards; -webkit-animation-delay:0.5s; -webkit-animation-iteration-count:2;}
.topic p {position:absolute; top:65%; left:0; width:100%;}

.about {position:relative;}
.about ul {overflow:hidden; position:absolute; bottom:10%; right:9%; width:56%;}
.about ul li {float:left; width:25%;}
.about ul li a {overflow:hidden; display:block; position:relative; height:0; margin:0 3%; padding-bottom:110.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.about ul li a span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}

/* comment */
.commentevt {padding-bottom:12%;background-color:#333;}
.form legend {visibility:hidden; width:0; height:0;}
.form .inner {padding:0 4.6875%;}
.form .field {position:relative; padding-right:7.8rem;}
.form .field textarea {width:100%; height:7.8rem; border:0; border-radius:0; background-color:#232323; color:#fff; font-size:1.2rem;}
.form .field input {position:absolute; top:0; right:0; width:8rem; height:7.8rem; background-color:#ffc427; color:#181818; font-size:1.3rem;}

.commentlist {margin-top:5.8rem;}
.commentlist .total {position:relative; padding-right:4.6875%; color:#ffc427;}
.commentlist .total span {position:relative; z-index:5; padding-left:4.6875%; padding-right:2rem; background-color:#333333;}
.commentlist .total:after {content:' '; position:absolute; right:4.6875%; bottom:0; width:100%; height:1px; background-color:#191919;}

.commentlist ul {padding:3rem 6.25% 0;}
.commentlist ul li {position:relative; margin-top:1.7rem; padding:2rem 1.8rem; background-color:#fff; box-shadow: 2px 3px 13px -1px rgba(0,0,0,0.75);}
.commentlist ul li:first-child {margin-top:0;}
.commentlist ul li:after {content:' '; position:absolute; top:-0.3rem; left:-0.3rem; width:2.7rem; height:2.7rem; background:url(http://webimage.10x10.co.kr/playmo/ground/20160307/bg_commnet_box_v1.png) no-repeat 0 0; background-size:100% 100%;}
.commentlist ul li .id, .commentlist ul li .no {display:block; color:#010101; font-size:1.1rem;}
.commentlist ul li .id {padding-bottom:0.5rem; border-bottom:1px solid #ddd;}
.commentlist ul li .id img {width:0.6rem;}
.commentlist ul li .no {position:absolute; top:2rem; right:1.8rem;}
.commentlist ul li .msg {margin-top:1.3rem; color:#505050; font-size:1.2rem; line-height:1.5em;}
.commentlist .btndel {position:absolute; top:0.5rem; right:0.5rem; width:1.3rem; background-color:transparent;}

.paging {margin-top:3rem;}
.paging span {width:2.9rem; height:2.9rem; border:1px solid #f2bb28; border-radius:50%;}
.paging span a {color:#ffc427; font-size:1.1rem; line-height:1em; font-weight:normal;}
.paging span.current {background-color:#ffc427;}
.paging span.arrow {border:0; background:url(http://webimage.10x10.co.kr/playmo/ground/20160307/btn_prev.png) no-repeat 0 0; background-size:100% 100%;}
.paging span.nextBtn {background:url(http://webimage.10x10.co.kr/playmo/ground/20160307/btn_next.png) no-repeat 0 0; background-size:100% 100%;}
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

	<% if commentcount>0 then %>
		alert("한 ID당 한번만 참여할 수 있습니다.");
		return false;
	<% else %>
	   if(!frm.txtcomm.value){
		alert("작가 이석원에게 하고 싶은 질문을 입력해주세요");
		document.frmcom.txtcomm.value="";
		frm.txtcomm.focus();
		return false;
	   }

		if (GetByteLength(frm.txtcomm.value) > 100){
			alert("제한길이를 초과하였습니다. 100자 까지 작성 가능합니다.");
			frm.txtcomm.focus();
			return;
		}

	   frm.action = "/play/groundcnt/doEventSubscript69489.asp";
	   return true;
	<% end if %>
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
		parent.calllogin();
		return false;
		<% else %>
		parent.jsevtlogin();
		return;
		<% end if %>			
	}

	return false;
}

function copy_url(url) {
	var IE=(document.all)?true:false;
	if (IE) {
		if(confirm("이 글의 URL 주소를 클립보드에 복사하시겠습니까?"))
			window.clipboardData.setData("Text", url);
	} else {
		temp = prompt("이 글의 트랙백 주소입니다.\n 클립보드에 복사하세요", url);
	}
}
</script>
<div class="mPlay20160307">
	<article>
		<div class="topic">
			<img src="http://webimage.10x10.co.kr/playmo/ground/20160307/bg_light_on.jpg" alt="" />
			<div class="off"><img src="http://webimage.10x10.co.kr/playmo/ground/20160307/bg_light_off.jpg" alt="" /></div>
			<h2 class="fadeInSlideUp"><img src="http://webimage.10x10.co.kr/playmo/ground/20160307/tit_talk.png" alt="민낯 토크" /></h2>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160307/txt_come.png" alt="많은 사람들에게 보여지는 모습을 준비하는 과정, 텐바이텐 PLAY 3월 주제는 샤워입니다. 막 샤워하고 나온 듯 겉치장은 벗어 던지고 본연의 나를 맞이하는 진솔한 시간. 작가 이석원과 함께하는 잡담회에 놀러오세요!" /></p>
		</div>

		<div class="preview">
			<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20160307/tit_preview.jpg" alt="민낯 토크" /></h3>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160307/txt_preview_carefully.jpg" alt="비밀을 보여주면 달아날 거란 생각에 두려움을 갖곤 하지만 사실은 더욱 큰 사랑을 느끼게 되므로 이것이야말로 사랑의 반전인 것이다. 따라서, 비밀공개는 신중히" /></p>
			<p class="slow"><img src="http://webimage.10x10.co.kr/playmo/ground/20160307/txt_preview_slow.jpg" alt="도로에서 가장 느리게 달리는 차는 항상 나다. 그래서 내 뒤에 오는 차들은 거의 어김없이 클랙슨을 누르며 답답해하다가 쌩, 하고 추월을 하곤 한다. 너네는 좋겠다. 그렇게 급한 일, 종요한 일, 가치 있는 일이 있어서. 그렇게 미친 듯이 가야 할 곳이 있어서. 오늘도 나는 가장 느리게 달린다." /></p>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160307/txt_preview_adult.jpg" alt="어른, 자신에게 선물을 하게 되는 순간부터." /></p>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160307/txt_preview_running.jpg" alt="이어달리기 연애란 이 사람한테 받은 걸 저 사람한테 주는 이어달리기와도 같은 것이어서 전에 사람한테 주지 못한 걸 이번 사람한테 주고 전에 사람한테 당한 걸 죄 없는 이번 사람한테 푸는 이상한 게임이다. 불공정하고 이치에 안 맞긴 하지만 이 특이한 이어달리기의 경향이 대체로 그렇다." /></p>
		</div>

		<div class="book">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160307/txt_book.jpg" alt="보통의 존재 그에게는 무슨 일이 있었던 것일까? 책에는 아무리 궁금해 해도 알 수 없었던 그 남자, 이석원의 속마음에 대한 이야기가 고스란히 담겨 있다. 이석원이 아무렇지 않은 듯 술술 풀어낸 언어의 강물 위에는 말하고 싶어도 너무나 내밀해서 함부로 꺼낼 수 없거나 말하지 않아도 된다고 생각해왔던 이야기들이 흐른다." /></p>
		</div>

		<div class="about">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160307/txt_about.png" alt="독자들의 마음을 두드리고 위로하는 도서 보통의 존재가 사랑받은지 6년이 지났습니다. 한정판 Black Edition의 발행을 기념하며 텐바이텐과 이석원이 만드는 특별한 공연에 초대합니다! 2016년 3월 17일 목요일 오후 7시반 장소는 대학로 텐바이텐 2층 라운지, 드레스코드는 블랙입니다. 콘서트 후 작가님과 단체사진 촬영이 있습니다." /></p>
			<ul>
				<li><a href="#" onclick="<%=chkiif(isapp="1","app_","")%>popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><span></span>페이스북</a></li>
				<li><a href="#" onclick="<%=chkiif(isapp="1","app_","")%>popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');return false;"><span></span>트위터</a></li>
				<% If isapp = "1" Then %>
				<li><a href="#" onclick="callNativeFunction('copyurltoclipboard', {'url':'<%=snpLink%>','message':'링크가 복사되었습니다. 원하시는 곳에 붙여넣기 하세요.'}); return false;"><span></span>URL</a></li>
				<% Else %>
				<li><a href="#" onclick="copy_url('<%=snpLink%>'); return false;"><span></span>URL</a></li>
				<% End If %>
				<li><a href="#" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');return false;"><span></span>카카오톡</a></li>
			</ul>
		</div>

		<div class="commentevt" id="commentevt">
			<div class="form">
				<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
				<input type="hidden" name="eventid" value="<%=eCode%>"/>
				<input type="hidden" name="bidx" value="<%=bidx%>"/>
				<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
				<input type="hidden" name="iCTot" value=""/>
				<input type="hidden" name="mode" value="add"/>
				<input type="hidden" name="userid" value="<%=GetEncLoginUserID%>"/>
				<input type="hidden" name="eCC" value="1">
				<input type="hidden" name="reload" value="ON">
					<fieldset>
					<legend>작가 이석원에게 하고 싶은 질문 쓰기</legend>
						<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160307/txt_comment.png" alt="작가 이석원에게 하고 싶은 질문이 있나요? 사연을 남겨주신 분들 중 추첨을 통해 토크 콘서트 민낯토크에 초대합니다. 이벤트 기간은 3월 7일부터 13일까지며, 당첨자 발표는 3월 14일입니다." /></p>
						<div class="inner">
							<div class="field">
								<textarea title="코멘트 작성" cols="60" rows="5"  name="txtcomm" onClick="jsChklogin22('<%=IsUserLoginOK%>');"></textarea>
								<input type="submit" value="응모하기" class="btnsubmit" />
							</div>
						</div>
					</fieldset>
				</form>
			</div>
			<form name="frmdelcom" method="post" action="/event/lib/comment_process.asp" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>">
			<input type="hidden" name="bidx" value="<%=bidx%>">
			<input type="hidden" name="Cidx" value="">
			<input type="hidden" name="mode" value="del">
			<input type="hidden" name="userid" value="<%=GetEncLoginUserID%>">
			</form>
			
			<% IF isArray(arrCList) THEN %>
			<div class="commentlist" id="commentlist">
				<p class="total"><span>Total <%=FormatNumber(iCTotCnt,0)%></span></p>
				<ul>
					<% For intCLoop = 0 To UBound(arrCList,2) %>
					<li>
						<span class="no">No. <%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
						<span class="id"><%=printUserId(arrCList(2,intCLoop),2,"*")%> <% If arrCList(8,intCLoop) = "M"  then%> <img src="http://webimage.10x10.co.kr/playmo/ground/20160215/ico_mobile.png" alt="모바일에서 작성된 글" /><% End If %></span>
						<p class="msg"><%=arrCList(1,intCLoop)%></p>
						<% if ((GetEncLoginUserID = arrCList(2,intCLoop)) or (GetEncLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
						<button type="button" class="btndel" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160215/btn_del.png" alt="삭제" /></button>
						<% End If %>
					</li>
					<% Next %>
				</ul>
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
			</div>
			<% End If %>
		</div>
	</article>
</div>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:false,
		speed:1000,
		autoplayDisableOnInteraction:false,
		nextButton:'.btn-next',
		prevButton:'.btn-prev',
		onSlideChangeStart: function (mySwiper) {
			$(".swiper-slide.topic").find("h2").delay(100).animate({"margin-top":"2%", "opacity":"0"},200);
			$(".swiper-slide.topic").find(".desc").delay(200).animate({"margin-top":"2%", "opacity":"0"},200);
			$(".swiper-slide-active.topic").find("h2").delay(300).animate({"margin-top":"0", "opacity":"1"},600);
			$(".swiper-slide-active.topic").find(".desc").delay(400).animate({"margin-top":"0", "opacity":"1"},600);
		}
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".app").show();
			$(".mo").hide();
	}else{
			$(".app").hide();
			$(".mo").show();
	}

	<% if vreload<>"" then %>
		$('html,body').animate({scrollTop: $("#commentevt").offset().top},0);
	<% end if %>
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->