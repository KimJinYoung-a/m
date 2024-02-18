// json - apiurl
var dataurl = "/todaykeywordlist/";
var json_data = dataurl+"json_data.asp";

//컴포넌트-탬플릿
//검색어 리스트
Vue.component('search-list',{
	props: ['sub','isapp'],
	template : '\
				<li v-if="isapp > 0"><a @click="fnAPPpopupAutoUrl(sub.itemurl);"><div class="thumbnail"><img :src="sub.image" :alt="sub.itemname" /></div></a></li>\
				<li v-else><a :href="sub.itemurl"><div class="thumbnail"><img :src="sub.image" :alt="sub.itemname" /></div></a></li>\
				'
})

// 키워드 data json
var keyworddata = new Vue({
	data: function(){
		return {
			items: {
			  type: String
			}
		}
	},
	created: function () {
		var self = this;
		$.getJSON(json_data, function (data, status, xhr) {
			if (status == "success") {
				self.items = data;
			} else {
				console.log("JSON data not Loaded.");
			}
		});
	}
})

new Vue({ el: "#keylist", data: keyworddata.$data })