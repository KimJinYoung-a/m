Vue.component('Product-List-Photo2',{
    template : `<div class="prd_list type_photo">
                    <Product-Item-Photo2
                        v-for="(product, index) in products"
                        @go_item_detail="go_item_detail"
                        @change_wish_flag="change_wish_flag_list"
                        :key="index"
                        :index="index + 1"
                        :isApp="isApp"
                        :product="product"
                        wishType="product"
                        :wish_type="wish_type"
                        :wish_place="wish_place"
                        :view_type="view_type"
                        :sort="sort"
                        :filter_recommend="filter_recommend"
                        :filter_category="filter_category"
                        :filter_brand="filter_brand"
                        :filter_delivery="filter_delivery"
                        :filter_lowprice="filter_lowprice"
                        :filter_highprice="filter_highprice"
                        :category="category"
                        :page="page"
                        :brand="brand"
                        :isBiz="isBiz"
                    ></Product-Item-Photo2>
                </div>
    `,
    props : {
        isApp : { type : Boolean, default : false }, //  M/A 구분 App === true , Mobile === false
        products : {
            item_id: { type: Number, default: 0 }, // 상품코드
            item_name : { type : String, default : '' }, // 상품명
            item_image : { type : String, default : '' }, // 이미지 url
            list_image : { type : String, default : '' }, // 이미지 url
            big_image : { type : String, default : '' }, // 이미지 url
            amplitudeActionName : { type : String, default : "" }, // amplitude 지정이름
            wish_yn : { type : Boolean, default : false }, // 위시 on off flag
            sell_flag : { type : String, default : 'Y' }, // 판매상태
            adult_type : { type : Number, default : 0 }, // 성인상품 구분
            move_url : { type : String, default : '' }, // 이동 할 Url
            category_code: {type: String, default: ''}, // 상품 카테고리 코드
            category_name: {type: String, default: ''}, // 상품 카테고리 코드
            brand_name_en: {type: String, default: ''}, // 브랜드명(EN)
        },
        wish_type : { type : String, default : '' }, // 위시 구분값
        wish_place : { type : String, default : 'place' }, // 위시 장소
        view_type: {type:String, default:''}, // 뷰 타입
        sort: {type:String, default:''}, // 정렬
        filter_recommend: {type:Array, default:function(){return [];}}, // 필터 - 추천
        filter_category: {type:Array, default:function(){return [];}}, // 필터 - 카테고리
        filter_brand: {type:Array, default:function(){return [];}}, // 필터 - 브랜드ID
        filter_delivery: {type:Array, default:function(){return [];}}, // 필터 - 배송
        filter_lowprice: {type:String, default:''}, // 필터 - 가격 최저가
        filter_highprice: {type:String, default:''}, // 필터 - 가격 최고가
        category: { type: Number, default: 0 }, // 카테고리
        page: { type: Number, default: 0 }, // 페이지
        brand: {type:String, default:''}, // 브랜드 상세 - 현재 브랜드ID
        isBiz : {type: Boolean, default: false}, // Biz상품 여부(WISH 표시 X)
    },
    methods : {
        go_item_detail(index, product) {
            this.$emit('go_item_detail', index, product);
        }
    }
})