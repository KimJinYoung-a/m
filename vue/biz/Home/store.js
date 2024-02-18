const decodeBase64 = function (str) {
    if (str == null) return null;
    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
}

let store = new Vuex.Store({
    state    : {
        banner_list : []
        , best_pick : []
        , recommend_list : []
        , categories : []
    }
    , actions  : {
        GET_BANNER_LIST(context, master_code){
            $.ajax({
                type: "GET"
                , url: apiurl + "/b2b/mobile/home/banner-list"
                , data : {"masterCode" : master_code}
                , ContentType: "json"
                , crossDomain: true
                , xhrFields: {
                    withCredentials: true
                }
                , success: function (data) {
                    //console.log('GET_BANNER_LIST', data);
                    context.commit("SET_BANNER_LIST", data);
                }
                , error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
        , GET_BEST_PICK(context){
            $.ajax({
                type: "GET"
                , url: apiurl + "/b2b/mobile/home/bestpick-list"
                , ContentType: "json"
                , crossDomain: true
                , xhrFields: {
                    withCredentials: true
                }
                , success: function (data) {
                    //console.log('GET_BEST_PICK', data);
                    context.commit("SET_BEST_PICK", data);
                }
                , error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
        , GET_RECOMMEND_LIST(context, request){
            $.ajax({
                type: "GET"
                , url: apiurl + "/b2b/mobile/home/recommend-list"
                , data : {"sort_method" : request.sort_method , "category_code" : request.category_code, "read_row_cnt" : 80}
                , ContentType: "json"
                , crossDomain: true
                , xhrFields: {
                    withCredentials: true
                }
                , success: function (data) {
                    //console.log('GET_RECOMMEND_LIST', data.items);
                    context.commit("SET_RECOMMEND_LIST", data.items);
                }
                , error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
        , GET_CATEGORIES(context, category_code){
            $.ajax({
                type: "GET"
                , url: apiurl + "/b2b/mobile/categories"
                , data : {"category_code" : category_code}
                , ContentType: "json"
                , crossDomain: true
                , xhrFields: {
                    withCredentials: true
                }
                , success: function (data) {
                    let category_depth1 = data.categories_depth1;
                    let category_line_count = Math.ceil(category_depth1.length / 4);
                    //console.log("count / length",category_line_count, category_depth1.length);

                    let category_line = [];
                    for (let i = 0; i < category_line_count; i++){
                        let start_arr_index = 0 + (i*4);
                        let end_arr_index = 4 + (i*4);
                        category_line.push(category_depth1.slice(start_arr_index, end_arr_index));
                    }
                    let comming_soon = {"category_name" : "곧 만나요!", "category_image" : "Ly9maXhpbWFnZS4xMHgxMC5jby5rci93ZWIyMDIxL2Jpei9tL3Nvb24uZ2lm"};
                    category_line[category_line_count-1].push(comming_soon);
                    //console.log('GET_CATEGORIES', category_line);

                    context.commit("SET_CATEGORIES", category_line);
                }
                , error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
    }
    , mutations: {
        SET_BANNER_LIST(state, data){
            state.banner_list = data;
        }
        , SET_BEST_PICK(state, data){
            state.best_pick = data;
        }
        , SET_RECOMMEND_LIST(state, data){
            if( data != null && data.length > 0 ) {
                state.recommend_list = [];
                data.forEach(item => {
                    item.list_image = decodeBase64(item.list_image);
                    item.add_image = decodeBase64(item.add_image);
                    item.move_url = decodeBase64(item.move_url);
                    state.recommend_list.push(item);
                });
            } else {
                state.recommend_list = null;
            }
        }
        , SET_CATEGORIES(state, data){
            state.categories = data;
        }
    }
    , getters : {
        banner_list(state){
            return state.banner_list;
        }
        , best_pick(state){
            return state.best_pick;
        }
        , recommend_list(state){
            return state.recommend_list;
        }
        , categories(state){
            return state.categories;
        }
    }
});