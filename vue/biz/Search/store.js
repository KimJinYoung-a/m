const store = new Vuex.Store({
    state : {
        parameter: { // 파라미터
            keyword       : '', // 검색했던 키워드
            sort_method   : 'new', // 정렬
            deliType      : [], // 배송/기타 - 꼼꼼하게 찾기
            dispCategories: [], // 카테고리 - 꼼꼼하게 찾기
            makerIds      : [], // 브랜드 - 꼼꼼하게 찾기
            minPrice      : '', // 최저가
            maxPrice      : '', // 최고가
            page          : '1' // 페이지
        },

        productCount : 0, // 상품 갯수
        products : [], // 상품 리스트

        filterPrice : { min : 0, max : 0 }, // 필터 최저/최고 가격
        filterCategories : [], // 필터 카테고리 리스트
        filterBrands : [], // 필터 브랜드 리스트(검색 대상 브랜드 리스트)
        filterMakerIds : [], // 필터 브랜드 리스트(현재 체크 중인 브랜드ID 리스트)

        lastPage : 0, // 마지막 페이지
        loadingComplete : false, // 로딩 완료 여부
    },

    getters : {
        parameter(state) { return state.parameter; },
        productCount(state) { return state.productCount; },
        products(state) { return state.products; },
        filterPrice(state) { return state.filterPrice; },
        filterCategories(state) { return state.filterCategories; },
        filterBrands(state) { return state.filterBrands; },
        filterMakerIds(state) { return state.filterMakerIds; },
        lastPage(state) { return state.lastPage; },
        loadingComplete(state) { return state.loadingComplete; },
    },

    mutations : {
        // Set Parameter
        SET_PARAMETER(state, parameter) {
            state.parameter = parameter;
        },

        // Set ProductCount
        SET_PRODUCT_COUNT(state, count) {
            state.productCount = count;
        },

        // Set Products
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

        // Set Filters
        // - filterCategories, filterBrands, filterPrice
        SET_FILTERS(state, filters) {
            state.filterCategories = filters.categories;
            state.filterPrice.min = filters.min_price;
            state.filterPrice.max = filters.max_price;

            state.filterBrands = [];
            if( filters.brands != null ) {
                filters.brands.forEach(brand => {
                    brand.is_checked = (
                        state.parameter.makerIds.indexOf(brand.brand_id) > -1
                        || state.filterMakerIds.indexOf(brand.brand_id) > -1);
                    state.filterBrands.push(brand);
                });
            }
        },

        // Set LastPage
        SET_LAST_PAGE(state, page) {
            state.lastPage = page;
        },

        // Set LoadingComplete
        SET_LOADING_COMPLETE(state, flag) {
            state.loadingComplete = flag;
        },

        // Clear FilterMakerIds
        CLEAR_FILTER_MAKERIDS(state) {
            state.filterMakerIds = [];
        },

        // Update FilterMakerIds
        UPDATE_FILTER_MAKERIDS(state, parameter) {
            if( state.filterMakerIds.indexOf(parameter.brand_id) > -1 && !parameter.is_checked ) {
                state.filterMakerIds.splice(state.filterMakerIds.indexOf(parameter.brand_id), 1);
            } else if( state.filterMakerIds.indexOf(parameter.brand_id) < 0 && parameter.is_checked ) {
                state.filterMakerIds.push(parameter.brand_id);
            }
        },
    },

    actions : {
        // Get Products
        GET_PRODUCTS(context) {
            const parameter = context.getters.parameter;

            const uri = '/b2b/mobile/search';
            const api_data = {
                'keyword' : parameter.keyword,
                'sortMethod' : parameter.sort_method,
                'page' : parameter.page,
                'dispCategories' : parameter.dispCategories.join(','),
                'makerIds' : parameter.makerIds.join(','),
                'deliType' : parameter.deliType.join(','),
                'minPrice' : parameter.minPrice,
                'maxPrice' : parameter.maxPrice
            }

            getFrontApiData('GET', uri, api_data, data => {
                console.log(data);
                context.commit('SET_PRODUCTS', data.items);
                context.commit('SET_PRODUCT_COUNT', data.total_count);
                context.commit('SET_LAST_PAGE', data.last_page);
                context.commit('SET_LOADING_COMPLETE', true);
            });
        },

        // Get Filter Criteria
        GET_FILTER_CRITERIA(context) {
            const parameter = context.getters.parameter;

            const uri = '/b2b/mobile/filters';
            const api_data = {
                'keyword' : parameter.keyword,
                'sortMethod' : parameter.sort_method,
                'page' : parameter.page,
                'dispCategories' : parameter.dispCategories.join(','),
                'makerIds' : parameter.makerIds.join(','),
                'deliType' : parameter.deliType.join(','),
                'minPrice' : parameter.minPrice,
                'maxPrice' : parameter.maxPrice
            }

            getFrontApiData('GET', uri, api_data, data => {
                console.log(data);
                context.commit('SET_FILTERS', data);
            });
        }
    }
});

function decodeBase64(str) {
    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
}