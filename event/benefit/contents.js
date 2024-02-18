// json - apiurl
//pc 78/79/80/81/82
var dataurl = "/chtml/main/loader/2017loader/";
var data_mainbanner = dataurl+"json_main_loader.asp";

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

//컴포넌트-탬플릿
//스와이퍼 롤링
Vue.component('main-banner',{
	props: ['item','isapp'],
	template : '\
				<a @click="fnAmplitudeEventAction(item.ampevt,item.ampevtp,item.ampevtpv,function(bool){if(bool) {fnAPPpopupAutoUrl(item.link);}});" v-if="isapp > 0"><div class="thumbnail"><img v-lazy="item.imgsrc"></div></a>\
				<a :href="item.link" @click="fnAmplitudeEventAction(item.ampevt,item.ampevtp,item.ampevtpv);" v-else><div class="thumbnail"><img v-lazy="item.imgsrc"></div></a>\
				'
})

// 메인배너 data json
var mainbannerdata = new Vue({
	data: {
        items: {
		  type: String
		}
    },
    created: function () {
        var self = this;
        $.getJSON(data_mainbanner, function (data, status, xhr) {
			if (status == "success") {
				self.items = data;
			} else {
				console.log("JSON data not Loaded.");
			}
        });
    }
})

// 마케팅 롤링
new Vue({
	el: "#mktbanner",
	data: mainbannerdata.$data
})