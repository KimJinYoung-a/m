Vue.component('Product-Slider-Type6',{
    template : `
        <!-- 상품 슬라이드 타입6 -->
        <div :id="slider_id" class="prd_slider_type6">
            <div class="swiper-container">
                <div class="swiper-wrapper">
                    <div class="swiper-slide" v-for="(p, index) in products_arr" :key="index">
                        <template v-for="(product, index2) in p">
                            <article class="prd_item"
                                :key="index2" :id="slider_id + '_' + index">
                                <Product-Image-Svg 
                                    :shape_type="shape_arr[index2]"
                                    :sell_flag="product.sell_flag"
                                    :adult_type="product.adult_type"
                                    :image_url="product.item_image"
                                ></Product-Image-Svg>
                                <span class="discount" v-html="get_discount_html(product)"></span>
                                <a @click="itemUrl(product.item_id)" class="prd_link"><span class="blind">상품 바로가기</span></a>
                            </article>
                        </template>
                    </div>
                </div>
            </div>
        </div>
    `,
    data() {
        return {
            shape_arr: [],
            swiper : null
        }
    },
    created() {
        let shape_arr = [ // 슬라이더 svg모양 배열(fix)
             'bumpy'
            ,'diamond'
            ,'circle'
            ,'star_diamond'
            ,'clover'
            ,'speech_bubble'
            ,'round_diamond'
            ,'circle'
            ,'diamond'
            ,'star_diamond'
        ];
        const temp_shape_arr = shape_arr;
        for( var i=0 ; i<4 ; i++ ) {
            shape_arr = shape_arr.concat(temp_shape_arr);
        }
        this.shape_arr = shape_arr;
    },
    props : {
        slider_id : {type : String, default : 'prd_slider_type6'},
        isApp : {type : Boolean, default : false }, // 앱 여부
        products : {
            item_id : { type : Number, default : 0 }, // 상품ID
            item_image : { type : String, default : '' }, // 이미지
            sell_flag : { type : String, default : 'Y' }, // 판매상태(Y:정상, S:일시품절, N:품절)
            adult_type : { type : Number, default : 0 }, // 성인상품구분
            wish_yn : { type : Boolean, default : false }, // 위시여부
            move_url : { type : String, default : '' }, // 이동할 URL
            sale_percent : { type : Number, default : 0 } // 할인율
        }
    },
    computed: {
        products_arr() {
            let products_arr = [];
            for( let i=0 ; i<this.products.length/10 ; i++ ) {
                products_arr.push(this.products.slice(i*10, i*10 + 10));
            }
            return products_arr;
        }
    },
    mounted : function() {
        const _this = this;
        _this.$nextTick(function () {
            _this.swiper = new Swiper('#' + _this.slider_id + '.prd_slider_type6 .swiper-container', {
                speed: 15000,
                slidesPerView: 'auto',
                freeMode: true,
                // loop: true,
                // loopedSlides: 15,
                autoplay: {
                    delay: 1,
                    disableOnInteraction: true
                }
            });
        });
    },
    updated() {
        this.swiper.update();
    }
})