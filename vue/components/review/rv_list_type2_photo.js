Vue.component('Review-List-Type2-Photo',{
    template : `
            <div class="rv_list_type1 type_photo">
                <!-- 같은 상품 후기 리스트 - 사진만 -->
                <article
                    v-for="(review, index) in reviews"
                    :key="review.idx"
                    :class="['rv_item', {soldout:is_soldout(review.review_images, review.sell_yn)}]"
                >
                    <figure :class="get_rv_figure_classes(review.review_images, review.sell_yn)">
                        <img :src="get_image_url(review)" alt="상품명">
                        <span class="prd_mask"></span>
                    </figure>
                    <a @click="itemUrl(review.item_id)" class="rv_link"><span class="blind">상품 바로가기</span></a>
                </article>
            </div>
    `,
    props : {
        isApp : {type:Boolean, default:false}, // APP 여부
        reviews: {
            idx             : Number,   // 후기idx
            item_id         : Number,   // 상품id
            review_images   : Array,    // 후기이미지리스트
            item_image      : String,   // 상품이미지
            move_url        : String,   // 이동할 상품 상세 url
            sellyn          : String    // 상품 상태(Y:정상, S:임시품절, N:품절)
        }
    },
    methods : {
        // GET 이미지
        get_image_url : function(review) {
            if( review.review_images != null && review.review_images.length > 0 ) {
                return review.review_images[0];
            } else {
                return review.item_image;
            }
        },

        // GET 후기 figure 클래스
        get_rv_figure_classes : function(review_images, sell_yn) {
            if( this.is_soldout(review_images, sell_yn) ) {
                return 'prd_img';
            } else {
                return 'rv_img';
            }
        },

        // 일시품절 여부
        is_soldout : function(review_images, sell_yn) {
            return (review_images == null || review_images.length == 0) && sell_yn != 'Y';
        }
    }
})