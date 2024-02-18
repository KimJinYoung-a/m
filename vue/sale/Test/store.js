const decodeBase64 = function(str) {
    if( str == null ) return null;
    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
}

let store = new Vuex.Store({
    state : {
        wonder_products: { // 뭐 없을까 싶을 때 상품 리스트
            best: [],
            steady: [],
            sale: [],
            new: [],
            clearance: []
        },
        titles: [

        ], // 뭐 없을까 싶을 때 탭 타이틀 리스트
        active_wonder_type: null, // 쿼 없을까 싶을 때 활성화 된 구분값
    },
    getters : {
        wonder_products : function(state) { // 뭐 없을까 싶을 때 상품 리스트
            return state.wonder_products;
        },
        titles : function(state) { // 뭐 없을까 싶을 때 탭 타이틀 리스트
            return state.titles;
        },
        active_wonder_type : function(state) { // 뭐 없을까 싶을 때 탭 타이틀 리스트
            return state.active_wonder_type;
        },
    },
    mutations : {
        SET_WONDERS : function (state, wonders) { // SET 뭐 없을까 싶을 때
            for( let i=0 ; i<wonders.length ; i++ ) {
                const wonder = wonders[i];

                if( i===0 ) {
                    state.active_wonder_type = wonder.type;
                }

                state.titles.push({
                    text : wonder.title,
                    value : wonder.type,
                    is_active : i === 0
                });

                state.wonder_products[wonder.type] = [];
                for( let j=0 ; j<wonder.items.length ; j++ ) {
                    if( wonder.items[j].item_image != null )
                        wonder.items[j].item_image = decodeBase64(wonder.items[j].item_image);

                    wonder.items[j].move_url = decodeBase64(wonder.items[j].move_url);
                    state.wonder_products[wonder.type].push(wonder.items[j]);
                }
            }
        },
        SET_ACTIVE_WONDER_TYPE : function (state, type) {
            state.active_wonder_type = type;
        },
    },
    actions : {
        GET_MAIN_ITEMS : function(context) { // 메인 아이템들 state에 저장
            const category_main_apiurl = apiurl + '/category/main/102';

            $.ajax({
                type: "GET",
                url: category_main_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log(data);
                    // 뭐 없을 까 싶을 때
                    context.commit('SET_WONDERS', data.wonders);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
    }
});