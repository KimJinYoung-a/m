// 히치하이커 배너
Vue.component('Hitchhiker-Banner',{
    template : `
        <div class="bnr_addr" @click="click_banner"
            v-if="address_banner_show_yn || editor_banner_show_yn"
        >
            <template v-if="address_banner_show_yn && !closed_application_yn">
            <!-- 주소입력 신청 기간(마감X) -->
                <b>VVIP, VIP GOLD 고객님</b><br>선착순 10,000분께 히치하이커 신간을 드려요!
                <span class="txt_btn">주소입력하고 선물 받기<i class="i_arw_r1"></i></span>
                <a id="btn_address" class="link"></a>
            </template>
            <template v-else-if="address_banner_show_yn">
            <!-- 주소입력 신청 기간 마감 -->
                VVIP, VIP GOLD 고객님께 드리는<br>히치하이커 선착순 신청이 마감되었어요!<br><b>다음 신청도 기대해주세요 :)</b>
            </template>
            <template v-else-if="editor_banner_show_yn">
            <!-- 에디터 모집 기간 -->
                지금은 고객 에디터 모집 기간입니다.<br><b>PC버전에서 히치하이커 에디터로 참여해보세요 :)</b>
            </template>
        </div>
	`,
    props : {
        address_banner_show_yn : { type:Boolean, default:false }, // 주소입력 배너 노출 여부
        closed_application_yn : { type:Boolean, default:false }, // 선착순 마감 여부
        editor_banner_show_yn : { type:Boolean, default:false } // 에디터 모집 배너 노출 여부
    },
    methods : {
        click_banner() {
            // 주소입력 신청기간 중이고 마감X 일때만 click event emit
            if( this.address_banner_show_yn && !this.closed_application_yn ) {
                fnAmplitudeEventMultiPropertiesAction('click_hitchhiker_banner_address', '', '');
                this.$emit('click_banner');
            }
        }
    }
});