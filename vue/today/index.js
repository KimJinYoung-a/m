Vue.filter('nl2br', function (value) {
    // 처리된 값을 반환합니다
    return String(value).replace('\r\n', '<br>');
})

//lazy load
Vue.use(VueLazyload, {
    preLoad: 1.3,
    error : false,
    loading : false,
    supportWebp : false,
    listenEvents: ['scroll', 'wheel', 'mousewheel', 'resize', 'animationend', 'transitionend', 'touchmove']
})

const todayApp = new Vue({
    store : store,
    created() {
        this.$store.dispatch('GET_TODAY', this.isApp);
    },
    computed : {
        isApp() { return location.pathname.toLowerCase().indexOf('/apps/appcom/wish/web2014') > -1; },
        mdPicks() { return this.$store.getters.mdPicks; },
        oneBanners() { return this.$store.getters.oneBanners; },
        exhibitions() { return this.$store.getters.exhibitions; },
        keywords() { return this.$store.getters.keywords; },
        enjoys() { return this.$store.getters.enjoys; },
        brands() { return this.$store.getters.brands; },
        twinItems() { return this.$store.getters.twinItems; },
        categories() { return this.$store.getters.categories; }
    }
});


//컴포넌트-탬플릿
//스와이퍼 롤링
Vue.component('main-banner',{
    props: ['item','isapp'],
    template : '\
				<a @click="fnAmplitudeEventAction(item.ampevt,item.ampevtp,item.ampevtpv,function(bool){if(bool) {fnAPPpopupAutoUrl(item.link);}});" v-if="isapp > 0"><div class="thumbnail"><img v-lazy="item.imgsrc"></div></a>\
				<a :href="item.link" @click="fnAmplitudeEventAction(item.ampevt,item.ampevtp,item.ampevtpv);" v-else><div class="thumbnail"><img v-lazy="item.imgsrc"></div></a>\
				'
})

//HCP-List
Vue.component('hcp-list',{
    props: ['item','isapp'],
    template : '\
				<a @click="fnAmplitudeEventAction(item.ampevt,item.ampevtp,item.ampevtpv,function(bool){if(bool) {fnAPPpopupAutoUrl(item_link);}});" v-if="isapp > 0">\
					<div class="thumbnail"><span class="label label-circle" v-if="item.cgubun == 2"><em>{{item.culopt}}</em></span><img :src="item.imgsrc"></div>\
					<div class="desc">\
						<h2 class="headline" v-html="item.maincopy"></h2>\
						<p class="subcopy" v-html="item.subcopy"></p>\
					</div>\
				</a>\
				<a :href="item_link" @click="fnAmplitudeEventAction(item.ampevt,item.ampevtp,item.ampevtpv);" v-else>\
					<div class="thumbnail"><span class="label label-circle" v-if="item.cgubun == 2"><em>{{item.culopt}}</em></span><img :src="item.imgsrc"></div>\
					<div class="desc">\
						<h2 class="headline" v-html="item.maincopy"></h2>\
						<p class="subcopy" v-html="item.subcopy"></p>\
					</div>\
				</a>\
				',
    computed : {
        item_link() {
            if( Number(this.item.cgubun) === 1 ) { // 히치하이커 배너일 경우에 Amplitude 이벤트를 위해 parameter 추가
                return this.item.link + ( this.item.link.indexOf('?') > -1 ? '&' : '?' ) + 'ap=today';
            } else {
                return this.item.link;
            }
        }
    }
})

//mdpick
Vue.component('main-mdpick',{
    props: ['sub','index','isapp'],
    template : '\
				<a @click="fnAmplitudeEventMultiPropertiesAction(sub.ampevt,sub.ampevtp,sub.ampevtpv,function(bool){if(bool) {fnAPPpopupProduct(sub.link);}});" v-if="isapp > 0">\
					<div class="thumbnail"><p class="tagV18 t-low" v-if="sub.islowestprice == 1"><span>최저가</span></p>\
					<img :src="sub.imgsrc"/></div>\
					<div class="desc">\
						<p class="name">{{sub.name}}</p>\
						<b class="discount color-red" v-if="sub.sale_coupontag == 1">{{sub.sale}}</b>\
						<b class="discount color-green" v-if="sub.sale_coupontag == 2">{{sub.sale}}</b>\
					</div>\
				</a>\
				<a :href="sub.link" @click="fnAmplitudeEventMultiPropertiesAction(sub.ampevt,sub.ampevtp,sub.ampevtpv);" v-else>\
					<div class="thumbnail"><p class="tagV18 t-low" v-if="sub.islowestprice == 1"><span>최저가</span></p>\
					<img :src="sub.imgsrc"/></div>\
					<div class="desc">\
						<p class="name">{{sub.name}}</p>\
						<b class="discount color-red" v-if="sub.sale_coupontag == 1">{{sub.sale}}</b>\
						<b class="discount color-green" v-if="sub.sale_coupontag == 2">{{sub.sale}}</b>\
					</div>\
				</a>\
				'
})

//sale
Vue.component('main-sale',{
    props: ['sub','index','isapp'],
    template : '\
				<a @click="fnAmplitudeEventAction(sub.ampevt,sub.ampevtp,sub.ampevtpv,function(bool){if(bool) {fnAPPpopupProduct(sub.link);}});" v-if="isapp > 0">\
					<div class="thumbnail"><img :src="sub.imgsrc"/></div>\
					<div class="desc">\
						<p class="name">{{sub.name}}</p>\
						<div class="price">\
							<b class="discount color-red" v-if="sub.sale_coupontag == 1">{{sub.sale}}</b>\
							<b class="discount color-green" v-if="sub.sale_coupontag == 2">{{sub.sale}}</b>\
							<b class="sum">{{sub.price}}<span class="won">원</span></b>\
						</div>\
					</div>\
				</a>\
				<a :href="sub.link" @click="fnAmplitudeEventAction(sub.ampevt,sub.ampevtp,sub.ampevtpv);" v-else>\
					<div class="thumbnail"><img :src="sub.imgsrc"/></div>\
					<div class="desc">\
						<p class="name">{{sub.name}}</p>\
						<div class="price">\
							<b class="discount color-red" v-if="sub.sale_coupontag == 1">{{sub.sale}}</b>\
							<b class="discount color-green" v-if="sub.sale_coupontag == 2">{{sub.sale}}</b>\
							<b class="sum">{{sub.price}}<span class="won">원</span></b>\
						</div>\
					</div>\
				</a>\
				'
})

//new / exhibition //lazy load > 3
Vue.component('main-itemlist',{
    props: ['sub','index','isapp'],
    template : '\
				<li class="swiper-slide" v-if="isapp > 0">\
					<a @click="fnAmplitudeEventAction(sub.ampevt,sub.ampevtp,sub.ampevtpv,function(bool){if(bool) {fnAPPpopupProduct(sub.link);}});">\
						<span class="label label-triangle" v-if="sub.tagname"><em>{{sub.tagname}}</em></span>\
						<div class="thumbnail" v-if="index < 3"><img :src="sub.imgsrc"/></div>\
						<div class="thumbnail" v-else><img v-lazy="sub.imgsrc"/></div>\
						<div class="desc">\
							<p class="name">{{sub.name}}</p>\
							<div class="price">\
								<b class="discount color-red" v-if="sub.sale_coupontag == 1">{{sub.sale}}</b>\
								<b class="discount color-green" v-if="sub.sale_coupontag == 2">{{sub.sale}}</b>\
								<b class="sum">{{sub.price}}<span class="won">원</span></b>\
							</div>\
						</div>\
					</a>\
				</li>\
				<li class="swiper-slide" v-else>\
					<a :href="sub.link" @click="fnAmplitudeEventAction(sub.ampevt,sub.ampevtp,sub.ampevtpv);">\
						<span class="label label-triangle" v-if="sub.tagname"><em>{{sub.tagname}}</em></span>\
						<div class="thumbnail" v-if="index < 3"><img :src="sub.imgsrc"/></div>\
						<div class="thumbnail" v-else><img v-lazy="sub.imgsrc"/></div>\
						<div class="desc">\
							<p class="name">{{sub.name}}</p>\
							<div class="price">\
								<b class="discount color-red" v-if="sub.sale_coupontag == 1">{{sub.sale}}</b>\
								<b class="discount color-green" v-if="sub.sale_coupontag == 2">{{sub.sale}}</b>\
								<b class="sum">{{sub.price}}<span class="won">원</span></b>\
							</div>\
						</div>\
					</a>\
				</li>\
				'
})

//이미지배너 AB타입
Vue.component('img-banner',{
    props: ['item','isapp'],
    template : '\
				<a @click="fnAmplitudeEventMultiPropertiesAction(item.ampevt,item.ampevtp,item.ampevtpv,function(bool){if(bool) {fnAPPpopupAutoUrl(item.link);}});" v-if="isapp > 0">\
					<div class="thumbnail"><img v-lazy="item.imgsrc"/></div>\
					<div class="desc">\
						<span class="label label-speech" v-if="item.sale_per || item.coupon_per"><b class="discount" v-if="item.sale_per">{{item.sale_per}}</b> <b v-if="item.coupon_per">{{item.coupon_per}}</b></span>\
						<h2 class="headline">{{item.maincopy}}<br /> {{item.maincopy2}}</h2>\
						<p class="subcopy"><span class="label label-color" v-if="item.evttag"><em class="color-blue">{{item.evttag}}</em></span><span v-html="this.$options.filters.nl2br(item.subcopy)"></span></p>\
					</div>\
				</a>\
				<a :href="item.link" @click="fnAmplitudeEventMultiPropertiesAction(item.ampevt,item.ampevtp,item.ampevtpv);" v-else>\
					<div class="thumbnail"><img v-lazy="item.imgsrc"/></div>\
					<div class="desc">\
						<span class="label label-speech" v-if="item.sale_per || item.coupon_per"><b class="discount" v-if="item.sale_per">{{item.sale_per}}</b> <b v-if="item.coupon_per">{{item.coupon_per}}</b></span>\
						<h2 class="headline">{{item.maincopy}}<br /> {{item.maincopy2}}</h2>\
						<p class="subcopy"><span class="label label-color" v-if="item.evttag"><em class="color-blue">{{item.evttag}}</em></span><span v-html="this.$options.filters.nl2br(item.subcopy)"></span></p>\
					</div>\
				</a>\
				'
})


//LI-LIST 이벤트 배너
Vue.component('main-eventban',{
    props: ['item','isapp'],
    template : '\
				<li v-if="isapp > 0">\
					<a @click="fnAmplitudeEventMultiPropertiesAction(item.ampevt,item.ampevtp,item.ampevtpv,function(bool){if(bool) {fnAPPpopupAutoUrl(item.link);}});">\
						<div class="thumbnail"><p class="tagV18 t-only" v-if="item.onlytag > 0"><span>ONLY<br />10X10</span></p><img :src="item.imgsrc" style="display:block;width:100%;"/></div>\
						<div class="desc">\
							<p>\
								<b class="headline"><span class="ellipsis" v-if="item.sale_per">{{item.title1}}</span><span class="ellipsis full" v-else>{{item.title1}}</span> <b class="discount color-red" v-if="item.sale_per">{{item.sale_per}}</b></b>\
								<span class="subcopy"><span class="label label-color" v-if="item.evttag"><em class="color-green" v-if="item.coupon_flag == 1">{{item.evttag}}</em><em class="color-blue" v-else-if="item.coupon_flag == 0">{{item.evttag}}</em></span>{{item.title2}}</span>\
							</p>\
						</div>\
					</a>\
				</li>\
				<li v-else>\
					<a :href="item.link" @click="fnAmplitudeEventMultiPropertiesAction(item.ampevt,item.ampevtp,item.ampevtpv);">\
						<div class="thumbnail"><p class="tagV18 t-only" v-if="item.onlytag > 0"><span>ONLY<br />10X10</span></p><img :src="item.imgsrc" style="display:block;width:100%;"/></div>\
						<div class="desc">\
							<p>\
								<b class="headline"><span class="ellipsis" v-if="item.sale_per">{{item.title1}}</span><span class="ellipsis full" v-else>{{item.title1}}</span> <b class="discount color-red" v-if="item.sale_per">{{item.sale_per}}</b></b>\
								<span class="subcopy"><span class="label label-color" v-if="item.evttag"><em class="color-green" v-if="item.coupon_flag == 1">{{item.evttag}}</em><em class="color-blue" v-else-if="item.coupon_flag == 0">{{item.evttag}}</em></span>{{item.title2}}</span>\
							</p>\
						</div>\
					</a>\
				</li>\
				'
})

//LI-LIST 이벤트 배너 + 상품타입
Vue.component('main-eventbanitems',{
    props: ['item','isapp'],
    template : '\
				<div v-if="isapp > 0">\
					<div class="list-card type-align-left">\
						<a @click="fnAPPpopupAutoUrl(item.link);">\
							<div class="thumbnail"><img :src="item.imgsrc" alt=""></div>\
							<p class="desc">\
								<b class="headline"><span class="ellipsis" v-if="item.sale_per">{{item.title1}}</span><span class="ellipsis full" v-else>{{item.title1}}</span> <b class="discount color-red" v-if="item.sale_per">{{item.sale_per}}</b></b>\
								<span class="subcopy"><span class="label label-color" v-if="item.evttag"><em class="color-green" v-if="item.coupon_flag == 1">{{item.evttag}}</em><em class="color-blue" v-if="item.coupon_flag == 0">{{item.evttag}}</em></span>{{item.title2}}</span>\
							</p>\
						</a>\
					</div>\
					<div class="items">\
						<ul>\
							<li>\
								<a @click="fnAPPpopupAutoUrl(item.itemid1url);">\
									<div class="thumbnail"><img :src="item.itemimg1" alt=""></div>\
									<div class="desc">\
										<div class="price">\
											<b class="discount color-red" v-if="item.sale1">{{item.sale1}}</b>\
											<b class="sum">{{item.price1}}<span class="won">원</span></b>\
										</div>\
									</div>\
								</a>\
							</li>\
							<li>\
								<a @click="fnAPPpopupAutoUrl(item.itemid2url);">\
									<div class="thumbnail"><img :src="item.itemimg2" alt=""></div>\
									<div class="desc">\
										<div class="price">\
											<b class="discount color-red" v-if="item.sale2">{{item.sale2}}</b>\
											<b class="sum">{{item.price2}}<span class="won">원</span></b>\
										</div>\
									</div>\
								</a>\
							</li>\
							<li>\
								<a @click="fnAPPpopupAutoUrl(item.itemid3url);">\
									<div class="thumbnail"><img :src="item.itemimg3" alt=""></div>\
									<div class="desc">\
										<div class="price">\
											<b class="discount color-red" v-if="item.sale3">{{item.sale3}}</b>\
											<b class="sum">{{item.price3}}<span class="won">원</span></b>\
										</div>\
									</div>\
								</a>\
							</li>\
						</ul>\
					</div>\
				</div>\
				<div v-else>\
					<div class="list-card type-align-left">\
						<a :href="item.link">\
							<div class="thumbnail"><img :src="item.imgsrc" alt=""></div>\
							<p class="desc">\
								<b class="headline"><span class="ellipsis" v-if="item.sale_per">{{item.title1}}</span><span class="ellipsis full" v-else>{{item.title1}}</span> <b class="discount color-red" v-if="item.sale_per">{{item.sale_per}}</b></b>\
								<span class="subcopy"><span class="label label-color" v-if="item.evttag"><em class="color-green" v-if="item.coupon_flag == 1">{{item.evttag}}</em><em class="color-blue" v-if="item.coupon_flag == 0">{{item.evttag}}</em></span>{{item.title2}}</span>\
							</p>\
						</a>\
					</div>\
					<div class="items">\
						<ul>\
							<li>\
								<a :href="item.itemid1url">\
									<div class="thumbnail"><img :src="item.itemimg1" alt=""></div>\
									<div class="desc">\
										<div class="price">\
											<b class="discount color-red" v-if="item.sale1">{{item.sale1}}</b>\
											<b class="sum">{{item.price1}}<span class="won">원</span></b>\
										</div>\
									</div>\
								</a>\
							</li>\
							<li>\
								<a :href="item.itemid2url">\
									<div class="thumbnail"><img :src="item.itemimg2" alt=""></div>\
									<div class="desc">\
										<div class="price">\
											<b class="discount color-red" v-if="item.sale2">{{item.sale2}}</b>\
											<b class="sum">{{item.price2}}<span class="won">원</span></b>\
										</div>\
									</div>\
								</a>\
							</li>\
							<li>\
								<a :href="item.itemid3url">\
									<div class="thumbnail"><img :src="item.itemimg3" alt=""></div>\
									<div class="desc">\
										<div class="price">\
											<b class="discount color-red" v-if="item.sale3">{{item.sale3}}</b>\
											<b class="sum">{{item.price3}}<span class="won">원</span></b>\
										</div>\
									</div>\
								</a>\
							</li>\
						</ul>\
					</div>\
				</div>\
				'
})

//브랜드 배너
Vue.component('brand-banner',{
    props: ['item','isapp'],
    template : '\
				<div v-if="isapp > 0">\
					<a @click="fnAmplitudeEventMultiPropertiesAction(item.ampevt,item.ampevtp,item.ampevtpv,function(bool){if(bool) {fnAPPpopupBrand(item.brandid);}});">\
						<div class="thumbnail type-b"><img :src="item.imgsrc1" alt="" /></div>\
						<div class="desc">\
							<h2 class="headline">BRAND;</h2>\
							<h3 class="headline">{{item.maincopy}}</h3>\
							<p v-html="this.$options.filters.nl2br(item.subcopy)"></p>\
						</div>\
					</a>\
					<div class="brand-items">\
						<ul>\
							<li><a @click="fnAmplitudeEventMultiPropertiesAction(item.ampevt_item,item.ampevtp_item,item.ampevtpv_1,function(bool){if(bool) {fnAPPpopupAutoUrl(item.itemid1url);}});"><div class="thumbnail"><img :src="item.itemimg1" alt="" /></div></a></li>\
							<li><a @click="fnAmplitudeEventMultiPropertiesAction(item.ampevt_item,item.ampevtp_item,item.ampevtpv_2,function(bool){if(bool) {fnAPPpopupAutoUrl(item.itemid2url);}});"><div class="thumbnail"><img :src="item.itemimg2" alt="" /></div></a></li>\
						</ul>\
						<div class="btn-group">\
							<a @click="fnAPPpopupAutoUrl(item.link);">\
								<div class="thumbnail"><img :src="item.imgsrc2" style="filter:Alpha(Opacity=50);Opacity:0.5;" alt="" /></div>\
								<span class="btn-more">더보기<span class="icon icon-arrow"></span></span>\
							</a>\
						</div>\
					</div>\
				</div>\
				<div v-else>\
					<a :href="item.brandlink" @click="fnAmplitudeEventAction(item.ampevt,item.ampevtp,item.ampevtpv);">\
						<div class="thumbnail type-b"><img :src="item.imgsrc1" alt="" /></div>\
						<div class="desc">\
							<h2 class="headline">BRAND;</h2>\
							<h3 class="headline">{{item.maincopy}}</h3>\
							<p v-html="this.$options.filters.nl2br(item.subcopy)"></p>\
						</div>\
					</a>\
					<div class="brand-items">\
						<ul>\
							<li><a :href="item.itemid1url" @click="fnAmplitudeEventAction(item.ampevt_item,item.ampevtp_item,item.ampevtpv_1);"><div class="thumbnail"><img :src="item.itemimg1" alt="" /></div></a></li>\
							<li><a :href="item.itemid2url" @click="fnAmplitudeEventAction(item.ampevt_item,item.ampevtp_item,item.ampevtpv_2);"><div class="thumbnail"><img :src="item.itemimg2" alt="" /></div></a></li>\
						</ul>\
						<div class="btn-group">\
							<a :href="item.link">\
								<div class="thumbnail"><img :src="item.imgsrc2" style="filter:Alpha(Opacity=50);Opacity:0.5;" alt="" /></div>\
								<span class="btn-more">더보기<span class="icon icon-arrow"></span></span>\
							</a>\
						</div>\
					</div>\
				</div>\
				'
})

// 투데이 더보기 - 카테고리 상품
Vue.component('cateitem-more',{
    props: ['sub','isapp'],
    template : '\
				<div v-if="isapp > 0">\
				<li>\
					<a @click="fnAPPpopupAutoUrl(sub.link);">\
						<div class="thumbnail"><img :src="sub.itemimage" alt="" /></div>\
						<div class="desc">\
							<p class="name">{{sub.itemname}}</p>\
							<div class="price">\
								<b class="discount color-red">{{sub.sale}}</b>\
								<b class="sum">{{sub.price}}<span class="won">원</span></b>\
							</div>\
						</div>\
					</a>\
				</li>\
				</div>\
				<div v-else>\
				<li>\
					<a :href="sub.link">\
						<div class="thumbnail"><img :src="sub.itemimage" alt="" /></div>\
						<div class="desc">\
							<p class="name">{{sub.itemname}}</p>\
							<div class="price">\
								<b class="discount color-red">{{sub.sale}}</b>\
								<b class="sum">{{sub.price}}<span class="won">원</span></b>\
							</div>\
						</div>\
					</a>\
				</li>\
				</div>\
			'
})

// 투데이 더보기 - 카테고리 이벤트
Vue.component('event-more',{
    props: ['sub','isapp'],
    template : '\
				<div v-if="isapp > 0">\
				<li>\
					<a @click="fnAPPpopupAutoUrl(sub.link);">\
						<div class="thumbnail"><img :src="sub.eventimage" alt=""></div>\
						<p class="desc">\
							<b class="headline"><span class="ellipsis" v-if="sub.sale">{{sub.maincopy}}</span><span class="ellipsis full" v-else>{{sub.maincopy}}</span> <b class="discount color-red" v-if="sub.sale">{{sub.sale}}</b></b>\
							<span class="subcopy" v-html="sub.subcopy"></span>\
						</p>\
					</a>\
				</li>\
				</div>\
				<div v-else>\
				<li>\
					<a :href="sub.link">\
						<div class="thumbnail"><img :src="sub.eventimage" alt=""></div>\
						<p class="desc">\
							<b class="headline"><span class="ellipsis" v-if="sub.sale">{{sub.maincopy}}</span><span class="ellipsis full" v-else>{{sub.maincopy}}</span> <b class="discount color-red" v-if="sub.sale">{{sub.sale}}</b></b>\
							<span class="subcopy" v-html="sub.subcopy"></span>\
						</p>\
					</a>\
				</li>\
				</div>\
			'
})

Vue.component('best-renewal',{
    props: ['items', 'update_text', 'isapp'],
    template : `
		<div @click="go_bestpage" class="best_2021">
			<div class="today_best">
				<div class="best_ment">
					<p class="now">지금 제일 잘 나가요!</p>
					<p class="rank_ment" v-html="update_text"></p>
				</div>
				<div class="icon">
					<p class="main"><img src="//fiximage.10x10.co.kr/m/2021/best/today_main.png?v=3" alt=""></p>
					<p class="book"><img src="//fiximage.10x10.co.kr/m/2021/best/today_book.png" alt=""></p>
					<p class="pen"><img src="//fiximage.10x10.co.kr/m/2021/best/today_pen.png?v=3" alt=""></p>
					<p class="clock"><img src="//fiximage.10x10.co.kr/m/2021/best/today_clock.png" alt=""></p>
				</div>
			</div>

			<template v-for="(item, index) in items">
				<Product-Item-Today-Best
					@go_item="go_item"
					:key="item.rank"
					:isApp="isapp > 0"
					:item_id="item.item_id"
					:image_url="item.list_image"
					:item_price="item.item_price"
					:sale_percent="item.sale_percent"
					:item_coupon_yn="item.item_coupon_yn"
					:item_coupon_value="item.item_coupon_value"
					:item_coupon_type="item.item_coupon_type"
					:item_name="item.item_name"
					sell_flag="Y"
					:rental_yn="item.rental_yn"
					:rank="item.rank"
					:rank_diff="item.rank_diff"
					:flag_text="item.flag_text"
					:index="index"
				></Product-Item-Today-Best>
			</template>
			<div class="gra">
				<a @click="go_bestpage" href="javascript:void(0)" class="all_rank">전체 랭킹 보러가기 <i class="i_arw_r1"></i></a>
			</div>
		</div>
	`
    , methods : {
        go_item(item_id, ranking, flag_text, event) {
            event.stopPropagation();

            fnAmplitudeEventObjectAction('click_today_best_item', {
                "item_id" : item_id
                , "ranking" : ranking
            });

            if( isapp > 0 ) {
                fnAPPpopupProductRenewal(item_id);
            } else {
                location.href = "/category/category_itemPrd.asp?itemid=" + item_id + "&flag=e";
            }
        }
        , go_bestpage(){
            fnAmplitudeEventObjectAction('click_today_best', {});

            if(isapp > 0){
                fnPopupBest("/apps/appcom/wish/web2014/list/best/best_summary2020.asp");
            }else{
                location.href = "/list/best/renewal/index2020.asp";
            }
        }
    }
})


//region MdPick들 (mdpick, onsale, new)
// mdpick
new Vue({
    el: "#mdpickSwiper",
    store : store,
    data() {return {test : 'test'}},
    computed : {
        items() {
            const mdPicks = this.$store.getters.mdPicks.mdPick;
            const list = [];
            for( let i=0 ; i<mdPicks.length ; i++ ) {
                const item = mdPicks[i];
                if( item ) {
                    if( i%2 === 0 ) {
                        list.push([item]);
                    } else {
                        list[Math.floor(i/2)].push(item);
                    }
                } else {
                    break;
                }
            }
            return list;
        },
    },
    mounted: function () {
        this.$nextTick(function() {
            setTimeout(function(){
                var mdpickSwiper = new Swiper("#mdpickSwiper .swiper-container", {
                    slidesPerView:"auto",
                    freeMode:true,
                    freeModeMomentumRatio:0.5
                    ,onImagesReady:function(){
                        rectPosition('#mdpickSwiper');
                    }
                });
            },1500);
        });
    }
})
// New
new Vue({
    el: "#newSwiper",
    store : store,
    computed : {
        items() { return this.$store.getters.mdPicks; },
    },
    mounted: function () {
        this.$nextTick(function() {
            setTimeout(function(){
                var newSwiper = new Swiper("#newSwiper .swiper-container", {
                    slidesPerView:"auto"
                    ,onImagesReady:function(){
                        rectPosition('#newSwiper');
                    }
                });
            },1500);
        });
    }
})

// onSale
new Vue({
    el: "#saleSwiper",
    store : store,
    computed : {
        items() { return this.$store.getters.mdPicks; },
    },
    mounted: function () {
        this.$nextTick(function() {
            setTimeout(function(){
                var saleSwiper = new Swiper("#saleSwiper .swiper-container", {
                    slidesPerView:"auto"
                    ,onImagesReady:function(){
                        rectPosition('#saleSwiper');
                    }
                });
            },1500);
        });
    }
})
//endregion

//region exhibitions
// exhibition
new Vue({
    el: "#enjoySwiper",
    store : store,
    computed : {
        items() { return this.$store.getters.exhibitions; },
    },
    mounted: function () {
        this.$nextTick(function() {
            setTimeout(function(){
                var enjoySwiper = new Swiper("#enjoySwiper .swiper-container", {
                    slidesPerView:"auto"
                    ,onImagesReady:function(){
                        rectPosition('#enjoySwiper');
                    }
                });
            },1500);
        });
    },
})
//endregion

//region oneBanner (마케팅롤링, 이미지배너a,b,c , 히치하이커, 가이드배너)
// 마케팅 롤링
new Vue({ el: "#mktbanner", store : store, computed : { items() { return this.$store.getters.oneBanners; } } })
// 이미지배너A 롤링
new Vue({ el: "#imgbanA", store : store, computed : { items() { return this.$store.getters.oneBanners; } } })
// 이미지배너B 롤링
new Vue({ el: "#imgbanB", store : store, computed : { items() { return this.$store.getters.oneBanners; } } })
// 이미지배너C 롤링
new Vue({ el: "#imgbanC", store : store, computed : { items() { return this.$store.getters.oneBanners; } } })
// 히치하이커 컬쳐 플레잉
new Vue({ el: "#HCPlist", store : store, computed : { items() { return this.$store.getters.oneBanners; } } })
// 가이드 배너
new Vue({ el: "#guideList", store : store, computed : { items() { return this.$store.getters.oneBanners; } } })
//endregion

// 키워드 배너
new Vue({ el: "#mainkeyword", store : store, computed : {items() { return this.$store.getters.keywords; }} })

//region enjoys (엔조이 이벤트 1,2,3,4)
// 엔조이이벤트 1
new Vue({ el: "#enjoyevent1", store : store, computed : { items() { return this.$store.getters.enjoys; }}})
// 엔조이이벤트 2
new Vue({ el: "#enjoyevent2", store : store, computed : { items() { return this.$store.getters.enjoys; }}})
// 엔조이이벤트 3
new Vue({ el: "#enjoyevent3", store : store, computed : { items() { return this.$store.getters.enjoys; }}})
// 엔조이이벤트 4
new Vue({ el: "#enjoyevent4", store : store, computed : { items() { return this.$store.getters.enjoys; }}})
//endregion

// 브랜드 배너
new Vue({ el: "#mainbrand", store : store, computed : {items() { return this.$store.getters.brands; }} })

// 단품 배너
new Vue({ el: "#twinitems", store : store, computed : {items() { return this.$store.getters.twinItems; }} })

// 카테고리 더보기
new Vue({
    el : '#todaymore',
    store : store,
    data : function () {
        return {
            show : false,	// display content after API request
            offset : 5 ,	// 스크롤 이후 보여질 갯수
            display : 0 ,	// 최초 보여질 갯수
            trigger : 450 , // 무한 스크롤 트리거 (높이값)
        }
    },
    computed : {
        sliced() {
            return this.items.slice(0,this.display); //최초 보여질 계산된 카운트 (0,0) 시작 안함
        },
        items() { return this.$store.getters.categories; }
    },
    methods : {
        scroll : function(){
            var _this = this;
            window.onscroll = function(ev){
                if (window.scrollY >= ( document.body.scrollHeight - document.body.offsetHeight ) - _this.trigger){
                    if(_this.display < _this.items.length){
                        _this.display = _this.display + _this.offset;
                    }else{
                        _this.end = true;
                    }
                }
            };
        }
    },
    mounted : function(){
        this.scroll();
        this.show = true;
    }
})


var br = new Vue({
    el : '#best-renewal',
    data :  function() {
        return {
            items : []		// api 데이터
            , update_text : ""
        }
    },
    created : function(){
        var _this = this;

        $.ajax({
            type: "GET"
            , url:'//fapi.10x10.co.kr/api/web/v2/best/today-best'
            , data : {"isApp" : isapp > 0}
            , ContentType: "json"
            , crossDomain: true
            , xhrFields: {
                withCredentials: true
            }
            , success: function (data) {
                _this.items =  data.items;

                const now = new Date();
                let update_text = "";

                if(now.getHours() == data.last_update_time) {
                    switch (data.last_update_time) {
                        case '00' :
                            update_text = "오전 0시의<br/>따끈한 랭킹!";
                            break;
                        case '03' :
                            update_text = "오전 3시의<br/>따끈한 랭킹!";
                            break;
                        case '06' :
                            update_text = "오전 6시의<br/>따끈한 랭킹!";
                            break;
                        case '09' :
                            update_text = "오전 9시의<br/>따끈한 랭킹!";
                            break;
                        case '12' :
                            update_text = "오후 12시의<br/>따끈한 랭킹!";
                            break;
                        case '15' :
                            update_text = "오후 3시의<br/>따끈한 랭킹!";
                            break;
                        case '18' :
                            update_text = "오후 6시의<br/>따끈한 랭킹!";
                            break;
                        case '21' :
                            update_text = "오후 9시의<br/>따끈한 랭킹!";
                            break;
                    }
                }else {
                    if (now >= new Date(now.getFullYear(), now.getMonth(), now.getDate(), 1, 0, 0) && now < new Date(now.getFullYear(), now.getMonth(), now.getDate(),3, 0, 0)) {
                        update_text = "야심한 새벽,<br/>다들 뭐 살까?";
                    } else if (now >= new Date(now.getFullYear(), now.getMonth(), now.getDate(), 4, 0 , 0) && now < new Date(now.getFullYear(), now.getMonth(), now.getDate(), 6, 0, 0)) {
                        update_text = "모두 잠들고<br/>나만 보는 랭킹";
                    } else if (now >= new Date(now.getFullYear(), now.getMonth(), now.getDate(), 7 , 0, 0) && now < new Date(now.getFullYear(), now.getMonth(), now.getDate(), 9, 0, 0)) {
                        update_text = "상쾌한 아침의<br/>따끈한 랭킹";
                    } else if (now >= new Date(now.getFullYear(), now.getMonth(), now.getDate(), 10, 0, 0) && now < new Date(now.getFullYear(), now.getMonth(), now.getDate(), 12, 0, 0)) {
                        update_text = "활기찬 오전의<br/>베스트 랭킹";
                    } else if (now >= new Date(now.getFullYear(), now.getMonth(), now.getDate(), 13, 0, 0) && now < new Date(now.getFullYear(), now.getMonth(), now.getDate(), 15, 0, 0)) {
                        update_text = "즐거운 점심의<br/>베스트 랭킹";
                    } else if (now >= new Date(now.getFullYear(), now.getMonth(), now.getDate(), 16, 0, 0) && now < new Date(now.getFullYear(), now.getMonth(), now.getDate(), 18, 0, 0)) {
                        update_text = "나른한 오후의<br/>베스트 랭킹";
                    } else if (now >= new Date(now.getFullYear(), now.getMonth(), now.getDate(), 19, 0, 0) && now < new Date(now.getFullYear(), now.getMonth(), now.getDate(), 21, 0, 0)) {
                        update_text = "평온한 저녁의<br/>따끈한 랭킹";
                    } else if (now >= new Date(now.getFullYear(), now.getMonth(), now.getDate(), 22, 0, 0) && now < new Date(now.getFullYear(), now.getMonth(), now.getDate(), 24, 0, 0)) {
                        update_text = "오늘 하루<br/>다들 뭐 샀을까?";
                    }
                }

                _this.update_text = update_text;
            }
            , error: function (xhr) {
                console.log(xhr.responseText);
            }
        });
    }
})