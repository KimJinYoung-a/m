const store = new Vuex.Store({
    state : {
        item : {}
        , servey : {}
        , comment_list : {}
    }
    , actions : {
        GET_DATA(context){
            const _this = this;
            let query_param = new URLSearchParams(window.location.search);
            const exclusive_idx = query_param.get("exclusive_idx");
            let api_data = {"isApp" : isApp, "exclusive_idx" : exclusive_idx};

            call_api("GET", "/tenten-exclusive-real/item-detail", api_data
                , data=>{
                    console.log("GET_DATA", data);
                    context.commit("SET_ITEM", data);
                }
            );
        }
        , GET_SERVEY(context){
            const _this = this;
            let query_param = new URLSearchParams(window.location.search);
            const exclusive_idx = query_param.get("exclusive_idx");
            let api_data = {"exclusive_idx" : exclusive_idx};

            call_api("GET", "/tenten-exclusive-real/servey", api_data
                , data=>{
                    console.log("GET_SERVEY", data);
                    context.commit("SET_SERBEY", data);
                }
            );
        }
        , GET_COMMENT_LIST(context){
            let query_param = new URLSearchParams(window.location.search);
            const exclusive_idx = query_param.get("exclusive_idx");
            let api_data = {"exclusiveIdx" : exclusive_idx, "currentPage" : 1, "pageSize" : 30};

            call_api("GET", "/tenten-exclusive-real/comments", api_data
                , data=>{
                    console.log("GET_COMMENT_LIST", data);
                    context.commit("SET_COMMENT_LIST", data);
                }
            );
        }
    }
    , mutations : {
        SET_ITEM(state, data){
            state.item = data;
        }
        , SET_SERBEY(state, data){
            state.servey = data;
        }
        , SET_COMMENT_LIST(state, data){
            state.comment_list = data;
        }
    }
    , getters : {
        item(state){
            return state.item;
        }
        , servey(state){
            return state.servey;
        }
        , comment_list(state){
            return state.comment_list;
        }
    }
});