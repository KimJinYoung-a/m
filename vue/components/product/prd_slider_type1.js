Vue.component('Product-Slider-Type1',{
    template : `
                <!-- 상품 슬라이드 타입1 -->
                <div :id="slider_id" class="prd_slider_type1">
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                            <template v-for="(product, index) in products">
                                <article class="swiper-slide prd_item"
                                    :id="slider_id + '_' + index" :key="index">
                                    <Product-Image :image_url="product.big_image ? product.big_image : product.item_image"></Product-Image>
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
                                        :product_name="product.item_name"
                                        :place="wish_place"
                                        :on_flag="product.wish_yn"
                                        :isApp="isApp"
                                    ></WISH>
                                </article>
                            </template>
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
                slidesPerView: 'auto',
                centeredSlides: true,
                loopAdditionalSlides: 1,
                on: {
                    transitionEnd: function () {
                        // 초기에 활성화된 상품 상위 컴포넌트로 전달
                        if( this.activeIndex === 0 ) {
                            const active_product = _this.products[this.activeIndex];
                            _this.$emit('trans_end_slider', active_product);
                        }
                    },
                    slideChange: function () {
                        const index = _this.get_swiper_index(this.activeIndex, _this.products.length);
                        // 슬라이더 이동할 때 활성화된 상품 상위 컴포넌트로 전달
                        const active_product = _this.products[index];
                        _this.$emit('trans_end_slider', active_product);
                    },
                    slideChangeTransitionStart: function(swiper) {
                        var obj = swiper.$el.parent('.prd_slider_type1').prev('.ani');
                        if (obj.length)	obj.addClass('ani_scale_bot');
                        // _this.$emit('trans_bg_start');
                    },
                    slideChangeTransitionEnd: function(swiper) {
                        var obj = swiper.$el.parent('.prd_slider_type1').prev('.ani');
                        if (obj.length)	obj.removeClass('ani_scale_bot');
                        // _this.$emit('trans_bg_end');
                    }
                }
            });
        });
    },
    updated() {
        this.swiper.update();
    },
    props : {
        slider_id : {type : String, default : 'prd_slider_type1'},
        wish_place : { type : String, default : '' }, // 위시 장소(Amplitude용)
        wish_type : { type : String, default : '' }, // 위시 타입
        isApp : {type : Boolean, default : false }, // 앱 여부
        products : {
            item_id : {type : Number, default : 0}, // 상품 ID
            item_name : {type : String, default : ''}, // 상품명
            big_image : {type : String, default : ''}, // 큰 이미지
            item_image : {type : String, default : ''}, // 상품 이미지
            item_price : {type : Number, default : 0}, // 상품가격
            sale_percent : {type : Number, default : 0}, // 세일 퍼센트
            item_coupon_yn : {type : Boolean, default : false}, // 상품 쿠폰 존재 여부
            item_coupon_value : {type : Number, default : 0}, // 쿠폰값
            item_coupon_type : {type : String, default : '1'}, // 쿠폰유형(0:율, 1:가격)
            wish_yn : {type : Boolean, default : false}, // 위시 여부
            buy_count : {type : Number, default : 0}, // 판매량
            f_flag : {type : String, default : ''}, // 장바구니/위시 플래그(위시:F, 장바구니:B)
            wish_count : {type : Number, default : 0}, // 위시 수
        }
    }
})