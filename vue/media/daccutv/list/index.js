// data
var dataurl = "/apps/appcom/wish/webapi/media/";
var data_MediaList = dataurl+"getContentsList.asp";
var data_likeCount = dataurl+"setContentsLikeCountProc.asp";
var data_viewCount = dataurl+"setContentsviewCountProc.asp";

//필터
Vue.filter('nl2br', function (value) {
    // 처리된 값을 반환합니다
    var returnString = String(value).replace(/(?:\r\n|\r|\n)/g, '<br />');
    return returnString.split('\n').join('<br />');
})

var list = new Vue({
    el : '#app',
    template : '<div class="diary-tv">\
                    <div class="top">\
                        <h2>DIARY DECO <br>TV</h2>\
                        <div class="deco">\
                            <i class="dc1 circle circle1"></i>\
                            <i class="dc2 circle circle2"></i>\
                            <i class="dc3 circle circle2"></i>\
                            <i class="dc4 circle circle2"></i>\
                            <i class="dc5 circle circle3"></i>\
                        </div>\
                    </div>\
                    <div class="filter">\
                        <select @change=sortChange($event)>\
                            <option value="1">최신순</option>\
                            <option value="2">인기순</option>\
                        </select>\
                        <span></span>\
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
                    <div class="progress-wrap">\
                        <div class="progress-container">\
                            <div class="progress-bar" id="progress-bar"></div>\
                        </div>\
                    </div>\
                </div>\
    ',
    data : function() {
        return {
            show : false,	// display content after API request
			offset : 3 ,	// 스크롤 이후 보여질 갯수
			display : 3 ,	// 최초 보여질 갯수
			trigger : 350 ,   // 무한 스크롤 트리거 (높이값)
            serviceCode : 3, // daccutv
            groupCode : '',
            page : 1,
            pagesize : 6,
            listType : 'A',
            sortType : 'NEW',
            swipeLists : [],
            contentsLists : [],
            contentsTotalCount : 0,
            isapp : isapp,
            selected : 1,
        }
    },
    computed : {
		sliced : function() {
            return this.contentsLists.slice(0,this.display); //최초 보여질 계산된 카운트 (0,3)
        },
    },
    created : function() {
        this.getContentsData();
    },
    mounted : function() {
        this.scroll();
    },
    methods : {
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

                    if (_this.contentsLists == '') {
                        _this.contentsLists = data.contentslists;
                    } else {
                        $.each(data.contentslists, function(key,value) {
                            _this.contentsLists.push(value);
                        });
                    }
                } else {
                    console.log('JSON data not Loaded.');
                }
            });
        },
        scroll : function() {
            var _this = this;
            var conT = $(".progress-wrap").offset().top;
			window.onscroll = function(ev) {
				if (window.scrollY >= ( document.body.scrollHeight - document.body.offsetHeight ) - _this.trigger){
					if(_this.display < _this.contentsLists.length){
                        _this.display = _this.display + _this.offset;
                        _this.moreDataLoad();
                    } 
                }
                
                // progress bar
                var winScroll = document.body.scrollTop || document.documentElement.scrollTop;
                var height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
                var scrolled = (winScroll / height) * 100;
                document.getElementById("progress-bar").style.width = scrolled + "%";

                var y = $(window).scrollTop();
                var fnHeader = function() {
                    if ( conT < y ) {
                        $(".progress-wrap").css("opacity",1);
                    }
                    else {
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
            
            if (this.swipeLists == '') {
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
        sortChange : function(event) {
            var _this = this;
            var _type = (event.target.value == 1) ? 'NEW' : 'BEST';
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
                    return this.contentsLists = [];
                }
            },
        }
    }
})

$(function() {
	// tab
	$(".plf-tab li").click(function(e){
		$(this).addClass("on").siblings("li").removeClass("on");
		e.preventDefault();
	});
});