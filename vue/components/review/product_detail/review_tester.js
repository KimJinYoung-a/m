Vue.component('REVIEW-TESTER', {
    template : `
        <div v-if="existTesterReviews" class="bnr-tester-review">
            <a href="" :click="popTesterReviewModal">
                <img src="http://fiximage.10x10.co.kr/m/2018/common/img_bnr_tester_1.jpg" alt="">
            </a>
        </div>
    `,
    props : {
        existTesterReviews : { type:Boolean, default:false }, // 테스터 후기 존재 여부
        itemId : { type:Number, default:0 }, // 상품 ID
    },
    methods : {
        //region popTesterReviewModal 테스터 모달 팝업
        popTesterReviewModal() {
            fnOpenModal('/category/pop_ItemTesterEvalList.asp?itemid=' + this.itemId);
        },
        //endregion
    }
});