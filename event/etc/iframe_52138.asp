<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<%
'#### 2014-05-23 이종화 작성 play_sub ###################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21178
Else
	eCode   =  52137
End If

dim com_egCode, bidx
	Dim cEComment
	Dim iCTotCnt, arrCList,intCLoop, iSelTotCnt
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt

	'파라미터값 받기 & 기본 변수 값 세팅
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)	

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
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<script src="/lib/js/swiper-1.8.min.js"></script>
<script type="text/javascript">
	$(function(){
		/* Move */
		$(".btnMove a").click(function(event){
			event.preventDefault();
			window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 500);
		});
	});

	function goPage(page){
		scrollToAnchor('rank');
		document.frmcom.iCC.value=page;
		document.frmcom.action="";
		document.frmcom.submit();
	}

	function scrollToAnchor(where){
		scrollY=document.getElementById(where).offsetTop;
		scrollTo(0,scrollY);
	}

	function jsSubmitComment(frm){
				
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>
		
		if(!frm.msg1.value || frm.msg1.value == "런"){
	    alert("가사를 바꿔주세요");
		document.frmcom.msg1.value="";
	    frm.msg1.focus();
	    return false;
	   }

	   if(!frm.msg2.value || frm.msg2.value == "치"){
	    alert("가사를 바꿔주세요");
		document.frmcom.msg2.value="";
	    frm.msg2.focus();
	    return false;
	   }

	   if(!frm.msg3.value || frm.msg3.value == "런"){
	    alert("가사를 바꿔주세요");
		document.frmcom.msg3.value="";
	    frm.msg3.focus();
	    return false;
	   }

	   if(!frm.msg4.value || frm.msg4.value == "치"){
	    alert("가사를 바꿔주세요");
		document.frmcom.msg4.value="";
	    frm.msg4.focus();
	    return false;
	   }

	   document.frmcom.txtcomm.value = document.frmcom.msg1.value + document.frmcom.msg2.value + document.frmcom.msg3.value + document.frmcom.msg4.value;

	   frm.action = "doEventSubscript50842.asp";
	   return true;
	}

	function jsDelComment(cidx)	{
		if(confirm("삭제하시겠습니까?")){
			document.frmdelcom.Cidx.value = cidx;
	   		document.frmdelcom.submit();
		}
	}

	function jsChklogin11(blnLogin)
	{
		if (blnLogin == "True"){
			if(document.frmcom.msg1.value == "런"){
				document.frmcom.msg1.value="";
			}
			if(document.frmcom.msg2.value == "치"){
				document.frmcom.msg2.value="";
			}
			if(document.frmcom.msg3.value == "런"){
				document.frmcom.msg3.value="";
			}
			if(document.frmcom.msg4.value == "치"){
				document.frmcom.msg4.value="";
			}
			return true;
		} else {
			jsChklogin('<%=IsUserLoginOK%>');
		}

		return false;
	}

</script>
<title>생활감성채널, 텐바이텐 > 이벤트 > 떠나요, 모든걸 훌훌 버리고</title>
<style type="text/css">
.mEvt52137 {}
.mEvt52137 img {vertical-align:top; width:100%;}
.mEvt52137 p {max-width:100%;}
.lunchKiki img {width:100%;}
.lunchKiki .section {padding:0;}
.lunchKiki .section h3 {margin:0; padding:0;}
.lunchKiki .section2 .group {position:relative;}
.lunchKiki .section2 .movie {position:absolute; top:12%; left:0; width:100%; padding:0 5% 0 5.3125%; box-sizing:border-box; -webkit-box-sizing:border-box; -moz-box-sizing:border-box;}
.lunchKiki .section2 .youtube {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background:#000;}
.lunchKiki .section2 .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%;}
.lunchKiki .section5 {position:relative;}
.lunchKiki .section5 .btnGo {position:absolute; top:-17%; right:0; width:24%;}
.lunchKiki .section5 legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.lunchKiki .section5 .part {position:absolute; top:39%; left:0; width:100%; text-align:center;}
.lunchKiki .section5 .part strong:first-child {display:block; margin-bottom:25px;}
.lunchKiki .section5 .part strong {color:#888; font-size:23px;}
.lunchKiki .section5 .part span {display:inline-block; margin-right:4px;}
.lunchKiki .section5 .part span input {width:34px; height:34px; margin:0 2px; border:2px solid #bbb; color:#444; font-size:27px; font-weight:bold; line-height:34px; text-align:center;}
@media all and (max-width:480px){
	.lunchKiki .section5 .part strong {font-size:15px;}
	.lunchKiki .section5 .part strong:first-child {display:block; margin-bottom:5px;}
	.lunchKiki .section5 .part span input {width:25px; height:25px; font-size:18px; line-height:25px;}
}
.lunchKiki .section5 .btnSubmit {position:absolute; bottom:28%; left:0;}
.lunchKiki .section5 .btnSubmit input {width:100%;}
.lunchKiki .section6 .group {margin-top:24px; padding:0 3%;}
.lunchKiki .section6 .part {position:relative; min-height:84px; margin-top:12px; padding:16px 0 0 115px; border-radius:60px; background-position:5px 50%; background-repeat:no-repeat; text-align:left;}
.lunchKiki .section6 .part .num {position:absolute; width:100px; left:0; bottom:15px; color:#fff; font-size:12px; text-align:center;}
.lunchKiki .section6 .part .id {color:#999; font-size:13px;}
.lunchKiki .section6 .part .song {margin-top:10px; color:#777; font-size:20px; font-weight:bold;}
.lunchKiki .section6 .part .date {display:block; margin-top:5px; padding-right:30px; color:#999; font-size:13px; text-align:right;}
.lunchKiki .section6 .part .icoMobile {width:10px; margin-top:2px; vertical-align:top;}
.lunchKiki .section6 .part .btnDel {position:absolute; top:0; right:0; width:26px; height:26px; margin:0; padding:0; border:0; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52137/btn_del.png) left top no-repeat; background-size:26px 26px; text-indent:-999em; cursor:pointer;}
.lunchKiki .section6 .bg1 {border:2px solid #60e1df; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52137/bg_song_box_01.gif); background-size:109px 89px;}
.lunchKiki .section6 .bg1 .song strong {color:#2ccbc9;}
.lunchKiki .section6 .bg2 {border:2px solid #ff8173; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52137/bg_song_box_02.gif); background-size:109px 89px;}
.lunchKiki .section6 .bg2 .song strong {color:#ff8173;}
.lunchKiki .section6 .bg3 {border:2px solid #ffbb29; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52137/bg_song_box_03.gif); background-size:109px 89px;}
.lunchKiki .section6 .bg3 .song strong {color:#ffbb29;}
.lunchKiki .section6 .bg4 {border:2px solid #987cf5; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52137/bg_song_box_04.gif); background-size:109px 89px;}
.lunchKiki .section6 .bg4 .song strong {color:#987cf5;}
.lunchKiki .section6 .paging {margin-top:28px;}
@media all and (max-width:480px){
	.lunchKiki .section6 .part {min-height:60px; padding:8px 0 0 80px;}
	.lunchKiki .section6 .part .num {width:70px; left:0; bottom:5px; font-size:8px;}
	.lunchKiki .section6 .part .id {font-size:8px;}
	.lunchKiki .section6 .part .song {margin-top:0; font-size:13px;}
	.lunchKiki .section6 .part .date {margin-top:0; font-size:8px;}
	.lunchKiki .section6 .part .icoMobile {width:8x;}
	.lunchKiki .section6 .part .btnDel {width:17px; height:17px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52137/btn_del.png) left top no-repeat; background-size:17px 17px;}
	.lunchKiki .section6 .bg1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52137/bg_song_box_01.gif); background-size:72px 59px;}
	.lunchKiki .section6 .bg2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52137/bg_song_box_02.gif); background-size:72px 59px;}
	.lunchKiki .section6 .bg3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52137/bg_song_box_03.gif); background-size:72px 59px;}
	.lunchKiki .section6 .bg4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52137/bg_song_box_04.gif); background-size:72px 59px;}
}
</style>
</head>
<body>
<div class="mEvt52137">
	<div class="lunchKiki">
		<div class="section section1">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52137/tit_lunch_kiki.jpg" alt="Aloha! Kunch - kiki" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52137/txt_lunch_kiki.jpg" alt="텐바이텐과 하와이 음악 밴드 마푸키키가 함께 만든 런치송, 일상 속 하와이를 즐길 수 있는 런치콘서트에 초대합니다." /></p>
		</div>

		<div id="lunchSong" class="section section2">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/52137/tit_lunch_song.jpg" alt="LUNCH SONG : TENBYTEN과 마푸키키" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52137/txt_lunch_song.jpg" alt="텐바이텐과 마푸키키가 함께 만든 런치송을 감상하세요!" /></p>
			<div class="group">
				<div class="movie">
					<div class="youtube">
						<iframe src="//player.vimeo.com/video/96153443" frameborder="0" title="LUNCH SONG" allowfullscreen></iframe>
					</div>
				</div>
				<div class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52137/bg_tv.jpg" alt="" /></div>
			</div>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52137/txt_sponsor.jpg" alt="런치송 뮤직비디오 장소협찬 : 홍대 봉주르 하와이" /></p>
			<div class="btnGo btnMove"><a href="#lunchConcert"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52137/btn_go_evnet.jpg" alt="이벤트 참여하기" /></a></div>
		</div>

		<div class="section section3">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/52137/tit_mapukiki.jpg" alt="마푸키키" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52137/txt_mapukiki.jpg" alt="알로하! 향긋한 꽃 향기라는 뜻의 마푸(Mapu)와 발사하다, 쏘다 라는 뜻의 키키(kiki)의 하와이어 합성어로 남국의 휴양지에서 들을 수 있을 법한 여유로운 노래를 연주하고 부르는 3인조 밴드 입니다!" /></p>
		</div>

		<div class="section section4">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/52137/tit_lunch_concert.jpg" alt="텐바이텐과 마푸키키가 함께하는 ALOHA! LUNCH - KIKI" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52137/txt_lunch_concert.jpg" alt="하와이의 청명한 하늘과 짙푸른 바다를 연상시키는 마푸키키 앨범발매 쇼케이스 런치 콘서트에 여러분을 초대합니다! 장소 : 서울의 좋고 예쁜 곳 어딘가, 시간 : 2014년 6월 22일 점심, 스페셜 기프트 : 알로하 런치박스" /></p>
		</div>

		<!-- 런치송 가사 바꾸기 폼 -->
		<div id="lunchConcert" class="section section5">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/52137/tit_lunch_song_change.jpg" alt="텐바이텐X마푸키키 런치송을 듣고 네모 안의 가사를 바꿔 주세요!" /></h3>
			<div class="btnGo btnMove"><a href="#lunchSong"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52137/btn_go_lunch_song.png" alt="런치송 감상하기" /></a></div>
			<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>">
			<input type="hidden" name="bidx" value="<%=bidx%>">
			<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
			<input type="hidden" name="iCTot" value="">
			<input type="hidden" name="mode" value="add">
			<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
			<input type="hidden" name="txtcomm">
				<fieldset>
				<legend>런치송 가사 바꾸기</legend>
					<div class="part">
						<strong>둘이- 우리 둘이</strong>
						<span>
							<input type="text" title="첫번째 글자 입력" value="런" name="msg1" maxlength="1" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');"/>
							<input type="text" title="두번째 글자 입력" value="치" name="msg2" maxlength="1" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');"/>
							<input type="text" title="세번째 글자 입력" value="런" name="msg3" maxlength="1" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');"/>
							<input type="text" title="네번째 글자 입력" value="치" name="msg4" maxlength="1" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');"/>
						</span>
						<strong>with me~</strong>
					</div>
					<div class="btnSubmit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/52137/btn_enter_event.png" alt="이벤트 참여" /></div>
					<div class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52137/bg_round_box.jpg" alt="" /></div>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52137/txt_gift.jpg" alt="정성스럽게 댓글을 남겨주신 50분을 추첨해 런치 콘서트(1인 2매) 입장권 + 알로하 런치박스를 선물로 드립니다. 이벤트 기간 : 2014.05.26 - 06.10 당첨자 발표 : 2014.06.11" /></p>
				</fieldset>
			</form>
			<form name="frmdelcom" method="post" action="doEventSubscript50842.asp" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>">
			<input type="hidden" name="bidx" value="<%=bidx%>">
			<input type="hidden" name="Cidx" value="">
			<input type="hidden" name="mode" value="del">
			<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
			</form>
		</div>
		<!-- //런치송 가사 바꾸기 폼 -->
		<% IF isArray(arrCList) THEN %>
		<!-- 런치송 가사 List -->
		<div class="section section6">
			<% For intCLoop = 0 To UBound(arrCList,2)%>
			<div class="group">
				<div class="part bg<%=intCLoop+1%>">
					<span class="num">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
					<div class="id"><span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span> 님의 런치송</div>
					<div class="song">둘이- 우리 둘이 <strong><%=nl2br(arrCList(1,intCLoop))%></strong> with me</div>
					<span class="date"><% If arrCList(8,intCLoop) = "M"  then%><img src="http://webimage.10x10.co.kr/eventIMG/2014/52137/ico_mobile.png" alt="모바일에서 작성" class="icoMobile" /><% End If %> <%=formatdate(arrCList(4,intCLoop),"0000.00.00")%></span>
					<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
					<button type="button" class="btnDel" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>')"><span>삭제</span></button>
					<% end if %>
				</div>
			</div>
			<% Next %>
			<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>
		</div>
		<% End If %>
		<!-- //런치송 가사 List -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->