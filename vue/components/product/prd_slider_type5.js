Vue.component('Product-Slider-Type5',{
    template : `
        <!-- 상품 슬라이드 타입5 -->
        <div :id="slider_id" class="prd_slider_type5">
            <div class="swiper-container">
                <div class="swiper-wrapper">
                    <template v-for="(product, index) in products">
                        <article class="swiper-slide prd_item"
                            :key="index" :id="slider_id + '_' + index">
                            <Product-Image-Svg 
                                :shape_type="shape_arr[index]"
                                :sell_flag="product.sell_flag"
                                :adult_type="product.adult_type"
                                :image_url="product.item_image"
                            ></Product-Image-Svg>
                            <div class="prd_info">
                                <div class="prd_price">
                                    <span class="set_price"><dfn>판매가</dfn>{{number_format(product.item_price)}}</span>
                                    <span class="discount" v-html="get_discount_html(product)"></span>
                                </div>
                                <div class="prd_name">{{product.item_name}}</div>
                            </div>
                            <i v-if="type == 'new'" class="bg" data-swiper-parallax-x="-20"></i>
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
    data() { return {
        shape_arr: [ // 슬라이더 svg모양 배열(fix)
            'circle'
            ,'clover'
            ,'diamond'
            ,'circle'
            ,'round_diamond'
            ,'speech_bubble'
            ,'clover'
            ,'diamond'
            ,'bumpy'
            ,'star_diamond'
        ],
        swiper : null
    }},
    props : {
        slider_id : {type : String, default : 'prd_slider_type5'},
        wish_place : { type : String, default : '' }, // 위시 장소(Amplitude용)
        wish_type : { type : String, default : '' }, // 위시 타입
        isApp : {type : Boolean, default : false }, // 앱 여부
        type : {type : String, default : '' }, // 구분값 (new:뉴메인)
        products : {
            item_id : {type : Number, default : 0}, // 상품 ID
            item_name : {type : String, default : ''}, // 상품명
            item_image : {type : String, default : ''}, // 큰 이미지
            item_price : {type : Number, default : 0}, // 상품가격
            sale_percent : {type : Number, default : 0}, // 세일 퍼센트
            item_coupon_yn : {type : Boolean, default : false}, // 상품 쿠폰 존재 여부
            item_coupon_value : {type : Number, default : 0}, // 쿠폰값
            item_coupon_type : {type : String, default : '1'}, // 쿠폰유형(0:율, 1:가격)
            move_url : {type : String, default : ''}, // 이동할 URL
            wish_yn : {type : Boolean, default : false}, // 위시 여부
            sell_flag : {type : String, default : ''}, // 판매 여부
            adult_type : {type : Number, default : 0} // 성인상품 구분
        }
    },
    mounted() {
        const _this = this;
        _this.$nextTick(function () {
            var option;
            if(_this.type == 'new') {
                option = {
                    speed: 5000,
                    slidesPerView: 'auto',
                    freeMode: true,
                    // loop: true,
                    // loopedSlides: 30,
                    autoplay: {
                        delay: 1,
                        disableOnInteraction: true
                    },
                    parallax: true
                }
            } else {
                option = {
                    speed: 5000,
                    slidesPerView: 'auto',
                    freeMode: true,
                    // loop: true,
                    // loopedSlides: 30,
                    autoplay: {
                        delay: 1,
                        disableOnInteraction: true
                    }
                }
            }
            _this.swiper = new Swiper('#' + _this.slider_id + `.prd_slider_type5 .swiper-container`, option);
        });
    },
    updated() {
        this.swiper.update();
    },
})