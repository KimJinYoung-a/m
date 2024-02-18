Vue.component('Product-MoreButton',{
    template : `<button type="button" class="btn_more" v-if="more_cnt > 0" @click="click_OpenModal">{{totalCount}}<i class="i_arw_r2"></i></button>`,
    props : {
        more_cnt: { type: Number, default: 0 }, // 후기 갯수
        brand_id : { type : String , default : ''}, // 브랜드 ID
    },
    computed : {
        totalCount() {
            return `${this.more_cnt > 999 ? "999+" : this.more_cnt}개의 신상품 더보기`;
        }
    },
    methods : {
        click_OpenModal() { // 신상품 모달팝업
            this.$emit('click_OpenModal',this.brand_id);
        }
    }
})