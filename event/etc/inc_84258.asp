<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 케이스팔레트
' History : 2018-01-30 김송이 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<style>
.case-palette {padding-bottom:2.5rem; background-color:#fff;}
.case-palette .inner {width:27.74rem; margin:0 auto;}
.slideTemplateV15 {margin:-8.53rem 0 1.71rem;}
.slideTemplateV15 .pagination span.swiper-active-switch {width:0.7rem; margin:0 0.6rem;}
.slideTemplateV15 .btnPrev {left:.4rem;}
.slideTemplateV15 .btnNext {right:.4rem;}
.best-hot {position:relative; margin-top:3rem; padding-bottom:4.52rem;}
.best-hot h3 {position:absolute; left:0; top:0; width:13.22rem;}
.best-hot .list {overflow:hidden;}
.best-hot .list li {float:left; width:50%; height:21rem; text-align:center; padding-right:0.68rem;}
.best-hot .list li > a {display:block;}
.best-hot .list li:nth-child(odd) {padding-right:0; padding-left:0.68rem;}
.best-hot .list li:first-child {margin-left:50%;}
.best-hot .list li p {padding-top:0.85rem; line-height:1; color:#666;}
.best-hot .list li .price {padding-top:0.6rem; color:#e52e2e; font-weight:bold;}
.best-hot .list li .price s {font-weight:normal; color:#666;}
.new-wish .swiper {position:relative; margin:2.56rem 0 5.12rem;}
.new-wish .slideNav {position:absolute; top:0; z-index:10; width:3rem; height:100%; background:transparent; text-indent:-999em;}
.new-wish .btnPrev {left:-2.13rem;}
.new-wish .btnNext {right:-2.13rem;}
.new-wish .slideNav:after {content:''; display:block; position:absolute; top:40%; width:1rem; height:1rem; margin-left:-0.5rem; border-left:0.17rem solid #747474; border-bottom:0.17rem solid #747474;}
.new-wish .btnPrev:after {right:0.4rem; transform:rotate(45deg);}
.new-wish .btnNext:after {left:0.8rem; transform:rotate(-135deg);}
.related-event li {position:relative; margin-bottom:1.71rem;}
.related-event .btn-group {overflow:hidden; position:absolute; left:5%; bottom:0; width:90%; height:40%;}
.related-event .btn-group a {display:block; float:left; width:33.33333%; height:100%; text-indent:-999em;}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script type="text/javascript">
$(function(){
	fnApplyItemInfoList({
		items:"1857410,1844112,1875171,1870952,1772828,1736127,1732220", // 상품코드
		target:"list",
		fields:["soldout","price","sale"],
		unit:"hw",
		saleBracket:true
	});
	slideTemplate = new Swiper('.slideTemplateV15 .swiper-container',{
		loop:true,
		autoplay:3000,
		autoplayDisableOnInteraction:false,
		speed:800,
		pagination:".slideTemplateV15 .pagination",
		paginationClickable:true,
		nextButton:'.slideTemplateV15 .btnNext',
		prevButton:'.slideTemplateV15 .btnPrev'
	});

	var swiper = new Swiper('.new-wish .swiper-container', {
		slidesPerView:3,
		//slidesPerGroup:3,
		nextButton:'.new-wish .btnNext',
		prevButton:'.new-wish .btnPrev'
	});
});
function jsViewItem(i){
	<% if isApp=1 then %>
		parent.fnAPPpopupProduct(i);
		return false;
	<% else %>
		top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
		return false;
	<% end if %>
}
</script>
<div class="mEvt84258 case-palette">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/tit_case_palette.jpg" alt="Phone case Palette" /></h2>
	<div class="inner">
		<!-- 관련 기획전 -->
		<div class="slideTemplateV15">
			<div class="swiper">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><a href="" onclick="jsEventlinkURL('84195'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/bnr_main_1.jpg" alt="Collection Chip" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsEventlinkURL('84191'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/bnr_main_2.jpg" alt="스마트폰을 스마트하게 사용하는 법" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsEventlinkURL('84174'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/bnr_main_3.jpg" alt="믿고보는 귀여움, 카카오프렌즈" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsEventlinkURL('84173'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/bnr_main_4.jpg" alt="POP한 일러스트 어프어프 1+1" /></a></div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="slideNav btnPrev">이전</button>
				<button type="button" class="slideNav btnNext">다음</button>
			</div>
		</div>
		<ul class="related-event">
			<li><a href="" onclick="jsEventlinkURL('84170'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/bnr_hold.jpg" alt="Holder" /></a></li>
			<li><a href="" onclick="jsEventlinkURL('84171'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/bnr_cable.jpg" alt="Cable" /></a></li>
			<li><a href="" onclick="jsEventlinkURL('84172'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/bnr_glass.jpg" alt="Glass Protector" /></a></li>
		</ul>
		<!-- Best/hot -->
		<div class="best-hot">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/tit_best_hot.png" alt="Best &amp; Hot 텐텐에서는 이게 핫해요!" /></h3>
			<ul id="list" class="list">
				<li>
					<a href="" onclick="jsViewItem('1857410&pEtr=82700'); return false;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_hot_1.jpg" alt="" />
						<p>Good Night! 케이스</p>
						<p class="price">30,400won<span>[10%]</span></p>
					</a>
				</li>
				<li>
					<a href="" onclick="jsViewItem('1844112&pEtr=82700'); return false;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_hot_2.jpg" alt="" />
						<p style="letter-spacing:-.8px;">Brunch Brother 실리콘 케이스</p>
						<p class="price"></p>
					</a>
				</li>
				<li>
					<a href="" onclick="jsViewItem('1875171&pEtr=82700'); return false;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_hot_3.jpg" alt="" />
						<p>세서미 젤리케이스 엘모</p>
						<p class="price"></p>
					</a>
				</li>
				<li>
					<a href="" onclick="jsViewItem('1870952&pEtr=82700'); return false;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_hot_4.jpg" alt="" />
						<p>봉쥬르 선인장 자수케이스</p>
						<p class="price"></p>
					</a>
				</li>
				<li>
					<a href="" onclick="jsViewItem('1772828&pEtr=82700'); return false;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_hot_5.jpg" alt="" />
						<p>OUR 하트케이스</p>
						<p class="price"></p>
					</a>
				</li>
				<li>
					<a href="" onclick="jsViewItem('1736127&pEtr=82700'); return false;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_hot_6.jpg" alt="" />
						<p>Go high 케이스</p>
						<p class="price"></p>
					</a>
				</li>
				<li>
					<a href="" onclick="jsViewItem('1732220&pEtr=82700'); return false;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_hot_7.jpg" alt="" />
						<p>자목련 메시지 터프케이스</p>
						<p class="price"></p>
					</a>
				</li>
			</ul>
		</div>
		<!-- New/wish -->
		<div class="new-wish">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/tit_new.png" alt="New &amp; Wish" /></h3>
			<div class="swiper">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1880203&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_new_1.jpg" alt="BIG FACE - BOY" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1880091&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_new_2.jpg" alt="베리베리베리 케이스" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1880201&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_new_3.jpg" alt="THINK - GIRL" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1884944&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_new_4.jpg" alt="빈티지 카세트 테이프 케이스" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1885471&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_new_5.jpg" alt="Fennec Leather iPhone 7+/8+ Card Case" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1763243&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_new_6.jpg" alt="행성X레드커스텀X홀로그램 필름케이스" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1814480&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_new_7.jpg" alt="peach mlbb (피치) 아이폰케이스" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1875689&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_new_8.jpg" alt="세서미 컬러젤리케이스" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1883954&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_new_9.jpg" alt="냥코케이스 하드케이스 분홍니트입은 토끼" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1860582&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_new_10.jpg" alt="자수케이스_동백" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1883289&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_new_11.jpg" alt="디즈니 앨리스 퓨리 패턴 카드 케이스 아이폰 갤럭시 LG" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1885484&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_new_12.jpg" alt="Bon voyage case" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1878796&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_new_13.jpg" alt="리사라르손 컬러풀 케이스" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1878415&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_new_14.jpg" alt="Hoo-ri Case_Original_White " /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1858444&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/img_new_15.jpg" alt="메리골드" /></a></div>
					</div>
				</div>
				<button type="button" class="slideNav btnPrev">이전</button>
				<button type="button" class="slideNav btnNext">다음</button>
			</div>
		</div>
		<!-- 관련 기획전 -->
		<ul class="related-event">
			<li><a href="" onclick="jsEventlinkURL('84175'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/bnr_phone.jpg" alt="스마트폰으로 더 풍성해진 LIFE " /></a></li>
			<li><a href="" onclick="jsEventlinkURL('84176'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/bnr_listen.jpg" alt="가장 완벽한 사운드를 위해  음향" /></a></li>
			<li><a href="" onclick="jsEventlinkURL('84177'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/bnr_photo_acc.jpg" alt="남는 건 사진이니까  스마트 포토 악세사리" /></a></li>
			<li><a href="" onclick="jsEventlinkURL('84197'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84258/m/bnr_smart_acc.jpg" alt="우리가 몰랐던  스마트 악세사리" /></a></li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->