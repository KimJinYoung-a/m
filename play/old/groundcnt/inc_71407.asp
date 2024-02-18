<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAY #31-3
' History : 2016-06-17 김진영 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim eCode, userid, sqlstr, totcnt, todayCnt
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66155
Else
	eCode   =  71407
End If

userid = GetEncLoginUserID()

sqlstr = ""
sqlstr = sqlstr & " SELECT count(*) as CNT "
sqlstr = sqlstr & " FROM [db_event].[dbo].[tbl_event_subscript]"
sqlstr = sqlstr & " WHERE evt_code="& eCode &""
sqlstr = sqlstr & " and userid='"& userid &"' and datediff(day,regdate,getdate()) = 0 and sub_opt1 = 1 "
rsget.Open sqlstr, dbget, 1
If Not(rsget.bof Or rsget.Eof) Then
	todayCnt = rsget("CNT")
End If
rsget.Close

sqlstr = ""
sqlstr = sqlstr & " SELECT count(*) as CNT "
sqlstr = sqlstr & " FROM [db_event].[dbo].[tbl_event_subscript]"
sqlstr = sqlstr & " WHERE evt_code="& eCode &""
rsget.Open sqlstr, dbget, 1
If Not(rsget.bof Or rsget.Eof) Then
	totcnt = rsget("CNT")
End If
rsget.Close

Dim pagereload
	pagereload	= requestCheckVar(request("pagereload"),2)

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("물마신 횟수를 체크할 수 있는 수다타임 코스터로 수다타임을 갖자!")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/play/playGround.asp?idx=1401&contentsidx=128")
snpPre		= Server.URLEncode("텐바이텐")
snpTag		= Server.URLEncode("텐바이텐")
snpTag2		= Server.URLEncode("#10x10")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐]水多수다타임\n\n오늘 하루, 물 몇잔 마셨나요?\n\n많이 마시면 좋다는 이야기는 들었지만 실천안되는 사람들을 위해 텐바이텐 PLAY에서 준비했습니다.\n\n물마신 횟수를 체크할 수 있는\n수다타임 코스터! 그리고 컵!\n\n나만의 수다타임을 정해놓고,\n수다타임 세트를 이용해\n하루 8잔 마시고 피부 좋아지세요!\n\n이벤트 참여하기"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/playmo/ground/20160620/img_kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/play/playGround.asp?idx=1401&contentsidx=128"
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/play/playGround.asp?idx=1401&contentsidx=128"
end If

%>
<style type="text/css">
img {vertical-align:top;}

.topic {position:relative; background-color:#b0deee;}
.topic h2 {position:absolute; top:8.57%; left:50%; width:77.34%; margin-left:-38.67%;}
.topic .bg {position:absolute; top:0; left:0; width:100%; height:100%; background:#b0deee url(http://webimage.10x10.co.kr/playmo/ground/20160620/txt_water_time.jpg) no-repeat 0 0; background-size:100% 100%;}

.opacity {animation-name:opacity; animation-duration:1s; animation-fill-mode:both; animation-iteration-count:1; animation-delay:1.2s;}
.opacity {-webkit-animation-name:opacity; -webkit-animation-duration:1s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:1; -webkit-animation-delay:1.2s;}
@keyframes opacity {
	0% {opacity:0;}
	100% {opacity:1;}
}
@-webkit-keyframes opacity {
	0% {opacity:0;}
	100% {opacity:1;}
}

.rollIn {animation-name:rollIn; animation-duration:1.8s; animation-fill-mode:both; animation-iteration-count:1;}
.rollIn {-webkit-animation-name:rollIn; -webkit-animation-duration:1.8s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:1;}
@keyframes rollIn {
	0% {transform:translateX(-100%) rotate(-120deg);}
	100% {transform:translateX(0px) rotate(0deg);}
}
@-webkit-keyframes rollIn {
	0% {-webkit-transform:translateX(-100%) rotate(-120deg);}
	100% {-webkit-transform:translateX(0px) rotate(0deg);}
}

.rolling .swiper {position:relative;}
.rolling .swiper .label {position:absolute; top:0; left:50%; z-index:20; width:66.1%; margin-left:-33.05%;}
.rolling .swiper .label span {position:absolute; top:54%; left:50%; width:13.23%; margin-left:-6.615%; background:url(http://webimage.10x10.co.kr/play/ground/20160620/img_no_01.png) no-repeat 0 0; background-size:100% 100% !important;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper .swiper-slide {position:relative;}
.rolling .swiper .swiper-slide .story {position:absolute; top:70.15%; left:0; width:100%;}
.rolling .swiper button {position:absolute; top:45%; z-index:20; width:6%; background-color:transparent;}
.rolling .swiper .btn-prev {left:7%;}
.rolling .swiper .btn-next {right:7%;}
/*.rolling .swiper button {position:absolute; top:1.5%; z-index:20; width:12.5%; background-color:transparent;}
.rolling .swiper .btn-prev {left:25%;}
.rolling .swiper .btn-next {right:25%;}*/
.rolling .swiper .pagination {position:absolute; bottom:3.4%; left:0; z-index:5; width:100%; height:auto; z-index:50; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; width:6px; height:6px; margin:0 0.25rem; background-color:#dedede; cursor:pointer; transition:all 0.7s ease;}
.rolling .swiper .pagination .swiper-active-switch {width:14px; border-radius:14px; background-color:#00a2de;}

@media all and (min-width:480px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:10px; height:10px;}
	.rolling .swiper .pagination .swiper-active-switch {width:28px; border-radius:28px;}
}
@media all and (min-width:768px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:16px; height:16px; border:4px solid #fff;}
	.rolling .swiper .pagination .swiper-active-switch {width:32px; border-radius:32px;}
}

.waterTime .event {padding-bottom:10%; background-color:#f7f7f7;}
.waterTime .event .btnEnter,
.waterTime .event .done {display:block; width:70.3125%; margin:0 auto;}
.waterTime .event .count {margin-top:5%; color:#777; font-size:1.2rem; text-align:center;}
.waterTime .event .count b {margin-right:0.5rem; color:#94c24b; font-size:2rem; font-style:italic;}

.sns {position:relative;}
.sns ul li {position:absolute; top:21.17%; width:14.6875%;}
.sns ul li.facebook {right:29.375%;}
.sns ul li.kakao {right:9.375%;}
.sns ul li a:focus img,
.sns ul li a:hover img {animation-name:pulse; animation-duration:1s; -webkit-animation-name:pulse; -webkit-animation-duration:1s;}
@keyframes pulse {
	0% {transform:scale(1);}
	50% {transform:scale(1.1);}
	100% {transform:scale(1);}
}
@-webkit-keyframes pulse {
	0% {-webkit-transform:scale(1);}
	50% {-webkit-transform:scale(1.1);}
	100% {-webkit-transform:scale(1);}
}
</style>
<script type="text/javascript">
function vote_play(){
	var frm = document.frm;
	<% If Not(IsUserLoginOK) Then %>
		<% If isApp Then %>
			calllogin();
			return false;
		<% Else %>
			jsevtlogin();
			return false;
		<% End If %>
	<% End If %>

	<% If not(left(now(),10)>="2016-06-17" and left(now(),10)<"2016-06-27" ) Then %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% Else %>
		<% If todayCnt > 0 Then %>
			alert("하루에 한 번만 응모가 가능 합니다.");
			return;
		<% Else %>
			frm.action = "/play/groundcnt/doEventSubscript71407.asp";
			frm.target="frmproc";
			frm.submit();
			return;
		<% End If %>
	<% End If %>
}

$(function(){
	mySwiper = new Swiper('#rolling .swiper',{
		loop:true,
		autoplay:false,
		speed:800,
		pagination:"#rolling .pagination",
		paginationClickable:true,
		nextButton:'#rolling .btn-next',
		prevButton:'#rolling .btn-prev',
		onSlideChangeStart: function (mySwiper) {
			if ($(".swiper-slide-active").is(".swiper-slide-01")) {
				$(".rolling .swiper .label span").css("background","url(http://webimage.10x10.co.kr/play/ground/20160620/img_no_01.png) no-repeat 0 0");
			}
			if ($(".swiper-slide-active").is(".swiper-slide-02")) {
				$(".rolling .swiper .label span").css("background","url(http://webimage.10x10.co.kr/play/ground/20160620/img_no_02.gif) no-repeat 0 0");
			}
			if ($(".swiper-slide-active").is(".swiper-slide-03")) {
				$(".rolling .swiper .label span").css("background","url(http://webimage.10x10.co.kr/play/ground/20160620/img_no_03.gif) no-repeat 0 0");
			}
			if ($(".swiper-slide-active").is(".swiper-slide-04")) {
				$(".rolling .swiper .label span").css("background","url(http://webimage.10x10.co.kr/play/ground/20160620/img_no_04.gif) no-repeat 0 0");
			}
			if ($(".swiper-slide-active").is(".swiper-slide-05")) {
				$(".rolling .swiper .label span").css("background","url(http://webimage.10x10.co.kr/play/ground/20160620/img_no_05.gif) no-repeat 0 0");
			}
			if ($(".swiper-slide-active").is(".swiper-slide-06")) {
				$(".rolling .swiper .label span").css("background","url(http://webimage.10x10.co.kr/play/ground/20160620/img_no_06.gif) no-repeat 0 0");
			}
			if ($(".swiper-slide-active").is(".swiper-slide-07")) {
				$(".rolling .swiper .label span").css("background","url(http://webimage.10x10.co.kr/play/ground/20160620/img_no_07.gif) no-repeat 0 0");
			}
			if ($(".swiper-slide-active").is(".swiper-slide-08")) {
				$(".rolling .swiper .label span").css("background","url(http://webimage.10x10.co.kr/play/ground/20160620/img_no_08.gif) no-repeat 0 0");
			}

			$(".swiper-slide").find(".story").delay(100).animate({"margin-top":"3%", "opacity":"0"},300);
			$(".swiper-slide-active").find(".story").delay(50).animate({"margin-top":"0", "opacity":"1"},600);
		}
	});
});
</script>
<div class="mPlay20160620 waterTime">
	<form name="frm" method="post">
	<input type="hidden" name="mode" value="add"/>
	<input type="hidden" name="pagereload" value="ON"/>
	</form>
	<article>
		<div class="topic">
			<div class="bg opacity"></div>
			<h2 class="rollIn"><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/tit_water_time.png" alt="수다 타임 물 마시는 시간" /></h2>
			<img src="http://webimage.10x10.co.kr/playmo/ground/20160620/img_white_big.png" alt="" />
		</div>

		<div class="desc">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/txt_desc.png" alt="오늘 하루, 물 몇 잔 마셨나요? 물을 많이 마시면 좋다는 이야기는 많이 들었지만, 생각보다 실천이 잘 안되셨죠? 텐바이텐 Play에서 물 마신 횟수를 체크할 수 있는 수다 타임 코스터&amp;컵 세트를 준비했습니다. 나만의 수다 타임을 정해놓고 수다 타임 세트를 이용해 하루 물 8잔을 채워 보세요!" /></p>
		</div>

		<div id="rolling" class="rolling">
			<div class="swiper">
				<div class="label">
					<img src="http://webimage.10x10.co.kr/playmo/ground/20160620/ico_water_v2.png" alt="water" />
					<span><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/img_white.png" alt="" /></span>
				</div>
				<div class="swiper-container swiper">
					<div class="swiper-wrapper">
						<div class="swiper-slide swiper-slide-01">
							<img src="http://webimage.10x10.co.kr/playmo/ground/20160620/img_slide_01.jpg" alt="am 7" />
							<p class="story"><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/txt_story_01.png" alt="아침에 일어나 물 한 잔으로 하루 시작! 아침에 일어나 마시는 물은 우리 몸에 보약! 밤 사이 축적된 노폐물을 배출시켜, 몸 속 신진대사를 촉진시키고, 혈액순환을 도와줍니다." /></p>
						</div>
						<div class="swiper-slide swiper-slide-02">
							<img src="http://webimage.10x10.co.kr/playmo/ground/20160620/img_slide_02.jpg" alt="am 9" />
							<p class="story"><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/txt_story_02.png" alt="아침 먹기 30분 전에 물 한잔! 식사 30분 전에 물을 마시면 잠들었던 체내의 기관들이 일어납니다. 식사를 거르더라도 물은 마셔주세요!" /></p>
						</div>
						<div class="swiper-slide swiper-slide-03">
							<img src="http://webimage.10x10.co.kr/playmo/ground/20160620/img_slide_03.jpg" alt="am 11" />
							<p class="story"><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/txt_story_03.png" alt="오전 일과 중, 가볍게 물 한 잔을 바쁜 업무로 집중력이 흐려질 때쯤 가볍게 물 한 잔 마셔 보세요 정신이 맑아지고 신체기능을 높여 업무 효율 UP!" /></p>
						</div>
						<div class="swiper-slide swiper-slide-04">
							<img src="http://webimage.10x10.co.kr/playmo/ground/20160620/img_slide_04.jpg" alt="pm 12" />
							<p class="story"><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/txt_story_04.png" alt="기다리던 점심시간 30분 전, 물 한 잔! 점심 먹기 30분 전에 물 한 잔 마셔보세요 포만감 때문에 과식도 방지하고 소화를 촉진시켜 다이어트 효과가 있어요" /></p>
						</div>
						<div class="swiper-slide swiper-slide-05">
							<img src="http://webimage.10x10.co.kr/playmo/ground/20160620/img_slide_05.jpg" alt="pm 16" />
							<p class="story"><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/txt_story_05.png" alt="오후 일과 중, 시원한 물 한잔! 지칠 때쯤 과일을 넣어 마셔보세요! 수분이 채워지면 피로가 풀리고 심장의 혈액 공급을 활발하게 해주어 업무 효율을 높여줘요" /></p>
						</div>
						<div class="swiper-slide swiper-slide-06">
							<img src="http://webimage.10x10.co.kr/playmo/ground/20160620/img_slide_06.jpg" alt="pm 18" />
							<p class="story"><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/txt_story_06.png" alt="퇴근 전, 물 한잔 마시고 집으로 떠나요! 퇴근 5분 전 물 한 잔으로 마무리하세요 저녁 과식을 방지해줘 성인병을 예방하는데 도움을 줘요!" /></p>
						</div>
						<div class="swiper-slide swiper-slide-07">
							<img src="http://webimage.10x10.co.kr/playmo/ground/20160620/img_slide_07.jpg" alt="pm 21" />
							<p class="story"><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/txt_story_07.png" alt="느릿느릿 산책 후 시원하게 물 한잔! 운동 후 마시는 물은 몸에 수분을 채워줘 활력을 준다고 해요 짧은 산책에도 꼭 물 한잔 마셔 보세요!" /></p>
						</div>
						<div class="swiper-slide swiper-slide-08">
							<img src="http://webimage.10x10.co.kr/playmo/ground/20160620/img_slide_08.jpg" alt="pm 23" />
							<p class="story"><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/txt_story_08.png" alt="자기 전, 물 한 잔으로 하루를 마무리! 잠자기 전에 물을 마셔주면 자는 동안 신진대사를 원활하게 하고 혈액 정화, 피로회복에 도움이 돼요!" /></p>
						</div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="btn-prev"><img src="http://fiximage.10x10.co.kr/m/2015/event/btn_slide_prev.png" alt="이전" /></button>
				<button type="button" class="btn-next"><img src="http://fiximage.10x10.co.kr/m/2015/event/btn_slide_next.png" alt="다음" /></button>
			</div>
		</div>

		<section>
			<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/tit_item.png" alt="수다 타임 세트" /></h3>
			<p id="votes">
				<img src="http://webimage.10x10.co.kr/playmo/ground/20160620/img_item_01.jpg" alt="하루 물 8잔 마시기를 도와 줄 물컵과 횟수 체크 기능을 더한 코스터로 구성되어 있습니다 8 water coaster" />
				<img src="http://webimage.10x10.co.kr/playmo/ground/20160620/img_item_02.jpg" alt="water glass cup 300미리 수다 타임 세트는 한정수량으로 제작되어 판매가 되지 않습니다" />
			</p>
		</section>

		<section class="event" >
			<h3 class="hidden">수다 타임 세트 신청</h3>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/txt_event.jpg" alt="하루 물 8잔 마시기 도전! 추첨을 통해 총 10분에게 드립니다. 신청기간은 6월 20일부터 26일까지며, 당첨자 발표는 6월 28일 입니다." /></p>
		<% If todayCnt > 0 Then %>
			<p class="done"><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/btn_done.png" alt="신청 완료" /></p>
		<% Else %>
			<button type="button" class="btnEnter" onclick="vote_play(); return false;" ><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/btn_enter.png" alt="수다 타임 세트 신청하기" /></button>
		<% End If %>
			<p class="count">총 <b><%=FormatNumber(totcnt,0)%></b>명이 신청하셨습니다</p>
		</section>

		<section class="sns">
			<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/tit_sns.png" alt="친구들에게 공유하면 당첨 확률이 두 배!" /></h3>
			<ul>
				<li class="facebook"><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/ico_facebook.png" alt="페이스북으로 수다타임 공유하기" /></a></li>
				<li class="kakao"><a href="#" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/ico_kakao.png" alt="카타오톡으로 수다타임 공유하기" /></a></li>
			</ul>
		</section>
	</article>
</div>
<iframe id="frmproc" name="frmproc" frameborder="0" width=0 height=0></iframe>
<script type="text/javascript">
	<% if pagereload <> "" then %>
		$('html,body').animate({scrollTop: $("#votes").offset().top},0);
	<% end if %>
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->