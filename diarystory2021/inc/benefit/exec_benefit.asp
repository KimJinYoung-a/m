<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
'####################################################
' Description : 다이어리스토리 2021 사은품 안내 페이지
' History : 2020-09-02 정태훈 생성
'####################################################
%>
<% if isapp then %>
<% else %>
<header class="tenten-header header-popup">
	<div class="title-wrap">
		<h1>사은품 안내</h1>
		<button type="button" class="btn-close" onclick="goback();">닫기</button>
	</div>
</header>
<% end if %>
<div id="content" class="content diary2021 dr_benefit">
	<div class="dr_top">
		<figure><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_top.jpg" alt=""></figure>
		<section class="sect_bnf">
			<h2>텐바이텐이 준비한 <strong>특별한 선물</strong></h2>
			<div class="bnf bnf1">
				<div class="tip"><span>선물 스티커<i class="badge_gift"></i></span>가 붙은 상품 포함 구매시,<br> 금액대별 사은품 증정</div>
				<ul>
					<li class="soldout">
						<div class="bnf_info">
							<p><em>15,000원</em> 이상 구매시</p>
							<div class="bnf-name">다꾸파우치<span> (랜덤증정)</span></div>
						</div>
						<figure class="bnf_img"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_benefit1.png" alt=""></figure>
						<!--<figure class="bnf_img"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_benefit1_sold.png" alt=""></figure>-->
					</li>
					<li>
						<div class="bnf_info">
							<p><em>30,000원</em> 이상 구매시</p>
							<div class="bnf-name">히치하이커 스티커북<span> 또는 </span>1,000마일리지</div>
						</div>
						<figure class="bnf_img"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_benefit2.png" alt=""></figure>
						<!--<figure class="bnf_img"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_benefit2_sold.png" alt=""></figure>-->
					</li>
					<li>
						<div class="bnf_info">
							<p><em>60,000원</em> 이상 구매시</p>
							<div class="bnf-name">다꾸라벨기<span> 또는 </span>3,000마일리지</div>
						</div>
						<figure class="bnf_img"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_benefit3.png" alt=""></figure>
						<!--<figure class="bnf_img"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_benefit3_sold.png" alt=""></figure>-->
					</li>
				</ul>
			</div>
			<p class="bbl_ppl bbl_b">다이어리 사고 사은품 받자!</p>
			<% if isapp = 1 then %>
			<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '다이어리 스토리', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2021/index.asp')" class="btn_type2 btn_blk btn_block">
			<% else %>
			<a href="/diarystory2021/index.asp" class="btn_type2 btn_blk btn_block">
			<% end if %>
				2021 DIARY STORY 바로가기
			</a>
		</section>
	</div>
	<div class="bnf_detail">
		<h3>다꾸 파우치</h3>
		<div class="bnf_swiper swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_slide1_1.jpg" alt=""></div>
				<div class="swiper-slide"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_slide1_2.jpg" alt=""></div>
				<div class="swiper-slide"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_slide1_3.jpg" alt=""></div>
			</div>
			<div class="btn_nav btn_prev"></div>
			<div class="btn_nav btn_next"></div>
		</div>
		<div class="bnf_note"><p>오늘은 다꾸하는 날!</p><p>컬러풀한 다꾸 파우치에 다꾸 아이템을 쏙 - 넣어!</p><p>가까운 공원에서 다꾸를 해보면 어떨까요?</p><span>(색상 랜덤 증정)</span></div>
	</div>
	<div class="bnf_detail">
		<h3>히치하이커 스티커북</h3>
		<div class="bnf_swiper swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_slide2_1.jpg" alt=""></div>
				<div class="swiper-slide"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_slide2_2.jpg" alt=""></div>
				<div class="swiper-slide"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_slide2_3.jpg" alt=""></div>
			</div>
			<div class="btn_nav btn_prev"></div>
			<div class="btn_nav btn_next"></div>
		</div>
		<div class="bnf_note"><p>일상의 풍경을 담은 매거진 히치하이커,</p><p>나의 일상과 닮은 히치하이커 일러스트와</p><p>포토 스티커로 하루를 기록해보세요.</p></div>
		<% if isapp = 1 then %>
		<a href="javascript:fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=3109375');" class="btn_get btn_type2 btn_gry">
		<% else %>
		<a href="/category/category_itemPrd.asp?itemid=3109375" class="btn_get btn_type2 btn_gry">
		<% end if %>
		구매하러 가기<i class="i_arw_r1"></i></a>
	</div>
	<div class="bnf_detail">
		<h3>다꾸 라벨기</h3>
		<div class="bnf_swiper swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_slide3_1.jpg" alt=""></div>
				<div class="swiper-slide"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_slide3_2.jpg" alt=""></div>
			</div>
			<div class="btn_nav btn_prev"></div>
			<div class="btn_nav btn_next"></div>
		</div>
		<div class="bnf_note"><p>사랑스러운 핑크 컬러의 다꾸 라벨기로</p><p>전하고 싶은 말을 꾹꾹 눌러담아</p><p>나만의 DIY 다꾸, 폴꾸에 도전해보세요!</p></div>
		<div class="insta"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_insta.png" alt="다꾸 라벨기 인증샷 올리고 선물 또 받아가세요!"></div>
		<% if isapp = 1 then %>
		<a href="javascript:fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105489');" class="btn_evt">
		<% else %>
		<a href="/event/eventmain.asp?eventid=105489" class="btn_evt">
		<% end if %>
			<img src="//fiximage.10x10.co.kr/m/2020/diary2021/btn_daccutem.png" alt="찰떡 다꾸템 보러가기">
		</a>
	</div>
	<div class="noti">
		<h4>사은품 안내사항</h4>
		<ul>
			<li>1. 선물 스티커가 붙은 다이어리 상품 포함 15,000 원 이상 구매시 구매금액별 사은품을 받으실 수 있습니다.</li>
			<li>2. 선물스티커는 2021 다이어리 스토리 페이지에서 확인 가능합니다.</li>
			<li>3. 사은품은 한정수량으로 조기 품절 될 수 있으며, 하위 금액대의 상품을 선택할 수 있습니다.</li>
			<li>4. 사은품은 주문건당 1개 증정됩니다.</li>
			<li>5. 구매 상품을 취소하거나 반품하였을 경우 사은품을 반품해주셔야 하며, 마일리지의 경우 회수됩니다.</li>
			<li>6. 사은품으로 마일리지를 선택하실 경우 모든 상품 출고 완료 후 익일에 지급됩니다.</li>
			<li>7. 마일리지는 지급일로부터 30일 동안 사용 가능합니다. 사용기한 이후에는 자동 소멸됩니다.</li>
			<li>8. 비회원 구매시 사은품이 증정되지 않습니다</li>
		</ul>
	</div>
</div>
<script>
$(function(){
	var diaryEvtSwiper = new Swiper('.bnf_swiper', {
		loop:true,
		navigation: {
			nextEl: '.btn_next',
			prevEl: '.btn_prev',
		},
		autoplay:true,
	});
});
function goback(){
    history.back();
}
</script>