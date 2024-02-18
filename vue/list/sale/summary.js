var app = new Vue({
    el: '#app',
    store: store,
    mixins : [item_mixin, common_mixin],
    template: `
        <!-- SALE 서머리 -->
        <div id="content" class="content sale_main">
            
            <!-- 다음은 없을지도 모르는 할인 -->
            <section v-if="rolling_products.length > 0" class="item_module">
                <header class="head_type1">
                    <h2 class="ttl">할인할 때 사면<br>죄책감 없으니까</h2>
                </header>
                <Product-Slider-Type3
                    @change_wish_flag="change_wish_flag_product"
                    slider_id="sale_rolling"
                    :products="rolling_products"
                    wish_place="sale_summary_top"
                    wish_type="rolling"
                    :isApp="isApp"
                ></Product-Slider-Type3>
            </section>
            
            <!-- ~님! 목이 빠지게 기다리셨죠? -->
            <section v-if="user_name && my_sale_products.length > 0" class="item_module">
                <i class="bg_sale"></i>
                <header class="head_type1">
                    <h2 class="ttl ta_r">{{user_name}}님!<br>마음에만<br>담아두지 말아요</h2>
                </header>
                <div class="ani"><p class="bbl_ten bbl_b ani_bnc">{{my_sale_bubble_text}}</p></div>
                <Product-Slider-Type1
                    @change_wish_flag="change_wish_flag_product"
                    @trans_end_slider="change_my_sale_product"
                    slider_id="my_sale_slider"
                    :products="my_sale_products"
                    wish_place="sale_summary_mywish"
                    wish_type="my_favorite"
                    :isApp="isApp"
                ></Product-Slider-Type1>
            </section>
            
            <!-- 간절히 바랐던 모두의 위시 할인 -->
            <section v-if="wish_products.length > 0" class="item_module">
                <header class="head_type1">
                    <h2 class="ttl">망설이지 마요<br>모두가 탐내는 중</h2>
                </header>
                <Product-List-Grid1
                    @change_wish_flag="change_wish_flag_product"
                    :isApp="isApp"
                    :products="wish_products"
                    wish_place="sale_summary_wish"
                    wish_type="wish"
                ></Product-List-Grid1>
            </section>
            
            <!-- 지금 인기있는 세일상품이에요 -->
            <section v-if="list_products.length > 0" class="item_module">
                <header class="head_type1">
                    <h2 class="ttl">핫한데<br>할인까지 한다구요!</h2>
                </header>
                <Category-Nav-Type2
                    @click_category="change_list_category"
                    slider_id="list_categories"
                    :active_code=0
                    :categories="categories"
                ></Category-Nav-Type2>
                <Product-List-Basic
                    @change_wish_flag="change_wish_flag_product"
                    :isApp="isApp"
                    :products="list_products"
                    wish_place="sale_summary_sale"
                    wish_type="list"
                ></Product-List-Basic>
                <div class="sect_foot">
                    <a @click="go_sale_detail" class="btn_more type2">세일 상품 전체보기</a>
                </div>
            </section>
            
            <a @click="go_clearance" class="btn_clearance">
                <span class="txt">더 특별한 보물을<br>찾아보지 않을래요?</span>
                <small class="txt2">클리어런스 바로가기</small>
            </a>

            <!-- 탑 버튼 -->
            <Button-Top/>
        </div>
    `,
    created() {
        this.$store.dispatch('GET_ROLLING_PRODUCTS'); // GET 다음은 없을지도 모르는 할인 상품 리스트
        this.$store.dispatch('GET_WISH_PRODUCTS'); // GET 간절히 바랐던 모두의 위시 할인 상품 리스트
        this.$store.dispatch('GET_CATEGORIES'); // GET 카테고리 리스트
        this.$store.dispatch('GET_LIST_PRODUCTS', 0); // GET 지금 인기있는 세일상품 리스트
        if( this.user_name ) {
            this.$store.dispatch('GET_MY_SALE_PRODUCTS'); // GET ~님! 목이 빠지게 기다리셨죠? 상품 리스트
        }

        fnAmplitudeEventObjectAction('view_sale_summary', {}); // Amplitude 조회 이벤트 전송
    },
    data() { return {
        isApp : isApp,
        user_name : user_name, // 로그인한 유저 이름
        my_fav_product_type : 'F', // ~님! 목이 빠지게 기다리셨죠? 활성화된 상품 구분(F:위시/B:장바구니)
    }},
    computed : {
        rolling_products() { // 다음은 없을지도 모르는 할인 상품 리스트
            return this.$store.getters.rolling_products;
        },
        my_sale_products() { // ~님! 목이 빠지게 기다리셨죠? 상품 리스트
            return this.$store.getters.my_sale_products;
        },
        my_sale_bubble_text() { // ~님! 목이 빠지게 기다리셨죠? 말풍선 텍스트
            const type_text = this.my_fav_product_type === 'F' ? '위시' : '장바구니';
            return type_text + '에 담긴 상품이 할인 중';
        },
        wish_products() { // 간절히 바랐던 모두의 위시 할인 상품 리스트
            return this.$store.getters.wish_products;
        },
        categories() { // 카테고리 리스트
            return this.$store.getters.categories;
        },
        list_products() { // 지금 인기있는 세일상품 리스트
            return this.$store.getters.list_products;
        }
    },
    methods : {
        change_my_sale_product(product) { // ~님! 목이 빠지게 기다리셨죠? 슬라이드시 활성화된 상품으로 말풍선 텍스트 변경
            this.my_fav_product_type = product.f_flag;
        },
        change_list_category(catecode, catename) { // 지금 인기있는 세일상품 리스트 카테고리 변경
            this.$store.dispatch('GET_LIST_PRODUCTS', catecode); // GET 지금 인기있는 세일상품 리스트
        },
        go_sale_detail() { // 세일상품 전체보기
            const uri = '/list/sale/sale_detail2020.asp';
            this.isApp ? this.app_more('SALE', uri) : function () {
                location.href = uri;
            }();
        },
        go_clearance() { // 클리어런스 서머리 이동
            const uri = '/list/clearance/clearance_summary2020.asp';
            this.isApp ? this.app_more('CLEARANCE', uri) : function () {
                location.href = uri;
            }();
        }
    }
});