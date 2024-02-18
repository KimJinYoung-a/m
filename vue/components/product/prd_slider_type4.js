Vue.component('Product-Slider-Type4',{
    template : `
                <!-- 상품 슬라이드 타입4 -->
                <div :id="slider_id" class="prd_slider_type4">
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                            <template v-for="(product, index) in products">
                                <article class="swiper-slide prd_item"
                                    :key="index" :id="slider_id + '_' + index">
                                    <Product-Image :image_url="product.list_image"></Product-Image>
                                    <div class="prd_info">
                                        <div class="prd_price">
                                            <span class="set_price"><dfn>판매가</dfn>{{number_format(product.item_price)}}</span>
                                            <span class="discount" v-html="get_discount_html(product)"></span>
                                        </div>
                                        <div class="prd_name">{{product.item_name}}</div>
                                    </div>
                                    <a @click="itemUrl(product.item_id)" class="prd_link"><span class="blind">상품 바로가기</span></a>
                                    <WISH
                                        @change_wish_flag="change_wish_flag_item"
                                        :id="product.item_id"
                                        type="product"
                                        :place="wish_place"
                                        :product_name="product.item_name"
                                        :on_flag="product.wish_yn"
                                        :is_white="true"
                                        :isApp="isApp"
                                    ></WISH>
                                </article>
                            </template>
                            <div v-if="brand_more_new_yn" class="swiper-slide">
                                <button type="button" class="btn_more" @click="linkToBrand"><i class="i_arw_line_r"></i><span class="txt">브랜드 신상품<br>전체보기</span></button>
                            </div>
                        </div>
                    </div>
                </div>
    `,
    data() {return {
        swiper : null
    }},
    mounted() {
        const _this = this;
        _this.$nextTick(function () {
            _this.swiper = new Swiper('#' + _this.slider_id + ' .swiper-container', {
                speed: 500,
                slidesPerView: 'auto'
            });
        });
    },
    updated() {
        this.swiper.update();
    },
    props : {
        slider_id : {type : String, default : 'prd_slider_type4'},
        wish_place : { type : String, default : '' }, // 위시 장소(Amplitude용)
        wish_type : { type : String, default : '' }, // 위시 타입
        isApp : {type : Boolean, default : false }, // 앱 여부
        products : {
            item_id : {type : Number, default : 0}, // 상품 ID
            item_name : {type : String, default : ''}, // 상품명
            big_image : {type : String, default : ''}, // 큰 이미지
            item_price : {type : Number, default : 0}, // 상품가격
            sale_percent : {type : Number, default : 0}, // 세일 퍼센트
            item_coupon_yn : {type : Boolean, default : false}, // 상품 쿠폰 존재 여부
            item_coupon_value : {type : Number, default : 0}, // 쿠폰값
            item_coupon_type : {type : String, default : '1'}, // 쿠폰유형(0:율, 1:가격)
            move_url : {type : String, default : ''}, // 이동할 URL
            wish_yn : {type : Boolean, default : false}, // 위시 여부
        },
        brand_more_new_yn : {type : Boolean, default : false}, // 브랜드 신상품 더보기 노출 여부
    },
    methods : {
        linkToBrand() {
            this.$emit('linkToBrand');
        },
    }
})