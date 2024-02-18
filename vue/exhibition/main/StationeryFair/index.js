var app = new Vue({
    el: '#app',
    store : store ,
    template: '\
                <div class="items-list">\
                    <ul>\
                        <ItemList\
                            v-for="(item,index) in itemLists"\
                                :key="index"\
                                :index="index"\
                                :itemId="item.itemId"\
                                :itemImage="item.itemImage"\
                                :itemName="item.itemName"\
                                :brandName="item.brandName"\
                                :totalPrice="item.totalPrice"\
                                :salePerString="item.salePercentString"\
                                :couponPerString="item.couponPercentString"\
                                :isApp="isApp"\
                                :amplitudeActionName="amplitudeActionName"\
                                :evalCount="item.evaluateCount"\
                                :favCount="item.favoriteCount"\
                                :totalPoint="item.evaluatePointAVG"\
                                :sellDate="item.sellDate"\
                                :isSellYN="item.isSellYN"\
                        >\
                        </ItemList>\
                    </ul>\
                </div>\
    ',
    data : function() {
        return {
            isApp : is_app,
            amplitudeActionName : "click_brand_justsold_",
            trigger : 0.7 ,
        }
    },
    computed: {
        itemLists : function() {
            return this.$store.state.itemLists;
        },
    },
    created : function() {
        this.$store.dispatch('GET_ITEMLISTS');
    },
    mounted : function() {
        this.scroll();
    },
    methods : {
        scroll : function() {
            var _this = this;
            window.onscroll = function(ev) {
                if (window.scrollY >= ( document.body.scrollHeight - document.body.offsetHeight ) - _this.trigger){
                    _this.$store.commit('SET_PAGENUMBER', _this.$store.state.params.page + 1);
                    _this.$store.dispatch('GET_ITEMLISTS');
                }
            }
        }
    }
})