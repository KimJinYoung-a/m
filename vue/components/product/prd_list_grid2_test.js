Vue.component('Product-List-Grid2',{
    template : `\
                <!-- 상품 리스트 그리드18 -->
                    <transition-group tag="section" class="prd_list type_grid2">
                        <article
                            v-for="(product, index) in products"
                            :key="index" 
                            :class="get_article_classes(product.sell_flag, product.adult_type)">
                            <Product-Image :image_url="product.item_image"></Product-Image>
                            <a @click="itemUrl(product.item_id)" class="prd_link"><span class="blind">상품 바로가기</span></a>
                            <WISH
                                :id="product.item_id"
                                type="product"
                                :place="wish_place"
                                :on_flag="product.wish_yn"
                            ></WISH>
                        </article>
                    </transition-group>
    `,
    mixins : [item_mixin],
    props : {
        products : { // 상품 리스트
            item_id : { type : Number, default : 0 }, // 상품ID
            item_image : { type : String, default : '' }, // 이미지
            sell_flag : { type : String, default : 'Y' }, // 판매상태(Y:정상, S:일시품절, N:품절)
            adult_type : { type : Number, default : 0 }, // 성인상품구분
            wish_yn : { type : Boolean, default : false }, // 위시여부
            move_url : { type : String, default : '' } // 이동할 URL
        },
        wish_place : { type : String, default : 'place' }, // 위시 장소
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
        },
    }
})