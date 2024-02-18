//var apiurl = "http://testfapi.10x10.co.kr:8080/api/web/v1";
var apiurl = "http://localhost:8080/api/web/v1";
var categories_dataurl = apiurl + "/category/main/";

var store = new Vuex.Store({
    state : {
        params : { // 파라미터
            request_catecode: 0
        },
        options : { // 옵션
            first_category_view_count: 6
        },
        this_category : { // 현재 카테고리
            catecode: 0,
            catename: ''
        },
        categories: [], // 하위 카테고리 리스트
        content_order: ['banner','exhibition','brand'], // 컨텐츠 순서
        banners: [], // 배너 리스트
        exhibitions: [] // 기획전 리스트
    },
    getters : {
        first_category_view_count : function(state) { // 처음 보여줄 하위 카테고리 수
            return state.options.first_category_view_count;
        },
        more_category_count : function(state) { // 더보기 카테고리 수
            if( state.categories.length < state.options.first_category_view_count )
                return 0;
            return state.categories.length - state.options.first_category_view_count;
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
        }
    },
    mutations : {
        /* SET */
        SET_REQ_PARAM : function(state, payload) { // Request 파라미터 state params에 set
            state.params.request_catecode = payload.disp;
        },
        SET_THIS_CATEGORY: function(state , payload) { // Set 현재 카테고리
            state.this_category.catecode = payload.catecode;
            state.this_category.catename = payload.catename;
        },
        SET_CATEGORIES : function(state , payload) { // Set 하위 카테고리 리스트
            state.categories = payload.categories;
        },
        SET_CONTENT_ORDER : function(state , payload) { // Set 컨텐츠 순서
            var content_order_arr = [];
            for( idx in payload ) {
                var order = payload[idx];
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
        }
    },
    actions : {
        GET_MAIN_ITEMS : function(context) { // 메인 아이템들 state에 저장
            var _url = categories_dataurl + context.state.params.request_catecode;

            var getData = new Promise(function(resolve , reject) {
                $.getJSON(_url, function(response) {
                    if (response) {
                        resolve(response);
                    } else {
                        reject(new Error("Json Data Not Loaded"));
                    }
                }).fail(function(e) {
                    if( e.responseText != '' ) {
                        var error = JSON.parse(e.responseText);
                        alert(error.message);
                    } else {
                        alert('오류가 발생했습니다');
                    }
                    history.back();
                });
            });

            getData.then(function(data) {

                // 상단 카테고리 그룹
                var top_categories = data.top_categories;
                context.commit('SET_THIS_CATEGORY', top_categories);
                context.commit('SET_CATEGORIES', top_categories);

                // 메인 컨텐츠(배너, 기획전, 뭐 없을까 싶을때)
                var contents = data.contents;

                // 컨텐츠 순서
                context.commit('SET_CONTENT_ORDER', contents.order);

                // 배너
                var banner = contents.banner;
                if( banner.totalCount > 0 ) {
                    context.commit('SET_BANNERS', banner.banners);
                }
                // 기획전
                var exhibition = contents.exhibition;
                if( exhibition.totalCount > 0 ) {
                    context.commit('SET_EXHIBITIONS', exhibition.exhibitions);
                }


            }, function(reason) {
                console.log(reason);
            });
        }
    }
});