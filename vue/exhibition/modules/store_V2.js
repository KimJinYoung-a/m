var dataurl = "/apps/appcom/wish/webapi/exhibition/";
var data_itemlists = dataurl+"getitemlist.asp";
var data_eventlists = dataurl+"geteventlist.asp";
var data_slidelists = dataurl+"getslidelist.asp";

var store = new Vuex.Store({
    state : {
        params : {
            masterCode : '1',
            category : '-1',
            page : 1,
            pageSize : 24,
            listType : 'A',
            isPick : '',
            totalPage : 0,
            totalCount : 0,
            pageBlock : 10,
            itemShowLimitCount : 0,
        },
        itemLists : [],
        partitionItemLists : [],
        tempItemId : '',
    },
    getters : {
        /*getPartitionItemListSorting : function(state) {
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
        }*/
    },
    mutations : {
        SET_MASTERCODE : function(state , payload) {
            state.params.masterCode = payload;
        },
        SET_CATEGORY : function(state , payload) {
            state.params.category = payload;
            state.params.page = 1; // 카테고리 변경시 페이징 넘버 1 초기화
        },
        SET_PAGESIZE : function(state , payload) {
            state.params.pageSize = payload.pageSize;
        },
        SET_LIMITCOUNT : function(state, payload) {
            state.params.itemShowLimitCount = payload.itemShowLimitCount;
        }
        , SET_PARTITIONLIMITCOUNT : function(state , payload) {
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
        GET_PARTITIONITEMLISTS : function(state , payload) {
            state.partitionItemLists.push(payload);
        }
    },
    actions : {
        GET_ITEMLIST : function(context) {
            var _self = this.state.params;
            var _url = apiurl + "/tempEvent/love-is-now?masterCode="+ _self.masterCode +"&detailCode="+ _self.category +"&page="+ _self.page +"&pageSize="+ _self.pageSize +"&listtype="+ _self.listType +"&ispick="+ _self.isPick + "&deviceType=m";

            var _payload = {
                category : _self.category,
                itemShowLimitCount : _self.itemShowLimitCount,
                items : []
            };

            var getData = new Promise(function(resolve , reject) {
                $.ajax({
                    type: "GET",
                    url: _url,
                    ContentType: "json",
                    crossDomain: true,
                    xhrFields: {
                        withCredentials: true
                    },
                    success: function (data) {
                        return resolve(data);
                    },
                    error: function (xhr) {
                        console.log(xhr.responseText);
                        return reject();
                    }
                });
            });

            getData.then(function(data) {
                _payload.items = data.itemList;
                context.commit('GET_PARTITIONITEMLISTS', _payload);
            }, function(reason) {
                console.log(reason);
            });
        }
    }
});