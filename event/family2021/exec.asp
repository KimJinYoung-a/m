<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 가정의달 2021
' History : 2020-04-06 김형태 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	dim gnbflag , testmode
	gnbflag = RequestCheckVar(request("gnbflag"),1)
	testmode = RequestCheckVar(request("testmode"),1)

	If gnbflag <> "" Then '//gnb 숨김 여부
		gnbflag = true
	Else 
		gnbflag = False
		strHeadTitleName = "가정의 달"
	End if
%>
<style>[v-cloak] { display: none; }</style>
<!-- MD 2021 가정의달 : Love is Now (M/A) -->
<link rel="stylesheet" type="text/css" href="/event/family2021/family2021.css?v=1.02">
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script>
    $(function() {
        // slider
        $(".family2021 .slider").each(function(index, slider) {
            var slider = $(this).find('.swiper-container');
            var amt = slider.find('.swiper-slide').length;
            var progress = $(this).find('.pagination-progressbar-fill');
            if (amt > 1) {
                var evtSwiper = new Swiper(slider, {
                    autoplay: 2500,
                    loop: true,
                    speed: 1000,
                    autoplayDisableOnInteraction: false,
                    onInit: function(evtSwiper) {
                        var init = (1 / amt).toFixed(2);
                        progress.css('transform', 'scaleX(' + init + ') scaleY(1)');
                    },
                    onSlideChangeStart: function(evtSwiper) {
                        var activeIndex = evtSwiper.activeIndex;
                        var realIndex = parseInt(evtSwiper.slides.eq(activeIndex).attr('data-swiper-slide-index') || activeIndex, 10);
                        var calc = ( (realIndex+1) / amt ).toFixed(2);
                        progress.css('transform', 'scaleX(' + calc + ') scaleY(1)');
                    }
                });
            } else {
                var evtSwiper = new Swiper(slider, {
                    noSwiping: true,
                    noSwipingClass: '.noswiping'
                });
                $(this).find('.pagination-progressbar').hide();
            }
        });
        // 상품가격
        fnApplyItemInfoList({
            items:"3733127,2336227,3134662,3189536,2324242",
            target:"itemList1",
            fields:["image","name","price","sale","wish","evaluate"],
            unit:"hw",
            saleBracket:false
        });
        fnApplyItemInfoList({
            items:"2702544,2588063,2772222,2769488,2521749",
            target:"itemList2",
            fields:["image","name","price","sale","wish","evaluate"],
            unit:"hw",
            saleBracket:false
        });
        fnApplyItemInfoList({
            items:"2792013,3723926,3675412,2617693,1646098",
            target:"itemList3",
            fields:["image","name","price","sale","wish","evaluate"],
            unit:"hw",
            saleBracket:false
        });
        fnApplyItemInfoList({
            items:"3101505,3726255,2147178,2397582,2322954",
            target:"itemList4",
            fields:["image","name","price","sale","wish","evaluate"],
            unit:"hw",
            saleBracket:false
        });
    });
</script>
<div class="family2021">
	<h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/tit_family2021.jpg" alt="Love is Now"></h2>
	<!-- 퍼블 수작업 영역 -->
	<section class="section s1">
		<div class="topic">
			<h3><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/tit_s01.jpg" alt="부모님 스승님"></h3>
			<span class="num"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/txt_s01.png" alt="01"></span>
		</div>
		<div class="slider">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_slide1_1.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=2820179" onclick="TnGotoProduct('2820179');return false;"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_slide1_2.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=2820178" onclick="TnGotoProduct('2820178');return false;"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_slide1_3.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=2332827" onclick="TnGotoProduct('2332827');return false;"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_slide1_4.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=3006026" onclick="TnGotoProduct('3006026');return false;"></a>
					</div>
				</div>
				<div class="pagination-progressbar"><span class="pagination-progressbar-fill"></span></div>
			</div>
		</div>
		<div class="items type-list">
			<ul id="itemList1">
				<li>
					<a href="/category/category_itemPrd.asp?itemid=3733127" onclick="TnGotoProduct('3733127');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item1_1.jpg" alt=""></div>
						<div class="desc">
							<p class="name">어버이날 용돈 선물 현금꽃다발</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2336227" onclick="TnGotoProduct('2336227');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item1_2.jpg" alt=""></div>
						<div class="desc">
							<p class="name">카네이션 무드등</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=3134662" onclick="TnGotoProduct('3134662');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item1_3.jpg" alt=""></div>
						<div class="desc">
							<p class="name">도라지미 2종 선물세트 (도라지정과 도라지청)</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=3189536" onclick="TnGotoProduct('3189536');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item1_4.jpg" alt=""></div>
						<div class="desc">
							<p class="name">카일리 카네이션 펄장미 꽃바구니</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2324242" onclick="TnGotoProduct('2324242');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item1_5.jpg" alt=""></div>
						<div class="desc">
							<p class="name">핑크작약 & 카네이션 2단 플라워 BOX</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
			</ul>
		</div>
	</section>
	<section class="section s2">
		<div class="topic">
			<h3><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/tit_s02.jpg" alt="우리 아이 조카"></h3>
			<span class="num"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/txt_s02.png" alt="02"></span>
		</div>
		<div class="slider">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_slide2_1.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=3724935" onclick="TnGotoProduct('3724935');return false;"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_slide2_2.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=3732511" onclick="TnGotoProduct('3732511');return false;"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_slide2_3.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=3543731" onclick="TnGotoProduct('3543731');return false;"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_slide2_4.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=3641502" onclick="TnGotoProduct('3641502');return false;"></a>
					</div>
				</div>
				<div class="pagination-progressbar"><span class="pagination-progressbar-fill"></span></div>
			</div>
		</div>
		<div class="items type-list">
			<ul id="itemList2">
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2702544" onclick="TnGotoProduct('2702544');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item2_1.jpg" alt=""></div>
						<div class="desc">
							<p class="name">팀슨키즈 원목 주방놀이 로즈골드 3단 디럭스</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2588063" onclick="TnGotoProduct('2588063');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item2_2.jpg" alt=""></div>
						<div class="desc">
							<p class="name">뽀로로 코딩컴퓨터</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2772222" onclick="TnGotoProduct('2772222');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item2_3.jpg" alt=""></div>
						<div class="desc">
							<p class="name">불이 들어오는 빨간지붕 이층집</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2769488" onclick="TnGotoProduct('2769488');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item2_4.jpg" alt=""></div>
						<div class="desc">
							<p class="name">써니앤펀 감열지 디지털 즉석카메라</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2521749" onclick="TnGotoProduct('2521749');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item2_5.jpg" alt=""></div>
						<div class="desc">
							<p class="name">접이식 초등학생 어린이 두발 성인킥보드</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
			</ul>
		</div>
	</section>
	<section class="section s3">
		<div class="topic">
			<h3><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/tit_s03.jpg" alt="커플 부부"></h3>
			<span class="num"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/txt_s03.png" alt="03"></span>
		</div>
		<div class="slider">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_slide3_1.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=3147005" onclick="TnGotoProduct('3147005');return false;"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_slide3_2.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=2797702" onclick="TnGotoProduct('2797702');return false;"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_slide3_3.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=3698504" onclick="TnGotoProduct('3698504');return false;"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_slide3_4.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=3489354" onclick="TnGotoProduct('3489354');return false;"></a>
					</div>
				</div>
				<div class="pagination-progressbar"><span class="pagination-progressbar-fill"></span></div>
			</div>
		</div>
		<div class="items type-list">
			<ul id="itemList3">
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2792013" onclick="TnGotoProduct('2792013');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item3_1.jpg" alt=""></div>
						<div class="desc">
							<p class="name">내맘대로 큐빅 14K 체인반지</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=3723926" onclick="TnGotoProduct('3723926');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item3_2.jpg" alt=""></div>
						<div class="desc">
							<p class="name">골라담는 곱창밴드 집게핀 헤어 박스 세트</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=3675412" onclick="TnGotoProduct('3675412');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item3_3.jpg" alt=""></div>
						<div class="desc">
							<p class="name">헤라 센슈얼 프레쉬 누드틴트 7ml</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2617693" onclick="TnGotoProduct('2617693');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item3_4.jpg" alt=""></div>
						<div class="desc">
							<p class="name">23.65 V2 Shoes</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=1646098" onclick="TnGotoProduct('1646098');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item3_5.jpg" alt=""></div>
						<div class="desc">
							<p class="name">커플 기프트세트/<br>거품 입욕제</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
			</ul>
		</div>
	</section>
	<section class="section s4">
		<div class="topic">
			<h3><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/tit_s04.jpg" alt="스무살"></h3>
			<span class="num"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/txt_s04.png" alt="04"></span>
		</div>
		<div class="slider">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_slide4_1.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=3482036" onclick="TnGotoProduct('3482036');return false;"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_slide4_2.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=3666162" onclick="TnGotoProduct('3666162');return false;"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_slide4_3.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=3666567" onclick="TnGotoProduct('3666567');return false;"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_slide4_4.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=3106422" onclick="TnGotoProduct('3106422');return false;"></a>
					</div>
				</div>
				<div class="pagination-progressbar"><span class="pagination-progressbar-fill"></span></div>
			</div>
		</div>
		<div class="items type-list">
			<ul id="itemList4">
				<li>
					<a href="/category/category_itemPrd.asp?itemid=3101505" onclick="TnGotoProduct('3101505');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item4_1.jpg" alt=""></div>
						<div class="desc">
							<p class="name">푸의 숲 속 산책 다이어리 ver.2</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=3726255" onclick="TnGotoProduct('3726255');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item4_2.jpg" alt=""></div>
						<div class="desc">
							<p class="name">생각보관함 그리드</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2147178" onclick="TnGotoProduct('2147178');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item4_3.jpg" alt=""></div>
						<div class="desc">
							<p class="name">기초부터 탄탄!! 데일리 메이크업</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2397582" onclick="TnGotoProduct('2397582');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item4_4.jpg" alt=""></div>
						<div class="desc">
							<p class="name">흙으로 만드는 나만의 접시</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2322954" onclick="TnGotoProduct('2322954');return false;">
						<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_item4_5.jpg" alt=""></div>
						<div class="desc">
							<p class="name">KALIMBA 17음계 칼림바 아프리카악기</p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
			</ul>
		</div>
	</section>

	<!-- for dev msg : 카테고리별 상품 -->
	<div id="itemlist"></div>
	<!-- //카테고리별 상품 -->

	<!-- 기획전 -->
	<section class="evt-wrap">
		<h3><img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/tit_evt.png" alt="EVENTS"></h3>
		<ul class="evt-list">
			<li>
				<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_evt_01.jpg" alt="어버이날">
				<a href="/event/eventmain.asp?eventid=110563" class="link mWeb"></a>
				<a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110563');return false;" class="link mApp"></a>
			</li>
			<li>
				<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_evt_02.jpg" alt="어린이날">
				<a href="/event/eventmain.asp?eventid=110295" class="link mWeb"></a>
				<a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110295');return false;" class="link mApp"></a>
			</li>
			<li>
				<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_evt_03.jpg" alt="로즈데이">
				<a href="/event/eventmain.asp?eventid=110470" class="link mWeb"></a>
				<a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110470');return false;" class="link mApp"></a>
			</li>
			<li>
				<img src="//webimage.10x10.co.kr/fixevent/event/2021/family/m/img_evt_04.jpg" alt="부부의날">
				<a href="/event/eventmain.asp?eventid=110528" class="link mWeb"></a>
				<a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110528');return false;" class="link mApp"></a>
			</li>
		</ul>
	</section>
	<!-- //기획전 -->
</div>
<!-- //MD 2021 가정의달 : Love is Now (M/A) -->

<!--Common Components-->
<script src="/vue/components/common/functions/common.js?v=1.00"></script>
<!--End Common Components-->

<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<% IF application("Svr_Info") = "Dev" or testmode = "1" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<script src="/vue/exhibition/components/item-wishnevaluate.js?v=1.00"></script>
<script src="/vue/exhibition/components/more-button_V2.js?v=1.01"></script>
<script src="/vue/exhibition/components/item-list.js?v=1.01"></script>
<script src="/vue/exhibition/modules/store_V2.js?v=1.01"></script>
<script src="/vue/exhibition/main/family2021/itemList.js?v=1.01"></script>
