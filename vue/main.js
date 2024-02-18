// json - apiurl
var data_mainbanner = "/chtml/main/loader/2016loader/json_main_loader.asp?poscode=2063";
var data_mktbanner = "/chtml/main/loader/2016loader/json_main_loader.asp?poscode=2065";
var data_hotkeyword = "/chtml/main/loader/2016loader/json_hotkeyword.asp";
var data_todayenjoy = "/chtml/main/loader/2016loader/json_todayenjoy.asp";
var data_mdpick = "/chtml/main/loader/2016loader/json_mdpick.asp";
var data_imgbanA = "/chtml/main/loader/2016loader/json_main_loader.asp?poscode=2067";
var data_imgbanB = "/chtml/main/loader/2016loader/json_main_loader.asp?poscode=2068";
var data_imgbanC = "/chtml/main/loader/2016loader/json_main_loader.asp?poscode=2073";
var data_brand = "/chtml/main/loader/2016loader/json_main_loader.asp?poscode=2069";
var data_exhibition = "/chtml/main/loader/2016loader/json_exhibition.asp";
var data_PCHdata = "/chtml/main/loader/2016loader/json_main_loader.asp?poscode=2071";

//필터
Vue.filter('nl2br', function (value) {
  // 처리된 값을 반환합니다
    return String(value).replace(' ', '<br>');
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
Vue.component('main-rolling',{
	props: ['item','isapp'],
	template : '\
				<div class="swiper-slide" v-if="isapp > 0"><a @click="fnAPPpopupAutoUrl(item.link);"><img :src="item.imgsrc" :alt="item.alt"/></a></div>\
				<div class="swiper-slide" v-else><a :href="item.link"><img :src="item.imgsrc" :alt="item.alt"/></a></div>\
				'
})

//LI-LIST
Vue.component('main-list',{
	props: ['item','isapp'],
	template : '\
				<li v-if="isapp > 0"><a @click="fnAPPpopupAutoUrl(item.link);"><div class="pPhoto"><img :src="item.imgsrc" :alt="item.title" /></div><span><i>#</i>{{item.title}}</span></a></li>\
				<li v-else><a :href="item.link"><div class="pPhoto"><img :src="item.imgsrc" :alt="item.title" /></div><span><i>#</i>{{item.title}}</span></a></li>\
				'
})

//LI-LIST 이벤트 배너
Vue.component('main-eventban',{
	props: ['item','isapp'],
	template : '\
				<li v-if="isapp > 0">\
					<a @click="fnAPPpopupAutoUrl(item.link);">\
						<div class="thumbnail"><img :src="item.imgsrc" :alt="item.alt" style="display:block;width:100%;"/></div>\
						<div class="desc">\
							<p>\
								<strong>{{item.title1}}</strong>\
								<span>{{item.title2}}</span>\
							</p>\
							<div class="label">\
								<b class="grey" v-if="item.opt"><span><i v-html="this.$options.filters.nl2br(item.opt)"></i></span></b>\
								<b class="red" v-if="item.sale"><span><i>{{item.sale}}</i></span></b>\
							</div>\
						</div>\
					</a>\
				</li>\
				<li v-else>\
					<a :href="item.link">\
						<div class="thumbnail"><img :src="item.imgsrc" :alt="item.alt" style="display:block;width:100%;"/></div>\
						<div class="desc">\
							<p>\
								<strong>{{item.title1}}</strong>\
								<span>{{item.title2}}</span>\
							</p>\
							<div class="label">\
								<b class="grey" v-if="item.opt"><span><i v-html="this.$options.filters.nl2br(item.opt)"></i></span></b>\
								<b class="red" v-if="item.sale"><span><i>{{item.sale}}</i></span></b>\
							</div>\
						</div>\
					</a>\
				</li>\
				'
})

//LI-LIST //lazy load > 3
Vue.component('main-itemlist',{
	props: ['sub' , 'index','isapp'],
	template : '\
				<div class="swiper-slide" v-if="isapp > 0">\
					<a @click="fnAPPpopupProduct(sub.link);">\
						<div class="pPhoto" v-if="index < 3"><img :src="sub.imgsrc" alt="sub.alt" /></div>\
						<div class="pPhoto" v-else><img v-lazy="sub.imgsrc" alt="sub.alt" /></div>\
						<div class="pdtCont">\
							<p class="pName">{{sub.name}}</p>\
							<div class="pPrice">{{sub.price}}</div>\
						</div>\
						<div class="label">\
							<b class="red" v-if="sub.sale"><span><i>{{sub.sale}}</i></span></b>\
							<b class="mint" v-if="sub.itemno < 50"><span><i>한정</i></span></b>\
						</div>\
					</a>\
				</div>\
				<div class="swiper-slide" v-else>\
					<a :href="sub.link">\
						<div class="pPhoto" v-if="index < 3"><img :src="sub.imgsrc" alt="sub.alt" /></div>\
						<div class="pPhoto" v-else><img v-lazy="sub.imgsrc" alt="sub.alt" /></div>\
						<div class="pdtCont">\
							<p class="pName">{{sub.name}}</p>\
							<div class="pPrice">{{sub.price}}</div>\
						</div>\
						<div class="label">\
							<b class="red" v-if="sub.sale"><span><i>{{sub.sale}}</i></span></b>\
							<b class="mint" v-if="sub.itemno < 50"><span><i>한정</i></span></b>\
						</div>\
					</a>\
				</div>\
				'
})

//Div-List
Vue.component('div-list',{
	props: ['item','isapp'],
	template : '\
				<div v-if="isapp > 0"><a @click="fnAPPpopupAutoUrl(item.link);"><img :src="item.imgsrc" :alt="item.alt" /></a></div>\
				<div v-else><a :href="item.link"><img :src="item.imgsrc" :alt="item.alt" /></a></div>\
				'
})

//brand-street
Vue.component('brand-street',{
	props: ['item','index','isapp'],
	template : '\
				<div class="inner" v-if="isapp > 0">\
					<a @click="fnAPPpopupAutoUrl(item.link);">\
						<div class="desc">\
							<p>\
								<span lang="en" class="en">{{item.socname}}</span>\
								<span class="ko">{{item.socname_kor}}</span>\
							</p>\
						</div>\
						<div class="thumbnail"><img :src="item.imgsrc" :alt="item.socname_kor" /></div>\
					</a>\
				</div>\
				<div class="inner" v-else>\
					<a :href="item.link">\
						<div class="desc">\
							<p>\
								<span lang="en" class="en">{{item.socname}}</span>\
								<span class="ko">{{item.socname_kor}}</span>\
							</p>\
						</div>\
						<div class="thumbnail"><img :src="item.imgsrc" :alt="item.socname_kor" /></div>\
					</a>\
				</div>\
				'
})

//HCP-List
Vue.component('foot-list2',{
	props: ['item','isapp'],
	template : '\
				<a @click="fnAPPpopupAutoUrl(item.link);" v-if="isapp > 0">\
					<div class="inner">\
						<div class="thumbnail"><img :src="item.imgsrc" alt="item.maincopy" /></div>\
						<div class="desc">\
							<h2>{{item.maincopy}}</h2>\
							<p v-html="item.subcopy"></p>\
						</div>\
						<div class="label" v-if="item.cgubun == 2">\
							<b class="red"><span><i>{{item.culopt}}</i></span></b>\
						</div>\
					</div>\
				</a>\
				<a :href="item.link" v-else>\
					<div class="inner">\
						<div class="thumbnail"><img :src="item.imgsrc" alt="item.maincopy" /></div>\
						<div class="desc">\
							<h2>{{item.maincopy}}</h2>\
							<p v-html="item.subcopy"></p>\
						</div>\
						<div class="label" v-if="item.cgubun == 2">\
							<b class="red"><span><i>{{item.culopt}}</i></span></b>\
						</div>\
					</div>\
				</a>\
				'
})

// 핫키워드
new Vue ({
	el: "#hkeyword",
	data: {
        items: {
		  type: String
		}
    },
    created: function () {
        var self = this;
        $.getJSON(data_hotkeyword, function (data, status, xhr) {
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
	el: "#mktRolling",
	data: {
        items: {
		  type: String
		}
    },
    created: function () {
        var self = this;
        $.getJSON(data_mktbanner, function (data, status, xhr) {
			if (status == "success") {
				self.items = data;
			} else {
				console.log("JSON data not Loaded.");
			}
        }).done(function() {
			setTimeout(function(){
				if ($("#mktRolling .swiper-container .swiper-slide").length > 1) {
					var swiper2 = new Swiper("#mktRolling .swiper-container", {
						pagination:"#mktRolling .paginationDot",
						paginationClickable:true,
						loop:true,
						speed:800
						,onImagesReady:function(){
							chkSwiper++;
							setTimeout(function(){rectPosition('#mktRolling');},200);
						}
					});
				} else {
					var swiper2 = new Swiper("#mktRolling .swiper-container", {
						pagination:false,
						noSwipingClass:".noswiping",
						noSwiping:true
					});
				}
			}, 100);
		 });
    }
})

// 엔조이 이벤트 data json
var enjoydata = new Vue({
	data: {
        items: {
		  type: String
		}
    },
    created: function () {
        var self = this;
        $.getJSON(data_todayenjoy, function (data, status, xhr) {
			if (status == "success") {
				self.items = data;
			} else {
				console.log("JSON data not Loaded.");
			}
        });
    }
})

//mdpick 관련
var mdpick = new Vue({
	data: {
        items: {
		  type: String
		}
    },
    created: function () {
        var self = this;
        $.getJSON(data_mdpick, function (data, status, xhr) {
			if (status == "success") {
				self.items = data;
			} else {
				console.log("JSON data not Loaded.");
			}
        });
    }
})

// exhibition data json
var exhibi = new Vue({
	data: {
        items: {
		  type: String
		}
    },
    created: function () {
        var self = this;
        $.getJSON(data_exhibition, function (data, status, xhr) {
			if (status == "success") {
				self.items = data;
			} else {
				console.log("JSON data not Loaded.");
			}
        });
    }
})

//이미지 배너A
new Vue({
	el: "#imgbannerA",
	data: {
        items: {
		  type: String
		}
    },
    created: function () {
        var self = this;
        $.getJSON(data_imgbanA, function (data, status, xhr) {
			if (status == "success") {
				self.items = data;
			} else {
				console.log("JSON data not Loaded.");
			}
        });
    }
})

//이미지 배너B
new Vue({
	el: "#imgbannerB",
	data: {
        items: {
		  type: String
		}
    },
    created: function () {
        var self = this;
        $.getJSON(data_imgbanB, function (data, status, xhr) {
			if (status == "success") {
				self.items = data;
			} else {
				console.log("JSON data not Loaded.");
			}
        });
    }
})

//이미지 배너C
new Vue({
	el: "#imgbannerC",
	data: {
        items: {
		  type: String
		}
    },
    created: function () {
        var self = this;
        $.getJSON(data_imgbanC, function (data, status, xhr) {
			if (status == "success") {
				self.items = data;
			} else {
				console.log("JSON data not Loaded.");
			}
        });
    }
})

// 브랜드스트리트 JSON DATA
new Vue({
	el: "#brandStreet",
	data: {
        items: {
		  type: String
		}
    },
    created: function () {
        var self = this;
        $.getJSON(data_brand, function (data, status, xhr) {
			if (status == "success") {
				self.items = data;
			} else {
				console.log("JSON data not Loaded.");
			}
        });
    }
})

//플레이 히치하이커 컬쳐스테이션 ver2
new Vue({
	el: "#enjoyTentenList",
	data: {
        items: {
		  type: String
		}
    },
    created: function () {
        var self = this;
        $.getJSON(data_PCHdata, function (data, status, xhr) {
			if (status == "success") {
				self.items = data;
			} else {
				console.log("JSON data not Loaded.");
			}
        });
    }
})

// 엔조이이벤트 a
new Vue({
	el: "#enjoyevent1",
	data: enjoydata.$data
})

// 엔조이이벤트 b
new Vue({
	el: "#enjoyevent2",
	data: enjoydata.$data	
})

// 엔조이이벤트 c
new Vue({
	el: "#enjoyevent3",
	data: enjoydata.$data,
	created: function () {
		this.$nextTick(function() {
			setTimeout(function(){
				linetobr();
			},100);
		});
    }
})

// mdpick
new Vue({
	el: "#mdPick",
	data: mdpick.$data,
	created: function () {
		this.$nextTick(function() {
			setTimeout(function(){
				var swiper3 = new Swiper("#mdPick .swiper-container", {
					slidesPerView:"auto",
					freeMode:true,
					freeModeMomentumRatio:0.5
					,onImagesReady:function(){
						chkSwiper++;
						setTimeout(function(){rectPosition('#mdPick');},300);
					}
				});
			},300);
		});
    }
})

// New Arrival
new Vue({
	el: "#newArrival",
	data: mdpick.$data,
	created: function () {
		this.$nextTick(function() {
			setTimeout(function(){
				var swiper4 = new Swiper("#newArrival .swiper-container", {
					slidesPerView:"auto",
					freeMode:true,
					freeModeMomentumRatio:0.5
					,onImagesReady:function(){
						chkSwiper++;
						setTimeout(function(){rectPosition('#newArrival');},300);
					}
				});
			},500);
		});
    }
})

// bestSeller
new Vue({
	el: "#bestSeller",
	data: mdpick.$data,
	created: function () {
		this.$nextTick(function() {
			setTimeout(function(){
				var swiper5 = new Swiper("#bestSeller .swiper-container", {
					slidesPerView:"auto",
					freeMode:true,
					freeModeMomentumRatio:0.5
					,onImagesReady:function(){
						chkSwiper++;
						setTimeout(function(){rectPosition('#bestSeller');},300);
					}
				});
			},500);
		});
    }
})

// onSale
new Vue({
	el: "#onSale",
	data: mdpick.$data,
	created: function () {
		this.$nextTick(function() {
			setTimeout(function(){
				var swiper6 = new Swiper("#onSale .swiper-container", {
					slidesPerView:"auto",
					freeMode:true,
					freeModeMomentumRatio:0.5
					,onImagesReady:function(){
						chkSwiper++;
						setTimeout(function(){rectPosition('#onSale');},300);
					}
				});
			},500);
		});
    }
})

// exhibition#1
new Vue({
	el: "#exhibition01",
	data: exhibi.$data,
	created: function () {
		this.$nextTick(function() {
			setTimeout(function(){
				var swiper8 = new Swiper("#exhibition01 .swiper-container", {
					slidesPerView:"auto",
					freeMode:true,
					freeModeMomentumRatio:0.5
					,onImagesReady:function(){
						chkSwiper++;
						setTimeout(function(){rectPosition('#exhibition01');},300);
					}
				});
			},500);
		});
    },
})

// exhibition#2
new Vue({
	el: "#exhibition02",
	data: exhibi.$data,
	created: function () {
		this.$nextTick(function() {
			setTimeout(function(){
				var swiper9 = new Swiper("#exhibition02 .swiper-container", {
					slidesPerView:"auto",
					freeMode:true,
					freeModeMomentumRatio:0.5
					,onImagesReady:function(){
						chkSwiper++;
						setTimeout(function(){rectPosition('#exhibition02');},300);
					}
				});
			},500);
		});
    },
})

function linetobr(){
	$('.listCardV16 ul li').each(function(){
		if ($(this).find('.label').children("b").length == 2) {
			$(this).find('.desc').children('p').children('strong').css('width','74%');
		} else if ($(this).find('.label').children("b").length == 1) {
			$(this).find('.desc').children('p').children('strong').css('width','86%');
		} else {
			$(this).find('.desc').children('p').children('strong').css('width','100%');
		}
	})
}