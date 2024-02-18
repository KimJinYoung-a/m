const decodeBase64 = function(str) {
    if( str == null ) return null;
    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
}

let store = new Vuex.Store({
    state : {
        period : 'D', // 기간별 유형(D:일간,W:주간,M:월간)
        categories : [{ // 카테고리 리스트
            catecode : 0,
            catename : '전체'
        }],
        period_products : [], // 기간별 베스트 상품 리스트
        period_category : 0, // 기간별 베스트 활성화된 카테고리 코드
        best_keywords : [], // 인기 검색어 리스트
        best_keyword_products : [], // 인기 검색어 상품 리스트
        active_best_keyword : '', // 활성화된 인기 검색어
        steady_products : [], // 스테디셀러 상품 리스트
        brand_category : 0, // 베스트 브랜드 활성화된 카테고리 코드
        best_brands : [], // 베스트 브랜드 리스트
        wish_products : [], // 베스트 위시 상품 리스트
        best_reviews : [], // 베스트 후기 리스트
        this_item_view_type : 'detail', // 이 상품 후기 더보기 팝업 뷰 타입
        product : { // 이 상품 후기 더보기 팝업 상품 정보
            item_id : 0, // 상품ID
            item_name : '', // 상품명
            item_price : 0, // 상품 가격
            sale_percent : 0, // 세일 퍼센트
            sale_yn : false, // 세일여부
            item_coupon_yn : false, // 쿠폰여부
            item_coupon_value : 0, // 쿠폰 값
            item_coupon_type : '1', // 쿠폰구분값
            item_image : '', // 상품 이미지
            wish_yn : false, // 위시 여부
            sell_flag : 'Y' // 판매 상태
        },
        this_item_reviews : [], // 이 상품 후기 더보기 팝업 후기 리스트
        this_item_review_count : 0, // 이 상품 후기 더보기 팝업 후기 갯수
        this_item_current_page : 1, // 이 상품 후기 더보기 팝업 현재 페이지
        is_loading_this_item_page : false, // 이 상품 후기 더보기 팝업 페이지 로딩중 여부
        is_end_this_item_page : false, // 이 상품 후기 더보기 팝업 페이지 종료 여부
    },
    getters : {
        period(state) { // 기간
            return state.period;
        },
        categories(state) { // 기간별 베스트 카테고리 리스트
            return state.categories;
        },
        period_products(state) { // 기간별 베스트 상품 리스트
            return state.period_products;
        },
        period_category(state) { // 기간별 베스트 활성화된 카테고리 코드
            return state.period_category;
        },
        best_keywords(state) { // 인기 검색어 리스트
            return state.best_keywords;
        },
        best_keyword_products(state) { // 인기 검색어 상품 리스트
            return state.best_keyword_products;
        },
        active_best_keyword(state) { // 활성화된 인기 검색어
            return state.active_best_keyword;
        },
        steady_products(state) { // 스테디셀러 상품 리스트
            return state.steady_products;
        },
        brand_category(state) { // 베스트 브랜드 활성화된 카테고리 코드
            return state.brand_category;
        },
        best_brands(state) { // 베스트 브랜드 리스트
            return state.best_brands;
        },
        wish_products(state) { // 베스트 위시 상품 리스트
            return state.wish_products;
        },
        best_reviews(state) { // 베스트 후기 리스트
            return state.best_reviews;
        },
        this_item_view_type(state) { // 이 상품 후기 더보기 팝업 뷰 타입
            return state.this_item_view_type;
        },
        product(state) { // 이 상품 후기 더보기 팝업 상품 정보
            return state.product;
        },
        this_item_reviews(state) { // 이 상품 후기 더보기 팝업 후기 리스트
            return state.this_item_reviews;
        },
        this_item_review_count(state) { // 이 상품 후기 더보기 팝업 후기 갯수
            return state.this_item_review_count;
        },
        this_item_current_page(state) { // 이 상품 후기 더보기 팝업 현재 페이지
            return state.this_item_current_page;
        },
        is_loading_this_item_page(state) { // 이 상품 후기 더보기 팝업 페이지 로딩중 여부
            return state.is_loading_this_item_page;
        },
        is_end_this_item_page(state) { // 이 상품 후기 더보기 팝업 페이지 종료 여부
            return state.is_end_this_item_page;
        }
    },
    mutations : {
        SET_PERIOD(state, period) { // SET 기간
            state.period = period;
        },
        SET_CATEGORIES(state, categories) { // SET 카테고리 리스트
            for( let i=0 ; i<categories.length ; i++ ) {
                if( categories[i].catecode !== '123' ) {
                    state.categories.push({
                        catecode: Number(categories[i].catecode),
                        catename: categories[i].catename
                    });
                }
            }
        },
        SET_PERIOD_PRODUCTS(state, items) { // SET 기간별 베스트 상품 리스트
            let temp_period_products = [];
            for( let key in items ) {
                items[key].big_image = decodeBase64(items[key].big_image);
                temp_period_products.push(items[key]);
            }
            state.period_products = temp_period_products;
        },
        SET_PERIOD_CATEGORY(state, catecode) { // SET 기간별 베스트 활성화된 카테고리 코드
            state.period_category = catecode;
        },
        SET_BEST_KEYWORDS(state, keywords) { // SET 인기 검색어 리스트
            let temp_best_keywords = [];
            let maxIdx = keywords.length > 8 ? 8 : keywords.length;
            for( let i=0 ; i<maxIdx ; i++ ) {
                temp_best_keywords.push({
                    text: keywords[i],
                    value: keywords[i],
                    is_active: i === 0,
                });
            }
            state.best_keywords = temp_best_keywords;
        },
        SET_BEST_KEYWORD_PRODUCTS(state, items) { // SET 인기 검색어 상품 리스트
            let temp_best_keyword_products = [];
            for( let i=0 ; i<items.length ; i++ ) {
                if( items[i].item_image != null )
                    items[i].item_image = decodeBase64(items[i].item_image);

                temp_best_keyword_products.push(items[i]);
            }
            state.best_keyword_products = temp_best_keyword_products;
        },
        SET_ACTIVE_BEST_KEYWORD(state, keyword) { // SET 활성화 인기 키워드
            state.active_best_keyword = keyword;
        },
        SET_STEADY_PRODUCTS(state, items) { // SET 스테디셀러 상품 리스트
            let temp_steady_products = [];
            if( items != null ) {
                for( let i=0 ; i<items.length ; i++ ) {
                    if( items[i].big_image != null )
                        items[i].big_image = decodeBase64(items[i].big_image);

                    temp_steady_products.push(items[i]);
                }
                state.steady_products = temp_steady_products;
            }
        },
        SET_BEST_BRANDS(state, brands) { // SET 베스트 브랜드 리스트
            let temp_best_brands = [];
            for( let i=0 ; i<brands.length ; i++ ) {
                if( brands[i].products != null ) {
                    for( let j=0 ; j<brands[i].products.length ; j++ ) {
                        brands[i].products[j].item_image = decodeBase64(brands[i].products[j].item_image);
                    }
                }
                temp_best_brands.push(brands[i]);
            }
            state.best_brands = temp_best_brands;
        },
        SET_BRAND_CATEGORY(state, catecode) { // SET 베스트 브랜드 활성화된 카테고리 코드
            state.brand_category = catecode;
        },
        SET_WISH_PRODUCTS(state, items) { // SET 베스트위시 상품 리스트
            let temp_wish_products = [];
            for( let i=0 ; i<items.length ; i++ ) {
                if( items[i].big_image != null )
                    items[i].big_image = decodeBase64(items[i].big_image);

                temp_wish_products.push(items[i]);
            }
            state.wish_products = temp_wish_products;
        },
        SET_BEST_REVIEWS(state, reviews) { // SET 베스트 리뷰 리스트
            if( reviews != null && reviews.length > 0 ) {
                let temp_best_reviews = [];
                for( let i=0 ; i<reviews.length ; i++ ) {
                    if( reviews[i].item_image != null )
                        reviews[i].item_image = decodeBase64(reviews[i].item_image);

                    if( reviews[i].user_file != null )
                        reviews[i].review_images = [decodeBase64(reviews[i].user_file)];

                    reviews[i].total_point = reviews[i].rating;
                    reviews[i].sell_yn = 'Y';

                    temp_best_reviews.push(reviews[i]);
                }
                state.best_reviews = temp_best_reviews;
            }
        },
        SET_PRODUCT : function (state, data) { // SET 상품정보
            state.product.item_id = data.item_id;
            state.product.item_name = data.item_name;
            state.product.item_price = data.item_price;
            state.product.sale_percent = data.sale_percent;
            state.product.sale_yn = data.sale_yn;
            state.product.item_coupon_yn = data.item_coupon_yn;
            state.product.item_coupon_value = data.item_coupon_value;
            state.product.item_coupon_type = data.item_coupon_type;
            state.product.item_image = decodeBase64(data.item_image);
            state.product.wish_yn = data.wish_yn;
            state.product.sell_flag = data.sell_flag;
        },
        SET_THIS_ITEM_REVIEWS : function (state, items) { // SET 리뷰 리스트
            console.log(items);
            for( let i=0 ; i<items.length ; i++ ) {
                if( items[i].item_image != null )
                    items[i].item_image = decodeBase64(items[i].item_image);

                if( items[i].review_images != null ) {
                    for( let j=0 ; j<items[i].review_images.length ; j++ ) {
                        items[i].review_images[j] = decodeBase64(items[i].review_images[j]);
                    }
                }

                if( items[i].move_url != null )
                    items[i].move_url = decodeBase64(items[i].move_url);
            }
            console.log(items);
            state.this_item_reviews = items;
            console.log(state.this_item_reviews);
        },
        SET_THIS_ITEM_REVIEW_COUNT : function(state, count) { // SET 리뷰 갯수
            state.this_item_review_count = count;
        },
        CLEAR_THIS_ITEM_DATA : function (state) { // 기존 불러와져있던 이상품후기더보기 정보 clear
            state.product = {
                item_id : 0,
                item_name : '',
                item_price : 0,
                sale_percent : 0,
                sale_yn : false,
                item_coupon_yn : false,
                item_coupon_value : 0,
                item_coupon_type : '1',
                item_image : '',
                wish_yn : false,
                sell_flag : 'Y'
            };
            state.this_item_reviews = [];
            state.this_item_review_count = 0;
            state.this_item_view_type = 'detail';
            state.this_item_current_page = 1;
            state.is_loading_this_item_page = false;
            state.is_end_this_item_page = false;
        },
        SET_THIS_ITEM_CURRENT_PAGE : function(state, page) { // 이 상품 후기 더보기 현재 페이지 변경
            console.log(page);
            state.this_item_current_page = page;
        },
        ADD_THIS_ITEM_REVIEWS : function(state, items) { // ADD 이 상품 후기 더보기 후기 리스트
            for( let i=0 ; i<items.length ; i++ ) {
                if( items[i].item_image != null )
                    items[i].item_image = decodeBase64(items[i].item_image);

                if( items[i].review_images != null ) {
                    for( let j=0 ; j<items[i].review_images.length ; j++ ) {
                        items[i].review_images[j] = decodeBase64(items[i].review_images[j]);
                    }
                }

                if( items[i].move_url != null )
                    items[i].move_url = decodeBase64(items[i].move_url);

                state.this_item_reviews.push(items[i]);
            }
            state.is_loading_this_item_page = false;
        },
        SET_IS_LOADING_THIS_ITEM_PAGE : function (state, is_loading) { // SET 이 상품 후기 더보기 후기 페이지 로딩중 여부
            state.is_loading_this_item_page = is_loading;
        },
        SET_IS_END_THIS_ITEM_PAGE : function (state, is_end) { // SET 이 상품 후기 더보기 후기 페이지 종료 여부
            state.is_end_this_item_page = is_end;
        },
        SET_THIS_ITEM_VIEW_TYPE : function (state, type) { // SET 이 상품 후기 더보기 뷰 타입
            state.this_item_view_type = type;
        },
        UPDATE_PRODUCT_WISH(state, payload) { // 상품 위시 변경
            let products;

            switch (payload.wish_type) {
                case 'period': products = state.period_products; break;
                case 'steady': products = state.steady_products; break;
                case 'keyword': products = state.best_keyword_products; break;
                case 'wish': products = state.wish_products; break;
                default : products = [];
            }

            for( let i=0 ; i<products.length ; i++ ) {
                if( Number(products[i].item_id) === Number(payload.item_id) ) {
                    products[i].wish_yn = payload.on_flag;
                    return;
                }
            }
        },
        UPDATE_REVIEW_PRODUCT_WISH(state, flag) { // UPDATE 이상품 후기 더보기 상품 위시
            state.product.wish_yn = flag;
        },
        UPDATE_BRAND_WISH(state, payload) { // UPDATE 요즘 많이 찾는 브랜드 위시
            for( let i=0 ; i<state.best_brands.length ; i++ ) {
                if( state.best_brands[i].brand_id === payload.brand_id ) {
                    state.best_brands[i].wish_yn = payload.on_flag;
                    return;
                }
            }
        }
    },
    actions : {
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
                    context.commit('SET_CATEGORIES', data.categories);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_PERIOD_PRODUCTS(context) { // GET 기간별 베스트 상품 리스트
            let period_products_apiurl;
            if( apiurl === '//fapi.10x10.co.kr/api/web/v1' ) {
                period_products_apiurl = apiurl + '/best/period'
                    + '?period_type=' + context.getters.period;
            } else { // 개발DB, 검색엔진에는 베스트상품이 없어서 임시 api 이용
                period_products_apiurl = apiurl + '/best/period2'
                    + '?period_type=' + context.getters.period;
            }

            if( context.getters.period_category !== 0 )
                period_products_apiurl += '&catecode=' + context.getters.period_category;

            $.ajax({
                type: "GET",
                url: period_products_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    context.commit('SET_PERIOD_PRODUCTS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_BEST_KEYWORDS(context) { // GET 인기 검색어 리스트
            const best_keywords_apiurl = apiurl + '/best/keyword/list';
            $.ajax({
                type: "GET",
                url: best_keywords_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    context.commit('SET_BEST_KEYWORDS', data.keywords);
                    context.commit('SET_ACTIVE_BEST_KEYWORD', data.keywords[0]);
                    context.dispatch('GET_BEST_KEYWORD_PRODUCTS', data.keywords[0]);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_BEST_KEYWORD_PRODUCTS(context, keyword) { // GET 인기 키워드 상품 리스트
            const best_products_apiurl = apiurl + '/best/keyword?keyword=' + keyword;
            $.ajax({
                type: "GET",
                url: best_products_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    context.commit('SET_BEST_KEYWORD_PRODUCTS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_STEADY_PRODUCTS(context) { // GET 스테디셀러 상품 리스트
            const steady_products_apiurl = apiurl + '/best/steady';
            $.ajax({
                type: "GET",
                url: steady_products_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log(data);
                    context.commit('SET_STEADY_PRODUCTS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_BEST_BRANDS(context, catecode) { // GET 베스트 브랜드
            let best_brand_apiurl = apiurl + '/best/brands';

            if( catecode !== 0 )
                best_brand_apiurl += '?catecode=' + catecode;

            $.ajax({
                type: "GET",
                url: best_brand_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    context.commit('SET_BEST_BRANDS', data.brands);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_WISH_PRODUCTS(context) { // GET 베스트위시 상품 리스트
            const wish_products_apiurl = apiurl + '/best/wish';
            $.ajax({
                type: "GET",
                url: wish_products_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    context.commit('SET_WISH_PRODUCTS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_BEST_REVIEWS(context) {
            let best_review_apiurl = apiurl + '/best/reviews';

            $.ajax({
                type: "GET",
                url: best_review_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    context.commit('SET_BEST_REVIEWS', data.reviews);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_PRODUCT_AND_REVIEWS : function (context, item_id) { // 상품정보, 리뷰리스트 불러오기
            const search_reviews_apiurl = apiurl
                + '/search/itemEvalSearch?itemid=' + item_id;

            $.ajax({
                type: "GET",
                url: search_reviews_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    context.commit('SET_PRODUCT', data); // SET 상품정보
                    context.commit('SET_THIS_ITEM_REVIEW_COUNT', data.totalCount); // SET 리뷰 갯수
                    context.commit('SET_THIS_ITEM_REVIEWS', data.items); // SET 리뷰 리스트

                    if( data.last_page === context.getters.this_item_current_page ) { // 마지막 페이지
                        context.commit('SET_IS_END_THIS_ITEM_PAGE', true);
                    }
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_MORE_THIS_ITEM_REVIEWS(context, item_id) { // 이 상품 후기 더보기 후기 리스트 더 불러오기
            const search_reviews_apiurl = apiurl + '/search/itemEvalSearch'
                + '?itemid=' + item_id
                + '&page=' + context.getters.this_item_current_page;

            $.ajax({
                type: "GET",
                url: search_reviews_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    context.commit('ADD_THIS_ITEM_REVIEWS', data.items); // SET 리뷰 리스트

                    if( data.last_page === context.getters.this_item_current_page ) { // 마지막 페이지
                        context.commit('SET_IS_END_THIS_ITEM_PAGE', true);
                    }
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
    }
});