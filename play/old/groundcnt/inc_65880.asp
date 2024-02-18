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
' PLAY #23 summer 5주차 
' 2015-08-28 이종화 작성
'########################################################
Dim eCode , sqlStr , userid , totcnt , iCTotCnt
IF application("Svr_Info") = "Dev" THEN
	eCode   =  "64868"
Else
	eCode   =  "65880"
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
.swipeWrap {position:relative;}
.swiper {position:absolute; left:0; top:0; width:100%;}
.swiper .numbering {position:absolute; left:0; bottom:0; width:100%; text-align:center; z-index:50;}
.swiper .numbering span {display:inline-block; width:7px; height:7px; margin:0 3px; border-radius:50%; background:#898989;}
.swiper .numbering span.swiper-active-switch {background:#52c5c6;}
.applyTv .sky {position:relative;}
.applyTv .floatingStar {position:absolute; left:0; top:0; width:100%; height:100%; background-repeat:no-repeat; background-position:0 0; background-size:100% auto;}
.applyTv .floatingStar.star01 {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150831/bg_star01.png);}
.applyTv .floatingStar.star02 {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150831/bg_star02.png);}
.applyTv .floatingStar.star03 {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150831/bg_star03.png);}
.applyTv .floatingStar.star04 {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150831/bg_star04.png);}
.applyTv .floatingStar.star05 {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150831/bg_star05.png);}
.myStar {position:relative;}
.myStar .count {position:absolute; left:0; top:16%; width:100%; text-align:center; color:#fff; font-size:13px; font-weight:bold;}
.myStar .count strong {display:inline-block; position:relative; top:1px; color:#94e3f8; font-size:16px; padding:0 5px 0 10px;}
@media all and (min-width:480px){
	.swiper .numbering span {width:11px; height:11px; margin:0 4px;}
	.myStar .count {font-size:20px;}
	.myStar .count strong {top:1px; font-size:24px; padding:0 7px 0 15px;}
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
	   frm.action = "/play/groundcnt/doeventsubscript65880.asp";
	   frm.submit();
	   return true;
	}

$(function(){
	mySwiper = new Swiper('.swiper',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.numbering',
		speed:600,
		autoplay:3500,
		autoplayDisableOnInteraction: true
	});

	$(".goApply").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 800);
	});
});
//-->
</script>
<div class="mPlay20150831">
	<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150831/tit_rooftop_tv.gif" alt="옥상티비" /></h2>
	<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150831/txt_purpose01.gif" alt="한 여름 밤을 다시 한 번 기억하며 - 옥상에 대한 로망이 있으신가요? 가장 높이, 넓은 공간을 품고 있는 멋진 곳 눈앞으로는 동네를 한가득, 하늘 위로는 쏟아지는 별을 가득 느낄 수 있습니다." /></p>
	<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150831/txt_purpose02.gif" alt="어느덧 여름이 지나고, 기분 좋은 시원한 바람이 불어옵니다. 한 여름밤을 다시 한번 기억하며 평범할 수 있지만, 특별한 공간에서의 특별한 시간 옥상티비 텐바이텐 DAY에 여러분을 초대합니다. 당신의 소중한 사람들과 함께 도심 속 옥상으로 놀러 오세요." /></p>
	<a href="#applyTv" class="goApply"><img src="http://webimage.10x10.co.kr/playmo/ground/20150831/btn_go_apply.gif" alt="옥상티비 신청하러 가기" /></a>
	<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150831/txt_tv_view.gif" alt="탁 트인 도심 속 옥상에서 시원한 밤 공기와 함께 영화를 관람할 수 있는 마이크임팩트 옥상티비" /></p>
	<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150831/txt_notice.gif" alt="옥상티비 텐바이텐 DAY안내" /></p>
	<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150831/img_benefit.jpg" alt="스페셜기프트, 문라이즈킹덤 감상, 맥주와 간식" /></div>
	<div class="swipeWrap">
		<div class="swiper-container swiper">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150831/txt_brand_info01.png" alt="ABOUT MICINPACT SQUARE" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150831/txt_brand_info02.png" alt="원더우먼 페스티벌" /></div>
			</div>
			<div class="numbering"></div>
		</div>
		<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150831/bg_swipe.gif" alt="" /></div>
	</div>
	<form name="frmcom" method="post" style="margin:0px;">
	<div class="applyTv" id="applyTv">
		<div class="sky">
			<div class="floatingStar star0<%=totcnt%>"></div>
			<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150831/bg_sky.gif" alt="하늘 배경" /></div>
		</div>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150831/txt_invite.gif" alt="한여름밤을 다시 한번 추억 할 옥상티비 텐바이텐 DAY에 초대합니다." /></p>
		<a href="" onclick="jsSubmitComment();return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150831/btn_apply.gif" alt="옥상티비 응모하기" /></a>
		<div class="myStar">
			<p class="count">총 <strong><%=iCTotCnt%></strong>개의 별이 떴습니다.</p>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150831/txt_invite02.gif" alt="옥상티비 응모하기" /></p>
		</div>
	</div>
	</form>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->