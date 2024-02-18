Vue.component('ItemList-Link',{
    template : '\
                <!-- 상품 리스트 링크 -->\
                <a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>\
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