Vue.component('item-list',{
    template :'\
                <article class="prd_item">\
                    <figure class="prd_img">\
                        <img :src="itemimage" :alt="itemname" >\
                        <span class="prd_mask"></span>\
                    </figure>\
                    <div class="prd_info">\
                        <div class="prd_price">\
                            <span class="set_price"><dfn>판매가</dfn>{{totalprice}}</span>\
                            <span v-if="saleInfo() != \'\'" class="discount"><dfn>할인율</dfn>{{saleInfo()}}</span>\
                        </div>\
                        <div class="prd_name ellipsis2">{{itemname}}</div>\
                        <div class="user_side" v-if="evalPoint >= 80">\
                            <span class="user_eval"><dfn>평점</dfn><i v-bind:style="{width : evalPoint + \'%\'}">{{evalPoint}}점</i></span>\
                            <span class="user_comment"><dfn>상품평</dfn>{{evalCount}}</span>\
                        </div>\
                    </div>\
                    <a @click="itemUrl(itemid)" class="prd_link"><span class="blind">상품 바로가기</span></a>\
                </article>\
                '
    ,
    props: {
        index : {
            type: Number,
            default: 0
        },
        itemid : {
            type: Number,
            default: 0
        },
        itemname : {
            type : String,
            default : ''
        },
        itemimage : {
            type : String,
            default : ''
        },
        brandname : {
            type : String,
            default : ''
        },
        totalprice : {
            type : String,
            default : "0"
        },
        totalsaleper : {
            type : String,
            default : "0"
        },
        saleperstring : {
            type : String,
            default : "0"
        },
        couponperstring : {
            type : String,
            default : "0"
        },
        isApp : {
            type : Boolean,
            default : false
        },
        amplitudeActionName : {
            type : String,
            default : ""
        },
        evalCount: {
            type: Number,
            default: 0
        },
        favCount : {
            type : Number,
            default : 0
        },
        totalPoint : {
            type : Number,
            default : 0
        },
        evalPoint : {
            type : Number,
            default : 0
        },
    },
    methods : {        
        itemUrl : function(itemid) {
            fnAmplitudeEventAction(this.amplitudeActionName+'item','itemid',itemid);

            this.isApp ? fnAPPpopupProduct(itemid) : function() {
                var itemUrl = "/category/category_itemPrd.asp?itemid="+ itemid +"&flag=e";
                location.href = itemUrl;
            }()
        },
        saleInfo : function() {
            if (this.saleperstring > "0" && this.couponperstring > "0") {
                return this.totalsaleper;
            }
            else if(this.saleperstring > "0" && this.couponperstring < "1"){
                return this.saleperstring;
            }
            else if(this.couponperstring > "0" && this.saleperstring < "1"){
                return this.couponperstring + " 쿠폰";
            }
        },
    },
})

Vue.use(VueLazyload, {
	preLoad: 1.3,
	error : false,
	loading : false,
	supportWebp : false,
	listenEvents: ['scroll', 'wheel', 'mousewheel', 'resize', 'animationend', 'transitionend', 'touchmove']
})