Vue.component('Review-List-Type2',{
    template : `\
            <div class="rv_list_type2">
                <article
                    v-for="(review, index) in reviews"
                    :key="review.idx"
                    :id="'review_' + index"
                    class="rv_item"
                >
                    <div class="rv_img_slider"
                        v-if="is_not_empty_review_images(review.review_images)"
                    >
                        <div class="swiper-container">
                            <div class="swiper-wrapper">
                                <figure class="swiper-slide rv_img"
                                    v-for="review_image in review.review_images"
                                >
                                    <img :src="review_image" alt="">
                                </figure>
                            </div>
                            <div class="swiper-pagination"></div>
                        </div>
                    </div>
                    <Review-Info
                        :rv_type="'same'"
                        :total_point="review.total_point"
                        :user_id="review.user_id"
                        :content="review.content"
                    ></Review-Info>
                    <a @click="itemUrl(review.item_id)" class="rv_link"><span class="blind">상품 바로가기</span></a>
                </article>
            </div>
    `,
    props : {
        isApp : {type:Boolean, default:false}, // APP 여부
        // 후기 리스트
        reviews: {
            idx             : Number,   // 후기idx
            item_id         : Number,   // 상품id
            item_name       : String,   // 상품명
            content         : String,   // 후기내용
            review_images   : Array,    // 후기이미지리스트
            item_image      : String,   // 상품이미지
            user_id         : String,   // 유저ID
            total_point     : Number,   // 평점
            move_url        : String,   // 이동할 상품 상세 url
            more_view_url   : String,   // 이 상품 후기 더보기 url
            sellyn          : String    // 상품 상태(Y:정상, S:임시품절, N:품절)
        }
    },
    mounted : function() {
        // 이미지 슬라이더
        $('.rv_img_slider').each(function(i, el) {
            var slider = $(el).find('.swiper-container'),
                lth = slider.find('.swiper-slide').length;
            if (lth > 1) {
                slider.addClass('on'+i);
                var rvImgSlider = new Swiper('.swiper-container.on'+i, {
                    speed: 500,
                    slidesPerView: 'auto',
                    pagination: {
                        el: '.swiper-pagination',
                        type: 'progressbar'
                    }
                });			
            }
        });
    },
    methods : {
        // 포토후기인지
        is_not_empty_review_images : function(review_images) {
            return review_images != null && review_images.length > 0;
        },

        // GET 후기 점수
        get_review_point : function(total_point) {
            return total_point * 20;
        }
    }
})