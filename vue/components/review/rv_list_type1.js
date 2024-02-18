/*
 * 사용하는 컴포넌트(미리 선언 해줘야하는 컴포넌트들)
 * | Toggle-Type1     | /vue/components/common/tgl_type1.js     | 후기/상품 이미지 토글
 * | Product-Image    | /vue/components/product/prd_img.js      | 상품이미지
*/

Vue.component('Review-List-Type1',{
    template : `
            <div class="rv_list_type1">
                <!-- 서로 다른 상품 후기 리스트 -->
                <article
                    v-for="(review, index) in reviews"
                    :key="review.idx"
                    :id="\'review_\' + index"
                    :class="['rv_item', {soldout: review.sell_yn != 'Y'}]"
                >
                    <!-- 토글 컴포넌트 (tgl_type1) -->
                    <Toggle-Type1
                        v-if="review.review_images != null"
                        :index="index"
                        @change_photo="change_photo"
                    ></Toggle-Type1>
                    <figure class="rv_img" v-if="review.review_images != null">
                        <img :src="review.review_images[0]" alt="상품명">
                    </figure>
                    <Product-Image
                        :image_style="item_image_view_flag(review.review_images)"
                        :image_url="review.item_image"
                    ></Product-Image>
                    <Review-Info
                        @pop_view_this_item_reviews="pop_view_this_item_reviews"
                        :rv_type="'different'"
                        :item_id="review.item_id"
                        :item_name="review.item_name"
                        :total_point="review.total_point"
                        :user_id="review.user_id"
                        :content="review.content"
                        :search_keyword="search_keyword"
                    ></Review-Info>
                    <a @click="click_review(index, review)" class="rv_link"><span class="blind">상품 바로가기</span></a>
                </article>
            </div>
    `,
    props : {
        isApp : {type:Boolean, default:false}, // APP 여부
        reviews: { // 후기 리스트
            idx             : {type:Number, default:0},   // 후기idx
            item_id         : {type:Number, default:0},   // 상품id
            item_name       : {type:String, default:''},   // 상품명
            content         : {type:String, default:''},   // 후기내용
            review_images   : {type:Array, default:function(){return [];}},    // 후기이미지리스트
            item_image      : {type:String, default:''},   // 상품이미지
            user_id         : {type:String, default:''},   // 유저ID
            total_point     : {type:Number, default:0},   // 평점
            more_view_url   : {type:String, default:''},   // 이 상품 후기 더보기 url
            sell_yn         : {type:String, default:'Y'},    // 상품 상태(Y:정상, S:임시품절, N:품절)
            category_name   : {type:String, default:''}, // 1Depth 카테고리명
            brand_name_en   : {type:String, default:''} // 브랜드명(EN)
        },
        search_keyword : {type:String, default:''} // 검색 키워드
    },
    methods : {
        // 사진 변경(후기/기본)
        change_photo : function(index, type) {            
            const article = document.getElementById('review_' + index);

            const product_image = article.querySelector('figure.prd_img');
            const review_image = article.querySelector('figure.rv_img');

            const toggle_area = article.querySelector('div.tgl_type1');
            const background = toggle_area.querySelector('i.bg');
            const review_text = toggle_area.querySelectorAll('span.txt')[0];
            const product_text = toggle_area.querySelectorAll('span.txt')[1];
            const button = toggle_area.querySelector('a.btn');
            const button_text = button.querySelector('span.blind');
            const current_type = button.dataset.current;

            if( current_type === 'user' ) { // 기본사진
                product_image.style.display = 'block';
                review_image.style.display = 'none';
                review_text.classList.remove('active');
                product_text.classList.add('active');
                background.style.left = '50%';
                button.dataset.current = 'product';
                button_text.innerText = '후기사진 보기';
            } else { // 후기사진
                product_image.style.display = 'none';
                review_image.style.display = 'block';
                review_text.classList.add('active');
                product_text.classList.remove('active');
                background.style.left = '0%';
                button.dataset.current = 'user';
                button_text.innerText = '기본사진 보기';
            }
        },

        // 상품이미지 노출여부(후기이미지가 없으면 상품이미지 노출)
        item_image_view_flag : function(review_images) { 
            if( review_images != null && review_images.length > 0 )
                return 'display:none;';
            else
                return '';
        },
        // 이 상품 후기 더보기 팝업
        pop_view_this_item_reviews(item_id) {
            this.$emit('pop_view_this_item_reviews', item_id);
        },
        // 후기 클릭
        click_review(index, review) {
            this.$emit('click_review', index, review);
            this.itemUrl(review.item_id);
        }
    }
})