<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 2017 세일 이벤트 : 숨은 보물 찾기 MA
' History : 2017-03-29 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim currenttime, eCode, myevtcnt, itSlideno, i, sqlstr, myevtdaycnt
	currenttime = date()
'																		currenttime = "2017-04-17"

IF application("Svr_Info") = "Dev" THEN
	eCode   =  66294
Else
	eCode   =  77062
End If

dim userid
	userid = GetEncLoginUserID()
	myevtcnt = 0
	myevtdaycnt = 0

if userid <> "" then
	myevtcnt = getevent_subscriptexistscount(eCode,userid,"","","")

	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and userid='"& userid &"' and datediff(day,regdate,getdate()) = 0 "
	rsget.Open sqlstr, dbget, 1
		myevtdaycnt = rsget(0)
	rsget.close
end if

itSlideno = right(currenttime,2)-3
%>
<!-- #include virtual="/event/props/sns.asp" -->
<style type="text/css">
.treasure {position:relative;}
#dimmed {position:absolute; top:0; left:0; z-index:20; width:100%; height:100%; background:rgba(0,0,0, 0.8);}
.lyGuide {position:absolute; top:4%; left:50%; z-index:50; width:84%; margin-left:-42%;}
.lyGuide .btnClose {position:absolute; bottom:0; left:50%; width:92.6%; background-color:transparent; margin-left:-46.3%;}

.topic {position:relative;}
.topic span {position:absolute; top:20%; right:15%; width:34.375%;}

.hint {padding-bottom:5%; background:#a9dff1 url(http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/bg_sea_card.png) 50% 0 no-repeat; background-size:100% auto;}
.hint .swiper-slide {width:68.75%;}
.hint .open {position:relative;}
.hint .coming {display:none;}
.hint .btnGo {position:absolute; bottom:0; left:0; width:100%;}
.hint .btnGo span {position:absolute; top:38%; right:23.4%; width:5%;}
.move {animation:move 0.8s 7 alternate; animation-delay:2.2s; -webkit-animation:move 0.8s 7 alternate; -webkit-animation-delay:2.2s;}
@keyframes move {
	0% {transform:translateX(0); opacity:1;}
	100% {transform:translateX(5px); opacity:0;}
}
@-webkit-keyframes move {
	0% {-webkit-transform:translateX(0); opacity:1;}
	100% {-webkit-transform:translateX(5px); opacity:0;}
}

.check {position:absolute; top:33%; left:12.5%; width:5.9%;}
.check span {display:block; margin-top:190%; opacity:0;}
.check span:first-child {margin-top:0;}
.check span:nth-child(2) {animation-delay:0.8s; -webkit-animation-delay:0.8s;}
.check span:nth-child(3) {animation-delay:1.6s; -webkit-animation-delay:1.6s;}
.slideUp {
	animation:slideUp 1.6s cubic-bezier(0.19, 1, 0.22, 1) forwards;
	-webkit-animation:slideUp 1.6s cubic-bezier(0.19, 1, 0.22, 1) forwards;
}
@keyframes slideUp {
	0% {transform:translateY(-20px); opacity:0;}
	100% {transform:translateY(0); opacity:1;}
}
@-webkit-keyframes slideUp {
	0% {-webkit-transform:translateY(-20px); opacity:0;}
	100% {-webkit-transform:translateY(0); opacity:1;}
}

.line {position:absolute; top:38%; left:22%; width:28.5%;}
.line span {display:block; width:100%; height:2px; margin-top:55%; background-color:#ff9f42; transform-origin:0 0; -webkit-transform-origin:0 0; opacity:0;}
.line span:first-child {margin-top:0;}
.line span:nth-child(2) {animation-delay:1s; -webkit-animation-delay:1s;}
.line span:nth-child(3) {margin-top:54%; animation-delay:2s; -webkit-animation-delay:2s;}
.swiper-slide:nth-child(2) .line span,
.swiper-slide:nth-child(7) .line span,
.swiper-slide:nth-child(12) .line span {background-color:#bb68cc;}
.swiper-slide:nth-child(3) .line span,
.swiper-slide:nth-child(8) .line span,
.swiper-slide:nth-child(13) .line span {background-color:#ff7487;}
.swiper-slide:nth-child(4) .line span,
.swiper-slide:nth-child(9) .line span,
.swiper-slide:nth-child(14) .line span {background-color:#4793e1;}
.swiper-slide:nth-child(5) .line span,
.swiper-slide:nth-child(10) .line span,
.swiper-slide:nth-child(15) .line span {background-color:#85c158;}

.swiper-slide:first-child .line span:first-child {width:88%;}
.swiper-slide:first-child .line span:nth-child(2) {width:58%;}
.swiper-slide:nth-child(2) .line span:first-child {width:40%;}
.swiper-slide:nth-child(2) .line span:nth-child(2) {width:62%;}
.swiper-slide:nth-child(3) .line span:nth-child(2) {width:58%;}
.swiper-slide:nth-child(4) .line span:nth-child(2) {width:88%;}
.swiper-slide:nth-child(5) .line span:nth-child(2) {width:58%;}
.swiper-slide:nth-child(6) .line span:nth-child(2) {width:60%;}
.swiper-slide:nth-child(7) .line span:first-child {width:40%;}
.swiper-slide:nth-child(8) .line span:first-child {width:40%;}
.swiper-slide:nth-child(8) .line span:nth-child(2) {width:60%;}
.swiper-slide:nth-child(9) .line span:first-child {width:80%;}
.swiper-slide:nth-child(9) .line span:nth-child(2) {width:80%;}
.swiper-slide:nth-child(10) .line {width:43%;}
.swiper-slide:nth-child(10) .line span {margin-top:37%;}
.swiper-slide:nth-child(10) .line span:first-child {margin-top:0;}
.swiper-slide:nth-child(10) .line span:nth-child(2) {width:42%;}
.swiper-slide:nth-child(10) .line span:nth-child(3) {width:67%; margin-top:35%;}
.swiper-slide:nth-child(11) .line span:nth-child(2) {width:80%;}
.swiper-slide:nth-child(12) .line {top:39%; width:33%;}
.swiper-slide:nth-child(12) .line span {margin-top:46%;}
.swiper-slide:nth-child(12) .line span:first-child {margin-top:0; width:88%;}
.swiper-slide:nth-child(12) .line span:nth-child(3) {width:82%; margin-top:42%;}
.swiper-slide:nth-child(13) .line span:first-child {width:82%;}
.swiper-slide:nth-child(13) .line span:nth-child(2) {width:58%;}
.swiper-slide:nth-child(14) .line {width:35%;}
.swiper-slide:nth-child(14) .line span {margin-top:46%;}
.swiper-slide:nth-child(14) .line span:first-child {margin-top:0;}
.swiper-slide:nth-child(14) .line span:nth-child(2) {width:81%;}
.swiper-slide:nth-child(14) .line span:nth-child(3) {width:82%; margin-top:42%;}
.swiper-slide:nth-child(15) .line span:first-child,
.swiper-slide:nth-child(15) .line span:nth-child(2) {width:40%;}

.scaleX {animation:scaleX 1.2s cubic-bezier(0.19, 1, 0.22, 1) forwards; -webkit-animation:scaleX 1.2s cubic-bezier(0.19, 1, 0.22, 1) forwards;}
@keyframes scaleX {
	0% {transform:scaleX(0); opacity:0;}
	100% {transform:scaleX(1); opacity:1;}
}
@-webkit-keyframes scaleX {
	0% {-webkit-transform:scaleX(0); opacity:0;}
	100% {-webkit-transform:scaleX(1); opacity:1;}
}

.btnGuide {margin-top:5%;}
.btnGuide a {display:block; padding:5% 0;}

.treasure .count {padding:10% 0 8%; background:#f9f9f9 url(http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/bg_wave_v1.png) 50% 0 no-repeat; background-size:100% auto;}
.treasure .no {display:table; width:100%; height:3.5rem; text-align:center;}
.treasure .no .inner {display:table-cell; width:100%; height:100%; vertical-align:middle;}
.treasure .no span {display:inline-block; width:8.65rem; vertical-align:middle;}
.treasure .no span:last-child {width:2.5rem;}
.treasure .no b {display:inline-block; width:4.2rem; margin:0 0.7rem 0 1.3rem; color:#f8536a; font-size:3.6rem; font-weight:bold; line-height:3.5rem; vertical-align:middle; text-align:center;}
.treasure .one {width:58.125%; margin:2rem auto 0;}

.noti {padding:2.5rem 2.5rem 2.4rem; border-top:1rem solid #4f9bbb; background-color:#eee;}
.noti h3 {position:relative; color:#105775; font-size:1.3rem; font-weight:bold; line-height:1em;}
.noti h3:after {content:' '; display:block; position:absolute; top:50%; left:-1rem; width:0.4rem; height:1rem; margin-top:-0.3rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/blt_arrow.png) 50% 0 no-repeat; background-size:100% auto;}
.noti ul {margin-top:1.3rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#333; font-size:1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:0.4rem; height:0.1rem; background-color:#333;}

.sns {position:relative;}
.sns ul {width:33.75%; position:absolute; top:31%; right:3.43%;}
.bnr {background-color:#f4f7f7;}
.bnr ul li {margin-top:1rem;}
.bnr ul li:first-child {margin-top:0;}
</style>
<script type="text/javascript">
$(function(){
	/* layer popup */
	$(".btnClose").one("click",function () {
		$("#lyGuide").hide();
		$("#dimmed").fadeOut();
		$(".hint .swiper-slide:nth-child(1) .check span").addClass("slideUp");
		$(".hint .swiper-slide:nth-child(1) .line span").addClass("scaleX");
		$(".btnGo span").addClass("move");
	});

	$.fn.layerOpen = function(options) {
		return this.each(function() {
			var $this = $(this);
			var $layer = $($this.attr("href") || null);
			$this.click(function() {
				$layer.attr("tabindex",0).show().focus();
				$("#dimmed").show();
				window.$('html,body').animate({scrollTop:100}, 500);
				$layer.find(".btnClose").one("click",function () {
					$layer.hide();
					$this.focus();
					$("#dimmed").hide();
				});
			});
		});
	}
	$(".layer").layerOpen();
	
	/* swiper */
	if ($("#hint .swiper-container .swiper-slide").length > 1) {
		var hintSwiper = new Swiper("#hint .swiper-container",{
			slidesPerView:"auto",
			centeredSlides:true,
			// for dev msg : 날짜별로 initialSlide 변경해주세요!
			initialSlide:<%= itSlideno %>,
			spaceBetween:"7.8%",
			onSlideChangeEnd: function (hintSwiper) {
				$(".swiper-slide").find(".check span").removeClass("slideUp");
				$(".swiper-slide-active").find(".check span").addClass("slideUp");

				$(".swiper-slide").find(".line span").removeClass("scaleX");
				$(".swiper-slide-active").find(".line span").addClass("scaleX");

				$(".swiper-slide").find(".btnGo span").removeClass("move");
				$(".swiper-slide-active").find(".btnGo span").addClass("move");

				if ($(".swiper-slide-active").is(".swiper-slide:nth-child(15)")) {
					$("#hint").css("background","#a9dff1 url(http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/bg_sea_v2.png) no-repeat 50% 0");
					$("#hint").css("background-size","100% auto");
				}
			}
		});
	} else {
		var hintSwiper = new Swiper("#hint .swiper-container",{
			slidesPerView:"auto",
			centeredSlides:true,
			spaceBetween:"7.8%",
			noSwipingClass:".noswiping",
			noSwiping:true
		});
	}

	window.$('html,body').animate({scrollTop:$("#toparticle").offset().top}, 0);
});

function goCateLink(cg) {
	<% if isApp ="1" then %>
		fnAPPpopupCategory(cg);
	<% else %>
		parent.location.href='/category/category_list.asp?disp='+cg;
	<% end if %>
	return false;
}

</script>
	<!-- 4월 정기세일 소품전 [77062] 숨은 보물 찾기 -->
	<div class="sopum treasure" id="toparticle">
		<div id="lyGuide" class="lyGuide" <%=chkIIF(myevtdaycnt>0,"style='display:none'","")%>>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/txt_guide_v1.png" alt="보물찾으러 GO 버튼을 눌러 이동 후 상품 리스트에서 보물을 찾는다. 보물을 선택한 후 팝업창에서 응모하면 완료!!" /></p>
			<button type="button" class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_close.gif" alt="확인" /></button>
		</div>

		<p class="topic">
			<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/txt_treasure_v4.jpg" alt="하루에 하나씩 15일 일별로 주어진 힌트를 보고 텐바이텐 곳곳에 숨겨진 보물을 찾으세요!" />
			<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/img_ani.gif" alt="" /></span>
		</p>

		<!-- hint -->
		<div id="hint" class="hint">
			<div class="swiper-container">
				<div class="swiper-wrapper">

				<% if left(currenttime,10) >= "2017-04-03" then %>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/img_hint_0403.png" alt="4월 3일 힌트 가구/조명 카테고리에서 무드등 상품 중 주황색박스를 찾아라!" /></p>
						<div class="check">
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
						</div>
						<div class="line"><span></span><span></span><span></span>
						</div>
						<a href="" onclick="goCateLink('121101109'); return false;" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go.png" alt="보물찾으러 Go" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go_arrow.png" alt="" /></span></a>
					</div>
				<% end if %>

				<% if left(currenttime,10) >= "2017-04-04" then %>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/img_hint_0404.png" alt="4월 4일 힌트 토이 카테고리에서 피규어 상품 중 보라색박스를 찾아라!" /></p>
						<div class="check">
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
						</div>
						<div class="line"><span></span><span></span><span></span>
						</div>
						<a href="" onclick="goCateLink('104101'); return false;" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go.png" alt="보물찾으러 Go" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go_arrow.png" alt="" /></span></a>
					</div>
				<% end if %>

				<% if left(currenttime,10) >= "2017-04-05" then %>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/img_hint_0405.png" alt="4월 5일 데코/플라워 카테고리에서 디퓨져 상품 중 핑크색박스를 찾아라!" /></p>
						<div class="check">
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
						</div>
						<div class="line"><span></span><span></span><span></span>
						</div>
						<a href="" onclick="goCateLink('122106'); return false;" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go.png" alt="보물찾으러 Go" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go_arrow.png" alt="" /></span></a>
					</div>
				<% end if %>

				<% if left(currenttime,10) >= "2017-04-06" then %>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/img_hint_0406.png" alt="4월 6일 캠핑/트래블 카테고리에서 텐트/타프 상품 중 파랑색박스를 찾아라!" /></p>
						<div class="check">
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
						</div>
						<div class="line"><span></span><span></span><span></span></div>
						<a href="" onclick="goCateLink('103107101'); return false;" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go.png" alt="보물찾으러 Go" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go_arrow.png" alt="" /></span></a>
					</div>
				<% end if %>

				<% if left(currenttime,10) >= "2017-04-07" then %>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/img_hint_0407.png" alt="4월 7일 디자인문구 카테고리에서 필기구 상품 중 초록색박스를 찾아라!" /></p>
						<div class="check">
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
						</div>
						<div class="line"><span></span><span></span><span></span></div>
						<a href="" onclick="goCateLink('101104101'); return false;" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go.png" alt="보물찾으러 Go" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go_arrow.png" alt="" /></span></a>
					</div>
				<% end if %>

				<% if left(currenttime,10) >= "2017-04-08" then %>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/img_hint_0408.png" alt="4월 8일 패브릭/수납 카테고리에서 수납장 상품 중 주황색박스를 찾아라!" /></p>
						<div class="check">
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
						</div>
						<div class="line"><span></span><span></span><span></span></div>
						<a href="" onclick="goCateLink('120109104101'); return false;" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go.png" alt="보물찾으러 Go" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go_arrow.png" alt="" /></span></a>
					</div>
				<% end if %>

				<% if left(currenttime,10) >= "2017-04-09" then %>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/img_hint_0409.png" alt="4월 9일 키친 카테고리에서 피크닉매트 상품 중 보라색박스를 찾아라!" /></p>
						<div class="check">
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
						</div>
						<div class="line"><span></span><span></span><span></span></div>
						<a href="" onclick="goCateLink('112108107'); return false;" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go.png" alt="보물찾으러 Go" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go_arrow.png" alt="" /></span></a>
					</div>
				<% end if %>

				<% if left(currenttime,10) >= "2017-04-10" then %>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/img_hint_0410.png" alt="4월 10일 힌트 푸드 카테고리에서 견과류 상품 중 핑크색박스를 찾아라!" /></p>
						<div class="check">
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
						</div>
						<div class="line"><span></span><span></span><span></span></div>
						<a href="" onclick="goCateLink('119104101'); return false;" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go.png" alt="보물찾으러 Go" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go_arrow.png" alt="" /></span></a>
					</div>
				<% end if %>

				<% if left(currenttime,10) >= "2017-04-11" then %>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/img_hint_0411.png" alt="4월 11일 패션의류 카테고리에서 생활한복 상품 중 파랑색박스를 찾아라!" /></p>
						<div class="check">
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
						</div>
						<div class="line"><span></span><span></span><span></span></div>
						<a href="" onclick="goCateLink('117102109'); return false;" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go.png" alt="보물찾으러 Go" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go_arrow.png" alt="" /></span></a>
					</div>
				<% end if %>

				<% if left(currenttime,10) >= "2017-04-12" then %>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/img_hint_0412.png" alt="4월 12일 힌트 가방/슈즈/주얼리 카테고리에서 에코백 상품 중 초록색박스를 찾아라!" /></p>
						<div class="check">
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
						</div>
						<div class="line"><span></span><span></span><span></span></div>
						<a href="" onclick="goCateLink('116101101'); return false;" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go.png" alt="보물찾으러 Go" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go_arrow.png" alt="" /></span></a>
					</div>
				<% end if %>
					
				<% if left(currenttime,10) >= "2017-04-13" then %>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/img_hint_0413.png" alt="4월 13일 힌트 베이비/키즈 카테고리에서 봉제인형 상품 중 주황색박스를 찾아라!" /></p>
						<div class="check">
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
						</div>
						<div class="line"><span></span><span></span><span></span></div>
						<a href="" onclick="goCateLink('115107106'); return false;" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go.png" alt="보물찾으러 Go" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go_arrow.png" alt="" /></span></a>
					</div>
				<% end if %>

				<% if left(currenttime,10) >= "2017-04-14" then %>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/img_hint_0414.png" alt="4월 14일 힌트 Cat&amp;Dog 카테고리에서 플레이장난감 상품 중 보라색박스를 찾아라!" /></p>
						<div class="check">
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
						</div>
						<div class="line"><span></span><span></span><span></span></div>
						<a href="" onclick="goCateLink('110112103'); return false;" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go.png" alt="보물찾으러 Go" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go_arrow.png" alt="" /></span></a>
					</div>
				<% end if %>

				<% if left(currenttime,10) >= "2017-04-15" then %>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/img_hint_0415.png" alt="4월 15일 힌트 가구/조명 카테고리에서 타공판 상품 중 핑크색박스를 찾아라!" /></p>
						<div class="check">
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
						</div>
						<div class="line"><span></span><span></span><span></span></div>
						<a href="" onclick="goCateLink('121113109'); return false;" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go.png" alt="보물찾으러 Go" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go_arrow.png" alt="" /></span></a>
					</div>
				<% end if %>

				<% if left(currenttime,10) >= "2017-04-16" then %>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/img_hint_0416.png" alt="4월 16일 힌트 디지털/핸드폰 카테고리에서 usb선풍기 상품 중 파랑색박스를 찾아라!" /></p>
						<div class="check">
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
						</div>
						<div class="line"><span></span><span></span><span></span></div>
						<a href="" onclick="goCateLink('102110103101'); return false;" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go.png" alt="보물찾으러 Go" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go_arrow.png" alt="" /></span></a>
					</div>
				<% end if %>

				<% if left(currenttime,10) >= "2017-04-17" then %>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/img_hint_0417.png" alt="4월 17일 힌트 키친 카테고리에서 티팟 상품 중 초록색박스를 찾아라!" /></p>
						<div class="check">
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/ico_check.png" alt="" /></span>
						</div>
						<div class="line"><span></span><span></span><span></span></div>
						<a href="" onclick="goCateLink('112101102'); return false;" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go.png" alt="보물찾으러 Go" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_go_arrow.png" alt="" /></span></a>
					</div>
				<% end if %>

				</div>
			</div>

			<div class="btnGuide">
				<a href="#lyGuide" class="layer"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/btn_guide.png" alt="보물 찾는 방법" /></a>
			</div>
		</div>

		<!-- count -->
		<div class="count">
			<div class="no">
				<div class="inner">
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/txt_score_01_v2.png" alt="보물찾기 SCORE" /></span><b><%= myevtcnt %></b><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/txt_score_02.png" alt="개" /></span>
				</div>
			</div>
			<p class="one"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/txt_one.png" alt="응모는 하루에 한번만 가능합니다" /></p>
		</div>

		<div class="noti">
			<h3>이벤트 유의사항</h3>
			<ul>
				<li>본 이벤트는 ID당 하루에 한 번 응모 가능합니다.</li>
				<li>당첨자는 총 100명으로, 4월 20일 공지사항을 통해 발표합니다.</li>
				<li>보물힌트는 하루에 하나씩 공개됩니다.</li>
			</ul>
		</div>

		<% '' sns %>
		<div class="sns">
			<%=snsHtml%>
		</div>

		<div class="bnr">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/common/m/tit_event_more.gif" alt="이벤트 더보기" /></h3>
			<ul>
				<li><a href="eventmain.asp?eventid=77059"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/common/m/img_bnr_index.jpg" alt="소품전 이벤트 메인페이지 가기" /></a></li>
				<li><a href="eventmain.asp?eventid=77060"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/common/m/img_bnr_sopumland.jpg" alt="매일 만나는 다양한 테마기획전" /></a></li>
				<li><a href="eventmain.asp?eventid=77064"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/common/m/img_bnr_sticker.jpg" alt="당신의 일상에 스티커를 붙여주세요!" /></a></li>
			</ul>
		</div>

		<div id="dimmed" <%=chkIIF(myevtdaycnt>0,"style='display:none'","")%>></div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->