Vue.component('ItemList-Badge',{
    template : '\
                <!-- 상품 리스트 뱃지영역 -->\
                <div class="prd_badge">\
                    <span class="badge_type1">앞뱃지</span>\
                    <span class="badge_type2">뒷뱃지</span>\
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