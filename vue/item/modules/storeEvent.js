var dataUrl = "/apps/appcom/wish/webapi/item/";
var data_itemLists = dataUrl+"getJustSoldEventList.asp";

var store = new Vuex.Store({
    state : {
        params : {
            category : '',
            page : 1,
            pageSize : 100,
            totalPage : 0,
            totalCount : 0,
        },
        itemLists : [],
    },
    mutations : {
        SET_CATEGORY : function(state , payload) {
            state.params.category = payload;
            state.params.page = 1; // 카테고리 변경시 페이징 넘버 1 초기화
        },
        SET_PAGENUMBER : function(state , payload) {
            state.params.page = payload;
        },
        SET_PAGESIZE : function(state , payload) {
            state.params.pageSize = payload.pageSize;
        },
        CLEAR_ITEMLISTS : function(state) {
            state.itemLists = [];
        },
        SET_ITEMLISTS : function(state , payload) {
            state.itemLists = payload;
        },
        SET_ADDITEMLISTS : function(state , payload) {
            $.each(payload.itemlist , function(key,value) {
                state.itemLists.push(value);
            });
        }
    },
    actions : {
        // API 는 여기서 호출
        GET_ITEMLISTS : function(context) {
            let _self = this.state.params;
            let _itemLists = this.state.itemLists;
            let _url = data_itemLists + "?catecode="+ _self.category +"&page="+ _self.page + "&pagesize=" + _self.pageSize;

            let getData = new Promise(function(resolve , reject) {
                $.getJSON(_url, function(response) {
                    if (response) {
                        resolve(response);
                    }
                    reject(new Error("Json Data Not Loaded"));
                });
            });

            getData.then(function(data) {
                if (_itemLists == '') {
                    context.commit('SET_ITEMLISTS',data.itemlist);
                } else {
                    context.commit('SET_ADDITEMLISTS',data);
                }
            }, function(reason) {
                console.log(reason);
            });
        },
    }
})