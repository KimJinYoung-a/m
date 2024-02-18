const store = new Vuex.Store({
    state : {
        mikki_list : []
        , teaser_info : {}
    },
    mutations : {
        SET_MIKKI_LIST(state, data){
            state.mikki_list = data;
        }
        , SET_TEASER_INFO(state, data){
            state.teaser_info = data;
        }
    }
    , actions : {
        GET_MIKKI_LIST(context, eventid){
            let query_param = new URLSearchParams(window.location.search);
            let setting_time = query_param.get("setting_time");

            let api_data = {"tz_evt_code" : eventid};
            if(setting_time){
                api_data = {"tz_evt_code" : eventid, "setting_time" : setting_time};
            }

            $.ajax({
                type: "GET"
                , url: apiurl + "/timedeal/check-valid-event"
                , data : api_data
                , ContentType: "json"
                , crossDomain: true
                , xhrFields: {
                    withCredentials: true
                }
                , success: function (data) {
                    if(data.count > 0){
                        let setting_time_param = "";
                        if(server_info == "Dev" || server_info == "staging"){
                            setting_time_param = "&setting_time=" + setting_time;
                        }

                        if (isApp){
                            location.href ="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=" + data.evt_code + setting_time_param;
                        }else{
                            location.href = "/event/eventmain.asp?eventid=" + data.evt_code + setting_time_param;
                        }
                    }else{
                        $.ajax({
                            type: "GET"
                            , url: apiurl + "/timedeal/timedeal-teaser"
                            , data : api_data
                            , ContentType: "json"
                            , crossDomain: true
                            , xhrFields: {
                                withCredentials: true
                            }
                            , success: function (data) {
                                console.log("GET_MIKKI_LIST", data);
                                context.commit("SET_MIKKI_LIST", data);
                            }
                            , error: function (xhr) {
                                console.log(xhr.responseText);
                            }
                        });
                    }
                }
                , error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
        , GET_TEASER_INFO(context, eventid){
            call_api("GET", "/timedeal/timedeal-next-schedule-teaser", {"tz_evt_code" : eventid}, function (data){
                console.log("check", data);
                context.commit("SET_TEASER_INFO", data);
            });
        }
    }
    , getters : {
        mikki_list(state){
            return state.mikki_list;
        }
        , teaser_info(state){
            return state.teaser_info;
        }
    }
});