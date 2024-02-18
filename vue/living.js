// json - apiurl
var dataurl = "/living/";
var json_data1 = dataurl+"json_data1.asp";

//lazy load
Vue.use(VueLazyload, {
	preLoad: 1.3,
	error : false,
	loading : false,
	supportWebp : false,
	listenEvents: ['scroll', 'wheel', 'mousewheel', 'resize', 'animationend', 'transitionend', 'touchmove']
})

// component
Vue.component('item-list',{
	props: ['item','isapp','index'],
	template : '\
				<li class="exhibition-plus-item" v-if="item.itemcnt==2">\
					<a :href="item.linkurl">\
						<div class="thumbnail"><img :src="item.imagewide" :alt="item.eventname" /></div>\
						<p class="desc">\
							<b class="headline"><span class="ellipsis">{{item.eventname}}</span> <b class="discount color-red" if="item.saleper">{{item.saleper}}</b></b>\
							<span class="subcopy">{{item.eventsubcopy}}</span>\
						</p>\
					</a>\
					<div class="items">\
						<ul>\
							<li v-for="items in item.itemlist">\
								<a :href="items.linkurl">\
									<div class="thumbnail"><img :src="items.listimage" :alt="items.itemname"></div>\
									<div class="desc">\
										<div class="price">\
											<b class="discount color-red" v-if="items.totalsaleper>0">{{items.totalsaleper}}%</b><b v-else></b>\
											<b class="sum">{{items.totalprice}}<span class="won">원</span></b>\
										</div>\
									</div>\
								</a>\
							</li>\
						</ul>\
					</div>\
				</li>\
				<li v-else>\
					<a :href="item.linkurl">\
						<div class="thumbnail"><img :src="item.image" :alt="item.eventname" v-if="index == 3"/><img :src="item.imagewide" :alt="item.eventname" v-else/></div>\
						<p class="desc">\
							<b class="headline"><span class="ellipsis">{{item.eventname}}</span> <b class="discount color-red" if="item.saleper">{{item.saleper}}</b></b>\
							<span class="subcopy">{{item.eventsubcopy}}</span>\
						</p>\
					</a>\
				</li>\
				'
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

// fashion event3
var eventlist2 = new Vue({
	el : '#exhibition3',
	data :  eventdata.$data ,
})