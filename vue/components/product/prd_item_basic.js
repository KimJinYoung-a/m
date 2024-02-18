Vue.component('Product-Item-Basic',{
    template : `<article class="prd_item" v-bind:class="maskImageClassName" v-bind:style="{ width : isBigImage ? '100%' : '' }">
                    <Product-Rank :item_rank="rank"></Product-Rank>
                    <Product-Time :sell_minute="sell_minute"></Product-Time>
                    <Product-Image
                        :image_url="image_url"
                        :image_style="image_style"
                    >
                    </Product-Image>
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
                        <Product-Name
                            :item_name="item_name"
                        >
                        </Product-Name>
                        <Product-Brand
                            :brand_name="brand_name"
                        >
                        </Product-Brand>
                        <Product-Badge
                            :badge1="badge1"
                            :badge2="badge2"
                        >
                        </Product-Badge>
                        <Product-Evaluate
                            :review_cnt="review_cnt"
                            :review_rating="review_rating"
                        >
                        </Product-Evaluate>
                    </div>
                    <a @click="itemUrl(item_id, move_url)" class="prd_link"><span class="blind">상품 바로가기</span></a>
                    <WISH
                        @change_wish_flag="change_wish_flag_item"
                        :id="item_id"
                        type="product"
                        :place="wish_place"
                        :on_flag="wish_yn"
                        :is_white="true"
                        :brand="brand"
                        :product_name="item_name"
                        :category="category"
                        :view_type="view_type"
                        :sort="sort"
                        :filter_recommend="filter_recommend"
                        :filter_category="filter_category"
                        :filter_brand="filter_brand"
                        :filter_delivery="filter_delivery"
                        :filter_lowprice="filter_lowprice"
                        :filter_highprice="filter_highprice"
                        :isApp="isApp"
                    >
                    </WISH>
                    <Product-MoreButton
                        @click_OpenModal="click_new_more_button"
                        :more_cnt="more_cnt"
                        :brand_id="brand_id"
                    >
                    </Product-MoreButton>
                </article>
                `,
    props : {
        isApp : { type : Boolean, default : false }, //  M/A 구분 App === true , Mobile === false
        item_id: { type: Number, default: 0 }, // 상품코드
        rank : { type : Number, default : 0 }, // 상품 랭크 ex)best 사용
        image_url   : { type : String, default : '' }, // 이미지 url
        image_style : { type : String, default : '' }, // 기타 추가할 스타일
        item_price : {type : Number, default : 0}, // 상품가격
        sale_percent : {type : Number, default : 0}, // 세일 퍼센트
        item_coupon_yn : {type : Boolean, default : false}, // 상품 쿠폰 존재 여부
        item_coupon_value : {type : Number, default : 0}, // 쿠폰값
        item_coupon_type : {type : String, default : '1'}, // 쿠폰유형(0:% 할인, 1:원 할인가격)
        item_name : { type : String, default : '' }, // 상품명
        brand_name : { type : String, default : '' }, // 브랜드명
        review_cnt : { type : Number, default : 0 }, // 후기 갯수
        review_rating : { type : Number, default : 0 }, // 후기 평점
        amplitudeActionName : { type : String, default : "" }, // amplitude 지정이름
        rental_yn : { type : Boolean, default : false }, // 렌탈상품 여부
        wish_yn : { type : Boolean, default : false }, // 위시 on off flag
        sell_flag : { type : String, default : 'Y' }, // 판매상태
        adult_type : { type : Number, default : 0 }, // 성인상품 구분
        isBigImage : { type : Boolean, default : false }, // 큰이미지 적용 여부
        badge1 : { type : String, default : '' }, // 뱃지1 텍스트
        badge2 : { type : String, default : '' }, // 뱃지 2 텍스트
        more_cnt : { type : Number, default : 0 }, // 신규 상품 더보기 갯수
        brand_id : { type : String, default : '' }, // 브랜드 ID
        sell_minute : { type : Number, default : 0 }, // 판매로부터 지난 시간
        wish_place : { type : String, default : '' }, // 위시 장소(Amplitude용)
        wish_type : { type : String, default : '' }, // 위시 타입
        brand: {type:String, default:''}, // 브랜드 상세 - 현재 브랜드ID
        category: {type:Number, default:0}, // 현재 카테고리
        view_type: {type:String, default:''}, // 뷰 타입
        sort: {type:String, default:''}, // 정렬
        filter_recommend: {type:Array, default:function(){return [];}}, // 필터 - 추천
        filter_category: {type:Array, default:function(){return [];}}, // 필터 - 카테고리
        filter_brand: {type:Array, default:function(){return [];}}, // 필터 - 브랜드ID
        filter_delivery: {type:Array, default:function(){return [];}}, // 필터 - 배송
        filter_lowprice: {type:String, default:''}, // 필터 - 가격 최저가
        filter_highprice: {type:String, default:''}, // 필터 - 가격 최고가
        page: {type:Number, default:1}, // 현재 페이지
        move_url : { type : String, default : '' }, // 이동할 Url
    },
    computed : {
        maskImageClassName() {
            return {
                soldout : this.sell_flag !== "Y" ,
                adult : this.adult_type === 1
            }
        }
    },
    methods : {
        click_new_more_button(brand_id) {
            this.$emit('click_new_more_button', brand_id);
        }
    }
})