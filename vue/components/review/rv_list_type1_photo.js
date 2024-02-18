/*
 * 사용하는 컴포넌트(미리 선언 해줘야하는 컴포넌트들)
 * | Product-Image    | /vue/components/product/prd_img.js      | 상품이미지
*/

Vue.component('Review-List-Type1-Photo',{
    template : `
            <div class="rv_list_type1 type_photo">
                <!-- 서로 다른 상품 후기 리스트 - 사진만 -->
                <article
                    v-for="(review, index) in reviews"
                    :key="review.idx"
                    :id="'review_' + index"
                    :class="['rv_item', {soldout: review.sell_yn != 'Y'}]"
                >
                    <Product-Image
                        :image_url="get_image_url(review)"
                    ></Product-Image>
                    <a @click="click_review(index, review)" class="rv_link"><span class="blind">상품 바로가기</span></a>
                </article>
            </div>
    `,
    props : {
        isApp : {type:Boolean, default:false}, // APP 여부
        reviews: {
            idx             : {type:Number, default:0},   // 후기idx
            item_id         : {type:Number, default:0},   // 상품id
            review_images   : {type:Array, default:function(){return [];}},    // 후기이미지리스트
            item_image      : {type:String, default:''},   // 상품이미지
            sell_yn          : {type:String, default:'Y'},    // 상품 상태(Y:정상, S:임시품절, N:품절)
            category_name   : {type:String, default:''}, // 1Depth 카테고리명
            brand_name_en   : {type:String, default:''} // 브랜드명(EN)
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
        // 후기 클릭
        click_review(index, review) {
            this.$emit('click_review', index, review);
            this.itemUrl(review.item_id);
        }
    }
})