var mainRollingUrl = "/apps/appCom/wish/webapi/specialbrand/main-rollings.asp"
var brandListUrl = "/apps/appCom/wish/webapi/specialbrand/brand-lists.asp"
var eventListUrl = "/apps/appCom/wish/webapi/specialbrand/events.asp"
var itemListUrl = "/apps/appCom/wish/webapi/specialbrand/items.asp"
var reviewListUrl = "/apps/appCom/wish/webapi/specialbrand/reviews.asp"

var app = new Vue({
    el: '#app',
    template: '\
<div>\
    <!-- pb 메인 롤링 -->\
    <pb-main-rolling\
        :rolling-banners=banners\
        v-if="banners.length > 0"\
    ></pb-main-rolling>\
\
    <!-- pb 브랜드 리스트 -->\
    <pb-brand-container\
        :brands=brands\
    ></pb-brand-container>\
\
    <pb-contents-container\
        v-for="contents in contentsArr"\
        :contents-data="contents.data"\
        :contents-id="contents.contentsId"\
        :menu-arr="menuArr"\
        v-if="contents.data.length > 0"\
    ></pb-contents-container>\
</div>\
',
    data: function(){
        return {
            gotContentsCnt: 0 ,
            banners: [],
            brands: [],
            contentsArr: [
                { contentsId: 'pb-evt', menuName: '기획전', data: [] },
                { contentsId: 'new-item', menuName: '신상품', data: [] },
                { contentsId: 'best-item', menuName: '베스트', data: [] },
                { contentsId: 'now-item', menuName: '방금 판매된', data: [] },
                { contentsId: 'pb-review', menuName: '후기', data: [] },
            ]
        }
    },
    methods: {
        getContentsDetails: function(params){
            var _this = this;

            $.getJSON(params.url, params, function (data, status, xhr) {
                var tmpKeyArr = [];
                if (status == "success") {
                    for( var key in data ) {
           // 콘텐츠 콘테이너 데이터
                        if(params.contentsId){
                            _this.contentsArr.forEach(function(item){
                                if(item.contentsId == params.contentsId){
                                    item.data = data[key]
                                    // item.disp = data[key].length > 0 ? true : false;
                                }
                            });
                        }else{
                            _this.$data[key] = data[key]
                        }
                    }
                    _this.gotContentsCnt++
                } else {
                    console.log("JSON data not Loaded.");
                }
            });
        },
        getRandomKey: function(){
            var ranNum = Math.floor(Math.random() * (26243 - 1) + 1)
            return "key-" + ranNum
        }
    },
    created: function(){
        this.getContentsDetails({
            url: mainRollingUrl
        });
        this.getContentsDetails({
            url: brandListUrl
        });
        this.getContentsDetails({
            url: eventListUrl,
            contentsId: 'pb-evt'
        });
        this.getContentsDetails({
            url: itemListUrl,
            contentsId: 'new-item',
            listType: 'B'
        });
        this.getContentsDetails({
            url: itemListUrl,
            contentsId: 'best-item',
            listType: 'A'
        });
        this.getContentsDetails({
            url: itemListUrl,
            contentsId: 'now-item',
            listType: 'C'
        });
        this.getContentsDetails({
            url: reviewListUrl,
            contentsId: 'pb-review',
        });
    },
    mounted: function(){
        console.log('parent mounted')
    },
    computed: {
        menuArr: function(){
            tmpArr = []
            this.contentsArr.forEach(function(item){
                var tmpObj = {
                    contentsId: item["contentsId"],
                    menuName: item["menuName"],
                    disp: item["data"].length > 0 ? true : false
                }
                tmpArr.push(tmpObj)
            })
            return tmpArr
        }
    }
})
