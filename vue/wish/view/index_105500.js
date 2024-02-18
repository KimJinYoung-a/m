// data
var dataurl = "/apps/appcom/wish/webapi/wish/";
var data_wishList = dataurl+"getPopularWishList.asp";

var list = new Vue({
    el : "#wishlist",
    // 98974 템플릿만 수정
    template : '\
    <div class="items type-grid">\
        <ul>\
            <wish-list v-for="(item,index) in sliced" :key="index" :item="item" :isApp="isApp"></wish-list>\
        </ul>\
    </div>',
    data : function() {
        return {
            display : 10, // 최초 보여질 갯수
            offset : 10, // 스크롤 이후 보여질 갯수
            trigger : 0.7 , // 무한 스크롤 트리거 (높이값)
            wishList : [],
            displayCateCode : '',
            sortNumber : 3, //3: 급상승 위시 , 1: 최근위시 , 2: 신상품위시 , 4: 상품후기 많은순
            page : 1,
            pagesize : 20,
            isApp : isApp,
        }
    },
    computed : {
		sliced : function() {
            return this.wishList.slice(0,this.display); //최초 보여질 계산된 카운트 (0,3)
        },
    },
    created : function() {
        this.getWishListData();
    },
    mounted : function() {
        this.scroll();
    },
    methods : {
        scroll : function() {
            var _this = this;
            var timeout; // 윈도우 스크롤 이벤트 중복으로 먹을경우 별도 처리
			$(window).scroll(function() {
                clearTimeout(timeout);
                timeout = setTimeout(function() {
                    if (window.scrollY >= ( document.body.scrollHeight - document.body.offsetHeight ) * _this.trigger){
                        if(_this.display < _this.wishList.length){
                            _this.display = _this.display + _this.offset;
                            _this.moreDataLoad();
                        }
                    }
                },50)
            });
        },
        getWishListData : function() {
            var _this = this;
            var _parameters = "?disp="+ _this.displayCateCode +"&sort="+ _this.sortNumber +"&cpg="+ _this.page;
            var _url = data_wishList+_parameters;
            $.getJSON(_url, function (data, status, xhr) {
                console.log(data)
                if (status == 'success') {
                    if (_this.wishList == '') {
                        _this.wishList = data.wish;
                    } else {
                        $.each(data.wish, function(key,value) {
                            _this.wishList.push(value);
                        });
                    }
                } else {
                    console.log('JSON data not Loaded.');
                }
            });
        },
        moreDataLoad : function() {
            var _this = this;
            if (_this.display == Math.ceil(_this.pagesize * _this.page)){
                _this.page++;
                _this.getWishListData();
            }
        },
    },
})
