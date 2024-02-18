Vue.component('ItemList',{
    template :'\
                <li v-bind:class="soldOut">\
					<a @click="itemUrl(itemId)">\
						<div class="label-time">{{sellDate}}</div>\
						<div class="thumbnail"><img :src="itemImage" :alt="itemName" /></div>\
						<div class="desc">\
							<div class="price">{{totalPrice}}<span class="discount">{{saleInfo}}</span></div>\
							<div class="name">{{itemName}}</div>\
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
        itemId : {
            type: Number,
            default: 0
        },
        itemName : {
            type : String,
            default : ''
        },
        itemImage : {
            type : String,
            default : ''
        },
        brandName : {
            type : String,
            default : ''
        },
        totalPrice : {
            type : String,
            default : "0"
        },
        totalSalePer : {
            type : String,
            default : "0"
        },
        salePerString : {
            type : String,
            default : "0"
        },
        couponPerString : {
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
        sellDate : {
            type : String,
            default : ""
        },
        isSellYN : {
            type : String,
            default : "Y"
        }
    },
    computed : {
        saleInfo : function() {
            let resultString = "";

            if (this.salePerString != "0" && this.couponPerString != "0") {
                resultString = "더블할인";
            } else {
                if (this.salePerString != "0") {
                    resultString = this.salePerString;
                } else if( this.couponPerString != "0") {
                    resultString = this.couponPerString;
                }
            }

            return resultString;
        },
        soldOut : function() {
            return {
                soldout : this.isSellYN == "N"
            }
        },
        evaluateCount : function() {
            return this.evalCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
        }
    },
    methods : {
        itemUrl : function(itemId) {
            fnAmplitudeEventAction(this.amplitudeActionName+'item','itemid',itemId);

            this.isApp ? fnAPPpopupProduct(itemId) : function() {
                var itemUrl = "/category/category_itemPrd.asp?itemid="+ itemId +"&flag=e";
                location.href = itemUrl;
            }()
        },
    },
})