reviewVue = new Vue({
    el: '#tabReviewApp',
    store: reviewStore,
    template : /*html*/`
        <div>
            <!-- 테스터 후기 영역 -->
            <REVIEW-TESTER :existTesterReviews="existTesterReviews" :itemId="Number(itemId)"/>
    
            <!-- 후기 작성 영역 -->
            <REVIEW-WRITE :itemId="Number(itemId)" :stateProductReviewWrite="stateProductReviewWrite"/>
    
            <!-- 후기가 있을 떄 -->
            <template v-if="totalReviewCount > 0">
    
                <!-- 후기 종합 정보 -->
                <REVIEW-TOTAL-INFO :totalReviewCount="totalReviewCount" :totalReviewPointAverage="totalReviewPointAverage"
                    :reviewPointGroup="reviewPointGroup"/>
    
                <!-- 후기 갤러리 -->
                <GALLERY v-if="reviewGalleries" ref="reviewGallery" :reviewGalleries="reviewGalleries" @clickReviewGallery="clickReviewGallery" />
                
                <!-- 레이어 팝업 후기 갤러리 -->
                <GALLERY-MODAL v-if="reviewGalleries" v-show="showGalleryModal" ref="galleryModal"
                    :reviewGalleries="reviewGalleries"
                    @clickLayerReviewGallery="openReviewDetail" @closeModal="closeGalleryModal" />
                <div v-show="showGalleryModal" class="mask" style="display: block;"></div>
    
                <!-- 후기 정렬 바 -->
                <REVIEW-SORT-BAR @changeSortMethod="changeSortMethod" @changeProductOption="changeProductOption"
                    :reviewParameter="reviewParameter" :itemOptions="itemOptions"/>
    
                <!-- 후기 유형 탭 -->
                <REVIEW-TYPE-TAB @changeReviewType="changeReviewType" :reviewCountGroup="reviewCountGroup"
                    :reviewParameter="reviewParameter" :existOffShopReviews="existOffShopReviews"/>
                
                <div v-show="isReviewPageLoading && reviewParameter.page === 1" style="position:relative;text-align:center; padding:20px 0;">
                    <img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" />
                </div>
    
                <!-- 리뷰 영역 -->
                <div class="postContV16a">
                    <ul class="postListV16a">
                        <!-- 리뷰가 있을 때 -->
                        <template v-if="reviews">
                            <REVIEW v-for="review in reviews" :key="review.index" @openReviewDetail="openReviewDetail" 
                                @report="openReportModal" @cancelReport="successCancelReport"
                                :review="review" :isLogin="isLogin" :isApp="isApp"/>
                        </template>
                        <!-- 리뷰가 없을 때 -->
                        <p v-else class="txtNoneV16a">등록된 상품후기가 없습니다.</p>
                    </ul>
                </div>
    
                <!-- 후기 더보기 버튼 -->
                <div v-if="reviewParameter.page < reviewLastPage" class="btnAreaV16a">
                    <p><button @click="getMoreReviews" type="button" class="btnV16a btnRed1V16a">후기 더 보기</button></p>
                </div>
    
            </template>
            <!-- 후기가 없을 때 -->
            <p v-else class="txtNoneV16a">등록된 상품후기가 없습니다.</p>
            
            <MODAL-POST-REPORT-REVIEW @close="closeReportModal" @report="successReport" 
                :isShow="showReportModal" :review="reportReview" :isLogin="isLogin" :isApp="isApp"/>
        
        </div>
    `,
    data() { return {
        isTicketItem : false, // 티켓 상품 여부
        showGalleryModal : false, // 갤러리 모달 노출 여부
        reviewParameter : { // 후기 조회 파라미터
            reviewType : 'a', // 후기 구분(전체:a, 사진후기:p, 오프후기:o)
            sortMethod : 'ne', // 후기 정렬기준(최신순:ne, 높은평점순:hs, 낮은평점순:rs)
            pageSize : 10, // 페이지당 갯수
            page : 1, // 현재 페이지
            productOptionCode : '' // 상품 옵션
        },

        showReportModal : false, // 신고 모달 노출 여부
        reportReview : null, // 신고할 리뷰

        isLogin : false, // 로그인 여부
    };},
    created() {
        if( reviewUserId ) {
            this.isLogin = true;
        }

        this.$store.commit('SET_ITEM_ID', itemId);
        this.$store.dispatch('GET_REVIEW_MASTER');
        const reviewData = {
            'page' : 1
        };
        this.$store.dispatch('GET_REVIEWS', reviewData);
    },
    computed : {
        isApp() { // 앱 여부
            return location.pathname.toLowerCase().indexOf('/apps/appcom/wish/web2014') > -1;
        },
        itemId() { return this.$store.getters.itemId; }, // 상품ID
        totalReviewCount() { return this.$store.getters.totalReviewCount; }, // 총 후기 수
        totalReviewPointAverage() { return this.$store.getters.totalReviewPointAverage; }, // 총 후기 평점 평균
        reviewPointGroup() { return this.$store.getters.reviewPointGroup; }, // 리뷰 평점 별 비율
        reviewGalleries() { return this.$store.getters.reviewGalleries; }, // 리뷰 갤러리 리스트
        itemOptions() { return this.$store.getters.itemOptions; }, // 상품옵션 리스트
        stateProductReviewWrite() { return this.$store.getters.stateProductReviewWrite; }, // 상품 후기 작성 관련 상태
        existTesterReviews() { return this.$store.getters.existTesterReviews; }, // 테스터 후기 존재 여부
        existOffShopReviews() { return this.$store.getters.existOffShopReviews; }, // 매장후기 존재 여부
        reviewCountGroup() { return this.$store.getters.reviewCountGroup; }, // 후기 수 그룹
        reviews() { return this.$store.getters.reviews; }, // 후기 리스트
        reviewLastPage() { return this.$store.getters.reviewLastPage; }, // 후기 리스트 마지막 페이지
        isReviewPageLoading() { return this.$store.getters.isReviewPageLoading; } // 후기 페이지 로딩 중 여부
    },
    methods : {
        //region clickReviewGallery 후기 갤러리 클릭
        clickReviewGallery(index, moreFlag) {
            if( moreFlag ) {
                this.viewPhotoReviewsGathering();
            } else {
                this.popupGalleryModal(index);
            }
        },
        //endregion
        //region popupGalleryModal 갤러리 모달 팝업
        popupGalleryModal(index) {
            const _this = this;
            this.showGalleryModal = true;
            this.lockScrollReviewGallery();
            setTimeout(function() {
                _this.$refs.galleryModal.setSlider(index);
                _this.hideTabAndButton();
            }, 100);
        },
        //endregion
        //region hideTabAndButton 상세설명, Zoom버튼, Top버튼 숨기기
        hideTabAndButton() {
            $(".commonTabV16a").hide(); // 상세설명 TAB
            $(".btn-zoom").hide(); // Zoom 버튼
            $(".btn-top").hide(); // Tob 버튼
        },
        //endregion
        //region showTabAndButton 상세설명, Zoom버튼, Top버튼 노출
        showTabAndButton() {
            $(".commonTabV16a").show(); // 상세설명 TAB
            $(".btn-zoom").show(); // Zoom 버튼
            $(".btn-top").show(); // Tob 버튼
        },
        //endregion
        //region lockScrollReviewGallery 리뷰 갤러리 팝업으로 인한 기존 body 스크롤 잠그기
        lockScrollReviewGallery() {
            $('html, body').animate({scrollTop: $(".itemDeatilV16a").offset().top}, 0);
            $('html, body').css({'overflow':'hidden','height':'auto'});
            $('.itemDeatilV16a').on('scroll touchmove mousewheel', function(e) {
                e.preventDefault();
                e.stopPropagation();
                return false;
            });
        },
        //endregion
        //region unLockScrollReviewGallery 리뷰 갤러리 팝업 닫음으로 인한 기존 body 스크롤 풀기
        unLockScrollReviewGallery() {
            $('html, body').css({'overflow':'auto'});
            $('.itemDeatilV16a').off('scroll touchmove mousewheel');
        },
        //endregion
        //region closeGalleryModal 후기 갤러리 모달 닫기
        closeGalleryModal() {
            this.showGalleryModal = false;
            this.showTabAndButton();
            this.unLockScrollReviewGallery();
        },
        //endregion
        //region openReviewDetail 후기 상세 열기
        openReviewDetail(reviewIndex) {
            if( this.isApp )
                fnAPPpopupBrowserURL('포토후기',location.origin + '/apps/appCom/wish/web2014/category/pop_ItemEvalPhotoDetail.asp?itemid=' + this.itemId + '&idx=' + reviewIndex);
            else
                window.open('/category/pop_ItemEvalPhotoDetail.asp?itemid=' + this.itemId + '&idx=' + reviewIndex);
        },
        //endregion
        //region viewPhotoReviewsGathering 사진 모아 보기
        viewPhotoReviewsGathering() {
            if( this.isApp )
                fnAPPpopupBrowserURL('사진 모아보기',location.origin + '/apps/appCom/wish/web2014/category/pop_ItemEvalPhotoList.asp?itemid=' + this.itemId);
            else
                fnOpenModal('/category/pop_ItemEvalPhotoList.asp?itemid=' + this.itemId);
        },
        //endregion
        //region changeReviewType 후기 구분값 변경
        changeReviewType(type) {
            this.reviewParameter.reviewType = type;
            this.reviewParameter.page = 1;
            this.getReviews();
        },
        //endregion
        //region changeSortMethod 후기 정렬 변경
        changeSortMethod(sortMethod) {
            this.reviewParameter.sortMethod = sortMethod;
            this.reviewParameter.page = 1;
            this.getReviews();
        },
        //endregion
        //region changeProductOption 후기 상품옵션 변경
        changeProductOption(option) {
            this.reviewParameter.productOptionCode = option;
            this.reviewParameter.page = 1;
            this.getReviews();
        },
        //endregion
        //region getReviews 후기 리스트 불러오기
        getReviews() {
            this.$store.dispatch('GET_REVIEWS', this.reviewParameter);
        },
        //endregion
        //region getMoreReviews 후기 리스트 더 불러오기
        getMoreReviews() {
            if( !this.isReviewPageLoading ) { // 페이지를 불러오는 중이 아니면
                this.reviewParameter.page++;
                this.$store.dispatch('GET_MORE_REVIEWS', this.reviewParameter);
            }
        },
        //endregion
        //region openReportModal 신고 모달 열기
        openReportModal(review) {
            $('.btnAreaV16a').hide();
            this.reportReview = review;
            this.showReportModal = true;
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
            if( type === 3 ) {
                this.$store.dispatch('GET_REVIEW_MASTER');
                this.getReviews();
                this.syncBottomReview();
            } else {
                this.$store.commit('UPDATE_REVIEW_REPORT_VALUES', {
                    index : this.reportReview.index,
                    count : reportCount,
                    type : type
                });
            }
            this.closeReportModal();
        },
        syncBottomReview() {
            bottomReviewVue.$store.dispatch('GET_REVIEW_MASTER');
            bottomReviewVue.$store.dispatch('GET_REVIEWS');
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
        //region getLayerReviewGalleryUserLevelThumbnailClass 레이어 후기 갤러리 유저 등급 썸네일 클래스
        getLayerReviewGalleryUserLevelThumbnailClass(userLevel) {
            return ['thumb', this.getUserLevelClass(userLevel)];
        },
        //endregion
        //region getUserLevelClass GET 유저 등급 클래스명
        getUserLevelClass(userLevel) {
            switch(userLevel) {
                case 1: return "red";
                case 2: return "vip";
                case 3: return "vipgold";
                case 4:
                case 6:
                case 7:
                    return "vvip";
                default:
                    return "white";
            }
        },
        //endregion
        //region decodeBase64 Base64 디코딩
        decodeBase64(str) {
            return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
        },
        //endregion
    }
});