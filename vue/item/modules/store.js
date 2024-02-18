var dataUrl = "/apps/appcom/wish/webapi/item/";
var data_itemLists = dataUrl+"getJustSoldList.asp";

var store = new Vuex.Store({
    state : {
        params : {
            category : '',
            page : 1,
            pageSize : 20,
            totalPage : 0,
            totalCount : 0,
        },
        itemLists : [],
        categories : [],
        isLoading : false,
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
        },
        SET_CATEGORIES(state, payload) {
            if( payload.categories ) {
                payload.categories.forEach(c => {
                    if( c.catecode == null )
                        c.catecode = '';
                    state.categories.push({
                        catecode : c.catecode,
                        catename : c.catename
                    });
                });
            }
        },
        UPDATE_LOADING(state, payload) {
            state.isLoading = payload;
        }
    },
    actions : {
        // API 는 여기서 호출
        GET_ITEMLISTS : function(context) {
            context.commit('UPDATE_LOADING', true);

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
                context.commit('UPDATE_LOADING', false);
            }, function(reason) {
                console.log(reason);
            });
        },
        /**
         * 카테고리 리스트 조회
         */
        GET_CATEGORIES(context) {
            const uri = '/category/topDispCateList';
            const data = { allFlag : true };
            const success = data => context.commit('SET_CATEGORIES', data);
            getFrontApiData('GET', uri, data, success);
        }
    }
})