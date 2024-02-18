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
' PLAY #15 어둠 속의 대화
' 2014-12-18 이종화 작성
'########################################################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21411
Else
	eCode   =  57921
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
.mPlay20141222 {}

.movie {background-color:#efefef;}
.moviewrap {position:relative; padding:0 4.68% 5%;}
.moviewrap .youtube {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background:#000;}
.moviewrap .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%}

.tenbyten {padding-bottom:12%; background-color:#111;}
.tenbyten .btngo {width:62.5%; margin:7% auto 0;}
.exhibition {padding-bottom:15%; background-color:#fff; text-align:center;}
.exhibition .want {overflow:hidden; position:relative; width:66.625%; height:0; margin:0 auto; padding-bottom:16.1%; background:url(http://webimage.10x10.co.kr/playmo/ground/20141222/btn_apply.gif) no-repeat 50% 0; background-size:100% auto; text-indent:-999em;}
.exhibition .want span {position:absolute; top:0; left:0; width:100%; height:100%}
.count {margin-top:3%;}
.count img {vertical-align:middle;}
.count .total img {width:10px;}
.count .apply img {width:116px;}
.count strong {margin:0 4px; font-size:20px; font-style:italic; line-height:1.125em; vertical-align:middle;}

.about {position:relative;}
.about .btngo {position:absolute; bottom:22%; left:50%; width:46.8%; margin-left:-23.4%;}

@media all and (min-width:480px){
	.count .total img {width:15px;}
	.count .apply img {width:174px;}
	.count strong {font-size:30px;}
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
	   frm.action = "/play/groundcnt/doEventSubscript57921.asp";
	   frm.submit();
	   return true;
	}
//-->
</script>
</head>
<body>
<div class="mPlay20141222">
	<div class="dialogue">
		<div class="main">
			<h1><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/tit_dialogue_in_the_dark.gif" alt="어둠속의 대화 DIALOGUE IN THE DARK" /></h1>
		</div>

		<div class="story">
			<p class="word"><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/txt_word_01.gif" alt="빛이 전혀 없는 완전한 어둠 속 세상 상상해 본 적이 있으신가요?" /></p>
			<p class="word"><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/txt_word_02.gif" alt="쉴 새 없이움직이는 눈을 쉬게 하고 코, 입, 귀, 피부 등을 이용해 평소 잠자고 있는 당신의 뇌와 마음을 깨울 수 있다면 어떨까요." /></p>
			<div><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/img_candle_dark.gif" alt="" /></div>
			<p class="word"><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/txt_word_03.gif" alt="눈을 감고 세상을 상상하면 어떤 무의식적인 동작을 반복했는지 알게 되며, 깊이 숨겨두었던 나만의 생각과 사고를 이끌어낼 수 있어요." /></p>
			<p class="word"><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/txt_word_04.gif" alt="각자가 가진 감성과 살아 숨 쉬고 있는, 평소에는 미처 깨닫지 못 했던 나의 감각들과 함께 어둠속의대화는 시작됩니다." /></p>
			<div><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/img_candle_light.jpg" alt="" /></div>
			<p class="word"><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/txt_word_05.gif" alt="완전한 어둠 속에서 자신과의 가장 솔직한 대화를 시작해보세요." /></p>
			<p class="word"><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/txt_word_06.gif" alt="아무것도 보이지 않는 어둠 속이지만 우리가 생각하는, 상상할 수 있는 모든 것이 존재합니다." /></p>
		</div>

		<div class="movie">
			<h4><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/tit_movie.gif" alt="MOVIE" /></h4>
			<div class="moviewrap">
				<div class="youtube">
					<iframe src="//player.vimeo.com/video/114949521" frameborder="0" title="어둠속의 대화" allowfullscreen></iframe>
				</div>
			</div>
			<img src="http://webimage.10x10.co.kr/playmo/ground/20141222/bg_movie_arrow.gif" alt="" />
		</div>

		<div class="tenbyten">
			<h4><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/tit_tenbyten.gif" alt="텐바이텐과 어둠속의 대화" /></h4>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/txt_tenbyten.gif" alt="빛이 있다면, 그 반대엔 완전한 어둠도 존재합니다. 텐바이텐 PLAY는 어둠이 가지고 있는 새로운 의미와 가치에 대해 이야기하려 합니다. 사람과 사람 사이의 물리적인 관계를 단절시키는 완전한 어둠 속에서 서로가 빛이 되어 의지하는 이 특별한 경험은 함께 함의 소중함을 깨닫게 합니다." /></p>
			<div class="btngo"><a href="#section6"><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/btn_go.gif" alt="신청하러 가기" /></a></div>
		</div>

		<div class="kit">
			<h4><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/tit_kit.gif" alt="SPECIAL KIT" /></h4>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/txt_kit_01.gif" alt="오늘은, 모든 조명을 끄고 초를 켜세요. 너무나 좋은 향기와 타닥타닥 타 들어가는 소리. 서로 마음을 터 놓고 이해할 수 있는 시간을 가질 수 있어요." /></p>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/img_kit.jpg" alt="스페셜 키트는 어둠속의 대화 전시 티켓 1인 2매와 캔들 하나, 어둠속의 대화 성냥 3각을으로 구성되어 있습니다." /></p>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/txt_kit_02.gif" alt="어둠속의대화 향초는 100% 콩에서 추출한 천연 소이왁스와 꽃과 나무로부터 얻은 오일로 직접 만들었습니다. 스페셜 키트는 한정수량으로 제작되어 판매가 되지 않습니다." /></p>
			<img src="http://webimage.10x10.co.kr/playmo/ground/20141222/img_kit_package.jpg" alt="" />
		</div>

		<!-- EXHIBITION -->
		<form name="frmcom" method="post" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>"/>
		<input type="hidden" name="bidx" value="<%=bidx%>"/>
		<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
		<input type="hidden" name="iCTot" value=""/>
		<input type="hidden" name="mode" value="add"/>
		<input type="hidden" name="spoint" value="1">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>"/>
		<div id="section6" class="exhibition">
			<h4><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/tit_exhibition.gif" alt="EXHIBITION" /></h4>
			<p class="event"><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/txt_event.gif" alt="어둠속의대화를 하고 싶으신가요? 10분을 추첨해 SPECIAL KIT를 드립니다. 당첨되신 티켓은 당첨일로부터 3개월 안에 사용하실 수 있습니다" /></p>
			<button type="button" class="want" onclick="jsSubmitComment();return false;"><span>어둠속의 대화 신청하기</span></button>
			<p class="count">
				<span class="total"><img src="http://webimage.10x10.co.kr/play/ground/20141222/txt_total.gif" alt="총" /></span>
				<strong><%=iCTotCnt%></strong>
				<span class="apply"><img src="http://webimage.10x10.co.kr/play/ground/20141222/txt_want.gif" alt="명이 신청하셨습니다." /></span>
			</p>
		</div>
		</form>

		<div class="about">
			<h4><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/tit_about.jpg" alt="ABOUT 전시, 어둠속의 대화 빛이 존재하지 않는 완전한 어둠 속 세상" /></h4>
			<div class="btngo"><a href="http://www.dialogueinthedark.co.kr/index.nhn" target="_top" title="새창"><img src="http://webimage.10x10.co.kr/playmo/ground/20141222/btn_more.gif" alt="자세히 보러가기" /></a></div>
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->