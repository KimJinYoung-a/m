function decodeBase64(str) {
    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
}

let store = new Vuex.Store({
    state : {
        parameter: { // 파라미터
            keyword       : '', // 검색했던 키워드
            view_type     : 'detail', // 뷰타입(detail:일반, photo:사진만)
            sort_method   : 'new', // 정렬
            deliType      : [], // 배송/기타 - 꼼꼼하게 찾기
            dispCategories: [], // 카테고리 - 꼼꼼하게 찾기
            makerIds      : [], // 브랜드 - 꼼꼼하게 찾기
            minPrice      : '', // 최저가
            maxPrice      : '', // 최고가
            page          : '1', // 페이지
            correct_keyword : '', // 교정무시 키워드
        },
        last_page : 1, // 마지막 페이지
        is_loading_complete : false, // 로딩 완료 여부

        alternative_keyword : '', // 대체 키워드
        pre_correct_keyword : '', // 교정 전 검색어
        correct_keyword : '', // 교정 검색어
        recommend_keywords: [], // 추천(연관) 검색어 리스트
        best_keywords : [], // 베스트 키워드 리스트

        product_count : 0, // 상품 결과 수
        groups_count: { // 그룹별 겸색결과 수
            total : 0, // 전체
            product : 0, // 상품
            review : 0, // 상품후기
            exhibition : 0, // 기획전
            event : 0, // 이벤트
            brand : 0 // 브랜드
        },

        products : [], // 상품 리스트
        best_products : [], // 베스트 상품 리스트
        helper: { // 헬퍼
            best_seller: {},
            best_popularity: {},
            best_rating: {},
            md_recommend: {}
        },
        quicklink: { // 퀵링크
            background_image : '',
            main_copy : '',
            move_url : ''
            , text_color: ''
        },

        kkomkkom_categories : [], // 꼼꼼하게 찾기 카테고리 리스트
        kkomkkom_brands : [], // 꼼꼼하게 찾기 브랜드 리스트(검색 대상 브랜드리스트)
        kkomkkom_makerIds : [], // 꼼꼼하게 찾기 브랜드ID 리스트(현재 체크 중인 브랜드ID리스트)
        page_kkomkkom_brand : 1, // 꼼꼼하게 찾기 브랜드 페이지
        last_page_kkomkkom_brand : 1, // 꼼꼼하게 찾기 브랜드 마지막 페이지
        kkomkkom_price : { // 꼼꼼하게 찾기 최저/최고 가격
            min : 0,
            max : 0
        }
    },

    getters : {
        parameter(state) { return state.parameter; }, // 파라미터
        last_page(state) { return state.last_page; }, // 마지막 페이지
        is_loading_complete(state) { return state.is_loading_complete; }, // 로딩 완료 여부
        alternative_keyword(state) { return state.alternative_keyword; }, // 대체 키워드
        correct_keyword(state) { return state.correct_keyword; }, // 교정 후 키워드
        pre_correct_keyword(state) { return state.pre_correct_keyword; }, // 교정 전 키워드
        recommend_keywords(state) { return state.recommend_keywords; }, // 추천(연관) 검색어 리스트
        best_keywords(state) { return state.best_keywords; }, // 베스트 키워드 리스트
        product_count(state) { return state.product_count; }, // 상품 결과 수
        groups_count(state) { return state.groups_count; }, // 그룹별 겸색결과 수
        products(state) { return state.products; }, // 상품 리스트
        best_products(state) { return state.best_products; }, // 베스트 상품 리스트
        helper(state) { return state.helper; }, // 헬퍼
        quicklink(state) { return state.quicklink; }, // 퀵링크
        kkomkkom_categories(state) { return state.kkomkkom_categories; }, // 꼼꼼하게 찾기 카테고리 리스트
        kkomkkom_brands(state) { return state.kkomkkom_brands; }, // 꼼꼼하게 찾기 브랜드 리스트(검색 대상 브랜드리스트)
        kkomkkom_makerIds(state) { return state.kkomkkom_makerIds; }, // 꼼꼼하게 찾기 브랜드ID 리스트(현재 체크 중인 브랜드ID리스트)
        page_kkomkkom_brand(state) { return state.page_kkomkkom_brand; }, // 꼼꼼하게 찾기 브랜드 페이지
        last_page_kkomkkom_brand(state) { return state.last_page_kkomkkom_brand; }, // 꼼꼼하게 찾기 브랜드 마지막 페이지
        kkomkkom_price(state) { return state.kkomkkom_price; }, // 꼼꼼하게 찾기 최저/최고 가격
    },

    mutations : {
        // SET 파라미터
        SET_PARAMETER(state, parameter) {
            state.parameter = parameter;
        },
        // SET 기타 데이터
        SET_PRODUCT_RESULT_ETC(state, data) {
            state.product_count = data.totalCount;
            state.last_page = data.last_page;
            state.correct_keyword = data.correctKeyword;
            state.pre_correct_keyword = data.orgKeyword;

            if( data == null ) {
                state.is_loading_complete = true;
            }
            if( data.items == null ) { // 검색 결과가 없을 때
                // 대체 검색어 (※ 결과 없을 때만 Return)
                if( data.alternativeKeyword != null ) {
                    state.alternative_keyword = data.alternativeKeyword;
                }

                // 베스트 키워드 리스트 (※ 결과 없을 때만 Return)
                if( data.bestKeywords != null ) {
                    const temp_best_keywords = [];
                    for( let i=0 ; i<data.bestKeywords.length ; i++ ) {
                        temp_best_keywords.push(data.bestKeywords[i].keyword);
                    }
                    state.best_keywords = temp_best_keywords;
                }

                // 베스트 키워드 상품 리스트 (※ 결과 없을 때만 Return)
                if( data.bestProducts != null ) {
                    const items = data.bestProducts;
                    for( let i=0 ; i<items.length ; i++ ) {
                        items[i].item_image = decodeBase64(items[i].item_image);
                    }
                    state.best_products = items;
                }
            }
        },
        // SET 상품 리스트
        SET_PRODUCT_RESULT(state, data) {
            if( data.items != null ) {
                const items = data.items;

                const image_type = state.parameter.view_type === 'detail' ? 'list_image' : 'item_image';
                for( let i=0 ; i<items.length ; i++ ) {
                    items[i][image_type] = decodeBase64(items[i][image_type]);
                    items[i].move_url = decodeBase64(items[i].move_url);

                    state.products.push(items[i]);
                }
            }
            state.is_loading_complete = true;
        },
        // SET 그룹별 검색결과 수
        SET_GROUPS_COUNT(state, results) {
            state.groups_count = {
                total : results.total,
                product : results.product,
                review : results.review,
                exhibition : results.exhibition,
                event : results.event,
                brand : results.brand
            };
        },
        // SET 추천(연관) 검색어 리스트
        SET_RECOMMEND_KEYWORDS(state, keywords) {
            state.recommend_keywords = [];

            if (keywords != null) {
                for( let i=0 ; i<keywords.length ; i++ ) {
                    state.recommend_keywords.push(keywords[i].keyword);
                }
            }
        },
        // SET 헬퍼
        SET_HELPER(state, data) {
            const item_type_arr = ['best_seller','best_popularity','md_recommend'];

            for( let i=0 ; i<item_type_arr.length ; i++ ) {
                const type = item_type_arr[i];

                if( data[type] != null ) {
                    if( data[type].big_image != null )
                        data[type].big_image = decodeBase64(data[type].big_image);

                    if( data[type].list_image != null )
                        data[type].list_image = decodeBase64(data[type].list_image);

                    if( data[type].move_url != null )
                        data[type].move_url = decodeBase64(data[type].move_url);

                    state.helper[type] = data[type];
                }
            }

            if( data.best_rating != null ) {
                if( data.best_rating.product.big_image != null )
                    data.best_rating.product.big_image = decodeBase64(data.best_rating.product.big_image);

                if( data.best_rating.product.list_image != null )
                    data.best_rating.product.list_image = decodeBase64(data.best_rating.product.list_image);

                if( data.best_rating.product.move_url != null )
                    data.best_rating.product.move_url = decodeBase64(data.best_rating.product.move_url);

                state.helper.best_rating = data.best_rating;
            }
        },
        // SET 베스트 상품 리스트
        SET_BEST_PRODUCTS(state, items) {
            for( let i=0 ; i<items.length ; i++ ) {
                items[i].item_image = decodeBase64(items[i].item_image);
            }
            state.best_products = items;
        },
        // SET 퀵링크
        SET_QUICK_LINK(state, quickLink) {
            if( quickLink != null ) {
                let move_url;
                const link_value = quickLink.link_value;
                switch (quickLink.type) {
                    case 'category': move_url = '/category/category_main2020.asp?disp=' + link_value; break;
                    case 'search': move_url = '/search/search_result2020.asp?keyword=' + link_value; break;
                    case 'brand': move_url = '/brand/brand_detail2020.asp?brandid=' + link_value; break;
                    default: move_url = decodeBase64(quickLink.link_value);
                }
                state.quicklink = {
                    background_image : decodeBase64(quickLink.background_image),
                    main_copy : quickLink.main_copy,
                    move_url : move_url
                    , text_color : quickLink.text_color
                };
            }
        },
        // SET 꼼꼼하게 찾기 카테고리 리스트
        SET_KKOMKKOM_CATEGORIES(state, categories) {
            state.kkomkkom_categories = [];
            if( categories != null ) {
                for( let i=0 ; i<categories.length ; i++ ) {
                    state.kkomkkom_categories.push(categories[i]);
                }
            }
        },
        // SET 꼼꼼하게 찾기 브랜드 리스트
        SET_KKOMKKOM_BRANDS(state, brands) {
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
        // ADD 꼼꼼하게 찾기 브랜드 리스트
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
        // SET 꼼꼼하게 찾기 브랜드 페이지
        SET_PAGE_KKOMKKOM_BRAND(state, page) {
            state.page_kkomkkom_brand = page;
        },
        // UPDATE 꼼꼼하게 찾기 브랜드ID리스트
        UPDATE_KKOMKKOM_MAKERIDS(state, parameter) {
            if( state.kkomkkom_makerIds.indexOf(parameter.brand_id) > -1 && !parameter.is_checked ) {
                state.kkomkkom_makerIds.splice(state.kkomkkom_makerIds.indexOf(parameter.brand_id), 1);
            } else if( state.kkomkkom_makerIds.indexOf(parameter.brand_id) < 0 && parameter.is_checked ) {
                state.kkomkkom_makerIds.push(parameter.brand_id);
            }
        },
        // 꼼꼼하게 찾기 추가한 브랜드ID 리스트 초기화
        CLEAR_KKOMKKOM_MAKERIDS(state) {
            state.kkomkkom_makerIds = [];
        },
        // SET 꼼꼼하게 찾기 최저/최고 가격
        SET_KKOMKKOM_PRICE(state, price) {
            state.kkomkkom_price.min = price.min_price;
            state.kkomkkom_price.max = price.max_price;
        },
        // 상품 위시 변경
        UPDATE_PRODUCT_WISH(state, payload) {
            let products;

            switch (payload.wish_type) {
                case 'list': products = state.products; break;
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
        // 헬퍼 상품 위시 변경
        UPDATE_HELPER_PRODUCT_WISH(state, payload) {
            if( payload.wish_type === 'best_rating' ) {
                state.helper.best_rating.product.wish_yn = payload.on_flag;
            } else {
                state.helper[payload.wish_type].wish_yn = payload.on_flag;
            }
        }
    },

    actions : {
        // 검색결과 조회
        READ_SEARCH_PRODUCTS(context) {
            const parameter = context.getters.parameter;

            if( parameter.keyword == null || parameter.keyword === '' ) {
                history.back();
            } else {
                const createParameter = function () { // 검색API 파라미터 생성
                    let api_parameter = '?keywords=' + parameter.keyword
                        + '&mode=D&page=' + parameter.page
                        + '&sortMethod=' + parameter.sort_method;

                    if( parameter.deliType.length > 0 ) { // 배송/기타
                        for( let i=0 ; i<parameter.deliType.length ; i++ ) {
                            api_parameter += '&deliType=' + parameter.deliType[i];
                        }
                    }
                    if( parameter.dispCategories.length > 0 ) { // 카테고리
                        for( let i=0 ; i<parameter.dispCategories.length ; i++ ) {
                            api_parameter += '&dispCategories=' + parameter.dispCategories[i];
                        }
                    }
                    if( parameter.makerIds.length > 0 ) { // 브랜드
                        for( let i=0 ; i<parameter.makerIds.length ; i++ ) {
                            api_parameter += '&makerIds=' + parameter.makerIds[i];
                        }
                    }
                    if( parameter.minPrice !== '' ) { // 최저가
                        api_parameter += '&minPrice=' + parameter.minPrice;
                    }
                    if( parameter.maxPrice !== '' ) { // 최고가
                        api_parameter += '&maxPrice=' + parameter.maxPrice;
                    }

                    if( parameter.correct_keyword !== '' ) { // 교정무시 키워드
                        api_parameter += '&ignoreCorrectTypos=true&ignoreCorrectTyposKeyword=' + parameter.correct_keyword;
                    }

                    return api_parameter;
                }();

                // 자세히 보기
                if (parameter.view_type === 'detail') {
                    const search_keywords_apiurl = apiurlv2 + '/search/itemSearch' + createParameter;
                    //console.log("search_keywords_apiurl", search_keywords_apiurl);
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

                            context.commit('SET_PRODUCT_RESULT_ETC', data); // 기타 데이터
                            context.commit('SET_PRODUCT_RESULT', data); // 상품리스트
                            context.commit('SET_GROUPS_COUNT', data.groupsCount); // 그룹별 결과 수
                            context.commit('SET_RECOMMEND_KEYWORDS', data.recommendKeywords); // 추천(연관) 검색어
                            context.commit('SET_QUICK_LINK', data.quickLink);

                            // GET 꼼꼼하게 찾기 검색조건 조회
                            context.dispatch('GET_KKOMKKOM_CRITERIA');

                            // 현재 1페이지
                            if( Number(parameter.page) === 1 && data.items && data.items.length > 0 ) {

                                context.dispatch('GET_HELPER'); // 상품 헬퍼 데이터 불러오기

                                const product_id_arr = [];
                                data.items.slice(0, 3).forEach(item => {
                                    product_id_arr.push(item.item_id.toString());
                                });

                                // criteo 전송
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

                // 사진만 보기
                } else {
                    const search_keywords_apiurl = apiurl + '/search/imageItemSearch' + createParameter;

                    $.ajax({
                        type: "GET",
                        url: search_keywords_apiurl,
                        ContentType: "json",
                        crossDomain: true,
                        xhrFields: {
                            withCredentials: true
                        },
                        success: function (data) {
                            //console.log(data);
                            context.commit('SET_PRODUCT_RESULT_ETC', data);
                            context.commit('SET_PRODUCT_RESULT', data);
                            context.commit('SET_RECOMMEND_KEYWORDS', data.recommendKeywords);
                            context.commit('SET_GROUPS_COUNT', data.groupsCount);
                            context.commit('SET_QUICK_LINK', data.quickLink);

                            // GET 꼼꼼하게 찾기 검색조건 조회
                            context.dispatch('GET_KKOMKKOM_CRITERIA');

                            if( parameter.page === 1 ) {
                                    const product_id_arr = [];
                                    data.items.slice(0, 3).forEach(item => {
                                        product_id_arr.push(item.item_id.toString());
                                    });

                                    window.criteo_q = window.criteo_q || [];
                                    var deviceType = /iPad/.test(navigator.userAgent) ? "t" : /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "m" : "d";
                                    window.criteo_q.push(
                                        {event: "setAccount", account: 8262}, // 이 라인은 업데이트하면 안됩니다
                                        {event: "setEmail", email: criteo_user_mail_md5}, // 유저가 로그인이 안되 있는 경우 빈 문자열을 전달
                                        {event: "setSiteType", type: deviceType},
                                        {event: "viewList", item: product_id_arr}); // 가장 위에있는 3개의 상품 ID를 전달
                            }
                        },
                        error: function (xhr) {
                            console.log(xhr.responseText);
                        }
                    });
                }
            }

            if(typeof qg !== "undefined"){
                let appier_searched_data = {
                    "keyword" : parameter.keyword
                    , "filter_brand" : parameter.makerIds.toString()
                    , "filter_category" : parameter.dispCategories.toString()
                    , "filter_highprice" : parameter.maxPrice
                    , "filter_lowprice" : parameter.minPrice
                    , "list_type" : parameter.view_type
                    , "sort" : parameter.sort_method
                };

                qg("event", "searched", appier_searched_data);
            }
        },
        // 상품 헬퍼 데이터 조회
        GET_HELPER(context) {
            const keyword = context.getters.correct_keyword ? context.getters.correct_keyword
                                : context.getters.parameter.keyword;
            const search_helper_apiurl = apiurl + '/search/itemSearchHelper?keywords=' + keyword;

            $.ajax({
                type: "GET",
                url: search_helper_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    //console.log(data);
                    context.commit('SET_HELPER', data);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        // 베스트 키워드 상품 리스트 불러오기
        CHANGE_BEST_PRODUCTS(context, keyword) {
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
                    context.commit('SET_BEST_PRODUCTS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        // GET 꼼꼼하게 찾기 검색조건 조회
        GET_KKOMKKOM_CRITERIA(context) {
            const parameter = context.getters.parameter;
            const keyword = context.getters.correct_keyword ? context.getters.correct_keyword
                                : parameter.keyword;

            let search_kkomkkom_apiurl = apiurl + '/search/kkomkkom?keywords=' + keyword;

            if( parameter.deliType.length > 0 ) { // 배송/기타
                for( let i=0 ; i<parameter.deliType.length ; i++ ) {
                    search_kkomkkom_apiurl += '&deliType=' + parameter.deliType[i];
                }
            }
            if( parameter.dispCategories.length > 0 ) { // 카테고리
                for( let i=0 ; i<parameter.dispCategories.length ; i++ ) {
                    search_kkomkkom_apiurl += '&dispCategories=' + parameter.dispCategories[i];
                }
            }
            if( parameter.makerIds.length > 0 ) { // 브랜드
                for( let i=0 ; i<parameter.makerIds.length ; i++ ) {
                    search_kkomkkom_apiurl += '&makerIds=' + parameter.makerIds[i];
                }
            }
            if( parameter.minPrice !== '' ) { // 최저가
                search_kkomkkom_apiurl += '&minPrice=' + parameter.minPrice;
            }
            if( parameter.maxPrice !== '' ) { // 최고가
                search_kkomkkom_apiurl += '&maxPrice=' + parameter.maxPrice;
            }

            $.ajax({
                type: "GET",
                url: search_kkomkkom_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    //console.log(data);
                    context.commit('SET_KKOMKKOM_CATEGORIES', data.categories);
                    context.commit('SET_KKOMKKOM_BRANDS', data.brands);
                    context.commit('SET_KKOMKKOM_PRICE', data);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            })
        },
        // 꼼꼼하게 찾기 브랜드 조회
        GET_MORE_KKOMKKOM_BRANDS(context, brand_name_keyword) {
            if( context.getters.last_page_kkomkkom_brand <= context.getters.page_kkomkkom_brand ) // 마지막 페이지면 return
                return false;

            const next_page = context.getters.page_kkomkkom_brand + 1;
            context.commit('SET_PAGE_KKOMKKOM_BRAND', next_page);
            const keyword = context.getters.correct_keyword ? context.getters.correct_keyword
                                : context.getters.parameter.keyword;

            let brand_kkomkkom_apiurl = apiurl + '/search/kkomkkom/brands?keywords='
                + keyword + '&page=' + next_page;
            if( brand_name_keyword !== '' ) {
                brand_kkomkkom_apiurl += '&brand_name_keyword=' + brand_name_keyword;
            }

            $.ajax({
                type: "GET",
                url: brand_kkomkkom_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    context.commit('ADD_KKOMKKOM_BRANDS', data.brands);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            })
        }
    }
});