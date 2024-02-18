Vue.component('Product-Item-Today-Best', {
    template : `
        <div :class="['re_best','prd_item', {soldout: sell_flag != 'Y'}, {rank_five : index == 4}]">
            <!-- 베스트 상품 : 순위 표시 (label_rank) -->
            <div class="best_rank">
                <span class="num">{{rank}}</span>
                <span class="blind">위</span>
                <template v-if="rank_diff != 2000 && rank_diff <= 30">
                    <span v-if="rank_diff > 0" class="rank_up"><img src="//fiximage.10x10.co.kr/m/2021/best/rank_up.png" alt=""></span>
                    <span v-else-if="rank_diff < 0" class="rank_down"><img src="//fiximage.10x10.co.kr/m/2021/best/rank_down.png" alt=""></span>
                </template>                
            </div>
            <div class="best_wrap">
                <figure class="prd_img">
                    <img v-lazy="decodeBase64(image_url)" alt="">
                    <span class="prd_mask"></span>
                </figure>
                <div class="prd_info">
                    <div class="prd_price">
                        <template v-if="item_price != null">
                            <span class="set_price" v-html="price_html"></span>
                            <span v-if="discount_html != ''" class="discount" v-html="discount_html"></span>
                        </template>
                        <p v-else class="biz_price not_biz"><span>BIZ</span> 회원전용가</p>
                    </div>
                    <Product-Name :item_name="item_name"></Product-Name>                    
                </div>
                <a @click="$emit('go_item', item_id, rank, flag_text, $event)" class="prd_link"><span class="blind">상품 바로가기</span></a>
            </div>
            <div v-if="flag_text" class="picky">
                <p class="bbl_ten">{{flag_text}}</p>
            </div>
        </div>
    `,
    props : {
        isApp : { type : Boolean, default : false }, //  M/A 구분 App === true , Mobile === false
        item_id: { type: Number, default: 0 }, // 상품코드
        image_url   : { type : String, default : '' }, // 이미지 url
        shape_type : { type : String, default : 'circle' }, // SVG 모양
        item_price : { type : Number, default : 0 }, // 최종 가격
        sale_percent : { type : Number, default : 0 }, // 세일 할인율
        item_coupon_yn : {type : Boolean, default : false}, // 상품 쿠폰 존재 여부
        item_coupon_value : {type : Number, default : 0}, // 쿠폰값
        item_coupon_type : {type : String, default : '1'}, // 쿠폰유형(0:% 할인, 1:원 할인가격)
        item_name : { type : String, default : '' }, // 상품명
        amplitudeActionName : { type : String, default : "" }, // amplitude 지정이름
        rental_yn : { type : Boolean, default : false }, // 렌탈상품 여부
        sell_flag : { type : String, default : 'Y' } // 판매상태
        , rank : { type : Number, default : 0 }
        , rank_diff : { type : Number, default : 0 }
        , flag_text : { type : String, default : '' }
        , index : { type : Number, default : 0 }
    }
    , created() {
    }
    , computed : {
        // 가격
        price_html() {
            if( this.item_price == null ) {
                return '';
            } else if( this.rental_yn ) {
                return '<em>월</em>' + this.number_format(this.item_price) + '<em>~</em>';
            } else {
                return this.number_format(this.item_price);
            }
        }
        // GET 상품 할인율
        , discount_html() {
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
        }
    }
    , methods : {
        decodeBase64(str) {
            if( str == null ) return null;
            return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
        }
        , number_format(number) {
            if( number == null || isNaN(number) )
                return '';
            else
                return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }
    }
})