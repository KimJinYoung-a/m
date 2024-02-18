Vue.component('Review-List-This-Item',{
    template : `
        <div class="modalV20 modal_type4" id="modal">
            <div @click="close_pop_view_this_item_reviews" class="modal_overlay"></div>
            <div class="modal_wrap">
                <div class="modal_header">
                    <h2>모달</h2>
                    <button class="btn_close" @click="close_pop_view_this_item_reviews"><i class="i_close"></i>모달닫기</button>
                </div>
                <div class="modal_body">
                    <div @scroll="scroll_modal" class="modal_cont review_more">
                        <!-- 상품 기본정보 -->
                        <article :class="get_product_class">
                            <div class="prd_info">
                                <div class="user_side">
                                    <span class="user_comment">{{number_format(review_count)}}개의 후기</span>
                                </div>
                                <Product-Name :item_name="product.item_name"></Product-Name>
                                <Product-Price
                                    :item_price="product.item_price"
                                    :sale_percent="product.sale_percent"
                                    :item_coupon_yn="product.item_coupon_yn"
                                    :item_coupon_value="product.item_coupon_value"
                                    :item_coupon_type="product.item_coupon_type"
                                    :rental_yn="product.rental_yn"
                                ></Product-Price>
                            </div>
                            <Product-Image
                                :image_url="product.item_image"
                            ></Product-Image>
                            <a @click="itemUrl(product.item_id)" class="prd_link"><span class="blind">상품 바로가기</span></a>
                            <WISH
                                @change_wish_flag="change_wish_flag_item"
                                :id="product.item_id"
                                :on_flag="product.wish_yn"
                                type="product"
                                :place="wish_place"
                                :product_name="product.item_name"
                                :is_white="true"
                                :isApp="isApp"
                            ></WISH>
                        </article>
                        <article class="prd_item fixed">
                            <figure class="prd_img">
                                <img :src="product.item_image" alt="상품명">
                            </figure>
                            <a @click="itemUrl(product.item_id)" class="prd_link"><span class="blind">상품 바로가기</span></a>
                        </article>
                        
                        <!-- 뷰 타입 탭 -->
                        <Tab-View-Type @change_view_type="change_view_type" :view_type="view_type"></Tab-View-Type>
                        
                        <!-- 후기 리스트 -->
                        <Review-List-Type2
                            v-if="reviews.length > 0 && view_type == 'detail'"
                            :isApp="isApp"
                            :reviews="reviews"
                        ></Review-List-Type2>
                        <Review-List-Type2-Photo
                            v-else-if="reviews.length > 0 && view_type == 'photo'"
                            :isApp="isApp"
                            :reviews="reviews"
                        ></Review-List-Type2-Photo>
                    </div>
                </div>
            </div>
        </div>
    `,
    props : {
        isApp : {type:Boolean, default:false}, // APP 여부
        product: { // 상품 정보
            item_id : {type:Number, default:0}, // 상품ID
            item_name : {type:String, default:''}, // 상품명
            item_price : {type:Number, default:0}, // 상품 가격
            sale_percent : {type:Number, default:0}, // 세일 퍼센트
            sale_yn : {type:Boolean, default:false}, // 세일여부
            item_coupon_yn : {type:Boolean, default:false}, // 쿠폰여부
            item_coupon_value : {type:Number, default:0}, // 쿠폰 값
            item_coupon_type : {type:String, default:'1'}, // 쿠폰구분값
            item_image : {type:String, default:''}, // 상품 이미지
            rental_yn : { type : Boolean, default : false }, // 렌탈상품 여부
            wish_yn : {type:Boolean, default:false}, // 위시 여부
            sell_flag : {type:String, default:'Y'} // 판매 상태
        },
        view_type: {type:String, default:'detail'}, // 뷰 타입
        reviews: {type:Array, default:function(){return [];}}, // 리뷰 리스트
        review_count: {type:Number, default:0}, // 리뷰 갯수
        is_loading: {type:Boolean, default:false}, // 페이지 로딩 여부
        is_end_page: {type:Boolean, default:false}, // 페이지 종료 여부
        wish_place : { type : String, default : '' }, // 위시 장소(Amplitude용)
        wish_type : { type : String, default : '' }, // 위시 타입
    },
    computed: {
        get_product_class() {
            return `prd_item type2 ${this.product.sell_flag==='Y' ? '' : 'soldout'}`;
        }
    },
    methods : {
        scroll_modal(e) { // 스크롤
            // 페이징
            if( (e.target.scrollHeight - e.target.offsetHeight - e.target.scrollTop) <= 300
                    && !this.is_loading && !this.is_end_page )
                this.$emit('get_more_this_item_reviews', this.product.item_id);

            // 상품 기본정보 벗어나면 이미지 노출
            if (e.target.scrollTop >= document.querySelector('.review_more .prd_item').offsetHeight) {
                $('.review_more .prd_item.fixed').show();
            } else {
                $('.review_more .prd_item.fixed').hide();
            }
        },
        change_view_type(type) {
            this.$emit('change_view_type', type);
        },
        close_pop_view_this_item_reviews() {
            this.$emit('close_pop_view_this_item_reviews');
        }
    }
})