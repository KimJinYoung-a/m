var app = new Vue({
    el: '#app',
    store : store ,
    template: `
        <div>
            <CategoryFilter v-if="categories.length > 0" :categories="categories"></CategoryFilter>
            <div class="items-list">
                <ul v-if="itemLists.length > 0">
                    <ItemList
                        v-for="(item,index) in itemLists"
                            :key="index"
                            :index="index"
                            :itemId="item.itemId"
                            :itemImage="item.itemImage"
                            :itemName="item.itemName"
                            :brandName="item.brandName"
                            :totalPrice="item.totalPrice"
                            :salePerString="item.salePercentString"
                            :couponPerString="item.couponPercentString"
                            :isApp="isApp"
                            :amplitudeActionName="amplitudeActionName"
                            :evalCount="item.evaluateCount"
                            :favCount="item.favoriteCount"
                            :totalPoint="item.evaluatePointAVG"
                            :sellDate="item.sellDate"
                            :isSellYN="item.isSellYN"
                    >
                    </ItemList>
                </ul>
                <No-Data v-else-if="!isLoading"
                    :backUrlButtonDisplayFlag="false"
                    mainCopy="방금 판매된 상품이 없어요"
                    subCopy="상품이 품절되었을 경우 노출되지<br>않을 수 있으니 참고해주세요 :)"
                ></No-Data>
            </div>
        </div>
    `,
    data : function() {
        return {
            isApp : isApp,
            amplitudeActionName : "click_justsold_",
            trigger : 0.7 ,
        }
    },
    computed: {
        itemLists : function() {
            return this.$store.state.itemLists;
        },
        categories() {
            return this.$store.state.categories;
        },
        isLoading() {
            return this.$store.state.isLoading;
        },
    },
    created : function() {
        this.$store.dispatch('GET_CATEGORIES');
        this.$store.dispatch('GET_ITEMLISTS');
    },
    mounted : function() {
        this.scroll();
    },
    methods : {
        scroll : function() {
            var _this = this;
            window.onscroll = function(ev) {
                if (_this.itemLists.length > 0 && window.scrollY >= ( document.body.scrollHeight - document.body.offsetHeight ) - _this.trigger){
					_this.$store.commit('SET_PAGENUMBER', _this.$store.state.params.page + 1);
                    _this.$store.dispatch('GET_ITEMLISTS');
				}
            }
        }
    }
})
