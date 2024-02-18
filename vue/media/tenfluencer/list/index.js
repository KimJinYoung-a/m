// data
var dataurl = "/apps/appcom/wish/webapi/media/";
var data_swipeList = dataurl+"getSwipeList.asp";
var data_MediaList = dataurl+"getContentsList.asp";
var data_likeCount = dataurl+"setContentsLikeCountProc.asp";
var data_viewCount = dataurl+"setContentsviewCountProc.asp";

//필터
Vue.filter('nl2br', function (value) {
    // 처리된 값을 반환합니다
    var returnString = String(value).replace(/(?:\r\n|\r|\n)/g, '<br />');
    return returnString.split('\n').join('<br />');
})

// //lazy load
// Vue.use(VueLazyload, {
// 	preLoad: 1.3,
// 	error : false,
// 	loading : false,
// 	supportWebp : false,
// 	listenEvents: ['scroll', 'wheel', 'mousewheel', 'resize', 'animationend', 'transitionend', 'touchmove']
// })

var list = new Vue({
    el : '#app',
    template : '<div>\
                    <swipe-list :swipelists="swipelists" :isapp="isapp"></swipe-list>\
                    <div class="progress-wrap">\
                        <div class="progress-container">\
                            <div class="progress-bar" id="progress-bar"></div>\
                        </div>\
                    </div>\
                    <div class="plf-tab">\
                        <ul>\
                            <li class="on"><a @click="sortChange(1)"><span>신규순</span></a></li>\
                            <li class=""><a @click="sortChange(2)"><span>인기순</span></a></li>\
                        </ul>\
                    </div>\
                    <div class="vod-list type1">\
                        <ul><video-list v-for="(item,index) in sliced" :index="index" :item="item" v-if="sliced" :isapp="isapp"></video-list></ul>\
                        <div class="tf-loader"></div>\
                    </div>\
                    <div class="ly-clap">\
                        <div class="inner">\
                            <div class="dots dots1"></div>\
                            <div class="dots dots2"></div>\
                            <div class="dots dots3"></div>\
                            <div class="dots dots4"></div>\
                            <div class="dots dots5"></div>\
                            <div class="dots dots6"></div>\
                            <div class="dots dots7"></div>\
                            <div class="dots dots8"></div>\
                            <div class="hand"></div>\
                            <div class="heart"><i></i></div>\
                        </div>\
                        <div class="mask"></div>\
                    </div>\
                </div>\
    ',
    data : function() {
        return {
            show : false,	// display content after API request
			offset : 3 ,	// 스크롤 이후 보여질 갯수
			display : 3 ,	// 최초 보여질 갯수
			trigger : 0 ,   // 무한 스크롤 트리거 (높이값)
            serviceCode : 1,
            groupCode : '',
            page : 1,
            pagesize : 6,
            listType : 'A',
            sortType : 'NEW',
            swipelists : [],
            contentslists : [],
            contentsTotalCount : 0,
            isapp : isapp,
        }
    },
    computed : {
		sliced : function() {
            return this.contentslists.slice(0,this.display); //최초 보여질 계산된 카운트 (0,3)
        },
    },
    created : function() {
        this.getSwipeData();
        this.getContentsData();
    },
    mounted : function() {
        this.scroll();
    },
    methods : {
        getSwipeData : function() {
            var _this = this;
            var _parameters = {
                servicecode : _this.serviceCode,
                channel : 2
            };
            var _url = data_swipeList+'?json='+JSON.stringify(_parameters);
            $.getJSON(_url, function (data, status, xhr) {
                if (status == 'success') {
                    if (data != null)
                    {
                        _this.swipelists = data.lists;
                    }
                } else {
                    console.log('JSON data not Loaded.');
                }
            });
        },
        getContentsData : function () {
            var _this = this;
            var _parameters = {
                servicecode : _this.serviceCode,
                groupcode : _this.groupCode,
                page : _this.page,
                pagesize : _this.pagesize,
                listtype : _this.listType,
                sorttype : _this.sortType
            };
            var _url = data_MediaList+'?json='+JSON.stringify(_parameters);
            $.getJSON(_url, function (data, status, xhr) {
                if (status == 'success') {
                    _this.contentsTotalCount = data.contentstotalcount;

                    if (_this.contentslists == '') {
                        _this.contentslists = data.contentslists;
                    } else {
                        $.each(data.contentslists, function(key,value) {
                            _this.contentslists.push(value);
                        });
                    }
                } else {
                    console.log('JSON data not Loaded.');
                }
            });
        },
        scroll : function() {
			var _this = this;
			window.onscroll = function(ev) {
				if (window.scrollY >= ( document.body.scrollHeight - document.body.offsetHeight ) - _this.trigger){
					if(_this.display < _this.contentslists.length){
                        _this.display = _this.display + _this.offset;
                        _this.moreDataLoad();
                    } 
                }
                // progress bar
                var winScroll = document.body.scrollTop || document.documentElement.scrollTop;
                var height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
                var scrolled = (winScroll / height) * 100;
                document.getElementById("progress-bar").style.width = scrolled + "%";

                // 상단 header 영역 -- 모웹 전용?
                var hh = $(".tenten-header").outerHeight();
                var conT = $(".plf-tab").offset().top - hh;
                var y = $(window).scrollTop();
                var fnHeader = function() {
                    if ( conT < y ) {
                        $(".tenten-header").removeClass("header-transparent");
                        $(".progress-wrap").css("opacity",1);
                    }
                    else {
                        $(".tenten-header").addClass("header-transparent");
                        $(".progress-wrap").css("opacity",0);
                    }
                }
                fnHeader();
			};
        },
        moreDataLoadingLayer : function() {
            var fnLoad = function() {
                $(".tf-loader").fadeIn(500).delay(1000).fadeOut();
            }
            
            if (this.swipelists == '') {
                if ( timer ) clearTimeout( timer );
            }
            timer = setTimeout( fnLoad, 150 );
        },
        moreDataLoad : function() {
            var _this = this;
            if (_this.display == Math.ceil(_this.pagesize * _this.page)){
                _this.page++;
                _this.moreDataLoadingLayer();
                _this.getContentsData();
            }
        },
        sortChange : function(type) {
            var _this = this;
            var _type = (type == 1) ? 'NEW' : 'BEST';
            _this.page = 1;
            _this.pagesize = 6;
            _this.listType = 'A';
            _this.sortType = _type;
            _this.display = 3;
            _this.getContentsData();
        }
    },
    watch : {
        sortType : {
            handler : function(val , oldVal) {
                if (val != oldVal) {
                    return this.contentslists = [];
                }
            },
        }
    }
})

$(function() {
	// bg rolling
	bgRolling = new Swiper('.bg-rolling .swiper-container', {
		speed:3000,
		autoplay:1000,
		effect:"fade"
	});

	// timer
	var date = new Date(-32400000);
	setInterval(function() {
		date.setSeconds(date.getSeconds() + 1);
		$('#timer').html(date.toTimeString().substr(0, 8));
	}, 1000);

	// tab
	$(".plf-tab li").click(function(e){
		$(this).addClass("on").siblings("li").removeClass("on");
		e.preventDefault();
	});
});