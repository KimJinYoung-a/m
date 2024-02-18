// json - apiurl
//pc 78/79/80/81/82
var dataurl = "/chtml/main/loader/2017loader/";
var data_foryou = dataurl+"json_foryou.asp";

//필터
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

const todayMixin = Vue.mixin({
	methods: {
		/**
		 * Base64 디코딩
		 * @param str 디코딩할 문자열
		 * @returns {string} 디코딩된 문자열
		 */
		decodeBase64(str) {
			if( str != null )
				return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
			else
				return '';
		},
		/**
		 * 숫자에 콤마(',') 찍어서 리턴
		 * @param num 숫자
		 * @returns {string} 콤마(',') 찍힌 숫자
		 */
		numberFormat(num){
			num = num.toString();
			return num.replace(/(\d)(?=(?:\d{3})+(?!\d))/g,'$1,');
		}
	}
});
const mdPickMixin = Vue.mixin({
	methods: {
		/**
		 * 아이템 클릭 이벤트
		 */
		clickItem() {
			const amplitudeParameter = this.createAmplitudeParameters();
			const urlParameter = this.sub.itemId + this.createGaParameter();

			if( this.isapp ) {
				const callBack = bool => {if(bool) {fnAPPpopupProduct(urlParameter);}};
				fnAmplitudeEventMultiPropertiesAction(amplitudeParameter.event,amplitudeParameter.titles,
					amplitudeParameter.values, callBack);
			} else {
				fnAmplitudeEventMultiPropertiesAction(amplitudeParameter.event, amplitudeParameter.titles,
					amplitudeParameter.values);
				location.href = '/category/category_itemPrd.asp?itemid=' + urlParameter;
			}
		},
		/**
		 * Amplitude 파라미터 생성
		 * @returns {{values: string, titles: string, event: string}}
		 */
		createAmplitudeParameters() {
			switch (this.sub.type) {
				case 1:
					return {
						event : 'click_maintodaymdpick',
						titles : 'todaymdpicknumber|itemid|categoryname|brand_id',
						values : `${this.index}|${this.sub.itemId}|${this.sub.categoryName}|${this.sub.brandName}`
					};
				case 2:
					return {
						event : 'click_maintodaynew',
						titles : 'todaynewnumber|itemid',
						values : `${this.index}|${this.sub.itemId}`
					};
				case 3:
					return {
						event : 'click_maintodaybest',
						titles : 'todaybestnumber|itemid',
						values : `${this.index}|${this.sub.itemId}`
					};
				case 4:
					return {
						event : 'click_maintodaysale',
						titles : 'todaysalenumber|itemid',
						values : `${this.index}|${this.sub.itemId}`
					};
				default: // enjoy exhibition
					return {
						event : 'click_mainenjoy',
						titles : 'enjoynumber|itemid',
						values : `${this.index}|${this.sub.itemId}`
					}
			}
		},
		/**
		 * GaParameter 생성
		 * @returns {string}
		 */
		createGaParameter() {
			const parameter = '&gaparam=';
			switch (this.sub.type) {
				case 1:
					return parameter + 'today_mdpick_' + this.index;
				case 2:
					return parameter + 'today_new_' + this.index;
				case 3:
					return parameter + 'today_best_' + this.index;
				case 4:
					return parameter + 'today_sale_' + this.index;
				default: // enjoy exhibition
					return parameter + 'today_enjoy_' + this.index;
			}
		}
	}
});

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
// macketingRolling, imageBannerC, guideBanner
Vue.component('main-banner',{
	props: ['item','isapp', 'index'],
	template : `
		<a @click="clickItem">
			<div class="thumbnail">
				<img v-lazy="decodeBase64(item.image)">
			</div>
		</a>
	`,
	methods : {
		/**
		 * 아이템 클릭 이벤트
		 */
		clickItem() {
			const amplitudeParameter = this.createAmplitudeParameters();
			if( this.isapp ) {
				const callBack = bool => { if(bool) fnAPPpopupAutoUrl(this.item.link); }
				fnAmplitudeEventAction(amplitudeParameter.event, amplitudeParameter.titles, amplitudeParameter.values, callBack);
			} else {
				fnAmplitudeEventAction(amplitudeParameter.event, amplitudeParameter.titles, amplitudeParameter.values);
				location.href = this.item.link;
			}
		},
		/**
		 * Amplitude파라미터 생성
		 */
		createAmplitudeParameters() {
			if( this.item.type === 'marketingRolling' ) {
				return {
					event : 'click_mainbanner',
					titles : 'bannertype',
					values : 'mkt_' + (this.index+1)
				};
			} else if( this.item.type === 'imageBannerC' ) {
				return {
					event : 'click_mainbanner',
					titles : 'bannertype',
					values : 'imggif'
				};
			} else if( this.item.type === 'guideBanner' ) {
				return {
					event : 'click_guidebanner',
					titles : 'bannertype',
					values : 'guide' + (this.index+1)
				};
			} else {
				return {};
			}
		},
	}
})

//HCP-List
Vue.component('hcp-list',{
	props: ['item','isapp'],
	template : `
		<a @click="clickItem">
			<div class="thumbnail">
				<span class="label label-circle" v-if="item.contentsType == 'cultureStation'">
					<em>{{item.cultureDescription}}</em>
				</span>
				<img :src="decodeBase64(item.image)">
			</div>
			<div class="desc">
				<h2 class="headline" v-html="item.mainCopy"></h2>
				<p class="subcopy" v-html="item.subCopy"></p>
			</div>
		</a>
	`,
	methods : {
		/**
		 * 아이템 클릭 이벤트
		 */
		clickItem() {
			const amplitudeEvent = this.createAmplitudeEvent();
			if( this.isapp ) {
				const callBack = bool => { if(bool) fnAPPpopupAutoUrl(this.item.link) }
				fnAmplitudeEventAction(amplitudeEvent, '', '', callBack);
			} else {
				fnAmplitudeEventAction(amplitudeEvent, '', '');
				location.href = this.item.link;
			}
		},
		/**
		 * 앰플리튜드 이벤트명 생성
		 */
		createAmplitudeEvent() {
			if( this.item.contentsType === 'hitchhiker' ) {
				return 'click_mainhitchhiker';
			} else if( this.item.contentsType === 'cultureStation' ) {
				return 'click_mainculture';
			} else if( this.item.contentsType === 'playing' ) {
				return 'click_mainplaying';
			} else {
				return '';
			}
		}
	}
})

//mdpick
Vue.component('main-mdpick',{
	mixins : [todayMixin, mdPickMixin],
	props: ['sub','index','isapp'],
	template : `
        <a @click="clickItem">
            <div class="thumbnail">
                <p class="tagV18 t-low" v-if="sub.lowestPrice"><span>최저가</span></p>
                <img :src="decodeBase64(sub.image)" :alt="sub.itemName"/>
            </div>
            <div class="desc">
                <p class="name">{{sub.itemName}}</p>
                <b class="discount color-red" v-if="sub.discount">{{sub.discountText}}</b>
                <b class="discount color-green" v-else-if="sub.coupon">{{sub.discountText}}</b>
            </div>
        </a>
        `,
})

//sale
Vue.component('main-sale',{
	mixins : [todayMixin, mdPickMixin],
	props: ['sub','index','isapp'],
	template : `
		<a @click="clickItem">
			<div class="thumbnail">
				<img :src="decodeBase64(sub.image)" :alt="sub.itemName"/>
			</div>
			<div class="desc">
				<p class="name">{{sub.itemName}}</p>
				<div class="price">
					<b class="discount color-red" v-if="sub.discount">{{sub.discountText}}</b>
                	<b class="discount color-green" v-else-if="sub.coupon">{{sub.discountText}}</b>
					<b class="sum">{{numberFormat(sub.price)}}<span class="won">원</span></b>
				</div>
			</div>
		</a>
		`
})

//new / exhibition //lazy load > 3
Vue.component('main-itemlist',{
	mixins : [todayMixin, mdPickMixin],
	props: ['sub','index','isapp'],
	template : `
		<li class="swiper-slide" v-else>
			<a @click="clickItem">
				<span class="label label-triangle" v-if="sub.newProduct"><em>NEW</em></span>
				<div class="thumbnail" v-if="index < 3"><img :src="decodeBase64(sub.image)" :alt="sub.itemName"/></div>
				<div class="thumbnail" v-else><img v-lazy="decodeBase64(sub.image)" :alt="sub.itemName"/></div>
				<div class="desc">
					<p class="name">{{sub.itemName}}</p>
					<div class="price">
						<b class="discount color-red" v-if="sub.discount">{{sub.discountText}}</b>
                		<b class="discount color-green" v-else-if="sub.coupon">{{sub.discountText}}</b>
						<b class="sum">{{numberFormat(sub.price)}}<span class="won">원</span></b>
					</div>
				</div>
			</a>
		</li>
		`,
})

// imageBannerA, imageBannerB
Vue.component('img-banner',{
	mixins : [todayMixin],
	props: ['item','isapp'],
	template : `
		<a @click="clickItem">
			<div class="thumbnail"><img v-lazy="decodeBase64(item.image)"/></div>
			<div class="desc">
				<span class="label label-speech" v-if="item.discountText || item.couponText">
					<b class="discount" v-if="item.discountText">{{item.discountText}}</b>
					<b v-if="item.couponText">{{item.couponText}}</b>
				</span>
				<h2 class="headline">{{item.mainCopy}}<br />{{item.mainCopy2}}</h2>
				<p class="subcopy">
					<span class="label label-color" v-if="item.eventTag">
						<em class="color-blue">{{item.eventTag}}</em>
					</span>
					<span v-html="this.$options.filters.nl2br(item.subCopy)"></span>
				</p>
			</div>
		</a>
	`,
	methods : {
		/**
		 * 아이템 클릭 이벤트
		 */
		clickItem() {
			const amplitudeParameters = this.createAmplitudeParameters();
			if( this.isapp ) {
				const callBack = bool => { if(bool) fnAPPpopupAutoUrl(this.item.link); }
				fnAmplitudeEventMultiPropertiesAction(amplitudeParameters.event, amplitudeParameters.titles,
					amplitudeParameters.values, callBack);
			} else {
				fnAmplitudeEventMultiPropertiesAction(amplitudeParameters.event, amplitudeParameters.titles,
					amplitudeParameters.values);
				location.href = this.item.link;
			}
		},
		/**
		 * Amplitude 파라미터 생성
		 */
		createAmplitudeParameters() {
			const parameter = {
				event : 'click_mainbanner',
				titles : 'bannertype'
			}
			if( this.item.type === 'imageBannerA' )
				parameter.values = 'imga';
			else if( this.item.type === 'imageBannerB' )
				parameter.values = 'imgb'

			return parameter;
		}
	}
})


//LI-LIST 이벤트 배너
Vue.component('main-eventban',{
	mixins : [todayMixin],
	props: {
		index : { type:Number, default:0 },
		item : { type:Object, default:function() {return {}} },
		isapp : { type:Boolean, default:false },
		start : { type:Number, default:0 },
	},
	template : `
		<li>
			<a @click="clickItem(index)">
				<div class="thumbnail">
					<p v-if="item.onlyTenbyTen" class="tagV18 t-only">
						<span> ONLY <br/> 10X10 </span>
					</p>
					<img :src="decodeBase64(item.image)" style="display:block;width:100%;"/>
				</div>
				<div class="desc">
					<p>
						<b class="headline">
							<span v-if="item.discountText" class="ellipsis">{{item.title1}}</span>
							<span v-else class="ellipsis full">{{item.title1}}</span>
							<b v-if="item.discountText" class="discount color-red">{{item.discountText}}</b>
						</b>
						<span class="subcopy">
							<span v-if="item.eventTag" class="label label-color">
								<em v-if="item.coupon" class="color-green">{{item.eventTag}}</em>
								<em v-else class="color-blue">{{item.eventTag}}</em>
							</span>
							{{item.title2}}
						</span>
					</p>
				</div>
			</a>
		</li>
	`,
	methods : {
		/**
		 * 아이템 클릭 이벤트
		 */
		clickItem() {
			const link = this.decodeBase64(this.item.link);
			const amplitudeEvent = 'click_mainenjoybanner';
			const amplitudeTitles = 'type|linkurl';
			const amplitudeValueSuffix = `${this.createAmplitudeValue()}_${this.index}|${link}`;

			if( this.isapp ) {
				const callback = bool => {if(bool) {fnAPPpopupAutoUrl(link + this.createGaParameter());}};
				fnAmplitudeEventMultiPropertiesAction(amplitudeEvent, amplitudeTitles, amplitudeValueSuffix, callback);
			} else {
				fnAmplitudeEventMultiPropertiesAction(amplitudeEvent, amplitudeTitles, amplitudeValueSuffix);
				location.href = link + this.createGaParameter();
			}
		},
		/**
		 * 앰플리튜드 값 생성
		 */
		createAmplitudeValue() {
			if( this.start === 0 )
				return 'today_Aeventa';
			else if( this.start === 3 )
				return 'today_eventb';
			else if( this.start === 3 )
				return 'today_Aeventc';
			else
				return 'today_Aeventd';
		},
		/**
		 * GA Parameter 생성
		 */
		createGaParameter() {
			let alphabet;
			if( this.start === 0 )
				alphabet = 'a';
			else if( this.start === 3 )
				alphabet = 'b';
			else if( this.start === 3 )
				alphabet = 'c';
			else
				alphabet = 'd';
			return `&gaparam=today_event${alphabet}_${this.start+this.index}`;
		},
	}
})

//LI-LIST 이벤트 배너 + 상품타입
Vue.component('main-eventbanitems',{
	mixins : [todayMixin],
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
	mixins : [todayMixin],
	props: ['item','isapp'],
	template : `
		<div>
			<a @click="clickTitle">
				<div class="thumbnail type-b"><img :src="decodeBase64(item.titleImage)" alt=""/></div>
				<div class="desc">
					<h2 class="headline">BRAND;</h2>
					<h3 class="headline">{{item.mainCopy}}</h3>
					<p v-html="this.$options.filters.nl2br(item.subCopy)"></p>
				</div>
			</a>
			<div class="brand-items">
				<ul>
					<li v-for="(product, index) in item.items">
						<a @click="clickItem(index, product.itemId)">
							<div class="thumbnail">
								<img :src="decodeBase64(product.image)" alt=""/>
							</div>
						</a>
					</li>
				</ul>
				<div class="btn-group">
					<a @click="clickMore">
						<div class="thumbnail">
							<img :src="decodeBase64(item.moreImage)" style="filter:Alpha(Opacity=50);Opacity:0.5;" alt="" />
						</div>
						<span class="btn-more">더보기<span class="icon icon-arrow"></span></span>
					</a>
				</div>
			</div>
		</div>
	`,
	data() {return {
		gaParameter : '&gaparam=today_brand_'
	}},
	methods : {
		clickTitle() {
			const brandId = this.item.brandId;
			if( this.isapp ) {
				const callback = bool => {if(bool) {fnAPPpopupBrand(brandId);}};
				fnAmplitudeEventMultiPropertiesAction('click_mainbrand', 'brand_id', brandId, callback);
			} else {
				fnAmplitudeEventAction('click_mainbrand', 'brand_id', brandId);
				location.href = '/brand/brand_detail2020.asp?brandid=' + brandId + this.gaParameter + 'img';
			}
		},
		clickItem(index, itemId) {
			const url = `/category/category_itemPrd.asp?itemid=${itemId}${this.gaParameter}${index+1}`;
			const amplitudeEvent = 'click_mainbrand_items';
			const amplitudePropertyTitles = 'indexnumber|itemid';
			const amplitudePropertyValues = `${index+1}|${itemId}`;

			if( this.isapp ) {
				const callback = bool => {if(bool) {fnAPPpopupAutoUrl(url);}};
				fnAmplitudeEventMultiPropertiesAction(amplitudeEvent,amplitudePropertyTitles, amplitudePropertyValues, callback);
			} else {
				fnAmplitudeEventAction(amplitudeEvent, amplitudePropertyTitles, amplitudePropertyValues);
				location.href = url;
			}
		},
		clickMore() {
			const link = this.item.link + this.gaParameter + '0';
			if( this.isapp ) {
				fnAPPpopupAutoUrl(link);
			} else {
				location.href = link;
			}
		}
	}
})

//twin 단품 배너
Vue.component('twin-item',{
	mixins : [todayMixin],
	props : {
		isapp : { type:Boolean, default:false },
		items : { type:Array, default:() => {return [];} }
	},
	template : `
		<ul class="items">
			<li v-for="(item, index) in items">
				<a @click="clickItem(item.itemId, index)">
					<span v-if="item.newProduct || item.best" class="label label-triangle">
						<em v-if="item.newProduct">NEW</em>
						<em v-if="item.best">BEST</em>
					</span>
					<div class="thumbnail"><img :src="decodeBase64(item.image)" alt=""></div>
					<div class="desc">
						<b class="headline">{{item.mainCopy}} <u>{{item.itemName}}</u></b>
						<span class="price">
							<b v-if="item.discountText" class="discount color-red">{{item.discountText}}</b>
							<b class="sum">{{item.price}}<span class="won">원</span></b>
						</span>
					</div>
				</a>
			</li>
		</ul>
	`,
	methods : {
		/**
		 * 아이템 클릭 이벤트
		 */
		clickItem(itemId, index) {
			const link = `/category/category_itemPrd.asp?itemid=${itemId}&gaparam=today_itembanner_${index+1}`
			const amplitudeParameters = this.createAmplitudeParameters(itemId, index);

			if( this.isapp ) {
				const callback = bool => {if(bool) {fnAPPpopupAutoUrl(link);}};
				fnAmplitudeEventMultiPropertiesAction(amplitudeParameters.title, amplitudeParameters.titles,
					amplitudeParameters.values, callback);
			} else {
				fnAmplitudeEventAction(amplitudeParameters.title, amplitudeParameters.titles,
					amplitudeParameters.values);
				location.href = link;
			}
		},
		/**
		 * Ampliutde 파라미터 생성
		 */
		createAmplitudeParameters(itemId, index) {
			return {
				event : 'click_maintwoproducts',
				titles : 'index|itemid',
				values : `${index === 0 ? 'A' : 'B'}|${itemId}`
			};
		},
	}
});

const categoryMoreMixin = Vue.mixin({
	props: {
		categoryCode : { type:String, default:'' },
		sort : { type:Number, default:0 },
		item : { type:Object, default:() => {return {}} },
		isapp : { type:Boolean, default:false },
	},
	methods : {
		/**
		 * GA Parameter 생성
		 */
		createGaParameter(categoryCode) {
			let keyword;
			switch (categoryCode) {
				case "102":
					keyword = "digital"; break;
				case "124":
					keyword = "appliances"; break;
				case "121":
					keyword = "furniture"; break;
				case "122":
					keyword = "light"; break;
				case "120":
					keyword = "fabric"; break;
				case "112":
					keyword = "kitchen"; break;
				case "119":
					keyword = "food"; break;
				case "117":
					keyword = "fashion"; break;
				case "116":
					keyword = "shoes"; break;
				case "125":
					keyword = "jewely"; break;
				case "118":
					keyword = "beauty"; break;
				case "103":
					keyword = "travel"; break;
				case "104":
					keyword = "toy"; break;
				case "115":
					keyword = "kids"; break;
				case "110":
					keyword = "pet"; break;
				default:
					keyword = "stationery";
			}
			return `&gaparam=today_${keyword}_${this.sort}`;
		},
	}
});

// 투데이 더보기 - 카테고리 상품
Vue.component('cateitem-more',{
	mixins : [todayMixin, categoryMoreMixin],
	template : `
		<div>
			<li>
				<a @click="clickItem">
					<div class="thumbnail"><img :src="decodeBase64(item.image)" alt="" /></div>
					<div class="desc">
						<p class="name">{{item.itemName}}</p>
						<div class="price">
							<b class="discount color-red">{{item.discountText}}</b>
							<b class="sum">{{item.price}}<span class="won">원</span></b>
						</div>
					</div>
				</a>
			</li>
		</div>
	`,
	methods : {
		/**
		 * 아이템 클릭 이벤트
		 */
		clickItem() {
			const link = `/category/category_itemPrd.asp?itemid=${this.item.itemId}${this.createGaParameter(this.categoryCode)}`;
			if( this.isapp )
				fnAPPpopupAutoUrl(link);
			else
				location.href = link;
		},
	}
})

// 투데이 더보기 - 카테고리 이벤트
Vue.component('event-more',{
	mixins : [todayMixin, categoryMoreMixin],
	template : `
		<div>
			<li>
				<a @click="clickItem">
					<div class="thumbnail"><img :src="decodeBase64(item.image)" alt=""></div>
					<p class="desc">
						<b class="headline">
							<span v-if="item.discountText" class="ellipsis">{{item.mainCopy}}</span>
							<span v-else class="ellipsis full">{{item.mainCopy}}</span>
							<b v-if="item.discountText" class="discount color-red">{{sub.discountText}}</b>
						</b>
						<span v-html="item.subCopy" class="subcopy"></span>
					</p>
				</a>
			</li>
		</div>
	`,
	methods : {
		/**
		 * 아이템 클릭 이벤트
		 */
		clickItem() {
			const link = `/event/eventmain.asp?eventid=${this.item.eventCode}${this.createGaParameter(this.categoryCode)}`;
			if( this.isapp )
				fnAPPpopupAutoUrl(link);
			else
				location.href = link;
		},
	}
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

// mdpick
new Vue({
	el: "#mdpickSwiper",
	store : store,
	computed : {
		mixItems() {
			const mdPicks = this.$store.getters.mdPicks.mdPick;
			const mixItems = [];
			for( let i=0 ; i<mdPicks.length ; i++ ) {
				const item = mdPicks[i];
				if( item ) {
					if( i%2 === 0 ) {
						mixItems.push([item]);
					} else {
						mixItems[Math.floor(i/2)].push(item);
					}
				} else {
					break;
				}
			}
			return mixItems;
		},
		isEvenItemsLength() {
			return this.mixItems.length > 0 && this.mixItems[this.mixItems.length-1].length === 2;
		}
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
	},
})
// New
new Vue({
	el: "#newSwiper",
	store : store,
	computed : {
		items() { return this.$store.getters.mdPicks.newProducts; },
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
		mixItems() {
			const onSale = this.$store.getters.mdPicks.onSale;
			const mixItems = [];
			for( let i=0 ; i<onSale.length ; i++ ) {
				const item = onSale[i];
				if( item ) {
					if( i%2 === 0 ) {
						mixItems.push([item]);
					} else {
						mixItems[Math.floor(i/2)].push(item);
					}
				} else {
					break;
				}
			}
			return mixItems;
		},
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

//region oneBanner (마케팅롤링, 이미지배너a,b,c , 히치하이커, 가이드배너)
// 마케팅 롤링 - main-banner
new Vue({ el: "#mktbanner", store : store, computed : { items() { return this.$store.getters.oneBanners; } } })
// 이미지배너A 롤링 - img-banner
new Vue({ el: "#imgbanA", store : store, computed : { items() { return this.$store.getters.oneBanners; } } })
// 이미지배너B 롤링 - img-banner
new Vue({ el: "#imgbanB", store : store, computed : { items() { return this.$store.getters.oneBanners; } } })
// 이미지배너C 롤링 - main-banner
new Vue({ el: "#imgbanC", store : store, computed : { items() { return this.$store.getters.oneBanners; } } })
// 히치하이커 컬쳐 플레잉 - hcp-list
new Vue({ el: "#HCPlist", store : store, computed : { items() { return this.$store.getters.oneBanners; } } })
// 가이드 배너 - main-banner
new Vue({ el: "#guideList", store : store, computed : { items() { return this.$store.getters.oneBanners; } } })
//endregion

// 키워드
new Vue({
	el: "#mainkeyword",
	store : store,
	computed : {
		items() { return this.$store.getters.keywords; },
		isApp() { return location.pathname.toLowerCase().indexOf('/apps/appcom/wish/web2014') > -1; },
	},
	methods : {
		clickItem(index, itemId, link) {
			if( this.isApp ) {
				const callBack = bool => {if(bool) {fnAPPpopupAutoUrl(link);}};
				fnAmplitudeEventMultiPropertiesAction('click_mainhotkeyword','indexnumber|itemid',`${index}|${itemId}`, callBack);
			} else {
				fnAmplitudeEventMultiPropertiesAction('click_mainhotkeyword','indexnumber|itemid',`${index}|${itemId}`);
				location.href = link;
			}
		}
	}
})

//region enjoys (엔조이 이벤트 1,2,3,4)
// 엔조이이벤트 1
new Vue({
	el: "#enjoyevent1", store : store,
	computed : {
		items() { return this.$store.getters.enjoys.filter((i1, i2) => i2<3); }
	}
});
// 엔조이이벤트 2
new Vue({
	el: "#enjoyevent2", store : store,
	computed : {
		items() { return this.$store.getters.enjoys.filter((i1, i2) => i2>=3 && i2<6); }
	}
});
// 엔조이이벤트 3
new Vue({
	el: "#enjoyevent3", store : store,
	computed : {
		items() { return this.$store.getters.enjoys.filter((i1, i2) => i2>=6 && i2<9); }
	}
});
// 엔조이이벤트 4
new Vue({
	el: "#enjoyevent4", store : store,
	computed : {
		items() { return this.$store.getters.enjoys.filter((i1, i2) => i2>=9 && i2<12); }
	}
});
//endregion

// 브랜드 배너
new Vue({
	el: "#mainbrand",
	store : store,
	computed: {
        items() { return this.$store.getters.brands; },
    },
})

// 단품 배너
new Vue({
	el: "#twinitems",
	store : store,
	computed : {
		twinItems() { return this.$store.getters.twinItems; }
	}
});

// today 더보기 
new Vue({
	el : '#todaymore',
	mixins : [categoryMoreMixin],
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
		items() { return this.$store.getters.categories; },
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
		},
		linkUrl(categoryCode) {
			return '/category/category_main2020.asp?disp=' + categoryCode + this.createGaParameter(categoryCode) + '0';
		},
	},
	mounted : function(){
		this.scroll();
		this.show = true;
	}
})

// today - 개인화1 foryou
var vm = new Vue({
	el : '#foryou',
	data :  function() {
		return {
			openlayer : false,	// display content after API request
			username : '',
			items : []		// api 데이터
		}
	},
	created : function(){
		// get the data by performing API request
		var _this = this;
		$.getJSON(data_foryou, function (data, status, xhr) {
			if (status == "success") {
				_this.items = data;
				if (data != null && data.length > 0)
				{
					_this.username = data[0].username;
					_this.openlayer = true;
				}
			} else {
				console.log("JSON data not Loaded.");
			}
        });
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