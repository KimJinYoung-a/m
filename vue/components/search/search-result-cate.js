Vue.component('Search-Result-Cate',{
    template : '\
                <!-- 검색 결과 구분 -->\
                <div class="srch_cate">\
                    <ul>\
                        <li class="on"><a href="">전체<span class="cnt">10,255</span></a></li>\
                        <li><a href="">상품<span class="cnt">10,255</span></a></li>\
                        <li><a href="">상품 후기<span class="cnt">10,255</span></a></li>\
                        <li><a href="">기획전<span class="cnt">10,255</span></a></li>\
                        <li><a href="">이벤트<span class="cnt">10,255</span></a></li>\
                        <li><a href="">브랜드<span class="cnt">10,255</span></a></li>\
                        <li><a href="">텐텐tv<span class="cnt">10,255</span></a></li>\
                    </ul>\
                </div>\
    ',
    props : {
        itemId : {
            type : Number,
            default : 0,
        },
        optionCount : {
            type : Number,
            default : 0,
        },
        isApp : {
            type : Boolean,
            default : false,
        },
    },
    methods : {

    }
})