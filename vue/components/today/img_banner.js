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