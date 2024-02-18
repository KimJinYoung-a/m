const dealReviewVue = new Vue({
    el : '#dealReviewVue',
    store : dealReviewStore,
    template : `
        <div id="tab03" class="postTxtV16a" style="display:none;">
            
            <!-- 상품 선택 SELECT 박스 -->
            <SELECT-PRODUCT @changeProduct="changeProduct" :dealProducts="dealProducts"/>
            
            <!-- 후기 작성 버튼 -->
            <BUTTON-WRITE :itemId="selectedProductId" :isLogin="isLogin" :isApp="isApp"/>
            
            <!-- 후기 타입 탭 -->
            <TAB-REVIEW-TYPE :reviewType="reviewType" :totalCount="totalCount" :productReviewTypeCount="productReviewTypeCount"
                @changeReviewType="changeReviewType"/>
            
            <!-- 후기 리스트 -->
            <REVIEW-LIST v-if="reviews && reviews.length > 0" :itemId="selectedProductId" :reviews="reviews" 
                :reviewType="reviewType" :isLogin="isLogin" :isApp="isApp"
                @report="openReportModal" @cancelReport="successCancelReport"/>
            <p class="txtNoneV16a" v-else>등록된 상품후기가 없습니다.</p>
                
            <!-- 후기 신고 모달 -->
            <MODAL-POST-REPORT-REVIEW @close="closeReportModal" @report="successReport" 
                :isShow="showReportModal" :review="reportReview" :isLogin="isLogin" :isApp="isApp"/>
            
        </div>
    `,
    data() {return {
        isLogin : false, // 로그인 여부
        showReportModal : false, // 후기 신고 모달 노출 여부
        reportReview : null, // 신고 중인 후기
    }},
    mounted() {
        if( dealReviewUserId )
            this.isLogin = true;

        this.$store.commit('SET_MASTER_IDX', Number(dealReviewMasterIdx));
        this.$store.dispatch('GET_DEAL_PRODUCTS');
    },
    computed : {
        isApp() { return location.pathname.toLowerCase().indexOf('/apps/appcom/wish/web2014') > -1; },
        masterIdx() { return this.$store.getters.masterIdx; },
        totalCount() { return this.$store.getters.totalCount; },
        reviewType() { return this.$store.getters.reviewType; },
        dealProducts() { return this.$store.getters.dealProducts; },
        productReviewTypeCount() { return this.$store.getters.productReviewTypeCount; },
        reviews() { return this.$store.getters.reviews; },
        //region selectedProductId 현재 선택중인 상품ID
        selectedProductId() {
            const product = this.dealProducts.find(p => p.selected);
            if( product )
                return product.itemId;
        },
        //endregion
    },
    methods : {
        //region changeProduct 상품 변경
        changeProduct(itemId) {
            this.$store.commit('CHANGE_SELECTED_PRODUCT', itemId);
            this.$store.dispatch('GET_REVIEWS');
        },
        //endregion
        //region changeReviewType 후기구분 변경
        changeReviewType(reviewType) {
            if( this.reviewType !== reviewType ) {
                this.$store.commit('SET_REVIEW_TYPE', reviewType);
                this.$store.dispatch('GET_REVIEWS');
            }
        },
        //endregion
        //region openReportModal 후기 신고하기
        openReportModal(review) {
            $('.btnAreaV16a').hide();
            this.reportReview = review;
            this.showReportModal = true;
        },
        //endregion
        //region successReport 신고 성공
        successReport(type, reportCount) {
            this.$store.commit('UPDATE_REVIEW_REPORT_VALUES', {
                index : this.reportReview.index,
                count : reportCount,
                type : type
            });
            this.closeReportModal();
        },
        //endregion
        //region closeReportModal 신고 모달 닫기
        closeReportModal() {
            $('.btnAreaV16a').show();
            this.reportReview = null;
            this.showReportModal = false;
        },
        //endregion
        //region successCancelReport 신고 취소 성공
        successCancelReport(reviewIndex, reportCount) {
            this.$store.commit('UPDATE_REVIEW_REPORT_VALUES', {
                index : reviewIndex,
                count : reportCount,
                type : 0
            });
        },
        //endregion
    }
});