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
' PLAY #14 Audio_HELLO RHYTHM BOX
' 2014-11-14 이종화 작성
'########################################################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21362
Else
	eCode   =  56626
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

	Dim rencolor
	 
	randomize

	rencolor=int(Rnd*30)+1
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {width:100%; vertical-align:top;}
.rhythm-box {background-color:#f4f7f7;}
.section2 {overflow:hidden; position:relative; z-index:5; width:100%; height:0; margin:45px 0; padding-bottom:95%;}
.section2 .bg {position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/playmo/ground/20141117/bg_txt_stress_solution.gif) no-repeat 0 0; background-size:100% auto;}
.section4 {padding:45px 0;}
/* swiper */
.papercup-swiper {position:relative; width:290px; margin:0 auto;}
.papercup-swiper .swiper-container {overflow:hidden; width:290px;}
.papercup-swiper .swiper .swiper-slide {float:left;}
.papercup-swiper .pagination {position:relative; z-index:10; text-align:center;}
.papercup-swiper .pagination span {display:inline-block; width:12px; height:auto; margin:0 5px; border-radius:0; -webkit-border-radius:0; background-color:transparent; color:#888; font-size:12px; font-weight:bold; line-height:1em; text-align:center;}
.papercup-swiper .pagination .swiper-active-switch {border-bottom:1px solid #ff8b00; color:#ff8b00;}
.papercup-swiper button {position:absolute; top:82px;  z-index:10; width:30px; height:46px; background-color:transparent; background-repeat:no-repeat; background-position:50% 50%; background-size:12px 24px; text-indent:-999em;}
.papercup-swiper .arrow-left {left:0; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20141117/btn_nav_prev.png);}
.papercup-swiper .arrow-right {right:0; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20141117/btn_nav_next.png);}

.section6, .section7 {margin-top:15px;}
.section8 {padding-bottom:30px; background-color:#fe9334;}
.section8 button {overflow:hidden; display:block; position:relative; width:213px; height:45px; margin:0 auto; background-color:transparent; font-size:11px; line-height:45px; text-align:center;}
.section8 button span {display:block; position:absolute; top:0; left:0; width:100%; height:100%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20141117/btn_entry.gif); background-repeat:no-repeat; background-position:0 0; background-size:213px 45px;}
.section8 .count {margin-top:15px; text-align:center;}
.section8 .count img {vertical-align:middle;}
.section8 .count img:first-child {width:12px; margin-right:11px;}
.section8 .count img:last-child {width:177px;}
.section8 .count strong {color:#fff; font-size:30px; line-height:1.25em; vertical-align:middle;}
.section9 {padding-top:21px;}
@media all and (min-width:480px){
	.papercup-swiper {width:435px;}
	.papercup-swiper .swiper-container {width:435px;}
	.papercup-swiper .pagination span {width:18px; margin:0 7px; font-size:18px;}
	.papercup-swiper button {top:123px; width:45px; height:69px; background-size:18px 36px;}
	.section6, .section7 {margin-top:22px;}
	.section8 button {width:319px; height:67px;}
	.section8 button span {background-size:319px 67px;}
}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.pagination',
		paginationClickable:true,
		speed:1000,
		autoplay:5000,
		autoplayDisableOnInteraction: true,
		nextButton:'.arrow-right',
		prevButton:'.arrow-left',
		paginationBulletRender: function (index, className) {
			return '<span class="' + className + '">' + (index + 1) + '</span>';
		}
	});

	$('.arrow-left').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});

	$('.arrow-right').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});
});
</script>
<script type="text/javascript">
<!--
 	function jsSubmitComment(frm){
		<% If IsUserLoginOK() Then %>
			<% If Now() > #12/09/2014 23:59:59# Then %>
				alert("이벤트가 종료되었습니다.");
				return;
			<% Else %>
				var frm = document.frmcom;
				frm.action = "doEventSubscript56626.asp";
				frm.submit();
				return true;
			<% End If %>
		<% Else %>
			<% If isApp="1" or isApp="2" Then %>
			parent.calllogin();
			return false;
			<% else %>
			parent.jsevtlogin();
			return;
			<% end if %>			
		<% End IF %>
	}
//-->
</script>
</head>
<body>
<div class="mPlay20141117">
	<div class="rhythm-box">
		<div class="section section1">
			<h1><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/tit_rhythm_box.gif" alt="헬로 리듬 박스" /></h1>
		</div>

		<div class="section section2">
			<div class="bg"></div>
			<h2>여러분은 스트레스 받을 때 어떻게 해소하시나요?</h2>
			<p>실제로 많은 사람들이 좋아하는 음악을 들으면서 마음의 짐이나, 스트레스를 치유하는 데 많은 도움을 받는다고 합니다. 텐바이텐 PLAY는 음악이 흐르는 것처럼 스트레스를 흘려보낼 수 있기를 바라는 마음에서 RHYTHM BOX를 만들었습니다. 소리가 어떻게 전해지는지 기본적인 원리를 알 수 있고, 듣는 즐거움이 어떻게 생겨나는지 이해할 수 있도록 직접 만들어 볼 수 있는 종이컵 스피커 KIT, 스트레스를 말끔히 없애 주기는 어렵지만 조금이라도 도움이 되길 바라는 마음에서 쓰레기봉투, 면봉, 이태리타월을 담았습니다.</p>
			<p><strong>인생 속, 리듬을 맞추고 좋아하는 음악 속, 리듬을 맞춰 가면서 즐거운 인생 만들어 가시길 바랍니다 : )</strong></p>
		</div>

		<div class="section section3">
			<div class="figure"><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/img_the_rhythm_box.jpg" alt="리듬 박스" /></div>
			<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/tit_rhythm_box_item.gif" alt="리듬 박스 아이템" /></h2>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/txt_rhythm_box_item.gif" alt="리듬 박스는 종이컵 스피커 만들기 키트와 키드 매뉴얼 북, 쓰레기 봉투, 면봉, 이태리 타월로 구성되어있습니다." /></p>
		</div>

		<div class="section section4">
			<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/tit_make_papercup_speaker.gif" alt="리듬맨과 함께 종이컵 스피커 만들기" /></h2>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/txt_material.gif" alt="종이컵, 네오디뮴자석, 에나멜선, 이어폰 잭, 필름 통, 사포, 양면테이프, 투명테이프" /></p>

			<div class="papercup-swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/img_slide_01.jpg" alt="" /></div>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/img_slide_02.jpg" alt="에나멜선의 양 끝을 사포로 문질러 표면을 벗져주세요" /></p>
						</div>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/img_slide_03.jpg" alt="애나멜선을 필름 통에 감고 투명테이프로 고정시켜주세요." /></p>
						</div>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/img_slide_04.jpg" alt="종이컵의 바깥쪽 중앙에 네오디뮴자석을 붙여주세요." /></p>
						</div>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/img_slide_05.jpg" alt="에나멜선이 감긴 필름 통을 종이컵 바닥에 고정시켜주세요." /></p>
						</div>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/img_slide_06.jpg" alt="이어폰 잭의 전선 두 가닥의 피복을 제거해주세요." /></p>
						</div>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/img_slide_07.jpg" alt="전선을 에나멜선 양 끝에 각각 연결하고, 고정시켜주세요." /></p>
						</div>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/img_slide_08.jpg" alt="핸드폰에 꽂아 볼륨을 최대로 한 다음 소리를 들어보세요." /></p>
						</div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="arrow-left">이전</button>
				<button type="button" class="arrow-right">다음</button>
			</div>
		</div>

		<div class="section section5">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/txt_cotton_swab.jpg" alt="나쁜 소리들은 면봉으로 제거하고 그 자리 좋은 곡들을 차곡차곡담으세요." /></p>
		</div>

		<div class="section section6">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/txt_towel.jpg" alt="이태리 타월로 피로와 스트레스는 싸악 밀어내고, 깨끗이 씻어 내세요." /></p>
		</div>

		<div class="section section7">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/txt_trash_bag.jpg" alt="쓰레기 봉투에 나쁜 것들은 꽁꽁 싸매서 버리세요. 버리면 좋은 것들은 더 많이 채워져요." /></p>
		</div>

		<!-- for dev msg : 리듬 박스 응모 -->
		<form name="frmcom" method="post" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>"/>
		<input type="hidden" name="bidx" value="<%=bidx%>"/>
		<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
		<input type="hidden" name="iCTot" value=""/>
		<input type="hidden" name="mode" value="add"/>
		<input type="hidden" name="spoint" value="1">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>"/>
		<div class="section section8">
			<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/tit_present.gif" alt="응모하신 분들 중 10분을 추첨해 텐바이텐 PLAY가 제작한 리듬박스를 선물로 드립니다." /></h2>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/txt_date.gif" alt="응모기간은 2014년 11월 17일부터 12월 2일까지며, 발표는 2014년 12월 4일입니다. 응모를 많이 하실 수록 당첨기회가 UP!" /></p>
			<button type="button" onclick="jsSubmitComment();return false;">리듬박스 신청하기<span></span></button>
			<p class="count">
				<img src="http://webimage.10x10.co.kr/playmo/ground/20141117/txt_total.gif" alt="총" />
				<strong><%=iCTotCnt%></strong>
				<img src="http://webimage.10x10.co.kr/playmo/ground/20141117/txt_want.gif" alt="명이 리듬 박스를 원합니다." />
			</p>
		</div>
		</form>

		<div class="section section9">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141117/img_rhythm_box_view.jpg" alt="종이컵, 네오디뮴자석, 에나멜선, 이어폰 잭, 필름 통, 사포, 양면테이프, 투명테이프로 구성된 리듬박스" /></p>
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->