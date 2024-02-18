const item_mixin = Vue.mixin({
    methods : {
        // 상품 URL
        itemUrl(item_id) {
            fnAmplitudeEventAction(this.amplitudeActionName+'item','itemid',item_id);

            if( this.isApp ) {
                fnAPPpopupProductRenewal(item_id);
            } else {
                location.href = "/category/category_itemPrd.asp?itemid=" + item_id + "&flag=e";
            }
        },
        itemUrl(item_id, move_url, item_adult_type, is_adult_user) {
            fnAmplitudeEventAction(this.amplitudeActionName+'item','itemid',item_id);

            if( move_url == null || move_url === '' || this.isApp ) {
                if( this.isApp ) {
                    fnAPPpopupProductRenewal(item_id);
                } else {
                    location.href = "/category/category_itemPrd.asp?itemid=" + item_id + "&flag=e";
                }
            } else {
                setTimeout(() => location.href = move_url, 300);
            }
        },
        // GET 상품 할인율
        get_discount_html(product) {
            let discount_html = '<dfn>할인율</dfn>';
            if( product.sale_percent > 0 && product.item_coupon_yn ) {
                discount_html += '<em>더블할인</em>';
            } else if( product.sale_percent > 0 ) {
                discount_html += product.sale_percent + '%';
            } else if( product.item_coupon_yn && product.item_coupon_value > 0 ) {
                if( product.item_coupon_type === '1' ) {
                    discount_html += product.item_coupon_value + '% <em>쿠폰</em>';
                } else if( product.item_coupon_type === '2' ) {
                    discount_html += product.item_coupon_value + '<em>원 쿠폰</em>';
                }
            }
            return discount_html;
        },
        // 숫자 Format(#,###)
        number_format(number) {
            if( number == null || isNaN(number) )
                return '';
            else
                return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        },
        remove_commas(x) {
            return x.toString().replace(/,/gi,'');
        },
        change_wish_flag_product(wish_place, wish_type, item_id, flag) { // 상품 위시 변경
            this.$store.commit('UPDATE_PRODUCT_WISH', {
                wish_place: wish_place,
                wish_type: wish_type,
                item_id: item_id,
                on_flag : flag
            });
        },
        change_wish_flag_review_product(wish_place, wish_type, item_id, flag) { // 이 상품 후기 더보기 상품 위시 변경
            this.$store.commit('UPDATE_REVIEW_PRODUCT_WISH', flag);
        },
    }
});