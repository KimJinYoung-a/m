const review_mixin = Vue.mixin({
    methods : {
        // 상품 URL
        itemUrl(item_id) {
            fnAmplitudeEventAction(this.amplitudeActionName+'item','itemid',item_id);

            this.isApp ? fnAPPpopupProduct(item_id) : function() {
                let itemUrl = "/category/category_itemPrd.asp?itemid="+ item_id +"&flag=e";
                location.href = itemUrl;
            }()
        },
    }
});