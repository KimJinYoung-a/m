// json - apiurl
//var dataurl = "/trend/";
var dataurl = "/trend/";
var data_data1 = dataurl+"json_data1.asp";
var data_data2 = dataurl+"json_data2.asp";
var data_data3 = dataurl+"json_data3.asp";

//컴포넌트-탬플릿
//상품 리스트
Vue.component('item-list',{
	props: ['item','isapp'],
	template : '\
				<li v-if="isapp > 0">\
					<a @click="trendAmplitudeEvent(item.itemid, item.gubun, function() {fnAPPpopupAutoUrl(item.itemurl);});">\
						<div class="thumbnail"><img :src="item.image" alt="" /><b class="myview" v-if="item.gubun == 2 && item.sortkey == 1">최근 본 상품</b></div>\
						<div class="desc">\
							<span class="brand" v-if="item.gubun == 9">{{item.brand}}</span>\
							<p class="name">{{item.itemname}}</p>\
							<div class="price">\
								<div class="unit"><b class="sum">{{item.price}}<span class="won">원</span></b> <b class="discount color-red" v-if="item.sale">{{item.sale}}</b></div>\
							</div>\
						</div>\
					</a>\
				</li>\
				<li v-else>\
					<a :href="item.itemurl">\
						<div class="thumbnail"><img :src="item.image" alt="" /><b class="myview" v-if="item.gubun == 2 && item.sortkey == 1">최근 본 상품</b></div>\
						<div class="desc">\
							<span class="brand" v-if="item.gubun == 9">{{item.brand}}</span>\
							<p class="name">{{item.itemname}}</p>\
							<div class="price">\
								<div class="unit"><b class="sum">{{item.price}}<span class="won">원</span></b> <b class="discount color-red" v-if="item.sale">{{item.sale}}</b></div>\
							</div>\
						</div>\
					</a>\
				</li>\
				'
})

//쿠폰 리스트
Vue.component('coupon-list',{
	props: ['item','isapp'],
	template : '\
				<li v-if="isapp > 0">\
					<div class="label"><em class="d-day">{{item.dt}}</em></div>\
					<div class="thumbnail"><img :src="item.image" alt="" /></div>\
					<div class="desc">\
						<span class="name">{{item.itemname}}</span>\
						<div class="unit"><b class="sum" v-if="item.coupontype == 1">{{item.sale}}%</b><b class="sum" v-else-if="item.coupontype == 2">{{item.sale}}<span class="won">원</span></b><b class="sum shipping" v-else-if="item.coupontype == 3">{{item.sale}}</b></div>\
						<a @click="fnAmplitudeEventMultiPropertiesAction(\'click_coupon_in_trend\', \'itemid|type\', item.itemid + \'|more\', function() {fnAPPpopupCouponItem(item.couponurl);});" class="btn-view">적용상품 보기<span class="icon icon-plus"></span></a>\
						<button type="button" class="btn-download" @click="fnAmplitudeEventMultiPropertiesAction(\'click_coupon_in_trend\', \'itemid|type\', item.itemid + \'|coupon\', function() {jsDownCoupon(item.itemcouponidx);});">쿠폰 다운<span class="icon icon-download"></span></button>\
					</div>\
				</li>\
				<li v-else>\
					<div class="label"><em class="d-day">{{item.dt}}</em></div>\
					<div class="thumbnail"><img :src="item.image" alt="" /></div>\
					<div class="desc">\
						<span class="name">{{item.itemname}}</span>\
						<div class="unit"><b class="sum" v-if="item.coupontype == 1">{{item.sale}}%</b><b class="sum" v-else-if="item.coupontype == 2">{{item.sale}}<span class="won">원</span></b><b class="sum shipping" v-else-if="item.coupontype == 3">{{item.sale}}</b></div>\
						<a :href="item.couponurl" class="btn-view">적용상품 보기<span class="icon icon-plus"></span></a>\
						<button type="button" class="btn-download" @click="jsDownCoupon(item.itemcouponidx);">쿠폰 다운<span class="icon icon-download"></span></button>\
					</div>\
				</li>\
				'
})

//이벤트 리스트
Vue.component('evt-list',{
	props: ['item','isapp'],
	template : '\
				<li v-if="isapp > 0">\
					<a @click="trendAmplitudeEvent(item.itemid, item.gubun, function() {fnAPPpopupAutoUrl(item.itemurl);});">\
						<div class="thumbnail"><img :src="item.image" alt="" /></div>\
						<p class="desc">\
							<b class="headline">{{item.itemname}}</b>\
							<span class="subcopy"><span class="ellipsis">{{item.subcopy}}</span> <b class="discount color-red" v-if="item.couponflag == 1">{{item.sale}}</b><b class="discount color-green" v-else-if="item.couponflag == 2">{{item.sale}}</b></span>\
						</p>\
					</a>\
				</li>\
				<li v-else>\
					<a :href="item.itemurl">\
						<div class="thumbnail"><img :src="item.image" alt="" /></div>\
						<p class="desc">\
							<b class="headline">{{item.itemname}}</b>\
							<span class="subcopy"><span class="ellipsis">{{item.subcopy}}</span> <b class="discount color-red" v-if="item.couponflag == 1">{{item.sale}}</b><b class="discount color-green" v-else-if="item.couponflag == 2">{{item.sale}}</b></span>\
						</p>\
					</a>\
				</li>\
				'
})

//검색어 리스트
Vue.component('search-list',{
	props: ['sub','isapp'],
	template : '\
				<li v-if="isapp > 0"><a @click="trendAmplitudeEvent(\'\', \'keyword\', function() {fnAPPpopupAutoUrl(sub.itemurl);});"><div class="thumbnail"><img :src="sub.image" :alt="sub.itemname" /></div></a></li>\
				<li v-else><a :href="sub.itemurl"><div class="thumbnail"><img :src="sub.image" :alt="sub.itemname" /></div></a></li>\
				'
})

// gubun값을 읽을수있는 string값으로 변경함.
function trendGubunToString(gubun){
	switch (gubun) {
		case "1": return "buy";
		case "2": return "myview";
		case "3": return "keyword";
		case "4": return "view";
		case "5": return "mycart";
		case "6": return "cart";
		case "7": return "brand";
		case "8": return "keyword";
		case "9": return "mywish";
		case "10": return "wish";
		case "11": return "event";
		case "12": return "category";
		case "13": return "coupon";
	}
	return gubun;
}

function trendAmplitudeEvent(itemId, gubun, callback){
	fnAmplitudeEventMultiPropertiesAction('click_item_in_trend', 'itemid|gubun', itemId + "|" + trendGubunToString(gubun), callback);
}

// gubun data json
var trenddata1 = new Vue({
	data: {
        items: {
		  type: String
		},
		brandname : { type : String },
		brandurl : { type : String },
  		catename : { type : String },
		cateurl : { type : String }
    },
    created: function () {
        var self = this;
        $.getJSON(data_data1, function (data, status, xhr) {
			if (status == "success") {
				self.items = data;
				for(var i in data) {
					if (data[i].gubun == "7"){
						self.brandname = data[i].brandname;
						self.brandurl = data[i].brandurl;
					}else if (data[i].gubun == "12"){
						self.catename = data[i].catename;
						self.cateurl = data[i].cateurl;
					}
				}
			} else {
				console.log("JSON data not Loaded.");
			}
        });
    }
})

// gubun 2,4 data json
var trenddata2 = new Vue({
	data: {
        items: {
		  type: String
		}
    },
    created: function () {
        var self = this;
        $.getJSON(data_data2, function (data, status, xhr) {
			if (status == "success") {
				self.items = data;
			} else {
				console.log("JSON data not Loaded.");
			}
        });
    }
})

// 키워드 data json
var trenddata3 = new Vue({
	data: {
        items: {
		  type: String
		}
    },
    created: function () {
        var self = this;
        $.getJSON(data_data3, function (data, status, xhr) {
			if (status == "success") {
				self.items = data;
			} else {
				console.log("JSON data not Loaded.");
			}
        });
    }
})

//gubun 1
new Vue({ el: "#ifop", data: trenddata1.$data })
//gubun 2 - my
var ify = new Vue({ 
	el: "#ify", 
	data: {
        items: {
		  type: String
		}
    },
    created: function () {
        var self = this;
        $.getJSON(data_data2, function (data, status, xhr) {
			if (status == "success") {
				for(var i in data) {
					if (data[i].gubun == "2"){
						self.items = data;
					}
				}
			} else {
				console.log("JSON data not Loaded.");
			}
        });
    }
})
//gubun 3
new Vue({ el: "#ifsch1", data: trenddata3.$data })
//gubun 4
new Vue({ el: "#ifops", data: trenddata2.$data })
//gubun 5 - my
var ifmsb = new Vue({ 
	el: "#ifmsb", 
	data: {
        items: {
		  type: String
		}
    },
    created: function () {
        var self = this;
        $.getJSON(data_data1, function (data, status, xhr) {
			if (status == "success") {
				for(var i in data) {
					if (data[i].gubun == "5"){
						self.items = data;
					}
				}
			} else {
				console.log("JSON data not Loaded.");
			}
        });
    }
})
//gubun 6
new Vue({ el: "#ifosb", data: trenddata1.$data })
//gubun 7
new Vue({ el: "#ifnb", data: trenddata1.$data })
//gubun 8
new Vue({ el: "#ifsch2", data: trenddata3.$data })
//gubun 9 - my
new Vue({ 
	el: "#ifyw", 
	data: {
        items: {
		  type: String
		}
    },
    created: function () {
        var self = this;
        $.getJSON(data_data1, function (data, status, xhr) {
			if (status == "success") {
				for(var i in data) {
					if (data[i].gubun == "9"){
						self.items = data;
					}
				}
			} else {
				console.log("JSON data not Loaded.");
			}
        });
    }
})
//gubun 10
new Vue({ el: "#ifow", data: trenddata1.$data })
//gubun 11
new Vue({ el: "#efed", data: trenddata1.$data })
//gubun 12
new Vue({ el: "#ifhk", data: trenddata1.$data })
//gubun 13
new Vue({ el: "#ifec", data: trenddata1.$data })