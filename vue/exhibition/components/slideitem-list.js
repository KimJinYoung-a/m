Vue.component('slideitem-list',{
    template :'\
                <li class="swiper-slide">\
                    <a @click="itemUrl(itemid)">\
                        <div class="thumbnail">\
                            <p v-if="optionCode > \'0\'" class="tagV18 t-low"><span>{{tagName}}</span></p>\
                            <img :src="itemimage" :alt="itemname" v-if="index < 3">\
                            <img v-lazy="itemimage" :alt="itemname" v-else>\
                        </div>\
                        <div class="desc">\
                            <p class="name">{{itemname}}</p>\
                            <b v-if="saleperstring > \'0\'" class="discount color-red">{{saleperstring}}</b>\
                            <b v-if="couponperstring > \'0\'" class="discount color-green">{{couponperstring}}</b>\
                        </div>\
                    </a>\
                </li>\
                '
    ,
    props: {
        index : {
            type : Number,
            default : 0
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
        optionCode : {
            type : [String,Number],
            default : "0"
        }
    },
    computed : {
        tagName : function() {
            switch (this.optionCode) {
                case "1" :
                    return '최저가';
                case "2" : 
                    return '특가';
                case "3" : 
                    return '단독';
                default : 
                    return ''
            }
        }
    },
    methods : {        
        itemUrl : function(itemid) {
            fnAmplitudeEventAction(this.amplitudeActionName,'itemid',itemid);

            this.isApp ? fnAPPpopupProduct(itemid) : function () {
                var itemUrl = "/category/category_itemPrd.asp?itemid="+ itemid +"&flag=e";
                location.href = itemUrl;
            }()
        },
    },
})