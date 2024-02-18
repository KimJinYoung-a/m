Vue.component('Quicklink',{
    template : `
            <!-- 퀵 링크 -->
            <div v-if="background_image" :class="['kwd_quick', {no_swiper : recommend_keywords.length == 0}]">
                <figure><img :src="background_image" alt=""></figure>
                <a :href="move_url">
                    <pre class="kwd_info ellipsis2" :style="'color:#' + text_color">{{main_copy}}</pre>
                </a>
            </div>
    `,
    props: {
        background_image : {type:String, default: ''}, // 배경 이미지
        move_url : {type:String, default: ''}, // 클릭 시 이동할 페이지
        main_copy : {type:String, default: ''} // 메인 카피
        , text_color : {type:String, default: ''} //글자 색
        , recommend_keywords : {type:Array, default:function(){return [];}} // 대체검색어
    }
});