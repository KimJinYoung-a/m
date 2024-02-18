Vue.component('Product-Slider-Type3',{
    template : `
                <!-- 상품 슬라이드 타입3 -->
                <div :id="slider_id" class="prd_slider_type3">
                    <div v-if="mdCopy" class="md_copy"><p class="bbl_ten bbl_r" v-html="mdCopy"></p></div>
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                            <template v-for="(product, index) in products">
                                <article class="swiper-slide prd_item"
                                    :key="index" :id="slider_id + '_' + index">
                                    <Product-Image :image_url="product.item_image"></Product-Image>
                                    <div class="prd_info">
                                        <div class="prd_price">
                                            <s v-if="product.org_price" class="o_price"><dfn>기본가</dfn>{{number_format(product.org_price)}}</s>
                                            <span class="set_price"><dfn>판매가</dfn>{{number_format(product.item_price)}}</span>
                                            <span v-if="product.sale_percent > 0" class="discount"><dfn>할인율</dfn>{{get_discount_html(product.sale_percent)}}</span>
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
                                        :isApp="isApp"
                                    ></WISH>
                                </article>
                            </template>
                        </div>
                    </div>
                </div>
    `,
    data() {return {
        swiper : null, // Swiper
        mdCopy : '', // 활성화된 상품 MD 카피
    }},
    props : {
        slider_id : {type : String, default : 'prd_slider_type3'},
        wish_place : { type : String, default : '' }, // 위시 장소(Amplitude용)
        wish_type : { type : String, default : '' }, // 위시 타입
        isApp : {type : Boolean, default : false }, // 앱 여부
        products : {
            item_id : {type : Number, default : 0}, // 상품 ID
            item_name : {type : String, default : ''}, // 상품명
            item_image : {type : String, default : ''}, // 상품 이미지
            org_price : {type : Number, default : 0}, // 상품가격
            item_price : {type : Number, default : 0}, // 상품가격
            sale_percent : {type : Number, default : 0}, // 세일 퍼센트
            move_url : {type : String, default : ''}, // 이동할 URL
            wish_yn : {type : Boolean, default : false}, // 위시 여부
            md_copy : {type : String, default : ''}, // MD COPY
        }
    },
    mounted : function() {
        const _this = this;
        this.mdCopy = this.products[0].md_copy;

        _this.$nextTick(function () {
            if (_this.slider_id === 'md_rolling') { // MDPICK 롤링 상품 리스트 일 때 애니메이션 효과 적용 & 카피 텍스트 변경
                _this.swiper = new Swiper('#' + _this.slider_id + `.prd_slider_type3 .swiper-container`, {
                    speed: 500,
                    slidesPerView: 'auto',
                    centeredSlides: true,
                    on: {
                        slideChange: function () {
                            // 슬라이더 이동할 때 MD COPY 변경
                            const active_product = _this.products[this.activeIndex];
                            _this.mdCopy = active_product.md_copy;
                        },
                        slideChangeTransitionStart: function(swiper) {
                            var obj = swiper.$el.prev('.md_copy');
                            obj.addClass('ani_right');
                            obj.children('.bbl_r').addClass('ani_scale_right');
                        },
                        slideChangeTransitionEnd: function(swiper) {
                            var obj = swiper.$el.prev('.md_copy');
                            obj.removeClass('ani_right');
                            obj.children('.bbl_r').removeClass('ani_scale_right');
                        }
                    }
                });
            } else {
                _this.swiper = new Swiper('#' + _this.slider_id + `.prd_slider_type3 .swiper-container`, {
                    speed: 500,
                    slidesPerView: 'auto',
                    centeredSlides: true
                });
            }
        });
    },
    updated() {
        if( this.swiper != null )
            this.swiper.update();
    },
    methods : {
        // GET 상품 할인율
        get_discount_html : function (sale_percent) {
            return sale_percent + '%';
        }
    }
})