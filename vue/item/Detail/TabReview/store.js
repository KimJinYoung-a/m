const reviewStore = new Vuex.Store({
    state : {
        itemId : 0, // 상품ID
        totalReviewCount : 0, // 총 후기 수
        totalReviewPointAverage : 0, // 총 후기 평점 평균
        reviewPointGroup : [], // 리뷰 평점 별 비율
        reviewGalleries : [], // 리뷰 갤러리 리스트
        itemOptions : [], // 상품옵션 리스트
        stateProductReviewWrite : null, // 상품 후기 작성 관련 상태
        existTesterReviews : false, // 테스터 후기 존재 여부
        existOffShopReviews : false, // 매장후기 존재 여부
        reviewCountGroup : { // 후기 수 그룹
            'total' : 0,
            'photo' : 0,
            'offline' : 0
        },
        reviews : [], // 후기 리스트
        reviewLastPage : 0, // 후기 리스트 마지막 페이지
        isReviewPageLoading : false, // 후기 페이지 로딩 중 여부
    },

    getters : {
        itemId(state) { return state.itemId; },
        totalReviewCount(state) { return state.totalReviewCount; },
        totalReviewPointAverage(state) { return state.totalReviewPointAverage; },
        reviewPointGroup(state) { return state.reviewPointGroup; },
        reviewGalleries(state) { return state.reviewGalleries; },
        itemOptions(state) { return state.itemOptions; },
        stateProductReviewWrite(state) { return state.stateProductReviewWrite; },
        existTesterReviews(state) { return state.existTesterReviews; },
        existOffShopReviews(state) { return state.existOffShopReviews; },
        reviewCountGroup(state) { return state.reviewCountGroup; },
        reviews(state) { return state.reviews; },
        reviewLastPage(state) { return state.reviewLastPage; },
        isReviewPageLoading(state) { return state.isReviewPageLoading; },
    },

    mutations : {
        // SET 상품ID
        SET_ITEM_ID(state, itemId) {
            state.itemId = itemId;
        },

        // SET 후기 마스터 정보
        SET_REVIEW_MASTER(state, payload) {
            state.totalReviewCount = payload.totalReviewCount;
            state.totalReviewPointAverage = payload.totalReviewPoint;
            state.reviewGalleries = payload.galleries;
            state.itemOptions = payload.itemOptions;
            state.stateProductReviewWrite = payload.stateProductReviewWrite;
            state.existTesterReviews = payload.existTesterReviews;
            state.existOffShopReviews = payload.existOffShopReviews;

            function createPointGroup(point) {
                const groupCount = payload.totalReviewPointGroups[point.toString()];
                return {
                    'point' : point,
                    'percent' : state.totalReviewCount === 0 ? 0 : Math.round((groupCount*100)/state.totalReviewCount)
                }
            }

            for( let i=5 ; i>0 ; i-- ) {
                state.reviewPointGroup.push(createPointGroup(i));
            }
        },

        // SET 후기 그룹 카운트
        SET_REVIEW_COUNT_GROUP(state, payload) {
            state.reviewCountGroup = payload;
        },

        // SET 후기 리스트 마지막 페이지
        SET_REVIEW_LAST_PAGE(state, page) {
            state.reviewLastPage = page;
        },

        // SET 후기 리스트
        SET_REVIEWS(state, reviews) {
            state.reviews = reviews;
        },

        // ADD 후기 리스트
        ADD_REVIEWS(state, reviews) {
            state.reviews = state.reviews.concat(reviews);
        },

        //region UPDATE_REVIEW_REPORT_VALUES 후기 신고 값들 수정
        UPDATE_REVIEW_REPORT_VALUES(state, payload) {
            const review = state.reviews.find(r => r.index === payload.index);
            review.reportCount = payload.count;
            review.reportType = payload.type;
        },
        //endregion

        // SET 후기 페이지 로딩중 여부
        SET_REVIEW_PAGE_LOADING(state, payload) {
            state.isReviewPageLoading = payload;
        }
    },

    actions : {
        // GET 후기 마스터 정보
        GET_REVIEW_MASTER(context) {
            const uri = '/review/product/detail/' + context.getters.itemId;
            getFrontApiDataV2('GET', uri, null,
                function(data) {
                    context.commit('SET_REVIEW_MASTER', data);
                }
            );
        },
        // GET 후기 리스트
        GET_REVIEWS(context, sendData) {
            const uri = '/review/product/detail/reviews';
            sendData.itemId = context.getters.itemId;
            context.commit('SET_REVIEWS', []);
            context.commit('SET_REVIEW_PAGE_LOADING', true);

            getFrontApiDataV2('GET', uri, sendData,
                function(data) {
                    context.commit('SET_REVIEW_COUNT_GROUP', data.countGroup);
                    context.commit('SET_REVIEW_LAST_PAGE', data.lastPage);
                    context.commit('SET_REVIEWS', data.reviews);
                    context.commit('SET_REVIEW_PAGE_LOADING', false);
                }
            );
        },
        // GET 후기 리스트
        GET_MORE_REVIEWS(context, sendData) {
            context.commit('SET_REVIEW_PAGE_LOADING', true);

            const uri = '/review/product/detail/reviews';
            sendData.itemId = context.getters.itemId;

            getFrontApiDataV2('GET', uri, sendData,
                function(data) {
                    context.commit('ADD_REVIEWS', data.reviews);
                    context.commit('SET_REVIEW_PAGE_LOADING', false);
                }
            );
        }
    }
});