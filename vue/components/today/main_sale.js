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