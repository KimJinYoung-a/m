Vue.component('Brand-Image',{
    template : `
            <!-- 브랜드 이미지 -->
            <figure class="brd_img">
                <img :src="image_url" alt="">
            </figure>
    `,
    props : {
        image_url : String
    }
})