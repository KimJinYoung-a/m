const decodeBase64 = function(str) {
    if( str == null ) return null;
    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
}

const sendViewCategoryAmplitude = function(getters) {
    const category_code = getters.this_category_info.category_code;
    const category_name = getters.this_category_info.category_name;
    const parameter = getters.parameter;

    const object = {
        'category_code' : category_code,
        'category_depth' : Math.round(category_code.toString().length/3),
        'category_name' : category_name,
        'list_type' : parameter.view_type,
        'sort' : amplitudeSort(parameter.sort_method),
        'filter_recommend' : amplitudeFilterRecommend(parameter.deliType).join(','),
        'filter_brand' : parameter.makerIds.join(','),
        'filter_delivery' : amplitudeFilterDelivery(parameter.deliType).join(','),
        'filter_lowprice' : parameter.minPrice,
        'filter_highprice' : parameter.maxPrice,
        'paging_index' : parameter.page
    };

    fnAmplitudeEventObjectAction('view_category_list', object);
}

const appierCategoryViewed = function(getters){
    if(typeof qg !== "undefined"){
        let appier_category_viewed = {
            "category_code" : getters.this_category_info.category_code
            , "category_name" : getters.this_category_info.category_name
            , "sort" : getters.parameter.sort_method
        };

        qg("event", "category_viewed", appier_category_viewed);
    }
}

const store = new Vuex.Store({
    state : {
        parameter : { // 파라미터
            disp: 101, // 전시 카테고리 코드
            view_type: 'detail', // 뷰 타입
            sort_method: 'new', // 정렬
            page: 1, // 페이지
            deliType: [], // 배송/기타 - 꼼꼼하게 찾기
            makerIds: [], // 브랜드 - 꼼꼼하게 찾기
            minPrice: '', // 최저가
            maxPrice: '' // 최고가
        },
        this_category_info : { // 현재 카테고리 정보
            category_code: 0, // 카테고리 코드
            category_name: '', // 카테고리 명
            low_categories: [] // 하위 카테고리 리스트
        },
        product_count : 0, // 총 상품 수
        products : [], // 상품 리스트
        last_page: 1, // 마지막 페이지
        first_loading_complete : false, // 첫 로딩 끝났는지 여부
        explorer_categories : [], // 카테고리 익스플로어

        // 검색 필터용 데이터
        kkomkkom_brands : [], // 꼼꼼하게 찾기 브랜드 리스트(검색 대상 브랜드리스트)
        kkomkkom_makerIds : [], // 꼼꼼하게 찾기 브랜드ID 리스트(현재 체크 중인 브랜드ID리스트)
        kkomkkom_price : { // 꼼꼼하게 찾기 최저/최고 가격
            min : 0,
            max : 0
        },
        page_kkomkkom_brand : 1, // 꼼꼼하게 찾기 브랜드 페이지
        last_page_kkomkkom_brand : 1, // 꼼꼼하게 찾기 브랜드 마지막 페이지
    },

    getters : {
        parameter : function(state) { return state.parameter; },
        this_category_info : function(state) { return state.this_category_info; },
        product_count : function(state) { return state.product_count; },
        products : function(state) { return state.products; },
        last_page : function(state) { return state.last_page; },
        first_loading_complete : function(state) { return state.first_loading_complete; },
        explorer_categories : function(state) { return state.explorer_categories; },
        kkomkkom_brands : function(state) { return state.kkomkkom_brands; },
        kkomkkom_makerIds : function(state) { return state.kkomkkom_makerIds; },
        kkomkkom_price : function(state) { return state.kkomkkom_price; },
        page_kkomkkom_brand : function(state) { return state.page_kkomkkom_brand; },
        last_page_kkomkkom_brand : function(state) { return state.last_page_kkomkkom_brand; },
    },

    mutations : {
        /**
         * 파라미터 SET
         */
        SET_PARAMETER(state, parameter) {
            state.parameter = parameter;
        },

        /**
         * SET 현재 카테고리 정보
         * 현재 카테고리의 코드, 이름, 하위 카테고리 리스트를 state에 set
         */
        SET_CATEGORY_INFO(state, category_info) {
            state.this_category_info.category_code = category_info.catecode;
            state.this_category_info.category_name = category_info.catename;
            state.this_category_info.low_categories = category_info.categories;
        },

        /**
         * SET 총 상품 수
         */
        SET_PRODUCT_COUNT(state, count) {
            state.product_count = count;
        },

        /**
         * SET 상품 리스트
         */
        SET_PRODUCTS : function (state, items) {
            state.products = [];

            if( items != null ) {
                for( let i=0 ; i<items.length ; i++ ) {
                    const product = items[i];

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

        /**
         * 상품 위시 변경
         */
        UPDATE_PRODUCT_WISH(state, payload) {
            for( let i=0 ; i<state.products.length ; i++ ) {
                if( Number(state.products[i].item_id) === Number(payload.item_id) ) {
                    state.products[i].wish_yn = payload.on_flag;
                    return;
                }
            }
        },

        /**
         * SET 마지막 페이지
         */
        SET_LAST_PAGE : function (state, page) {
            state.last_page = page;
        },

        /**
         * SET 첫 로딩 끝났는지 여부
         * 첫 페이지 로딩 ~ API데이터 가져오기까지 결과없음 컴포넌트가 보이지 않도록
         * API 데이터를 불러왔는지 체크함
         * 데이터를 불러온 이후에도 products가 비어있으면 결과없음 표시
         */
        SET_FIRST_LOADING_COMPLETE(state, is_loading) {
            state.first_loading_complete = is_loading;
        },

        /**
         * SET 필터 브랜드 리스트
         */
        SET_KKOMKKOM_BRANDS : function (state, brands) {
            state.kkomkkom_brands = [];
            if( brands != null ) {
                state.last_page_kkomkkom_brand = brands.last_page;
                if( brands.brands != null ) {
                    for( let i=0 ; i<brands.brands.length ; i++ ) {
                        brands.brands[i].is_checked = (
                            state.parameter.makerIds.indexOf(brands.brands[i].brand_id) > -1
                            || state.kkomkkom_makerIds.indexOf(brands.brands[i].brand_id) > -1);
                        state.kkomkkom_brands.push(brands.brands[i]);
                    }
                }
            }
        },

        /**
         * 필터 브랜드 리스트 add
         */
        ADD_KKOMKKOM_BRANDS(state, brands) {
            if( brands != null ) {
                for( let i=0 ; i<brands.length ; i++ ) {
                    brands[i].is_checked = (
                        state.parameter.makerIds.indexOf(brands[i].brand_id) > -1
                        || state.kkomkkom_makerIds.indexOf(brands[i].brand_id) > -1);
                    state.kkomkkom_brands.push(brands[i]);
                }
            }
        },

        /**
         * UPDATE 꼼꼼하게 찾기 브랜드ID 리스트
         */
        UPDATE_KKOMKKOM_MAKERIDS(state, parameter) {
            if( state.kkomkkom_makerIds.indexOf(parameter.brand_id) > -1 && !parameter.is_checked ) {
                state.kkomkkom_makerIds.splice(state.kkomkkom_makerIds.indexOf(parameter.brand_id), 1);
            } else if( state.kkomkkom_makerIds.indexOf(parameter.brand_id) < 0 && parameter.is_checked ) {
                state.kkomkkom_makerIds.push(parameter.brand_id);
            }
        },

        /**
         * 꼼꼼하게 찾기 추가한 브랜드ID 리스트 초기화
         */
        CLEAR_KKOMKKOM_MAKERIDS(state) {
            state.kkomkkom_makerIds = [];
        },

        /**
         * SET 꼼꼼하게 찾기 브랜드 페이지
         */
        SET_PAGE_KKOMKKOM_BRAND(state, page) {
            state.page_kkomkkom_brand = page;
        },

        /**
         * SET 꼼꼼하게 찾기 최저/최고 가격
         */
        SET_KKOMKKOM_PRICE(state, price) {
            state.kkomkkom_price.min = price.min_price;
            state.kkomkkom_price.max = price.max_price;
        },

        /**
         * 뷰 타입 변경
         */
        SET_VIEW_TYPE(state, type) {
            state.parameter.view_type = type;
        },

        /**
         * SET 카테고리 익스플로어 리스트
         */
        SET_EXPLORER_CATEGORIES(state, categories) {
            state.explorer_categories = categories;
        },
    },

    actions : {
        /**
         * GET 카테고리 정보
         * API 데이터 가져온 후 SET_CATEGORY_INFO 실행
         */
        GET_CATEGORY_INFO : function(context) {
            const uri = '/category/topDispCateList';
            const api_data = {
                'allFlag' : false,
                'catecode' : context.getters.parameter.disp
            };

            getFrontApiData('GET', uri, api_data, data => {
                // console.log('GET_CATEGORY_INFO', data);
                context.commit('SET_CATEGORY_INFO', data);

                appierCategoryViewed(context.getters);
            });
        },

        /**
         * GET 상품 리스트
         * API 데이터 가져온 후
         * 총 상품 수, 상품 리스트, 마지막페이지 변경
         * 로딩 종료 여부 true로 변경
         */
        GET_PRODUCTS : function (context) {
            const parameter = context.getters.parameter;

            const uri = '/category/items/search';
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
                // console.log('GET_PRODUCTS', data);
                context.commit('SET_PRODUCT_COUNT', data.total_count);
                context.commit('SET_PRODUCTS', data.items);
                context.commit('SET_LAST_PAGE', data.last_page);
                context.commit('SET_FIRST_LOADING_COMPLETE', true);

                // view_category_list Amplitude 전송
                sendViewCategoryAmplitude(context.getters);

                // Criteo 상위 3개 상품ID 전송
                if( data.items != null ) {
                    const product_id_arr = [];
                    data.items.slice(0, 3).forEach(item => {
                        product_id_arr.push(item.item_id.toString());
                    });
                    // console.log(product_id_arr);

                    window.criteo_q = window.criteo_q || [];
                    var deviceType = /iPad/.test(navigator.userAgent) ? "t" : /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "m" : "d";
                    window.criteo_q.push(
                        { event: "setAccount", account: 8262}, // 이 라인은 업데이트하면 안됩니다
                        { event: "setEmail", email: criteo_user_mail_md5 }, // 유저가 로그인이 안되 있는 경우 빈 문자열을 전달
                        { event: "setSiteType", type: deviceType},
                        { event: "viewList", item: product_id_arr }); // 가장 위에있는 3개의 상품 ID를 전달
                }
            });
        },

        /**
         * GET 필터 조건
         * API 데이터 가져온 후
         * 현재 상품 중 브랜드 리스트, 최저가, 최고가 변경
         */
        GET_KKOMKKOM_CRITERIA : function (context) {
            const parameter = context.getters.parameter;

            const uri = '/search/kkomkkom';
            const api_data = {
                'dispCategories' : parameter.disp,
                'deliType' : parameter.deliType.join(','),
                'makerIds' : parameter.makerIds.join(','),
                'minPrice' : parameter.minPrice,
                'maxPrice' : parameter.maxPrice
            }

            getFrontApiData('GET', uri, api_data, data => {
                // console.log('GET_KKOMKKOM_CRITERIA', data);
                context.commit('SET_KKOMKKOM_BRANDS', data.brands);
                context.commit('SET_KKOMKKOM_PRICE', data);
            });
        },

        /**
         * GET 필터 브랜드 리스트 with keyword, page
         */
        GET_MORE_KKOMKKOM_BRANDS(context, brand_name_keyword) { // 꼼꼼하게 찾기 브랜드 더 불러오기
            if( context.getters.last_page_kkomkkom_brand <= context.getters.page_kkomkkom_brand ) // 마지막 페이지면 return
                return false;

            const next_page = context.getters.page_kkomkkom_brand + 1;
            context.commit('SET_PAGE_KKOMKKOM_BRAND', next_page);

            const uri = '/search/kkomkkom/brands';
            const api_data = {
                'dispCategories' : context.getters.parameter.disp,
                'page' : next_page
            };
            if( brand_name_keyword !== '' ) {
                api_data.brand_name_keyword = brand_name_keyword;
            }

            getFrontApiData('GET', uri, api_data, data => {
                // console.log('GET_MORE_KKOMKKOM_BRANDS', data);
                context.commit('ADD_KKOMKKOM_BRANDS', data.brands);
            });
        },

        /**
         * GET 카테고리 익스플로어 리스트
         */
        GET_EXPLORER_CATEGORIES(context) {
            const uri = '/category/explorer/' + context.getters.parameter.disp;
            getFrontApiData('GET', uri, null, data => {
                // console.log('GET_EXPLORER_CATEGORIES', data);
                context.commit('SET_EXPLORER_CATEGORIES', data.explorer);
            });
        }
    }
});
