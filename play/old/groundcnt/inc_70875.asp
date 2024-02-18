<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAY 30-4 M/A
' History : 2016-05-19 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim eCode , userid
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66134
Else
	eCode   =  70875
End If

userid = GetEncLoginUserID()

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("#서울재즈페스티벌 공식굿즈 둘러보고, 초대권도 받아야지! #텐바이텐 #서재페 #SJF2016")
snpLink = Server.URLEncode("http://bit.ly/sjf2016")
snpPre = Server.URLEncode("텐바이텐")

'기본 태그
snpTag = Server.URLEncode("텐바이텐")
snpTag2 = Server.URLEncode("#10x10")

%>
<style type="text/css">
img {vertical-align:top;}

.mPlay20160523 button {background-color:transparent;}
.mPlay20160523 h2 {position:relative; z-index:10;}

.sjfContWrap {width:100%; position:relative; padding-bottom:193%; margin-top:-49.0625%;}
.sjfContWrap .sjfCont {width:100%; height:100%; position:absolute; left:0; top:0; right:0; bottom:0;}
.sjfContWrap .swiper-container {width:100%; height:100%;}
.sjfContWrap .swiper-wrapper {width:100%; height:100%;}
.sjfContWrap .swiper-slide {width:100%; height:100%; display:-webkit-box; display:-ms-flexbox; display:-webkit-flex; display:flex; -webkit-box-pack:center; -ms-flex-pack:center; -webkit-justify-content:center; justify-content:center; -webkit-box-align:center; -ms-flex-align:center; -webkit-align-items:center; align-items:center;}
.sjfContWrap .vPagination {position:absolute; right:1.5rem; width:5rem; top:57%; height:12.75rem; background:transparent url(http://webimage.10x10.co.kr/playmo/ground/20160523/bg_cont_control1.png) no-repeat 50% 0; background-size:1.3rem auto; z-index:100;}
.sjfContWrap .vPagination .swiper-pagination-switch {display:block; width:5rem; height:50%; margin:0 auto;}
.sjfContWrap .vPagination .swiper-pagination-switch:first-child {background:transparent url(http://webimage.10x10.co.kr/playmo/ground/20160523/btn_cont_control2.png) no-repeat 50% 100%; background-size:2.3rem auto;}
.sjfContWrap .vPagination .swiper-pagination-switch:last-child {background:transparent url(http://webimage.10x10.co.kr/playmo/ground/20160523/btn_cont_control1.png) no-repeat 50% 100%; background-size:2.3rem auto;}
.sjfContWrap .vPagination .swiper-active-switch {background:transparent !important;}
.swiper-button-prev, .swiper-button-next {width:3.2rem; height:3.2rem; top:auto; bottom:3.5%; left:50%; background-position:50% 50%; background-repeat:no-repeat;}
.swiper-button-prev {margin-left:-22.8125%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160523/btn_cont_prev.png); background-size:100%;}
.swiper-button-next {margin-left:13.125%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160523/btn_cont_next.png); background-size:100%;}
.scrollDeco {position:absolute; right:2.3rem; top:57%; width:2.6rem; height:2.8rem; margin-top:13.5rem; background:transparent url(http://webimage.10x10.co.kr/playmo/ground/20160523/bg_sjf_cont_deco.png) no-repeat 50% 0; background-size:2.65rem auto; z-index:10;}

.rolling {position:relative; background-color:#fbb56f; text-align:center;}
.rolling .swiper {position:relative; padding:0 4.6875% 4rem 4.6875%;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper button {position:absolute; top:38%; z-index:20; width:7%; background:transparent;}
.rolling .swiper .btnPrev {left:4.6875%;}
.rolling .swiper .btnNext {right:4.6875%;}
.rolling .swiper .pagination {overflow:hidden; position:absolute; bottom:1.5rem; left:0; width:100%; height:0.5rem; z-index:50; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; position:relative; z-index:50; width:0.5rem; height:0.5rem; margin:0 0.4rem; border-radius:0.25rem 0.25rem; background-color:#f49536; cursor:pointer;}
.rolling .swiper .pagination .swiper-active-switch {width:1rem; background-color:#fff;}
.rolling .btnBuy {padding-bottom:10%;}
.rolling .btnBuy button {width:32.8125%;}

.sns {position:relative;}
.sns ul {position:absolute; left:0; top:52%; width:100%; height:28%; padding:0 5%; margin:0 auto;}
.sns ul li {position:relative; float:left; width:33%; height:100%; cursor:pointer;}
.sns ul li a, .sns ul li span {display:block; width:100%; height:100%; text-indent:-999rem;}
.sns ul li p {display:none; position:absolute; left:50%; top:95%; width:12.2rem; margin-left:-6.1rem; z-index:10;}
.sns ul li p a {position:absolute; left:5%; top:50%; right:5%; width:90%; height:40%;}

.moviewrap {width:100%; padding:0 4.6875% 10%; background-color:#f1a498;}
.movie .youtube {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background:#000;}
.movie .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%}
</style>
<script type="text/javascript">
$(function(){
	var swiperH = new Swiper('.swiper-container-h', {
		pagination:false,
		nextButton:'.swiper-button-next',
		prevButton:'.swiper-button-prev',
		effect: 'fade'
	});

	var swiperVs1 = new Swiper('.vSlide1', {
		pagination:'.vSlide1 .vPagination',
		paginationClickable:true,
		effect:'fade',
		direction:'vertical',
		simulateTouch:false
	});

	var swiperVs2 = new Swiper('.vSlide2', {
		pagination:'.vSlide2 .vPagination',
		paginationClickable:true,
		effect:'fade',
		direction:'vertical',
		simulateTouch:false
	});

	var swiperVs3 = new Swiper('.vSlide3', {
		pagination:'.vSlide3 .vPagination',
		paginationClickable:true,
		effect:'fade',
		direction:'vertical',
		simulateTouch:false
	});

	var swiperVs4 = new Swiper('.vSlide4', {
		pagination:'.vSlide4 .vPagination',
		paginationClickable:true,
		effect:'fade',
		direction:'vertical',
		simulateTouch:false
	});

	/* sns instagram */
	$(".btnInsta").click(function(){
		if($(this).children('p').is(':hidden')){
			$(this).find('p').show();
		} else {
			$(this).find('p').hide();
		};
	});

	/* rolling */
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		autoplay:2000,
		speed:800,
		pagination:".swiper1 .pagination",
		paginationClickable:true,
		autoplayDisableOnInteraction:false,
		nextButton:".btnNext",
		prevButton:".btnPrev"
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if (chkapp){
		$(".app").show();
		$(".mo").hide();
	} else {
		$(".app").hide();
		$(".mo").show();
	}
});

function jsevtchk(sns){
	<% If not(left(now(),10)>="2016-05-20" and left(now(),10)<"2016-05-27" ) Then '오픈시 이벤트 기간 23~26일로 수정 %>
		alert('이벤트 응모 기간이 아닙니다.');
		return;
	<% else %>
		<% if IsUserLoginOK then %>
		var result;
			$.ajax({
				type:"GET",
				url:"/play/groundcnt/doEventSubscript70875.asp",
				data: "mode=sns&snsgubun="+sns,
				dataType: "text",
				async:false,
				cache:false,
				success : function(Data){
					result = jQuery.parseJSON(Data);
					if(result.stcode=="tw") 
					{
						parent.popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>')
						return false;
					}
					else if(result.stcode=="fb")
					{
						popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
						return false;
					}
				}
			});	
		<% else %>
			<% If isapp="1" Then %>
				calllogin();
				return;
			<% else %>
				jsevtlogin();
				return;
			<% End If %>
		<% end if %>
	<% end if %>
}
</script>
<div class="mPlay20160523">
	<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/tit_sjf.png" alt="JAZZ UP YOUR SOUL - Seoul Jazz Festival 2016" /></h2>

	<div class="sjfContWrap">
		<div class="sjfCont">
			<div class="swiper-container swiper-container-h "><!-- swiper-no-swiping -->
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<div class="swiper-container swiper-container-v vSlide1" dir="rtl">
							<div class="swiper-wrapper swiper-no-swiping">
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/img_sjf_cont1a.jpg" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/img_sjf_cont1b.jpg" alt="" /></div>
							</div>
							<div class="vPagination"></div>
						</div>
					</div>
					<div class="swiper-slide">
						<div class="swiper-container swiper-container-v vSlide2" dir="rtl">
							<div class="swiper-wrapper swiper-no-swiping">
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/img_sjf_cont2a.jpg" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/img_sjf_cont2b.jpg" alt="" /></div>
							</div>
							<div class="vPagination"></div>
						</div>
					</div>
					<div class="swiper-slide">
						<div class="swiper-container swiper-container-v vSlide3" dir="rtl">
							<div class="swiper-wrapper swiper-no-swiping">
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/img_sjf_cont3a.jpg" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/img_sjf_cont3b.jpg" alt="" /></div>
							</div>
							<div class="vPagination"></div>
						</div>
					</div>
					<div class="swiper-slide">
						<div class="swiper-container swiper-container-v vSlide4" dir="rtl">
							<div class="swiper-wrapper swiper-no-swiping">
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/img_sjf_cont4a.jpg" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/img_sjf_cont4b.jpg" alt="" /></div>
							</div>
							<div class="vPagination"></div>
						</div>
					</div>
				</div>
				<div class="swiper-button-next"></div>
				<div class="swiper-button-prev"></div>
				<p class="scrollDeco"></p>
			</div>
		</div>
	</div>

	<div class="rolling">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/txt_sjf_lineup.png" alt="SPEICAL LINE UP" /></p>
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/img_slide1.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/img_slide2.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/img_slide3.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/img_slide4.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/img_slide5.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/img_slide6.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/img_slide7.jpg" alt="" /></div>
				</div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/btn_slide_prev.png" alt="이전" /></button>
			<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/btn_slide_next.png" alt="다음" /></button>
		</div>
		<div class="btnBuy">
			<button type="button" onclick="window.open('http://m.10x10.co.kr/event/eventmain.asp?eventid=70864')" class="mo"><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/btn_buy.png" alt="BUY" /></button>
			<button type="button" onclick="fnAPPpopupEvent(70864);return false;" class="app"><img src="http://webimage.10x10.co.kr/playmo/ground/20160523/btn_buy.png" alt="BUY" /></button>
		</div>
	</div>
	<div class="sns">
		<ul>
			<li class="btnInsta"><span>INSTARGRAM</span>
				<p>
					<a href="https://www.instagram.com/your10x10/" target="blank" class="mo">인스타그램 바로가기</a>
					<a href="" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/your10x10/'); return false;" class="app">인스타그램 바로가기</a>
					<img src="http://webimage.10x10.co.kr/playmo/ground/20160523/tag_sjf_instar.png" alt="본페이지를 캡쳐해서 포스팅해주세요" />
				</p>
			</li>
			<li><a href="" onclick="jsevtchk('fb');return false;">FACEBOOK</a></li>
			<li><a href="" onclick="jsevtchk('tw');return false;">TWITTER</a></li>
		</ul>
		<img src="http://webimage.10x10.co.kr/playmo/ground/20160523/img_sjf_sns.jpg" alt="INVITE YOU - 이번 플레이 그라운드를 SNS에 공유해주시는 분중 추첨을 통해 두분께 Seoul Jazz Festival 2016 1일 입장원(2매)를 드립니다." />
	</div>

	<div class="moviewrap">
		<div class="movie">
			<div class="youtube">
				<iframe src="https://www.youtube.com/embed/d-E3RTYe82k" frameborder="0" title="Seoul Jazz Festival 2016" allowfullscreen></iframe>
			</div>
		</div>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->