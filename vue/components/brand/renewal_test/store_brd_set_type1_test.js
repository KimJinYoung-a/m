// Decode Base64
function decodeBase64(str) {
    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
}

var store = new Vuex.Store({
    state : {
        brand : {}
    },
    getters : {
        brand : function(state) {
            return state.brand;
        }
    },
    mutations : {
        SET_BRAND : function(state, payload) { // Set 브랜드
            if( payload == null )
                return;

            let brand = payload;
            brand.main_image = decodeBase64(brand.main_image);

            for( let idx=0 ; idx < brand.items.length ; idx++ ) {
                brand.items[idx].item_image = decodeBase64(brand.items[idx].item_image);
            }
            state.brand = brand;
        }
    },
    actions : {
        GET_BRAND : function(context) { // 브랜드 state에 저장
            const _url = apiurl + '/category/main/102';

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
                    context.commit('SET_BRAND', data.contents.brand);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
    }
});