<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'###########################################################
' Description : play sub
' History : 2014.06.10 이종화
'###########################################################

	dim eCode, cnt, sqlStr, regdate , totalsum
	Dim totcnt1 , totcnt2  , totcnt3

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21199
	Else
		eCode   =  52550
	End If

	If IsUserLoginOK Then
		'하루 1회 중복 응모 확인
		sqlStr="Select count(sub_idx) " &_
				" From db_event.dbo.tbl_event_subscript " &_
				" WHERE evt_code='" & eCode & "'" &_
				" and userid='" & GetLoginUserID() & "' and convert(varchar(10),regdate,120) = '" &  Left(now(),10) & "'"
		rsget.Open sqlStr,dbget,1
		cnt=rsget(0)
		rsget.Close

		'토탈 5회 중복 응모 확인
		sqlStr="Select count(sub_idx) " &_
				" From db_event.dbo.tbl_event_subscript " &_
				" WHERE evt_code='" & eCode & "'" &_
				" and userid='" & GetLoginUserID() & "'"
		rsget.Open sqlStr,dbget,1
		totalsum=rsget(0)
		rsget.Close

	End If

	sqlStr="Select count(case when sub_opt2 = 1 then sub_opt2 end) as totcnt1 " &_
			" , count(case when sub_opt2 = 2 then sub_opt2 end) as totcnt2 " &_
			" , count(case when sub_opt2 = 3 then sub_opt2 end) as totcnt3 " &_
			" From db_event.dbo.tbl_event_subscript " &_
			" WHERE evt_code='" & eCode & "'"

	rsget.Open sqlStr,dbget,1
		totcnt1 = rsget("totcnt1")
		totcnt2 = rsget("totcnt2")
		totcnt3 = rsget("totcnt3")
	rsget.Close
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > [텐바이텐x직방 제휴 프로모션] 내가 꿈꾸던 로망이 있는 집</title>
<style type="text/css">
.mEvt52548 {}
.mEvt52548 img {vertical-align:top; width:100%;}
.mEvt52548 p {max-width:100%;}
.mEvt52548 .evtInfo {position:relative;}
.mEvt52548 .evtInfo .goApply {display:block; position:absolute; left:26%; bottom:11%;  width:48%; cursor:pointer;}
.mEvt52548 .swiperWrap {height:357px;}
.mEvt52548 .swiperWrap .frame {border:1px solid #d2d2d2; padding:4px; width:447px; height:272px; overflow:visible; margin:0 auto;}
.mEvt52548 .swiper {position:relative; width:447px; height:357px;}
.mEvt52548 .swiper .swiper-container {overflow:hidden; height:357px;}
.mEvt52548 .swiper .swiper-slide {float:left;}
.mEvt52548 .swiper .swiper-slide a {display:block; width:100%;}
.mEvt52548 .swiper .swiper-slide img {width:100%; vertical-align:top;}
.mEvt52548 .swiper .btnArrow {display:block; position:absolute; top:105px; z-index:10; width:45px; height:57px; text-indent:-9999px; background-repeat:no-repeat; background-position:left top; background-size:100% 100%;}
.mEvt52548 .swiper .arrow-left {left:0; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52548/btn_prev.png);}
.mEvt52548 .swiper .arrow-right {right:0; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52548/btn_next.png);}
.mEvt52548 .swiper .pagination {position:absolute; left:0; bottom:38px; width:100%; text-align:center; z-index:100;}
.mEvt52548 .swiper .pagination span {position:relative; display:inline-block; width:18px; height:17px; margin:0 10px; cursor:pointer; background-repeat:no-repeat; background-position:left top; background-size:100% 200%;}
.mEvt52548 .swiper .pagination .swiper-active-switch {background-position:left -17px;}
.mEvt52548 .swiper .pagination span.n01 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52548/txt_num01.png);}
.mEvt52548 .swiper .pagination span.n02 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52548/txt_num02.png);}
.mEvt52548 .swiper .pagination span.n03 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52548/txt_num03.png);}
.mEvt52548 .swiper .pagination span.n04 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52548/txt_num04.png);}
.mEvt52548 .swiper .pagination span.n05 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52548/txt_num05.png);}
.mEvt52548 .heroSection {padding-bottom:38px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52548/bg_grid.png) left top repeat; background-size:6px 6px;}
.mEvt52548 .heroSection legend {overflow:hidden; visibility:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}
.mEvt52548 .heroSection input {vertical-align:top;}
.mEvt52548 .heroSection .group ul {overflow:hidden; padding:0 4%;}
.mEvt52548 .heroSection .group ul li {float:left; width:33.33333%; padding:0 3%; box-sizing:border-box; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; text-align:center;}
.mEvt52548 .heroSection .group ul li label {display:block; margin-bottom:10px; }
.mEvt52548 .heroSection .group ul li p {padding-bottom:8px; color:#777; font-size:11px; line-height:16px; font-weight:bold; white-space:nowrap;}
.mEvt52548 .heroSection .group ul li p strong {font-size:13px;}
.mEvt52548 .heroSection .group ul li.hulk p strong {color:#00a940;}
.mEvt52548 .heroSection .group ul li.thor p strong {color:#3ca2d6;}
.mEvt52548 .heroSection .group ul li.ironman p strong {color:#da5059;}
.mEvt52548 .heroSection .group .btnSubmit {width:44%; margin:22px auto 0;}
.mEvt52548 .heroSection .group .btnSubmit input {display:block; width:100%;}
@media all and (max-width:480px){
	.mEvt52548 .swiperWrap {height:238px;}
	.mEvt52548 .swiperWrap .frame {width:296px; height:180px;}
	.mEvt52548 .swiper {width:296px; height:238px;}
	.mEvt52548 .swiper .swiper-container {height:238px;}
	.mEvt52548 .swiper .btnArrow {top:75px; width:30px; height:30px;}
	.mEvt52548 .swiper .pagination {bottom:25px}
	.mEvt52548 .swiper .pagination span {width:14px; height:13px;}
	.mEvt52548 .swiper .pagination .swiper-active-switch {background-position:left -13px;}
}
</style>
<script src="/lib/js/swiper-1.8.min.js"></script>
<script type="text/javascript">
$(function(){
	var mySwiper = new Swiper('.swiper-container',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.pagination',
		paginationClickable:true,
		speed:180
	})
	$('.swiper .arrow-left').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.swiper .arrow-right').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
	var oTm = setInterval(function () {
		mySwiper.reInit();
			clearInterval(oTm);
		}, 1);
	});

	$(".mEvt52548 .swiper .pagination span:eq(0)").addClass("n01");
	$(".mEvt52548 .swiper .pagination span:eq(1)").addClass("n02");
	$(".mEvt52548 .swiper .pagination span:eq(2)").addClass("n03");
	$(".mEvt52548 .swiper .pagination span:eq(3)").addClass("n04");
	$(".mEvt52548 .swiper .pagination span:eq(4)").addClass("n05");

	$(".goApply").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 500);
	});
});
</script>
<script type="text/javascript">
<!--
	function checkform(frm) {
	<% if datediff("d",date(),"2014-06-30")>=0 then %>
		<% If IsUserLoginOK Then %>
			<% If cnt > 0 Then %>
					alert('하루에 1회 응모 가능 합니다.');
					return false;
			<% else %>
				<% If totalsum = 5 Then %>
					alert('최대 5회 응모 가능합니다.');
					return false;
				<% else %>
					if(!(frm.spoint[0].checked||frm.spoint[1].checked||frm.spoint[2].checked))
					{
						alert("히어로수를 골라주세요!");
						return false;
					}

					frm.action = "doEventSubscript52548.asp";
					return true;
				<% end if %>
			<% end if %>
		<% Else %>
   			parent.jsevtlogin();;
		<% End If %>
	<% else %>
			alert('이벤트가 종료되었습니다.');
			return;
	<% end if %>
	}	
//-->
</script>
</head>
<body>
<div class="mEvt52548">
	<div class="hero">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/52548/tit_hero_water.png" alt="최강의 슈퍼 히어로수(水)가 모였다!" /></h2>
		<div class="evtInfo">
			<a href="#selectHero" class="goApply"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52548/btn_go_apply.png" alt="응모하러 가기" /></a>
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/52548/img_evt_info.png" alt="최강의 슈퍼 히어로수(水)가 모였다!" />
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52548/img_cartoon.png" alt="" /></p>
		<div class="swiperWrap">
			<div class="frame">
				<div class="swiper">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52548/img_slide01.png" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52548/img_slide02.png" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52548/img_slide03.png" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52548/img_slide04.png" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52548/img_slide05.png" alt="" /></div>
						</div>
						<div class="pagination"></div>
					</div>
					<a class="btnArrow arrow-left" href="">Previous</a>
					<a class="btnArrow arrow-right" href="">Next</a>
				</div>
			</div>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52548/img_water_info.png" alt="" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52548/img_kit.png" alt="HERO 水 KIT 구성 안내 " /></p>
		<!-- 응모하기 -->
		<div class="heroSection" id="selectHero">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/52548/tit_help_hero.png" alt="도와줘요~ 히어로 水!" /></h3>
			<div class="group">
				<form name="frm" method="POST" style="margin:0px;" onSubmit="return checkform(this);">
					<fieldset>
					<legend>나에게 필요한 영웅 선택하기</legend>
						<ul>
							<li class="hulk">
								<label for="hero01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52548/ico_hero_01.png" alt="도와줘요~ 헐쿠" /></label>
								<p><strong><%=totcnt1%>명</strong>이 <br />도움을 요청합니다!</p>
								<input type="radio" id="hero01" name="spoint" value="1" />
							</li>
							<li class="thor">
								<label for="hero02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52548/ico_hero_02.png" alt="도와줘요~ 쏘르" /></label>
								<p><strong><%=totcnt2%>명</strong>이 <br />도움을 요청합니다!</p>
								<input type="radio" id="hero02" name="spoint" value="2" />
							</li>
							<li class="ironman">
								<label for="hero03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52548/ico_hero_03.png" alt="도와줘요~ 아니언 맨" /></label>
								<p><strong><%=totcnt3%>명</strong>이 <br />도움을 요청합니다!</p>
								<input type="radio" id="hero03" name="spoint" value="3" />
							</li>
						</ul>
						<div class="btnSubmit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/52548/btn_submit.png" alt="응모하기" /></div>
					</fieldset>
				</form>
			</div>
		</div>
		<!-- //응모하기 -->
	</div>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->