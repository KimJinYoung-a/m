const store = new Vuex.Store({
    state : {
        top_banner : '',
        open_items : [],
        wait_items : [],
        soldout_items : [],
        comments : [],
        currentPage : '',
        totalCount : '',
        pageSize : '',
        lastPage : ''
    },
    mutations : {
        SET_TOP_BANNER(state, topBanner) {
            state.top_banner = topBanner;
        },
        SET_OPEN_ITEMS(state, items) {
            state.open_items = items;
        },
        SET_WAIT_ITEMS(state, items) {
            state.wait_items = items;
        },
        SET_SOLDOUT_ITEMS(state, items) {
            state.soldout_items = items;
        },
        SET_COMMENTS(state, comments) {
            state.comments = comments;
        },
        SET_PAGE_SIZE(state, pageSize) {
            state.pageSize = pageSize;
        },
        SET_CURRENT_PAGE(state, currentPage) {
            state.currentPage = currentPage;
        },
        SET_TOTAL_COUNT(state, totalCount) {
            state.totalCount = totalCount;
        },
        SET_LAST_PAGE(state, lastPage) {
            state.lastPage = lastPage;
        }
    }
    , actions : {
        GET_TOP_BANNER(context){
            // 하드 코딩용
            let topBanner = "http://fiximage.10x10.co.kr/m/2021/tenten/top.gif?ver=1.1";
            context.commit('SET_TOP_BANNER', topBanner);
        },
        GET_OPEN_ITEMS(context) {
            getFrontApiData('GET', '/tenten-exclusive-real/open/items', {"isApp" : isApp}, data => {
                console.log("SET_OPEN_ITEMS", data);
                context.commit('SET_OPEN_ITEMS', data);
            });
        },
        GET_WAIT_ITEMS(context) {
            getFrontApiData('GET', '/tenten-exclusive-real/wait/items', '', data => {
                console.log("SET_WAIT_ITEMS", data);
                context.commit('SET_WAIT_ITEMS', data);
            });
        },
        GET_SOLDOUT_ITEMS(context) {
            getFrontApiData('GET', '/tenten-exclusive-real/soldout/items', {"isApp" : isApp}, data => {
                console.log("SET_SOLDOUT_ITEMS", data);
                context.commit('SET_SOLDOUT_ITEMS', data);
            });
        },
        GET_COMMENT(context, data) {

            $.ajax({
                type : 'GET',
                url: apiurl+'/tenten-exclusive-real/comments',
                data: data,
                ContentType : "json",
                crossDomain: true,
                async: false,
                xhrFields: {
                    withCredentials: true
                }
                , success: function(data) {
                    context.commit('SET_COMMENTS', data.comments);
                    context.commit('SET_CURRENT_PAGE', data.currentPage);
                    context.commit('SET_TOTAL_COUNT', data.totalCount);
                    context.commit('SET_LAST_PAGE', data.lastPage);
                    context.commit('SET_PAGE_SIZE', data.pageSize);
                }
                , error: function (xhr) {
                    console.log(xhr);
                }
            });
        }
    }
    , getters : {
        top_banner(state) {
            return state.top_banner;
        },
        open_items(state) {
            return state.open_items;
        },
        wait_items(state) {
            return state.wait_items;
        },
        soldout_items(state) {
            return state.soldout_items;
        },
        comments(state) {
            return state.comments;
        },
        pageSize(state) {
            return state.pageSize;
        },
        currentPage(state) {
            return state.currentPage;
        },
        totalCount(state) {
            return state.totalCount;
        },
        lastPage(state) {
            return state.lastPage;
        }
    }
});