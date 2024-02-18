Vue.component('Event-List-Md',{
    template : '\
                <!-- 기획전 리스트 -->\
                <div class="evt_list_type2">\
                    <article \
                        v-for="(exhibition, index) in exhibitions"\
                        :key="exhibition.evt_code"\
                        class="evt_item">\
                        <Event-Image :image_url="exhibition.banner_img"></Event-Image>\
                        <Event-Info\
                            :evt_name="exhibition.evt_name"\
                            :discount="exhibition.sale_and_coupon"\
                            :badge1="exhibition.badge1"\
                            :badge2="exhibition.badge2"\
                        ></Event-Info>\
                        <a @click="click_exhibition(index, exhibition)" class="evt_link"><span class="blind">이벤트 바로가기</span></a>\
                        <!--<button type="button" class="btn_wish_on">위시 해제</button>-->\
                    </article>\
                </div>\
    ',
    props : {
        exhibitions : {
            evt_code : Number, // 이벤트 코드
            banner_img: String, // 배너 이미지
            evt_name: String, // 이벤트 명
            sale_and_coupon: String, // 세일or쿠폰 텍스트
            badge1: String, // 뱃지1
            badge2: String, // 뱃지2
            move_url: String, // 이동할 URL
            wish_yn: Boolean // 위시 여부 ( 1차에선 사용 X -> false )
        }
    },
    methods : {
        click_exhibition(index, exhibition) {
            this.$emit('click_exhibition', index, exhibition);
            location.href = exhibition.move_url;
        }
    }
})