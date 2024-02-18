<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg, vIsEnd, vQuery, vState, vNowTime, vCouponMaxCount
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[텐바이텐] 16주년 텐쇼")
snpLink		= Server.URLEncode("http://www.10x10.co.kr/event/16th/together.asp")
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/eventIMG/2017/16th/m/kakao_tenshow_sub1.jpg")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "50만원 쇼핑지원금으로 신나게 쇼핑을 즐겨 줄 서포터즈를 찾습니다!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2017/16th/m/kakao_tenshow_sub1.jpg"
Dim kakaoimg_width : kakaoimg_width = "400"
Dim kakaoimg_height : kakaoimg_height = "400"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/16th/together.asp"
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/16th/together.asp"
End If
%>
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<style type="text/css">
/* common */
.ten-show .noti {margin-top:4.5rem; padding:2.3rem; background-color:#6a6a6a; color:#cecece;}
.ten-show .noti h3 {position:relative; padding-left:2.39rem; margin-bottom:.94rem; color:#fff;font-size:1.37rem;}
.ten-show .noti h3:before {display:inline-block; content:' '; position:absolute; top:50%; left:0;width:1.62rem; height:1.62rem; margin-top:-.81rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/16th/m/img_noti.png) no-repeat 0 0;background-size:100%;}
.ten-show .noti ul li {font-size:1.1rem; line-height:1.79rem; text-indent:-0.7rem; padding-left:0.7rem;}
.ten-show .share {position:relative;}
.ten-show .share .btn-group {position:absolute; bottom:2.39rem; left:50%; margin-left:-9.2rem;}
.ten-show .share .btn-group a {display:inline-block; width:3.75rem; margin:0 .85rem;}
.ten-show .ten-show-bnr li{margin-top:.6rem;}

/* together */
.show-together {background-color:#fff;}
.show-together .topic {position:relative;}
.show-together .topic h2 span {position:absolute;}
.show-together .topic h2 .t1 {left:0; top:0; width:100%;}
.show-together .topic h2 .t2 {right:7.3%; top:12.6%; width:24.8%; animation:bounce1 .5s 1s 2;}
.show-together .topic .deco {position:absolute; left:0; top:0; width:100%;}
@keyframes bounce1 {
	from to{transform:translateY(0);}
	50%{transform:translateY(8px)}
}
</style>
<script type="text/javascript">
$(function(){
	titleAnimation();
	$(".topic h2 span").css({"opacity":"0"});
	$(".topic h2 .t1").css({"margin-top":"-20px"});
	$(".topic .deco").css({"opacity":"0","margin-top":"-10px"});
	function titleAnimation() {
		$(".topic .deco").delay(90).animate({"opacity":"1","margin-top":"0"},1200);
		$(".topic h2 .t1").delay(10).animate({"margin-top":"10px", "opacity":"1"},600).animate({"margin-top":"0"},300);
		$(".topic h2 .t2").delay(800).animate({"opacity":"1"},600);
	}
});

function snschk(snsnum) {
	if(snsnum=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
	}else if(snsnum=="pt"){
		pinit('<%=snpLink%>','<%=snpImg%>')
	}else if(snsnum=="ka"){
		parent_kakaolink('<%=kakaotitle%>', '<%=kakaoimage%>' , '<%=kakaoimg_width%>' , '<%=kakaoimg_height%>' , '<%=kakaolink_url%>' );
		return false;
	}
}

// add log
function fnWriteLog() {
	$.ajax({
		type: "get",
		url: "/common/addlog.js",
		data: "tp=together&ror="+encodeURIComponent("http://www.10x10.co.kr/event/16th/together")
	});
}
</script>
<!-- 16주년 이벤트 : 함께하쑈! -->
<div class="ten-show show-together">
	<div class="topic">
		<h2>
			<span class="t1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80411/m/tit_together_1.png" alt="함께하쑈!" /></span>
			<span class="t2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80411/m/tit_together_2.png" alt="텐텐쇼퍼!" /></span>
		</h2>
		<div class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80411/m/bg_deco.png" alt="" /></div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80411/m/txt_subcopy.png" alt="모두가 함께하는 쇼핑쑈! 텐바이텐의 텐텐쑈퍼를 모집합니다" /></p>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80411/m/txt_shopper.png" alt="쇼핑지원금으로 신나게 쇼핑을 한 후 솔직한 쇼핑 후기를 남기는 텐바이텐 공식 SHOPPER!" /></p>

	<!-- 텐텐쇼퍼 지원안내 -->
	<div class="section section1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80411/m/txt_benefit_v3.png" alt="활동 혜택" /></div>
	<div class="section section2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80411/m/txt_process.png" alt="신청 절차" /></div>
	<div class="section section3">
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80411/m/txt_date.png" alt="모집 요강" /></div>
		<a href="http://bit.ly/tentenshopper"  onclick="fnWriteLog();" target="_blank" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80411/m/btn_submit.png" alt="신청서 작성하기" /></a>
		<a href="#" onclick="fnAPPpopupExternalBrowser('http://bit.ly/tentenshopper'); fnWriteLog(); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80411/m/btn_submit.png" alt="신청서 작성하기" /></a>
	</div>

	<!-- 유의사항 -->
	<div class="noti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>- 본 이벤트의 일정 및 세부 내용은 당사의 사정에 따라 예고 없이 변동될 수 있습니다.</li>
			<li>- 지원서 양식에 입력하신 정보는 텐바이텐 텐텐쑈퍼<br />운영/관리를 위해서만 활용되며, 활동 기간이 끝나면 폐기됩니다.</li>
			<li>- 텐텐쑈퍼 활동 시 블로그 및 인스타그램에 올려주신 내용은 텐바이텐에 귀속되며, 홍보를 위한 자료로 활용될 수 있습니다.</li>
		</ul>
	</div>

	<!-- 공유하기 -->
	<div class="share">
		<div class="inner">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/tit_share.png" alt="1년에 한번 있는 텐바이텐 쑈! 친구와 함께하쑈~!" /></p>
			<div class="btn-group">
				<a href="#" onclick="snschk('fb'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/btn_fb_v2.png" alt="페이스북으로 텐쑈 공유하기" /></a>
				<a href="#" onclick="snschk('ka'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/btn_kakao.png" alt="카카오톡으로 텐쑈 공유하기" /></a>
				<a href="#" onclick="snschk('pt'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/btn_pinterest.png" alt="핀터레스트로 텐쑈 공유하기" /></a>
			</div>
		</div>
	</div>
</div>
<ul>
	<li>
		<a href="/event/16th/pickshow.asp" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/bnr_pickshow.jpg" alt="뽑아주쑈" /></a>
		<a href="#" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/event/16th/pickshow.asp');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/bnr_pickshow.jpg" alt="뽑아주쑈" /></a>
	</li>
	<li>
		<a href="/event/16th/" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/bnr_main.jpg" alt="텐쑈 메인" /></a>
		<a href="#" onclick="fnAPPpopupBrowserURL('이벤트','http://m.10x10.co.kr/apps/appcom/wish/web2014/event/16th/'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/bnr_main.jpg" alt="텐쑈 메인" /></a>
	</li>
</ul>
<!--// 16주년 이벤트 : 함께하쑈! -->
<!-- #include virtual="/lib/db/dbclose.asp" -->