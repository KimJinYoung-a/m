const decodeBase64 = function(str) {
    if( str == null ) return null;
    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
}

let store = new Vuex.Store({
    state : {
        md_rolling_products : [], // MD가 고르고 골랐어요 상품 리스트
        md_keyword : '', // MD가 추천하는 키워드 활성화된 키워드
        md_keywords : [], // MD가 고르고 골랐어요 상품 리스트
        md_keyword_products : [], // MD가 추천하는 키워드 상품 리스트
        md_brand : { // 이 브랜드 어때요?
            brand_id : '', // 브랜드ID
            main_image : '', // 메인 이미지
            brand_name_kr : '', // 브랜드명(KR)
            brand_name_en : '', // 브랜드명(EN)
            sub_copy : '', // 서브카피
            brand_wish_yn : false, // 브랜드 위시 여부
            products : [] // 상품 리스트
        },
        categories : [ // 카테고리 리스트
            {
                catecode : 0,
                catename : '전체'
            }
        ],
        md_products : [], // 카피쓰다 구매할뻔했어요 상품 리스트
    },
    getters : {
        md_rolling_products(state) { // MD가 고르고 골랐어요 상품 리스트
            return state.md_rolling_products;
        },
        md_keyword(state) { // MD가 추천하는 키워드 활성화된 키워드
            return state.md_keyword;
        },
        md_keywords(state) { // MD가 추천하는 키워드 리스트
            return state.md_keywords;
        },
        md_keyword_products(state) { // MD가 추천하는 키워드 상품 리스트
            return state.md_keyword_products;
        },
        md_brand(state) { // 이 브랜드 어때요?
            return state.md_brand;
        },
        categories(state) { // 카테고리 리스트
            return state.categories;
        },
        md_products(state) { // 카피쓰다 구매할뻔했어요 상품 리스트
            return state.md_products;
        }
    },
    mutations : {
        SET_MD_ROLLING_PRODUCTS(state, items) { // SET MD가 고르고 골랐어요 상품 리스트
            if( items != null ) {
                const temp_md_rolling_products = [];
                for( let i=0 ; i<items.length ; i++ ) {
                    if( items[i].item_image != null ) {
                        items[i].item_image = decodeBase64(items[i].item_image);
                    }
                    temp_md_rolling_products.push(items[i]);
                }
                state.md_rolling_products = temp_md_rolling_products;
            }
        },
        SET_MD_KEYWORDS(state, keywords) { // SET MD가 추천하는 키워드 리스트
            if( keywords != null ) {
                const temp_md_keywords = [];
                for( let i=0 ; i<keywords.length ; i++ ) {
                    temp_md_keywords.push({
                        value : keywords[i].keyword,
                        text : keywords[i].keyword,
                        is_active : i === 0
                    });
                }
                state.md_keywords = temp_md_keywords;
            }
        },
        SET_MD_KEYWORD_PRODUCTS(state, items) { // SET MD가 추천하는 키워드 상품 리스트
            if( items != null ) {
                const temp_md_keyword_products = [];
                for( let i=0 ; i<items.length ; i++ ) {
                    if( items[i].item_image != null ) {
                        items[i].item_image = decodeBase64(items[i].item_image);
                    }
                    temp_md_keyword_products.push(items[i]);
                }
                state.md_keyword_products = temp_md_keyword_products;
            } else {
                state.md_keyword_products =[];
            }
        },
        SET_MD_KEYWORD(state, keyword) { // SET MD가 추천하는 키워드 활성화된 키워드
            state.md_keyword = keyword;
        },
        SET_MD_BRAND(state, brand) { // SET 이 브랜드 어때요?
            if( brand.brand != null ) {
                state.md_brand.brand_id = brand.brand.brand_id;
                if( brand.brand.brand_image != null ) {
                    state.md_brand.main_image = decodeBase64(brand.brand.brand_image);
                }
                state.md_brand.brand_name_kr = brand.brand.brand_name_kor;
                state.md_brand.brand_name_en = brand.brand.brand_name_en;
                state.md_brand.sub_copy = brand.brand.sub_copy;
                state.md_brand.brand_wish_yn = brand.brand.wish_yn;
                state.md_brand.products = [];

                if( brand.items != null ) {
                    for( let i=0 ; i<brand.items.length ; i++ ) {
                        if( brand.items[i].item_image != null ) {
                            brand.items[i].item_image = decodeBase64(brand.items[i].item_image);
                        }
                        state.md_brand.products.push(brand.items[i]);
                    }
                }
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
        SET_MD_PRODUCTS(state, items) { // SET 카피쓰다 구매할뻔했어요 상품 리스트
            if( items != null ) {
                const temp_md_products = [];
                for( let i=0 ; i<items.length ; i++ ) {
                    if( items[i].list_image != null ) {
                        items[i].list_image = decodeBase64(items[i].list_image);
                    }
                    if( items[i].big_image != null ) {
                        items[i].big_image = decodeBase64(items[i].big_image);
                    }
                    temp_md_products.push(items[i]);
                }
                state.md_products = temp_md_products;
            } else {
                state.md_products =[];
            }
        },
        UPDATE_PRODUCT_WISH(state, payload) { // 상품 위시 변경
            let products;

            switch (payload.wish_type) {
                case 'rolling': products = state.md_rolling_products; break; // MD가 고르고 골랐어요
                case 'keyword': products = state.md_keyword_products; break; // MD가 추천하는 키워드
                case 'brand': products = state.md_brand.products; break; // 이 브랜드 어때요?
                case 'list': products = state.md_products; break; // 카피쓰다 구매할뻔했어요
                default : products = [];
            }

            for( let i=0 ; i<products.length ; i++ ) {
                if( Number(products[i].item_id) === Number(payload.item_id) ) {
                    products[i].wish_yn = payload.on_flag;
                    return;
                }
            }
        },
        UPDATE_BRAND_WISH(state, on_flag) { // UPDATE 브랜드 위시
            state.md_brand.brand_wish_yn = on_flag;
        },
    },
    actions : {
        GET_MD_ROLLING_PRODUCTS(context) { // GET MD가 고르고 골랐어요 상품 리스트
            const md_rolling_apiurl = apiurl + '/mdpick/rolling';

            $.ajax({
                type: "GET",
                url: md_rolling_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('GET_MD_ROLLING_PRODUCTS', data);
                    context.commit('SET_MD_ROLLING_PRODUCTS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_MD_KEYWORDS(context) { // GET MD가 추천하는 키워드 리스트
            const md_keyword_apiurl = apiurl + '/mdpick/keywords';

            $.ajax({
                type: "GET",
                url: md_keyword_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('GET_MD_KEYWORDS', data);
                    context.commit('SET_MD_KEYWORDS', data.keywords);

                    // 첫 키워드로 상품 검색
                    if( data.keywords != null ) {
                        const md_first_keyword = data.keywords[0].keyword;
                        context.dispatch('GET_MD_KEYWORD_PRODUCTS', md_first_keyword);
                        context.commit('SET_MD_KEYWORD', md_first_keyword);
                    }
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_MD_KEYWORD_PRODUCTS(context, keyword) { // GET MD가 추천하는 키워드 상품 리스트
            const md_keyword_product_apiurl = apiurl + '/mdpick/keyword/item?keyword=' + keyword;

            $.ajax({
                type: "GET",
                url: md_keyword_product_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('GET_MD_KEYWORD_PRODUCTS', data);
                    context.commit('SET_MD_KEYWORD_PRODUCTS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_MD_BRAND(context) { // GET 이 브랜드 어때요?
            const md_brand_apiurl = apiurl + '/mdpick/brand';

            $.ajax({
                type: "GET",
                url: md_brand_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('GET_MD_BRAND', data);
                    context.commit('SET_MD_BRAND', data);
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
                    console.log('GET_CATEGORIES', data);
                    context.commit('SET_CATEGORIES', data.categories);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_MD_PRODUCTS(context, category_code) { // GET 카피쓰다 구매할뻔했어요 상품 리스트
            let md_products_apiurl = apiurl + '/mdpick/list/main';
            if( category_code !== 0 ) {
                md_products_apiurl += '?catecode=' + category_code;
            }

            $.ajax({
                type: "GET",
                url: md_products_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('GET_MD_PRODUCTS', data);
                    context.commit('SET_MD_PRODUCTS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
    }
});