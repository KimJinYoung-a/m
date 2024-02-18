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
'########################################################
' PLAY #17 3주차
' 2015-02-02 이종화 작성
'########################################################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21463
Else
	eCode   =  59301
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
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.mPlay20150216 {}
.walkWithYou {position:relative;}
.walkWithYou a {position:absolute; left:15%; bottom:8%; width:70%; height:10%; color:transparent;}
.applyEvent .applyCont {padding-bottom:30px; background:url(http://webimage.10x10.co.kr/playmo/ground/20150216/bg_slash.gif) left top repeat-y; background-size:100% auto;}
.applyEvent .apply {display:block; width:64%; margin:0 auto; padding-bottom:15px;}
.applyEvent .count {text-align:center;}
.applyEvent .count .c01 {width:13px; vertical-align:middle;}
.applyEvent .count .c02 {width:145px; vertical-align:middle;}
.applyEvent .count span {display:inline-block; padding:0 0 0 8px; color:#f6cc47; font-size:30px; line-height:1.2; vertical-align:middle;}
@media all and (min-width:480px){
	.applyEvent .apply {padding-bottom:23px;}
	.applyEvent .count .c01 {width:20px;}
	.applyEvent .count .c02 {width:218px;}
	.applyEvent .count span {padding:0 0 0 12px; font-size:45px;}
}
</style>
<script type="text/javascript">
<!--
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
	   
	   var frm = document.frmcom;
	   frm.action = "doEventSubscript59301.asp";
	   frm.submit();
	   return true;
	}
	$(function(){
		$(".walkWithYou a").click(function(event){
			event.preventDefault();
			window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 800);
		});
	});
//-->
</script>
</head>
<body>
<div class="mPlay20150216">
	<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150216/tit_walk_together.gif" alt="가치걷기" /></h2>
	<div class="walkWithYou">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150216/txt_walk_together.gif" alt="WALK WITH YOU" /></p>
		<a href="#applyEvent">가치걷기 신청하러가기</a>
	</div>
	<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150216/img_pictogram.gif" alt="" /></p>
	<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150216/tit_walk_with_you.jpg" alt="가치걷기" /></h2>
	<ul>
		<li><img src="http://webimage.10x10.co.kr/playmo/ground/20150216/img_wish_card.jpg" alt="WISH CARD" /></li>
		<li><img src="http://webimage.10x10.co.kr/playmo/ground/20150216/img_active_card.jpg" alt="ACTIVE CARD" /></li>
		<li><img src="http://webimage.10x10.co.kr/playmo/ground/20150216/img_love_card.jpg" alt="LOVE CARD" /></li>
		<li><img src="http://webimage.10x10.co.kr/playmo/ground/20150216/img_kind_card.jpg" alt="KIND CARD" /></li>
	</ul>
	<!-- 응모하기 -->
	<form name="frmcom" method="post" style="margin:0px;">
	<input type="hidden" name="eventid" value="<%=eCode%>"/>
	<input type="hidden" name="bidx" value="<%=bidx%>"/>
	<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
	<input type="hidden" name="iCTot" value=""/>
	<input type="hidden" name="mode" value="add"/>
	<input type="hidden" name="spoint" value="1">
	<input type="hidden" name="userid" value="<%=GetLoginUserID%>"/>
	<div class="applyEvent" id="applyEvent">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150216/txt_apply_kit.gif" alt="응모하신 분들 중 5분을 추첨해 텐바이텐 PLAY가 제작한 가치걷기 KIT를 선물로 드립니다." /></p>
		<div class="applyCont">
			<a href="" onclick="jsSubmitComment();return false;" class="apply"><img src="http://webimage.10x10.co.kr/playmo/ground/20150216/btn_walk_together.png" alt="가치걷기 신청하기" /></a>
			<p class="count">
				<img src="http://webimage.10x10.co.kr/playmo/ground/20150216/txt_count01.png" alt="총" class="c01" />
				<span><%=iCTotCnt%></span>
				<img src="http://webimage.10x10.co.kr/playmo/ground/20150216/txt_count02.png" alt="명이 같이 걷고 있습니다."  class="c02" />
			</p>
		</div>
	</div>
	</form>
	<!--// 응모하기 -->
	<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150216/img_card01.jpg" alt="카드이미지1" /></div>
	<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150216/img_card02.jpg" alt="카드이미지2" /></div>
	<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150216/img_card03.jpg" alt="카드이미지3" /></div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->