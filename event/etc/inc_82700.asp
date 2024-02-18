<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 케이스팔레트
' History : 2017-12-01 조경애 생성
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
.best-hot .list li {float:left; width:50%; height:22rem; text-align:center; padding-right:0.68rem;}
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
		items:"1736130,1193204,1459543,1604702,1715655,1692128,1191546", // 상품코드
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
function goEventLink(evt) {
	<% if isApp then %>
		fnAPPpopupEvent(evt);
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
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
<div class="mEvt82700 case-palette">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/tit_case_palette.jpg" alt="Phone case Palette" /></h2>
	<div class="inner">
		<!-- 관련 기획전 -->
		<div class="slideTemplateV15">
			<div class="swiper">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><a href="" onclick="goEventLink('82701'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/bnr_main_1.jpg" alt="Collection Chip" /></a></div>
						<div class="swiper-slide"><a href="" onclick="goEventLink('82552'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/bnr_main_2.jpg" alt="따뜻한 터치, 스마트폰 장갑" /></a></div>
						<div class="swiper-slide"><a href="" onclick="goEventLink('82550'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/bnr_main_3.jpg" alt="More Smarter, Accessory" /></a></div>
						<div class="swiper-slide"><a href="" onclick="goEventLink('82310'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/bnr_main_4.jpg" alt="따뜻하게 손 잡아줄래" /></a></div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="slideNav btnPrev">이전</button>
				<button type="button" class="slideNav btnNext">다음</button>
			</div>
		</div>
		<ul class="related-event">
			<li><a href="" onclick="goEventLink('82535'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/bnr_fur.jpg" alt="Fur Case" /></a></li>
			<li><a href="" onclick="goEventLink('82728'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/bnr_tailor.jpg" alt="Tailor Made for" /></a></li>
			<li><a href="" onclick="goEventLink('82536'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/bnr_custom.jpg" alt="Custom Case" /></a></li>
		</ul>
		<!-- Best/hot -->
		<div class="best-hot">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/tit_best_hot.png" alt="Best &amp; Hot 텐텐에서는 이게 핫해요!" /></h3>
			<ul id="list" class="list">
				<li>
					<a href="" onclick="jsViewItem('1736130&pEtr=82700'); return false;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_hot_1.jpg" alt="" />
						<p>Youth Series</p>
						<p class="price">30,400won<span>[10%]</span></p>
					</a>
				</li>
				<li>
					<a href="" onclick="jsViewItem('1193204&pEtr=82700'); return false;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_hot_2.jpg" alt="" />
						<p>아이폰 방탄 강화유리 필름</p>
						<p class="price"></p>
					</a>
				</li>
				<li>
					<a href="" onclick="jsViewItem('1459543&pEtr=82700'); return false;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_hot_3.jpg" alt="" />
						<p>SUN CASE LIGHT GRAY</p>
						<p class="price"></p>
					</a>
				</li>
				<li>
					<a href="" onclick="jsViewItem('1604702&pEtr=82700'); return false;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_hot_4.jpg" alt="" />
						<p>hej 동물케이스</p>
						<p class="price"></p>
					</a>
				</li>
				<li>
					<a href="" onclick="jsViewItem('1715655&pEtr=82700'); return false;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_hot_5.jpg" alt="" />
						<p>CBB SC Telescope jelly</p>
						<p class="price"></p>
					</a>
				</li>
				<li>
					<a href="" onclick="jsViewItem('1692128&pEtr=82700'); return false;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_hot_6.jpg" alt="" />
						<p>냥-이 케이스</p>
						<p class="price"></p>
					</a>
				</li>
				<li>
					<a href="" onclick="jsViewItem('1191546&pEtr=82700'); return false;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_hot_7.jpg" alt="" />
						<p>day,day 케이스</p>
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
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1841031&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_new_1.jpg" alt="" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1845942&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_new_2.jpg" alt="" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1844969&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_new_3.jpg" alt="" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1844144&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_new_4.jpg" alt="" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1830609&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_new_5.jpg" alt="" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1833449&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_new_6.jpg" alt="" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1818817&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_new_7.jpg" alt="" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1796783&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_new_8.jpg" alt="" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1780523&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_new_9.jpg" alt="" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1845348&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_new_10.jpg" alt="" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1845333&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_new_11.jpg" alt="" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1841523&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_new_12.jpg" alt="" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1840127&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_new_13.jpg" alt="" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1838033&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_new_14.jpg" alt="" /></a></div>
						<div class="swiper-slide"><a href="" onclick="jsViewItem('1847786&pEtr=82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/img_new_15.jpg" alt="" /></a></div>
					</div>
				</div>
				<button type="button" class="slideNav btnPrev">이전</button>
				<button type="button" class="slideNav btnNext">다음</button>
			</div>
		</div>
		<!-- 관련 기획전 -->
		<ul class="related-event">
			<li>
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/bnr_apple.jpg?v=1" alt="Apple Case" />
				<div class="btn-group mWeb">
					<a href="/category/category_list.asp?disp=102101118">iPhone X</a>
					<a href="/category/category_list.asp?disp=102101116">iPhone 8</a>
					<a href="/category/category_list.asp?disp=102101114">iPhone 7</a>
				</div>
				<div class="btn-group mApp">
					<a href="" onclick="fnAPPpopupCategory('102101118'); return false;">iPhone X</a>
					<a href="" onclick="fnAPPpopupCategory('102101116'); return false;">iPhone 8</a>
					<a href="" onclick="fnAPPpopupCategory('102101114'); return false;">iPhone 7</a>
					
				</div>
			</li>
			<li>
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/bnr_samsung.jpg?v=1" alt="Samsung Case" />
				<div class="btn-group mWeb">
					<a href="/category/category_list.asp?disp=102102116">Galaxy Note8</a>
					<a href="/category/category_list.asp?disp=102102115">Galaxy S8</a>
					<a href="/category/category_list.asp?disp=102102113">Galaxy S7</a>
				</div>
				<div class="btn-group mApp">
					<a href="" onclick="fnAPPpopupCategory('102102116'); return false;">Galaxy Note8</a>
					<a href="" onclick="fnAPPpopupCategory('102102115'); return false;">Galaxy S8</a>
					<a href="" onclick="fnAPPpopupCategory('102102113'); return false;">Galaxy S7</a>
				</div>
			</li>
			<li>
				<a href="/category/category_list.asp?disp=102104" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/bnr_acc.jpg" alt="Accessory" /></a>
				<a href="" onclick="fnAPPpopupCategory('102104'); return false;"class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/bnr_acc.jpg" alt="Accessory" /></a>
			</li>
			<li><a href="" onclick="goEventLink('82754'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82700/m/bnr_brand.jpg" alt="Artist Brand Collection" /></a></li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->