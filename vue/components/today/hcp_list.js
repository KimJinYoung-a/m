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