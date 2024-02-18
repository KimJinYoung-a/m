var app = new Vue({
    el: '#app',
    store: store,
    mixins : [item_mixin, search_mixin, modal_mixin, common_mixin],
    template: `
        <div id="content" class="content search_detail">
            <!-- 검색바 -->
            <Searchbar
                v-if="is_loading_complete"
                :searched_keyword="parameter.keyword"
                :correct_keyword="correct_keyword"
                @click_search_within_this="search_within_this"
                @do_search="move_search_result"
            ></Searchbar>
            
            <!-- 오타교정 검색어 -->
            <Correct-Typos @moveIgnoreCorrect="move_ignore_correct" 
                :correct_keyword="correct_keyword" :pre_correct_keyword="pre_correct_keyword"/>
            
            <!-- 대체 검색어 -->
            <Alternative-Keyword :alternative_keyword="alternative_keyword"/>
            
            <!-- 연관 검색어 -->
            <Recommend-Keywords :recommend_keywords="recommend_keywords" :background_image="quicklink.background_image"/>
            
            <!-- 키워드 퀵링크 -->
            <Quicklink :background_image="quicklink.background_image"
                :move_url="quicklink.move_url" :main_copy="quicklink.main_copy"
                :text_color="quicklink.text_color" 
                :recommend_keywords="recommend_keywords"    
            />
            
            <!-- 검색 결과 구분 -->
            <Search-Category
                :search_keyword="parameter.keyword"
                :groups_count="groups_count"
                active_group="product"
            ></Search-Category>
            
            <hr class="hr_div">
            
            <!-- 정렬 바 -->
            <Sortbar
                :sort="parameter.sort_method"
                :kkomkkom_flag="true"
                :do_search_flag="is_kkomkkom_searched"
                search_type="product"
                @pop_sort_option="pop_sort_option"
                @pop_kkomkkom="pop_modal_filter"
                @kkomkkom_reset="kkomkkom_reset"
            ></Sortbar>
            
            <!-- 검색 후 검색결과가 있으면 -->
            <template v-if="is_loading_complete && product_count > 0">
                
                <header class="head_type2">
                    <h2 class="ttl">{{number_format(product_count)}}건의 상품을<br>찾아냈어요!</h2>
                </header>
                
                <!-- 뷰 타입 탭 -->
                <Tab-View-Type
                    :view_type="parameter.view_type"
                    @change_view_type="change_view_type"
                ></Tab-View-Type>
                
                <!-- 상품 검색 결과 - 자세히 -->
                <div class="prd_list type_basic" v-if="product_count > 0 && parameter.view_type == 'detail'">
                    <template v-for="(product, index) in products">
                        <!-- 헬퍼 영역 -->
                        <article v-if="current_page === 1 && product_count > 100 && index === 3">
                            <button class="btn_helper" @click="click_helper">
                                <span class="txt">다른 텐텐이들은<br>뭘 샀을까?</span>
                                <i class="i_arw_line_r"></i>
                            </button>
                        </article>
                        <Product-Item-Basic
                            :index="index + 1"
                            @change_wish_flag="change_wish_flag_product"
                            @go_item_detail="send_click_search_result_item_amplitude"
                            :isApp="isApp"
                            :product="product"
                            wish_type="list"
                            wish_place="search_result_item"
                            :view_type="parameter.view_type"
                            :sort="parameter.sort_method"
                            :filter_recommend="filter_recommend"
                            :filter_category="parameter.dispCategories"
                            :filter_brand="parameter.makerIds"
                            :filter_delivery="filter_delivery"
                            :filter_lowprice="parameter.minPrice"
                            :filter_highprice="parameter.maxPrice"
                        ></Product-Item-Basic>
                    </template>
                </div>
                
                <!-- 상품 검색 결과 - 사진만 -->
                <Product-List-Photo2
                    v-if="products.length > 0 && parameter.view_type == 'photo'"
                    @change_wish_flag="change_wish_flag_product"
                    @go_item_detail="send_click_search_result_item_amplitude"
                    :products="products"
                    wish_type="list"
                    wish_place="search_result_item"
                    :view_type="parameter.view_type"
                    :sort="parameter.sort_method"
                    :filter_recommend="filter_recommend"
                    :filter_category="parameter.dispCategories"
                    :filter_brand="parameter.makerIds"
                    :filter_delivery="filter_delivery"
                    :filter_lowprice="parameter.minPrice"
                    :filter_highprice="parameter.maxPrice"
                ></Product-List-Photo2>
                
                <!-- 페이지 -->
                <Pagination
                    v-if="is_loading_complete"
                    @move_page="move_page"
                    :current_page="current_page"
                    :last_page="last_page"
                ></Pagination>
                
            </template>
            
            <!-- 검색 후 검색결과가 없으면 -->
            <template v-else-if="is_loading_complete && product_count == 0">
                <Search-Result-Nodata
                    @change_wish_flag="change_wish_flag_product"
                    @change_best_keyword="change_best_keyword"
                    :best_keywords="best_keywords"
                    :best_products="best_products"
                    :is_show_how_about_this="true"
                    wish_place="search_none_item_keyword"
                    wish_type="no_result_products"/>
            </template>
            
            <!-- 이 안에서 검색 -->
            <Add-Keyword
                @search_add_keyword="do_search_within_this"
                :result_count="product_count"
                :search_keyword="parameter.keyword"
            ></Add-Keyword>
            
            <!-- 정렬 옵션 모달 -->
            <Modal-Sorting
                :is_groups_show="true"
                :groups_count="groups_count"
                :search_keyword="parameter.keyword"
                :sort_option="parameter.sort_method"
                search_type="product"
            ></Modal-Sorting>
            
            <!-- 상품 헬퍼 모달 -->
            <Modal
                :type=4
                :content="product_helper"
                :parameter="helper_parameter"
                @wish_product="wish_helper_product"
                modal_id="helper_modal"
            ></Modal>
            
            <!-- 꼼꼼하게 찾기 모달 -->
            <Modal-Filter
                @modal_paging="get_more_kkomkkom_brands"
                @change_makerIds="change_kkomkkom_makerIds"
                @close_kkomkkom="close_kkomkkom"
                @clear_all="clear_kkomkkom_all"
                ref="modal_filter"
                :parameter="kkomkkom_parameter"
            ></Modal-Filter>
            
        </div>
    `,

    created() {
        // SET 파라미터
        this.$store.commit('SET_PARAMETER', parameter);
        // READ 검색결과
        this.$store.dispatch('READ_SEARCH_PRODUCTS');
    },

    mounted() {
        // 검색 Amplitude 전송
        this.send_search_amplitude(this.parameter.keyword, 'item'
            , this.parameter.view_type, this.parameter.sort_method, this.parameter.deliType
            , this.parameter.dispCategories, this.parameter.makerIds, this.parameter.minPrice
            , this.parameter.maxPrice, this.current_page);
    },

    data() {return {
        isApp : isApp,
        product_helper : product_helper, // 헬퍼 컴포넌트
    }},

    computed : {
        parameter() { return this.$store.getters.parameter; }, // 파라미터
        current_page() { return Number(this.$store.getters.parameter.page); }, // 현재 페이지
        last_page() { return this.$store.getters.last_page; }, // 마지막 페이지
        is_loading_complete() { return this.$store.getters.is_loading_complete; }, // 로딩 완료 여부
        correct_keyword() { return this.$store.getters.correct_keyword; }, // 교정 후 검색어
        pre_correct_keyword() { return this.$store.getters.pre_correct_keyword; }, // 교정 전 검색어
        alternative_keyword() { return this.$store.getters.alternative_keyword; }, // 대체 키워드
        recommend_keywords() { return this.$store.getters.recommend_keywords; }, // 추천(연관) 검색어 리스트
        best_keywords() { return this.$store.getters.best_keywords; }, // 베스트 키워드 리스트
        product_count() { return this.$store.getters.product_count; }, // 상품 결과 수
        groups_count() { return this.$store.getters.groups_count; }, // 그룹별 겸색결과 수
        products() { return this.$store.getters.products; }, // 상품 리스트
        best_products() { return this.$store.getters.best_products; }, // 베스트 상품 리스트
        helper() { return this.$store.getters.helper; }, // 헬퍼
        quicklink() { return this.$store.getters.quicklink; }, // 퀵링크

        // 꼼꼼하게 찾기 여부
        is_kkomkkom_searched() {
            return this.parameter.deliType.length > 0 || this.parameter.dispCategories.length > 0
                || this.parameter.makerIds.length > 0 || this.parameter.minPrice !== ''
                || this.parameter.maxPrice !== ''
        },
        // 헬퍼 모달 파라미터
        helper_parameter() {
            return {
                best_seller: this.helper.best_seller,
                best_popularity: this.helper.best_popularity,
                md_recommend: this.helper.md_recommend,
                best_rating: this.helper.best_rating
            };
        },
        // 꼼꼼하게 찾기 모달 파라미터
        kkomkkom_parameter() {
            return {
                searched_deliType : this.parameter.deliType,
                searched_categories : this.parameter.dispCategories,
                searched_brands : this.parameter.makerIds,
                searched_min_price : this.parameter.minPrice,
                searched_max_price : this.parameter.maxPrice,
                search_keyword : this.correct_keyword ? this.correct_keyword : this.parameter.keyword, // 교정검색어가 있으면 교정검색어 적용
                view_type : this.parameter.view_type,
                sort_method : this.parameter.sort_method,
                result_count : this.product_count,
                result_price : this.$store.getters.kkomkkom_price,
                categories : this.$store.getters.kkomkkom_categories,
                brands : this.$store.getters.kkomkkom_brands,
                brand_page : this.$store.getters.page_kkomkkom_brand,
            };
        },
        // 필터 - 추천 for Wish Amplitude
        filter_recommend() {
            return amplitudeFilterRecommend(this.parameter.deliType);
        },
        // 필터 - 배송 for Wish Amplitude
        filter_delivery() {
            return amplitudeFilterDelivery(this.parameter.deliType);
        }
    },

    methods : {
        // 베스트키워드 변경
        change_best_keyword(keyword) {
            this.$store.dispatch('CHANGE_BEST_PRODUCTS', keyword);
        },
        // 이 안에서 검색 실행
        do_search_within_this(keyword) {
            location.href = '?' + this.create_uri('keyword', keyword).substr(1);
        },
        // 헬퍼 상품 위시 변경
        wish_helper_product(wish_info) {
            this.$store.commit('UPDATE_HELPER_PRODUCT_WISH', wish_info);
        },
        // 페이지 이동
        move_page(page) {
            let param = '?keyword=' + this.parameter.keyword + '&view_type=' + this.parameter.view_type
                + '&sort_method=' + this.parameter.sort_method + '&page=' + page;

            if( this.parameter.deliType.length > 0 ) { // 배송/기타
                for( let i=0 ; i<this.parameter.deliType.length ; i++ ) {
                    param += '&deliType=' + this.parameter.deliType[i];
                }
            }
            if( this.parameter.dispCategories.length > 0 ) { // 카테고리
                for( let i=0 ; i<this.parameter.dispCategories.length ; i++ ) {
                    param += '&dispCategories=' + this.parameter.dispCategories[i];
                }
            }
            if( this.parameter.makerIds.length > 0 ) { // 브랜드
                for( let i=0 ; i<this.parameter.makerIds.length ; i++ ) {
                    param += '&makerIds=' + this.parameter.makerIds[i];
                }
            }

            if( this.parameter.minPrice !== '' ) { // 최저가
                param += '&minPrice=' + this.parameter.minPrice;
            }
            if( this.parameter.maxPrice !== '' ) { // 최고가
                param += '&maxPrice=' + this.parameter.maxPrice;
            }
            location.href = param;
        },

        // 꼼꼼하게 찾기 팝업
        pop_modal_filter() {
            this.$refs.modal_filter.refresh();
            this.open_pop('modal_filter');
        },
        // 꼼꼼하게 찾기 초기화
        kkomkkom_reset() {
            location.href = '?keyword=' + this.parameter.keyword
                + '&sortMethod=' + this.parameter.sort_method
                + '&view_type=' + this.parameter.view_type;
        },
        // 꼼꼼하게 찾기 브랜드 더 불러오기
        get_more_kkomkkom_brands(parameter) {
            this.$store.dispatch('GET_MORE_KKOMKKOM_BRANDS', parameter.brand_name_keyword);
        },
        // 꼼꼼하게 찾기 브랜드 추가/삭제 시
        change_kkomkkom_makerIds(parameter) {
            this.$store.commit('UPDATE_KKOMKKOM_MAKERIDS', parameter);
        },
        // 꼼꼼하게 찾기 모달 닫음
        close_kkomkkom() {
            this.$store.commit('CLEAR_KKOMKKOM_MAKERIDS'); // 꼼꼼하게 찾기 추가한 브랜드 초기화
        },
        // 꼼꼼하게 찾기 초기화
        clear_kkomkkom_all() {
            this.$store.commit('CLEAR_KKOMKKOM_MAKERIDS'); // 꼼꼼하게 찾기 추가한 브랜드 초기화
        },

        // 헬퍼 클릭시 amplitude 전송 & 헬퍼 모달 팝업
        click_helper() {
            fnAmplitudeEventObjectAction('click_search_result_item', {
                'item_type' : 'picky',
                'list_type' : 'item',
                'list_style' : 'list',
                'sort' : amplitudeSort(this.parameter.sort_method),
                'keyword' : this.parameter.keyword
            });
            this.open_pop('helper_modal');
        },
        // click_search_result_item Amplitude전송
        send_click_search_result_item_amplitude(index, product) {
            fnAmplitudeEventObjectAction('click_search_result_item', {
                'item_index' : index,
                'item_type' : 'product',
                'list_style' : this.parameter.view_type === 'detail' ? 'list' : 'photo',
                'sort' : amplitudeSort(this.parameter.sort_method),
                'keyword' : this.parameter.keyword,
                'list_type' : 'item',
                'itemid' : product.item_id,
                'category_name' : product.category_name,
                'brand_name' : product.brand_name_en
            });
        }
    }
});