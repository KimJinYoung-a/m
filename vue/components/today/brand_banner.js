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