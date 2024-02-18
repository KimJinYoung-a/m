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