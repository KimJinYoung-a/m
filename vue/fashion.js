// json - apiurl
var dataurl = "/fashion/";
var json_data1 = dataurl+"json_data1.asp";
var json_data2 = dataurl+"json_data2.asp";

//lazy load
Vue.use(VueLazyload, {
	preLoad: 1.3,
	error : false,
	loading : false,
	supportWebp : false,
	listenEvents: ['scroll', 'wheel', 'mousewheel', 'resize', 'animationend', 'transitionend', 'touchmove']
})

// component
// rolling
Vue.component('item-rolling',{
	props: ['item','isapp'],
	template : '\
				<div class="swiper-slide" v-if="isapp > 0">\
					<a @click="fnAPPpopupAutoUrl(item.linkurl);">\
						<div class="thumbnail"><img :src="item.image" :alt="item.eventname" /></div>\
						<div class="desc">\
							<b class="headline"><span class="ellipsis">{{item.eventname}}</span> <b class="discount color-red" if="item.saleper">{{item.saleper}}</b></b>\
							<p class="subcopy"><span class="ellipsis">{{item.eventsubcopy}}</span></p>\
						</div>\
					</a>\
				</div>\
				<div class="swiper-slide" v-else>\
					<a :href="item.linkurl">\
						<div class="thumbnail"><img :src="item.image" :alt="item.eventname" /></div>\
						<div class="desc">\
							<b class="headline"><span class="ellipsis">{{item.eventname}}</span> <b class="discount color-red" if="item.saleper">{{item.saleper}}</b></b>\
							<p class="subcopy"><span class="ellipsis">{{item.eventsubcopy}}</span></p>\
						</div>\
					</a>\
				</div>\
				'
})

Vue.component('item-list',{
	props: ['item','isapp','index'],
	template : '\
				<li v-if="isapp > 0">\
					<a @click="fnAPPpopupAutoUrl(item.linkurl);">\
						<div class="thumbnail"><img :src="item.image" :alt="item.eventname" v-if="index == 10 || index == 14"/><img :src="item.imagewide" :alt="item.eventname" v-else/></div>\
						<p class="desc">\
							<b class="headline"><span class="ellipsis">{{item.eventname}}</span> <b class="discount color-red" if="item.saleper">{{item.saleper}}</b></b>\
							<span class="subcopy">{{item.eventsubcopy}}</span>\
						</p>\
					</a>\
				</li>\
				<li v-else>\
					<a :href="item.linkurl">\
						<div class="thumbnail"><img :src="item.image" :alt="item.eventname" v-if="index == 10 || index == 14"/><img :src="item.imagewide" :alt="item.eventname" v-else/></div>\
						<p class="desc">\
							<b class="headline"><span class="ellipsis">{{item.eventname}}</span> <b class="discount color-red" if="item.saleper">{{item.saleper}}</b></b>\
							<span class="subcopy">{{item.eventsubcopy}}</span>\
						</p>\
					</a>\
				</li>\
				'
})

Vue.component('brand-list',{
	props: ['item','isapp','index'],
	template : '\
				<div class="swiper-slide" v-if="isapp > 0">\
					<a @click="fnAPPpopupAutoUrl(item.linkurl);">\
						<div class="thumbnail" v-if="index < 1"><img :src="item.image" :alt="item.brandnameEN" /></div>\
						<div class="thumbnail" v-else><img v-lazy="item.image" :alt="item.brandnameEN" /></div>\
						<div class="desc">\
							<h3 class="headline">{{item.brandnameEN}}</h3>\
							<p class="headline">{{item.brandnameKR}}</p>\
						</div>\
					</a>\
					<a @click="myzzimbrand(item.makerid);" class="btn-zzim ziim-on" v-if="item.mybrand > 0">찜브랜드 추가</a>\
					<a @click="myzzimbrand(item.makerid);" class="btn-zzim" v-else>찜브랜드 추가</a>\
				</div>\
				<div class="swiper-slide" v-else>\
					<a :href="item.linkurl">\
						<div class="thumbnail" v-if="index < 1"><img :src="item.image" :alt="item.brandnameEN" /></div>\
						<div class="thumbnail" v-else><img v-lazy="item.image" :alt="item.brandnameEN" /></div>\
						<div class="desc">\
							<h3 class="headline">{{item.brandnameEN}}</h3>\
							<p class="headline">{{item.brandnameKR}}</p>\
						</div>\
					</a>\
					<a @click="myzzimbrand(item.makerid);" class="btn-zzim ziim-on" v-if="item.mybrand > 0">찜브랜드 추가</a>\
					<a @click="myzzimbrand(item.makerid);" class="btn-zzim" v-else>찜브랜드 추가</a>\
				</div>\
				',
	methods : {
		myzzimbrand : function(event,index){
			var _toggle = this.$el.querySelector('.btn-zzim');
			$.ajax({
				type:"GET",
				url:"/street/myzzimbrand.asp",
				data: "makerid="+event,
				dataType: "text",
				async:false,
				success : function(Data){
					result = jQuery.parseJSON(Data);
					if (result.resultcode=="11"){
						_toggle.className = "btn-zzim ziim-on";
						alert('찜브랜드에 추가 되었습니다.');
						return;
					}
					else if (result.resultcode=="22"){
						_toggle.className = "btn-zzim";
						alert('찜브랜드에 삭제 되었습니다.');
						return;
					}
					else if (result.resultcode=="00"){
						alert('로그인 후에 이용 하실 수 있습니다.');
						return;
					}
					else if (result.resultcode=="99"){
						alert('브랜드를 선택 해주세요');
						return;
					}
				}
			});
		}
	}
})


// fashion event data
var eventdata = new Vue({
	data: function() {
		return {
			items:  []
		}
    },
    created: function () {
        var self = this;
        $.getJSON(json_data1, function (data, status, xhr) {
			if (status == "success") {
				self.items = data;
			} else {
				console.log("JSON data not Loaded.");
			}
        });
    }
})

// fashion rolling
var rolling = new Vue({
	el : '#rollingbanner',
	data :  eventdata.$data ,
	updated: function() {
		this.$nextTick(function() {
			setTimeout(function(){
				var fMainSwiper = new Swiper(".fashion-main-bnr .swiper-container", {
					loop:true,
					slidesPerView:'auto',
					centeredSlides:true,
					speed:600
				});
			},100);
		});
	}
})

// fashion event1
var eventlist1 = new Vue({
	el : '#exhibition1',
	data :  eventdata.$data ,
})

// fashion event2
var eventlist2 = new Vue({
	el : '#exhibition2',
	data :  eventdata.$data ,
})

// fashion hotbrand
var hotbrand = new Vue({
	el : '#hotbrand',
	data: function() {
		return {
			items:  []
		}
    },
    created: function () {
        var self = this;
        $.getJSON(json_data2, function (data, status, xhr) {
			if (status == "success") {
				self.items = data;
			} else {
				console.log("JSON data not Loaded.");
			}
        });
    },
	updated: function() {
		this.$nextTick(function() {
			setTimeout(function(){
				var fBrandSwiper = new Swiper(".fashion-brand .swiper-container",{
					slidesPerView:'auto',
					speed:600
				});
			},100);
		});
	}
})