let store = new Vuex.Store({
    state : {
        content : {}
    }
    , actions : {
        GET_CONTENT(context) {
            let ajax_data = {"evt_code" : context.getters.evt_code};
            $.ajax({
                type: "GET"
                , url: apiurl + '/event/content'
                , data : ajax_data
                , ContentType: "json"
                , crossDomain: true
                , xhrFields: {
                    withCredentials: true
                }
                , success: function (data) {
                    context.commit('SET_CONTENT', data);
                }
                , error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
    }
    , mutations : {
        SET_CONTENT(state, data) { // SET 기간
            state.content = data;
        }
    }
    , getters : {
        content(state){
            return state.content;
        }
    }
});