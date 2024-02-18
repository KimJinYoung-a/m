const store = new Vuex.Store({
    state : {
        evt_code : ""
        , schedule_idx: ""
        , normal_list : []
        , mikki_time : []
        , time_text : ""
        , now_mikki : {}
        , pre_mikki : []
        , post_mikki : []
        , next_mikki : ""
        , next_schedule : ""
    },
    mutations : {
        SET_EVT_CODE(state, data){
            state.evt_code = data;
        }
        , SET_SCHEDULE_IDX(state, data){
            state.schedule_idx = data;
        }
        , SET_NORMAL_LIST(state, data){
            state.normal_list = data;
        }
        , SET_MIKKI_TIME(state, data){
            return state.mikki_time = data;
        }
        , SET_TIME_TEXT(state, data){
            return state.time_text = data;
        }
        , SET_NOW_MIKKI(state, data){
            return state.now_mikki = data;
        }
        , SET_PRE_MIKKI(state, data){
            return state.pre_mikki = data;
        }
        , SET_POST_MIKKI(state, data){
            return state.post_mikki = data;
        }
        , SET_NEXT_MIKKI(state, data){
            return state.next_mikki = data;
        }
        , SET_NEXT_SCHEDULE(state, data){
            return state.next_schedule = data;
        }
    }
    , actions : {
        GET_DATA(context){
            const _this = this;
            let query_param = new URLSearchParams(window.location.search);
            let setting_time;
            if(server_info == "Dev" || server_info == "staging"){
                setting_time = query_param.get("setting_time");
            }

            return new Promise(function (resolve, reject){
                let api_data = {"evt_code" : context.getters.evt_code};
                if(setting_time){
                    api_data = {"evt_code" : context.getters.evt_code, "setting_time" : setting_time};
                }

                call_api("GET", "/timedeal/check-valid-event", api_data
                    , data=>{
                        //console.log("CHECK_VALID_EVENT", data);
                        if(data.count == 0){
                            let setting_time_param = "";
                            if(setting_time){
                                setting_time_param = "&setting_time=" + setting_time;
                            }

                            if (isApp){
                                location.href ="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=" + data.tz_evt_code + setting_time_param;
                            }else{
                                location.href = "/event/eventmain.asp?eventid=" + data.tz_evt_code + setting_time_param;
                            }
                        }else{
                            call_api("GET", "/timedeal/timedeal-scheduleidx", api_data
                                , data=>{
                                    //console.log("GET_SCHEDULE_IDX", data);
                                    if(data.toString() != null && data.toString() != ""){
                                        context.commit("SET_SCHEDULE_IDX", data);
                                        resolve();
                                    }else{
                                        alert("진행중인 타임세일이 없습니다.");
                                        reject("진행중인 타임세일이 없습니다.");
                                    }
                                }
                            );
                        }
                    }
                );
            }).then(function (){
                let api_data = {"evt_code" : context.getters.evt_code, "schedule_idx" : context.getters.schedule_idx};
                if(setting_time){
                    api_data = {"evt_code" : context.getters.evt_code, "schedule_idx" : context.getters.schedule_idx, "setting_time" : setting_time};
                }

                call_api("GET", "/timedeal/timedeal-normal", {"evt_code" : context.getters.evt_code, "schedule_idx" : context.getters.schedule_idx}
                    , data=>{
                        //console.log("GET_NORMAL_LIST", data);
                        context.commit("SET_NORMAL_LIST", data);

                        const $rootEl = $("#itemList");
                        let tmpEl = "";
                        let itemEle = "";
                        $rootEl.empty();

                        data.forEach(function(item){
                            tmpEl = `
                                <li>
                                    <a href="" onclick="goProduct('` + item + `');return false;">
                                        <div class="thumbnail"><img src="" alt=""></div>
                                        <div class="desc">
                                            <p class="name">상품명상품명상품명상품명상품명상품명</p>
                                            <div class="price"><s>정가</s> 할인가<span class="sale">할인율%</span></div>
                                        </div>
                                    </a>
                                </li>
                            `
                            itemEle += tmpEl
                        });
                        $rootEl.append(itemEle)

                        fnApplyItemInfoList({
                            items: data,
                            target:"itemList",
                            fields:["image","name","price","sale"],
                            unit:"none",
                            saleBracket:false
                        });
                    }
                );

                call_api("GET", "/timedeal/timedeal-mikki-time", api_data
                    , data=>{
                        console.log("GET_MIKKI_TIME", data);
                        let mikki_time = [];
                        let start_time = data[0].mikki_time, end_time = data[0].mikki_time, end_end_time = data[0].endDate;
                        data.forEach(function (item, index){
                            if(index < 4){
                                if(item.end_flag == 'Y'){
                                    item.active_name = 'end';
                                }else{
                                    if(index == 0){
                                        let today = new Date();
                                        if(setting_time){
                                            today = new Date(
                                                setting_time.substr(0, 4)
                                                , setting_time.substr(5, 2) - 1
                                                , setting_time.substr(8, 2)
                                                , setting_time.substr(11, 2)
                                                , setting_time.substr(14, 2)
                                                , setting_time.substr(17, 2)
                                            );
                                        }
                                        //console.log("today", today);

                                        let startDate = new Date(
                                            item.startDate.substr(0, 4)
                                            , item.startDate.substr(5, 2) - 1
                                            , item.startDate.substr(8, 2)
                                            , Number(item.startDate.substr(11, 2))
                                            , item.startDate.substr(14, 2)
                                            , item.startDate.substr(17, 2)
                                        );
                                        let endDate = new Date(
                                            item.endDate.substr(0, 4)
                                            , item.endDate.substr(5, 2) - 1
                                            , item.endDate.substr(8, 2)
                                            , Number(item.endDate.substr(11, 2))
                                            , item.endDate.substr(14, 2)
                                            , item.endDate.substr(17, 2)
                                        );
                                        console.log("startDate", startDate, new Date(item.startDate));
                                        console.log("endDate", endDate, new Date(item.endDate));

                                        if(today >= startDate && today <= endDate){
                                            item.active_name = 'on';
                                        }else{
                                            item.active_name = 'off';
                                        }
                                    }else{
                                        item.active_name = 'off';
                                    }
                                }
                                mikki_time.push(item);
                            }

                            if(parseInt(start_time) > parseInt(item.mikki_time)){
                                start_time = item.mikki_time;
                            }
                            if(parseInt(end_time) < parseInt(item.mikki_time)){
                                end_time = item.mikki_time;
                            }
                            if(parseInt(end_end_time) < parseInt(item.endDate)){
                                end_end_time = item.endDate;
                            }
                        });

                        let today = new Date();
                        if(setting_time){
                            //console.log("today is setting_time", setting_time);
                            today = new Date(
                                setting_time.substr(0, 4)
                                , setting_time.substr(5, 2) - 1
                                , setting_time.substr(8, 2)
                                , Number(setting_time.substr(11, 2))
                                , setting_time.substr(14, 2)
                                , setting_time.substr(17, 2)
                            );
                        }

                        let end_end_time_date = new Date(
                            end_end_time.substr(0, 4)
                            , end_end_time.substr(5, 2) - 1
                            , end_end_time.substr(8, 2)
                            , Number(end_end_time.substr(11, 2)) + 9
                            , end_end_time.substr(14, 2)
                            , end_end_time.substr(17, 2)
                        );

                        let now_time = today.getHours();
                        let time_text = "";
                        //console.log("now, start, end, today, end_end_time", now_time, start_time, end_time, today, end_end_time_date);
                        switch (true){
                            case now_time < start_time : time_text = "세일 오픈까지"; break;
                            case now_time >= end_time && today < end_end_time_date : time_text = "세일 종료까지"; break;
                            default : time_text = "다음 특가상품 까지";
                        }

                        context.commit("SET_MIKKI_TIME", mikki_time);
                        context.commit("SET_TIME_TEXT", time_text);
                    }
                );

                call_api("GET", "/timedeal/timedeal-now-mikki", api_data
                    , data=>{
                        //console.log("data", data);
                        data.now_mikki.is_soldout = data.now_mikki.limitno - data.now_mikki.limitsold < 1 ? true : false;

                        context.commit("SET_NOW_MIKKI", data.now_mikki);
                        context.commit("SET_PRE_MIKKI", data.pre_mikki);
                        context.commit("SET_POST_MIKKI", data.post_mikki);
                        context.commit("SET_NEXT_MIKKI", data.next_mikki);
                    }
                );
            });
        }
        , GET_NEXT_SCHEDULE(context){
            call_api("GET", "/timedeal/timedeal-next-schedule", {"evt_code" : context.getters.evt_code}
                , data=>{
                    //console.log("GET_NEXT_SCHEDULE", data);
                    context.commit("SET_NEXT_SCHEDULE", data.startDate);
                }
            );
        }
    }
    , getters : {
        evt_code(state){
            return state.evt_code;
        }
        , schedule_idx(state){
            return state.schedule_idx;
        }
        , normal_list(state){
            return state.normal_list;
        }
        , mikki_time(state){
            return state.mikki_time;
        }
        , time_text(state){
            return state.time_text;
        }
        , now_mikki(state){
            return state.now_mikki;
        }
        , pre_mikki(state){
            return state.pre_mikki;
        }
        , post_mikki(state){
            return state.post_mikki;
        }
        , next_mikki(state){
            return state.next_mikki;
        }
        , next_schedule(state){
            return state.next_schedule;
        }
    }
});