Vue.component('Product-Price',{
    template : /*html*/`
                <div class="prd_price">
                    <template v-if="item_price != null">
                        <span class="set_price" v-html="price_html"></span>
                        <span v-if="discount_html != ''" class="discount" v-html="discount_html"></span>
                    </template>
                    <p v-else class="biz_price not_biz"><span>BIZ</span> 회원전용가</p>
                </div>`,
    props : {
        item_price : {type : Number, default : 0}, // 상품가격
        sale_percent : {type : Number, default : 0}, // 세일 퍼센트
        item_coupon_yn : {type : Boolean, default : false}, // 상품 쿠폰 존재 여부
        item_coupon_value : {type : Number, default : 0}, // 쿠폰값
        item_coupon_type : {type : String, default : '1'}, // 쿠폰유형(0:% 할인, 1:원 할인가격)
        rental_yn : {type : Boolean, default : false}, // 렌탈상품 여부
    },
    computed : {
        // 가격
        price_html() {
            if( this.item_price == null ) {
                return '';
            } else if( this.rental_yn ) {
                return '<em>월</em>' + this.number_format(this.item_price) + '<em>~</em>';
            } else {
                return this.number_format(this.item_price);
            }
        },
        // GET 상품 할인율
        discount_html() {
            let discount_html = '';
            if( this.sale_percent > 0 && this.item_coupon_yn ) {
                discount_html += '<em>더블할인</em>';
            } else if( this.sale_percent > 0 ) {
                discount_html += this.sale_percent + '%';
            } else if( this.item_coupon_yn && this.item_coupon_value > 0 ) {
                if( this.item_coupon_type === '1' ) {
                    discount_html += this.item_coupon_value + '% <em>쿠폰</em>';
                } else if( this.item_coupon_type === '2' ) {
                    discount_html += this.item_coupon_value + '<em>원 쿠폰</em>';
                }
            }
            return discount_html;
        },
    },
})