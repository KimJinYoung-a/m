Vue.component('main-banner',{
    props: ['item','isapp'],
    template : '\
				<a @click="fnAmplitudeEventAction(item.ampevt,item.ampevtp,item.ampevtpv,function(bool){if(bool) {fnAPPpopupAutoUrl(item.link);}});" v-if="isapp > 0"><div class="thumbnail"><img v-lazy="item.imgsrc"></div></a>\
				<a :href="item.link" @click="fnAmplitudeEventAction(item.ampevt,item.ampevtp,item.ampevtpv);" v-else><div class="thumbnail"><img v-lazy="item.imgsrc"></div></a>\
				'
})