// json - apiurl
var dataurl = "/apps/appcom/wish/webapi/play/";
var data_playInfo = dataurl+"getcontentsinfo.asp";
var data_playList = dataurl+"getplaylist.asp";
var data_playOpeningList = dataurl+"getplayopeninglist.asp";
var data_wishItem = dataurl+"setWishProc.asp";

//필터
Vue.filter('nl2br', function (value) {
    // 처리된 값을 반환합니다
    var returnString = String(value).replace(/(?:\r\n|\r|\n)/g, '<br />');
    return returnString.split('\n').join('<br />');
})

//lazy load
Vue.use(VueLazyload, {
	preLoad: 1.3,
	error : false,
	loading : false,
	supportWebp : false,
	listenEvents: ['scroll', 'wheel', 'mousewheel', 'resize', 'animationend', 'transitionend', 'touchmove']
})

// 컴포넌트-탬플릿
// play contents info
Vue.component('play-info',{
	props: ['item'],
	template : '<li class="swiper-slide"><div><strong>{{item.contents_name}}</strong><span v-html="this.$options.filters.nl2br(item.desc)"></span></div></li>'
})

// ui type-event - 이벤트형
Vue.component('type-event',{
    props : ['item'],
    template : '<li class="type-event"><a :href="eventLink(item.url)"><img v-lazy="imgDecode(item.listimage)" alt="" /></a></li>',
    methods : {
        eventLink : function(linkurl) {
            var linkurl = atob(linkurl.replace(/_/g, '/').replace(/-/g, '+'));
            return linkurl.replace('/apps/appcom/wish/web2014/','');
        },
        imgDecode : function(obj) {
            return atob(obj.replace(/_/g, '/').replace(/-/g, '+'));
        }
    }
})

// ui type-detial - 탐구생활 , thingbedge
Vue.component('type-detail',{
    props : ['item'],
    template : '\
                <li class="type-research">\
                    <div class="topic">\
                        <a :href="contentLink(item.url)">\
                            <div class="play-badge" v-if="item.bedge_flag > 0">\
                                <span :class="bedgeflag(item.bedge_flag)">debut or limited</span>\
                            </div>\
                            <div class="thumbnail"><img v-lazy="imgDecode(item.listimage)" alt="" /></div>\
                            <div class="play-title">\
                                <div class="label">\
                                    <em>{{item.contents_name}}</em>\
                                </div>\
                                <h2>{{item.title_name}}</h2>\
                            </div>\
                        </a>\
                    </div>\
                </li>\
                ',
    methods : {
        bedgeflag : function(obj) {
            return obj == 1 ? "badge-debut" : "badge-limited";
        },
        contentLink : function(url) {
            // base64 uri decode
            var url = atob(url.replace(/_/g, '/').replace(/-/g, '+'));
            return url.replace('/apps/appcom/wish/web2014/playwebview/','/play/');
        },
        imgDecode : function(obj) {
            return atob(obj.replace(/_/g, '/').replace(/-/g, '+'));
        }
    }
})

// ui type-movie - dayfilm
Vue.component('type-movie',{
    props : ['item'],
    template : '\
                <li class="type-film">\
                    <div class="topic">\
                        <a :href="detialLink(item)">\
                            <div class="play-badge" v-if="item.bedge_flag > 0">\
                                <span :class="bedgeflag(item)">debut or limited</span>\
                            </div>\
                            <div class="thumbnail"><img v-lazy="imgDecode(item.listimage)" alt="" /></div>\
                            <div class="play-title">\
                                <div class="label">\
                                    <em>{{item.contents_name}}</em>\
                                </div>\
                                <h2 v-html="this.$options.filters.nl2br(item.title_name)"></h2>\
                            </div>\
                        </a>\
                    </div>\
                    <div class="others swiper-container">\
                        <ul class="swiper-wrapper">\
                            <slot v-for="listitem in item.items"><list-items :listitem="listitem"></list-items></slot>\
                        </ul>\
                    </div>\
                </li>\
                ',
    methods : {
        bedgeflag : function(obj) {
            return obj.bedge_flag == 1 ? "badge-debut" : "badge-limited";
        },
        detialLink : function(obj) {
            return "/play/movie_detail.asp?pidx="+obj.contents_pidx;
        },
        imgDecode : function(obj) {
            return atob(obj.replace(/_/g, '/').replace(/-/g, '+'));
        }
    },
    mounted : function() {
        this.$nextTick(function() {
            setTimeout(function(){
                var othersSwiper = new Swiper(".others", {
                    slidesPerView:"auto",
                    freeMode:true
                });
            },300);
        });
    },
})

/* 
<div class="btn-group">
    <a href="" class="play-share"><i>공유</i></a>
</div>
*/

// ui type-list - masterpiece
Vue.component('type-list',{
    props : ['item'],
    template : '\
                <li class="type-masterpiece">\
                    <div class="topic">\
                        <a :href="masterPieceItemLink(item)">\
                            <div class="play-badge" v-if="item.bedge_flag > 0">\
                                <span :class="bedgeflag(item)">debut or limited</span>\
                            </div>\
                            <div class="thumbnail"><img v-lazy="imgDecode(item.listimage)" alt="" /></div>\
                            <div class="play-title">\
                                <div class="label">\
                                    <em>{{item.contents_name}}</em>\
                                </div>\
                                <h2 v-html="this.$options.filters.nl2br(item.title_name)"></h2>\
                            </div>\
                        </a>\
                    </div>\
                    <div class="story" v-html="this.$options.filters.nl2br(item.contents)"></div>\
                    <div class="tag swiper-container">\
                        <ul class="swiper-wrapper">\
                            <li class="swiper-slide writer"><a href="javascript:void(0);"><i>{{item.occupation}}.</i>{{item.nickname}}</a></li>\
                            <slot v-for="tag in item.tags"><list-tags :tag="tag"></list-tags></slot>\
                        </ul>\
                    </div>\
                    <div class="others swiper-container">\
                        <ul class="swiper-wrapper">\
                            <slot v-for="listitem in item.items"><list-items :listitem="listitem"></list-items></slot>\
                        </ul>\
                    </div>\
                </li>\
                ',
    mounted : function() {
        this.$nextTick(function() {
            setTimeout(function(){
                var tagSwiper = new Swiper(".tag", {
                    slidesPerView:"auto",
                    freeMode:true
                });
            
                var othersSwiper = new Swiper(".others", {
                    slidesPerView:"auto",
                    freeMode:true
                });
            },300);
        });
    },
    methods : {
        bedgeflag : function(obj) {
            return obj.bedge_flag == 1 ? "badge-debut" : "badge-limited";
        },
        masterPieceItemLink : function(obj) {
            if (obj.items == null) {
                return false;
            }
            
            var itemid = obj.items[0].item_id;
            return "/category/category_itemPrd.asp?itemid="+itemid;
        },
        imgDecode : function(obj) {
            return atob(obj.replace(/_/g, '/').replace(/-/g, '+'));
        }
    }
})
            
// masterpiece_tag
Vue.component('list-tags',{
    props : ['tag'],
    template : '<li class="swiper-slide"><a :href="tagSearch(tag)">#{{tag}}</a></li>',
    methods : {
        tagSearch : function(obj) {
            return "/search/search_result2020.asp?keyword="+obj;
        }
    }
})

// masterpiece_items
Vue.component('list-items',{
    props : ['listitem'],
    template : '\
                <li class="swiper-slide">\
                    <div class="thumbnail"><a :href="gotoItemDetail(listitem.item_id)"><img :src="imgDecode(listitem.item_image)" alt="Animal Series" /></a></div>\
                    <button @click="myWish(listitem.item_id,$event)" type="button" class="btn-wish" :class="myWishItemCheck(listitem)">위시등록</button>\
                </li>\
                ',
    methods : {
        myWish : function(obj,event) {
            var _this = this;
            var _itemid = obj;
            var _userid = $("#userid").attr("rel");
            
            if (!_userid) {
                alert('로그인후 이용 가능합니다.');
                return location.href='/login/login.asp?vType=G&backpath=%2Fplay%2F';
            }

            var _data = {item_id : _itemid , user_id : _userid};

            $.ajax({
                type: "POST",
                url: data_wishItem+'?json='+JSON.stringify(_data),
                contentType:"application/json; charset=utf-8",
                dataType: "json",
                success: function(data){
                    if (data.my_wish) {
                        // true
                        $(event.target).addClass("on");
                    } else {
                        // false
                        $(event.target).removeClass("on");                        
                    }
                }
            });
        },
        gotoItemDetail : function(itemid) {
            return "/category/category_itemPrd.asp?itemid="+itemid;
        },
        myWishItemCheck : function(obj) {
            return obj.my_wish == 1 ? "on" : "";
        },
        imgDecode : function(obj) {
            return atob(obj.replace(/_/g, '/').replace(/-/g, '+'));
        }
    }
})

// Filter Event Bus
var EventBus = new Vue()

// Play Contents Filter
var filter = new Vue({
    el : '#playsearch',
    data : function() {
        return {
            contents_cidx : ["1","2","3","4","5"],
            selected : ["1","2","3","4","5"],
            checkAll : true
        }
    },
    computed : {
        checked : function() { 
            // 체크 박스 설정
            return this.selected.indexOf(this.contents_cidx) !== 0
        }
    },
    watch : {
        contents_cidx : function() {
            // 1개라도 빠지면 전체 보기 해제
            this.checkAll = false;
            // 모든 옵션을 선택 해제 할 수 없음 해제 하는 순간 모든 선택이 되도록 설정
            if (this.contents_cidx == '') {
                this.filterAddAll();
            }
        }
    },
    methods : {
        filterAddAll : function() {
            if (this.contents_cidx.length < this.selected.length) {
                this.contents_cidx = [];
                this.contents_cidx.push("1","2","3","4","5");
            } 
        },
        // list 필터로 보냄
        filterSender : function() {
            EventBus.$emit('playfilter',this.contents_cidx);
            this.searchLayerFadeOut();
        },
        // 검색 필터 fadeout
        searchLayerFadeOut : function() {
            this.$nextTick(function() {
                setTimeout(function() {
                    $('#playsearch').hide();        
                },100);
            });
        }
    }
})

// Play Contents Guide
var info = new Vue({
    el : '#playcontentsinfo',
    data : function() {
        return {
            items : []
        }
    },
    methods : {
        sorting : function(arr) {
            return arr.slice().sort(function(a, b) {
                return a.contents_cidx - b.contents_cidx;
            });
        }
    },
    computed : {
        totalcount : function() {
            var total = 0;
            this.items.forEach(function(item) {
                if (item.is_using && item.is_view) {
                    total += 1;
                }
            });
            return total;
        }
    },
    created : function(){
		// get the data by performing API request
		var _this = this;
		$.getJSON(data_playInfo, function (data, status, xhr) {
			if (status == "success") {
                _this.items = data.contents;
			} else {
				console.log("JSON data not Loaded.");
			}
        });
    },
    updated : function(){
        this.$nextTick(function() {
			setTimeout(function(){
                var guideSwiper = new Swiper(".play-guide", {
                    slidesPerView:"auto",
                    freeMode:true
                });
			},300);
		});
    }
})

// Play List 
var list = new Vue({
    el : '#playlist',
	data : function () {
		return {
			show : false,	// display content after API request
			offset : 5 ,	// 스크롤 이후 보여질 갯수
			display : 5 ,	// 최초 보여질 갯수
			trigger : 500 , // 무한 스크롤 트리거 (높이값)
            items : [] ,// api 데이터
            openingList : [] , // 오프닝 데이터
            page_number : 1, // page 번호
            page_size : 20, // page 갯수
            contents_cidx : "0", // 컨텐츠
            before_cidx : "0",
            view_type : 'default_large',
		}
	},
	computed : {
		sliced : function() {
            return this.items.slice(0,this.display); //최초 보여질 계산된 카운트 (0,5)
        },
    },
	methods : {
		scroll : function() {
			var _this = this;
			window.onscroll = function(ev){
				if (window.scrollY >= ( document.body.scrollHeight - document.body.offsetHeight ) - _this.trigger){
					if(_this.display < _this.items.length){
                        _this.display = _this.display + _this.offset;
                        _this.moreDataLoad();
                    } 
				}
			};
        },
        // API Request
        getListData : function() {
            var _this = this;
            var _userid = $("#userid").attr("rel");
            var _data = {
                            page_number : _this.page_number,
                            page_size : _this.page_size,
                            user_id : _userid,
                            contents_cidx : _this.contents_cidx,
                            view_type : _this.view_type,
                            adminid : ""
                        };
            var _url = data_playList+'?json='+JSON.stringify(_data);
            $.getJSON(_url, function (data, status) {
                if (status == "success") {
                    if (_this.items == '') {
                        _this.items = data.contents;
                        _this.gotolistTop();
                        //console.log(_this.items);
                    } else {
                        $.each(data.contents, function(key,value) {
                            _this.items.push(value);
                        });
                        //console.log(_this.items);
                    }
                } else {
                    console.log("JSON data not Loaded.");
                }
            });
            _this.show = true;
        },
        getOpeningData : function() {
            var _this = this;
            var _userid = $("#userid").attr("rel");
            var _data = { user_id : _userid };
            var _url = data_playOpeningList+'?json='+JSON.stringify(_data);
            $.getJSON(_url, function (data, status) {
                if (status == "success") {
                    _this.openingList = data.contents;
                    //console.log(_this.openingList);
                } else {
                    console.log("JSON data not Loaded.");
                }
            });
        },
        moreDataLoad : function() {
            var _this = this;
            if (_this.display == Math.ceil(_this.page_size * _this.page_number)){
                _this.page_number++;
                _this.getListData();
            }            
        },
        // todo filter 구현
        otherList : function(newVal) {
            var _this = this;
            _this.display = 5;
            _this.page_number = 1;
            _this.contents_cidx = '';
            _this.contents_cidx = newVal.join(',');
            _this.getListData();
        },
        gotolistTop : function() {
            window.scrollTo(0,0);
        },
        currentView : function(uiNumber) {
            switch (uiNumber) {
                case 1 :
                    return 'type-list';
                case 2 :
                    return 'type-detail';
                case 4 : 
                    return 'type-movie';
                case 5 : 
                    return 'type-event';
                default : 
                    return ''
            }
        }
	},
	mounted : function() {
		// scroll event
		this.scroll();
	},
	created : function() {
        EventBus.$on('playfilter',this.otherList);
		// get the data by performing API request
        this.getListData();
        this.getOpeningData();
    },
    watch : {
        contents_cidx : function() {
            var _this = this;
            var _beforecidx = _this.before_cidx;

            if (_this.contents_cidx.indexOf(_beforecidx) !== 0) {
                return _this.items = []
            } 
        }
    },
})

$(function(){
    $(".play-guide .btn-hide").click(function(){
        var playGuideViewDate = new Date();   
        playGuideViewDate.setDate( playGuideViewDate.getDate() + 7 );
        document.cookie =  "playGuideView=x; path=/; expires=" + playGuideViewDate.toGMTString() + ";"
        $(this).closest(".play-guide").addClass("fold");
    });

    /* play filter */
	$('.btn-playfilter').click(function(e){
		$('.play-filter').fadeIn(200)
		e.preventDefault();
	})

	$('.play-filter .btn-close').click(function(e){
		$('.play-filter').fadeOut(200)
		e.preventDefault();
	})
	$('.play-filter dd a').click(function(e){
		$(this).addClass('on').siblings().removeClass('on')
		e.preventDefault();
	})

	var lastScrollTop = 0, delta = 5;
	$(window).scroll(function() {
		var nowScrollTop = $(this).scrollTop();
		if(Math.abs(lastScrollTop - nowScrollTop) >= delta){
			if (nowScrollTop > lastScrollTop){
				$(".play-filter, .btn-playfilter").stop().css({'margin-top':'-4.78rem'})
			} else {
				$(".play-filter, .btn-playfilter").stop().css({'margin-top':'0'})
			}
			lastScrollTop = nowScrollTop;
		}
	})
});