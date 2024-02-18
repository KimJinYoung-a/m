var app = new Vue({
    el: '#app',
    store: store,
    template: `<div id="content" class="content clearance_detail">
                    <header class="head_type1">
                        <h2 class="ttl">더 많은 보물이<br>기다리고 있어요</h2>
                    </header>
                    <!-- 카테고리 -->
                    <Category-Nav-Type2
                        ref="ctgrnav2"
                        slider_id="category_slider"
                        @click_category="click_category"
                        :active_code="category_code"
                        :categories="categories"
                    ></Category-Nav-Type2>
                    <!-- 정렬바 -->
                    <Sortbar
                        @pop_kkomkkom="pop_kkomkkom"
                        @kkomkkom_reset="kkomkkom_reset"
                        :isApp="isApp"
                        :sort="sort_method"
                        :kkomkkom_flag="true"
                        :do_search_flag="min_price != '' || max_price != ''"
                        @change_wish_flag="change_wish_flag_product"
                        wish_type="list"
                    ></Sortbar>
                    <template v-if="first_loading_complete && products.length > 0">
                        <Product-List-Basic
                            @change_wish_flag="change_wish_flag_product"
                            :isApp="isApp"
                            :products="products"
                            wish_place="clearance_clearance"
                            wish_type="list"
                        ></Product-List-Basic>
                    </template>
                    <template v-else-if="first_loading_complete">
                        <No-Data
                            :backUrlButtonDisplayFlag="false"
                        ></No-Data>
                    </template>
                    <!-- 정렬 옵션 모달 -->
                    <Modal-Sorting
                        @change_sort_option="change_sort_method"
                        :sort_option="sort_method"
                        search_type="clearance"
                        :isApp="isApp"
                    ></Modal-Sorting>
                    <Clearance-Filter
                        ref="kkomkkom"
                        @clear_all="clear_kkomkkom"
                        @do_kkomkkom_search="do_kkomkkom_search"
                        :isApp="isApp"
                        :searched_category_code="category_code"
                        :searched_min_price="min_price"
                        :searched_max_price="max_price"
                        :product_min_price="product_min_price"
                        :product_max_price="product_max_price"
                        :result_count="product_count"
                    ></Clearance-Filter>

                    <!-- 탑 버튼 -->
                    <Button-Top/>
               </div>
            `,
    mixins : [item_mixin , common_mixin, modal_mixin, search_mixin],
    data() {return {
        active_category_name : '전체',
        isApp : isApp
    }},
    created() {
        this.$store.commit('SET_CATEGORY_CODE', disp);
        this.$store.dispatch('GET_CATEGORIES');
        this.$store.dispatch('GET_FIRST_PRODUCTS');
    },
    mounted() {
        this.clearance_scroll(this.loading_page); // 스크롤 시 페이지 로딩
        this.$refs.ctgrnav2.set_ctgrnav2_float(); // 카테고리 필터 슬라이더 플로팅

        fnAmplitudeEventObjectAction('view_clearance_clearance', {
            'category_code' : 0,
            'category_name' : '전체',
            'sort': amplitudeSort(this.sort_method),
            'filter_lowprice' : this.min_price,
            'filter_highprice' : this.max_price,
            'paging_index' : 1
        });
    },
    computed : {
        min_price() { // 검색 최저가
            return this.$store.getters.min_price;
        },
        max_price() { // 검색 최고가
            return this.$store.getters.max_price;
        },
        category_code() { // 카테고리 코드
            return this.$store.getters.category_code;
        },
        categories() { // 카테고리 리스트
            return this.$store.getters.categories;
        },
        products() { // 상품 리스트
            return this.$store.getters.products;
        },
        product_count() { // 상품 갯수
            return this.$store.getters.product_count;
        },
        product_min_price() { // 상품 리스트 중 최저 가격
            return this.$store.getters.product_min_price;
        },
        product_max_price() { // 상품 리스트 중 최고 가격
            return this.$store.getters.product_max_price;
        },
        sort_method() { // 정렬
            return this.$store.getters.sort_method;
        },
        first_loading_complete() { // 처음 loading 종료 여부
            return this.$store.getters.first_loading_complete;
        },
        is_loading() { // 로딩중 여부
            return this.$store.getters.is_loading;
        },
        is_loading_complete() { // 페이지 모두 로딩했는지 여부
            return this.$store.getters.is_loading_complete;
        },
        current_page() { // 현재 페이지
            return this.$store.getters.current_page;
        }
    },
    methods : {
        click_category(category_code, category_name) {
            this.$store.commit('SET_CATEGORY_CODE', category_code);
            this.$store.dispatch('GET_FIRST_PRODUCTS');
            this.active_category_name = category_name;

            fnAmplitudeEventObjectAction('view_clearance_clearance', {
                'category_code' : category_code,
                'category_name' : category_name,
                'sort': amplitudeSort(this.sort_method),
                'filter_lowprice' : this.min_price,
                'filter_highprice' : this.max_price,
                'paging_index' : 1
            });
        },
        loading_page() { // 페이징
            this.$store.dispatch('GET_NEXT_PRODUCTS');
        },
        clearance_scroll : function() {
            const _this = this;

            window.onscroll = function () {
                if ( !_this.is_loading && !_this.is_loading_complete
                    && $(window).scrollTop() >= ($(document).height() - $(window).height()) - 250) {
                    _this.$store.dispatch('GET_NEXT_PRODUCTS');

                    fnAmplitudeEventObjectAction('view_clearance_clearance', {
                        'category_code' : _this.category_code,
                        'category_name' : _this.active_category_name,
                        'sort': amplitudeSort(_this.sort_method),
                        'filter_lowprice' : _this.min_price,
                        'filter_highprice' : _this.max_price,
                        'paging_index' : _this.current_page
                    });
                }
            };
        },
        change_sort_method(sort_method) { // 정렬값 변경
            this.$store.commit('SET_SORT_METHOD', sort_method);
            this.$store.dispatch('GET_FIRST_PRODUCTS');
            this.close_pop('modal_sorting');

            fnAmplitudeEventObjectAction('view_clearance_clearance', {
                'category_code' : this.category_code,
                'category_name' : this.active_category_name,
                'sort': amplitudeSort(sort_method),
                'filter_lowprice' : this.min_price,
                'filter_highprice' : this.max_price,
                'paging_index' : 1
            });
        },
        pop_kkomkkom() { // 꼼꼼하게찾기 팝업
            this.$refs.kkomkkom.refresh();
            this.open_pop('clearance_filter');
        },
        do_kkomkkom_search(min_price, max_price) { // 꼼꼼하게 찾기 실행
            this.$store.commit('SET_MIN_PRICE', min_price);
            this.$store.commit('SET_MAX_PRICE', max_price);
            this.close_pop('clearance_filter');
            this.$store.dispatch('GET_FIRST_PRODUCTS');

            fnAmplitudeEventObjectAction('view_clearance_clearance', {
                'category_code' : this.category_code,
                'category_name' : this.active_category_name,
                'sort': amplitudeSort(this.sort_method),
                'filter_lowprice' : min_price,
                'filter_highprice' : max_price,
                'paging_index' : 1
            });
        },
        clear_kkomkkom() { // clear 꼼꼼하게 찾기
            this.$store.commit('SET_MIN_PRICE', '');
            this.$store.commit('SET_MAX_PRICE', '');
        },
        kkomkkom_reset() { // 초기화 하실래요? 클릭
            this.$store.commit('SET_MIN_PRICE', '');
            this.$store.commit('SET_MAX_PRICE', '');
            this.$store.dispatch('GET_FIRST_PRODUCTS');

            fnAmplitudeEventObjectAction('view_clearance_clearance', {
                'category_code' : this.category_code,
                'category_name' : this.active_category_name,
                'sort': amplitudeSort(this.sort_method),
                'filter_lowprice' : '',
                'filter_highprice' : '',
                'paging_index' : 1
            });
        }
    }
});