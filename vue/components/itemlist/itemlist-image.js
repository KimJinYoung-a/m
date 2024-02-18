Vue.component('ItemList-Image',{
    template : '\
                <!-- 상품 리스트 이미지 영역 -->\
                <figure class="prd_img">\
                    <img src="//thumbnail.10x10.co.kr/webimage/image/basic600/210/B002105986.jpg" alt="">\
                    <span class="mask"></span>\
                </figure>\
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