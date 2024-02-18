let store = new Vuex.Store({
    state : {
        keyword: '', // 검색 키워드
        best_keywords: [], // 인기검색어 리스트
        auto_keywords: [], // 자동완성 키워드 리스트
        recent_keywords: [] // 자동완성 키워드 리스트
    },

    getters : {
        keyword(state) { // 검색 키워드
            return state.keyword;
        },
        best_keywords(state) { // 인기검색어 리스트
            return state.best_keywords;
        },
        auto_keywords(state) { // 자동완성 키워드 리스트
            return state.auto_keywords;
        },
        recent_keywords(state) { // 최근검색어 리스트
            return state.recent_keywords;
        }
    },

    mutations : {
        SET_BEST_KEYWORDS(state, keywords) { // SET 인기검색어 리스트
            if( keywords != null ) {
                for( let i=0 ; i<keywords.length ; i++ ) {
                    if( !isNaN(keywords[i].tag) && Number(keywords[i].tag) > 100 ) {
                        keywords[i].tag = 'hot';
                    } else if(!isNaN(keywords[i].tag) || keywords[i].tag === '-') {
                        keywords[i].tag = '';
                    }
                }
            }
            state.best_keywords = keywords;
        },
        SET_AUTO_KEYWORDS(state, keywords) { // SET 자동완성 키워드 리스트
            state.auto_keywords = keywords != null ? keywords : [];
        },
        SET_RECENT_KEYWORDS(state, keywords) { // SET 최근검색어 리스트
            state.recent_keywords = keywords;
        },
        DELETE_RECENT_KEYWORDS(state) { // DELETE 최근검색어 리스트
            state.recent_keywords = [];
        },
        UPDATE_KEYWORD(state, keyword) { // 키워드 변경
            state.keyword = keyword;
        }
    },

    actions : {
        READ_BEST_KEYWORDS(context) { // 인기검색어 리스트 조회
            const best_keywords_api_url = apiurl + '/search/bestKeywords';
            $.ajax({
                type: "GET",
                url: best_keywords_api_url,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    context.commit('SET_BEST_KEYWORDS', data.keywords);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        READ_AUTO_KEYWORDS(context) {
            const keyword = context.getters.keyword;
            // 자동완성 키워드 리스트 API GET Request
            if( keyword != null && keyword.trim() !== '' ) {
                const auto_complete_api_url = apiurl + '/search/completeKeywords?keyword=' + keyword;
                $.ajax({
                    type: "GET",
                    url: auto_complete_api_url,
                    ContentType: "json",
                    crossDomain: true,
                    xhrFields: {
                        withCredentials: true
                    },
                    success: function (data) {
                        context.commit('SET_AUTO_KEYWORDS', data.keywords);
                    },
                    error: function (xhr) {
                        console.log(xhr.responseText);
                    }
                });
            }
        }
    }
});