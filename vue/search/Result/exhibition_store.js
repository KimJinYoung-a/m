let store = new Vuex.Store({
    state : {
        parameter : { // 파라미터
            keyword : '', // 검색했던 키워드
            sort_method: 'new', // 정렬
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
        exhibition_count : 0, // 기획전 검색결과 갯수
        exhibitions: [], // 상품 리스트
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
        exhibition_count(state) { // 기획전 검색결과 갯수
            return state.exhibition_count;
        },
        exhibitions(state) { // 기획전 리스트
            return state.exhibitions;
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
            state.groups_count = {
                total : results.total,
                product : results.product,
                review : results.review,
                exhibition : results.exhibition,
                event : results.event,
                brand : results.brand
            };
        },
        SET_EXHIBITIONS_RESULT(state, data) { // 기획전 리스트 SET
            state.exhibition_count = data.totalCount;
            if( data.current_page === 1 ) {
                state.correct_keyword = data.correctKeyword;
                state.pre_correct_keyword = data.orgKeyword;
            }

            if( data.items != null ) {
                const items = data.items;

                const decodeBase64 = function(str) {
                    if( str == null ) return null;
                    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
                }

                for( let i=0 ; i<items.length ; i++ ) {
                    // 배너이미지 decode
                    if( items[i].banner_img != null ) {
                        items[i].banner_img = decodeBase64(items[i].banner_img);
                    }
                    if( items[i].move_url != null ) {
                        items[i].move_url = decodeBase64(items[i].move_url);
                    }
                    state.exhibitions.push(items[i]);
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
                const decodeBase64 = function(str) {
                    if( str == null ) return null;
                    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
                }

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
        }
    },

    actions : {
        READ_SEARCH_EXHIBITIONS(context) { // READ 검색결과
            const parameter = context.getters.parameter;

            if( parameter.keyword == null || parameter.keyword === '' ) {
                history.back();
            } else {
                let search_exhibition_apiurl = apiurlv2 + '/search/exhibitionSearch'
                    + create_search_parameter(parameter, context.getters.current_page)
                    + '&sortMethod=' + parameter.sort_method;

                if( parameter.correct_keyword !== '' ) { // 교정무시 키워드
                    search_exhibition_apiurl += '&ignoreCorrectTypos=true&ignoreCorrectTyposKeyword=' + parameter.correct_keyword;
                }

                $.ajax({
                    type: "GET",
                    url: search_exhibition_apiurl,
                    ContentType: "json",
                    crossDomain: true,
                    xhrFields: {
                        withCredentials: true
                    },
                    success: function (data) {
                        console.log(data);
                        context.commit('SET_EXHIBITIONS_RESULT', data);
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
    }
});