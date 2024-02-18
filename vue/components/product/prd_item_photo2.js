Vue.component('Product-Item-Photo2',{
    template : `<article class="prd_item" v-bind:class="maskImageClassName">
                    <Product-Image :image_url="item_image"/>
                    <a @click="go_item_detail" class="prd_link"><span class="blind">상품 바로가기</span></a>
                    <WISH
                        v-if="!isBiz"
                        @change_wish_flag="change_wish_flag_item"
                        :id="product.item_id.toString()"
                        type="product"
                        :place="wish_place"
                        :product_name="product.item_name"
                        :on_flag="product.wish_yn"
                        :is_white="true"
                        :view_type="view_type"
                        :sort="sort"
                        :filter_recommend="filter_recommend"
                        :filter_category="filter_category"
                        :filter_brand="filter_brand"
                        :filter_delivery="filter_delivery"
                        :filter_lowprice="filter_lowprice"
                        :filter_highprice="filter_highprice"
                        :isApp="isApp"
                        :category="category"
                        :brand="brand"
                    />
                </article>
                `,
    props : {
        isApp : { type : Boolean, default : false }, //  M/A 구분 App === true , Mobile === false
        index : { type: Number, default: 0 }, // 인덱스
        product : {
            item_id: { type: Number, default: 0 }, // 상품코드
            item_name: { type: String, default: '' }, // 상품명
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
        category: {type:Number, default:0}, // 현재 카테고리
        page: {type:Number, default:1}, // 현재 페이지
        brand: {type:String, default:''}, // 브랜드 상세 - 현재 브랜드ID
        isBiz : {type: Boolean, default: false}, // Biz상품 여부(WISH 표시 X)
    },
    computed : {
        maskImageClassName() {
            return {
                soldout : this.product.sell_flag !== "Y" ,
                adult : this.product.adult_type !== 0
            }
        },
        item_image() {
            if( this.product.item_image != null && this.product.item_image !== '' ) {
                return this.product.item_image;
            } else if( this.product.big_image != null && this.product.big_image !== '' ) {
                return this.product.big_image;
            } else {
                return this.product.list_image;
            }
        },
    },
    methods : {
        go_item_detail() {
            this.$emit('go_item_detail', this.index, this.product);
            this.itemUrl(this.product.item_id, this.product.move_url);
        }
    }
})