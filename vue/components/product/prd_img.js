Vue.component('Product-Image',{
    template : `<figure class="prd_img" :style="image_style">
                    <img :src="image_url" alt="">
                    <span class="prd_mask"></span>
                </figure>`,
    props : {
        image_url   : String,   // 이미지 url
        image_style : { // 기타 추가할 스타일
            type : String,
            default : ''
        }
    }
})