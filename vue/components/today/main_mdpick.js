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