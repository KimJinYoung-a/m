// 컴포넌트-탬플릿
// 검색어 리스트
Vue.component('item-list',{
	props: ['sub','isapp', 'idx', 'limit'],
	template : '\
				<li v-if="isapp > 0 && idx < limit">\
					<a @click="fnAmplitudeEventAction(sub.ampevtname,sub.ampevtpk,sub.itemid,function(bool){if(bool) {fnAPPpopupAutoUrl(sub.link);}});">\
						<div class="thumb"><img :src="sub.itemimage" :alt="sub.itemname" /></div>\
						<div class="txt">\
							<p class="name multi-ellipsis">{{sub.itemname}}</p>\
							<s>상품보기</s>\
						</div>\
					</a>\
				</li>\
				<li v-else-if="isapp === 0 && idx < limit">\
					<a :href="sub.link" @click="fnAmplitudeEventAction(sub.ampevtname,sub.ampevtpk,sub.itemid);">\
						<div class="thumb"><img :src="sub.itemimage" :alt="sub.itemname" /></div>\
						<div class="txt">\
							<p class="name multi-ellipsis">{{sub.itemname}}</p>\
							<s>상품보기</s>\
						</div>\
					</a>\
				</li>\
				'
})

Vue.component('image-list',{
	props: ['sub','isapp'],
	template : '\
				<div class="swiper-slide" v-if="isapp > 0"><img :src="sub.images" /></div>\
				<div class="swiper-slide" v-else><img :src="sub.images" /></div>\
				'
})

Vue.component('drama-bnr',{
	props: ['item', 'evtcode'],
	template : '\
				<div class="bnr-drama-evt" \
				v-bind:style="{ backgroundColor: item.bgcolor }"\
				>\
					<div class="txt">\
						<div class="evt-tit"><em class="ellipsis" v-html="item.bannermaincopy"></em><span class="color-red" v-if="item.bannersaleper!=0">{{item.bannersaleper}}%</span></div>\
						<p class="ellipsis" v-html="item.bannersubcopy"></p>\
					</div>\
					<span class="drama-label"><img :src="item.bannerimage" alt="" /></span>\
				</div>\
				'
})

// 드라마존 검색
var dramalist = new Vue({
	el : "#dramalist" ,
	data : function(){
		return {
			show : false,	// display content after API request
			offset : 5 ,	// 스크롤 이후 보여질 갯수
			display : 5 ,	// 최초 보여질 갯수
			trigger : 300 , // 무한 스크롤 트리거 (높이값)
			items : [] // api 데이터
		}
	},
	computed : {
		sliced : function(){
			return this.items.slice(0,this.display); //최초 보여질 계산된 카운트 (0,0) 시작 안함
		},
	},
	methods : {
		scroll : function(){
			var _this = this;
			window.onscroll = function(ev){
				if (window.scrollY >= ( document.body.scrollHeight - document.body.offsetHeight ) - _this.trigger){
					if(_this.display < _this.items.length){
						_this.display = _this.display + _this.offset;
					}else{
						_this.end = true;
					}
				}
			};
		},
		videoplay : function (event){
			$(event.target).fadeOut(400);
			var sbsVod = $(event.target).closest('.vod').find('.vod-player');
			var url = sbsVod.attr('src').split('?')[0];
			var data = {
				method: 'play'
			};
			sbsVod[0].contentWindow.postMessage(JSON.stringify(data), url);
		},		
		viewMore: function(num, didx){
			this.items[didx].rowLimit = num;
			this.items[didx].viewFlag = 0;
		},
		getNowDate: function(){
			var d = new Date()
			, month = '' + (d.getMonth() + 1)
			, day = '' + d.getDate()
			, year = d.getFullYear(); 

			if (month.length < 2) month = '0' + month; 
			if (day.length < 2) day = '0' + day; 

			return [year, month, day].join('-');			
		},
		isDateValid: function(startdate, enddate){
			return (this.getNowDate() >= startdate && this.getNowDate() <= enddate)
		}		
	},
	mounted : function(){
		// 스크롤 이벤트
		this.scroll();
	},
	created : function () {
		var self = this;
		$.getJSON(json_data2, function (data, status, xhr) {
			if (status == 'success') {
				if (data != null && data.length > 0)
				{
					self.items = data;
				}else{
					self.items = '';
				}
			} else {
				console.log('JSON data not Loaded.');
			}
		});
		self.show = true;
	},
	updated: function() {
		this.$nextTick(function() {
			setTimeout(function(){
				var dramaSlide = new Swiper('.drama-rolling .swiper-container',{
					loop:true,
					autoplay:3000,
					autoplayDisableOnInteraction:false,
					speed:800,
					pagination:'.drama-rolling .pagination',
					paginationClickable:true,
					nextButton:'.drama-rolling .btn-next',
					prevButton:'.drama-rolling .btn-prev',
					effect:'fade'
				});
			},100);
		});
	}
})

$(function(){
	// sorting-bar
	$('.sortingbar').click(function(e){
		e.preventDefault();
		if ($('.sbs-top').hasClass("on")) {
			$('.sbs-top').removeClass("on");
			disappearMask();
		} else {
			$('.sbs-top').addClass("on");
			makeMask();
		}
		$('#mask').click(function(e){
			e.preventDefault();
			$('.sbs-top').removeClass("on");
			disappearMask();
		});
	});
});
	
// mask
function makeMask(){
	var maskH = $(window).outerHeight() * 10;
	var maskW = $(window).outerWidth();
	$('#mask').css({'width':maskW,'height':maskH});
	$('#mask').fadeIn();
}

function disappearMask(){
	$('#mask').css({'width':0,'height':0});
	$('#mask').fadeOut();
}