<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
dim gnbflag
gnbflag = RequestCheckVar(request("gnbflag"),1)

If gnbflag = "" Then '//gnb 숨김 여부
	gnbflag = true 
Else 
	gnbflag = False
	strHeadTitleName = "2018 다이어리"
End if
%>
<link rel="stylesheet" type="text/css" href="/lib/css/diary2018.css" />
<script type="text/javascript">
$(function() {
	var swiper = new Swiper(".rolling .swiper-container", {
		pagination:".rolling .pagination",
		paginationClickable:true,
		autoplay:3000,
		loop:true,
		speed:600,
		nextButton:'.rolling .btn-next',
		prevButton:'.rolling .btn-prev'
	});
});
</script>
</head>
<body >
	<!-- contents -->
	<div id="content" class="content diary-gift">
		<h2><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/tit_gift.png" alt="구매금액별 사은품 AND 무료배송" /></h2>
		<div><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/img_gift_terms_sold.jpg" alt="1만원 이상 구매 시 마스킹테이프 랜덤 증정/3만원 이상 구매 시 홀로그램 파일증정,5만원 이상 구매 시 메모판+자석 증정" /></div>
		<p><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/txt_brand.jpg" alt="나의 생각과 일상을 기록하는 그곳, 텐바이텐 다이어리 스토리’  오직 텐바이텐에서 만나볼 수 있는 문라잇펀치로맨스와 새로운 콜라보 상품을 제작 했습니다." /></p>
		<div class="rolling">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/img_gift_1.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/img_gift_2.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/img_gift_3.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/img_gift_4.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/img_gift_5.jpg" alt="" /></div>
				</div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="btn-prev">이전</button>
			<button type="button" class="btn-next">다음</button>
		</div>
		<div class="terms">
			<div class="inner">
				<h3>저기요!<em>다이어리스토리 사은품,<br />저도 받을 수 있나요?</em></h3>
				<p>2018 DIARY STORY 다이어리를 포함한 <span class="color-red">텐바이텐 배송 상품</span>으로 구매시, 사은품 증정 조건에 해당됩니다. 상품 상세 페이지에서 2018 DIARY STORY 배너를 확인하세요.</p>
			</div>
			<div class="ex"><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/img_gift_ex_v2.jpg" alt="상품 상세 페이지 속 다이어리 배너 확인" /></div>
			<div class="inner">
				<h4>[사은품 증정 예시]</h4>
				<ul>
					<li>- 2018 DIARY STORY 다이어리(9,000원) + 텐바이텐 배송상품(1,000원) 구매시 : [M.P.R] 마스킹테이프 1종 증정</li>
					<li>- 2018 DIARY STORY 다이어리(10,000원) + 2018 DIARY STORY 다이어리(20,000원) 구매시 : [M.P.R] 홀로그램 파일 증정</li>
				</ul>
				<a href="/event/eventmain.asp?eventid=80481" class="btnV16a btnRed2V16a btnLarge btnBlock mWeb">텐바이텐 배송상품 보러가기</a>
				<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=80481" onclick="fnAPPpopupEvent('80481'); return false;" class="btnV16a btnRed2V16a btnLarge btnBlock mApp">텐바이텐 배송상품 보러가기</a>
			</div>
		</div>
		<div class="noti">
			<h3>사은품 유의사항</h3>
			<ul>
				<li>사은품 증정기간은 2017.10.16 ~ 2017.12.31입니다.<br />(한정수량으로 조기품절 될 수 있습니다.)</li>
				<li>2018 DIARY STORY 다이어리 포함 텐바이텐 배송상품<br />1/ 3/ 5만원 이상 구매시 증정 됩니다.<br />(쿠폰, 할인카드 등 사용 후 구매확정금액 기준)</li>
				<li>환불 및 교환으로 기준 금액 미만이 될 경우 사은품은 반품해주셔야 합니다.</li>
				<li>모든 사은품의 옵션은 랜덤 증정 됩니다.</li>
				<li>다이어리 구매 개수에 관계없이 총 구매금액이 조건 충족 시<br />사은품이 증정됩니다.</li>
				<li>비회원 구매 시 사은품 증정에서 제외됩니다.</li>
			</ul>
		</div>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/apps/appcom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>