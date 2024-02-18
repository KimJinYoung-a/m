var store = new Vuex.Store({
    state : {
        detail_type : '', // 상세 구분(best:베스트셀러, steady:스테디셀러, wish:베스트위시, review:베스트후기)
        parameter : {
            cate_code : '',
            period_type : 'D', // 기간유형(D:일간,W:주간,M:월간)
            sort_method : 'best', // 정렬(best:인기순(default),new:신규순,lp:낮은가격순,hp:높은가격순,hs:할인율순)
        },
        categories: [], // 검색 카테고리 리스트
        itemCount : 0, // 상품 결과 갯수
        items : [], // 상품 리스트,
        moreItems : [], // 더보기 상품 
        best_reviews : [], // 베스트 후기 리스트
        isApp: isApp, // 앱 여부
        current_page: 1, // 현재 페이지
        is_loading: false, // 현재 페이지
        is_loading_complete: false, // 페이지 모두 로딩했는지 여부
        dataURI : '', // data URI
        brandID : '',
        // 상품 후기 영역
        this_item_view_type : 'detail', // 이 상품 후기 더보기 팝업 뷰 타입
        product : { // 이 상품 후기 더보기 팝업 상품 정보
            item_id : 0, // 상품ID
            item_name : '', // 상품명
            item_price : 0, // 상품 가격
            sale_percent : 0, // 세일 퍼센트
            sale_yn : false, // 세일여부
            item_coupon_yn : false, // 쿠폰여부
            item_coupon_value : 0, // 쿠폰 값
            item_coupon_type : '1', // 쿠폰구분값
            item_image : '', // 상품 이미지
            wish_yn : false, // 위시 여부
            sell_flag : 'Y' // 판매 상태
        },
        this_item_reviews : [], // 이 상품 후기 더보기 팝업 후기 리스트
        this_item_review_count : 0, // 이 상품 후기 더보기 팝업 후기 갯수
        this_item_current_page : 1, // 이 상품 후기 더보기 팝업 현재 페이지
        is_loading_this_item_page : false, // 이 상품 후기 더보기 팝업 페이지 로딩중 여부
        is_end_this_item_page : false, // 이 상품 후기 더보기 팝업 페이지 종료 여부
        // 상품 후기 영역
        first_loading_complete : false // 처음 loading 종료 여부
    },
    getters : {
        parameter(state) { // 파라미터
            return state.parameter;
        },
        categories(state) { // 카테고리 리스트
            return state.categories;
        },
        items(state) { // 상품 리스트
            return state.items;
        },
        moreItems(state) { // 더보기 상품 리스트
            return state.moreItems;
        },
        itemCount(state) { // 검색결과 그룹별 겸색결과 수
            return state.itemCount;
        },
        current_page(state) { // 현재 페이지
            return state.current_page;
        },
        next_page(state) { // 다음 페이지
            return state.current_page + 1;
        },
        is_loading(state) {	// 다음 상품리스트 로딩 중 여부
            return state.is_loading;
        },
        is_loading_complete(state) { // 페이지 모두 로딩했는지 여부
            return state.is_loading_complete;
        },
        isApp(state) { // 앱 여부
            return state.isApp;
        },
        // 상품 후기 영역
        brandID(state) {
            return state.brandID;
        },
        best_reviews(state) { // 베스트 후기 리스트
            return state.best_reviews;
        },
        this_item_view_type(state) { // 이 상품 후기 더보기 팝업 뷰 타입
            return state.this_item_view_type;
        },
        product(state) { // 이 상품 후기 더보기 팝업 상품 정보
            return state.product;
        },
        this_item_reviews(state) { // 이 상품 후기 더보기 팝업 후기 리스트
            return state.this_item_reviews;
        },
        this_item_review_count(state) { // 이 상품 후기 더보기 팝업 후기 갯수
            return state.this_item_review_count;
        },
        this_item_current_page(state) { // 이 상품 후기 더보기 팝업 현재 페이지
            return state.this_item_current_page;
        },
        is_loading_this_item_page(state) { // 이 상품 후기 더보기 팝업 페이지 로딩중 여부
            return state.is_loading_this_item_page;
        },
        is_end_this_item_page(state) { // 이 상품 후기 더보기 팝업 페이지 종료 여부
            return state.is_end_this_item_page;
        },
        // 상품 후기 영역
        first_loading_complete(state) { // 처음 loading 종료 여부
            return state.first_loading_complete;
        }
    },
    mutations : {
        SET_DETAIL_TYPE(state, type) { // SET 상세 구분값
            state.detail_type = type;
        },
        CLEAR_ITEMS : function(state) {
            state.items = [];
        },
        CLEAR_MOREITEMS : function(state) {
            state.moreItems = [];
        },
        CLEAR_BEST_REVIEWS : function(state) {
            state.best_reviews = [];
        },
        CLEAR_THIS_ITEM_DATA : function (state) { // 기존 불러와져있던 이상품후기더보기 정보 clear
            state.product = {
                item_id : 0,
                item_name : '',
                item_price : 0,
                sale_percent : 0,
                sale_yn : false,
                item_coupon_yn : false,
                item_coupon_value : 0,
                item_coupon_type : '1',
                item_image : '',
                wish_yn : false,
                sell_flag : 'Y'
            };
            state.this_item_reviews = [];
            state.this_item_review_count = 0;
            state.this_item_view_type = 'detail';
            state.this_item_current_page = 1;
            state.is_loading_this_item_page = false;
            state.is_end_this_item_page = false;
        },
        SET_BRANDID(state,payload) {
            state.brandID = payload;
        },
        SET_PARAMETER(state, parameter) { // SET 파라미터
            Object.assign(state.parameter , parameter);
        },
        SET_PARAMETER_CATEGORY(state, category_code) { // SET 파라미터 카테고리 코드
            state.parameter.cate_code = category_code;
        },
        SET_PARAMETER_SORT_METHOD(state, sort_method) { // SET 파라미터 정렬옵션
            state.parameter.sort_method = sort_method;
        },
        SET_CATEGORIES : function(state , payload) { // Set 하위 카테고리 리스트
            const default_arr = [{
                catecode: 0,
                catename: '전체',
                hasRowList: false,
                itemCount: 0
            }];
            state.categories = default_arr.concat(payload);
        },
        SET_ITEMS : function(state, payload) { // Set 상품 리스트
            let items = [];

            if( payload != null ) {
                for( let idx=0 ; idx < payload.length ; idx++ ) {
                    let temp_item = payload[idx];

                    let decodeBase64 = (str) => { return (str != null && str != '') ? atob(str.replace(/_/g, '/').replace(/-/g, '+')) : '' }

                    // Decode Base64
                    temp_item.big_image = decodeBase64(temp_item.big_image);
                    temp_item.list_image = decodeBase64(temp_item.list_image);
                    temp_item.move_url = decodeBase64(temp_item.move_url);

                    items.push(temp_item);
                }
                
                if (state.items === '') {
                    state.items = items;
                } else {
                    $.each(items , function(key,value) {
                        state.items.push(value);
                    });
                }
                
            } else {
                state.is_loading_complete = true;
            }

            const limit_type = ['best', 'wish', 'steady']; // 200개 한계 구분값
            if( limit_type.indexOf(state.detail_type) > -1 && state.items.length >= 200 ) {
                state.is_loading_complete = true;
            }

            state.is_loading = false;
        },
        SET_MOREITEMS : function(state, payload) { // Set 상품 리스트
            let moreItems = [];

            if( payload != null ) {
                for( let idx=0 ; idx < payload.items.length ; idx++ ) {
                    let temp_item = payload.items[idx];

                    let decodeBase64 = (str) => { return (str != null && str != '') ? atob(str.replace(/_/g, '/').replace(/-/g, '+')) : '' }

                    // Decode Base64
                    temp_item.big_image = decodeBase64(temp_item.big_image);
                    temp_item.list_image = decodeBase64(temp_item.list_image);
                    temp_item.move_url = decodeBase64(temp_item.move_url);

                    moreItems.push(temp_item);
                }
                state.moreItems = payload;
                Object.assign(state.moreItems , moreItems);
            } 
        },
        SET_BEST_REVIEWS(state, reviews) { // SET 베스트 리뷰 리스트
            if( reviews != null && reviews.length > 0 ) {
                let temp_best_reviews = [];
                for( let i=0 ; i<reviews.length ; i++ ) {
                    
                    let decodeBase64 = (str) => { return (str != null && str != '') ? atob(str.replace(/_/g, '/').replace(/-/g, '+')) : '' }

                    if( reviews[i].item_image != null )
                        reviews[i].item_image = decodeBase64(reviews[i].item_image);

                    if( reviews[i].user_file != null )
                        reviews[i].review_images = [decodeBase64(reviews[i].user_file)];

                    reviews[i].total_point = reviews[i].rating;
                    reviews[i].sell_yn = 'Y';

                    temp_best_reviews.push(reviews[i]);
                }

                if (state.best_reviews === '') {
                    state.best_reviews = temp_best_reviews;
                } else {
                    $.each(temp_best_reviews , function(key,value) {
                        state.best_reviews.push(value);
                    });
                }
            }
        },
        SET_PAGE(state, page) { // 페이지 이동
            state.current_page = page;
        },
        SET_IS_LOADING(state, loading) { // SET 페이지 로딩 중 여부
            state.is_loading = loading;
        },
        SET_URI(state , payload) { // api uri 셋팅
            state.dataURI = payload;
        },
        // 상품 후기 영역
        SET_IS_LOADING_COMPLETE(state) { // 페이지 전체 로딩 여부
            state.is_loading_complete = false;
        },
        SET_IS_LOADING_THIS_ITEM_PAGE : function (state, is_loading) { // SET 이 상품 후기 더보기 후기 페이지 로딩중 여부
            state.is_loading_this_item_page = is_loading;
        },
        SET_IS_END_THIS_ITEM_PAGE : function (state, is_end) { // SET 이 상품 후기 더보기 후기 페이지 종료 여부
            state.is_end_this_item_page = is_end;
        },
        SET_THIS_ITEM_CURRENT_PAGE : function(state, page) { // 이 상품 후기 더보기 현재 페이지 변경
            //console.log(page);
            state.this_item_current_page = page;
        },
        SET_THIS_ITEM_VIEW_TYPE : function (state, type) {
            state.this_item_view_type = type;
        },
        SET_THIS_ITEM_REVIEW_COUNT : function(state, count) { // SET 리뷰 갯수
            state.this_item_review_count = count;
        },
        SET_THIS_ITEM_REVIEWS : function (state, items) { // SET 리뷰 리스트
            //console.log(items);

            let decodeBase64 = (str) => { return (str != null && str != '') ? atob(str.replace(/_/g, '/').replace(/-/g, '+')) : '' }
            
            for( let i=0 ; i<items.length ; i++ ) {
                if( items[i].item_image != null )
                    items[i].item_image = decodeBase64(items[i].item_image);

                if( items[i].review_images != null ) {
                    for( let j=0 ; j<items[i].review_images.length ; j++ ) {
                        items[i].review_images[j] = decodeBase64(items[i].review_images[j]);
                    }
                }

                if( items[i].move_url != null )
                    items[i].move_url = decodeBase64(items[i].move_url);
            }
            //console.log(items);
            state.this_item_reviews = items;
            //console.log(state.this_item_reviews);
        },
        SET_PRODUCT : function (state, data) { // SET 상품정보
            let decodeBase64 = (str) => { return (str != null && str != '') ? atob(str.replace(/_/g, '/').replace(/-/g, '+')) : '' }

            state.product.item_id = data.item_id;
            state.product.item_name = data.item_name;
            state.product.item_price = data.item_price;
            state.product.sale_percent = data.sale_percent;
            state.product.sale_yn = data.sale_yn;
            state.product.item_coupon_yn = data.item_coupon_yn;
            state.product.item_coupon_value = data.item_coupon_value;
            state.product.item_coupon_type = data.item_coupon_type;
            state.product.item_image = decodeBase64(data.item_image);
            state.product.wish_yn = data.wish_yn;
            state.product.sell_flag = data.sell_flag;
        },
        ADD_THIS_ITEM_REVIEWS : function(state, items) { // ADD 이 상품 후기 더보기 후기 리스트
            let decodeBase64 = (str) => { return (str != null && str != '') ? atob(str.replace(/_/g, '/').replace(/-/g, '+')) : '' }

            for( let i=0 ; i<items.length ; i++ ) {
                if( items[i].item_image != null )
                    items[i].item_image = decodeBase64(items[i].item_image);

                if( items[i].review_images != null ) {
                    for( let j=0 ; j<items[i].review_images.length ; j++ ) {
                        items[i].review_images[j] = decodeBase64(items[i].review_images[j]);
                    }
                }

                if( items[i].move_url != null )
                    items[i].move_url = decodeBase64(items[i].move_url);

                state.this_item_reviews.push(items[i]);
            }
            state.is_loading_this_item_page = false;
        },
        // 상품 후기 영역
        SET_FIRST_LOADING_COMPLETE(state, is_complete) {
            state.first_loading_complete = is_complete;
        },
        UPDATE_PRODUCT_WISH(state, payload) { // 상품 위시 변경
            if( payload.wish_type === 'more_new_product' ) { // 신상품 더보기 상품
                for( let key in state.moreItems ) {
                    if( !isNaN(key) && Number(state.moreItems[key].item_id) === Number(payload.item_id) ) {
                        state.moreItems[key].wish_yn = payload.on_flag;
                        return;
                    }
                }
            } else {
                for( let i=0 ; i<state.items.length ; i++ ) {
                    if( Number(state.items[i].item_id) === Number(payload.item_id) ) {
                        state.items[i].wish_yn = payload.on_flag;
                        return;
                    }
                }
            }
        },
        UPDATE_REVIEW_PRODUCT_WISH(state, flag) { // UPDATE 이상품 후기 더보기 상품 위시
            state.product.wish_yn = flag;
        }
    },
    actions : {
        GET_CATEGORIES : function(context) { // 메인 아이템들 state에 저장
            const _url = apiurl + context.state.dataURI;

            $.ajax({
                type : "GET",
                url: _url,
                ContentType : "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function(data) {
                    //console.log(data);
                    context.commit('SET_CATEGORIES', data.categories);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_PRODUCTS : function(context) { // 상품 리스트 state에 저장
            const _pageLoadComplete = context.getters.is_loading_complete;
            const _parameter = context.getters.parameter;
            const _pageNumber = context.getters.current_page;

            if( _pageNumber === 1 )
                context.commit('SET_FIRST_LOADING_COMPLETE', false);

            if (!_pageLoadComplete) {

                const _createParameters = function() {
                    return '?catecode=' + _parameter.cate_code 
                            + '&page=' + _pageNumber 
                            + '&period_type=' + _parameter.period_type
                            + '&sortMethod=' + _parameter.sort_method
                }()

                const _url = apiurl + context.state.dataURI + _createParameters;

                $.ajax({
                    type : "GET",
                    url: _url,
                    ContentType : "json",
                    crossDomain: true,
                    xhrFields: {
                        withCredentials: true
                    },
                    success: function(data) {
                        //console.log(data);
                        context.commit('SET_ITEMS', data.items);
                        context.commit('SET_IS_LOADING', false);

                        if( _pageNumber === 1 ) {
                            context.commit('SET_FIRST_LOADING_COMPLETE', true);
                        }
                    },
                    error: function (xhr) {
                        console.log(xhr.responseText);
                    }
                });
            } else {
                context.commit('SET_IS_LOADING', false);
            }
        },
        GET_MORE_PRODUCTS : function(context) {
            
            const _brandID = context.getters.brandID
            const _createParameters = function() {
                return '?brand_id=' + _brandID                        
            }()

            const _url = apiurl + context.state.dataURI + _createParameters;

            $.ajax({
                type : "GET",
                url: _url,
                ContentType : "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function(data) {
                    //console.log(data);
                    context.commit('SET_MOREITEMS', data);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_BEST_REVIEWS(context) {
            const _pageLoadComplete = context.getters.is_loading_complete;
            const _parameter = context.getters.parameter;
            const _pageNumber = context.getters.current_page;

            if( _pageNumber === 1 )
                context.commit('SET_FIRST_LOADING_COMPLETE', false);

            if (!_pageLoadComplete) {
                const _createParameters = function() {
                    return '?catecode=' + _parameter.cate_code 
                            + '&page=' + _pageNumber 
                }()

                const _url = apiurl + context.state.dataURI + _createParameters;

                $.ajax({
                    type : "GET",
                    url: _url,
                    ContentType : "json",
                    crossDomain: true,
                    xhrFields: {
                        withCredentials: true
                    },
                    success: function(data) {
                        //console.log(data);
                        context.commit('SET_BEST_REVIEWS', data.reviews);

                        if( _pageNumber === 1 )
                            context.commit('SET_FIRST_LOADING_COMPLETE', true);
                    },
                    error: function (xhr) {
                        console.log(xhr.responseText);
                    }
                });
            }
        },
        GET_PRODUCT_AND_REVIEWS : function (context, item_id) { // 상품정보, 리뷰리스트 불러오기
            const search_reviews_apiurl = apiurl
                + '/search/itemEvalSearch?itemid=' + item_id;

            $.ajax({
                type: "GET",
                url: search_reviews_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    context.commit('SET_PRODUCT', data); // SET 상품정보
                    context.commit('SET_THIS_ITEM_REVIEW_COUNT', data.totalCount); // SET 리뷰 갯수
                    context.commit('SET_THIS_ITEM_REVIEWS', data.items); // SET 리뷰 리스트

                    if( data.last_page === context.getters.this_item_current_page ) { // 마지막 페이지
                        context.commit('SET_IS_END_THIS_ITEM_PAGE', true);
                    }
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        GET_MORE_THIS_ITEM_REVIEWS(context, item_id) { // 이 상품 후기 더보기 후기 리스트 더 불러오기
            const search_reviews_apiurl = apiurl + '/search/itemEvalSearch'
                + '?itemid=' + item_id
                + '&page=' + context.getters.this_item_current_page;

            $.ajax({
                type: "GET",
                url: search_reviews_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    context.commit('ADD_THIS_ITEM_REVIEWS', data.items); // SET 리뷰 리스트

                    if( data.last_page === context.getters.this_item_current_page ) { // 마지막 페이지
                        context.commit('SET_IS_END_THIS_ITEM_PAGE', true);
                    }
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
    }
});