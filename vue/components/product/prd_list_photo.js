Vue.component('Product-List-Photo',{
    template : `<div class="prd_list type_photo">
                    <Product-Item-Photo
                        v-for="(product, index) in products"
                        @change_wish_flag="change_wish_flag_list"
                        :key="index"
                        :isApp="isApp"
                        :item_id="product.item_id"
                        :item_name="product.item_name"
                        :image_url="product.big_image ? product.big_image : product.list_image"
                        :image_style="product.image_style"
                        :amplitudeActionName="product.amplitudeActionName"
                        :wishType="product.wishType"
                        :wish_yn="product.wish_yn"
                        :sell_flag="product.sell_flag"
                        :adult_type="product.adult_type"
                        :isBigImage="product.isBigImage"
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
                    ></Product-Item-Photo>
                </div>
    `,
    props : {
        isApp : { type : Boolean, default : false }, //  M/A 구분 App === true , Mobile === false
        wish_type : { type : String, default : '' }, // 위시 구분값
        wish_place : { type : String, default : 'place' }, // 위시 구분값
        products : {
            item_id: { type: Number, default: 0 }, // 상품코드
            item_name: { type: String, default: '' }, // 상품명
            big_image   : { type : String, default : '' }, // 이미지 url
            list_image   : { type : String, default : '' }, // 이미지 url
            image_style : { type : String, default : '' }, // 기타 추가할 스타일
            amplitudeActionName : { type : String, default : "" }, // amplitude 지정이름
            wishType : { type : String, default : 'product' }, // 위시 타입
            wish_yn : { type : Boolean, default : false }, // 위시 on off flag
            sell_flag : { type : String, default : 'Y' }, // 판매상태
            adult_type : { type : Number, default : 0 }, // 성인상품 구분
            isBigImage : { type : Boolean, default : false }, // 큰이미지 적용 여부
        },
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
    },
})