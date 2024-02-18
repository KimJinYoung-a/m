Vue.component('Product-Item-Type3',{
    template : `<article class="prd_item type3" v-bind:class="maskImageClassName">
                    <div v-if="bubble_html != null && bubble_html != ''" class="bbl_ten bbl_b label_rank ani_bnc" v-html="bubble_html"></div>
                    <Product-Image-Svg
                        ref="product_image"
                        :shape_type="shape_type"
                        :sell_flag="sell_flag"
                        :adult_type="adult_type"
                        :image_url="image_url"
                    >
                    </Product-Image-Svg>
                    <div class="prd_info">
                        <Product-Price
                            :item_price="item_price"
                            :sale_percent="sale_percent"
                            :item_coupon_yn="item_coupon_yn"
                            :item_coupon_value="item_coupon_value"
                            :item_coupon_type="item_coupon_type"
                            :rental_yn="rental_yn"
                        >
                        </Product-Price>
                        <Product-Name :item_name="item_name"></Product-Name>
                    </div>
                    <i v-if="type == 'best'" class="bg_best"></i>
                    <a @click="itemUrl(item_id)" class="prd_link"><span class="blind">상품 바로가기</span></a>
                    <WISH
                        @change_wish_flag="change_wish_flag_item"
                        :id="item_id"
                        type="product"
                        :product_name="item_name"
                        :place="wish_place"
                        :on_flag="wish_yn"
                        :isApp="isApp"
                    >
                    </WISH>
                </article>
                `,
    props : {
        isApp : { type : Boolean, default : false }, //  M/A 구분 App === true , Mobile === false
        type : { type : String, default : '' }, // 구분값 (best:베스트메인)
        item_id: { type: Number, default: 0 }, // 상품코드
        image_url   : { type : String, default : '' }, // 이미지 url
        shape_type : { type : String, default : 'circle' }, // SVG 모양
        item_price : { type : Number, default : 0 }, // 최종 가격
        sale_percent : { type : Number, default : 0 }, // 세일 할인율
        item_coupon_yn : {type : Boolean, default : false}, // 상품 쿠폰 존재 여부
        item_coupon_value : {type : Number, default : 0}, // 쿠폰값
        item_coupon_type : {type : String, default : '1'}, // 쿠폰유형(0:% 할인, 1:원 할인가격)
        item_name : { type : String, default : '' }, // 상품명
        review_cnt : { type : Number, default : 0 }, // 후기 갯수
        review_rating : { type : Number, default : 0 }, // 후기 평점
        amplitudeActionName : { type : String, default : "" }, // amplitude 지정이름
        rental_yn : { type : Boolean, default : false }, // 렌탈상품 여부
        wish_place : { type : String, default : 'place' }, // 위시 장소(Amplitude용)
        wish_type : { type : String, default : '' }, // 위시 타입
        wish_yn : { type : Boolean, default : false }, // 위시 on off flag
        sell_flag : { type : String, default : 'Y' }, // 판매상태
        adult_type : { type : Number, default : 0 }, // 성인상품 구분
        bubble_html : { type : String, default : '' }, // 말풍선 Html
    },
    computed : {
        maskImageClassName() {
            return {
                soldout : this.sell_flag !== "Y" ,
                adult : this.adult_type === 1
            }
        },
    },
    methods : {
        change_image_shpae() { // 이미지 모양 변경
            this.$refs.product_image.change_image_shpae();
        }
    }
})