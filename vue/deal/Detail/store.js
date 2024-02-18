const dealReviewStore = new Vuex.Store({
    state : {
        masterIdx : 0, // 딜 마스터 일련번호
        totalCount : 0, // 전체 후기 갯수
        reviewType : 'a', // 후기 구분(전체:a, 포토:p)
        dealProducts : [], // 딜 상품 리스트
        productReviewTypeCount : { // 상품 후기유형별 갯수
            total : 0,
            photo : 0,
        },
        reviews : [], // 후기 리스트
    },

    getters : {
        masterIdx(state) { return state.masterIdx; },
        totalCount(state) { return state.totalCount; },
        reviewType(state) { return state.reviewType; },
        dealProducts(state) { return state.dealProducts; },
        productReviewTypeCount(state) { return state.productReviewTypeCount; },
        reviews(state) { return state.reviews; },
    },

    mutations : {
        SET_MASTER_IDX(state, idx) { state.masterIdx = idx; },
        //region SET_DEAL_PRODUCTS 딜 상품 리스트 설정
        SET_DEAL_PRODUCTS(state, products) {
            state.totalCount = products.map(p => p.reviewCount).reduce((acc, cur) => acc + cur);
            document.getElementById('evalTotal').innerText =
                `(${state.totalCount.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g,'$1,')})`;

            const maxReviewCount = Math.max.apply(Math, products.map(p => p.reviewCount));
            const maxIndex = products.findIndex(p => p.reviewCount === maxReviewCount);
            products.forEach((p,index) => {
                p.number = index + 1;
                p.selected = index === maxIndex;
            });
            state.dealProducts = products;
        },
        //endregion
        //region CHANGE_SELECTED_PRODUCT 선택 상품 변경
        CHANGE_SELECTED_PRODUCT(state, itemId) {
            state.dealProducts.forEach(p => p.selected = p.itemId === itemId);
        },
        //endregion
        SET_REVIEWS(state, reviews) { state.reviews = reviews; },
        SET_REVIEW_TYPE(state, type) { state.reviewType = type; },
        //region SET_PRODUCT_REVIEW_TYPE_COUNT 상품 후기유형별 갯수 설정
        SET_PRODUCT_REVIEW_TYPE_COUNT(state, payload) {
            state.productReviewTypeCount.total = payload.total;
            state.productReviewTypeCount.photo = payload.photo;
        },
        //endregion
        //region SYNC_PRODUCT_REVIEW_COUNT 상품 후기 수 동기화
        SYNC_PRODUCT_REVIEW_COUNT(state, count) {
            const product = state.dealProducts.find(p => p.selected);
            if( product && product.reviewCount !== count ) {
                state.totalCount += count - product.reviewCount;
                product.reviewCount = count;
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
        //region GET_DEAL_PRODUCTS 딜 상품 리스트 조회
        GET_DEAL_PRODUCTS(context) {
            const uri = `/review/deal/${context.getters.masterIdx}/detail/products`;
            getFrontApiDataV2('GET', uri, null, data => {
                context.commit('SET_DEAL_PRODUCTS', data);
                context.dispatch('GET_REVIEWS');
            });
        },
        //endregion
        //region GET_REVIEWS 후기 리스트 조회
        GET_REVIEWS(context) {
            const uri = '/review/product/detail/reviews';
            const sendData = {
                itemId : context.getters.dealProducts.find(p => p.selected).itemId,
                reviewType : context.getters.reviewType,
                pageSize : 5
            };
            getFrontApiDataV2('GET', uri, sendData, data => {
                context.commit('SET_REVIEWS', data.reviews);
                context.commit('SET_PRODUCT_REVIEW_TYPE_COUNT', data.countGroup);
                context.commit('SYNC_PRODUCT_REVIEW_COUNT', data.countGroup.total);
            });
        },
        //endregion
    }
});