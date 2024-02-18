Vue.component('ItemList-ReviewArea',{
    template : '\
                <!-- 상품 리스트 평점 영역 -->\
                <div class="user_side">\
                    <span class="user_eval"><dfn>평점</dfn><i style="width:80%">80점</i></span>\
                    <span class="user_comment"><dfn>상품평</dfn>count</span>\
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