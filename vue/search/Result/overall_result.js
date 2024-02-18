
var app = new Vue({
    el: '#app',
    store: store,
    mixins : [item_mixin, search_mixin, modal_mixin, common_mixin],
    template: /*html*/`
        <div id="content" class="content search_main">
            <!-- 검색바 -->
            <Searchbar
                v-if="isSearched"
                :searched_keyword="parameter.keyword"
                :correct_keyword="correct_keyword"
                @click_search_within_this="search_within_this"
                @do_search="move_search_result"
            ></Searchbar>
            
            <!-- 오타교정 검색어 -->
            <Correct-Typos @moveIgnoreCorrect="move_ignore_correct" 
                :correct_keyword="correct_keyword" :pre_correct_keyword="pre_correct_keyword"/>
            
            <!-- 대체 검색어 -->
            <Alternative-Keyword
                :alternative_keyword="alternative_keyword"
            ></Alternative-Keyword>
            
            <!-- 연관 검색어 -->
            <Recommend-Keywords
                :recommend_keywords="recommend_keywords" :background_image="quicklink.background_image"
            ></Recommend-Keywords>
            
            <!-- 키워드 퀵링크 -->
            <Quicklink
                :background_image="quicklink.background_image"
                :move_url="quicklink.move_url"
                :main_copy="quicklink.main_copy"
                :text_color="quicklink.text_color"
                :recommend_keywords="recommend_keywords"
            ></Quicklink>
            
            <!-- 검색 결과 구분 -->
            <Search-Category
                :search_keyword="parameter.keyword"
                :groups_count="groups_count"
            ></Search-Category>
            
            <!-- 검색결과 존재 -->
            <template v-if="isSearched && groups_count.total > 0">               
                <hr class="hr_div">
                
                <!-- 상품 검색 결과 -->
                <section v-if="products.length > 0" class="item_module">
                    <Item-Module-Header
                        :top_text="number_format(groups_count.product) + '건의'"
                        :bottom_text="'상품을 찾았어요'"
                        :move_url="'./search_product2020.asp?keyword=' + parameter.keyword"
                    ></Item-Module-Header>
                    <div class="prd_list type_basic">
                        <Product-Item-Basic
                            v-for="(product, index) in products"
                            :key="product.item_id"
                            :index="index + 1"
                            @change_wish_flag="change_wish_flag_product"
                            @go_item_detail="go_item_detail"
                            :isApp="isApp"
                            :product="product"
                            wish_type="product_results"
                            wish_place="search_result_all"
                        ></Product-Item-Basic>
                    </div>
                    <Item-Module-Footer-Button
                        v-if="groups_count.product > 6"
                        text="상품 검색결과 더보기"
                        @click_item_module_footer_btn="go_group_search('product')"
                    ></Item-Module-Footer-Button>
                </section>
                
                <!-- 상품후기 검색 결과 -->
                <section v-if="reviews.length > 0" class="item_module">
                    <Item-Module-Header
                        :top_text="number_format(groups_count.review) + '건의'"
                        :bottom_text="'상품후기를 찾았어요'"
                        :move_url="'./search_review2020.asp?keyword=' + parameter.keyword"
                    ></Item-Module-Header>
                    <Review-List-Type1
                        @pop_view_this_item_reviews="pop_view_this_item_reviews"
                        @click_review="click_review"
                        :isApp="isApp"
                        :reviews="reviews"
                        :search_keyword="parameter.keyword"
                    ></Review-List-Type1>
                    <Item-Module-Footer-Button
                        v-if="groups_count.review > 2"
                        text="상품후기 검색결과 더보기"
                        @click_item_module_footer_btn="go_group_search('review')"
                    ></Item-Module-Footer-Button>
                </section>
                
                <!-- 기획전 검색 결과 -->
                <section v-if="exhibitions.length > 0" class="item_module">
                    <Item-Module-Header
                        :top_text="number_format(groups_count.exhibition) + '건의'"
                        :bottom_text="'기획전을 찾았어요'"
                        :move_url="'./search_exhibition2020.asp?keyword=' + parameter.keyword"
                    ></Item-Module-Header>
                    <Event-List-Md
                        @click_exhibition="click_exhibition"
                        :exhibitions="exhibitions"
                    ></Event-List-Md>
                    <Item-Module-Footer-Button
                        v-if="groups_count.exhibition > 2"
                        text="기획전 검색결과 더보기"
                        @click_item_module_footer_btn="go_group_search('exhibition')"
                    ></Item-Module-Footer-Button>
                </section>
                
                <!-- 이벤트 검색 결과 -->
                <section v-if="events.length > 0" class="item_module">
                    <Item-Module-Header
                        :top_text="number_format(groups_count.event) + '건의'"
                        :bottom_text="'이벤트를 찾았어요'"
                        :move_url="'./search_event2020.asp?keyword=' + parameter.keyword"
                    ></Item-Module-Header>
                    <Event-List-Marketing
                        @click_event="click_event"
                        :events="events"
                    ></Event-List-Marketing>
                    <Item-Module-Footer-Button
                        v-if="groups_count.event > 2"
                        text="이벤트 검색결과 더보기"
                        @click_item_module_footer_btn="go_group_search('event')"
                    ></Item-Module-Footer-Button>
                </section>
                
                <!-- 브랜드 검색 결과 -->
                <section v-if="brands.length > 0" class="item_module">
                    <Item-Module-Header
                        :top_text="number_format(groups_count.brand) + '건의'"
                        :bottom_text="'브랜드를 찾았어요'"
                        :move_url="'./search_brand2020.asp?keyword=' + parameter.keyword"
                    ></Item-Module-Header>
                    <Brand-List
                        @change_wish_flag="change_wish_flag_brand"
                        @click_brand="click_brand"
                        :brands="brands"
                        :search_keyword="parameter.keyword"
                        wish_place="search_result_all"
                        :isApp="isApp"
                    ></Brand-List>
                    <Item-Module-Footer-Button
                        v-if="groups_count.brand > 5"
                        text="브랜드 검색결과 더보기"
                        @click_item_module_footer_btn="go_group_search('brand')"
                    ></Item-Module-Footer-Button>
                </section>
            
            </template>
            
            <!-- 검색결과 없음 -->
            <template v-else-if="isSearched && groups_count.total == 0">
                <hr class="hr_div">
                <Search-Result-Nodata
                    @change_wish_flag="change_wish_flag_product"
                    @change_best_keyword="change_best_keyword"
                    :best_keywords="best_keywords"
                    :best_products="best_products"
                    :is_show_how_about_this="true"
                    wish_place="search_none_all_keyword"
                    wish_type="no_result_products"/>
            </template>
            
            <!-- 이 안에서 검색 -->
            <Add-Keyword
                @search_add_keyword="do_search_within_this"
                :result_count="groups_count.total"
                :search_keyword="parameter.keyword"
            ></Add-Keyword>
            
            <!-- 이 상품 더보기 모달 -->
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
                wish_place="search_result_review_more"
            ></Review-List-This-Item>

            <!-- 탑 버튼 -->
            <Button-Top/>
            
        </div>
    `,

    data(){return {
        isApp : isApp
    }},

    created() {
        this.$store.commit('SET_PARAMETER', parameter); // SET 파라미터
        this.$store.dispatch('READ_SEARCH_RESULTS'); // READ 검색결과

        this.send_search_amplitude(parameter.keyword, 'all', '', '', []
            , [], [], '', '', 1);
    },

    computed : {
        parameter() { // 파라미터
            return this.$store.getters.parameter;
        },
        alternative_keyword() { // 대체 키워드
            return this.$store.getters.alternative_keyword;
        },
        correct_keyword() { return this.$store.getters.correct_keyword; }, // 교정 후 검색어
        pre_correct_keyword() { return this.$store.getters.pre_correct_keyword; }, // 교정 전 검색어
        searched_keyword() { // 검색한 키워드
            return this.correct_keyword ? this.correct_keyword : this.parameter.keyword;
        },
        recommend_keywords() { // 연관검색어 키워드 리스트
            return this.$store.getters.recommend_keywords;
        },
        groups_count() { // 검색구분별 검색결과 수
            return this.$store.getters.groups_count;
        },
        quicklink() { // 키워드 퀵링크
            return this.$store.getters.quicklink;
        },
        products() { // 상품 리스트
            return this.$store.getters.products;
        },
        reviews() { // 상품후기 리스트
            return this.$store.getters.reviews;
        },
        exhibitions() { // 기획전 리스트
            return this.$store.getters.exhibitions;
        },
        events() { // 이벤트 리스트
            return this.$store.getters.events;
        },
        brands() { // 브랜드 리스트
            return this.$store.getters.brands;
        },
        isSearched() { // 검색 결과 불러왔는지 여부
            return this.$store.getters.isSearched;
        },
        best_keywords() { // 베스트 키워드 리스트
            return this.$store.getters.best_keywords;
        },
        best_products() { // 베스트 상품 리스트
            return this.$store.getters.best_products;
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
        }
    },

    methods : {
        move_search_result(keyword) { // 검색결과 페이지 이동
            if( keyword.trim() !== '' ) {
                location.href = '?keyword=' + keyword;
            }
        },
        change_best_keyword(keyword) { // 베스트 키워드 변경
            this.$store.dispatch('CHANGE_BEST_PRODUCTS', keyword);
        },
        do_search_within_this(keyword) { // 이 안에서 검색 실행
            location.href = '?keyword=' + keyword;
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
        // 상품 클릭 시 상세 이동 전 Amplitude 전송
        go_item_detail(index, product) {
            fnAmplitudeEventObjectAction('click_search_result_item', {
                'item_index' : index,
                'item_type' : 'product',
                'sort' : amplitudeSort('best'),
                'keyword' : this.parameter.keyword,
                'list_type' : 'all',
                'itemid' : product.item_id,
                'category_name' : product.category_name,
                'brand_name' : product.brand_name_en
            });
        },
        // 후기 클릭 시 Amplitude 전송
        click_review(index, review) {
            fnAmplitudeEventObjectAction('click_search_result_item', {
                'item_index' : index + 1,
                'item_type' : 'review',
                'sort' : amplitudeSort('rc'),
                'keyword' : this.parameter.keyword,
                'list_type' : 'all',
                'itemid' : review.item_id,
                'category_name' : review.category_name,
                'brand_name' : review.brand_name_en
            });
        },
        // 기획전 클릭 시 Amplitude 전송
        click_exhibition(index, exhibition) {
            fnAmplitudeEventObjectAction('click_search_result_item', {
                'item_index' : index + 1,
                'item_type' : 'planning',
                'sort' : amplitudeSort('best'),
                'keyword' : this.parameter.keyword,
                'list_type' : 'all'
            });
        },
        // 기획전 클릭 시 Amplitude 전송
        click_event(index, event) {
            fnAmplitudeEventObjectAction('click_search_result_item', {
                'item_index' : index + 1,
                'item_type' : 'event',
                'sort' : amplitudeSort('best'),
                'keyword' : this.parameter.keyword,
                'list_type' : 'all'
            });
        },
        // 브랜드 클릭 시 Amplitude 전송
        click_brand(index, brand) {
            fnAmplitudeEventObjectAction('click_search_result_item', {
                'item_index' : index + 1,
                'item_type' : 'brand',
                'sort' : amplitudeSort('best'),
                'keyword' : this.parameter.keyword,
                'list_type' : 'all'
            });
        }
    }
});