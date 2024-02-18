<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 그린 크리스박스-이니스프리 MA
' History : 2016-11-24 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim eCode, userid

IF application("Svr_Info") = "Dev" THEN
	eCode = "66243"
Else
	eCode = "74541"
End If

userid = getEncLoginUserID

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("[텐바이텐] 그린 크리스박스")
snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=74541")
snpPre = Server.URLEncode("10x10 이벤트")

'기본 태그
snpTag = Server.URLEncode("텐바이텐 그린 크리스박스")
snpTag2 = Server.URLEncode("#10x10")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 그린 크리스박스\n\n텐바이텐과 이니스프리가\n놀라운 크리스박스를\n준비했습니다.\n\n배송비 2,000원만 내면\n구매할 수 있는\n엄청난 혜택을\n직접 확인해보세요!\n\n오직 텐바이텐에서!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/74541/m/img_kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
if isapp then
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
Else
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
end if

%>
<style type="text/css">
.greenChrisbox {position:relative;}
.greenChrisbox img {vertical-align:top;}
.greenChrisbox button {background-color:transparent;}

.greenChrisbox .event {position:relative; background-color:#1d6441;}
.greenChrisbox .event .figure {position:relative;}
.greenChrisbox .event .figure .btnView {position:absolute; top:10.64%; right:4.68%; width:13.28%;}
.greenChrisbox .event .figure .btnView {
	animation-name:bounce; animation-iteration-count:5; animation-duration:1.2s;
	-webkit-animation-name:bounce; -webkit-animation-iteration-count:5; -webkit-animation-duration:1.2s;
}
@keyframes bounce {
	from, to{margin-right:0; animation-timing-function:ease-out;}
	50% {margin-right:-5px; animation-timing-function:ease-in;}
}
@-webkit-keyframes bounce {
	from, to{margin-right:0; animation-timing-function:ease-out;}
	50% {margin-right:-5px; animation-timing-function:ease-in;}
}

.greenChrisbox .event .btnGet {display:block; position:absolute; bottom:10%; left:50%; width:81.25%; margin-left:-40.625%;}


.greenChrisbox .event .random {position:absolute; bottom:6%; left:0; width:100%;}

/* layer popup */
.lyContent {display:none; position:absolute; top:4.5%; left:50%; z-index:30; width:85.78%; margin-left:-42.89%;}
.lyContent .btnClose {display:block; position:absolute; z-index:30; top:-2%; right:-5%; width:9.64%; padding:2%; color:transparent;}
.lyContent .btnClose img {transition:transform .7s ease; -webkit-transition:transform .7s ease;}
.lyContent .btnClose:active img {transform:rotate(-180deg); -webkit-transform:rotate(-180deg);}

.lyContent .btnClick, 
.lyContent .btnDownload {position:absolute; bottom:12%; left:50%;width:70.4%; margin-left:-35.2%;}
.lyContent .btnDownload {bottom:20%;}
.lyContent .outer {padding-top:2%;}
.lyContent .inner {position:relative; width:100%; height:100%;}
.lyContent .swiper-container {position:absolute; left:50%; top:19%; width:92.53%; height:75%; margin-left:-46.265%; z-index:50;}
.lyContent .swiper-wrapper {width:90%;}
.lyContent .swiper-wrapper .swiper-slide {width:100%;}
.lyContent .swiper-container-vertical > .swiper-scrollbar {right:3%;}

#lyWin {width:78.5%; margin-left:-39.25%;}
#lyWin .btnClose {top:5%; right:8%; width:9.16%;}
#dimmed {display:none; position:absolute; top:0; left:0; z-index:20; width:100%; height:100%; background:rgba(0, 0, 0, 0.5);}

.greenChrisbox .innisfree {background-color:#b92813;}
.greenChrisbox .innisfree .desc1 {position:relative;}
.greenChrisbox .innisfree .desc1 .btnMore {position:absolute; bottom:0; left:50%; width:62.5%; margin-left:-31.25%;}
.greenChrisbox .innisfree .desc2 {padding-top:5.64%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/74541/m/bg_light.jpg) no-repeat 50% 0; background-size:100% auto;}

.video {width:74.2%; margin:0 auto; padding:1.2%; background-color:#e8462f;}
.video .youtube {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background:#000;}
.video .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%}

.rolling {width:80.46%; margin:0 auto; padding:6% 0 8%;}
.rolling .swiper {position:relative; overflow:visible;}
.rolling .swiper .swiper-container {width:100%;}
.rolling button {position:absolute; top:24%; z-index:5; width:7.1%; padding:5% 2%; background-color:transparent;}
.rolling .swiper .btn-prev {left:-5%;}
.rolling .swiper .btn-next {right:-4.8%;}
.rolling .swiper .pagination {height:auto; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; width:6px; height:6px; margin:0 0.3rem; background-color:#4e1c1f; cursor:pointer; transition:all 0.5s ease;}
.rolling .swiper .pagination .swiper-active-switch {width:12px; border-radius:12px; background-color:#fff;}

.greenChrisbox .sns {position:relative;}
.greenChrisbox .sns ul {overflow:hidden; position:absolute; top:30%; right:6%; width:40%;}
.greenChrisbox .sns ul li {float:left; width:50%;}
.greenChrisbox .sns ul li a {display:block; margin-left:21%;}

.noti {padding:2.5rem 1.1rem; background-color:#681b10;}
.noti h3 {color:#fcc148; font-size:1.4rem; font-weight:bold;}
.noti h3 span {border-bottom:2px solid #fcc148;}
.noti ul {margin-top:5%;}
.noti ul li {position:relative; margin-top:0.15rem; padding-left:1rem; color:#fff; font-size:1.1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:4px; height:4px; border-radius:50%; background-color:#d69d27;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt74541").offset().top+30}, 0);
});
var giftScroll;
$(function(){
	giftScroll = new Swiper("#lyItem .swiper-container", {
		scrollbar:"#lyItem .swiper-scrollbar",
		direction:"vertical",
		slidesPerView:"auto",
		mousewheelControl:true,
		freeMode:true
	});

	/* swiper js */
	mySwiper = new Swiper('#rolling .swiper-container',{
		loop:true,
		autoplay:3000,
		speed:1000,
		pagination:"#rolling .pagination",
		paginationClickable:true,
		nextButton:'#rolling .btn-next',
		prevButton:'#rolling .btn-prev',
		effect:"fade"
	});

	$("#btnView").click(function(){
		$("#lyItem").show();
		$("#dimmed").show();
		window.$('html,body').animate({scrollTop:100}, 500);
		giftScroll.update();
	});

	$("#lyItem .btnClose, #lyWin .btnClose").click(function(){
		$("#lyItem").hide();
		$("#lyWin").hide();
		$("#dimmed").fadeOut();
	});
});

///////////////////////////////////////////////////////
function btnClose(){
	$("#lyWin").hide();
	$("#dimmed").hide();
	$("#dimmed").fadeOut();
}

function getcoupon(){
<% If IsUserLoginOK() Then %>
	<% If Now() > #11/23/2016 10:00:00# and Now() < #12/02/2016 23:59:59# Then %>
		var result;
			$.ajax({
				type:"GET",
				url:"/event/etc/doeventsubscript/doEventSubscript74541.asp",
				data: "mode=I",
				dataType: "text",
				async:false,
				success : function(Data){
					result = jQuery.parseJSON(Data);
					if (result.resultcode=="11"){
						$("#lyWin").empty().html(result.lypop);
						$("#lyWin").show();
						$("#dimmed").show();
						window.$('html,body').animate({scrollTop:100}, 500);
					}
					else if (result.resultcode=="00"){
						alert('잠시 후 다시 시도해 주세요.');
						return;
					}
					else if (result.resultcode=="99"){
						alert('오늘은 이미 응모 하셨습니다.');
						return;
					}
					else if (result.resultcode=="33"){
						alert('이벤트 응모 기간이 아닙니다.');
						return;
					}
					else if (result.resultcode=="44"){
						alert('로그인후 이용하실 수 있습니다.');
						return;
					}
					else if (result.resultcode=="88"){
						alert('잘못된 접근 입니다.');
						return;
					}
					else if (result.resultcode=="E0"){
						alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오.');
						return;
					}
					else if (result.resultcode=="ER"){
						alert('데이터 처리에 예외 상황이 발생하였습니다. 관리자에게 문의해주십시오.');
						return;
					}
					else if (result.resultcode=="999"){
						alert('오류가 발생했습니다.');
						return false;
					}else{
						alert('오류가 발생했습니다..');
						return false;
					}
				}
			});
	<% else %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% end if %>
<% Else %>
	<% if isApp=1 then %>
		calllogin();
		return false;
	<% else %>
		jsevtlogin();
		return false;
	<% end if %>
<% End IF %>
}

function goDirOrdItem(tm){
<% If IsUserLoginOK() Then %>
	<% If Now() > #11/23/2016 10:00:00# and Now() < #12/02/2016 23:59:59# Then %>
		$("#itemid").val(tm);
		<% if isapp="1" then %>
	        document.directOrd.target = "iiBagWin";
		<% end if %>
		document.directOrd.submit();
	<% else %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% end if %>
<% Else %>
	<% if isApp=1 then %>
		calllogin();
		return false;
	<% else %>
		jsevtlogin();
		return false;
	<% end if %>
<% End IF %>
}

function snschk(snsnum) {
	if(snsnum == "tw") {
		popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
	}else if(snsnum=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
	}else if(snsnum=="ka"){
		parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}
</script>
	<div class="mEvt74541 greenChrisbox">
		<div class="section event">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/txt_green_christmas.jpg" alt="텐바이텐과 이니스프리가 함께하는 그린 크리스박스 배송비 2,000원만 결제하면 그린 크리스박스가 갑니다!" /></p>
			<div class="figure">
				<img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/img_green_chrisbox.jpg" alt="그린 크리스박스" />
				<a href="#lyItem" id="btnView" class="btnView"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/btn_view.png" alt="상품 더보기" /></a>
			</div>

			<%' for dev msg : 응모하기 버튼 %>
			<button type="button" id="btnGet" onclick="getcoupon(); return false;" class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/btn_get.png" alt="응모하기" /></button>
			<p class="random"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/txt_random.png" alt="그린 크리스박스는 배송비만 결제하면 위 상품 중 한가지 상품이 랜덤으로 담겨 발송됩니다" /></p>
		</div>

		<%' for dev msg : 당첨 상품 리스트 %>
		<div id="lyItem" class="lyContent">
			<div class="outer">
				<div class="inner">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/img_gift.jpg" alt="당첨 상품 리스트 2016 그린크리스마스 DIY 뮤직박스, 센티드 캔들 100g, 비즈왁스 타블렛, 세컨드 스킨 마스크 4종 세트, 마이바디 미니어처 세트, 제주 퍼퓸드 핸드크림 3동 기프트 세트, 마이쿠션 케이스" /></p>
							</div>
						</div>
						<div class="swiper-scrollbar"></div>
					</div>
					<img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/img_box_v2.png" alt="" />
				</div>
				<button type="button" class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/btn_close_01.png" alt="당첨 상품 리스트 레이어팝업 닫기" /></button>
			</div>
		</div>

		<%' for dev msg : 당첨 레이어 팝업 %>
		<div id="lyWin" class="lyContent" style="display:none">
		</div>

		<div class="section innisfree">
			<div class="desc desc1">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/txt_campaign.jpg" alt="2016 이니스프리 그린 크리스마스 My Green Christmas 이니스프리 그린 크리스마스는 나의 즐거움이 누군가에게 따뜻함으로 전해지도록DIY키트를 통해 행복을 나누는 캠페인입니다" /></p>
				<a href="http://innisfree.co.kr/event/greenchristmas2016/gatePc.jsp" onclick="fnAPPpopupExternalBrowser('http://innisfree.co.kr/event/greenchristmas2016/gatePc.jsp'); return false;" target="_blank" title="My Green Christmas 캠페인으로 이동 새창" class="btnMore"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/btn_campaign.png" alt="캠페인 자세히 보기" /></a>
			</div>

			<div class="desc desc2">
				<div class="video">
					<div class="youtube">
						<iframe src="https://www.youtube.com/embed/mildxmge27Q?list=PLQ629BV8uoazzUT3JhWmQ696pTI8Arg0N" title="이니스프리 My Green Christmas 민호의 그린 크리스마스 이야기" frameborder="0" allowfullscreen></iframe>
					</div>
				</div>

				<div id="rolling" class="rolling">
					<div class="swiper">
						<div class="swiper-container">
							<ul class="swiper-wrapper">
								<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/img_slide_01.png" alt="이니스프리 크리스마스 LTD 에디션을 사면" /></li>
								<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/img_slide_02.png" alt="DIY 뮤직박스 할인가 2,000원에 구매 가능" /></li>
								<li class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/img_slide_03.png" alt="DIY 뮤직박스 판매금 중 일부는 세이브더칠드런에 기부" /></li>
							</ul>
						</div>
						<div class="pagination"></div>
						<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/btn_prev.png" alt="이전" /></button>
						<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/btn_next.png" alt="다음" /></button>
					</div>
				</div>
			</div>
		</div>

		<%' for dev msg : sns %>
		<div class="sns">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/txt_sns.jpg" alt="친구에게 SNS로  그린 크리스박스 알려주고, 즐거운 혜택 나눠갖자!" /></p>
			<ul>
				<li class="facebook"><a href="" onclick="snschk('fb');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/img_sns_facebook.png" alt="페이스북에 공유하기" /></a></li>
				<li class="kakao"><a href="" onclick="snschk('ka');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/img_sns_kakao.png" alt="카카오톡으로 공유하기" /></a></li>
			</ul>
		</div>

		<div class="noti">
			<h3><span>이벤트 주의사항</span></h3>
			<ul>
				<li>본 이벤트는 텐바이텐에서만 참여 가능합니다.</li>
				<li>본 이벤트는 로그인 후에 참여할 수 있습니다.</li>
				<li>ID당 1일 1회만 응모 가능합니다.</li>
				<li>무료배송쿠폰은 발급 당일 자정 기준으로 자동 소멸됩니다. (텐바이텐 배송 상품 1만원 이상 구매 시 사용 가능)</li>
				<li>이벤트 내 모든 상품의 컬러는 랜덤으로 발송되며, 선택이 불가능합니다.</li>
				<li>이벤트는 상품 품절 시 조기 마감될 수 있습니다.</li>
				<li>이벤트는 즉시 결제로만 구매가 가능하며, 배송 후 반품/교환/구매취소가 불가능합니다.</li>
				<li>당첨된 상품은 당첨 당일 구매하셔야 결제 가능합니다. (익일 결제불가)</li>
			</ul>
		</div>

		<div id="dimmed"></div>
	</div>
	<!--//74541 -->
<% if isapp then %>
	<form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
		<input type="hidden" name="itemid" id="itemid" value="">
		<input type="hidden" name="itemoption" value="0000">
		<input type="hidden" name="itemea" readonly value="1">
		<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
		<input type="hidden" name="isPresentItem" value="" />
	    <input type="hidden" name="mode" value="DO3">
	</form>
<% else %>
	<form method="post" name="directOrd" action="/inipay/shoppingbag_process.asp">
		<input type="hidden" name="itemid" id="itemid" value="">
		<input type="hidden" name="itemoption" value="0000">
		<input type="hidden" name="itemea" readonly value="1">
		<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
		<input type="hidden" name="isPresentItem" value="" />
		<input type="hidden" name="mode" value="DO1">
	</form>
<% end if %>
<iframe src="" name="iiBagWin" frameborder="0" width="0" height="0"></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->