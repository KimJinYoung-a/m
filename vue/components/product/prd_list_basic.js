Vue.component('Product-List-Basic',{
    template : `<div :class="['prd_list', 'type_basic', {type_time : isJustSold}]">
                    <Product-Item-Basic
                        v-for="(product, index) in products"
                        @click_new_more_button="click_new_more_button"
                        :key="index"
                        @change_wish_flag="change_wish_flag_list"
                        @go_item_detail="go_item_detail"
                        :isApp="isApp"
                        :item_id="product.item_id"Product-List-Basic
                        :item_rank="product.item_rank"
                        :image_url="product.list_image"
                        :image_style="product.image_style"
                        :item_price="product.item_price"
                        :sale_percent="product.sale_percent"
                        :item_coupon_yn="product.item_coupon_yn"
                        :item_coupon_value="product.item_coupon_value"
                        :item_coupon_type="product.item_coupon_type"
                        :item_name="product.item_name"
                        :brand_name="product.brand_name"
                        :review_cnt="product.review_cnt"
                        :review_rating="product.review_rating"
                        :amplitudeActionName="product.amplitudeActionName"
                        :rental_yn="product.rental_yn"
                        :wish_yn="product.wish_yn"
                        :sell_flag="product.sell_flag"
                        :adult_type="product.adult_type"
                        :isBigImage="product.isBigImage"
                        :badge1="product.badge1"
                        :badge2="product.badge2"
                        :more_cnt="product.more_cnt"
                        :brand_id="product.brand_id"
                        :sell_minute="product.sell_minute"
                        :move_url="product.move_url"
                        :wish_type="wish_type"
                        :wish_place="wish_place"
                        :brand="brand"
                        :category="category"
                        :view_type="view_type"
                        :sort="sort"
                        :filter_recommend="filter_recommend"
                        :filter_brand="filter_brand"
                        :filter_delivery="filter_delivery"
                        :filter_lowprice="filter_lowprice"
                        :filter_highprice="filter_highprice"
                        :page="page"
                    ></Product-Item-Basic>
                </div>
    `,
    props : {
        isApp : { type : Boolean, default : false }, //  M/A 구분 App === true , Mobile === false
        wish_place : { type : String, default : '' }, // 위시 장소(Amplitude용)
        wish_type : { type : String, default : '' }, // 위시 타입
        products : {
            item_id: { type: Number, default: 0 }, // 상품코드
            item_rank : { type : Number, default : 0 }, // 상품 랭크 ex)best 사용
            list_image  : { type : String, default : '' }, // 이미지 url
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
            move_url : { type : String, default : '' }, // 이동할 Url
        },
        isJustSold : { type : Boolean, default : false }, // 방금 판매되었어요 여부
        brand: {type:String, default:''}, // 브랜드 상세 - 현재 브랜드ID
        category: {type:Number, default:0}, // 카테고리 탐색 - 현재 카테고리
        view_type: {type:String, default:''}, // 뷰 타입
        sort: {type:String, default:''}, // 정렬
        filter_recommend: {type:Array, default:function(){return [];}}, // 필터 - 추천
        filter_category: {type:Array, default:function(){return [];}}, // 필터 - 카테고리
        filter_brand: {type:Array, default:function(){return [];}}, // 필터 - 브랜드ID
        filter_delivery: {type:Array, default:function(){return [];}}, // 필터 - 배송
        filter_lowprice: {type:String, default:''}, // 필터 - 가격 최저가
        filter_highprice: {type:String, default:''}, // 필터 - 가격 최고가
        page: {type:Number, default:1}, // 현재 페이지
    },
    methods : {
        click_new_more_button(brand_id) {
            this.$emit('click_new_more_button', brand_id);
        },
        go_item_detail(item_id, move_url) {
            this.$emit('go_item_detail', item_id, move_url);
        }
    }
})