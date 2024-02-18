var store = new Vuex.Store({
    state : {
        categories: []
    },
    getters : {
        categories : function(state) { // 카테고리 리스트
            return state.categories;
        }
    },
    mutations : {
        SET_CATEGORIES : function(state , payload) { // Set 하위 카테고리 리스트
            const default_arr = [{
                catecode: 0,
                catename: '전체',
                hasRowList: false,
                itemCount: 0
            }];
            state.categories = default_arr.concat(payload);
        }
    },
    actions : {
        GET_CATEGORIES : function(context) { // 메인 아이템들 state에 저장
            const _url = apiurl + '/category/topDispCateList';

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
                    context.commit('SET_CATEGORIES', data.categories);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
    }
});