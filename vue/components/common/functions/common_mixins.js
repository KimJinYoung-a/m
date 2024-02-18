const common_mixin = Vue.mixin({
    methods : {
        // 스크롤 이벤트
        scroll : function(callback) { 
            const _store = this.$store;

            window.onscroll = function () {
                if ($(window).scrollTop() >= ($(document).height() - $(window).height()) - 250) {
                    if (_store.getters.is_loading === false) {
                        _store.commit('SET_IS_LOADING', true);
                        callback();
                    }
                }
            };
        },
        move_brand_page(brand_id) { // 브랜드 상세 페이지 이동
            this.isApp ? fnAPPpopupBrand(brand_id) : function () {
                location.href = '/brand/brand_detail2020.asp?brandid=' + brand_id;
            }();
        },
        move_search_page(keyword, search_type) { // 검색결과 페이지 이동
            this.isApp ? fnAPPpopupSearch(keyword, search_type) : function () {
                location.href = '/search/search_product2020.asp?keyword=' + keyword;
            }();
        },
        change_wish_flag_item(id, flag) { // 위시 변경 (item 컴포넌트)
            this.$emit('change_wish_flag', this.wish_place, this.wish_type, id, flag);
        },
        change_wish_flag_list(wish_place, wish_type, id, flag) { // 위시 변경 (list 컴포넌트)
            this.$emit('change_wish_flag', wish_place, wish_type, id, flag);
        },
        change_wish_flag_brand(wish_place, wish_type, brand_id, flag) { // 브랜드 위시 변경
            this.$store.commit('UPDATE_BRAND_WISH', {
                wish_place: wish_place,
                wish_type: wish_type,
                brand_id: brand_id,
                on_flag : flag
            });
        },
        get_swiper_index(active_index, list_length) {
            return (active_index + list_length) % list_length;
        },
        decode_base64(str) {
            if( str == null ) return null;
            return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
        },
        app_more(title, uri) { // 앱 더보기 팝업
            if( appVersion >= 4.001 ){
                fnAPPpopupBrowserRenewal('push', title, location.protocol
                    + '//' + location.hostname + '/apps/appCom/wish/web2014' + uri);
            } else {
                fnAPPpopupBrowserURL(title, location.protocol
                    + '//' + location.hostname + '/apps/appCom/wish/web2014' + uri, 'right');
            }
        }
    }
});