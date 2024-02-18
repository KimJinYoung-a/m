const store = new Vuex.Store({
    state : {
        evt_code : ""
        , comment_list:[]
        , current_page : 1
        , page_size : 5

        , totalpage : 1
        , current_page_list_start : 1
    }
    , actions : {
        GET_COMMENT(context){
            call_api("GET", "/tempEvent/sanrio", {"event_code" : context.getters.evt_code, "current_page" : context.getters.current_page, "page_size" : context.getters.page_size}
                , data=>{
                    console.log("GET_COMMENT", data);
                    context.commit("SET_COMMENT_LIST", data);
                }
            );
        }
    }
    , mutations : {
        SET_EVT_CODE(state, data){
            state.evt_code = data;
        }
        , SET_COMMENT_LIST(state, data){
            state.comment_list = data.sanrioList;
            state.totalpage = data.totalPage;
            state.current_page_list_start = 1 + 6 * (Math.ceil(state.current_page / 6) - 1);
        }
        , SET_CURRENT_PAGE(state, data){
            state.current_page = data;
        }
    }
    , getters : {
        evt_code(state){
            return state.evt_code;
        }
        , comment_list(state){
            return state.comment_list;
        }
        , current_page(state){
            return state.current_page;
        }
        , page_size(state){
            return state.page_size;
        }
        , totalpage(state){
            return state.totalpage;
        }
        , current_page_list_start(state){
            return state.current_page_list_start;
        }
    }
});