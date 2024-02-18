Vue.component('Product-Item-Photo',{
    template : `<article class="prd_item" v-bind:class="maskImageClassName" v-bind:style="{ width : isBigImage ? '100%' : '' }">
                    <Product-Image
                        :image_url="image_url"
                        :image_style="image_style"
                    >
                    </Product-Image>
                    <span v-if="sale_percent > 0" class="discount"><dfn>할인율</dfn>{{sale_percent}}%</span>
                    <a @click="itemUrl(item_id, move_url)" class="prd_link"><span class="blind">상품 바로가기</span></a>
                    <WISH
                        @change_wish_flag="change_wish_flag_item"
                        :id="item_id.toString()"
                        type="product"
                        :place="wish_place"
                        :on_flag="wish_yn"
                        :is_white="true"
                        :brand="brand"
                        :category="category"
                        :product_name="item_name"
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
                </article>
                `,
    props : {
        isApp : { type : Boolean, default : false }, //  M/A 구분 App === true , Mobile === false
        item_id: { type: Number, default: 0 }, // 상품코드
        item_name   : { type : String, default : '' }, // 상품명
        image_url   : { type : String, default : '' }, // 이미지 url
        image_style : { type : String, default : '' }, // 기타 추가할 스타일
        amplitudeActionName : { type : String, default : "" }, // amplitude 지정이름
        wish_yn : { type : Boolean, default : false }, // 위시 on off flag
        sell_flag : { type : String, default : 'Y' }, // 판매상태
        adult_type : { type : Number, default : 0 }, // 성인상품 구분
        move_url : { type : String, default : '' }, // 이동할 Url
        isBigImage : { type : Boolean, default : false }, // 큰이미지 적용 여부
        sale_percent : { type : Number, default : 0 }, // 할인율
        wish_place : { type : String, default : 'place' }, // 위시 장소(Amplitude용)
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
    },
    computed : {
        maskImageClassName() {
            return {
                soldout : this.sell_flag !== "Y" ,
                adult : this.adult_type === 1
            }
        }
    }
})