function decodeBase64(str) {
    if( str != null )
        return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
    else
        return '';
}

let store = new Vuex.Store({
    state : {
        parameter : { // 파라미터
            keyword : '', // 검색했던 키워드
            sort_method: 'rc', // 정렬
            view_type: 'detail', // 뷰타입(detail:일반, photo:사진만)
            deliType: [], // 배송/기타 - 꼼꼼하게 찾기
            dispCategories: [], // 카테고리 - 꼼꼼하게 찾기
            makerIds: [], // 브랜드 - 꼼꼼하게 찾기
            minPrice: '', // 최저가
            maxPrice: '', // 최고가
            correct_keyword : '', // 교정무시 키워드
        },
        recommend_keywords: [], // 연관검색어 키워드 리스트
        groups_count: { // 검색결과 그룹별 겸색결과 수
            total : 0, // 전체
            product : 0, // 상품
            review : 0, // 상품후기
            exhibition : 0, // 기획전
            event : 0, // 이벤트
            brand : 0 // 브랜드
        },
        quicklink: {}, // 키워드 퀵링크
        products: [], // 상품 리스트
        reviews: [], // 상품후기 리스트
        exhibitions: [], // 상품후기 리스트
        events: [], // 상품후기 리스트
        brands: [], // 브랜드 리스트
        alternative_keyword: '', // 대체 검색어
        pre_correct_keyword : '', // 교정 전 검색어
        correct_keyword : '', // 교정 검색어
        isSearched: false, // 검색 결과 불러왔는지 여부
        best_keywords: [], // 베스트 키워드 리스트
        best_products: [], // 베스트 상품 리스트
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
        parameter(state) { // 파라미터
            return state.parameter;
        },
        recommend_keywords(state) { // 연관검색어 키워드 리스트
            return state.recommend_keywords;
        },
        groups_count(state) { // 검색결과 그룹별 겸색결과 수
            return state.groups_count;
        },
        quicklink(state) { // 키워드 퀵링크
            return state.quicklink;
        },
        products(state) { // 상품 리스트
            return state.products;
        },
        reviews(state) { // 상품후기 리스트
            return state.reviews;
        },
        exhibitions(state) { // 기획전 리스트
            return state.exhibitions;
        },
        events(state) { // 이벤트 리스트
            return state.events;
        },
        brands(state) { // 브랜드 리스트
            return state.brands;
        },
        alternative_keyword(state) { // 대체 검색어
            return state.alternative_keyword;
        },
        ignore_correct_keyword(state) { return state.ignore_correct_keyword; }, // 무시 교정 키워드
        correct_keyword(state) { return state.correct_keyword; }, // 교정 후 키워드
        pre_correct_keyword(state) { return state.pre_correct_keyword; }, // 교정 전 키워드
        isSearched(state) { // 검색 결과 불러왔는지 여부
            return state.isSearched;
        },
        best_keywords(state) { // 베스트 키워드 리스트
            return state.best_keywords;
        },
        best_products(state) { // 베스트 상품 리스트
            return state.best_products;
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
        SET_PARAMETER(state, parameter) { // SET 검색했던 키워드
            state.parameter = parameter;
        },
        SET_RECOMMEND_KEYWORDS(state, keywords) { // SET 연관검색어 키워드 리스트
            state.recommend_keywords = [];

            if (keywords != null) {
                for( let i=0 ; i<keywords.length ; i++ ) {
                    state.recommend_keywords.push(keywords[i].keyword);
                }
            }
        },
        SET_SEARCH_RESULTS(state, results) { // SET 검색결과
            // 검색결과 그룹별 겸색결과 수
            state.groups_count = {
                total : results.groupsCount.total,
                product : results.groupsCount.product,
                review : results.groupsCount.review,
                exhibition : results.groupsCount.exhibition,
                event : results.groupsCount.event,
                brand : results.groupsCount.brand
            };

            state.correct_keyword = results.correctKeyword;
            state.pre_correct_keyword = results.orgKeyword;

            state.isSearched = true;

            // 키워드 퀵링크
            if( results.quickLink != null ) {
                let move_url;
                const link_value = results.quickLink.link_value;
                switch (results.quickLink.type) {
                    case 'category': move_url = '/category/category_main2020.asp?disp=' + link_value; break;
                    case 'search': move_url = '/search/search_result2020.asp?keyword=' + link_value; break;
                    case 'brand': move_url = '/brand/brand_detail2020.asp?brandid=' + link_value; break;
                    default: move_url = decodeBase64(results.quickLink.link_value);
                }
                state.quicklink = {
                    background_image : decodeBase64(results.quickLink.background_image),
                    main_copy : results.quickLink.main_copy,
                    move_url : move_url
                    , text_color : results.quickLink.text_color
                };
            }

            // 상품
            if( results.product.items != null ) {
                const items = results.product.items;
                for( let i=0 ; i<items.length ; i++ ) {
                    items[i].list_image = decodeBase64(items[i].list_image);
                    items[i].move_url = decodeBase64(items[i].move_url);
                }
                state.products = items;
            }

            // 상품 후기
            if( results.review.items != null ) {
                const items = results.review.items;
                for( let i=0 ; i<items.length ; i++ ) {
                    // decode
                    if( items[i].review_images != null ) { // 사용자 후기 이미지
                        for( let j=0 ; j<items[i].review_images.length ; j++ ) {
                            items[i].review_images[j] = decodeBase64(items[i].review_images[j]);
                        }
                    }
                    items[i].item_image = decodeBase64(items[i].item_image);
                    items[i].move_url = decodeBase64(items[i].move_url);
                }
                state.reviews = items;
            }

            // 기획전
            if( results.exhibition.items != null ) {
                const items = results.exhibition.items;
                for( let i=0 ; i<items.length ; i++ ) {
                    items[i].banner_img = decodeBase64(items[i].banner_img);
                    items[i].move_url = decodeBase64(items[i].move_url);
                }
                state.exhibitions = items;
            }

            // 이벤트
            if( results.event.items != null ) {
                const items = results.event.items;
                for( let i=0 ; i<items.length ; i++ ) {
                    items[i].banner_img = decodeBase64(items[i].banner_img);
                    items[i].move_url = decodeBase64(items[i].move_url);
                }
                state.events = items;
            }

            // 브랜드
            if( results.brand.items != null ) {
                const items = results.brand.items;
                for( let i=0 ; i<items.length ; i++ ) {
                    items[i].main_image = decodeBase64(items[i].main_image);
                    items[i].move_url = decodeBase64(items[i].move_url);
                }
                state.brands = items;
            }

            // 베스트 키워드 리스트 (※ 결과 없을 때만 Return)
            if( results.bestKeywords != null ) {
                const temp_best_keywords = [];
                for( let i=0 ; i<results.bestKeywords.length ; i++ ) {
                    temp_best_keywords.push(results.bestKeywords[i].keyword);
                }
                state.best_keywords = temp_best_keywords;
            }

            // 베스트 키워드 상품 리스트 (※ 결과 없을 때만 Return)
            if( results.bestProducts != null ) {
                const items = results.bestProducts;
                for( let i=0 ; i<items.length ; i++ ) {
                    items[i].item_image = decodeBase64(items[i].item_image);
                }
                state.best_products = items;
            }

            state.alternative_keyword = results.alternativeKeyword;
        },
        SET_BEST_PRODUCTS(state, items) { // SET 베스트 상품 리스트
            for( let i=0 ; i<items.length ; i++ ) {
                items[i].item_image = decodeBase64(items[i].item_image);
            }
            state.best_products = items;
        },
        SET_PRODUCT : function (state, data) { // SET 이 상품 후기 더보기 상품정보
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
            state.this_item_reviews = items;
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
        SET_THIS_ITEM_VIEW_TYPE : function (state, type) {
            state.this_item_view_type = type;
        },
        UPDATE_PRODUCT_WISH(state, payload) { // 상품 위시 변경
            let products;

            switch (payload.wish_type) {
                case 'product_results': products = state.products; break;
                case 'no_result_products': products = state.best_products; break;
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
        UPDATE_BRAND_WISH(state, payload) { // UPDATE 브랜드 위시
            for( let i=0 ; i<state.brands.length ; i++ ) {
                if( state.brands[i].brand_id === payload.brand_id ) {
                    state.brands[i].wish_yn = payload.on_flag;
                    return;
                }
            }
        },
        SET_IGNORE_CORRECT_KEYWORD(state, keyword) {
            state.ignore_correct_keyword = keyword;
        }
    },

    actions : {
        READ_RECOMMENDKEYWORDS(context) { // READ 연관검색어 리스트
            const recommend_keywords_apiurl = apiurl
                + '/search/recommendKeywords?keywords='
                + context.getters.parameter.keyword;

            $.ajax({
                type: "GET",
                url: recommend_keywords_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {

                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        READ_SEARCH_RESULTS(context) { // READ 검색결과
            const parameter = context.getters.parameter;

            let search_keywords_apiurl = apiurlv2
                + '/search/keywordSearch?keywords='
                + parameter.keyword;

            if( parameter.correct_keyword !== '' ) { // 교정무시 키워드
                search_keywords_apiurl += '&ignoreCorrectTypos=true&ignoreCorrectTyposKeyword=' + parameter.correct_keyword;
            }

            $.ajax({
                type: "GET",
                url: search_keywords_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log(data);
                    context.commit('SET_SEARCH_RESULTS', data);
                    context.commit('SET_RECOMMEND_KEYWORDS', data.recommendKeywords);

                    /* Criteo 전송 */
                    if( data.product.totalCount > 0 ) {
                        const product_id_arr = [];
                        data.product.items.slice(0, 3).forEach(item => {
                            product_id_arr.push(item.item_id.toString());
                        });
                        console.log(product_id_arr);

                        window.criteo_q = window.criteo_q || [];
                        var deviceType = /iPad/.test(navigator.userAgent) ? "t" : /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "m" : "d";
                        window.criteo_q.push(
                            { event: "setAccount", account: 8262}, // 이 라인은 업데이트하면 안됩니다
                            { event: "setEmail", email: criteo_user_mail_md5 }, // 유저가 로그인이 안되 있는 경우 빈 문자열을 전달
                            { event: "setSiteType", type: deviceType},
                            { event: "viewList", item: product_id_arr }); // 가장 위에있는 3개의 상품 ID를 전달
                    }
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        CHANGE_BEST_PRODUCTS(context, keyword) { // 베스트 키워드 상품 리스트 다시 불러오기
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
                    console.log(data);
                    context.commit('SET_BEST_PRODUCTS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_PRODUCT_AND_REVIEWS : function (context, item_id) { // GET 이 상품 후기 더보기 상품정보, 리뷰리스트 불러오기
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
                    console.log(data);
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
                    console.log(data);
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