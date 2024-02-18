const store = new Vuex.Store({

    state : {
        parameter : { // 파라미터
            disp: 102, // 전시 카테고리 코드
            view_type: 'detail', // 뷰 타입
            sort_method: 'best', // 정렬
            page: 1, // 페이지
            deliType: [], // 배송/기타 - 꼼꼼하게 찾기
            makerIds: [], // 브랜드 - 꼼꼼하게 찾기
            minPrice: '', // 최저가
            maxPrice: '' // 최고가
        },

        categories : [], // 1Depth 카테고리 리스트
        categories2 : [], // 2Depth 카테고리 리스트

        productCount : 0, // 상품 결과 수
        products : [], // 상품 리스트

        lastPage : 1, // 마지막 페이지
        loadingComplete : false, // 로딩 끝났는지 여부

        filterBrands : [], // 필터 브랜드 리스트(검색 대상 브랜드리스트)
        filterMakerIds : [], // 필터 브랜드ID 리스트(현재 체크 중인 브랜드ID리스트)
        filterPrice : { // 필터 최저/최고 가격
            min : 0, max : 0
        },
    },

    getters : {
        parameter : function(state) { return state.parameter; },
        categories : function(state) { return state.categories; },
        categories2 : function(state) { return state.categories2; },
        productCount : function(state) { return state.productCount; },
        products : function(state) { return state.products; },
        lastPage : function(state) { return state.lastPage; },
        loadingComplete : function(state) { return state.loadingComplete; },
        filterBrands : function(state) { return state.filterBrands; },
        filterMakerIds : function(state) { return state.filterMakerIds; },
        filterPrice : function(state) { return state.filterPrice; },
    },

    mutations : {
        SET_PARAMETER(state, parameter) { state.parameter = parameter; }, // Set 파라미터
        SET_PRODUCT_COUNT(state, count) { state.productCount = count; }, // Set 상품 결과 수
        SET_LAST_PAGE(state, page) { state.lastPage = page; }, // Set 마지막 페이지
        SET_LOADING_COMPLETE(state, flag) { state.loadingComplete = flag; }, // Set 로딩 끝났는지 여부

        // Set 카테고리 리스트 (Depth1, 2)
        SET_CATEGORIES(state, payload) {
            payload.categories_depth1.forEach(c => {
                c.category_image = decodeBase64(c.category_image);
                state.categories.push(c);
            });

            state.categories2 = payload.categories_depth2;
        },

        // Set 상품 리스트
        SET_PRODUCTS(state, products) {
            state.products = [];

            if( products != null ) {
                for( let i=0 ; i<products.length ; i++ ) {
                    const product = products[i];

                    if( product.big_image != null )
                        product.big_image = decodeBase64(product.big_image);
                    if( product.list_image != null )
                        product.list_image = decodeBase64(product.list_image);
                    if( product.move_url != null )
                        product.move_url = decodeBase64(product.move_url);

                    state.products.push(product);
                }
            }
        },

        //Set 필터 브랜드 리스트
        SET_FILTER_BRANDS(state, brands) {
            state.filterBrands = [];
            if( brands != null ) {
                for( let i=0 ; i<brands.length ; i++ ) {
                    brands[i].is_checked = (
                        state.parameter.makerIds.indexOf(brands[i].brand_id) > -1
                        || state.filterMakerIds.indexOf(brands[i].brand_id) > -1);
                    state.filterBrands.push(brands[i]);
                }
            }
        },

        /**
         * SET 꼼꼼하게 찾기 최저/최고 가격
         */
        SET_FILTER_PRICE(state, price) {
            state.filterPrice.min = price.min_price;
            state.filterPrice.max = price.max_price;
        },

        /**
         * UPDATE 꼼꼼하게 찾기 브랜드ID 리스트
         */
        UPDATE_FILTER_MAKERIDS(state, parameter) {
            if( state.filterMakerIds.indexOf(parameter.brand_id) > -1 && !parameter.is_checked ) {
                state.filterMakerIds.splice(state.filterMakerIds.indexOf(parameter.brand_id), 1);
            } else if( state.filterMakerIds.indexOf(parameter.brand_id) < 0 && parameter.is_checked ) {
                state.filterMakerIds.push(parameter.brand_id);
            }
        },

        /**
         * 꼼꼼하게 찾기 추가한 브랜드ID 리스트 초기화
         */
        CLEAR_FILTER_MAKERIDS(state) {
            state.filterMakerIds = [];
        },
    },

    actions : {
        /**
         * GET 카테고리 리스트
         */
        GET_CATEGORIES(context, category_code) {
            const uri = '/b2b/mobile/categories';
            const api_data = {'category_code' : category_code.toString()};

            getFrontApiData('GET', uri, api_data, data => {
                context.commit('SET_CATEGORIES', data);
            });
        },

        /**
         * GET 상품 리스트
         */
        GET_PRODUCTS(context) {
            const parameter = context.getters.parameter;

            const uri = '/b2b/mobile/category/items';
            const api_data = {
                'catecode' : parameter.disp,
                'sortMethod' : parameter.sort_method,
                'page' : parameter.page,
                'deliType' : parameter.deliType.join(','),
                'makerIds' : parameter.makerIds.join(','),
                'minPrice' : parameter.minPrice,
                'maxPrice' : parameter.maxPrice
            }

            getFrontApiData('GET', uri, api_data, data => {
                console.log(data);
                context.commit('SET_PRODUCT_COUNT', data.total_count);
                context.commit('SET_PRODUCTS', data.items);
                context.commit('SET_LOADING_COMPLETE', true);
                context.commit('SET_LAST_PAGE', data.last_page);
            });
        },

        /**
         * GET 필터 조건
         * API 데이터 가져온 후
         * 현재 상품 중 브랜드 리스트, 최저가, 최고가 변경
         */
        GET_FILTER_CRITERIA : function (context) {
            const parameter = context.getters.parameter;

            const uri = '/b2b/mobile/filters';
            const api_data = {
                'dispCategories' : parameter.disp,
                'deliType' : parameter.deliType.join(','),
                'makerIds' : parameter.makerIds.join(','),
                'minPrice' : parameter.minPrice,
                'maxPrice' : parameter.maxPrice
            }

            getFrontApiData('GET', uri, api_data, data => {
                context.commit('SET_FILTER_BRANDS', data.brands);
                context.commit('SET_FILTER_PRICE', data);
            });
        },
    }

});

function decodeBase64(str) {
    if( str == null ) return null;
    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
}