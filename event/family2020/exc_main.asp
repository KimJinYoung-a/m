<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 가정의달 기획전 2020
' History : 2020-04-07 이종화 생성
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
		strHeadTitleName = "가정의달 기획전"
	End if
%>
<style>[v-cloak] { display: none; }</style>
<link rel="stylesheet" type="text/css" href="/lib/css/family2020.css?v=1.4">
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script type="text/javascript">
$(function(){
	$(".family2020 .topic").addClass("on");
	$(".family2020 .item-wrap .slider").each(function(index, slider) {
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
	fnApplyItemInfoList({
		items:"2607663,2792109,2278171,2805630,2645437",
		target:"itemList1",
		fields:["image","name","price","sale","wish","evaluate"],
		unit:"hw",
		saleBracket:false
	});
	fnApplyItemInfoList({
		items:"2331348,2711597,1948702,2201856,2751936",
		target:"itemList2",
		fields:["image","name","price","sale","wish","evaluate"],
		unit:"hw",
		saleBracket:false
	});
	fnApplyItemInfoList({
		items:"2797702,2774963,2142575,2787707,2694289",
		target:"itemList3",
		fields:["image","name","price","sale","wish","evaluate"],
		unit:"hw",
		saleBracket:false
	});
});
</script>

<div class="topic">
	<img src="//webimage.10x10.co.kr/fixevent/event/2020/family2020/m/bg_topic.jpg" alt="">
	<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/family2020/m/tit_present.png" alt="가정의 달"></h2>
	<span><img src="//webimage.10x10.co.kr/fixevent/event/2020/family2020/m/img_carnation.png" alt=""></span>
</div>
<%' mdpick %>
<div id="mdpicklist"></div>

<section class="item-wrap">
	<div class="item-parents">
		<div class="slider">
			<div class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2020/family2020/m/tit_parents.jpg" alt="부모님"></div>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/family2020/m/img_slide2_1.jpg" alt="">
						<a href="/event/eventmain.asp?eventid=101795" target="_blank" class="mWeb"></a>
						<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101795');" target="_blank" class="mApp"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/family2020/m/img_slide2_2.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=2811387" onclick="TnGotoProduct('2811387');return false;"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/family2020/m/img_slide2_3.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=2324241" onclick="TnGotoProduct('2324241');return false;"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/family2020/m/img_slide2_4.jpg?v=1.0" alt="">
						<a href="/category/category_itemPrd.asp?itemid=2201856" onclick="TnGotoProduct('2201856');return false;"></a>
					</div>
				</div>
				<div class="pagination-progressbar"><span class="pagination-progressbar-fill"></span></div>
			</div>
		</div>
		<div class="items type-list">
			<ul id="itemList2">
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2331348" onclick="TnGotoProduct('2331348');return false;">
						<div class="thumbnail"><img src="" alt=""></div>
						<div class="desc">
							<p class="name"></p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:90%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2711597" onclick="TnGotoProduct('2711597');return false;">
						<div class="thumbnail"><img src="" alt=""></div>
						<div class="desc">
							<p class="name"></p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:90%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=1948702" onclick="TnGotoProduct('1948702');return false;">
						<div class="thumbnail"><img src="" alt=""></div>
						<div class="desc">
							<p class="name"></p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:90%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2201856" onclick="TnGotoProduct('2201856');return false;">
						<div class="thumbnail"><img src="" alt=""></div>
						<div class="desc">
							<p class="name"></p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:90%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2751936" onclick="TnGotoProduct('2751936');return false;">
						<div class="thumbnail"><img src="" alt=""></div>
						<div class="desc">
							<p class="name"></p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:90%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
			</ul>
			<a href="/event/eventmain.asp?eventid=101795" target="_blank" class="btn-more mWeb">제품 더보기<span class="btn-icon"></span></a>
			<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101795');" target="_blank" class="btn-more mApp">제품 더보기<span class="btn-icon"></span></a>
		</div>
	</div>
	<div class="item-couple">
		<div class="slider">
			<div class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2020/family2020/m/tit_couple.jpg" alt="연인"></div>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/family2020/m/img_slide3_1.jpg" alt="">
						<a href="/event/eventmain.asp?eventid=101796" target="_blank" class="mWeb"></a>
						<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101796');" target="_blank" class="mApp"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/family2020/m/img_slide3_2.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=2797702" onclick="TnGotoProduct('2797702');return false;"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/family2020/m/img_slide3_3.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=2787707" onclick="TnGotoProduct('2787707');return false;"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/family2020/m/img_slide3_4.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=2300712" onclick="TnGotoProduct('2300712');return false;"></a>
					</div>
				</div>
				<div class="pagination-progressbar"><span class="pagination-progressbar-fill"></span></div>
			</div>
		</div>
		<div class="items type-list">
			<ul id="itemList3">
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2797702" onclick="TnGotoProduct('2797702');return false;">
						<div class="thumbnail"><img src="" alt=""></div>
						<div class="desc">
							<p class="name"></p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:90%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2774963" onclick="TnGotoProduct('2774963');return false;">
						<div class="thumbnail"><img src="" alt=""></div>
						<div class="desc">
							<p class="name"></p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:90%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2142575" onclick="TnGotoProduct('2142575');return false;">
						<div class="thumbnail"><img src="" alt=""></div>
						<div class="desc">
							<p class="name"></p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:90%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2787707" onclick="TnGotoProduct('2787707');return false;">
						<div class="thumbnail"><img src="" alt=""></div>
						<div class="desc">
							<p class="name"></p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:90%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2694289" onclick="TnGotoProduct('2694289');return false;">
						<div class="thumbnail"><img src="" alt=""></div>
						<div class="desc">
							<p class="name"></p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:90%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
			</ul>
			<a href="/event/eventmain.asp?eventid=101796" target="_blank" class="btn-more mWeb">제품 더보기<span class="btn-icon"></span></a>
			<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101796');" target="_blank" class="btn-more mApp">제품 더보기<span class="btn-icon"></span></a>
		</div>
	</div>
	<div class="item-child">
		<div class="slider">
			<div class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2020/family2020/m/tit_child.jpg" alt="어린이"></div>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/family2020/m/img_slide1_1.jpg" alt="">
						<a href="/event/eventmain.asp?eventid=101794" target="_blank" class="mWeb"></a>
						<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101794');" target="_blank" class="mApp"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/family2020/m/img_slide1_2.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=2607663" onclick="TnGotoProduct('2607663');return false;"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/family2020/m/img_slide1_3.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=2702487" onclick="TnGotoProduct('2702487');return false;"></a>
					</div>
					<div class="swiper-slide">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/family2020/m/img_slide1_4.jpg" alt="">
						<a href="/category/category_itemPrd.asp?itemid=2805630" onclick="TnGotoProduct('2805630');return false;"></a>
					</div>
				</div>
				<div class="pagination-progressbar"><span class="pagination-progressbar-fill"></span></div>
			</div>
		</div>
		<div class="items type-list">
			<ul id="itemList1">
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2607663" onclick="TnGotoProduct('2607663');return false;">
						<div class="thumbnail"><img src="" alt=""></div>
						<div class="desc">
							<p class="name"></p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:90%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2792109" onclick="TnGotoProduct('2792109');return false;">
						<div class="thumbnail"><img src="" alt=""></div>
						<div class="desc">
							<p class="name"></p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:90%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2278171" onclick="TnGotoProduct('2278171');return false;">
						<div class="thumbnail"><img src="" alt=""></div>
						<div class="desc">
							<p class="name"></p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:90%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2805630" onclick="TnGotoProduct('2805630');return false;">
						<div class="thumbnail"><img src="" alt=""></div>
						<div class="desc">
							<p class="name"></p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:90%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=2645437" onclick="TnGotoProduct('2645437');return false;">
						<div class="thumbnail"><img src="" alt=""></div>
						<div class="desc">
							<p class="name"></p>
							<div class="price"></div>
						</div>
						<div class="etc">
							<div class="tag review"><span class="icon icon-rating"><i style="width:90%;"></i></span><span class="counting" title="리뷰 개수"></span></div>
							<div class="tag wish"><span class="icon icon-wish"><i>wish</i></span><span class="counting" title="위시 개수"></span></div>
						</div>
					</a>
				</li>
			</ul>
			<a href="/event/eventmain.asp?eventid=101794" target="_blank" class="btn-more mWeb">제품 더보기<span class="btn-icon"></span></a>
			<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101794');" target="_blank" class="btn-more mApp">제품 더보기<span class="btn-icon"></span></a>
		</div>
	</div>
</section>

<%' 상품 리스트 %>
<div id="itemlist"></div>

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
<script src="/vue/exhibition/components/item-wishnevaluate.js?v=1.01"></script>
<script src="/vue/exhibition/components/more-button.js?v=1.00"></script>
<script src="/vue/exhibition/components/event-list.js?v=1.00"></script>
<script src="/vue/exhibition/components/item-list.js?v=1.00"></script>
<script src="/vue/exhibition/components/slideitem-list.js?v=1.00"></script>
<script src="/vue/exhibition/modules/store.js?v=1.00"></script>
<script src="/vue/exhibition/main/family2020/mdpicklist.js?v=1.00"></script>
<script src="/vue/exhibition/main/family2020/itemlist.js?v=1.03"></script>
