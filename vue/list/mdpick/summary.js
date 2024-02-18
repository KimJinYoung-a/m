// MDPICK 서머리 페이지
var app = new Vue({
    el: '#app',
    store: store,
    mixins : [item_mixin, search_mixin, common_mixin],
    template: `
        <div id="content" class="content mdpick_main">
            <!-- MD가 고르고 골랐어요 -->
            <section v-if="md_rolling_products.length > 0" class="item_module">
                <header class="head_type1">
                    <h2 class="ttl">이 상품으로<br>말할 것 같으면</h2>
                </header>
                <Product-Slider-Type3
                    @change_wish_flag="change_wish_flag_product"
                    slider_id="md_rolling"
                    :products="md_rolling_products"
                    wish_place="mdpick_summary_top"
                    wish_type="rolling"
                    :isApp="isApp"
                ></Product-Slider-Type3>
            </section>
            
            <!-- MD가 추천하는 키워드 -->
            <section v-if="md_keywords && md_keywords.length > 0" class="item_module">
                <header class="head_type1">
                    <h2 class="ttl">고르고<br>골랐어요</h2>
                </header>
                <Tab-Type1 @click_tab="change_md_keywords" :tabs="md_keywords"></Tab-Type1>
                <Product-List-Grid1
                    @change_wish_flag="change_wish_flag_product"
                    v-if="md_keyword_products.length > 0"
                    :isApp="isApp"
                    :products="md_keyword_products"
                    wish_place="mdpick_summary_keyword"
                    wish_type="keyword"
                ></Product-List-Grid1>
                <div class="sect_foot">
                    <a @click="move_search_page(md_keyword, 'product')" class="btn_more type2">{{md_keyword}} 상품 더보기</a>
                </div>
            </section>
            
            <!-- 이 브랜드 어때요? -->
            <section v-if="md_brand.brand_id" class="item_module">
                <header class="head_type1">
                    <h2 class="ttl">우리만 알기<br>아까운 브랜드</h2>
                </header>
                <Brand-Set-Type1
		            @wish_brand="wish_brand"
                    @change_wish_flag="change_wish_flag_product"
                    :isApp="isApp"
                    :brand_id="md_brand.brand_id"
                    :main_image="md_brand.main_image"
                    :brand_name_kr="md_brand.brand_name_kr"
                    :brand_name_en="md_brand.brand_name_en"
                    :sub_copy="md_brand.sub_copy"
                    :brand_wish_yn="md_brand.brand_wish_yn"
                    :products="md_brand.products"
                    wish_place="mdpick_summary_brand"
                    wish_type="brand"
                ></Brand-Set-Type1>
            </section>
            
            <!-- 카피쓰다 구매할뻔했어요 -->
            <section v-if="categories.length > 0" class="item_module">
                <header class="head_type1">
                    <h2 class="ttl">텐텐 MD들은<br>뭘 살까?</h2>
                </header>
                <Category-Nav-Type2
                    slider_id="md_item_categories"
                    @click_category="change_category"
                    :active_code="0"
                    :categories="categories"
                ></Category-Nav-Type2>
                <Product-List-Basic
                    @change_wish_flag="change_wish_flag_product"
                    :isApp="isApp"
                    :products="md_products"
                    wish_place="mdpick_summary_mdpick"
                    wish_type="list"
                ></Product-List-Basic>
                <div class="sect_foot">
                    <a @click="go_mdpick_detail" class="btn_more type2">MD PICK 상품 전체보기</a>
                </div>
            </section>

            <!-- 탑 버튼 -->
            <Button-Top/>
        </div>
    `,

    data() { return {
        isApp : isApp, // 앱 여부
    }},

    created() {
        this.$store.dispatch('GET_MD_ROLLING_PRODUCTS'); // GET MD가 고르고 골랐어요 상품 리스트
        this.$store.dispatch('GET_MD_KEYWORDS'); // GET MD가 추천하는 키워드 리스트
        this.$store.dispatch('GET_MD_BRAND'); // GET 이 브랜드 어때요?
        this.$store.dispatch('GET_CATEGORIES'); // GET 카테고리 리스트
        this.$store.dispatch('GET_MD_PRODUCTS', 0); // GET 카피쓰다 구매할뻔했어요 상품 리스트

        fnAmplitudeEventObjectAction('view_mdpick_summary', {}); // Amplitude 조회 이벤트 전송
    },

    computed : {
        md_rolling_products() { // MD가 고르고 골랐어요 상품 리스트
            return this.$store.getters.md_rolling_products;
        },
        md_keyword() { // MD가 추천하는 키워드 활성화된 키워드
            return this.$store.getters.md_keyword;
        },
        md_keywords() { // MD가 추천하는 키워드 리스트
            return this.$store.getters.md_keywords;
        },
        md_keyword_products() { // MD가 추천하는 키워드 상품 리스트
            return this.$store.getters.md_keyword_products;
        },
        md_brand() { // 이 브랜드 어때요?
            return this.$store.getters.md_brand;
        },
        categories() { // 카테고리 리스트
            return this.$store.getters.categories;
        },
        md_products() { // 카피쓰다 구매할뻔했어요 상품 리스트
            return this.$store.getters.md_products;
        }
    },

    methods : {
        change_md_keywords(keyword) { // MD가 추천하는 키워드 - 키워드 변경
            this.$store.commit('SET_MD_KEYWORD', keyword); // SET MD가 추천하는 키워드 활성화된 키워드
            this.$store.dispatch('GET_MD_KEYWORD_PRODUCTS', keyword); // GET MD가 추천하는 키워드 상품 리스트
        },
        change_category(category_code, category_name) { // 카피쓰다 구매할뻔했어요 - 카테고리 변경
            this.$store.dispatch('GET_MD_PRODUCTS', category_code);
        },
        go_md_keyword_search() { // MD가 추천하는 키워드 활성화된 키워드로 검색 실행
            const encodeKeyword = encodeURIComponent(this.md_keyword);
            location.href = '/search/search_result2020.asp?keyword=' + encodeKeyword;
        },
        wish_brand(id, on_flag) { // 브랜드 위시
            console.log('wish_brand', id, on_flag);
            this.$store.commit('UPDATE_BRAND_WISH', on_flag);
        },
        go_mdpick_detail() { // MDPICK 전체보기 이동
            const uri = '/list/mdpick/mdpick_detail2020.asp';
            this.isApp ? this.app_more('MDPICK', uri) : function () {
                location.href = uri;
            }();
        }
    }
});