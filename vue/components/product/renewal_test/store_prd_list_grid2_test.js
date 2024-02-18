String.prototype.replaceAll = (searchStr, replaceStr) => { return this.split(searchStr).join(replaceStr) }

var store = new Vuex.Store({
    state : {
        items : []
    },
    getters : {
        items(state) {
            return state.items;
        }
    },
    mutations : {
        SET_ITEMS(state, payload) { // Set 상품 리스트
            if( payload == null )
                return;

            let items = [];
            for( let idx=0 ; idx < payload.length ; idx++ ) {
                let temp_item = payload[idx];

                let decodeBase64 = (str) => { return (str != null && str != '') ? atob(str.replace(/_/g, '/').replace(/-/g, '+')) : '' }

                // Decode Base64
                temp_item.item_image = decodeBase64(temp_item.item_image);
                temp_item.move_url = decodeBase64(temp_item.move_url);

                items.push(temp_item);
            }
            state.items = items;
        }
    },
    actions : {
        GET_PRODUCTS(context) { // 상품 리스트 state에 저장
            var _url = apiurl + '/category/cateWonder?catecode=102';

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
                    context.commit('SET_ITEMS', data.sale_item);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
    }
});