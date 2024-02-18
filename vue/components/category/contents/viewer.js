Vue.component('Banner-Viewer',{
    template : `
    <!-- 배너뷰어 (viewer) -->
    <div class="modal_body">
        <div class="modal_cont">
            <div class="viewer">
                <div class="evt_list_type3">
                    <article class="evt_item"
                        v-for="(banner, index) in banners"
                        :key="index">
                        <figure class="evt_img"><img :src="banner.banner_image" alt=""></figure>
                        <div class="evt_info">
                            <div class="num">{{(index < 10 ? '0' : '') + index}}</div>
                            <div class="evt_name ellipsis3" v-html="banner.banner_text"></div>
                        </div>
                        <a :href="banner.move_url" class="evt_link"><span class="blind">이벤트 바로가기</span></a>
                    </article>
                </div>
            </div>
        </div>
    </div>
    `,
    props : {
        banners: { // 배너 리스트
            banner_image: String,
            banner_text: String,
            move_url: String
        }
    },
});