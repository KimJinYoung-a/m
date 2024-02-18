const decodeBase64 = function(str) {
    if( str == null ) return null;
    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
}

let store = new Vuex.Store({
    state : {
        category_code : 0, // 카테고리
        sort_method : 'new', // 정렬
        min_price: '', // 검색 최저가
        max_price: '', // 검색 최고가
        categories: [], // 카테고리 리스트
        products : [], // 상품 리스트
        product_count : 0, // 상품 갯수
        product_min_price : 0, // 상품 리스트 중 최저 가격
        product_max_price : 0, // 상품 리스트 중 최저 가격
        current_page: 1, // 현재 페이지
        is_loading: false, // 로딩중 여부
        is_loading_complete: false, // 페이지 모두 로딩했는지 여부
        first_loading_complete : false // 처음 loading 종료 여부
    },
    getters : {
        category_code(state) { // 카테고리
            return state.category_code;
        },
        sort_method(state) { // 정렬
            return state.sort_method;
        },
        min_price(state) { // 검색 최저가
            return state.min_price;
        },
        max_price(state) { // 검색 최고가
            return state.max_price;
        },
        categories(state) { // 카테고리 리스트
            return state.categories;
        },
        products(state) { // 상품 리스트
            return state.products;
        },
        product_count(state) { // 상품 갯수
            return state.product_count;
        },
        product_min_price(state) { // 상품 리스트 중 최저 가격
            return state.product_min_price;
        },
        product_max_price(state) { // 상품 리스트 중 최저 가격
            return state.product_max_price;
        },
        current_page(state) { // 현재 페이지
            return state.current_page;
        },
        next_page(state) { // 다음 페이지
            return state.current_page + 1;
        },
        is_loading(state) { // 로딩중 여부
            return state.is_loading;
        },
        is_loading_complete(state) { // 페이지 모두 로딩했는지 여부
            return state.is_loading_complete;
        },
        first_loading_complete(state) { // 처음 loading 종료 여부
            return state.first_loading_complete;
        }
    },
    mutations : {
        SET_MIN_PRICE(state, price) { // SET 검색 최저 가격
            state.min_price = price;
        },
        SET_MAX_PRICE(state, price) { // SET 검색 최고 가격
            state.max_price = price;
        },
        SET_CATEGORY_CODE(state, category_code) { // SET 카테고리 코드
            state.category_code = category_code;
        },
        SET_CATEGORIES(state, categories) { // SET 카테고리 리스트
            const temp_categories = [{
                catecode: 0,
                catename: '전체'
            }];
            for( let i=0 ; i<categories.length ; i++ ) {
                if( categories[i].catecode !== '123' ) {
                    temp_categories.push({
                        catecode: Number(categories[i].catecode),
                        catename: categories[i].catename
                    });
                }
            }
            state.categories = temp_categories;
        },
        SET_PRODUCTS(state, items) { // SET 상품 리스트
            state.products = [];
            if( items != null ) {
                for( let i=0 ; i<items.length ; i++ ) {
                    if( items[i].big_image != null )
                        items[i].big_image = decodeBase64(items[i].big_image);
                    if( items[i].list_image != null )
                        items[i].list_image = decodeBase64(items[i].list_image);

                    items[i].move_url = decodeBase64(items[i].move_url);
                    state.products.push(items[i]);
                }
            }
        },
        SET_PRODUCT_COUNT(state, count) { // SET 상품 갯수
            state.product_count = count;
        },
        SET_FIRST_LOADING_COMPLETE(state, is_complete) { // SET 첫 페이지 로딩 종료 여부
            state.first_loading_complete = is_complete;
        },
        SET_PAGE(state, page) { // SET 페이지
            state.current_page = page;
        },
        SET_IS_LOADING(state, is_loading) { // SET 로딩중 여부
            state.is_loading = is_loading;
        },
        SET_IS_LOADING_COMPLETE(state, is_complete) { // SET 페이지 모두 로딩했는지 여부
            state.is_loading_complete = is_complete;
        },
        ADD_PRODUCTS(state, items) { // ADD 상품 리스트
            if( items != null ) {
                for( let i=0 ; i<items.length ; i++ ) {
                    if( items[i].big_image != null )
                        items[i].big_image = decodeBase64(items[i].big_image);
                    if( items[i].list_image != null )
                        items[i].list_image = decodeBase64(items[i].list_image);
                    items[i].move_url = decodeBase64(items[i].move_url);
                    state.products.push(items[i]);
                }
            }
        },
        SET_SORT_METHOD(state, sort_method) { // SET 정렬값
            state.sort_method = sort_method;
        },
        SET_PRODUCT_MIN_PRICE(state, price) { // SET 상품 리스트 중 최저 가격
            state.product_min_price = price;
        },
        SET_PRODUCT_MAX_PRICE(state, price) { // SET 상품 리스트 중 최고 가격
            state.product_max_price = price;
        },
        UPDATE_PRODUCT_WISH(state, payload) { // 상품 위시 변경
            for( let i=0 ; i<state.products.length ; i++ ) {
                if( Number(state.products[i].item_id) === Number(payload.item_id) ) {
                    state.products[i].wish_yn = payload.on_flag;
                    return;
                }
            }
        }
    },
    actions: {
        GET_CATEGORIES(context) { // GET 카테고리 리스트
            const categories_apiurl = apiurl + '/category/topDispCateList?appFlag=false';

            $.ajax({
                type: "GET",
                url: categories_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('GET_CATEGORIES\n', data);
                    context.commit('SET_CATEGORIES', data.categories);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_FIRST_PRODUCTS(context) { // GET 상품 리스트(첫 페이지)
            context.commit('SET_PAGE', 1);
            context.commit('SET_FIRST_LOADING_COMPLETE', false);
            context.commit('SET_IS_LOADING_COMPLETE', false);

            let products_apiurl = apiurl + '/clearance/Items?page_size=20'
                + '&page=1&sortMethod=' + context.getters.sort_method;
            if( context.getters.category_code !== 0 ) {
                products_apiurl += '&catecode=' + context.getters.category_code;
            }
            if( context.getters.min_price !== '' ) {
                products_apiurl += '&minPrice=' + context.getters.min_price;
            }
            if( context.getters.max_price !== '' ) {
                products_apiurl += '&maxPrice=' + context.getters.max_price;
            }

            $.ajax({
                type: "GET",
                url: products_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('GET_FIRST_PRODUCTS\n', data);
                    if( data.items == null ) {
                        context.commit('SET_IS_LOADING_COMPLETE', true);
                    }
                    context.commit('SET_PRODUCTS', data.items);
                    context.commit('SET_PRODUCT_COUNT', data.totalCount);
                    context.commit('SET_PRODUCT_MIN_PRICE', data.min_price);
                    context.commit('SET_PRODUCT_MAX_PRICE', data.max_price);
                    context.commit('SET_FIRST_LOADING_COMPLETE', true);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_NEXT_PRODUCTS(context) { // GET 다음페이지 상품 리스트
            context.commit('SET_PAGE', context.getters.current_page + 1);
            context.commit('SET_IS_LOADING', true);

            let products_apiurl = apiurl + '/clearance/Items?page_size=20'
                + '&page=' + context.getters.current_page
                + '&sortMethod=' + context.getters.sort_method;
            if( context.getters.category_code !== 0 ) {
                products_apiurl += '&catecode=' + context.getters.category_code;
            }
            if( context.getters.min_price !== '' ) {
                products_apiurl += '&minPrice=' + context.getters.min_price;
            }
            if( context.getters.max_price !== '' ) {
                products_apiurl += '&maxPrice=' + context.getters.max_price;
            }

            $.ajax({
                type: "GET",
                url: products_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('GET_NEXT_PRODUCTS\n', data);
                    if( data.items == null ) {
                        context.commit('SET_IS_LOADING_COMPLETE', true);
                    } else {
                        context.commit('ADD_PRODUCTS', data.items);
                    }
                    context.commit('SET_IS_LOADING', false);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
    }
});