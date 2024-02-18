var dataurl = "/christmas/2020/";
var data_itemlists = dataurl+"getitemlist.asp";

var store = new Vuex.Store({
    state : {
        params : {
            masterCode : '1',
            category : '-1',
            page : 1,
            pageSize : 24,
            listType : 'B',
            isPick : '',
            totalPage : 0,
            totalCount : 0,
            pageBlock : 10,
            sorted : 8,
        },
        eventLists : [],
        itemLists : [],
        mdPickItemLists : [],
        partitionItemLists : [],
        slideLists : [],
        tempItemId : '',
    },
    getters : {
        getPartitionItemListSorting : function(state) {
            function compare(a, b) {
                if (parseInt(a.category) < parseInt(b.category)) {
                    return -1;
                }
                if (parseInt(a.category) > parseInt(b.category)) {
                    return 1;
                }
                return 0;
            }
            return state.partitionItemLists.sort(compare);
        },
    },
    mutations : {
        SET_MASTERCODE : function(state , payload) {
            state.params.masterCode = payload;
        },
        SET_CATEGORY : function(state , payload) {
            state.params.category = payload;
            state.params.page = 1; // 카테고리 변경시 페이징 넘버 1 초기화
        },
        SET_ISPICK : function(state , payload) {
            state.params.isPick = payload.isPick;
        },
        SET_PAGESIZE : function(state , payload) {
            state.params.pageSize = payload.pageSize;
        },
        SET_LIMITCOUNT : function(state, payload) {
            state.params.itemShowLimitCount = payload.itemShowLimitCount;
        },
        SET_PARTITIONLIMITCOUNT : function(state , payload) {
            state.partitionItemLists[payload.index].itemShowLimitCount = payload.itemShowLimitCount;
        },
        SET_PAGENUMBER : function(state , payload) {
            state.params.page = payload;
        },
        SET_TEMPITEMID : function(state , payload) {
            state.tempItemId = payload;
        },
        CLEAR_TEMPITEMID : function(state) {
            state.tempItemId = "";
        },
        CLEAR_ITEMLISTS : function(state) {
            state.itemLists = [];
        },
        CLEAR_SLIDELISTS : function(state) {
            state.slideLists = [];
        },
        CLEAR_EVENTLISTS : function(state) {
            state.eventLists = [];
        },
        CLEAR_ISPICK : function(state) {
            state.params.isPick = '';
        },
        CLEAR_MDPICKITEMLISTS : function(state) {
            state.mdPickItemLists = [];
        },
        GET_EVENTLISTS : function(state , payload) {
            state.eventLists = payload;
        },
        GET_SLIDELISTS : function(state , payload) {
            state.slideLists = payload;
        },
        GET_ITEMLISTS : function(state , payload) {
            console.log(payload.itemlist);
            if (state.itemLists==null){
                state.itemLists = payload.itemlist;
            }
            else{
                $.each(payload.itemlist, function(key,value) {
                    state.itemLists.push(value);
                });
            }
            state.params.totalPage = payload.listtotalpage;
            state.params.totalCount = payload.listtotalcount;
        },
        GET_PARTITIONITEMLISTS : function(state , payload) {
            state.partitionItemLists.push(payload);
        },
        GET_MDPICKITEMLISTS : function(state , payload) {
            state.mdPickItemLists = payload.itemlist;
            state.params.totalPage = payload.listtotalpage;
            state.params.totalCount = payload.listtotalcount;
        },
        SET_IS_LOADING(state, is_loading) {
            state.is_loading = is_loading;
        },
        SET_SORT(state , payload) {
            state.params.sorted = payload;
            state.params.page = 1; // 카테고리 변경시 페이징 넘버 1 초기화
        },
    },
    actions : {
        // API 는 여기서 호출
        GET_ITEMLISTS : function(context) {
            let _self = this.state.params;
            let _url = data_itemlists + "?mastercode="+ _self.masterCode +"&detailcode="+ _self.category +"&page="+ _self.page +"&pagesize="+ _self.pageSize +"&listtype="+ _self.listType +"&ispick="+ _self.isPick +"&sorted="+ _self.sorted;
            let isPick = _self.isPick;

            let getData = new Promise(function(resolve , reject) {
                $.getJSON(_url, function(response) {
                    if (response) {
                        resolve(response);
                    }
                    reject(new Error("Json Data Not Loaded"));
                });
            });

            getData.then(function(data) {
                isPick != '' ? function() {
                    context.commit('CLEAR_MDPICKITEMLISTS');
                    context.commit('GET_MDPICKITEMLISTS',data);
                }() : function() {
                    context.commit('GET_ITEMLISTS',data);
                }()
                //console.log(data);
            }, function(reason) {
                console.log(reason);
            });
        },
        GET_PARTITIONITEMLISTS : function(context) {
            var _self = this.state.params;
            var _url = data_itemlists + "?mastercode="+ _self.masterCode +"&detailcode="+ _self.category +"&page="+ _self.page +"&pagesize="+ _self.pageSize +"&listtype="+ _self.listType +"&ispick="+ _self.isPick;

            var _payload = {
                category : _self.category,
                itemShowLimitCount : _self.itemShowLimitCount,
                items : []
            };

            var getData = new Promise(function(resolve , reject) {
                $.getJSON(_url, function(response) {
                    if (response) {
                        resolve(response);
                    }
                    reject(new Error("Json Data Not Loaded"));
                });
            });

            getData.then(function(data) {
                _payload.items = data.itemlist;
                context.commit('GET_PARTITIONITEMLISTS',_payload);
            }, function(reason) {
                console.log(reason);
            });
        },
    },
})