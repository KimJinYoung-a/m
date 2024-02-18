<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'#################################################################
' Description : 탐앤탐스 이벤트 - 놀러와 우리의 다꾸홈카페로
' History : 2020-11-12 허진원
'#################################################################
%>
<%
Dim userid, currentDate, eventStartDate, eventEndDate
currentDate =  now()
userid = GetEncLoginUserID()
eventStartDate  = cdate("2020-09-14")		'이벤트 시작일
eventEndDate 	= cdate("2020-10-04")		'이벤트 종료일

if userid="ley330" or userid="greenteenz" or userid="rnldusgpfla" or userid="kobula" or userid="thensi7" or userid = "motions" or userid = "jj999a" or userid = "phsman1" or userid = "jjia94" or userid = "seojb1983" or userid = "kny9480" or userid = "bestksy0527" or userid = "mame234" or userid = "corpse2" or userid = "starsun726" then
	currentDate = #11/20/2020 09:00:00#
end if

Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  103266
Else
	eCode   =  107214
End If

dim subscriptcount
	
If userid <> "" then
	'금일 참여횟수 확인
	subscriptcount = getevent_subscriptexistscount(eCode, userid, left(currentDate,10), "", "")
Else
	subscriptcount = 0
End If

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("놀러와! 우리의 다꾸홈카페로!")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/105778/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "놀러와! 우리의 다꾸홈카페로!"
Dim kakaodescription : kakaodescription = "텐바이텐과 탐앤탐스가 다꾸홈카페를 준비해보았어요!"
Dim kakaooldver : kakaooldver = "텐바이텐과 탐앤탐스가 다꾸홈카페를 준비해보았어요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/105778/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style>
.mEvt107214 .topic {position:relative;}
.mEvt107214 .section-01 {padding-bottom:2.47rem; background:#fef6eb;}
.mEvt107214 .section-01 .input-area {display:flex; align-items:center; justify-content:center; padding:0 2.82rem;}
.mEvt107214 .section-01 .input-area button {width:5.30rem; height:4.13rem; font-size:1.34rem; color:#fff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; background-color: rgb(87, 42, 49);} 
.mEvt107214 .section-01 .input-area input {width:100%; height:4.13rem; margin-right:0.26rem; border-color:#572931; border-radius:0; font-size:1.34rem; color:#999; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt107214 .section-01 .input-area input::placeholder {font-size:1.34rem; color:#999; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt107214 .section-02 .item-area {padding:0 1.30rem 2.17rem; background:#fcead3;}
.mEvt107214 .section-02 .item-area:last-child {padding-bottom:4.95rem;}
.mEvt107214 .section-02 .detail-area {padding:0 1.52rem 3.47rem; background:#fff; border-radius:0 0 0.65rem 0.65rem;}
.mEvt107214 .section-02 .detail-area .tit {position:relative; width:100%; height:2.65rem; line-height:2.65rem; padding-left:0.86rem; background:#572a31; font-size:1.34rem; color:#fff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; cursor:pointer;}
.mEvt107214 .section-02 .detail-area .tit:after {content:""; display:inline-block; position:absolute; right:1rem; top:1rem; width:0.95rem; height:0.56rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/107214/m/icon_arrow.png) no-repeat 0 0; background-size:100%; transition: .5s ease;}
.mEvt107214 .section-02 .detail-area .tit.rotate:after {transform:rotate(180deg);}
.mEvt107214 .section-02 .detail-area .info {display:none;}
.mEvt107214 .section-03 .item {position:relative; text-align:center; background:#fff6ec;}
.mEvt107214 .section-03 .item .img,
.mEvt107214 .section-03 .item .txt {width:32.61rem;}
.mEvt107214 .section-03 .item .txt {width:22.96rem; position:absolute; left:50%; top:20rem; transform:translate(-50%, 0);}
.mEvt107214 .section-03 .item .txt02 {width:22.96rem; position:absolute; left:43%; top:32.5rem; transform:translate(-50%, 0);}
.mEvt107214 .section-03 .item .txt-box {width:100%; height:12rem; padding-top:2.39rem; background:#ffb800;}
.mEvt107214 .section-03 .item .txt-box img {width:24.96rem;}
.mEvt107214 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(0, 0, 0,0.702); z-index:150;}
.mEvt107214 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:4.17rem 1.73rem;}
.mEvt107214 .pop-container .pop-inner a {display:inline-block;}
.mEvt107214 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:5.73rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/107214/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;} 
.mEvt107214 .pop-container .pop-contents {position:relative;}
.mEvt107214 .pop-container .pop-contents .link-kakao {width:calc(100% - 4.80rem); position:absolute; left:50%; top:57%; transform:translate(-50%, 0);}
.mEvt107214 .vod-wrap {width:100%; height:23.65rem; margin:2.47rem 0;}
.mEvt107214 .vod-wrap .vod {padding:0;}
.mEvt107214 .vod-wrap .vod video {position:absolute; top:0; left:0; bottom:0; width:100%; height:100%;}
.mEvt107214 .vod-wrap .btn-play {position:absolute; top:0; left:0; width:100%; height:100%; z-index:10; background:transparent;}
.mEvt107214 .vod-wrap .btn-play:after {content:''; width:7.39rem; height:7.39rem; position:absolute; top:50%; left:50%; transform:translate(-50%, -50%); background:url(//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_play.png) 0 0 no-repeat; background-size:100% auto;}
.mEvt107214 .vod-wrap .btn-play img {height:100%;}
.mEvt107214 .memong-slide {background-color:#fff;}
.mEvt107214 .memong-slide .swiper-slide img {width:100vw;}
.mEvt107214 .memong-slide li {overflow:hidden; position:relative; width:72.84%; margin-left:2.7vw;}
.mEvt107214 .memong-slide li:first-child {margin-left:0;}
.mEvt107214 .memong-slide .pagination {overflow:hidden; position:absolute; bottom:0; left:0; z-index:10; width:100%; height:0.47rem; background:#fcead3;}
.mEvt107214 .memong-slide .pagination-fill {position:absolute; left:0; top:0; width:100%; height:100%; font-size:0; color:transparent; transform:scale(0); transform-origin:left top; transition-duration:300ms; background:#572a31;}
.bnr-anniv18 {display:none;}
</style>
<script>
$(function(){
    /* vedio 재생 */
    $('.vod .btn-play').click(function(){
		$(this).fadeOut();
        $(this).next('iframe')[0].contentWindow.postMessage('{"event":"command","func":"' + 'playVideo' + '","args":""}', '*');
		return false;
	});
    /* 자세히 보기 아코디언 */
    var tit = $(".mEvt107214 .tit");
    $(tit).on("click",function(){
        $(this).next(".info").slideToggle(500);
        $(this).toggleClass("rotate");
    });
    /* slide */
    var today = $('.memong-slide');
	var progressFill = today.find('.pagination-fill');
	var length = today.find('.swiper-slide').length;
	var init = (1 / length).toFixed(2);
	progressFill.css("transform", "scaleX(" + init + ") scaleY(1)");
    var mySwiper = new Swiper('.memong-slide .swiper-container', {
        slidesPerView: 'auto',
        autoplay:1200,
        speed:800,
        onSlideChangeStart: function(swiper2) {
			var scale = (swiper2.activeIndex+1) * init;
			progressFill.css("transform", "scaleX(" + scale + ") scaleY(1)");
		},
		onSliderMove: function(swiper2){
			var scale = (swiper2.activeIndex+1) * init;
			var lastprev = swiper2.slides.length-1
			if($('.memong-slide .swiper-slide:nth-child('+ lastprev +')').hasClass('swiper-slide-active')){
				progressFill.css("transform", "scaleX(" + scale + ") scaleY(1)");
			}
		},
		onReachEnd: function(swiper2) {
			progressFill.css("transform", "scaleX(1) scaleY(1)");
		}
    });
    /* text slide up */
    $(window).scroll(function(){
        var scrollTop = $(window).scrollTop();
        var ani_point01 = $(".item-top01").offset().top;
        var ani_point02 = $(".item-top02").offset().top;
        var ani_point03 = $(".item-top03").offset().top;
		if (scrollTop > ani_point01 ) {
			titleAnimation();
		}
		if (scrollTop > ani_point02 ) {
			titleAnimation();
        }
        if (scrollTop > ani_point03 ) {
			titleAnimation();
        }
	});
	$(".scroll01").css({"top":"25rem", "opacity":"0"});
	$(".scroll02").css({"top":"37.5rem", "opacity":"0"});
	$(".scroll03").css({"margin-top":"1.5rem", "opacity":"0"});
	function titleAnimation() {
		$(".scroll01").delay(300).animate({"top":"20rem", "opacity":"1"},700);
		$(".scroll02").delay(700).animate({"top":"32.5rem", "opacity":"1"},700);
		$(".scroll03").delay(1000).animate({"margin-top":"0", "opacity":"1"},700);
    }
    /* popup */
    // 정답 기재 후 등록 클릭시 호출 팝업
	$("#btnAnswer").on("click", function(){
		var ans = $("#txtAnswer").val();
		<% If Not(IsUserLoginOK) Then %>
			<% If isApp="1" or isApp="2" Then %>
				calllogin();
				return false;
			<% else %>
				jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid="&eCode&"")%>');
				return false;
			<% end if %>
		<% else %>
			<% If not( left(currentDate,10) >= "2020-11-18" and left(currentDate,10) <= "2020-12-01" ) Then %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% else %>
				<% if subscriptcount>0 then %>
					alert("오늘 이미 답을 제출하셨어요.\n하루에 한 번 참여 가능 합니다.");
					return;
				<% else %>
					if (ans == '' || GetByteLength(ans) > 2 || !IsDigit(ans)){
						alert("정답은 숫자 2자 이내입니다.");
						$("#txtAnswer").focus();
						return;
					}

					$.ajax({
						type: "post",
						url: "/event/lib/actEventSubscript.asp",
						data: "evt_code=<%=eCode%>&evt_option=<%=left(currentDate,10)%>&evt_option2="+ans+"&flgChkOpt=100",
						cache: false,
						success: function(message) {
							var rst = JSON.parse(message);
							if(rst.result=="00") {
								$(".pop-container").fadeIn();
								fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>');
							} else if(rst.result=="04") {
								alert('오늘 이미 답을 제출하셨어요.\n하루에 한 번 참여 가능 합니다.');
							} else {
								alert(rst.message);
							}
						},
						error: function(err) {
							console.log(err.responseText);
						}
					});
				<% end if %>
			<% end if %>
		<% End IF %>
	});
	// 팝업 닫기
	$(".mEvt107214 .btn-close").on("click", function(){
		$(".pop-container").fadeOut();
	});
});

function sharesns(snsnum) {		
<% if isapp then %>
	fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
<% else %>
	event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );
<% end if %>
}
</script>
<div class="mEvt107214">
	<div class="topic">
		<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_tit.jpg" alt="tenbyten x tom n toms 다꾸홈카페 로 놀러와! 텐바이텐과 탐앤탐스가 다꾸 홈카페를 준비해보았어요! 지금 이벤트 참여하고 다꾸홈카페의 주인공에 도전해보세요!"></h2>
	</div>
	<div class="section-01">
		<img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_event_info.jpg" alt="아래 영상 속에서 텐텐x탐탐 문구가 몇번 등장할까요?">
		<div class="input-area">
			<input id="txtAnswer" type="number" placeholder="정답 등록 예시 ) 7" maxlength="2" />
			<button type="button" id="btnAnswer" class="btn-enter">등록</button>
		</div>
		<!-- 영상 영역 -->
		<div class="video-area">
            <div class="vod-wrap">
                <div class="vod">
                    <!-- <button class="btn-play"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_btn_play.png" alt="image"></button> -->
                    <iframe src="https://www.youtube.com/embed/z4gJyRjiNLM?enablejsapi=1&rel=0&playsinline=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen=""></iframe>
                </div>
            </div>
        </div>
		<!-- //영상 영역 -->
	</div>
	<div class="section-02">
		<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_tit_02.jpg" alt="이벤트 당첨 상품 당첨자 중 추첨을 통해 아래 상품 1종을 드립니다."></h3>
		<div class="item-area">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_gift_01.jpg" alt="다꾸 홈카페 gift set">
			<div class="detail-area">
				<div class="tit">상품 자세히 보기</div>
				<div class="info" style="height:15.48rem;">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_detail_01.jpg" alt="아스카소 드림머신, 마샬 액톤 2 스피커, 더 칼립소 에스프로소잔 세트, 더 칼립소 골드 로고 머그컵, 텐바이텐 다꾸 아이템 10만원 상당, 탐앤탐스 2021 플러나 1종">
				</div>
			</div>
		</div>
		<div class="item-area">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_gift_02.jpg" alt="탐앤탐스 마이탐 프레즐 세트 쿠폰 100명">
			<div class="detail-area">
				<div class="tit">쿠폰 사용 방법 자세히 보기</div>
				<div class="info" style="height:20.83rem;">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_detail_02.jpg" alt="마이탐 프레즐 쿠폰 사용 기간, 마이탐 프레즐 쿠폰 사용 방법">
				</div>
			</div>
		</div>
	</div>
	<div class="section-03">
		<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_tit_03.jpg" alt="다꾸홈카페 구경하기 지금 당장 다꾸하고 싶게 만드는 다꾸홈카페! 여러분들도 집에서 쉽게 즐기실 수 있어요!"></h3>
		<div class="memong-slide">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_slide01.png" alt="slide 01">
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_slide02.png" alt="slide 02">
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_slide03.png" alt="slide 03">
					</div>
				</div>
				<!-- page nation -->
				<div class="pagination"><span class="pagination-fill"></span></div>
			</div>
		</div>
		<div class="item item-top01">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_look_01.jpg" alt="다꾸홈카페 구경하기" class="img">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_look_text01.jpg" alt="텐바이텐에서 만날 수 있는 다양한 다꾸템과 함께 다꾸 즐기기!" class="txt scroll01">
		</div>
		<div class="item item-top02">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_look_02.jpg" alt="다꾸홈카페 구경하기" class="img">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_look_text02.jpg" alt="탐앤탐스 홈카페 아이템으로 나만의 홈카페를 열어보세요." class="txt02 scroll02">
		</div>
		<div class="item item-top03">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_look_03.jpg" alt="다꾸홈카페 구경하기" class="img">
			<div class="txt-box">
				<img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_txt_01.png" alt="날씨가 추워진 요즘, 집에서 따뜻한 나만의 다꾸홈카페를 즐겨보세요." class="scroll03">
			</div>
		</div>
	</div>
	<div>
		<img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_noti.jpg" alt="유의사항">
	</div>
	<div class="pop-container">
		<div class="pop-inner">
			<div class="pop-contents">
				<img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_pop.png" alt="정답 제출 알림 팝업">
				<a href="#" class="link-kakao" onclick="sharesns('ka')"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107214/m/img_sns.png" alt="친구에게도 이벤트 소식을 공유해보세요!"></a>
			</div>
			<button type="button" class="btn-close">닫기</button>
		</div>
	</div>
</div>