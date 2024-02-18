Vue.component('item-list',{
    template :`
        <li>
            <a @click="itemUrl(itemid)">
                <div class="thumbnail" v-if="index < 6"><img :src="itemimage" :alt="itemname" ></div>
                <div class="thumbnail" v-else><img v-lazy="itemimage" :alt="itemname"></div>
                <div class="desc">
                    <p class="name">{{itemname}}</p>
                    <div class="price">
                        <b class="sum">{{totalprice}}<span class="won">원</span></b>
                        <b v-if="saleperstring > '0'" class="discount color-red">{{saleperstring}}</b>
                        <b v-if="couponperstring > '0'" class="discount color-green">{{couponperstring}}</b>
                    </div>
                    <slot>
                        <wish-evaluate
                            :evalCount="evalCount"
                            :favCount="favCount"
                            :totalPoint="totalPoint"
                        >
                        </wish-evaluate>
                    </slot>
                </div>
            </a>
        </li>                `
    , props: {
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
    },
    methods : {        
        itemUrl : function(itemid) {
            fnAmplitudeEventAction(this.amplitudeActionName+'item','itemid',itemid);

            this.isApp ? fnAPPpopupProduct(itemid) : function() {
                var itemUrl = "/category/category_itemPrd.asp?itemid="+ itemid +"&flag=e";
                location.href = itemUrl;
            }()
        },
    },
});

Vue.use(VueLazyload, {
	preLoad: 1.3,
	error : false,
	loading : false,
	supportWebp : false,
	listenEvents: ['scroll', 'wheel', 'mousewheel', 'resize', 'animationend', 'transitionend', 'touchmove']
});