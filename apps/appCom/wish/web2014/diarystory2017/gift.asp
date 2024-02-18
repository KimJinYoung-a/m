<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 다이어리 스토리2017 GIFT 페이지
' History : 2016.09.30 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/diary2017.css" />
<script type="text/javascript">
$(function(){
	var swiper1 = new Swiper(".rolling .swiper-container", {
		pagination:".rolling .pagination",
		paginationClickable:true,
		autoplay:3000,
		loop:true,
		prevButton:'.rolling .prev',
		nextButton:'.rolling .next',
		speed:500
	});
	var swiper2 = new Swiper(".terms .swiper-container", {
		pagination:false,
		autoplay:1900,
		effect:'fade',
		loop:true,
		speed:600
	});
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry diarystory2017">
			<!-- content area -->
			<div class="content diaryGift" id="contentArea">
				<h2><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/tit_tenbyten_day.jpg" alt="OH TEN BY TEN DAY" /></h2>
				<div>
					<a href="/street/street_brand.asp?makerid=ohlollyday" class="mWeb"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/txt_lolly_day.png" alt="오롤리데이x텐바이텐" /></a>
					<a href="" onclick="fnAPPpopupBrand('ohlollyday'); return false;" class="mApp"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/txt_lolly_day.png" alt="오롤리데이x텐바이텐" /></a>
				</div>
				<div class="terms">
					<ul>
						<li>
							<span class="soldout"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/txt_soldout.png" alt="SOLD OUT" /></span>
							<img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/img_gift_01.jpg" alt="1만원 이상 구매시 [O,TD!] 체크메모패드" />
						</li>
						<li>
							<span class="soldout"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/txt_soldout.png" alt="SOLD OUT" /></span>
							<img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/img_gift_02.jpg" alt="2만원 이상 구매시 [O,TD!] 문구세트" />
						</li>
						<li>
							<span class="soldout"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/txt_soldout.png" alt="SOLD OUT" /></span>
							<img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/img_gift_03_v2.jpg" alt="4만원 이상 구매시 [O,TD!] 보조배터리 200mAh" />
							<div class="swiper-container">
								<div class="swiper-wrapper">
									<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/img_gift_slide_01.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/img_gift_slide_02.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/img_gift_slide_03.jpg" alt="" /></div>
								</div>
							</div>
						</li>
					</ul>
					<p><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/txt_terms.jpg" alt="" /></p>
				</div>
				<div class="rolling">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<div class="video"><iframe src="https://player.vimeo.com/video/190516509" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>
							</div>
							<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/img_slide_01.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/img_slide_02.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/img_slide_03.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/img_slide_04.jpg" alt="" /></div>
						</div>
						<div class="pagination"></div>
						<button type="button" class="prev"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/btn_prev.png" alt="이전" /></button>
						<button type="button" class="next"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/btn_next.png" alt="다음" /></button>
					</div>
				</div>
				<div class="giftGuide">
					<div class="giftTerms">
						<div class="textCont">
							<h3 class="cRd1"><strong>저기요!</strong></h2>
							<p class="fs1-3r tMar0-3r">다이어리 스토리 사은품, <strong>저도 받을 수 있나요?</strong></p>
							<p class="tMar0-8r">2017 DIARY STORY 다이어리를 포함한 <span class="cRd1">텐바이텐 배송 상품</span>으로 구매시, 사은품 증정 조건에 해당됩니다. 상품 상세 페이지에서 2017 DIARY STORY 배너를 확인하세요.</p>
						</div>
						<div><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/img_gift_ex.jpg" alt="" /></div>
						<div class="textCont">
							<h4 class="cBk1V16a fs1-2r"><strong>[사은품 증정 예시]</strong></h4>
							<ul class="exList">
								<li>- 2017 DIARY STORY 다이어리(9,000원) + 텐바이텐 배송상품(1,000원) 구매시 : O,TD! 체크메모패드</li>
								<li>- 2017 DIARY STORY 다이어리(10,000원) + 2017 DIARY STORY 다이어리(10,000원) 구매시 : O,TD! 문구세트</li>
							</ul>
							<a href="/event/eventmain.asp?eventid=73440" class="mWeb"><img src="http://fiximage.10x10.co.kr/m/2015/diarystory2016/btn_ten_deliver.gif" alt="텐바이텐 배송상품 보러가기" /></a>
							<a href="" onclick="fnAPPpopupEvent('73440'); return false;" class="mApp"><img src="http://fiximage.10x10.co.kr/m/2015/diarystory2016/btn_ten_deliver.gif" alt="텐바이텐 배송상품 보러가기" /></a>
						</div>
					</div>
					<div class="giftNoti">
						<h3>사은품 유의사항</h2>
						<ul class="tMar1r">
							<li>다이어리 스토리 사은 이벤트는 텐바이텐 회원님을 위한 혜택입니다. (비회원 구매 시, 증정 불가)</li>
							<li>사은품 증정기간은  2016.10.04 ~ 2016.12.31 입니다. (한정수량으로 조기품절 될 수 있습니다.)</li>
							<li>2017 DIARY STORY 다이어리 포함 텐바이텐 배송상품 1/ 2/ 4만원 이상 구매시 증정 됩니다. (쿠폰, 할인카드 등 사용 후 구매확정금액 기준)</li>
							<li>환불 및 교환으로 기준 금액 미만이 될 경우 사은품은 반품해주셔야 합니다.</li>
							<li>모든 사은품의 옵션은 랜덤 증정 됩니다.</li>
							<li>다이어리 구매 개수에 관계없이 총 구매금액이 조건 충족시 사은품이 증정됩니다.</li>
						</ul>
					</div>
				</div>
			</div>
			<!--// content area -->
			<!-- #include virtual="/apps/appcom/wish/web2014/lib/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
