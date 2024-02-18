const decodeBase64 = function(str) {
    if( str == null ) return null;
    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
}

let store = new Vuex.Store({
    state : {
        rolling_products: [], // 다음은 없을지도 모르는 할인 상품 리스트
        my_sale_products: [], // ~님! 목이 빠지게 기다리셨죠? 상품 리스트
        wish_products: [], // 간절히 바랐던 모두의 위시 할인 상품 리스트
        categories : [{ // 카테고리 리스트
            catecode : 0,
            catename : '전체'
        }],
        list_products: [], // 지금 인기있는 세일상품 리스트
    },
    getters : {
        rolling_products(state) { // 다음은 없을지도 모르는 할인 상품 리스트
            return state.rolling_products;
        },
        my_sale_products(state) { // ~님! 목이 빠지게 기다리셨죠? 상품 리스트
            return state.my_sale_products;
        },
        categories(state) { // 카테고리 리스트
            return state.categories;
        },
        list_products(state) { // 지금 인기있는 세일상품 리스트
            return state.list_products;
        },
        wish_products(state) { // 간절히 바랐던 모두의 위시 할인 상품 리스트
            return state.wish_products;
        }
    },
    mutations : {
        SET_ROLLING_PRODUCTS(state, items) { // SET 다음은 없을지도 모르는 할인
            if( items != null ) {
                let temp_rolling_products = [];
                for( let i=0 ; i<items.length ; i++ ) {
                    items[i].item_image = decodeBase64(items[i].item_image);

                    temp_rolling_products.push(items[i]);
                }
                state.rolling_products = temp_rolling_products;
            }
        },
        SET_MY_SALE_PRODUCTS(state, items) { // SET ~님! 목이 빠지게 기다리셨죠? 상품 리스트
            if( items != null ) {
                let temp_my_sale_products = [];
                for( let i=0 ; i<items.length ; i++ ) {
                    items[i].item_image = decodeBase64(items[i].item_image);

                    temp_my_sale_products.push(items[i]);
                }
                state.my_sale_products = temp_my_sale_products;
            }
        },
        SET_WISH_PRODUCTS(state, items) { // SET 간절히 바랐던 모두의 위시 할인 상품 리스트
            if( items != null ) {
                let temp_wish_products = [];
                for( let i=0 ; i<items.length ; i++ ) {
                    if( items[i].item_image != null )
                        items[i].item_image = decodeBase64(items[i].item_image);

                    temp_wish_products.push(items[i]);
                }
                state.wish_products = temp_wish_products;
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
        SET_LIST_PRODUCTS(state, items) { // SET 지금 인기있는 세일상품 리스트
            state.list_products = [];
            if( items != null ) {
                for( let i=0 ; i<items.length ; i++ ) {
                    if( items[i].big_image != null )
                        items[i].big_image = decodeBase64(items[i].big_image);
                    if( items[i].list_image != null )
                        items[i].list_image = decodeBase64(items[i].list_image);

                    items[i].move_url = decodeBase64(items[i].move_url);
                    state.list_products.push(items[i]);
                }
            }
        },
        UPDATE_PRODUCT_WISH(state, payload) { // 상품 위시 변경
            let products;

            switch (payload.wish_type) {
                case 'rolling': products = state.rolling_products; break; // 다음은 없을지도 모르는 할인
                case 'wish': products = state.wish_products; break; // 간절히 바랐던 모두의 위시 할인
                case 'my_favorite': products = state.my_sale_products; break; // ~님! 목이 빠지게 기다리셨죠?
                case 'list': products = state.list_products; break; // 지금 인기있는 세일상품이에요
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
        GET_ROLLING_PRODUCTS(context) { // GET 다음은 없을지도 모르는 할인
            const rolling_products_apiurl = apiurl + '/sale/rolling';

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
        GET_MY_SALE_PRODUCTS(context) { // GET ~님! 목이 빠지게 기다리셨죠? 상품 리스트
            const my_sale_products_apiurl = apiurl + '/sale/myFav';

            $.ajax({
                type: "GET",
                url: my_sale_products_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('my_sale_products', data);
                    context.commit('SET_MY_SALE_PRODUCTS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_WISH_PRODUCTS(context) { // GET 간절히 바랐던 모두의 위시 할인 상품 리스트
            const wish_product_apiurl = apiurl + '/sale/bestWish';

            $.ajax({
                type: "GET",
                url: wish_product_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('wish_products', data);
                    context.commit('SET_WISH_PRODUCTS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_CATEGORIES(context) { // GET 카테고리 리스트
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
        GET_LIST_PRODUCTS(context, category_code) { // GET 지금 인기있는 세일상품 리스트
            let list_products_apiurl = apiurl + '/sale/all/main';
            if( category_code !== 0 ) {
                list_products_apiurl += '?catecode=' + category_code;
            }

            $.ajax({
                type: "GET",
                url: list_products_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('list_products', data);
                    context.commit('SET_LIST_PRODUCTS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
    }
});