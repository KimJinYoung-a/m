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
    template: '<div class="diary-tv">\
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
			display : 3 ,	// 최초 보여질 갯수
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