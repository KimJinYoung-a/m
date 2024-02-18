<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<%
'########################################################
' 플레이모빌
' 2015-07-17 이종화 작성
'########################################################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  "64833"
Else
	eCode   =  "65026"
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
<style type="text/css">
img {vertical-align:top;}
.mEvt65026 {position:relative;}
.invite {position:relative;}
.invite .btnSubmit {display:block; position:absolute; left:17.5%; bottom:5%; width:65%;}
.count {text-align:center; padding:23px 0 20px; background:#fa6266;}
.count strong {display:inline-block; position:relative; top:-1px; color:#fff; font-size:14px; line-height:1; padding-right:2px; margin-left:2px;}
.count strong:before,
.count strong:after {content:' '; position:absolute; bottom:-2px; left:0; width:100%; height:2px; background:#fff;}
.count strong:after {left:100%; width:10px;}
.count img {display:inline-block;}
.count .t01 {width:121px;}
.count .t02 {width:102px;}
@media all and (min-width:480px){
	.count {padding:35px 0 30px;}
	.count strong {top:0; font-size:21px; padding-right:3px; margin-left:3px;}
	.count strong:after {width:15px;}
	.count .t01 {width:182px;}
	.count .t02 {width:153px;}
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
	   frm.action = "/event/lib/doEventComment.asp";
	   frm.submit();
	   return true;
	}
//-->
</script>
<div class="mEvt65026">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/65026/tit_play_mobil.jpg" alt="WE♥플레이모빌" /></h2>
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/65026/tit_preview.jpg" alt="플레이모빌 아트전 미리보기" /></h3>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65026/txt_info.jpg" alt="전시회 정보" /></p>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/65026/img_exhibition.jpg" alt="" /></div>
	<form name="frmcom" method="post" style="margin:0px;">
	<input type="hidden" name="eventid" value="<%=eCode%>"/>
	<input type="hidden" name="bidx" value="<%=bidx%>"/>
	<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
	<input type="hidden" name="iCTot" value=""/>
	<input type="hidden" name="mode" value="addone"/>
	<input type="hidden" name="spoint" value="1">
	<input type="hidden" name="userid" value="<%=GetLoginUserID%>"/>
	<div class="invite">
		<h3 id="need"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65026/tit_invite.jpg" alt="플레이모빌 아트전 초대이벤트" /></h3>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65026/txt_event_.jpg" alt="총 100분을 추첨해 플레이모빌 아트전 초대권(1인2매)을 선물로 드립니다." /></p>
		<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/65026/btn_apply.png" alt="응모하기" class="btnSubmit" onclick="jsSubmitComment();return false;"/>
	</div>
	<div class="count">
		<img src="http://webimage.10x10.co.kr/eventIMG/2015/65026/txt_count01.gif" class="t01" alt="플레이모빌을 사랑하시는" />
		<strong><%=FormatNumber(iCTotCnt,0)%></strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/65026/txt_count02.gif" class="t02" alt="분이 신청하셨습니다." />
	</div>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/65026/img_exhibition02.jpg" alt="" /></div>
	</form>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->