const decodeBase64 = function(str) {
    if( str == null ) return null;
    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
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
        review_count : 0, // 상품 검색결과 갯수
        reviews: [], // 상품 리스트
        alternative_keyword: '', // 대체 검색어
        pre_correct_keyword : '', // 교정 전 검색어
        correct_keyword : '', // 교정 검색어
        isApp: isApp, // 앱 여부
        is_searched: false, // 검색 결과 불러왔는지 여부
        current_page: 1, // 현재 페이지
        is_loading: false, // 현재 페이지
        is_loading_complete: false, // 페이지 모두 로딩했는지 여부
        quicklink: { // 퀵링크
            background_image : '',
            main_copy : '',
            move_url : ''
            , text_color: ''
        },
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
        review_count(state) { // 검색결과 그룹별 겸색결과 수
            return state.review_count;
        },
        reviews(state) { // 상품 리스트
            return state.reviews;
        },
        alternative_keyword(state) { // 대체 검색어
            return state.alternative_keyword;
        },
        correct_keyword(state) { return state.correct_keyword; }, // 교정 후 키워드
        pre_correct_keyword(state) { return state.pre_correct_keyword; }, // 교정 전 키워드
        isApp(state) { // 앱 여부
            return state.isApp;
        },
        is_searched(state) { // 검색 결과 불러왔는지 여부
            return state.is_searched;
        },
        current_page(state) { // 현재 페이지
            return state.current_page;
        },
        next_page(state) { // 다음 페이지
            return state.current_page + 1;
        },
        is_loading(state) {	// 다음 상품리스트 로딩 중 여부
            return state.is_loading;
        },
        is_loading_complete(state) { // 페이지 모두 로딩했는지 여부
            return state.is_loading_complete;
        },
        quicklink(state) { // 퀵링크
            return state.quicklink;
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
        SET_PARAMETER(state, parameter) { // SET 파라미터
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
        SET_GROUPS_COUNT(state, results) { // SET 그룹별 검색결과 수
            // 검색결과 그룹별 겸색결과 수
            state.groups_count = {
                total : results.total,
                product : results.product,
                review : results.review,
                exhibition : results.exhibition,
                event : results.event,
                brand : results.brand
            };
        },
        SET_REVIEW_RESULT(state, data) { // 상품후기 리스트 SET
            state.review_count = data.totalCount;
            if( data.current_page === 1 ) {
                state.correct_keyword = data.correctKeyword;
                state.pre_correct_keyword = data.orgKeyword;
            }

            if( data.items != null ) {
                const items = data.items;

                const add_highlight = function(str) {
                    return str.split(state.parameter.keyword).join('<mark class="match">' + state.parameter.keyword + '</mark>');
                }

                for( let i=0 ; i<items.length ; i++ ) {
                    const item = items[i];

                    // 상품이미지 decode
                    if( item.item_image != null ) {
                        item.item_image = decodeBase64(item.item_image);
                    }
                    // 유저 후기이미지 decode
                    if( item.review_images != null ) {
                        for( let j=0 ; j<item.review_images.length ; j++ ) {
                            item.review_images[j] = decodeBase64(item.review_images[j]);
                        }
                    }

                    // 상품명, 후기내용 검색키워드 하이라이트 처리
                    item.item_name = add_highlight(item.item_name);
                    item.content = add_highlight(item.content);

                    state.reviews.push(item);
                }
            } else {
                state.is_loading_complete = true;
            }

            if( data.alternativeKeyword != null ) {
                state.alternative_keyword = data.alternativeKeyword;
            }
            state.is_searched = true;
            state.is_loading = false;
        },
        SET_PAGE(state, page) { // 페이지 이동
            state.current_page = page;
        },
        SET_IS_LOADING(state, loading) { // SET 페이지 로딩 중 여부
            state.is_loading = loading;
        },
        SET_QUICK_LINK(state, quickLink) { // SET 퀵링크
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
        UPDATE_REVIEW_PRODUCT_WISH(state, flag) { // UPDATE 이상품 후기 더보기 상품 위시
            state.product.wish_yn = flag;
        }
    },

    actions : {
        READ_RECOMMEND_KEYWORDS(context) { // READ 연관검색어 리스트
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
        READ_SEARCH_REVIEWS(context) { // READ 검색결과
            const parameter = context.getters.parameter;

            if( parameter.keyword == null || parameter.keyword === '' ) {
                history.back();
            } else {
                let search_review_apiurl = apiurlv2 + '/search/reviewSearch'
                    + create_search_parameter(parameter, context.getters.current_page)
                    + '&sortMethod=' + parameter.sort_method;

                if( parameter.correct_keyword !== '' ) { // 교정무시 키워드
                    search_review_apiurl += '&ignoreCorrectTypos=true&ignoreCorrectTyposKeyword=' + parameter.correct_keyword;
                }

                $.ajax({
                    type: "GET",
                    url: search_review_apiurl,
                    ContentType: "json",
                    crossDomain: true,
                    xhrFields: {
                        withCredentials: true
                    },
                    success: function (data) {
                        console.log(data);
                        context.commit('SET_REVIEW_RESULT', data);
                        if( context.getters.current_page === 1 ) {
                            context.commit('SET_RECOMMEND_KEYWORDS', data.recommendKeywords);
                            context.commit('SET_GROUPS_COUNT', data.groupsCount);
                            context.commit('SET_QUICK_LINK', data.quickLink);
                        }
                    },
                    error: function (xhr) {
                        console.log(xhr.responseText);
                    }
                });
            }
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