<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'########################################################
' PLAY #24 CAMERA _ MY STUDIO
' 2015-09-04 원승현 작성
'########################################################
Dim eCode , sqlStr , userid , totcnt , iCTotCnt
IF application("Svr_Info") = "Dev" THEN
	eCode   =  "64878"
Else
	eCode   =  "66035"
End If

userid = GetEncLoginUserID

If GetEncLoginUserID <> "" then
	sqlStr = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& userid &"' and evt_code = '"& ecode &"' " 
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly 

	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End IF
	rsget.close()
End If 

	sqlStr = "select count(*) from db_event.dbo.tbl_event_subscript where evt_code = '"& ecode &"' " 
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly 

	IF Not rsget.Eof Then
		iCTotCnt = rsget(0)
	End IF
	rsget.close()
%>
<style type="text/css">
img {vertical-align:top;}
.mPlay20150907 {background-color:#fff;}
.mPlay20150907 button {background-color:transparent;}
.mPlay20150907 #app, .mPlay20150907 .app {display:none;}

.mPlay20150907 .topic {padding-bottom:15%;}
.mPlay20150907 .topic .btngo {width:57.18%; margin:0 auto;}

.prepare .open {position:relative;}
.prepare .open .btnOpen {position:absolute; top:23%; left:50%; z-index:10; width:29%; margin-left:-14.5%;}
.prepare .open .after {position:absolute; top:0; left:0; width:100%; height:0; transition:opacity 0.5s ease-out; opacity:0; filter: alpha(opacity=0);}
.prepare .after.show {opacity:1; filter: alpha(opacity=100); height:100%;}

.howtoMake .make {position:relative;}
.howtoMake .btnmore {position:absolute; top:0; left:0; width:100%; height:100%;}
.howtoMake .btnmore a {display:block; width:100%; height:100%; color:transparent;}

/* swiper */
.swiper {overflow:hidden; position:relative;}
.swiper .swiper-container {width:100%;}
/*.swiper .swiper-wrapper {overflow:hidden;} */
.swiper .pagination {display:none;}
.swiper button {position:absolute; top:42%; z-index:150; width:4%; background:transparent; vertical-align:top;}
.swiper .prev {left:3%}
.swiper .next {right:3%;}

.mystudioEvt {padding-bottom:10%; background-color:#404452;}
.mystudioEvt .desc {position:relative;}
.mystudioEvt .hidden {visibility:hidden; width:0; height:0;}
.mystudioEvt .btnTake {position:absolute; bottom:10%; right:6%; width:29.53%;}
.mystudioEvt .name {position:relative;}
.mystudioEvt .name strong {overflow:hidden; display:block; position:absolute; top:48%; right:18%; width:38.75%; height:0; padding-bottom:10.25%; color:#556aed; font-size:14px; line-height:2.8em; text-align:center;}
.mystudioEvt .name strong span {position:absolute; top:0; left:0; width:100%; height:100%;}
.mystudioEvt .count {color:#fff; font-size:12px; text-align:center;}
.mystudioEvt .count strong {border-bottom:1px solid #b7f9ff; color:#b7f9ff;}

.brand {position:relative;}
.brand .btnBrand {position:absolute; top:0; left:0; width:100%; height:100%;}
.brand .btnBrand a {display:block; width:100%; height:100%; color:transparent;}

@media all and (min-width:480px){
	.mystudioEvt .name strong {font-size:20px;}
	.mystudioEvt .count {font-size:18px;}
}

@media all and (min-width:480px){
	.mystudioEvt .name strong {font-size:24px;}
}
</style>
<script type="text/javascript">
<!--
 	function jsSubmitComment(){
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
	   frm.action = "/play/groundcnt/doeventsubscript66035.asp";
	   frm.submit();
	   return true;
	}

$(function(){
	$("#btngo a").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},1500);
	});

	$(".btnOpen").click(function(){
		$(".prepare .after").addClass("show");
		$(".btnOpen").fadeOut();
	});

	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:3000,
		speed:800,
		pagination:".pagination",
		paginationClickable:true,
		autoplayDisableOnInteraction:false,
		nextButton:'.next',
		prevButton:'.prev',
	});
	$('.prev').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.next').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$("#app, .app").show();
			$("#mo, .mo").hide();
	}else{
			$("#app, .app").hide();
			$("#mo .mo").show();
	}
});
//-->
</script>
<div class="mPlay20150907">
	<div class="topic">
		<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/tit_my_studio.jpg" alt="MY STUDIO" /></h2>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/txt_plan.png" alt="카메라가 핸드폰으로 들어오게 되면서, 우리는 많은 순간을 편리하게 촬영할 수 있게 되었습니다. 누구나 사진 작가가 되어 본인만의 느낌으로 촬영하는 사진들. 하지만 가끔 지저분한 배경이나, 어두운 환경때문에 마음에 들지 않는 결과물을 볼 때도 있죠. 그래서 텐바이텐 플레이에서는 여러분을 포토그래퍼로 만들어 드리기로 했습니다. 핸드폰 카메라 뿐만 아니라 모든 카메라를 들고 이제 여러분의 스튜디오에서 깔끔하고 선명한 촬영을 해보세요! 여러분의 카메라 사용이 더욱 즐겁고 만족스러워지기를 바랍니다" /></p>
		<div id="btngo" class="btngo"><a href="#mystudioEvt"><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/btn_go.gif" alt="MY STUDIO 신청하기" /></a></div>
	</div>

	<div class="howtoTake">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/txt_how_to_take_01.jpg" alt="텐바이텐의 이런 깔끔한 사진! 어떻게 촬영했을까?" /></p>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/txt_how_to_take_02.jpg" alt="인스타그램과 블로그에서 봤던 이런 인증 사진! 어떻게 찍어야 할까?" /></p>
	</div>

	<div class="prepare">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/txt_prepare.png" alt="그래서 준비했습니다!" /></p>
		<div class="open">
			<p class="mine"><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/txt_open.jpg" alt="나만의 스튜디오를 오픈해 보세요!" /></p>
			<button type="button" class="btnOpen"><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/btn_open.png" alt="OPEN" /></button>
			<div class="after">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/txt_your.jpg" alt="YOUR OWN PHOTO STUIO" /></p>
			</div>
		</div>
	</div>

	<div class="howtoMake">
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/tit_how_to_make.png" alt="HOW TO MAKE" /></h3>
		<div class="make" style="width:92.9%; margin:0 auto;">
			<img src="http://webimage.10x10.co.kr/playmo/ground/20150907/img_how_to_make.gif" alt="MY STUDIO 조립방법" />
			<div class="btnmore">
				<% If isApp="1" Then %>
					<a href="/category/category_itemPrd.asp?itemid=1078873" onclick="fnAPPpopupProduct('1078873'); return false;" class="app">MY STUDIO 조립방법 자세히 보기</a>
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1078873" class="mo">MY STUDIO 조립방법 자세히 보기</a>
				<% End If %>
			</div>
		</div>
		<div class="beforeAfter"><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/img_before_after.jpg" alt="MY STUDIO 사용하여 촬영 전 후" /></div>
	</div>

	<div class="package">
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/tit_package.jpg" alt="MY STUDIO PACKAGE" /></h3>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/txt_package.jpg" alt="마이 스튜디오 패키지는 휴대가능한 미니 스튜이오와 당신을 포토그래퍼로 만들어줄 명함으로 구성 되어있습니다. 패키지는 변경 가능성이 있습니다." /></p>
	</div>

	<div class="swiper">
		<div class="swiper-container swiper1">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/img_slide_01.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/img_slide_02.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/img_slide_03.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/img_slide_04.jpg" alt="" /></div>
			</div>
		</div>
		<div class="pagination"></div>
		<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/btn_prev.png" alt="이전" /></button>
		<button type="button" class="next"><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/btn_next.png" alt="다음" /></button>
	</div>

	<!-- my studio event -->
	<div id="mystudioEvt" class="mystudioEvt">
		<div class="desc">
			<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/tit_my_studio_event.png" alt="MY STUDIO EVENT" /></h3>
			<p class="hidden">당신의 스튜디오를 신청하세요! 신청하신 분들 중 추첨을 통해 6분에게 MY STUDIO PACKAGE를 보내드립니다! 이벤트 기간은 2015년 9월 7일부터 9월 20일까지며, 당첨자 발표는 2015년 9월 21일 입니다.</p>
			<button type="button" class="btnTake" onclick="jsSubmitComment();return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/btn_take.png" alt="MY STUDIO 신청하기" /></button>
		</div>

		<div class="name">
			<img src="http://webimage.10x10.co.kr/playmo/ground/20150907/img_name_card.png" alt="MY STUDIO 포토그래퍼" />
			<%' for dev msg : 아이디 노출 %>
			<% if Not(IsUserLoginOK) then %>
				<strong><span></span></strong>
			<% Else %>
				<strong><span><%=userid%></span></strong>
			<% End If %>
		</div>

		<!-- for dev msg : 응모자수 카운트 -->
		<p class="count">총 <strong><%=FormatNumber(iCTotCnt, 0)%></strong> 분의 Studio가 오픈 준비 중입니다!</p>
	</div>

	<div class="brand">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150907/btn_brand.jpg" alt="휴대용 스튜디오는 세계 최초 스마트폰용 포터블 스튜디오 Foldio 제품입니다." /></p>
		<div class="btnBrand">
			<% If isApp="1" Then %>
				<a href="" onclick="fnAPPpopupBrand('orangemonkie'); return false;">브랜드 바로가기</a>
			<% Else %>
				<a href="/street/street_brand.asp?makerid=orangemonkie" id="mo">브랜드 바로가기</a>
			<% End If %>
		</div>
	</div>
</div>
<form name="frmcom" method="post"></form>
<!-- #include virtual="/lib/db/dbclose.asp" -->