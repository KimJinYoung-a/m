const app = new Vue({
    el: '#app',
    store: store,
    mixins : [item_mixin, search_mixin, modal_mixin, common_mixin],
    template : /*html*/`
        <div id="content" class="content search_detail">
            <!-- 검색바 -->
            <Searchbar
                v-if="true"
                :searched_keyword="parameter.keyword"
                :is_show_within_this="false"
                @do_search="move_search_result"
            ></Searchbar>

            <!-- 정렬 바 -->
            <Sortbar
                :sort="parameter.sort_method"
                :kkomkkom_flag="true"
                :do_search_flag="isFilterSearched"
                :is_biz="true"
                @pop_sort_option="pop_sort_option"
                @pop_kkomkkom="popModalFilter"
                @kkomkkom_reset="resetFilter"
            ></Sortbar>

            <!-- 검색 후 검색결과가 있으면 -->
            <template v-if="loadingComplete && products.length > 0">

                <header class="head_type1 head_biz_type1">
                    <span class="txt">{{number_format(productCount)}}건의</span>
                    <h2 class="ttl">상품을 찾아냈어요!</h2>
                </header>

                <!-- 상품 검색 결과 - 자세히 -->
                <div class="prd_list type_basic" v-if="products.length > 0">
                    <Product-Item-Basic
                        v-for="(product, index) in products"
                        :index="index + 1"
                        @go_item_detail="sendClickProductAmplitude"
                        :isApp="isApp"
                        :isBiz="true"
                        :product="product"
                    ></Product-Item-Basic>
                </div>

                <!-- 페이지 -->
                <Pagination
                    @move_page="movePage"
                    :current_page="Number(parameter.page)"
                    :last_page="lastPage"
                ></Pagination>

            </template>

            <!-- 검색 후 검색결과가 없으면 -->
            <No-Data v-else-if="loadingComplete" @click_return_button="goBack" />

            <!-- 정렬 옵션 모달 -->
            <Modal-Sorting
                @change_sort_option="changeSortMethod"
                :search_keyword="parameter.keyword"
                :sort_option="parameter.sort_method"
                search_type="product"
            ></Modal-Sorting>
            
            <!-- 꼼꼼하게 찾기 모달 -->
            <Modal-Filter
                ref="modal_filter"
                @do_kkomkkom_search="doFilterSearch"
                @change_makerIds="changeFilterMakerIds"
                @close_kkomkkom="clearFilter"
                @clear_all="clearFilter"
                :parameter="filterParameter"
                :is_biz="true"
            ></Modal-Filter>

        </div>
    `,

    data() {return {
        isApp : isApp
    }},

    created() {
        // SET 파라미터
        this.$store.commit('SET_PARAMETER', parameter);
        // GET 상품 리스트
        this.$store.dispatch('GET_PRODUCTS');
        // GET 필터 검색조건 조회
        this.$store.dispatch('GET_FILTER_CRITERIA');
    },

    mounted() {
        fnAmplitudeEventMultiPropertiesAction('view_biz_search','keyword',parameter.keyword);
    },

    computed : {
        parameter() { return this.$store.getters.parameter; }, // 파라미터
        productCount() { return this.$store.getters.productCount; }, // 상품 갯수
        products() { return this.$store.getters.products; }, // 상품 리스트
        lastPage() { return this.$store.getters.lastPage; }, // 마지막 페이지
        loadingComplete() { return this.$store.getters.loadingComplete; }, // 로딩 완료 여부

        // 필터 검색 여부
        isFilterSearched() {
            return this.parameter.deliType.length > 0 || this.parameter.dispCategories.length > 0
                || this.parameter.makerIds.length > 0 || this.parameter.minPrice !== ''
                || this.parameter.maxPrice !== ''
        },
        filterParameter() { // 필터 모달 파라미터
            return {
                searched_deliType : this.parameter.deliType,
                searched_categories : this.parameter.dispCategories,
                searched_brands : this.parameter.makerIds,
                searched_min_price : this.parameter.minPrice,
                searched_max_price : this.parameter.maxPrice,
                search_keyword : this.parameter.keyword,
                view_type : 'detail',
                sort_method : this.parameter.sort_method,
                result_count : this.productCount,
                result_price : this.$store.getters.filterPrice,
                categories : this.$store.getters.filterCategories,
                brands : this.$store.getters.filterBrands,
                brand_page : 1
            };
        },
    },

    methods : {
        // 정렬 옵션 변경
        changeSortMethod(sortMethod) {
            this.go_page(sortMethod);
        },
        // 필터 초기화
        resetFilter() {
            location.href = '?keyword=' + this.parameter.keyword
                + '&sortMethod=' + this.parameter.sort_method
                + '&viewType=' + this.parameter.view_type;
        },
        // 페이지 이동
        movePage(page) {
            this.go_page(null, page);
        },
        // 검색결과 없음 돌아가기
        goBack() {
            history.back();
        },
        // 필터 검색 실행
        doFilterSearch(parameters) {
            this.go_page(null, 1, parameters);
        },
        // 페이지 이동 공통 함수
        go_page(sortMethod, page, parameters) {
            const currentParameters = this.parameter;
            if( parameters == null )
                parameters = {};

            location.href = `?keyword=${currentParameters.keyword}`
                + `&sortMethod=${sortMethod != null ? sortMethod : currentParameters.sort_method}`
                + `&page=${page != null ? page : currentParameters.page}`
                + `&deliType=${(parameters.deliType != null ? parameters.deliType : currentParameters.deliType).join(', ')}`
                + `&dispCategories=${(parameters.dispCategories != null ? parameters.dispCategories : currentParameters.dispCategories).join(', ')}`
                + `&makerIds=${(parameters.makerIds != null ? parameters.makerIds : currentParameters.makerIds).join(', ')}`
                + `&minPrice=${parameters.min_price != null ? parameters.min_price : currentParameters.minPrice}`
                + `&maxPrice=${parameters.max_price != null ? parameters.max_price : currentParameters.maxPrice}`
        },

        // 필터 팝업
        popModalFilter() {
            this.$refs.modal_filter.refresh();
            this.open_pop('modal_filter');
        },
        // 브랜드 필터 변경
        changeFilterMakerIds(parameters) {
            this.$store.commit('UPDATE_FILTER_MAKERIDS', parameter);
        },
        // 필터 초기화
        clearFilter() {
            this.$store.commit('CLEAR_FILTER_MAKERIDS'); // 꼼꼼하게 찾기 추가한 브랜드 초기화
        },
        // 상품상세 이동 Amplitude 전송
        sendClickProductAmplitude() {

        }
    }
});