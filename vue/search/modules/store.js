//var dataurl = "/apps/appcom/wish/webapi/exhibition/";
//var data_itemlists = dataurl+"getitemlist.asp";
//var data_eventlists = dataurl+"geteventlist.asp";
//var data_slidelists = dataurl+"getslidelist.asp";
var data_keywordSearch = "/api/web/v1/search/keywordSearch/"

var store = new Vuex.Store({
    state : {
        params : {
            deliType : '',
            dispCategories : '',
            keywords : '',
            makerIds : '',
            maxPrice : '',
            minPrice : '',
        },
        keywordSearchLists : [],
        //tempItemId : '',
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
        SET_DELITYPE : function(state, payload) {
            state.params.deliType = payload;
        },
        SET_DISPCATEGORIES : function(state, payload) {
            state.params.dispCategories = payload;
        },
        SET_MAKERIDS : function(state, payload) {
            state.params.makerIds = payload;
        },
        SET_MAXPRICE : function(state, payload) {
            state.params.maxPrice = payload;
        },
        SET_MINPRICE : function(state, payload) {
            state.params.minPrice = payload;
        },      
        SET_KEYWORDS : function(state , payload) {
            state.params.keywords = payload;
        },
        CLEAR_KEYWORDSEARCHLISTS : function(state) {
            state.keywordSearchLists = [];
        },
        GET_KEYWORDSEARCHLISTS : function(state , payload) {
            state.itemLists = payload.itemlist;
        },
    },
    actions : {
        // API 는 여기서 호출
        GET_KEYWORDSEARCHLISTS : function(context) {
            let _self = this.state.params;
            let _url = data_keywordSearch + "?deliType="+ _self.deliType +"&dispCategories="+ _self.dispCategories +"&keywords="+ _self.keywords +"&makerids="+ _self.makerIds +"&maxPrice="+ _self.maxPrice +"&minPrice="+ _self.minPrice;
            //let isPick = _self.isPick;

            let getData = new Promise(function(resolve , reject) {
                $.getJSON(_url, function(response) {
                    if (response) {
                        resolve(response);
                    }
                    reject(new Error("Json Data Not Loaded"));
                });
            });
            
            /*
            getData.then(function(data) {
                isPick != '' ? function() {
                    context.commit('CLEAR_MDPICKITEMLISTS');
                    context.commit('GET_MDPICKITEMLISTS',data);
                }() : function() {
                    context.commit('CLEAR_ITEMLISTS');
                    context.commit('GET_ITEMLISTS',data);
                }()
            }, function(reason) {
                console.log(reason);
            });
            */
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