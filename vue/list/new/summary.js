var app = new Vue({
    el: '#app',
    store: store,
    mixins : [item_mixin, modal_mixin, common_mixin],
    template: `
        <div id="content" class="content new_main">
        
            <!-- 지금, 주목할만한 신상 -->
            <section v-if="rolling_products.length > 0" class="item_module">
                <header class="head_type1">
                    <h2 class="ttl">만나서<br>반가워요!</h2>
                </header>
                <Product-Slider-Type5
                    @change_wish_flag="change_wish_flag_product"
                    slider_id="new_rolling"
                    :products="rolling_products"
                    type="new"
                    wish_place="new_summary_top"
                    wish_type="rolling"
                    :isApp="isApp"
                ></Product-Slider-Type5>
            </section>
            
            <!-- 새롭게 선보이는 브랜드 -->
            <section v-if="new_brands.length > 0" class="item_module">
                <header class="head_type1">
                    <h2 class="ttl">새로운 식구를<br>소개할게요</h2>
                </header>
                <Brand-Set-Type2
                    v-for="brand in new_brands"
                    :key="brand.brand_id"
                    @change_wish_flag="change_wish_flag_brand"
                    :isApp="isApp"
                    :brand_id="brand.brand_id"
                    :brand_name="brand.brand_name"
                    :brand_name_en="brand.brand_name_en"
                    :wish_yn="brand.wish_yn"
                    :products="brand.items"
                    wish_place="new_summary_brand"
                    wish_type="list"
                ></Brand-Set-Type2>
            </section>
            
            <!-- ~님이 좋아하는 ~ 신상 도착 -->
            <section v-if="user_name && active_zzim_brand" class="item_module">
                <header class="head_type1">
                    <h2 class="ttl ta_r">
                        {{user_name}}님이 좋아하는<br>
                        <button @click="change_active_zzim_brand" type="button" class="btn_refresh">
                            <span class="txt_brand">{{zzim_brands[0].brand_name}}</span><i class="i_refresh1"></i>
                        </button><br>
                        신상 도착!
                    </h2>
                </header>
                <Product-Slider-Type2
                    ref="zzim_slider"
                    @change_wish_flag="change_wish_flag_product"
                    slider_id="zzim_brands"
                    :products="active_zzim_brand.items"
                    wish_place="new_summary_mybrand"
                    wish_type="zzim_brand"
                    :isApp="isApp"
                ></Product-Slider-Type2>
                <div class="sect_foot">
                    <a @click="move_brand_page(active_zzim_brand.brand_id)" class="btn_more type2">이 브랜드 상품 전체보기</a>
                </div>
            </section>
            
            <!-- 따끈따끈한 신상품이에요 -->
            <section v-if="new_products.length > 0" class="item_module">
                <header class="head_type1">
                    <h2 class="ttl">따끈따끈<br>방금 나왔어요</h2>
                </header>
                <Product-List-Basic
                    @change_wish_flag="change_wish_flag_product"
                    @click_new_more_button="pop_new_products"
                    :isApp="isApp"
                    :products="new_products"
                    wish_place="new_summary_new"
                    wish_type="list"
                ></Product-List-Basic>
                <div class="sect_foot">
                    <a @click="go_new_detail" class="btn_more type2">신상품 전체보기</a>
                </div>
            </section>
            
            <Modal
                :type=2
                :content="content"
                :isApp="isApp"
                :parameter="new_more_brand"
                @close_pop="close_pop_new_products"
                @wish_product="wish_more_product"
            ></Modal>

            <!-- 탑 버튼 -->
            <Button-Top/>
            
        </div>
    `,
    created() {
        this.$store.dispatch('GET_ROLLING_PRODUCTS');
        this.$store.dispatch('GET_NEW_BRANDS');
        this.$store.dispatch('GET_ZZIM_BRANDS');
        this.$store.dispatch('GET_NEW_PRODUCTS');

        fnAmplitudeEventObjectAction('view_new_summary', {}); // Amplitude 조회 이벤트 전송
    },
    data() { return {
        isApp : isApp,
        user_name : user_name, // 로그인한 유저 이름
        content : 'NEW-PRODUCT-MORE' // component name
    }},
    computed: {
        rolling_products() { // 지금, 주목할만한 신상
            return this.$store.getters.rolling_products;
        },
        new_brands() { // 새롭게 선보이는 브랜드
            return this.$store.getters.new_brands;
        },
        zzim_brands() { // 활성화 ~님이 좋아하는 ~ 신상 도착 브랜드 리스트
            return this.$store.getters.zzim_brands;
        },
        active_zzim_brand() { // 활성화 ~님이 좋아하는 ~ 신상 도착
            return this.$store.getters.active_zzim_brand;
        },
        zzim_brand_url() { // ~님이 좋아하는 ~ 신상 도착 브랜드 상품 전체보기 url
            return (this.isApp ? '/apps/appCom/wish/web2014' : '')
                + '/street/street_brand.asp?makerid=' + this.active_zzim_brand.brand_id;
        },
        new_products() { // 따끈따끈한 신상품이에요
            return this.$store.getters.new_products;
        },
        new_more_brand() { // 신상품 더보기 팝업 브랜드
            return this.$store.getters.new_more_brand;
        }
    },
    methods: {
        change_active_zzim_brand(e) { // ~님이 좋아하는 ~신상 도착 활성화 브랜드 변경
            this.$store.commit('UPDATE_ACTIVE_ZZIM_BRAND_INDEX');
            this.animation_zzim_brand(e.target.tagName === 'BUTTON' ? e.target : e.target.parentElement);
            this.$refs.zzim_slider.move_first();
        },
        animation_zzim_brand(button) { // 찜브랜드 브랜드명 클릭시 애니메이션
            const _this = this;
            function controlWidth() {
                var textEl = document.querySelector('.btn_refresh .txt_brand');
                var actualWidth = textEl.scrollWidth + "px";
                textEl.style.width = actualWidth;
            }

            var btn = $(button);
            var txt = btn.children('.txt_brand');
            var slider = btn.closest('.head_type1').next('.prd_slider_type2');
            var ani = new TimelineMax();

            // 텍스트 삭제
            btn.addClass('on');
            txt.empty();
            txt.width(0);
            ani.to(slider,0.2,{x:30, opacity:0});

            // 텍스트 추가
            setTimeout(function() {
                btn.removeClass('on');
                txt.text(_this.active_zzim_brand.brand_name);
                controlWidth();
                ani.to(slider,0.5,{x:0, opacity:1});
            }, 300);
        },
        pop_new_products(brand_id) { // 신상품 더보기 팝업
            this.$store.dispatch('GET_NEW_MORE_BRAND', brand_id);
            this.open_pop('modal');
        },
        close_pop_new_products() {
            this.$store.commit('CLEAR_NEW_MORE_BRAND');
        },
        wish_more_product(wish_info) {
            console.log('wish_more_product', wish_info);
            this.$store.commit('UPDATE_PRODUCT_WISH', wish_info);
        },
        go_new_detail() { // 신상품 전체보기 이동
            const uri = '/list/new/new_detail2020.asp';
            this.isApp ? this.app_more('NEW', uri) : function () {
                location.href = uri;
            }();
        }
    }
});