Vue.component('ItemList-Name',{
    template : '\
                <!-- 상품 리스트 상품명 -->\
                <div class="prd_name">상품명</div>\
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