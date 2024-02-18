const app = new Vue({
    el: '#app',
    store: store,
    mixins : [common_mixin, item_mixin, modal_mixin],
    template : `
        <div id="content" class="content category_detail">
        
            <!-- 하위 카테고리 Nav -->
		    <Category-Nav-Type1
		        @pop_category_explorer="pop_category_explorer"
		        @click_category="move_category"
		        :this_category="this_category_info"
		        :categories="this_category_info.low_categories"
		        :first_category_view_count="6"
		    ></Category-Nav-Type1>
		    
		    <hr class="hr_div"/>
		    
		    <!-- 정렬바 -->
            <Sortbar
                ref="sortbar"
                :sort="parameter.sort_method"
                :kkomkkom_flag="true"
                :do_search_flag="is_kkomkkom_searched"
                @pop_sort_option="pop_sort_option"
                @pop_kkomkkom="pop_modal_filter"
                @kkomkkom_reset="kkomkkom_reset"
            ></Sortbar>
            
            <!-- 검색결과 존재 -->
            <template v-if="products.length > 0">
                <!-- 뷰 타입 탭 -->
                <Tab-View-Type
                    @change_view_type="change_view_type"
                    :view_type="parameter.view_type"
                ></Tab-View-Type>
                
                <!-- 상품 리스트(자세히) -->
                <div class="prd_list type_basic" v-if="first_loading_complete && parameter.view_type == 'detail'">
                    <Product-Item-Basic
                        v-for="(product, index) in products"
                        :key="product.item_id"
                        :index="index + 1"
                        @change_wish_flag="change_wish_flag_product"
                        @go_item_detail="go_item_detail"
                        :isApp="false"
                        :product="product"
                        wish_place="category_list"
                        wish_type="list"
                        :category="Number(this_category_info.category_code)"
                        :view_type="parameter.view_type"
                        :sort="parameter.sort_method"
                        :filter_recommend="filter_recommend"
                        :filter_brand="parameter.makerIds"
                        :filter_delivery="filter_delivery"
                        :filter_lowprice="parameter.minPrice"
                        :filter_highprice="parameter.maxPrice"
                        :page="parameter.page"
                    ></Product-Item-Basic>
                </div>
                
                <!-- 상품 리스트(사진만) -->
                <Product-List-Photo2
                    @change_wish_flag="change_wish_flag_product"
                    @go_item_detail="go_item_detail"
                    v-if="parameter.view_type == 'photo'"
                    :products="products"
                    wish_place="category_list"
                    wish_type="list"
                    :category="Number(this_category_info.category_code)"
                    :view_type="parameter.view_type"
                    :sort="parameter.sort_method"
                    :filter_recommend="filter_recommend"
                    :filter_brand="parameter.makerIds"
                    :filter_delivery="filter_delivery"
                    :filter_lowprice="parameter.minPrice"
                    :filter_highprice="parameter.maxPrice"
                    :page="parameter.page"
                ></Product-List-Photo2>
                
                <!-- 페이지 -->
                <Pagination
                    v-if="first_loading_complete"
                    @move_page="move_page"
                    :current_page="parameter.page"
                    :last_page="last_page"
                ></Pagination>
            </template>
            
            <!-- 검색결과 없음 -->
            <template v-else-if="first_loading_complete && products.length == 0">
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
                @close_kkomkkom="close_kkomkkom"
                @clear_all="clear_kkomkkom_all"
                :parameter="filter_parameter"
                :is_category_search="true"
            ></Modal-Filter>
            
            <!-- 카테고리 익스플로어 모달 -->
            <Modal :type="4" modal_id="category_explorer">
                <Category-Explorer slot="body" ref="category_explorer"
                    :explorer_categories="explorer_categories"
                    :selected_category_code="parameter.disp"
                    :view_type="parameter.view_type"
                    :sort_method="parameter.sort_method"
                ></Category-Explorer>
            </Modal>
		    
        </div>
    `,
    created() {
        // SET 초기 파라미터
        this.$store.commit('SET_PARAMETER', parameter);

        // GET 현재 카테고리 정보 (하위 카테고리 리스트도)
        this.$store.dispatch('GET_CATEGORY_INFO');

        // GET 상품 리스트
        this.$store.dispatch('GET_PRODUCTS');

        // GET 필터 조건
        this.$store.dispatch('GET_KKOMKKOM_CRITERIA');

        // GET 카테고리 익스플로어 리스트
        this.$store.dispatch('GET_EXPLORER_CATEGORIES');
    },
    mounted() {
        this.$refs.sortbar.set_sortbar_float();
    },
    computed : {
        parameter : function() { return this.$store.getters.parameter; }, // 파라미터
        this_category_info : function() { return this.$store.getters.this_category_info; }, // 현재 카테고리 정보
        product_count : function() { return this.$store.getters.product_count; }, // 총 상품 수
        products : function() { return this.$store.getters.products; }, // 상품 리스트
        last_page : function() { return this.$store.getters.last_page; }, // 마지막 페이지
        first_loading_complete : function() { return this.$store.getters.first_loading_complete; }, // 첫 로딩 끝났는지 여부
        explorer_categories : function() { return this.$store.getters.explorer_categories; }, // 카테고리 익스플로어 리스트
        is_kkomkkom_searched() { // 꼼꼼하게 찾기 했는지 여부
            return this.parameter.deliType.length > 0 // 배송/기타
                || this.parameter.makerIds.length > 0 // 브랜드
                || this.parameter.minPrice !== '' // 최저가
                || this.parameter.maxPrice !== '' // 최고가
            ;
        },
        filter_parameter() { // 꼼꼼하게 찾기 모달 파라미터
            return {
                disp_category : this.parameter.disp,
                searched_deliType : this.parameter.deliType,
                searched_brands : this.parameter.makerIds,
                searched_min_price : this.parameter.minPrice,
                searched_max_price : this.parameter.maxPrice,
                view_type : this.parameter.view_type,
                sort_method : this.parameter.sort_method,
                result_count : this.product_count,
                result_price : this.$store.getters.kkomkkom_price,
                brands : this.$store.getters.kkomkkom_brands,
                brand_page : this.$store.getters.page_kkomkkom_brand,
            };
        },
        filter_recommend() { // 필터 - 추천 for Wish Amplitude
            return amplitudeFilterRecommend(this.parameter.deliType);
        },
        filter_delivery() { // 필터 - 배송 for Wish Amplitude
            return amplitudeFilterDelivery(this.parameter.deliType);
        }
    },
    methods : {
        move_category(category_code, has_row_list) { // 카테고리 이동(현재 뷰타입, 정렬옵션만 유지하면서 페이지 이동)
            location.href = '/category/category_detail2020.asp'
                + '?disp=' + category_code + '&viewType=' + this.parameter.view_type
                + '&sortMethod=' + this.parameter.sort_method;
        },
        change_view_type(type) { // 뷰 타입 변경
            this.go_page(type);
        },
        pop_category_explorer() { // 카테고리 익스플로러 팝업
            this.$refs.category_explorer.refresh();
            this.open_pop('category_explorer');
        },
        pop_modal_filter() { // 꼼꼼하게찾기 팝업
            this.$refs.modal_filter.refresh();
            this.open_pop('modal_filter');
        },
        change_sort_option(option) { // 정렬 옵션 변경
            this.close_pop('modal_sorting');
            this.go_page(null, option, 1);
        },
        move_page(page) { // 페이지 이동
            this.go_page(null, null, page);
        },
        do_kkomkkom_search(parameters) { // 꼼꼼하게 찾기 실행
            this.go_page(null, null, 1, parameters);
        },
        kkomkkom_reset() { // 꼼꼼하게찾기 초기화
            this.go_page(null, null, 1, {
                deliType: [], makerIds: [], minPrice: '', maxPrice: ''
            });
        },
        go_page(view_type, sort_method, page, parameters) {
            const current_param = this.parameter;
            if( parameters == null )
                parameters = {};

            location.href = `?disp=${current_param.disp}&viewType=${view_type != null ? view_type : current_param.view_type}`
                + `&sortMethod=${sort_method != null ? sort_method : current_param.sort_method}`
                + `&page=${page != null ? page : current_param.page}`
                + `&deliType=${(parameters.deliType != null ? parameters.deliType : current_param.deliType).join(',')}`
                + `&makerIds=${(parameters.makerIds != null ? parameters.makerIds : current_param.makerIds).join(',')}`
                + `&minPrice=${parameters.min_price != null ? parameters.min_price : current_param.minPrice}`
                + `&maxPrice=${parameters.max_price != null ? parameters.max_price : current_param.maxPrice}`
        },
        get_more_kkomkkom_brands(parameter) { // 꼼꼼하게 찾기 브랜드 더 불러오기
            this.$store.dispatch('GET_MORE_KKOMKKOM_BRANDS', parameter.brand_name_keyword);
        },
        change_kkomkkom_makerIds(parameter) { // 꼼꼼하게 찾기 브랜드 추가/삭제 시
            this.$store.commit('UPDATE_KKOMKKOM_MAKERIDS', parameter);
        },
        close_kkomkkom() { // 꼼꼼하게 찾기 모달 닫음
            this.$store.commit('CLEAR_KKOMKKOM_MAKERIDS'); // 꼼꼼하게 찾기 추가한 브랜드 초기화
        },
        clear_kkomkkom_all() { // 꼼꼼하게 찾기 초기화
            this.$store.commit('CLEAR_KKOMKKOM_MAKERIDS'); // 꼼꼼하게 찾기 추가한 브랜드 초기화
        },
        scroll_to_sortbar() { // 스크롤 to 정렬바 상단
            $('html,body').animate({scrollTop: document.querySelector('.ctgr_nav_type1').offsetHeight}, 400);
        },
        click_return_button() { // 결과없음 뒤로가기
            history.back();
        },
        go_item_detail(index, product) {
            // Amplitude 전송
            fnAmplitudeEventObjectAction('click_category_productlist_item', {
                'item_index' : index,
                'list_style' : this.parameter.view_type === 'detail' ? 'list' : 'photo',
                'sort' : amplitudeSort(this.parameter.sort_method),
                'category_code' : this.this_category_info.category_code,
                'itemid' : product.item_id,
                'category_name' : product.category_name,
                'brand_name' : product.brand_name_en,
                'page_number' : this.parameter.page
            });
        }
    }
});