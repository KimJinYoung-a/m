Vue.component('Product-Item-Type2',{
    template : `<article class="prd_item type2" v-bind:class="maskImageClassName">
                    <div class="prd_info">
                        <Product-Evaluate
                            :review_cnt="review_cnt"
                            :review_rating="review_rating"
                        >
                        </Product-Evaluate>
                        <Product-Name
                            :item_name="item_name"
                        >
                        </Product-Name>
                        <Product-Price
                            :item_price="item_price"
                            :sale_percent="sale_percent"
                            :item_coupon_yn="item_coupon_yn"
                            :item_coupon_value="item_coupon_value"
                            :item_coupon_type="item_coupon_type"
                            :rental_yn="rental_yn"
                        >
                        </Product-Price>
                    </div>
                    <Product-Image
                        :image_url="image_url"
                        :image_style="image_style"
                    >
                    </Product-Image>
                    <a @click="itemUrl(item_id)" class="prd_link"><span class="blind">상품 바로가기</span></a>
                    <WISH
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
        item_id: { type: Number, default: 0 }, // 상품코드
        image_url   : { type : String, default : '' }, // 이미지 url
        image_style : { type : String, default : '' }, // 기타 추가할 스타일
        item_price : {type : Number, default : 0}, // 상품가격
        sale_percent : {type : Number, default : 0}, // 세일 퍼센트
        item_coupon_yn : {type : Boolean, default : false}, // 상품 쿠폰 존재 여부
        item_coupon_value : {type : Number, default : 0}, // 쿠폰값
        item_coupon_type : {type : String, default : '1'}, // 쿠폰유형(0:% 할인, 1:원 할인가격)
        item_name : { type : String, default : '' }, // 상품명
        review_cnt : { type : Number, default : 0 }, // 후기 갯수
        review_rating : { type : Number, default : 0 }, // 후기 평점
        amplitudeActionName : { type : String, default : "" }, // amplitude 지정이름
        rental_yn : { type : Boolean, default : false }, // 렌탈상품 여부
        wish_place : { type : String, default : 'place' }, // 위시 장소
        wish_yn : { type : Boolean, default : false }, // 위시 on off flag
        sell_flag : { type : String, default : 'Y' }, // 판매상태
        adult_type : { type : Number, default : 0 }, // 성인상품 구분
    },
    computed : {
        maskImageClassName() {
            return {
                soldout : this.sell_flag !== "Y" ,
                adult : this.adult_type === 1
            }
        },
    }
})