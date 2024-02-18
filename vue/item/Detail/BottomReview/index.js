const bottomReviewVue = new Vue({
    el : '#bottomReviewApp',
    store : bottomReviewStore,
    template : `
        <div v-if="reviews && reviews.length > 0" class="postTxtV16a post-txtV18">
            
            <REVIEW-TESTER :existTesterReviews="existTesterReviews" :itemId="itemId"/>
            
            <h3 class="tit-review">상품후기</h3>
            
            <REVIEW-WRITE :itemId="itemId" :stateProductReviewWrite="stateProductReviewWrite"/>
            
            <REVIEW-TOTAL-INFO :totalReviewCount="totalReviewCount" :totalReviewPointAverage="totalReviewPointAverage"
                    :reviewPointGroup="reviewPointGroup"/>
            
            <!-- 리뷰 영역 -->
            <div class="postContV16a">
                <ul class="postListV16a">
                    <REVIEW v-for="review in reviews" :key="review.index" @openReviewDetail="openReviewDetail" 
                        @report="openReportModal" @cancelReport="successCancelReport"
                        :review="review" :isLogin="isLogin" :isApp="isApp"/>
                </ul>
            </div>

            <!-- 후기 더보기 버튼 -->
            <div class="btnAreaV16a">
                <p><button @click="viewMoreReviews" type="button" class="btnV16a btnRed1V16a">더 많은 후기 보기</button></p>
            </div>
            
            <!-- 후기 신고 모달 -->
            <MODAL-POST-REPORT-REVIEW @close="closeReportModal" @report="successReport" 
                :isShow="showReportModal" :review="reportReview" :isLogin="isLogin" :isApp="isApp"/>
            
        </div>
    `,
    created() {
        if( reviewUserId ) {
            this.isLogin = true;
        }

        this.$store.commit('SET_ITEM_ID', itemId);
        this.$store.dispatch('GET_REVIEW_MASTER');
        this.$store.dispatch('GET_REVIEWS');
    },
    data() { return {
        isTicketItem : false,
        isLogin : false, // 로그인 여부

        showReportModal : false, // 신고 모달 노출 여부
        reportReview : null, // 신고할 리뷰
    }},
    computed : {
        isApp() { return location.pathname.toLowerCase().indexOf('/apps/appcom/wish/web2014') > -1; }, // APP 여부
        itemId() { return this.$store.getters.itemId; }, // 상품ID
        totalReviewCount() { return this.$store.getters.totalReviewCount; }, // 총 후기 수
        totalReviewPointAverage() { return this.$store.getters.totalReviewPointAverage; }, // 총 후기 평점 평균
        reviewPointGroup() { return this.$store.getters.reviewPointGroup; }, // 리뷰 평점 별 비율
        reviews() { return this.$store.getters.reviews; }, // 후기 리스트
        stateProductReviewWrite() { return this.$store.getters.stateProductReviewWrite; }, // 상품 후기 작성 관련 상태
        existTesterReviews() { return this.$store.getters.existTesterReviews; }, // 테스터 후기 존재 여부
    },
    methods : {
        //region openReviewDetail 후기 상세 열기
        openReviewDetail(reviewIndex) {
            if( this.isApp )
                fnAPPpopupBrowserURL('포토후기',location.origin + '/apps/appCom/wish/web2014/category/pop_ItemEvalPhotoDetail.asp?itemid=' + this.itemId + '&idx=' + reviewIndex);
            else
                window.open('/category/pop_ItemEvalPhotoDetail.asp?itemid=' + this.itemId + '&idx=' + reviewIndex);
        },
        //endregion
        //region openReportModal 신고 모달 열기
        openReportModal(review) {
            $('.btnAreaV16a').hide();
            this.reportReview = review;
            this.showReportModal = true;
        },
        //endregion
        //region successCancelReport 신고 취소 성공
        successCancelReport(index, reportCount) {
            this.$store.commit('UPDATE_REVIEW_REPORT_VALUES', {
                index : index,
                count : reportCount,
                type : 0
            });
        },
        //endregion
        //region closeReportModal 신고 모달 닫기
        closeReportModal() {
            $('.btnAreaV16a').show();
            this.reportReview = null;
            this.showReportModal = false;
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

        //region viewMoreReviews 더 많은 후기 보기
        viewMoreReviews() {
            $(".itemDeatilV16a .itemDetailContV16a div#tab01").hide();
            $(".itemDeatilV16a .itemDetailContV16a div#tab03").show();
            $('.itemDeatilV16a .commonTabV16a li:first-child').removeClass('current');
            $('.itemDeatilV16a .commonTabV16a li:nth-child(3)').addClass('current');
            var tabView = $(".itemDeatilV16a .tabCont div[id|='tab03']");
            $(tabView).show();
            $('html, body').animate({scrollTop: $(".itemDeatilV16a").offset().top - $(".header_wrap").outerHeight()}, 500);
            reviewVue.$refs.reviewGallery.setSwiper(); // 후기 갤러리 스와이퍼 set
        },
        //endregion
    }
});