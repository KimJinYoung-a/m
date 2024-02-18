var app = new Vue({
    el: '#app',
    store: store,
    template: `<div id="content" class="content best_review">
                    <header class="head_type1">
                        <h2 class="ttl">다들 뭐 사는지<br>궁금하다면</h2>
                    </header>
                    <Category-Nav-Type2
                        ref="ctgrnav2"
                        @click_category="click_category"
                        :active_code="active_code"
                        :categories="categories"
                    ></Category-Nav-Type2>
                    <template v-if="first_loading_complete && best_reviews.length > 0">
                        <div class="rv_list_type1">
                            <Review-List-Type1
                                @pop_view_this_item_reviews="pop_view_this_item_reviews"
                                :isApp="isApp"
                                :reviews="best_reviews"
                            ></Review-List-Type1>
                        </div>
                    </template>
                    <template v-else-if="first_loading_complete">
                        <No-Data
                            :backUrlButtonDisplayFlag="false"
                        ></No-Data>
                    </template>
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
                        wish_place="best_review_more"
                        wish_type="best_review_more"
                    ></Review-List-This-Item>

                    <!-- 탑 버튼 -->
                    <Button-Top/>
               </div>
            `,
    mixins : [item_mixin , common_mixin, modal_mixin],
    data() {return {
        isApp : isApp
    }},
    created() {
        this.$store.commit('SET_DETAIL_TYPE', 'review'); // SET 상세 구분값

        // 카테고리 리스트 불러오기
        this.$store.commit('SET_URI', '/category/topDispCateList');
        this.$store.dispatch('GET_CATEGORIES');

        // 상품 목록 불러오기
        this.$store.commit('SET_URI', '/best/reviews/more');
        this.$store.dispatch('GET_BEST_REVIEWS');
    },
    mounted() {
        this.scroll(this.loading_page); // 스크롤 시 페이지 로딩
        this.$refs.ctgrnav2.set_ctgrnav2_float(); // 카테고리 필터 슬라이더 플로팅
    },
    computed : {
        active_code() { // 활성화할 카테고리 코드
            return 0;
        },
        categories() { // 카테고리 리스트
            return this.$store.getters.categories;
        },
        best_reviews() { // 베스트 후기 리스트
            return this.$store.getters.best_reviews;
        },
        parameter() { // 파라미터
            return this.$store.getters.parameter;
        },
        // 상품 후기 영역
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
        // 상품 후기 영역
        first_loading_complete() { // 처음 loading 종료 여부
            return this.$store.getters.first_loading_complete;
        }
    },
    methods : {
        click_category(category_code, category_name) {
            console.log('click ' + category_code);

            category_code = category_code === 0 ? '' : category_code

            this.$store.commit('SET_PARAMETER', {cate_code : category_code}); // 파라미터 카테고리 코드 변경
            this.$store.commit('SET_IS_LOADING_COMPLETE'); // 데이터 전체 로드 플레그
            this.$store.commit('SET_PAGE', 1); // 페이지 초기화
            this.$store.commit('CLEAR_BEST_REVIEWS'); // 데이터 초기화
            this.$store.dispatch('GET_BEST_REVIEWS');
        },
        loading_page() { // 페이징
            const next_page = this.$store.getters.next_page;

            this.$store.commit('SET_PAGE', next_page);
            this.$store.dispatch('GET_BEST_REVIEWS');
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
        }
    }
});