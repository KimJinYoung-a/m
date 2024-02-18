var app = new Vue({
    el: '#app',
    store: store,
    mixins : [item_mixin, modal_mixin, common_mixin],
    template: `
        <div id="content" class="content best_main">
        
            <!-- ~ 제일 잘 나가요 - 기간별 베스트 -->
            <section class="item_module">
                <header class="head_type1">
                    <h2 class="ttl">
                        <a @click="change_period('D')" :class="['tab', {active : period == 'D'}]">오늘</a>
                        <a @click="change_period('W')" :class="['tab', {active : period == 'W'}]">일주일간</a>
                        <a @click="change_period('M')" :class="['tab', {active : period == 'M'}]">한달간</a>
                        <br>제일 잘 나가요
                    </h2>
                </header>
                <Category-Nav-Type2
                    @click_category="change_period_category"
                    slider_id="period_category"
                    :active_code=0
                    :categories="categories"
                ></Category-Nav-Type2>
                <div v-if="period_products.length > 0" class="prd_list type_best">
                    <Product-Item-Type3
                        ref="best_first_product"
                        @change_wish_flag="change_wish_flag_product"
                        bubble_html="<span class='num'>1</span>위"
                        :isApp="isApp"
                        type="best"
                        :item_id="period_products[0].item_id"
                        :image_url="period_products[0].big_image"
                        shape_type="random"
                        :item_price="period_products[0].item_price"
                        :sale_percent="period_products[0].sale_percent"
                        :item_coupon_yn="period_products[0].item_coupon_yn"
                        :item_coupon_value="period_products[0].item_coupon_value"
                        :item_coupon_type="period_products[0].item_coupon_type"
                        :item_name="period_products[0].item_name"
                        :sell_flag="period_products[0].sell_flag"
                        :rental_yn="period_products[0].rental_yn"
                        :wish_yn="period_products[0].wish_yn"
                        :wish_place="period_wish_place"
                        wish_type="period"
                    ></Product-Item-Type3>
                    <template v-for="product in period_products">
                        <Product-Item-Type4
                            v-if="product.rank != 1"
                            @change_wish_flag="change_wish_flag_product"
                            :key="product.rank"
                            :isApp="isApp"
                            :item_id="product.item_id"
                            :image_url="product.big_image"
                            :item_price="product.item_price"
                            :sale_percent="product.sale_percent"
                            :item_coupon_yn="product.item_coupon_yn"
                            :item_coupon_value="product.item_coupon_value"
                            :item_coupon_type="product.item_coupon_type"
                            :item_name="product.item_name"
                            :sell_flag="product.sell_flag"
                            :rental_yn="product.rental_yn"
                            :wish_yn="product.wish_yn"
                            :rank="product.rank"
                            :wish_place="period_wish_place"
                            wish_type="period"
                        ></Product-Item-Type4>
                    </template>
                </div>
                <div class="sect_foot">
                    <a @click="period_more" class="btn_more type2">베스트셀러 상품 전체보기</a>
                </div>
            </section>
            
            <!-- 요즘 인기있는 키워드 - 인기검색어 상품 리스트 -->
            <section class="item_module" v-if="best_keywords.length > 0">
                <header class="head_type1">
                    <h2 class="ttl">지금 많이 찾는<br>키워드예요</h2>
                </header>
                <Tab-Type1
                    @click_tab="change_best_keyword"
                    :tabs="best_keywords"
                ></Tab-Type1>
                <Product-List-Grid1
                    @change_wish_flag="change_wish_flag_product"
                    :products="best_keyword_products"
                    :isApp="isApp"
                    wish_place="best_summary_keyword"
                    wish_type="keyword"
                ></Product-List-Grid1>
                <div class="sect_foot">
                    <a @click="move_search_page(active_best_keyword, 'product')" class="btn_more type2">{{active_best_keyword}} 상품 더보기</a>
                </div>
            </section>
            
            <!-- 꾸준히 사랑받고 있어요 - 스테디셀러 -->
            <section v-if="steady_products.length > 0" class="item_module">
                <header class="head_type1">
                    <h2 class="ttl">꾸준히<br>사랑받고 있어요</h2>
                </header>
                <div class="ani"><p v-show="steadyBuyCount != 0" class="bbl_blk bbl_b ani_bnc">{{number_format(steadyBuyCount)}}명이 구매했어요</p></div>
                <Product-Slider-Type1
                    @change_wish_flag="change_wish_flag_product"
                    @trans_end_slider="change_steady_slider"
                    :products="steady_products"
                    :isApp="isApp"
                    slider_id="steady_products"
                    wish_place="best_summary_steady"
                    wish_type="steady"
                ></Product-Slider-Type1>
                <div class="sect_foot">
                    <a @click="steady_more" class="btn_more type2">스테디셀러 상품 전체보기</a>
                </div>
            </section>
            
            <!-- 요즘 많이 찾는 브랜드 - 베스트 브랜드 -->
            <section v-if="best_brands.length > 0" class="item_module">
                <header class="head_type1">
                    <h2 class="ttl">요즘 인기있는<br>브랜드예요</h2>
                </header>
                <Category-Nav-Type2
                    @click_category="change_brand_category"
                    slider_id="brand_category"
                    :active_code=0
                    :categories="categories"
                ></Category-Nav-Type2>
                <Brand-Set-Type2
                    v-for="brand in best_brands"
                    :key="brand.brand_id"
                    v-if="brand.products"
                    @change_wish_flag="change_wish_flag_brand"
                    :isApp="isApp"
                    :brand_id="brand.brand_id"
                    :brand_name="brand.brand_name"
                    :brand_name_en="brand.brand_name_en"
                    :wish_yn="brand.wish_yn"
                    :products="brand.products"
                    wish_place="best_summary_brand"
                    wish_type="best_summary_brand"
                    :wish_cnt="brand.wish_cnt"
                ></Brand-Set-Type2>
            </section>
            
            <!-- 위시에 많이 담겼어요 - 베스트 위시 -->
            <section v-if="wish_products.length > 0" class="item_module">
                <header class="head_type1">
                    <h2 class="ttl">위시에<br>많이 담겼어요</h2>
                </header>
                <div class="ani"><p class="bbl_ten bbl_b ani_bnc">{{number_format(wishCount)}}명이 담았어요</p></div>
                <Product-Slider-Type1
                    @change_wish_flag="change_wish_flag_product"
                    @trans_end_slider="change_wish_slider"
                    :products="wish_products"
                    :isApp="isApp"
                    slider_id="wish_products"
                    wish_place="best_summary_wish"
                    wish_type="wish"
                ></Product-Slider-Type1>
                <div class="sect_foot">
                    <a @click="wish_more" class="btn_more type2">베스트위시 상품 전체보기</a>
                </div>
            </section>
            
            <section class="item_module">
                <header class="head_type1">
                    <h2 class="ttl">다들 뭐 사는지<br>궁금하다면</h2>
                </header>
                <Review-List-Type1
                    @pop_view_this_item_reviews="pop_view_this_item_reviews"
                    :isApp="isApp"
                    :reviews="best_reviews"
                ></Review-List-Type1>
                <div class="sect_foot">
                    <a @click="review_more" class="btn_more type2">베스트후기 전체보기</a>
                </div>
            </section>
            
            <!-- 이 상품 후기 더보기 리스트 -->
            <Review-List-This-Item
                @get_more_this_item_reviews="get_more_this_item_reviews"
                @change_view_type="change_this_item_view_type"
                @close_pop_view_this_item_reviews="close_pop_view_this_item_reviews"
                @change_wish_flag="change_wish_flag_review_product"
                :isApp="isApp"
                :product="product"
                :view_type="this_item_view_type"
                :reviews="this_item_reviews"
                :review_count="this_item_review_count"
                :is_loading="is_loading_this_item_page"
                :is_end_page="is_end_this_item_page"
                wish_place="best_summary_review_more"
                wish_type="best_summary_review_more"
            ></Review-List-This-Item>

            <!-- 탑 버튼 -->
            <Button-Top/>
            
        </div>
    `,

    data() {
        return {
            isApp : isApp, // app 여부
            steadyBuyCount : 0, // 스테디셀러 구매 수량
            wishCount : 0, // 베스트위시 위시 수
        }
    },

    created() {
        this.$store.dispatch('GET_CATEGORIES'); // GET 카테고리 리스트
        this.$store.dispatch('GET_PERIOD_PRODUCTS'); // GET 기간별 베스트 상품 리스트
        this.$store.dispatch('GET_BEST_KEYWORDS'); // GET 인기 검색어 리스트
        this.$store.dispatch('GET_STEADY_PRODUCTS'); // GET 스테디셀러 상품 리스트
        this.$store.dispatch('GET_BEST_BRANDS', 0); // GET 베스트 브랜드 리스트
        this.$store.dispatch('GET_WISH_PRODUCTS'); // GET 베스트 위시 리스트
        this.$store.dispatch('GET_BEST_REVIEWS'); // GET 베스트 위시 리스트

        fnAmplitudeEventObjectAction('view_best_summary', {});
    },

    computed : {
        period() { // 파라미터
            return this.$store.getters.period;
        },
        categories() { // 카테고리 리스트
            return this.$store.getters.categories;
        },

        /* 기간별 관련 */
        period_products() { // 기간별 베스트 상품 리스트
            return this.$store.getters.period_products;
        },
        period_category() { // 기간별 베스트 활성화된 카테고리 코드
            return this.$store.getters.period_category;
        },
        period_wish_place() { // 기간별 wish_place
            let period_place = 'best_summary_best_';
            switch (this.period) {
                case 'D' : period_place += 'today'; break;
                case 'W' : period_place += 'week'; break;
                case 'M' : period_place += 'month'; break;
            }
            return period_place;
        },
        /* //기간별 관련 */

        /* 요즘 인기있는 키워드 관련 */
        best_keywords() { // 인기 검색어 리스트
            return this.$store.getters.best_keywords;
        },
        best_keyword_products() { // 인기 검색어 상품 리스트
            return this.$store.getters.best_keyword_products;
        },
        active_best_keyword() { // 활성화된 인기 검색어
            return this.$store.getters.active_best_keyword;
        },
        best_keyword_more_url() { // 인기검색어 더보기
            return '/search/search_product2020.asp?keyword=' + this.active_best_keyword;
        },
        /* //요즘 인기있는 키워드 관련 */

        /* 꾸준히 사랑받고 있어요 관련 */
        steady_products() { // 스테디셀러 상품 리스트
            return this.$store.getters.steady_products;
        },
        /* //꾸준히 사랑받고 있어요 관련 */

        /* 요즘 많이 찾는 브랜드 관련 */
        brand_category() { // 베스트 브랜드 활성화된 카테고리 코드
            return this.$store.getters.brand_category;
        },
        best_brands() { // 베스트 브랜드 리스트
            return this.$store.getters.best_brands;
        },
        /* //요즘 많이 찾는 브랜드 관련 */

        /* 위시에 많이 담겼어요 관련 */
        wish_products() { // 베스트 위시 상품 리스트
            return this.$store.getters.wish_products;
        },
        /* //위시에 많이 담겼어요 관련 */

        /* 믿고 보는 텐텐이들의 후기 관련 */
        best_reviews() { // 베스트 후기 리스트
            return this.$store.getters.best_reviews;
        },
        product() { // 이 상품 후기 더보기 팝업 상품 정보
            return this.$store.getters.product;
        },
        this_item_view_type() { // 이 상품 후기 더보기 팝업 뷰 타입
            return this.$store.getters.this_item_view_type;
        },
        this_item_reviews() { // 이 상품 후기 더보기 팝업 후기 리스트
            return this.$store.getters.this_item_reviews;
        },
        this_item_review_count() { // 이 상품 후기 더보기 팝업 후기 갯수
            return this.$store.getters.this_item_review_count;
        },
        this_item_current_page() { // 이 상품 후기 더보기 팝업 현재 페이지
            return this.$store.getters.this_item_current_page;
        },
        is_loading_this_item_page() { // 이 상품 후기 더보기 팝업 페이지 로딩 여부
            return this.$store.getters.is_loading_this_item_page;
        },
        is_end_this_item_page() { // 이 상품 후기 더보기 팝업 페이지 종료 여부
            return this.$store.getters.is_end_this_item_page;
        },
        /* //믿고 보는 텐텐이들의 후기 관련 */
    },

    methods : {
        change_period(period) {
            this.animation_period_first_product_background();
            this.$refs.best_first_product.change_image_shpae();
            this.$store.commit('SET_PERIOD', period);
            this.$store.dispatch('GET_PERIOD_PRODUCTS');
        },
        change_period_category(catecode, catename) { // 기간별 카테고리 변경
            this.animation_period_first_product_background();
            this.$refs.best_first_product.change_image_shpae();
            this.$store.commit('SET_PERIOD_CATEGORY', catecode);
            this.$store.dispatch('GET_PERIOD_PRODUCTS');
        },
        change_best_keyword(keyword) { // 인기 검색어 변경
            this.$store.commit('SET_ACTIVE_BEST_KEYWORD', keyword);
            this.$store.dispatch('GET_BEST_KEYWORD_PRODUCTS', keyword);
        },
        change_steady_slider(product) { // 스테디셀러 슬라이드 - buycount변경
            this.steadyBuyCount = product.buy_count;
        },
        change_brand_category(catecode) { // 브랜드 카테고리 변경
            this.$store.commit('SET_BRAND_CATEGORY', catecode);
            this.$store.dispatch('GET_BEST_BRANDS', catecode);
        },
        change_wish_slider(product) { // 베스트위시 슬라이드 - wishcount 변경
            this.wishCount = product.wish_count;
        },
        pop_view_this_item_reviews(item_id) { // 이 상품 후기 더보기 팝업
            this.$store.dispatch('GET_PRODUCT_AND_REVIEWS', item_id);
            this.open_pop('modal');
        },
        close_pop_view_this_item_reviews() {
            this.$store.commit('CLEAR_THIS_ITEM_DATA'); // 기존 이 상품 더보기 정보 clear
            this.close_pop('modal');
        },
        get_more_this_item_reviews(item_id) { // 이 상품 후기 더보기 후기 리스트 더 불러오기
            if( item_id === 0 ) {
                return false;
            }
            this.$store.commit('SET_IS_LOADING_THIS_ITEM_PAGE', true);
            this.$store.commit('SET_THIS_ITEM_CURRENT_PAGE', this.this_item_current_page + 1); // 페이지 + 1
            this.$store.dispatch('GET_MORE_THIS_ITEM_REVIEWS', item_id);
        },
        change_this_item_view_type(type) { // 이 상품 후기 더보기 뷰 타입 변경
            this.$store.commit('SET_THIS_ITEM_VIEW_TYPE', type);
        },
        animation_period_first_product_background() { // 기간별 베스트 1위 상품 백그라운드 애니메이션
            $('.bg_best').addClass('ani');
            clearTimeout(timer);
            var timer = setTimeout(function() {
                $('.bg_best').removeClass('ani');
            },100);
            $('.prd_list.type_best').animate({opacity:0},0);
            $('.prd_list.type_best').animate({opacity:1},300);
        },
        period_more() { // 베스트셀러 상품 전체보기
            const uri =  '/list/best/best_detail2020.asp'
                + (this.period_category !== 0 ? '?disp=' + this.period_category : '');

            this.isApp ? this.app_more('베스트셀러', uri) : function () {
                location.href = uri;
            }();
        },
        steady_more() { // 스테디셀러 상품 전체보기
            const uri = '/list/best/steady_detail2020.asp';
            this.isApp ? this.app_more('스테디셀러', uri) : function () {
                location.href = uri;
            }();
        },
        wish_more() { // 베스트위시 상품 전체보기
            const uri = '/list/best/wish_detail2020.asp';
            this.isApp ? this.app_more('베스트위시', uri) : function () {
                location.href = uri;
            }();
        },
        review_more() { // 베스트후기 상품 전체보기
            const uri = '/list/best/review_detail2020.asp';
            this.isApp ? this.app_more('베스트후기', uri) : function () {
                location.href = uri;
            }();
        }
    }
});