Vue.component('item-list',{
    template :'\
                <li>\
                    <a @click="itemUrl(itemid)">\
                        <div class="thumbnail">\
                            <img :src="itemimage" :alt="itemname">\
                            <slot>\
                                <ShoppingBag\
                                    :itemId="itemid"\
                                    :optionCount="optionCount"\
                                    :sellCash="sellCash"\
                                    :isApp="isApp"\
                                >\
                                </ShoppingBag>\
                            </slot>\
                        </div>\
                        <div class="desc">\
                            <div class="price">{{totalprice}}\
                                <span v-if="saleperstring > \'0\'" class="sale">{{saleperstring}}</span>\
                                <span v-if="couponperstring > \'0\'" class="coupon">{{couponperstring}}</span>\
                            </div>\
                            <div class="name">{{itemname}}</div>\
                            <div class="brand">{{brandname}}</div>\
                            <div class="review" v-if="evalCount > \'0\'">\
                                <span class="rating"><i v-bind:style="{width : totalPoint +\'%\'}"></i></span>\
                                <span class="counting">{{evalCount}}</span>\
                            </div>\
                        </div>\
                    </a>\
                </li>\
                '
    ,
    props: {
        index : {
            type: Number,
            default: 0
        },
        itemid: {
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
            default : false,
        },
        evalCount: {
            type: Number,
            default: 0
        },
        totalPoint : {
            type : Number,
            default : 0
        },
        optionCount : {
            type : Number,
            default : 0
        },
        sellCash : {
            type : Number,
            default : 0
        },
        amplitudeActionName : {
            type : String,
            default : ""
        },
    },
    methods : {        
        itemUrl : function(itemid) {
            fnAmplitudeEventAction(this.amplitudeActionName + 'item','itemid',itemid);

            this.isApp ? fnAPPpopupProduct(itemid) : function() {
                var itemUrl = "/category/category_itemPrd.asp?itemid="+ itemid +"&flag=e";
                location.href = itemUrl;
            }()
        },
    },
})