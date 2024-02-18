Vue.component('ItemList-Price',{
    template : '\
                <!-- 상품 리스트 가격 영역 -->\
                <div class="prd_price">\
                <span class="set_price"><dfn>판매가</dfn>10,000</span>\
                <span class="discount"><dfn>할인율</dfn>5%</span>\
            </div>\
    ',
    props : {
        itemId : {
            type : Number,
            default : 0,
        },
    },
    methods : {

    }
})