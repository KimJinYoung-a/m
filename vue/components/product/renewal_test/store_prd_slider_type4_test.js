// 파라미터를 java Array 변수로 return
function getParametersObject() {
    var url = unescape(location.href);
    var paramArr = (url.substring(url.indexOf("?")+1,url.length)).split("&");

    var returnObject = {};
    for(var i = 0 ; i < paramArr.length ; i++){
        var temp = paramArr[i].split("=");
        returnObject[temp[0]] = temp[1];
    }
    return returnObject;
}

String.prototype.replaceAll = (searchStr, replaceStr) => { return this.split(searchStr).join(replaceStr) }

var store = new Vuex.Store({
    state : {
        items : []
    },
    getters : {
        items : function(state) {
            return state.items;
        }
    },
    mutations : {
        SET_ITEMS : function(state, payload) { // Set 상품 리스트
            if( payload == null )
                return;

            let items = [];
            for( let idx=0 ; idx < payload.length ; idx++ ) {
                let temp_item = payload[idx];

                let decodeBase64 = (str) => { return (str != null && str != '') ? atob(str.replace(/_/g, '/').replace(/-/g, '+')) : '' }

                // Decode Base64
                temp_item.list_image = decodeBase64(temp_item.list_image);
                temp_item.move_url = decodeBase64(temp_item.move_url);

                items.push(temp_item);
            }
            state.items = items;
        }
    },
    actions : {
        GET_PRODUCTS : function(context) { // 상품 리스트 state에 저장
            const brand_id = getParametersObject().brand_id;
            if( brand_id == null )
                return;

            const _url = apiurl + '/new/items/more?brand_id=' + brand_id;

            $.ajax({
                type : "GET",
                url: _url,
                ContentType : "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function(data) {
                    console.log(data);
                    context.commit('SET_ITEMS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
    }
});