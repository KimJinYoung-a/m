const app = new Vue({
    el: '#app',
    store: store,
    mixins : [common_mixin, item_mixin, modal_mixin],
    template : `
        <div id="content" class="content category_detail">
            <!-- 카테고리 슬라이더 -->
            <BIZ-CATEGORY-SLIDER @goCategory="move_category" :categories="categories" />
            
            <!-- 구분선 -->
            <hr class="hr_div"/>
            
            <!-- 카테고리 2Depth -->
            <BIZ-CATEGORY-SLIDER2 v-if="categories2" @click_category="move_category" :categories="categories2"/>
            
            <!-- 정렬바 -->
            <Sortbar
                ref="sortbar"
                :sort="parameter.sort_method"
                :kkomkkom_flag="true"
                :do_search_flag="isFilterSearched"
                @pop_sort_option="pop_sort_option"
                @pop_kkomkkom="pop_modal_filter"
                @kkomkkom_reset="kkomkkom_reset"
            ></Sortbar>
            
            <!-- 검색결과 존재 -->
            <template v-if="loadingComplete && products.length > 0">
            
                <!-- 뷰 타입 탭 -->
                <Tab-View-Type @change_view_type="change_view_type" :view_type="parameter.view_type"/>
                
                <!-- 상품 리스트(자세히) -->
                <div class="prd_list type_basic" v-if="parameter.view_type == 'detail'">
                    <Product-Item-Basic
                        v-for="(product, index) in products"
                        :key="product.item_id"
                        :index="index + 1"
                        @go_item_detail="go_item_detail"
                        :isApp="false"
                        :product="product"
                        :isBiz="true"
                    ></Product-Item-Basic>
                </div>
                
                <!-- 상품 리스트(사진만) -->
                <Product-List-Photo2
                    v-if="parameter.view_type == 'photo'"
                    @go_item_detail="go_item_detail"
                    :products="products" :isBiz="true"/>
                
                <!-- 페이지 -->
                <Pagination 
                    @move_page="move_page" :current_page="parameter.page" 
                    :last_page="lastPage"/>
                
            </template>
            
            <!-- 검색결과 없음 -->
            <template v-else-if="loadingComplete && products.length == 0">
                <!-- 검색 결과 없음 -->
                <No-Data @click_return_button="click_return_button"></No-Data>
            </template>
            
            <!-- 정렬 옵션 모달 -->
            <Modal-Sorting
                @change_sort_option="change_sort_option"
                :sort_option="parameter.sort_method"
                :category_code="parameter.disp"
                :view_type="parameter.view_type"
                search_type="product"
            ></Modal-Sorting>
            
            <!-- 꼼꼼하게 찾기 모달 -->
            <Modal-Filter
                ref="modal_filter"
                @do_kkomkkom_search="do_kkomkkom_search"
                @modal_paging="get_more_kkomkkom_brands"
                @change_makerIds="change_kkomkkom_makerIds"
                @close_kkomkkom="clear_kkomkkom_all"
                @clear_all="clear_kkomkkom_all"
                :parameter="filterParameter"
                :is_category_search="true"
                :is_biz="true"
            ></Modal-Filter>
            
        </div>
    `,
    created() {
        // SET 초기 파라미터
        this.$store.commit('SET_PARAMETER', parameter);

        // GET 카테고리 리스트
        this.$store.dispatch('GET_CATEGORIES', parameter.disp);

        // GET 상품 리스트
        this.$store.dispatch('GET_PRODUCTS');

        // GET 필터 조건
        this.$store.dispatch('GET_FILTER_CRITERIA');
    },
    mounted() {
        this.$refs.sortbar.set_sortbar_float();

        fnAmplitudeEventMultiPropertiesAction('view_biz_category','category_code',parameter.disp);
    },
    computed : {
        categoryCode() { return Number(this.parameter.disp); },
        parameter() { return this.$store.getters.parameter; },
        categories() { return this.$store.getters.categories; },
        categories2() { return this.$store.getters.categories2; },
        productCount() { return this.$store.getters.productCount; },
        products() { return this.$store.getters.products; },
        lastPage() { return this.$store.getters.lastPage; },
        loadingComplete() { return this.$store.getters.loadingComplete; },

        isFilterSearched() { // 꼼꼼하게 찾기 했는지 여부
            return this.parameter.deliType.length > 0 // 배송/기타
                || this.parameter.makerIds.length > 0 // 브랜드
                || this.parameter.minPrice !== '' // 최저가
                || this.parameter.maxPrice !== '' // 최고가
                ;
        },
        filterParameter() { // 꼼꼼하게 찾기 모달 파라미터
            return {
                disp_category : this.parameter.disp,
                searched_deliType : this.parameter.deliType,
                searched_brands : this.parameter.makerIds,
                searched_min_price : this.parameter.minPrice,
                searched_max_price : this.parameter.maxPrice,
                view_type : this.parameter.view_type,
                sort_method : this.parameter.sort_method,
                result_count : this.productCount,
                result_price : this.$store.getters.filterPrice,
                brands : this.$store.getters.filterBrands,
                brand_page : this.$store.getters.pageFilterBrand,
            };
        },
    },
    methods : {
        pop_modal_filter() { // 꼼꼼하게찾기 팝업
            this.$refs.modal_filter.refresh();
            this.open_pop('modal_filter');
        },
        move_category(category_code, has_row_list) { // 카테고리 이동(현재 뷰타입, 정렬옵션만 유지하면서 페이지 이동)
            location.href = '?disp=' + category_code + '&viewType=' + this.parameter.view_type
                + '&sortMethod=' + this.parameter.sort_method;
        },
        change_sort_option(option) { // 정렬 옵션 변경
            this.close_pop('modal_sorting');
            this.go_page(null, option, 1);
        },
        do_kkomkkom_search(parameters) { // 꼼꼼하게 찾기 실행
            this.go_page(null, null, 1, parameters);
        },
        change_view_type(type) { // 뷰 타입 변경
            this.go_page(type);
        },
        move_page(page) { // 페이지 이동
            this.go_page(null, null, page);
        },
        kkomkkom_reset() { // 꼼꼼하게찾기 초기화
            this.go_page(null, null, 1, {
                deliType: [], makerIds: [], minPrice: '', maxPrice: ''
            });
        },
        click_return_button() { // 결과없음 뒤로가기
            history.back();
        },
        get_more_kkomkkom_brands(parameter) { // 꼼꼼하게 찾기 브랜드 더 불러오기
            this.$store.dispatch('GET_MORE_FILTER_BRANDS', parameter.brand_name_keyword);
        },
        change_kkomkkom_makerIds(parameter) { // 꼼꼼하게 찾기 브랜드 추가/삭제 시
            this.$store.commit('UPDATE_FILTER_MAKERIDS', parameter);
        },
        clear_kkomkkom_all() { // 꼼꼼하게 찾기 초기화
            this.$store.commit('CLEAR_FILTER_MAKERIDS'); // 꼼꼼하게 찾기 추가한 브랜드 초기화
        },

        go_page(view_type, sort_method, page, parameters) {
            const currentParameters = this.parameter;
            if( parameters == null )
                parameters = {};

            location.href = `?disp=${currentParameters.disp}`
                + `&viewType=${view_type != null ? view_type : currentParameters.view_type}`
                + `&sortMethod=${sort_method != null ? sort_method : currentParameters.sort_method}`
                + `&page=${page != null ? page : currentParameters.page}`
                + `&deliType=${(parameters.deliType != null ? parameters.deliType : currentParameters.deliType).join(', ')}`
                + `&makerIds=${(parameters.makerIds != null ? parameters.makerIds : currentParameters.makerIds).join(', ')}`
                + `&minPrice=${parameters.min_price != null ? parameters.min_price : currentParameters.minPrice}`
                + `&maxPrice=${parameters.max_price != null ? parameters.max_price : currentParameters.maxPrice}`
        },
        go_item_detail(index, product) {
            // Amplitude 전송
            fnAmplitudeEventObjectAction('click_category_productlist_item', {
                'item_index' : index,
                'list_style' : this.parameter.view_type === 'detail' ? 'list' : 'photo',
                'sort' : amplitudeSort(this.parameter.sort_method),
                'category_code' : this.categoryCode,
                'itemid' : product.item_id,
                'category_name' : product.category_name,
                'brand_name' : product.brand_name_en,
                'page_number' : this.parameter.page
            });
        }
    }
});