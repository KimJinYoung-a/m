<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/diary2019.css?v=2.01" />
<script type="text/javascript">
$(document).ready(function(){
	fnAmplitudeEventMultiPropertiesAction('view_diary_gift','','');		
});
function goback(){
    history.back();
}
</script>
</head>
<body class="default-font <%=chkiif(isapp,"","body-popup")%>">
    <% if isapp then %>
    <% else %>
	<header class="tenten-header header-popup">
		<div class="title-wrap">
			<h1>사은품 안내</h1>
			<button type="button" class="btn-close" onclick="goback();">닫기</button>
		</div>
	</header>
    <% end if %>

	<div id="content" class="content" style="padding-bottom:0;">
		<div class="gift-layer">
		<% if date() > "2018-12-11" then  %>
			<div><img src="http://fiximage.10x10.co.kr/web2018/diary2019/m/img_gift_1.jpg" alt="일러스트레이터 이공 세상이 아름답지 않다고, 혹은 불안정하거나 다듬어지지 않았다고 말하는 것들을 오롯이 껴안아 반짝이게 만드는 일러스트레이터"></div>
			<h2><img src="http://fiximage.10x10.co.kr/web2018/diary2019/m/tit_gift_v2.jpg" alt="테바이텐 일러스트레이터 이공 콜라보 스탠다드러브댄스 키링 증정"></h2>
			<div><img src="http://fiximage.10x10.co.kr/web2018/diary2019/m/txt_about_gift.png" alt="세상이 아름답지 않다고, 혹은 불안정하거나 다듬어지지 않았다고 말하는 것들을 오롯이 껴안아 반짝이게 만드는 일러스트레이터 이공.
				REMEMBER YOUR GIRLHOOD 라는 슬로건 아래, 추억할 수 있는 또는 추억을 만들어주고 싶은 그림을 그리고 있습니다. 현재 연남동에 일러스트레이션 굿즈 샵 겸 스튜디오인 스탠다드러브댄스를 운영중입니다. "></div>
			<ul class="noti">
				<li>- 기간 : 2018년 9월 17일 ~ 12월 31일 (한정수량으로 조기 품절 될 수 있습니다)</li>
				<li>- 환불 및 교환으로 인해 증정 기준 금액이 미달될 경우, 사은품을 반품해 주셔야 합니다.</li>
				<li>- 사은품 불량으로 인한 교환은 불가능합니다.</li>
				<li>- 비회원 구매 시 사은품 증정에서 제외됩니다.</li>
			</ul>
		<% else %>
			<script type="text/javascript">
			$(function(){
				giftSlide = new Swiper('.giftSlide .swiper-container',{
					loop:true,
					autoplay:800,
					effect:'fade',
					autoplayDisableOnInteraction:false,
					speed:1200,
					pagination:false,
					paginationClickable:true,
					nextButton:false,
					prevButton:false,
				});
				$(window).on("orientationchange",function(){
					var oTm = setInterval(function () {
						slideTemplate.reInit();
							clearInterval(oTm);
					}, 500);
				});
			});
			</script>
			<div class="swiper giftSlide">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/web2018/diary2019/m/img_pop_snoopy_1.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/web2018/diary2019/m/img_pop_snoopy_2.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/web2018/diary2019/m/img_pop_snoopy_3.jpg" alt="" /></div>
					</div>
				</div>
			</div>
			<div><img src="http://fiximage.10x10.co.kr/web2018/diary2019/m/txt_gift.jpg" alt="텐텐배송 15,000원 이상 회원 구매시 스티커 2종 증정"></div>
			<ul class="noti" style="background-color:#f2f2f2; color:#888">
				<li>- 기간 : 2018년 11월 25일 ~ 12월 31일 (한정수량으로 조기 품절 될 수 있습니다)</li>
				<li>- 사은품은 쿠폰 등과 같은 할인 수단 사용 후, 구매확정 금액을 기준으로 증정됩니다.</li>
				<li>- 다이어리 구매 개수에 관계없이 총 구매금액 조건 충족 시 사은품이 증정됩니다.</li>
				<li>- 환불 및 교환으로 인해 증정 기준 금액이 미달될 경우, 사은품을 반품해 주셔야 합니다.</li>
				<li>- 사은품 불량으로 인한 교환은 불가능합니다.</li>
				<li>- 비회원 구매 시 사은품 증정에서 제외됩니다.</li>
			</ul>
		<% end if %>
		</div>
	</div>
	<!-- #include virtual="/lib/inc/incfooter.asp" -->
</body>
</html>