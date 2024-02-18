var store = new Vuex.Store({
    state : {
        params : { // 파라미터
            request_catecode: 0
        },
        options : { // 옵션
            first_category_view_count: 6
        },
        this_category : { // 현재 카테고리
            catecode: 0,
            catename: ''
        },
        categories: []
    },
    getters : {
        first_category_view_count : function(state) { // 처음 보여줄 하위 카테고리 수
            return state.options.first_category_view_count;
        },
        more_category_count : function(state) { // 더보기 카테고리 수
            if( state.categories.length < state.options.first_category_view_count )
                return 0;
            return state.categories.length - state.options.first_category_view_count;
        },
        this_category : function(state) { // 현재 카테고리
            return state.this_category;
        },
        categories : function(state) { // 하위 카테고리 리스트
            return state.categories;
        }
    },
    mutations : {
        SET_REQ_PARAM : function(state, payload) { // Request 파라미터 state params에 set
            state.params.request_catecode = payload.disp;
        },
        SET_THIS_CATEGORY: function(state , payload) { // Set 현재 카테고리
            state.this_category.catecode = payload.catecode;
            state.this_category.catename = payload.catename;
        },
        SET_CATEGORIES : function(state , payload) { // Set 하위 카테고리 리스트
            state.categories = payload.categories;
        }
    },
    actions : {
        GET_CATEGORIES : function(context) { // 메인 아이템들 state에 저장
            const _url = apiurl + '/category/main/' + context.state.params.request_catecode;

            $.ajax({
                type : "GET",
                url: _url,
                ContentType : "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function(data) {
                    console.log(data);
                    // 상단 카테고리 그룹
                    var top_categories = data.top_categories;
                    context.commit('SET_THIS_CATEGORY', top_categories);
                    context.commit('SET_CATEGORIES', top_categories);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
    }
});