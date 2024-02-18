const decodeBase64 = function(str) {
    if( str == null ) return null;
    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
}

let store = new Vuex.Store({
    state : {
        rolling_products: [], // 지금, 주목할만한 신상
        new_brands : [], // 새롭게 선보이는 브랜드
        zzim_brands : [], // ~님이 좋아하는 ~ 신상 도착 브랜드
        active_zzim_brands_index : 0, // ~님이 좋아하는 ~ 신상 도착 활성화 인덱스
        new_products : [], // 따끈따끈한 신상품이에요
        new_more_brand : { // 신상품 더보기 팝업 브랜드
            brand_id : '', // 브랜드ID
            brand_name : '', // 브랜드명
            item_count : 0, // 상품 수
            items : [], // 상품 리스트
            more_yn : false // 더보기 여부
        }
    },
    getters : {
        rolling_products(state) { // 지금, 주목할만한 신상
            return state.rolling_products;
        },
        new_brands(state) { // 새롭게 선보이는 브랜드
            return state.new_brands;
        },
        zzim_brands(state) { // ~님이 좋아하는 ~ 신상 도착 브랜드
            return state.zzim_brands;
        },
        active_zzim_brand(state) { // ~님이 좋아하는 ~ 신상 도착 활성화 브랜드
            return state.zzim_brands[state.active_zzim_brands_index];
        },
        new_products(state) { // 따끈따끈한 신상품이에요
            return state.new_products;
        },
        new_more_brand(state) { // 신상품 더보기 팝업 브랜드
            return state.new_more_brand;
        }
    },
    mutations : {
        SET_ROLLING_PRODUCTS(state, items) { // SET 지금, 주목할만한 신상
            if( items != null ) {
                for( let i=0 ; i<items.length ; i++ ) {
                    items[i].item_image = decodeBase64(items[i].item_image);
                }
                state.rolling_products = items;
            }
        },
        SET_NEW_BRANDS(state, brands) { // SET 새롭게 선보이는 브랜드
            if( brands != null ) {
                let temp_new_brands = [];
                for (let i = 0; i < brands.length; i++) {
                    if (brands[i].items != null) {
                        for (let j = 0; j < brands[i].items.length; j++) {
                            brands[i].items[j].item_image = decodeBase64(brands[i].items[j].item_image);
                        }
                    }
                    temp_new_brands.push(brands[i]);
                }
                state.new_brands = temp_new_brands;
            }
        },
        SET_ZZIM_BRANDS(state, brands) { // SET ~님이 좋아하는 ~ 신상 도착 브랜드
            if( brands != null ) {
                let temp_zzim_brands = [];
                for (let i = 0; i < brands.length; i++) {
                    if (brands[i].items != null) {
                        for (let j = 0; j < brands[i].items.length; j++) {
                            if( brands[i].items[j].big_image != null )
                                brands[i].items[j].big_image = decodeBase64(brands[i].items[j].big_image);

                            if( brands[i].items[j].list_image != null )
                                brands[i].items[j].list_image = decodeBase64(brands[i].items[j].list_image);
                        }
                    }
                    temp_zzim_brands.push(brands[i]);
                }
                state.zzim_brands = temp_zzim_brands;
            }
        },
        UPDATE_ACTIVE_ZZIM_BRAND_INDEX(state) { // SET ~님이 좋아하는 ~ 신상 도착 활성화 인덱스
            let zzim_brands_length = state.zzim_brands.length;
            if( zzim_brands_length > 0 && state.active_zzim_brands_index < (zzim_brands_length-1) ) {
                state.active_zzim_brands_index++;
            } else if ( zzim_brands_length > 1 ) {
                state.active_zzim_brands_index = 0;
            }
        },
        SET_NEW_PRODUCTS(state, items) { // SET 따끈따끈한 신상품이에요
            if( items != null ) {
                let temp_new_products = [];
                for( let i=0 ; i<items.length ; i++ ) {
                    if( i >= 8 )
                        break;

                    if( items[i].big_image != null )
                        items[i].big_image = decodeBase64(items[i].big_image);

                    if( items[i].list_image != null )
                        items[i].list_image = decodeBase64(items[i].list_image);

                    temp_new_products.push(items[i]);
                }
                state.new_products = temp_new_products;
            }
        },
        SET_NEW_MORE_BRAND(state, brand) { // SET 신상품 더보기 팝업 브랜드
            if( brand != null ) {
                if( brand.items != null ) {
                    for( let i=0 ; i<brand.items.length ; i++ ) {
                        if( brand.items[i].list_image != null )
                            brand.items[i].list_image = decodeBase64(brand.items[i].list_image);

                        if( brand.items[i].big_image != null )
                            brand.items[i].big_image = decodeBase64(brand.items[i].big_image);
                    }
                }
                state.new_more_brand = brand;
            }
        },
        CLEAR_NEW_MORE_BRAND(state) { // CLEAR 신상품 더보기 팝업 브랜드
            state.new_more_brand = {
                brand_id : '',
                brand_name : '',
                item_count : 0,
                items : [],
                more_yn : false
            }
        },
        UPDATE_PRODUCT_WISH(state, payload) { // 상품 위시 변경
            let products;

            switch (payload.wish_type) {
                case 'rolling': products = state.rolling_products; break; // 지금, 주목할만한 신상
                case 'zzim_brand': products = state.zzim_brands[state.active_zzim_brands_index].items; break; // ~님이 좋아하는 ~ 신상 도착
                case 'list': products = state.new_products; break; // 따끈따끈한 신상품이에요
                case 'more_new_product': products = state.new_more_brand.items; break; // 따끈따끈한 신상품이에요
                default : products = [];
            }

            for( let i=0 ; i<products.length ; i++ ) {
                if( Number(products[i].item_id) === Number(payload.item_id) ) {
                    products[i].wish_yn = payload.on_flag;
                    return;
                }
            }
        },
        UPDATE_BRAND_WISH(state, payload) { // UPDATE 새롭게 선보이는 브랜드 위시
            for( let i=0 ; i<state.new_brands.length ; i++ ) {
                if( state.new_brands[i].brand_id === payload.brand_id ) {
                    state.new_brands[i].wish_yn = payload.on_flag;
                    return;
                }
            }
        }
    },
    actions : {
        GET_ROLLING_PRODUCTS(context) { // GET 지금, 주목할만한 신상
            const rolling_products_apiurl = apiurl + '/new/rolling';

            $.ajax({
                type: "GET",
                url: rolling_products_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    context.commit('SET_ROLLING_PRODUCTS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_NEW_BRANDS(context) { // GET 새롭게 선보이는 브랜드
            const new_brand_apiurl = apiurl + '/new/brands';

            $.ajax({
                type: "GET",
                url: new_brand_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    context.commit('SET_NEW_BRANDS', data.brands);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_ZZIM_BRANDS(context) { // GET 새롭게 선보이는 브랜드
            const zzim_brand_apiurl = apiurl + '/new/zzim/brand';

            $.ajax({
                type: "GET",
                url: zzim_brand_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    context.commit('SET_ZZIM_BRANDS', data.brands);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_NEW_PRODUCTS(context) { // GET 따끈따끈한 신상품이에요
            const new_product_apiurl = apiurl + '/new/items';

            $.ajax({
                type: "GET",
                url: new_product_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    context.commit('SET_NEW_PRODUCTS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_NEW_MORE_BRAND(context, brand_id) { // GET 신상품 더보기 팝업 브랜드
            const new_more_brand_apiurl = apiurl + '/new/items/more?brand_id=' + brand_id;

            $.ajax({
                type: "GET",
                url: new_more_brand_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    context.commit('SET_NEW_MORE_BRAND', data);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
    }
});