const decodeBase64 = function(str) {
    if( str == null ) return null;
    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
}

let store = new Vuex.Store({
    state : {
        rolling_products : [], // 특별한 가격의 보물을 찾아보세요 상품 리스트
        limit_stock_products : [], // 몇 개 안 남았어요! 상품 리스트
        just_sold_products : [], // 방금 판매되었어요 상품 리스트
        categories : [{ // 카테고리 리스트
            catecode : 0,
            catename : '전체'
        }],
        more_treasure_products : [], // 더 많은 보물이 기다리고있어요 상품 리스트
    },
    getters : {
        rolling_products(state) { // 특별한 가격의 보물을 찾아보세요 상품 리스트
            return state.rolling_products;
        },
        limit_stock_products(state) { // 몇 개 안 남았어요! 상품 리스트
            return state.limit_stock_products;
        },
        just_sold_products(state) { // 방금 판매되었어요 상품 리스트
            return state.just_sold_products;
        },
        categories(state) { // 카테고리 리스트
            return state.categories;
        },
        more_treasure_products(state) { // 더 많은 보물이 기다리고있어요 상품 리스트
            return state.more_treasure_products;
        }
    },
    mutations : {
        SET_ROLLING_PRODUCTS(state, items) { // SET 특별한 가격의 보물을 찾아보세요 상품 리스트
            if( items != null ) {
                let temp_rolling_products = [];
                for( let i=0 ; i<items.length ; i++ ) {
                    items[i].item_image = decodeBase64(items[i].item_image);

                    temp_rolling_products.push(items[i]);
                }
                state.rolling_products = temp_rolling_products;
            }
        },
        SET_LIMIT_STOCK_PRODUCTS(state, items) { // SET 몇 개 안 남았어요! 상품 리스트
            if( items != null ) {
                let temp_limit_stock_products = [];
                for( let i=0 ; i<items.length ; i++ ) {
                    if( items[i].item_image != null )
                        items[i].item_image = decodeBase64(items[i].item_image);

                    temp_limit_stock_products.push(items[i]);
                }
                state.limit_stock_products = temp_limit_stock_products;
            }
        },
        SET_JUST_SOLD_PRODUCTS(state, items) { // SET 방금 판매되었어요 상품 리스트
            if( items != null ) {
                let temp_just_sold_products = [];
                for( let i=0 ; i<items.length ; i++ ) {
                    if( items[i].big_image != null )
                        items[i].big_image = decodeBase64(items[i].big_image);
                    if( items[i].list_image != null )
                        items[i].list_image = decodeBase64(items[i].list_image);

                    temp_just_sold_products.push(items[i]);
                }
                state.just_sold_products = temp_just_sold_products;
            }
        },
        SET_MORE_TREASURE_PRODUCTS(state, items) { // 더 많은 보물이 기다리고있어요 상품 리스트
            if( items != null ) {
                let temp_more_treasure_products = [];
                for( let i=0 ; i<items.length ; i++ ) {
                    if( items[i].big_image != null )
                        items[i].big_image = decodeBase64(items[i].big_image);
                    if( items[i].list_image != null )
                        items[i].list_image = decodeBase64(items[i].list_image);

                    items[i].move_url = decodeBase64(items[i].move_url);
                    temp_more_treasure_products.push(items[i]);
                }
                state.more_treasure_products = temp_more_treasure_products;
            } else {
                state.more_treasure_products = [];
            }
        },
        SET_CATEGORIES(state, categories) { // SET 카테고리 리스트
            for( let i=0 ; i<categories.length ; i++ ) {
                if( categories[i].catecode !== '123' ) {
                    state.categories.push({
                        catecode: Number(categories[i].catecode),
                        catename: categories[i].catename
                    });
                }
            }
        },
        UPDATE_PRODUCT_WISH(state, payload) { // 상품 위시 변경
            let products;

            switch (payload.wish_type) {
                case 'stock': products = state.limit_stock_products; break; // 몇 개 안 남았어요!
                case 'just_sold': products = state.just_sold_products; break; // 방금 판매되었어요
                case 'more_treasure': products = state.more_treasure_products; break; // 더 많은 보물이 기다리고있어요
                default : products = [];
            }

            for( let i=0 ; i<products.length ; i++ ) {
                if( Number(products[i].item_id) === Number(payload.item_id) ) {
                    products[i].wish_yn = payload.on_flag;
                    return;
                }
            }
        }
    },
    actions : {
        GET_ROLLING_PRODUCTS(context) { // GET 특별한 가격의 보물을 찾아보세요 상품 리스트
            const rolling_products_apiurl = apiurl + '/clearance/disCountSegments';

            $.ajax({
                type: "GET",
                url: rolling_products_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('rolling_products', data);
                    context.commit('SET_ROLLING_PRODUCTS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_LIMIT_STOCK_PRODUCTS(context) { // GET 몇 개 안 남았어요! 상품 리스트
            const limit_stock_products_apiurl = apiurl + '/clearance/limitLowStocks';

            $.ajax({
                type: "GET",
                url: limit_stock_products_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('limit_stock_products', data);
                    context.commit('SET_LIMIT_STOCK_PRODUCTS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_JUST_SOLD_PRODUCTS(context) { // GET 방금 판매되었어요 상품 리스트
            const just_sold_products_apiurl = apiurl + '/clearance/justSolds';

            $.ajax({
                type: "GET",
                url: just_sold_products_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('just_sold_products', data);
                    context.commit('SET_JUST_SOLD_PRODUCTS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_CATEGORIES(context) {
            const categories_apiurl = apiurl + '/category/topDispCateList?appFlag=false';

            $.ajax({
                type: "GET",
                url: categories_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('categories', data);
                    context.commit('SET_CATEGORIES', data.categories);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_MORE_TREASURE_PRODUCTS(context, catecode) { // 더 많은 보물이 기다리고있어요 상품 리스트
            let more_treasure_products_apiurl = apiurl + '/clearance/Items'
                    + '?page=1&page_size=8';
            if( catecode !== 0 ) {
                more_treasure_products_apiurl += '&catecode=' + catecode;
            }

            $.ajax({
                type: "GET",
                url: more_treasure_products_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('more_treasure_products', data);
                    context.commit('SET_MORE_TREASURE_PRODUCTS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
    }
});