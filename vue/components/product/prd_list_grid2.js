Vue.component('Product-List-Grid2',{
    template : `<div class="prd_list type_grid2">
                    <article
                        v-for="(product, index) in products"
                        :key="index" 
                        :class="get_article_classes(product.sell_flag, product.adult_type)">
                        <Product-Image :image_url="product.item_image"></Product-Image>
                        <a @click="itemUrl(product.item_id)" class="prd_link"><span class="blind">상품 바로가기</span></a>
                        <WISH
                            @change_wish_flag="change_wish_flag_item"
                            :id="product.item_id"
                            type="product"
                            :place="wish_place"
                            :product_name="product.item_name"
                            :on_flag="product.wish_yn"
                            :is_white="true"
                            :category="category"
                            :isApp="isApp"
                        ></WISH>
                    </article>
                </div>
    `,
    mixins : [item_mixin],
    props : {
        products : { // 상품 리스트
            item_id : { type : Number, default : 0 }, // 상품ID
            item_name : { type : String, default : '' }, // 상품명
            item_image : { type : String, default : '' }, // 이미지
            sell_flag : { type : String, default : 'Y' }, // 판매상태(Y:정상, S:일시품절, N:품절)
            adult_type : { type : Number, default : 0 }, // 성인상품구분
            wish_yn : { type : Boolean, default : false }, // 위시여부
            move_url : { type : String, default : '' }, // 이동할 URL
        },
        wish_place : { type : String, default : '' }, // 위시 장소(Amplitude용)
        wish_type : { type : String, default : '' }, // 위시 타입
        category: {type:Number, default:0}, // 현재 카테고리
        isApp : { type : Boolean, default : false }, // 현재 app 여부
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
        // GET 상품에 따른 클래스
        get_article_classes : function (sell_flag, adult_type) {
            let classes = 'prd_item';
            if( sell_flag !== 'Y' ) { // 판매상태
                classes += ' soldout';
            }
            if( adult_type !== 0 ) { // 성인
                classes += ' adult';
            }
            return classes;
        }
    }
})