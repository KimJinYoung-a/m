const decodeBase64 = function (str) {
    if (str == null) return null;
    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
}

const sendViewBrandDetailAmplitude = function(getters) {
    const filter_parameter = getters.filter_parameter;
    const amplitude_object = {
        'brand_id' : getters.brand_id,
        'list_type' : getters.view_type,
        'sort' : amplitudeSort(getters.sort_method),
        'filter_recommend' : amplitudeFilterRecommend(filter_parameter.deliType).join(','),
        'filter_category' : filter_parameter.dispCategories.join(','),
        'filter_delivery' : amplitudeFilterDelivery(filter_parameter.deliType).join(','),
        'filter_lowprice' : filter_parameter.minPrice,
        'filter_highprice' : filter_parameter.maxPrice,
        'paging_index' : getters.current_page
    };
    fnAmplitudeEventObjectAction('view_brand_list', amplitude_object);
}

const appierBrandView = function(getters){
    if(typeof qg !== "undefined"){
        let appier_brand_view = {
            "brand_id" : getters.brand_id
            , "brand_name" : getters.brand_info.brand_name_kr
            , "sort" : getters.sort_method
        };

        qg("event", "brand_view", appier_brand_view);
    }
}

let store = new Vuex.Store({
    state    : {
        brand_id           : '', // 브랜드 ID
        sort_method        : 'best', // 정렬조건
        view_type          : 'detail', // 뷰 타입
        filter_parameter   : { // 필터 파라미터
            dispCategories: [],
            deliType      : [],
            minPrice      : '',
            maxPrice      : ''
        },
        filter_criteria    : { // 필터 조건
            categories: [], // 카테고리 리스트
            max_price : 0, // 최고가
            min_price : 0 // 최저가
        },
        brand_info         : { // 브랜드 정보
            brand_name_en: '', // 브랜드명(EN)
            brand_name_kr: '', // 브랜드명(KR)
            brand_story  : '', // 브랜드 스토리
            brand_image  : '', // 브랜드 이미지
            wish_cnt     : 0, // 위시 수
            wish_yn      : false // 위시 여부
        },
        quick_link         : {}, // 퀵링크
        events             : [], // 이벤트 리스트
        product_count      : 0, // 상품 갯수
        products           : [], // 상품 리스트
        is_first_loaded    : false, // 첫 로딩 완료 여부
        is_loading         : false, // 페이지 로딩 중 여부
        is_loading_complete: false, // 페이지 로딩 종료 여부
        current_page       : 1, // 현재 페이지
    },
    getters  : {
        brand_id(state) { // 브랜드 ID
            return state.brand_id;
        },
        sort_method(state) { // 정렬조건
            return state.sort_method;
        },
        view_type(state) { // 뷰 타입
            return state.view_type;
        },
        filter_parameter(state) { // 필터 파라미터
            return state.filter_parameter;
        },
        filter_criteria(state) { // 필터 조건
            return state.filter_criteria;
        },
        brand_info(state) { // 브랜드 정보
            return state.brand_info;
        },
        quick_link(state) { // 퀵링크
            return state.quick_link;
        },
        events(state) { // 이벤트 리스트
            return state.events;
        },
        product_count(state) { // 상품 갯수
            return state.product_count;
        },
        products(state) { // 상품 리스트
            return state.products;
        },
        is_first_loaded(state) { // 첫 로딩 완료 여부
            return state.is_first_loaded;
        },
        is_filter_searched(state) { // 꼼꼼하게찾기 실행 여부
            return state.is_filter_searched;
        },
        is_loading(state) { // 페이지 로딩 중 여부
            return state.is_loading;
        },
        is_loading_complete(state) { // 페이지 로딩 종료 여부
            return state.is_loading_complete;
        },
        brand_api_url(state) { // 상품 리스트 조회 API 파라미터
            let parameter = '?brand_id=' + state.brand_id;
            if (state.filter_parameter.deliType.length > 0) {
                state.filter_parameter.deliType.forEach(d => {
                    parameter += '&deliType=' + d;
                });
            }
            if (state.filter_parameter.dispCategories.length > 0) {
                state.filter_parameter.dispCategories.forEach(c => {
                    parameter += '&dispCategories=' + c;
                });
            }
            if( state.filter_parameter.minPrice !== '' ) {
                parameter += '&minPrice=' + state.filter_parameter.minPrice;
            }
            if( state.filter_parameter.maxPrice !== '' ) {
                parameter += '&maxPrice=' + state.filter_parameter.maxPrice;
            }
            return parameter;
        },
        current_page(state) { // 현재 페이지
            return state.current_page;
        }
    },
    mutations: {
        SET_PARAMETER(state, parameter) { // SET 파라미터
            state.brand_id = parameter.brand_id;
            state.sort_method = parameter.sort_method;
            state.view_type = parameter.view_type;
            state.filter_parameter = { // 필터 파라미터
                deliType      : parameter.deliType,
                dispCategories: parameter.dispCategories,
                minPrice      : parameter.minPrice,
                maxPrice      : parameter.maxPrice
            }
        },
        SET_FILTER_CRITERIA(state, criteria) {
            state.filter_criteria = criteria;
        },
        SET_BRAND_INFO(state, data) { // SET 브랜드 정보
            const brand_info = state.brand_info;

            brand_info.brand_name_en = data.brand_name_en;
            brand_info.brand_name_kr = data.brand_name_kr;
            brand_info.brand_image = data.brand_image != null && data.brand_image !== '' ? decodeBase64(data.brand_image) : '';
            brand_info.brand_story = data.brand_story != null ? data.brand_story.replace(/\n/g, '<br>') : '';
            brand_info.wish_cnt = data.wish_cnt;
            brand_info.wish_yn = data.wish_yn;
        },
        SET_QUICK_LINK(state, quick_link) { // SET 퀵링크
            if( quick_link != null ) {
                let move_url;
                const link_value = quick_link.link_value;
                switch (quick_link.type) {
                    case 'category': move_url = '/category/category_list.asp?disp=' + link_value; break;
                    case 'search': move_url = '/search/search_result2020.asp?keyword=' + link_value; break;
                    case 'brand': move_url = '/brand/brand_detail2020.asp?brandid=' + link_value; break;
                    default: move_url = decodeBase64(quick_link.link_value);
                }
                state.quick_link = {
                    background_image : decodeBase64(quick_link.background_image),
                    move_url : move_url
                };
            }
        },
        SET_PRODUCT_COUNT(state, count) { // SET 상품 갯수
            state.product_count = count;
        },
        SET_EVENTS(state, events) { // SET 이벤트 리스트
            if( events != null ) {
                events.forEach(event => {
                    event.evt_name = event.evt_name.split('<br>').join('');
                    state.events.push(event);
                });
            }
        },
        SET_IS_FIRST_LOADED(state, loaded) { // SET 첫 로딩 완료 여부
            state.is_first_loaded = loaded;
        },
        SET_PRODUCTS(state, products) { // SET 상품 리스트
            state.products = [];
            if (products != null) {
                for (let i = 0; i < products.length; i++) {
                    const product = products[i];

                    if (product.big_image != null)
                        product.big_image = decodeBase64(product.big_image);
                    if (product.list_image != null)
                        product.list_image = decodeBase64(product.list_image);
                    if (product.move_url != null)
                        product.move_url = decodeBase64(product.move_url);

                    state.products.push(product);
                }
            }
        },
        ADD_PRODUCTS(state, products) { // ADD 상품 리스트
            if (products != null) {
                for (let i = 0; i < products.length; i++) {
                    const product = products[i];

                    if (product.big_image != null)
                        product.big_image = decodeBase64(product.big_image);
                    if (product.list_image != null)
                        product.list_image = decodeBase64(product.list_image);
                    if (product.move_url != null)
                        product.move_url = decodeBase64(product.move_url);

                    state.products.push(product);
                }
            }
        },
        SET_IS_LOADING(state, is_loading) { // SET 로딩 중 여부
            state.is_loading = is_loading;
        },
        SET_IS_LOADING_COMPLETE(state, is_complete) { // SET 페이지 로딩 종료 여부
            state.is_loading_complete = is_complete;
        },
        SET_CURRENCT_PAGE(state, page) { // SET 현재 페이지
            state.current_page = page;
        },
        UPDATE_BRAND_WISH(state, wish_yn) { // 브랜드 WISH 변경
            state.brand_info.wish_yn = wish_yn;
        },
        UPDATE_PRODUCT_WISH(state, payload) { // 상품 위시 변경
            for( let i=0 ; i<state.products.length ; i++ ) {
                if( Number(state.products[i].item_id) === Number(payload.item_id) ) {
                    state.products[i].wish_yn = payload.on_flag;
                    return;
                }
            }
        },
    },
    actions  : {
        GET_BRAND_INFO_AND_PRODUCTS(context) {
            let brand_api_url = apiurl + '/brand/detail' + context.getters.brand_api_url
                + '&sortMethod=' + context.getters.sort_method;

            $.ajax({
                type       : "GET",
                url        : brand_api_url,
                ContentType: "json",
                crossDomain: true,
                xhrFields  : {
                    withCredentials: true
                },
                success    : function (data) {
                    console.log('GET_BRAND_INFO_AND_PRODUCTS\n', data);
                    context.commit('SET_PRODUCT_COUNT', data.total_count);
                    context.commit('SET_BRAND_INFO', data);
                    context.commit('SET_QUICK_LINK', data.quick_link);
                    context.commit('SET_EVENTS', data.events);
                    context.commit('SET_PRODUCTS', data.products);
                    context.commit('SET_IS_FIRST_LOADED', true);

                    sendViewBrandDetailAmplitude(context.getters);
                    appierBrandView(context.getters);
                },
                error      : function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_PRODUCTS(context) {
            let brand_api_url = apiurl + '/brand/detail/products' + context.getters.brand_api_url
                + '&sortMethod=' + context.getters.sort_method
                + '&page=' + context.getters.current_page;

            $.ajax({
                type       : "GET",
                url        : brand_api_url,
                ContentType: "json",
                crossDomain: true,
                xhrFields  : {
                    withCredentials: true
                },
                success    : function (data) {
                    console.log('GET_PRODUCTS\n', data);
                    context.commit('ADD_PRODUCTS', data.products);
                    context.commit('SET_IS_LOADING', false);
                    if (data.products == null || data.products.length === 0) {
                        context.commit('SET_IS_LOADING_COMPLETE', true);
                    }

                    sendViewBrandDetailAmplitude(context.getters);
                },
                error      : function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_FILTER_CRITERIA(context) {
            let brand_api_url = apiurl + '/brand/detail/filters' + context.getters.brand_api_url;

            $.ajax({
                type       : "GET",
                url        : brand_api_url,
                ContentType: "json",
                crossDomain: true,
                xhrFields  : {
                    withCredentials: true
                },
                success    : function (data) {
                    console.log('GET_FILTER_CRITERIA\n', data);
                    context.commit('SET_FILTER_CRITERIA', data);
                },
                error      : function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
    }
});