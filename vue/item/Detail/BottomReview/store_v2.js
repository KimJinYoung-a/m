const bottomReviewStore = new Vuex.Store({
    state : {
        itemId : 0, // 상품ID
        totalReviewCount : 0, // 총 후기 수
        totalReviewPointAverage : 0, // 총 후기 평점 평균
        reviewPointGroup : [], // 리뷰 평점 별 비율
        reviews : [], // 후기 리스트
        stateProductReviewWrite : {}, // 상품 후기 작성 관련 상태
        existTesterReviews : false, // 테스터 후기 존재 여부
    },

    getters : {
        itemId(state) { return state.itemId; },
        totalReviewCount(state) { return state.totalReviewCount; },
        totalReviewPointAverage(state) { return state.totalReviewPointAverage; },
        reviewPointGroup(state) { return state.reviewPointGroup; },
        reviews(state) { return state.reviews; },
        stateProductReviewWrite(state) { return state.stateProductReviewWrite; },
        existTesterReviews(state) { return state.existTesterReviews; },
    },

    mutations : {
        SET_ITEM_ID(state, itemId) { state.itemId = Number(itemId); },
        SET_REVIEWS(state, reviews) { state.reviews = reviews; },
        //region SET_REVIEW_MASTER 후기 마스터 정보 등록
        SET_REVIEW_MASTER(state, payload) {
            state.totalReviewCount = payload.totalReviewCount;
            state.totalReviewPointAverage = payload.totalReviewPoint;
            state.stateProductReviewWrite = payload.stateProductReviewWrite;
            state.existTesterReviews = payload.existTesterReviews;

            function createPointGroup(point) {
                const groupCount = payload.totalReviewPointGroups[point.toString()];
                return {
                    'point' : point,
                    'percent' : state.totalReviewCount === 0 ? 0 : Math.round((groupCount*100)/state.totalReviewCount)
                }
            }

            state.reviewPointGroup = [];
            for( let i=5 ; i>0 ; i-- ) {
                state.reviewPointGroup.push(createPointGroup(i));
            }
        },
        //endregion
        //region UPDATE_REVIEW_REPORT_VALUES 후기 신고 값들 수정
        UPDATE_REVIEW_REPORT_VALUES(state, payload) {
            const review = state.reviews.find(r => r.index === payload.index);
            review.reportCount = payload.count;
            review.reportType = payload.type;
        },
        //endregion
    },

    actions : {
        //region GET_REVIEW_MASTER 후기 마스터 정보 조회
        GET_REVIEW_MASTER(context) {
            const uri = '/review/product/detail/' + context.getters.itemId;
            getFrontApiDataV2('GET', uri, null,
                function(data) {
                    context.commit('SET_REVIEW_MASTER', data);
                }
            );
        },
        //endregion
        //region GET_REVIEWS 후기 리스트 조회
        GET_REVIEWS(context) {
            const uri = '/review/product/detail/reviews';
            const sendData = {
                itemId : context.getters.itemId,
                pageSize : 3
            };

            getFrontApiDataV2('GET', uri, sendData,
                function(data) {
                    context.commit('SET_REVIEWS', data.reviews);
                }
            );
        },
        //endregion
    }
});