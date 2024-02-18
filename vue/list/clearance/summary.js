var app = new Vue({
    el: '#app',
    store: store,
    mixins : [item_mixin, common_mixin],
    template: `
        <div id="content" class="content clearance_main">
        
            <!-- 특별한 가격의 보물을 찾아보세요 -->
            <section v-if="rolling_products.length > 0" class="item_module">
                <header class="head_type1">
                    <h2 class="ttl">특별한 가격의<br>보물을 찾아보세요</h2>
                </header>
                <Product-Slider-Type6
                    slider_id="clearance_rolling"
                    :products="rolling_products"
                    :isApp="isApp"
                ></Product-Slider-Type6>
            </section>
            
            <!-- 몇 개 안 남았어요! -->
            <section v-if="limit_stock_products.length > 0" class="item_module">
                <header class="head_type1">
                    <h2 class="ttl">몇 개<br>안 남았어요!</h2>
                </header>
                <div class="ani"><p class="bbl_ten bbl_b ani_bnc">{{limit_count}}개 남았어요</p></div>
                <Product-Slider-Type1
                    @change_wish_flag="change_wish_flag_product"
                    @trans_end_slider="change_just_sold_product"
                    slider_id="limit_stock_slider"
                    :products="limit_stock_products"
                    wish_place="clearance_summary_top"
                    wish_type="stock"
                    :isApp="isApp"
                ></Product-Slider-Type1>
            </section>
            
            <!-- 방금 판매되었어요 -->
            <section v-if="just_sold_products.length > 0" class="item_module">
                <header class="head_type1">
                    <h2 class="ttl">방금<br>판매되었어요!</h2>
                </header>
                <Product-List-Basic
                    @change_wish_flag="change_wish_flag_product"
                    :isApp="isApp"
                    :isJustSold="true"
                    :products="just_sold_products"
                    wish_place="clearance_summary_momentago"
                    wish_type="just_sold"
                ></Product-List-Basic>
            </section>
            
            <!-- 더 많은 보물이 기다리고있어요 -->
            <section class="item_module">
                <header class="head_type1">
                    <h2 class="ttl">더 많은 보물이<br>기다리고 있어요</h2>
                </header>
                <Category-Nav-Type2
                    @click_category="change_more_treasure_category"
                    slider_id="more_treasure_categories"
                    :active_code=0
                    :categories="categories"
                ></Category-Nav-Type2>
                <Product-List-Basic
                    @change_wish_flag="change_wish_flag_product"
                    :isApp="isApp"
                    :products="more_treasure_products"
                    wish_place="clearance_summary_clearance"
                    wish_type="more_treasure"
                ></Product-List-Basic>
                <div class="sect_foot">
                    <a @click="go_clearance_detail" class="btn_more type2">클리어런스 상품 전체보기</a>
                </div>
            </section>

            <!-- 탑 버튼 -->
            <Button-Top/>
        </div>
    `,
    created() {
        this.$store.dispatch('GET_CATEGORIES'); // GET 카테고리 리스트
        this.$store.dispatch('GET_ROLLING_PRODUCTS'); // GET 특별한 가격의 보물을 찾아보세요 상품 리스트
        this.$store.dispatch('GET_LIMIT_STOCK_PRODUCTS'); // GET 몇 개 안 남았어요! 상품 리스트
        this.$store.dispatch('GET_JUST_SOLD_PRODUCTS'); // GET 방금 판매되었어요 상품 리스트
        this.$store.dispatch('GET_MORE_TREASURE_PRODUCTS', 0); // GET 더 많은 보물이 기다리고있어요

        fnAmplitudeEventObjectAction('view_clearance_summary', {}); // Amplitude 조회 이벤트 전송
    },
    data() {return {
        limit_count : 0, // 몇 개 안남았어요 상품 남은 수
        isApp : isApp, // 앱 여부
    }},
    computed: {
        rolling_products() { // 특별한 가격의 보물을 찾아보세요 상품 리스트
            return this.$store.getters.rolling_products;
        },
        limit_stock_products() { // 몇 개 안 남았어요! 상품 리스트
            return this.$store.getters.limit_stock_products;
        },
        just_sold_products() { // 방금 판매되었어요 상품 리스트
            return this.$store.getters.just_sold_products;
        },
        categories() { // 카테고리 리스트
            return this.$store.getters.categories;
        },
        more_treasure_products() { // 더 많은 보물이 기다리고있어요 상품 리스트
            return this.$store.getters.more_treasure_products;
        }
    },
    methods: {
        change_just_sold_product(product) { // 몇 개 안남았어요 슬라이드시 말풍선 상품 남은 수 변경
            this.limit_count = product.limit_count;
        },
        change_more_treasure_category(catecode, catename) { // 더 많은 보물이 기다리고있어요 카테고리 변경
            this.$store.dispatch('GET_MORE_TREASURE_PRODUCTS', catecode);
        },
        go_clearance_detail() {
            const uri = '/list/clearance/clearance_detail2020.asp';
            this.isApp ? this.app_more('CLEARANCE', uri) : function () {
                location.href = uri;
            }();
        }
    }
});