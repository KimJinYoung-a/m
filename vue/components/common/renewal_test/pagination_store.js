
var store = new Vuex.Store({
    state : {
        params : { // 파라미터
        },
        current_page : 1,
        last_page : 10
    },
    getters : {
        current_page : function (state) { // 현재 페이지
            return state.current_page;
        },
        last_page : function (state) { // 마지막 페이지
            return state.last_page;
        }
    },
    mutations : {
        MOVE_PAGE : function (state, payload) { // 페이지 이동
            this.state.current_page = Number(payload);
        }
    },
    actions : {
        GET_LIST : function (context) { //

        }
    }
});