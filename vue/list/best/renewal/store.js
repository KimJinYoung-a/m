let store = new Vuex.Store({
    state : {
        current_page : 1
        , last_page : 1
        , cate_code : ""
        , cate_name : ""
        , flag_delay_count : 0
        , last_update_time : ""
        , update_text : ""

        , items : []
        , categories : []

        , loading_flag : false
    }
    , actions : {
        GET_ITEMS(context) { // 베스트 상품 리스트
            let ajax_data = {"cate_code" : context.getters.cate_code, "current_page" : context.getters.current_page};
            $.ajax({
                type: "GET"
                , url: apiurlv2 + '/best/list'
                , data : ajax_data
                , ContentType: "json"
                , crossDomain: true
                , xhrFields: {
                    withCredentials: true
                }
                , success: function (data) {
                    context.commit('SET_ITEMS', data.items);
                    context.commit('SET_LAST_PAGE', data.last_page);
                    context.commit('SET_FLAG_DELAY_COUNT', data.flag_delay_count);
                    context.commit('SET_LAST_UPDATE_TIME', data.last_update_time);

                    fnAmplitudeEventObjectAction('view_best_main', {
                        'category_code' : context.getters.cate_code
                        , 'category_name' : context.getters.cate_name
                        , 'paging_index' : context.getters.current_page
                    });
                }
                , error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
        , GET_CATEGORIES(context) { // GET 카테고리 리스트
            $.ajax({
                type: "GET"
                , url: apiurlv2 + '/best/categories'
                , data : {}
                , ContentType: "json"
                , crossDomain: true
                , xhrFields: {
                    withCredentials: true
                }
                , success: function (data) {
                    context.commit('SET_CATEGORIES', data.categories);
                }
                , error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
        , GET_MORE_ITEMS(context){ //다음페이지 상품 리스트 추가
            if(!context.getters.loading_flag){
                context.commit('SET_LOADING_FLAG', true);

                context.commit('SET_CURRENT_PAGE', context.getters.current_page + 1);
                let ajax_data = {
                    "cate_code" : context.getters.cate_code
                    , "current_page" : context.getters.current_page
                    , "flag_delay_count" : context.getters.flag_delay_count
                };
                $.ajax({
                    type: "GET"
                    , url: apiurlv2 + '/best/list'
                    , data : ajax_data
                    , ContentType: "json"
                    , crossDomain: true
                    , xhrFields: {
                        withCredentials: true
                    }
                    , success: function (data) {
                        context.commit('SET_MORE_ITEMS', data.items);
                        context.commit('SET_LAST_PAGE', data.last_page);
                        context.commit('SET_FLAG_DELAY_COUNT', data.flag_delay_count);
                        context.commit('SET_LAST_UPDATE_TIME', data.last_update_time);
                    }
                    , error: function (xhr) {
                        console.log(xhr.responseText);
                    }
                    , complete: function(){
                        context.commit('SET_LOADING_FLAG', false);
                    }
                });
            }

        }
    }
    , mutations : {
        SET_ITEMS(state, data) { // SET 기간
            state.items = data;
        }
        , SET_LAST_PAGE(state, data){
            state.last_page = data;
        }
        , SET_CATEGORIES(state, data){
            state.categories = data;
        }
        , SET_MORE_ITEMS(state, data){
            state.items = state.items.concat(data);
        }
        , SET_CATE_CODE(state, data){
            state.cate_code = data;
        }
        , SET_CATE_NAME(state, data){
            state.cate_name = data;
        }
        , SET_CURRENT_PAGE(state, data){
            state.current_page = data;
        }
        , SET_FLAG_DELAY_COUNT(state, data){
            state.flag_delay_count = data;
        }
        , SET_LAST_UPDATE_TIME(state, data){
            state.last_update_time = data;

            const now = new Date();
            let update_text = "";

            if(now.getHours() == data) {
                switch (data) {
                    case '00' :
                        update_text = "오전 0시의 따끈한 랭킹!";
                        break;
                    case '03' :
                        update_text = "오전 3시의 따끈한 랭킹!";
                        break;
                    case '06' :
                        update_text = "오전 6시의 따끈한 랭킹!";
                        break;
                    case '09' :
                        update_text = "오전 9시의 따끈한 랭킹!";
                        break;
                    case '12' :
                        update_text = "오후 12시의 따끈한 랭킹!";
                        break;
                    case '15' :
                        update_text = "오후 3시의 따끈한 랭킹!";
                        break;
                    case '18' :
                        update_text = "오후 6시의 따끈한 랭킹!";
                        break;
                    case '21' :
                        update_text = "오후 9시의 따끈한 랭킹!";
                        break;
                }
            }else {
                console.log(new Date(now.getFullYear(), now.getMonth(), now.getDate(), 17, 30, 0));

                if (now >= new Date(now.getFullYear(), now.getMonth(), now.getDate(), 1, 0, 0) && now < new Date(now.getFullYear(), now.getMonth(), now.getDate(),2, 30, 0)) {
                    update_text = "야심한 새벽, 다들 뭐 살까?";
                } else if (now >= new Date(now.getFullYear(), now.getMonth(), now.getDate(), 4, 0 , 0) && now < new Date(now.getFullYear(), now.getMonth(), now.getDate(), 5, 30, 0)) {
                    update_text = "모두 잠들고 나만 보는 랭킹";
                } else if (now >= new Date(now.getFullYear(), now.getMonth(), now.getDate(), 7 , 0, 0) && now < new Date(now.getFullYear(), now.getMonth(), now.getDate(), 8, 30, 0)) {
                    update_text = "상쾌한 아침의 따끈한 랭킹";
                } else if (now >= new Date(now.getFullYear(), now.getMonth(), now.getDate(), 10, 0, 0) && now < new Date(now.getFullYear(), now.getMonth(), now.getDate(), 11, 30, 0)) {
                    update_text = "활기찬 오전의 베스트 랭킹";
                } else if (now >= new Date(now.getFullYear(), now.getMonth(), now.getDate(), 13, 0, 0) && now < new Date(now.getFullYear(), now.getMonth(), now.getDate(), 14, 30, 0)) {
                    update_text = "즐거운 점심시간의 베스트 랭킹";
                } else if (now >= new Date(now.getFullYear(), now.getMonth(), now.getDate(), 16, 0, 0) && now < new Date(now.getFullYear(), now.getMonth(), now.getDate(), 17, 30, 0)) {
                    update_text = "나른한 오후의 베스트 랭킹";
                } else if (now >= new Date(now.getFullYear(), now.getMonth(), now.getDate(), 19, 0, 0) && now < new Date(now.getFullYear(), now.getMonth(), now.getDate(), 20, 30, 0)) {
                    update_text = "평온한 저녁의 따끈한 랭킹";
                } else if (now >= new Date(now.getFullYear(), now.getMonth(), now.getDate(), 22, 0, 0) && now < new Date(now.getFullYear(), now.getMonth(), now.getDate(), 23, 30, 0)) {
                    update_text = "오늘 하루 다들 뭐 샀을까?";
                }
            }

            state.update_text = update_text;
        }
        , SET_LOADING_FLAG(state, data){
            state.loading_flag = data;
        }
        , UPDATE_PRODUCT_WISH(state, payload) { // 상품 위시 변경
            let products = state.items;

            for( let i=0 ; i<products.length ; i++ ) {
                if( Number(products[i].item_id) === Number(payload.item_id) ) {
                    products[i].wish_yn = payload.on_flag;
                    return;
                }
            }

            fnAmplitudeEventObjectAction('click_wish', {
                "item_id" : item_id
                , "ranking" : ranking
                , "interfere" : flag_text && flag_text != "" ? "y" : "n"
            });
        }
    }
    , getters : {
        current_page(state){
            return state.current_page;
        }
        , cate_code(state){
            return state.cate_code;
        }
        , cate_name(state){
            return state.cate_name;
        }
        , items(state) { // 기간
            return state.items;
        }
        , last_page(state){
            return state.last_page;
        }
        , categories(state){
            return state.categories;
        }
        , flag_delay_count(state){
            return state.flag_delay_count;
        }
        , last_update_time(state){
            return state.last_update_time;
        }
        , update_text(state){
            return state.update_text;
        }
        , loading_flag(state){
            return state.loading_flag;
        }
    }
});