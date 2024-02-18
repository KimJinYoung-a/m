const decodeBase64 = function(str) {
    if( str == null ) return null;
    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
}
const sendViewCategoryAmplitude = function(getters) {
    const category_code = getters.this_category.category_code;
    const category_name = getters.this_category.category_name;
    const parameter = getters.parameter;

    const object = {
        'category_code' : category_code,
        'category_depth' : Math.round(category_code.toString().length/3),
        'category_name' : category_name,
        'list_type' : parameter.view_type,
        'sort' : amplitudeSort(parameter.sort_method),
        'filter_recommend' : amplitudeFilterRecommend(parameter.deliType).join(','),
        'filter_brand' : parameter.makerIds.join(','),
        'filter_delivery' : amplitudeFilterDelivery(parameter.deliType).join(','),
        'filter_lowprice' : parameter.minPrice,
        'filter_highprice' : parameter.maxPrice,
        'paging_index' : parameter.page
    };

    fnAmplitudeEventObjectAction('view_category_list', object);
}

const appierCategoryViewed = function(getters){
    if(typeof qg !== "undefined"){
        let appier_category_viewed = {
            "category_code" : getters.this_category.category_code
            , "category_name" : getters.this_category.category_name
            , "sort" : getters.parameter.sort_method
        };

        qg("event", "category_viewed", appier_category_viewed);
    }
}

let store = new Vuex.Store({
    state : {
        parameter : { // 파라미터
            category_code: 0,
            view_type: 'detail', // 뷰 타입
            sort_method: 'new', // 정렬
            page: 1, // 페이지
            deliType: [], // 배송/기타 - 꼼꼼하게 찾기
            makerIds: [], // 브랜드 - 꼼꼼하게 찾기
            minPrice: '', // 최저가
            maxPrice: '' // 최고가
        },
        this_category : { // 현재 카테고리
            category_code: 0,
            category_name: ''
        },
        categories: [], // 하위 카테고리 리스트
        content_order: ['banner','exhibition','brand'], // 컨텐츠 순서
        banners: [], // 배너 리스트
        exhibitions: [], // 기획전 리스트
        brand: null, // 브랜드
        titles: [], // 뭐 없을까 싶을 때 탭 타이틀 리스트
        wonder_products: { // 뭐 없을까 싶을 때 상품 리스트
            best: [],
            steady: [],
            sale: [],
            new: [],
            clearance: []
        },
        is_wonder_loading: false, // 쿼 없을까 싶을 때 페이지 로딩 여부
        explorer_categories : [], // 카테고리 익스플로어 카테고리 리스트
        products: [], // 상품 리스트
        product_count : 0, // 상품 갯수
        last_page: 1, // 마지막 페이지
        first_loading_complete : false, // 첫 로딩 끝났는지 여부

        page_kkomkkom_brand : 1, // 꼼꼼하게 찾기 브랜드 페이지
        last_page_kkomkkom_brand : 1, // 꼼꼼하게 찾기 브랜드 마지막 페이지
        kkomkkom_brands : [], // 꼼꼼하게 찾기 브랜드 리스트(검색 대상 브랜드리스트)
        kkomkkom_makerIds : [], // 꼼꼼하게 찾기 브랜드ID 리스트(현재 체크 중인 브랜드ID리스트)
        kkomkkom_price : { // 꼼꼼하게 찾기 최저/최고 가격
            min : 0,
            max : 0
        }
    },
    getters : {
        parameter(state) { // 파라미터들
            return state.parameter;
        },
        this_category : function(state) { // 현재 카테고리
            return state.this_category;
        },
        categories : function(state) { // 하위 카테고리 리스트
            return state.categories;
        },
        content_order : function(state) {
            return state.content_order
        },
        banners : function(state) { // 배너 리스트
            return state.banners;
        },
        exhibitions : function(state) { // 기획전 리스트
            return state.exhibitions;
        },
        brand : function(state) { // 브랜드
            return state.brand;
        },
        titles : function(state) { // 뭐 없을까 싶을 때 탭 타이틀 리스트
            return state.titles;
        },
        wonder_products : function(state) { // 뭐 없을까 싶을 때 상품 리스트
            return state.wonder_products;
        },
        is_wonder_loading : function(state) { // 쿼 없을까 싶을 때 페이지 로딩 여부
            return state.is_wonder_loading;
        },
        explorer_categories(state) { // 카테고리 익스플로어 카테고리 리스트
            return state.explorer_categories;
        },
        products : function(state) { // 상품 리스트
            return state.products;
        },
        product_count : function(state) { // 상품 갯수
            return state.product_count;
        },
        last_page : function(state) { // 마지막 페이지
            return state.last_page;
        },
        first_loading_complete : function(state) { // 첫 로딩 끝났는지 여부
            return state.first_loading_complete;
        },
        page_kkomkkom_brand(state) { // 꼼꼼하게 찾기 브랜드 페이지
            return state.page_kkomkkom_brand;
        },
        last_page_kkomkkom_brand(state) { // 꼼꼼하게 찾기 브랜드 마지막 페이지
            return state.last_page_kkomkkom_brand;
        },
        kkomkkom_brands(state) { // 꼼꼼하게 찾기 브랜드 리스트(검색 대상 브랜드리스트)
            return state.kkomkkom_brands;
        },
        kkomkkom_makerIds(state) { // 꼼꼼하게 찾기 브랜드ID 리스트(현재 체크 중인 브랜드ID리스트)
            return state.kkomkkom_makerIds;
        },
        kkomkkom_price(state) { // 꼼꼼하게 찾기 최저/최고 가격
            return state.kkomkkom_price;
        },
    },
    mutations : {
        /* SET */
        SET_REQ_PARAM : function(state, parameter) { // Request 파라미터 state parameter에 저장
            state.parameter = parameter;
        },
        SET_THIS_CATEGORY: function(state , category) { // Set 현재 카테고리
            state.this_category.category_code = category.catecode;
            state.this_category.category_name = category.catename;
        },
        SET_CATEGORIES : function(state , payload) { // Set 하위 카테고리 리스트
            state.categories = payload.categories;
        },
        SET_CONTENT_ORDER : function(state , payload) { // Set 컨텐츠 순서
            let content_order_arr = [];
            for( let idx in payload ) {
                let order = payload[idx];
                content_order_arr[order.view_order-1] = order.content_type;
            }
            state.content_order = content_order_arr;
        },
        SET_BANNERS : function(state, payload) { // Set 배너 리스트
            var banners = [];
            for( idx in payload ) {
                var temp_banner = payload[idx];
                temp_banner.banner_image = decodeBase64(temp_banner.banner_image);
                temp_banner.move_url = decodeBase64(temp_banner.move_url);
                banners.push(temp_banner);
            }
            state.banners = banners;
        },
        SET_EXHIBITIONS : function(state, payload) { // Set 기획전 리스트
            var exhibitions = [];
            for( idx in payload ) {
                var temp_exhibition = payload[idx];
                temp_exhibition.banner_img = decodeBase64(temp_exhibition.banner_img);
                temp_exhibition.move_url = decodeBase64(temp_exhibition.move_url);
                exhibitions.push(temp_exhibition);
            }
            state.exhibitions = exhibitions;
        },
        SET_BRAND : function (state, brand) { // Set 브랜드
            brand.main_image = decodeBase64(brand.main_image);
            if( brand.items != null ) {
                for( let i=0 ; i<brand.items.length ; i++ ) {
                    if( brand.items[i].item_image != null )
                        brand.items[i].item_image = decodeBase64(brand.items[i].item_image);
                    brand.items[i].move_url = decodeBase64(brand.items[i].move_url);
                }
            }

            state.brand = brand;
        },
        SET_WONDERS : function (state, wonders) { // SET 뭐 없을까 싶을 때
            for( let i=0 ; i<wonders.length ; i++ ) {
                const wonder = wonders[i];

                state.titles.push({
                    text : wonder.title,
                    value : wonder.type
                });
                for( let j=0 ; j<wonder.items.length ; j++ ) {
                    if( wonder.items[j].item_image != null )
                        wonder.items[j].item_image = decodeBase64(wonder.items[j].item_image);

                    wonder.items[j].move_url = decodeBase64(wonder.items[j].move_url);
                }
                state.wonder_products[wonder.type] = wonder.items;
            }
        },
        SET_IS_WONDER_LOADING(state, loading) { // SET 쿼 없을까 싶을 때 페이지 로딩 여부
            state.is_wonder_loading = loading;
        },
        SET_MORE_WONDERS : function (state, data) {
            const items = data.items;
            for( let i=0 ; i<items.length ; i++ ) {
                if( items[i].item_image != null )
                    items[i].item_image = decodeBase64(items[i].item_image);

                items[i].move_url = decodeBase64(items[i].move_url);
                state.wonder_products[data.type].push(items[i]);
            }
        },
        UPDATE_PRODUCT_WISH(state, payload) { // 상품 위시 변경
            let products;

            if( payload.wish_type === 'brand' ) {
                products = state.brand.items;
            } else if( payload.wish_type != null && payload.wish_type.length > 6
                && payload.wish_type.substr(0, 6) === 'wonder' ) {
                products = state.wonder_products[payload.wish_type.split('_')[1]];
            } else {
                products = state.products;
            }

            for( let i=0 ; i<products.length ; i++ ) {
                if( Number(products[i].item_id) === Number(payload.item_id) ) {
                    products[i].wish_yn = payload.on_flag;
                    return;
                }
            }
        },
        UPDATE_BRAND_WISH(state, on_flag) { // UPDATE 지금뜨고있는 브랜드 위시
            state.brand.brand_wish_yn = on_flag;
        },
        SET_EXPLORER_CATEGORIES(state, categories) { // SET 카테고리 익스플로어 카테고리 리스트
            state.explorer_categories = categories;
        },
        UPDATE_KKOMKKOM_MAKERIDS(state, parameter) { // UPDATE 꼼꼼하게 찾기 브랜드ID리스트
            if( state.kkomkkom_makerIds.indexOf(parameter.brand_id) > -1 && !parameter.is_checked ) {
                state.kkomkkom_makerIds.splice(state.kkomkkom_makerIds.indexOf(parameter.brand_id), 1);
            } else if( state.kkomkkom_makerIds.indexOf(parameter.brand_id) < 0 && parameter.is_checked ) {
                state.kkomkkom_makerIds.push(parameter.brand_id);
            }
        },
        CLEAR_KKOMKKOM_MAKERIDS(state) { // 꼼꼼하게 찾기 추가한 브랜드ID 리스트 초기화
            state.kkomkkom_makerIds = [];
        },
        SET_PRODUCTS : function (state, items) {
            state.products = [];
            if( items != null ) {
                for( let i=0 ; i<items.length ; i++ ) {
                    const product = items[i];

                    if( product.big_image != null )
                        product.big_image = decodeBase64(product.big_image);
                    if( product.list_image != null )
                        product.list_image = decodeBase64(product.list_image);
                    if( product.move_url != null )
                        product.move_url = decodeBase64(product.move_url);

                    state.products.push(product);
                }
            }
        },
        SET_PRODUCT_COUNT : function (state, count) {
            state.product_count = count;
        },
        SET_LAST_PAGE : function (state, page) {
            state.last_page = page;
        },
        SET_FIRST_LOADING_COMPLETE(state, is_complete) {
            state.first_loading_complete = is_complete;
        },
        SET_KKOMKKOM_BRANDS : function (state, brands) { // SET 꼼꼼하게 찾기 브랜드 리스트
            state.kkomkkom_brands = [];
            if( brands != null ) {
                state.last_page_kkomkkom_brand = brands.last_page;
                if( brands.brands != null ) {
                    for( let i=0 ; i<brands.brands.length ; i++ ) {
                        brands.brands[i].is_checked = (
                            state.parameter.makerIds.indexOf(brands.brands[i].brand_id) > -1
                            || state.kkomkkom_makerIds.indexOf(brands.brands[i].brand_id) > -1);
                        state.kkomkkom_brands.push(brands.brands[i]);
                    }
                }
            }
        },
        ADD_KKOMKKOM_BRANDS(state, brands) { // ADD 꼼꼼하게 찾기 브랜드 리스트
            if( brands != null ) {
                for( let i=0 ; i<brands.length ; i++ ) {
                    brands[i].is_checked = (
                        state.parameter.makerIds.indexOf(brands[i].brand_id) > -1
                        || state.kkomkkom_makerIds.indexOf(brands[i].brand_id) > -1);
                    state.kkomkkom_brands.push(brands[i]);
                }
            }
        },
        SET_KKOMKKOM_PRICE(state, price) { // SET 꼼꼼하게 찾기 최저/최고 가격
            state.kkomkkom_price.min = price.min_price;
            state.kkomkkom_price.max = price.max_price;
        },
        SET_PAGE_KKOMKKOM_BRAND(state, page) { // SET 꼼꼼하게 찾기 브랜드 페이지
            state.page_kkomkkom_brand = page;
        },
    },
    actions : {
        GET_TOP_CONTENTS : function(context) { // GET 상단 하위카테고리, 컨텐츠, 뭐 없을까 리스트
            const category_code = context.state.parameter.category_code;
            const category_top_contents_apiurl = apiurl + '/category/top/contents/' + category_code;

            $.ajax({
                type: "GET",
                url: category_top_contents_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log(data);

                    // 상단 카테고리 그룹
                    const top_categories = data.top_categories;
                    context.commit('SET_THIS_CATEGORY', top_categories);
                    context.commit('SET_CATEGORIES', top_categories);

                    // 메인 컨텐츠(배너, 기획전, 뭐 없을까 싶을때)
                    const contents = data.contents;

                    // 컨텐츠 순서
                    context.commit('SET_CONTENT_ORDER', contents.order);

                    // 배너
                    const banner = contents.banner;
                    if( banner.totalCount > 0 ) {
                        context.commit('SET_BANNERS', banner.banners);
                    }
                    // 기획전
                    const exhibition = contents.exhibition;
                    if( exhibition.totalCount > 0 ) {
                        context.commit('SET_EXHIBITIONS', exhibition.exhibitions);
                    }

                    // 브랜드
                    const brand = contents.brand;
                    if( brand != null ) {
                        context.commit('SET_BRAND', brand);
                    }

                    // 뭐 없을 까 싶을 때
                    context.commit('SET_WONDERS', data.wonders);

                    // 카테고리 조회 Amplitude 전송
                    console.log('view_category_main', 'category_code|category_name',
                        category_code + '|' + top_categories.catename);
                    fnAmplitudeEventMultiPropertiesAction('view_category_main', 'category_code|category_name',
                        category_code + '|' + top_categories.catename);

                    appierCategoryViewed(context.getters);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_MORE_WONDERS : function (context, type) { // 뭐 없을까 싶을 때 더 불러오기
            console.log(type);
            console.log(context.getters.wonder_products[type]);
            context.commit('SET_IS_WONDER_LOADING', true);

            const wonder_more_apiurl = apiurl + '/category/cateWonder/more?'
                    + 'catecode=' + context.state.parameter.category_code
                    + '&page=' + (context.getters.wonder_products[type].length/18 + 1)
                    + '&type=' + type
            ;

            $.ajax({
                type: "GET",
                url: wonder_more_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log(data);
                    if( data.items != null ) {
                        context.commit('SET_MORE_WONDERS', {'type': type, 'items': data.items});
                    }
                    context.commit('SET_IS_WONDER_LOADING', false);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_EXPLORER_CATEGORIES(context) { // GET 카테고리 익스플로어 카테고리 리스트
            const category_explorer_apiurl = apiurl + '/category/explorer/' + context.getters.parameter.category_code;

            $.ajax({
                type: "GET",
                url: category_explorer_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('GET_EXPLORER_CATEGORIES', data);
                    context.commit('SET_EXPLORER_CATEGORIES', data.explorer);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            })
        },
        GET_PRODUCTS(context) {
            const parameter = context.getters.parameter;

            let category_products_apiurl = apiurl + '/category/items/search'
                + '?catecode=' + parameter.category_code
                + '&sortMethod=' + parameter.sort_method
                + '&page=' + parameter.page;

            if( parameter.deliType.length > 0 ) { // 배송/기타
                for( let i=0 ; i<parameter.deliType.length ; i++ ) {
                    category_products_apiurl += '&deliType=' + parameter.deliType[i];
                }
            }
            if( parameter.makerIds.length > 0 ) { // 브랜드
                for( let i=0 ; i<parameter.makerIds.length ; i++ ) {
                    category_products_apiurl += '&makerIds=' + parameter.makerIds[i];
                }
            }
            if( parameter.minPrice !== '' ) { // 최저가
                category_products_apiurl += '&minPrice=' + parameter.minPrice;
            }
            if( parameter.maxPrice !== '' ) { // 최고가
                category_products_apiurl += '&maxPrice=' + parameter.maxPrice;
            }

            $.ajax({
                type: "GET",
                url: category_products_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log(data);
                    context.commit('SET_PRODUCT_COUNT', data.total_count);
                    context.commit('SET_PRODUCTS', data.items);
                    context.commit('SET_LAST_PAGE', data.last_page);
                    context.commit('SET_FIRST_LOADING_COMPLETE', true);

                    if( data.items != null ) {
                        const product_id_arr = [];
                        data.items.slice(0, 3).forEach(item => {
                            product_id_arr.push(item.item_id.toString());
                        });
                        console.log(product_id_arr);

                        window.criteo_q = window.criteo_q || [];
                        var deviceType = /iPad/.test(navigator.userAgent) ? "t" : /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "m" : "d";
                        window.criteo_q.push(
                            { event: "setAccount", account: 8262}, // 이 라인은 업데이트하면 안됩니다
                            { event: "setEmail", email: criteo_user_mail_md5 }, // 유저가 로그인이 안되 있는 경우 빈 문자열을 전달
                            { event: "setSiteType", type: deviceType},
                            { event: "viewList", item: product_id_arr }); // 가장 위에있는 3개의 상품 ID를 전달
                    }

                    sendViewCategoryAmplitude(context.getters);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_MORE_KKOMKKOM_BRANDS(context, keyword) { // 꼼꼼하게 찾기 브랜드 더 불러오기
            if( context.getters.last_page_kkomkkom_brand <= context.getters.page_kkomkkom_brand ) // 마지막 페이지면 return
                return false;

            const next_page = context.getters.page_kkomkkom_brand + 1;
            context.commit('SET_PAGE_KKOMKKOM_BRAND', next_page);

            let brand_kkomkkom_apiurl = apiurl + '/search/kkomkkom/brands?dispCategories='
                + context.getters.parameter.category_code
                + '&page=' + next_page;
            if( keyword !== '' ) {
                brand_kkomkkom_apiurl += '&brand_name_keyword=' + keyword;
            }

            $.ajax({
                type: "GET",
                url: brand_kkomkkom_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('GET_MORE_KKOMKKOM_BRANDS', data);
                    context.commit('ADD_KKOMKKOM_BRANDS', data.brands);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            })
        },
        GET_KKOMKKOM_CRITERIA(context) { // GET 꼼꼼하게 찾기 검색조건 조회
            let search_kkomkkom_apiurl = apiurl + '/search/kkomkkom?dispCategories='
                + context.getters.parameter.category_code;

            const parameter = context.getters.parameter;

            if( parameter.deliType.length > 0 ) { // 배송/기타
                for( let i=0 ; i<parameter.deliType.length ; i++ ) {
                    search_kkomkkom_apiurl += '&deliType=' + parameter.deliType[i];
                }
            }
            if( parameter.makerIds.length > 0 ) { // 브랜드
                for( let i=0 ; i<parameter.makerIds.length ; i++ ) {
                    search_kkomkkom_apiurl += '&makerIds=' + parameter.makerIds[i];
                }
            }
            if( parameter.minPrice !== '' ) { // 최저가
                search_kkomkkom_apiurl += '&minPrice=' + parameter.minPrice;
            }
            if( parameter.maxPrice !== '' ) { // 최고가
                search_kkomkkom_apiurl += '&maxPrice=' + parameter.maxPrice;
            }

            $.ajax({
                type: "GET",
                url: search_kkomkkom_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('GET_KKOMKKOM_CRITERIA', data);
                    context.commit('SET_KKOMKKOM_BRANDS', data.brands);
                    context.commit('SET_KKOMKKOM_PRICE', data);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            })
        },
    }
});