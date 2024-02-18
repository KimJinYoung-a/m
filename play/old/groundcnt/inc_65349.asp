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
' PLAY #23 SUMMER ITEM _ BANGBANG GUN(뱅뱅건)
' 2015-08-07 원승현 작성
'########################################################
Dim eCode, userid, vQuery, vga
IF application("Svr_Info") = "Dev" THEN
	eCode   =  64847
Else
	eCode   =  65349
End If

userid = getloginuserid()
vga			= requestCheckVar(Request("ga"),3)

Dim strSql, incruitCnt, jobCnt, albaCnt, loveCnt

	vQuery = " Select count(userid) From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' And sub_opt3='incruit' "
	rsget.Open vQuery,dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		incruitCnt = rsget(0)
	End IF
	rsget.close

	vQuery = " Select count(userid) From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' And sub_opt3='job' "
	rsget.Open vQuery,dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		jobCnt = rsget(0)
	End IF
	rsget.close

	vQuery = " Select count(userid) From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' And sub_opt3='alba' "
	rsget.Open vQuery,dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		albaCnt = rsget(0)
	End IF
	rsget.close

	vQuery = " Select count(userid) From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' And sub_opt3='love' "
	rsget.Open vQuery,dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		loveCnt = rsget(0)
	End IF
	rsget.close

%>
<!doctype html>
<html lang="ko">
<head>
<style type="text/css">
img {vertical-align:top;}
.mPlay20150810 {}
.purpose {position:relative;}
.purpose a {display:block; position:absolute; left:12%; bottom:19%; width:76%; height:25%; color:transparent;}
.waterGun {background:url(http://webimage.10x10.co.kr/playmo/ground/20150810/bg_grid.gif) 0 0 repeat-y; background-size:100% auto;}
.waterGun .swiperWrap {padding:0 8.5%;}
.waterGun .swiper .numbering {position:absolute; left:0; bottom:5%; width:100%; text-align:center; z-index:50;}
.waterGun .swiper .numbering span {display:inline-block; width:6px; height:6px; margin:0 4px; background:#898989; border-radius:50%;}
.waterGun .swiper .numbering span.swiper-active-switch {background:#64d0d0;}
.applyGun {padding-bottom:38px; background:url(http://webimage.10x10.co.kr/playmo/ground/20150810/bg_blue.gif) 0 0 repeat-y; background-size:100% auto;}
.applyGun ul {overflow:hidden; padding:0 7.5% 10px;}
.applyGun li {float:left; width:50%; padding:0 0 20px;}
.applyGun li div {position:relative; padding:0 2.5%;}
.applyGun li input {position:absolute; left:50%; top:87%; width:13px; height:13px; margin-left:-7px; border-radius:50%; border:0; background:transparent;}
.applyGun li input:checked {background:none;}
.applyGun li input:checked:after {content:' '; display:inline-block; position:absolute; left:1px; top:1px; width:8px; height:8px; background:#d60000; border-radius:50%;}
.applyGun li .count {padding-top:6px; text-align:center; color:#fff; font-size:14px; line-height:1.2;}
.applyGun li .count strong {font-size:16px;}
.applyGun li .count span {display:block;}
.applyGun .btnApply {display:block; width:54%; margin:0 auto;}
.fullSwipe .swiper2 .numbering2 {position:absolute; left:0; bottom:5%; width:100%; text-align:center;}
.fullSwipe .swiper2 .numbering2 span {display:inline-block; width:12px; height:12px; margin:0 2px; background:url(http://webimage.10x10.co.kr/playmo/ground/20150810/btn_pagination_off.png) 0 0 no-repeat; background-size:100% 100%;}
.fullSwipe .swiper2 .numbering2 span.swiper-active-switch {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150810/btn_pagination_on.png);}
.fullSwipe .swiper2 button {position:absolute; bottom:5.5%; width:12px; z-index:30; background:transparent;}
.fullSwipe .swiper2 .prev {left:35%;}
.fullSwipe .swiper2 .next {right:35%;}
@media all and (min-width:480px){
	.waterGun .swiper .numbering span {width:9px; height:9px; margin:0 6px;}
	.applyGun ul {padding:0 7.5% 15px;}
	.applyGun li {padding:0 0 30px;}
	.applyGun li .count {padding-top:6px; font-size:21px;}
	.applyGun li .count strong {font-size:24px;}
	.applyGun li input {top:87.5%; width:20px; height:20px; margin-left:-10px;}
	.applyGun li input:checked:after {left:1px; top:1px; width:13px; height:13px;}
	.fullSwipe .swiper2 .numbering2 span {width:18px; height:18px; margin:0 3px;}
	.fullSwipe .swiper2 button {bottom:5%; width:18px;}
}
</style>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery.slides.min.js"></script>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.numbering',
		speed:600,
		autoplay:false,
		autoplayDisableOnInteraction: true
	});
	mySwiper2= new Swiper('.swiper2',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.numbering2',
		paginationClickable:true,
		speed:180,
		nextButton: '.next',
		prevButton: '.prev'
	});
	$('.prev').on('click', function(e){
		e.preventDefault()
		mySwiper2.swipePrev()
	});
	$('.next').on('click', function(e){
		e.preventDefault()
		mySwiper2.swipeNext()
	});

	$(".purpose a").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 800);
	});

	<% if vga="1" then %>
		window.parent.$('html,body').animate({scrollTop:$('#applyGunWrap').offset().top}, 10);
	<% end if %>
});
</script>
<script type="text/javascript">
<!--

	function jsSubmit(){
		<% if Not(IsUserLoginOK) then %>
			<% If isApp="1" or isApp="2" Then %>
			parent.calllogin();
			return false;
			<% else %>
			parent.jsevtlogin();
			return;
			<% end if %>			
		<% end if %>
		if($(':radio[name="votet"]:checked').length < 1){
			alert('날려버리고 싶은 스트레스를 골라 주세요!');
			return false;
		}
	   document.frmcom.votetour.value = $(':radio[name="votet"]:checked').val();
	   document.frmcom.submit();

	}
//-->
</script>
</head>
<body>

<div class="mPlay20150810">
	<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/tit_bangbang_gun.jpg" alt="BANG BANG GUN" /></h2>
	<div class="purpose">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/txt_purpose.gif" alt="더위와 함께 쌓인 스트레스를 한방에 날려버릴 시원한 일상 탈출 프로젝트. 무더운 여름 나를 더욱 덥게 만드는 스트레스가 있으시다면, 뱅뱅건으로 시원하게 쏴서 날려버리세요!!" /></p>
		<a href="#applyGunWrap">SHOOT! 뱅뱅건 쏘러 가기!</a>
	</div>
	<div class="waterGun">
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/tit_water_gun.png" alt="BANG BANG WATER GUN" /></h3>
		<div class="swiperWrap">
			<div class="swiper-container swiper">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/img_slide_type01.jpg" alt="취업건" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/img_slide_type02.jpg" alt="직장건" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/img_slide_type03.jpg" alt="알바건" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/img_slide_type04.jpg" alt="연애건" /></div>
				</div>
				<div class="numbering"></div>
			</div>
		</div>
		<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/img_composition.png" alt="뱅뱅건의 세트 구성" /></div>
	</div>
	<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/txt_target.jpg" alt="훈련을 위한 표적지" /></div>
	<!-- 이벤트 응모 -->
	<div id="applyGunWrap">
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/tit_apply_bangbang.jpg" alt="BANG BANG GUN - 날려버리고 싶은 스트레스를 골라 뱅뱅건을 신청해주세요! 추첨을 통해 각각 10분에게 선택하신 뱅뱅건 SET를 드립니다!" /></h3>
		<div class="applyGun">
			<ul>
				<li>
					<div>
						<label for="gun01"><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/txt_select01.png" alt="취업건" /></label>
						<input type="radio" id="gun01" name="votet" value="incruit" />
					</div>
					<p class="count"><strong><%=FormatNumber(incruitCnt, 0)%></strong>명이<span>조준 중입니다.</span></p>
				</li>
				<li>
					<div>
						<label for="gun02"><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/txt_select02.png" alt="직장건" /></label>
						<input type="radio" id="gun02" name="votet" value="job" />
					</div>
					<p class="count"><strong><%=FormatNumber(jobCnt, 0)%></strong>명이<span>조준 중입니다.</span></p>
				</li>
				<li>
					<div>
						<label for="gun03"><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/txt_select03.png" alt="알바건" /></label>
						<input type="radio" id="gun03" name="votet" value="alba"  />
					</div>
					<p class="count"><strong><%=FormatNumber(albaCnt, 0)%></strong>명이<span>조준 중입니다.</span></p>
				</li>
				<li>
					<div>
						<label for="gun04"><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/txt_select04.png" alt="연애건" /></label>
						<input type="radio" id="gun04" name="votet" value="love"  />
					</div>
					<p class="count"><strong><%=FormatNumber(loveCnt, 0)%></strong>명이<span>조준 중입니다.</span></p>
				</li>
			</ul>
			<p><input type="image" class="btnApply" src="http://webimage.10x10.co.kr/play/ground/20150810/btn_apply.gif" alt="뱅뱅건 신청하기" onclick="jsSubmit();return false;" /></p>
		</div>
	</div>
	<form name="frmcom" method="post" action="/play/groundcnt/doEventSubscript65349.asp" style="margin:0px;">
		<input type="hidden" name="votetour">
	</form>
	<!--// 이벤트 응모 -->
	<div class="fullSwipe">
		<div class="swiper-container swiper2">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/img_slide_full01.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/img_slide_full02.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/img_slide_full03.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/img_slide_full04.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/img_slide_full05.jpg" alt="" /></div>
			</div>
			<div class="numbering2"></div>
			<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/btn_prev.png" alt="이전" /></button>
			<button type="button" class="next"><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/btn_next.png" alt="다음" /></button>
		</div>
	</div>
	<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150810/txt_no_stress.gif" alt="취업이건, 직장이건, 알바건, 연애건 스트레스 없이 행복하게 하시기를 바랍니다" /></p>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->