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