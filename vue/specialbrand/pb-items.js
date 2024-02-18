Vue.component('pb-items', {
    template: '\
    <div class="items type-grid"\
        v-if="componentData.length > 0"\
    >\
        <ul>\
            <li\
                v-for="(item, idx) in componentData"\
                v-if="idx < limit"\
            >\
                <a @click="productLink(item.itemid)">\
                    <div class="thumbnail">\
                        <img :src="item.itemImg" alt="" />\
                        <b class="soldout"\
                            v-if="item.sellyn !=\'Y\'"\
                        >일시 품절</b>\
                        <em\
                            v-if="item.sellDiff != \'\'"\
                        >{{item.sellDiff}}</em>\
                    </div>\
                    <div class="desc">\
                        <span class="brand">{{item.brandName}}</span>\
                        <p class="name">{{item.itemName}}</p>\
                        <div class="price">\
                            <div class="unit">\
                                <b class="sum">{{setComma(item.price)}}</b>\
                                <b class="discount color-red"\
                                    v-if="item.saleStr != \'\'"\
                                >{{item.saleStr + \'%\'}}</b>\
                                <b class="discount color-green"\
                                    v-if="item.couponStr != \'\'"\
                                >{{item.couponStr}}</b>\
                            </div>\
                        </div>\
                        <div class="etc">\
                            <button class="tag wish btn-wish"\
                                :class="item.isWishItem ? \'on\' : \'\'"\
                                v-if="item.favCnt > 0"\
                            >\
                                <span class="icon-wish-pink"><i class="hidden"> wish</i></span>\
                                <span class="counting">{{item.favCnt}}</span>\
                            </button>\
                            <div class="tag review">\
                                <span class="icon icon-rating"\
                                    v-if="item.totalpointAvg != 0"\
                                >\
                                    <i\
                                        v-bind:style="{\'width\': item.totalpointAvg + \'%\'}">리뷰 종합 별점 {{item.totalpointAvg}}점</i>\
                                </span>\
                            </div>\
                        </div>\
                    </div>\
                </a>\
            </li>\
        </ul>\
        <button class="btn-more"\
            @click="setLimit"\
            v-if="limit != componentData.length && componentData.length > limit "\
        >+ <em>{{c_moreNumber}}</em>건 더보기</button>\
    </div>\
    ',
    data: function(){
        return {
            limit: 10,
            moreNumber: 10
        }
    },
    methods: {
        setLimit: function(){
            this.limit += this.moreNumber
        },
        setComma: function(x){
            return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        },
        productLink: function(itemId){
            if(isapp == 1){
                TnGotoProduct(itemId);
            }else{
                window.location.href = "/category/category_itemPrd.asp?itemid="+itemId
            }
            return false;
        }
    },
    props: {
        componentData: {
            type: Array,
            default: []
        }
    },
    computed: {
        c_moreNumber: function(){
            return Math.floor(this.restArrNum / this.moreNumber) > 0 ? 
                   this.moreNumber : 
                   this.restArrNum % this.moreNumber
        },
        restArrNum: function(){
            return this.componentData.length > this.moreNumber ?
                   this.componentData.length - this.limit :
                   this.componentData.length
        }
    }
})