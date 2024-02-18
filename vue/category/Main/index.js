var app = new Vue({
    el: '#app',
    store: store,
    mixins: [modal_mixin, common_mixin, item_mixin],
    template: `
		<div id="content" class="content category_main">
		    
		    <!-- 하위 카테고리 Nav -->
		    <Category-Nav-Type1
		        @pop_category_explorer="pop_category_explorer"
		        @click_category="move_category"
		        :this_category="this_category"
		        :categories="categories"
		        :first_category_view_count="6"
		    ></Category-Nav-Type1>
		    
		    <!-- 피키 -->
		    <div id="picky" @click="open_wonder_modal" class="picky">
                <p class="bbl_blk bbl_r">추천할게요!</p>
            </div>
		    
		    <!-- 컨텐츠 -->
		    <Contents
		        v-if="parameter.page == 1"
		        @change_wish_flag="change_wish_flag_product"
		        @wish_brand="wish_brand"
		        @click_more_button="open_pop('modal')"
		        :content_order="content_order"
                :banners="banners"
                :exhibitions="exhibitions"
                :brand="brand"
                :category="Number(this_category.category_code)"
		    ></Contents>
		    <!-- 배너가 없으면 구분선 -->
		    <hr v-if="banners == null || banners.length == 0" class="hr_div"/>
		    
		    <!-- 상품 리스트 -->
		    <!-- 정렬바 -->
            <Sortbar
                ref="sortbar"
                :sort="parameter.sort_method"
                :kkomkkom_flag="true"
                :do_search_flag="is_kkomkkom_searched"
                @pop_sort_option="open_pop('modal_sorting')"
                @pop_kkomkkom="pop_modal_filter"
                @kkomkkom_reset="kkomkkom_reset"
            ></Sortbar>
            
            <!-- 검색결과 존재 -->
            <template v-if="first_loading_complete && products.length > 0">
                <!-- 뷰 타입 탭 -->
                <Tab-View-Type
                    @change_view_type="change_view_type"
                    :view_type="parameter.view_type"
                ></Tab-View-Type>
                
                <!-- 상품 리스트(자세히) -->
                <div class="prd_list type_basic" v-if="parameter.view_type == 'detail'">
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
                        :category="Number(this_category.category_code)"
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
                    v-if="parameter.view_type == 'photo'"
                    @change_wish_flag="change_wish_flag_product"
                    @go_item_detail="go_item_detail"
                    :products="products"
                    wish_place="category_list"
                    wish_type="list"
                    :category="Number(this_category.category_code)"
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
                    @move_page="move_page"
                    :current_page="parameter.page"
                    :last_page="last_page"
                ></Pagination>
            </template>
            <No-Data v-else-if="first_loading_complete" @click_return_button="click_return_button"></No-Data>
		    
		    <!-- 배너 뷰어 모달 -->
            <Modal :type=4 modal_id="banner_viewer_modal">
                <Banner-Viewer slot="body" :banners="banners"></Banner-Viewer>
            </Modal>
            
            <!-- 카테고리 익스플로어 모달 -->
            <Modal :type="4" modal_id="category_explorer">
                <Category-Explorer slot="body" ref="category_explorer"
                    :explorer_categories="explorer_categories"
                    :selected_category_code="this_category.category_code.toString()"
                ></Category-Explorer>
            </Modal>
            
            <!-- 추천상품 리스트 모달 -->
            <Modal :type="4" modal_id="wonder_modal">
                <Wonders slot="body" ref="wonder"
                    @loading_more_wonders="loading_more_wonders"
                    :category_name="this_category.category_name"
                    :titles="titles"
                    :wonder_products="wonder_products"
                    :is_wonder_loading="is_wonder_loading"
                    :view_type="parameter.view_type"
                    :sort="parameter.sort_method"
                    :filter_recommend="filter_recommend"
                    :filter_brand="parameter.makerIds"
                    :filter_delivery="filter_delivery"
                    :filter_lowprice="parameter.minPrice"
                    :filter_highprice="parameter.maxPrice"
                    :page="parameter.page"
                ></Wonders>
            </Modal>
            
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
                @do_kkomkkom_search="do_kkomkkom_search"
                @modal_paging="get_more_kkomkkom_brands"
                @change_makerIds="change_kkomkkom_makerIds"
                @close_kkomkkom="close_kkomkkom"
                @clear_all="clear_kkomkkom_all"
                ref="modal_filter"
                :parameter="filter_parameter"
                :is_category_search="true"
            ></Modal-Filter>

            <!-- 탑 버튼 -->
            <Button-Top/>
		    
		</div>
    `,
    created() {
        console.log(parameter);
        this.$store.commit('SET_REQ_PARAM', parameter); // SET 파라미터
        this.$store.dispatch('GET_TOP_CONTENTS'); // GET 상단 컨텐츠 data
        this.$store.dispatch('GET_EXPLORER_CATEGORIES'); // GET 카테고리 익스플로어 카테고리 리스트
        this.$store.dispatch('GET_PRODUCTS');
        this.$store.dispatch('GET_KKOMKKOM_CRITERIA'); // GET 꼼꼼하게 찾기 검색조건 조회
    },

    mounted() {
        $(function() { document.getElementById('picky').classList.add('show'); });
        this.main_scroll();
    },

    data() { return {
        isApp : isApp, // 앱 여부
    }},

    computed : {
        parameter() { // 파라미터
            return this.$store.getters.parameter;
        },
        this_category() { // 현재 카테고리
            return this.$store.getters.this_category;
        },
        categories() { // 하위 카테고리 리스트
            return this.$store.getters.categories;
        },
        content_order : function () { // 컨텐츠 순서
            return this.$store.getters.content_order;
        },
        banners : function() { // 배너 리스트
            return this.$store.getters.banners;
        },
        exhibitions : function() { // 기획전 리스트
            return this.$store.getters.exhibitions;
        },
        brand : function() { // 브랜드
            return this.$store.getters.brand;
        },
        titles : function() { // 뭐 없을까 싶을 때 탭 타이틀 리스트
            return this.$store.getters.titles;
        },
        wonder_products : function() { // 뭐 없을까 싶을 때 상품 리스트
            return this.$store.getters.wonder_products;
        },
        explorer_categories() { // 카테고리 익스플로어 카테고리 리스트
            return this.$store.getters.explorer_categories;
        },
        is_wonder_loading() { // 뭐 없을까 싶을 때 로딩중 여부
            return this.$store.getters.is_wonder_loading;
        },
        is_kkomkkom_searched() { // 꼼꼼하게 찾기 여부
            return this.parameter.deliType.length > 0 || this.parameter.makerIds.length > 0
                || this.parameter.minPrice !== '' || this.parameter.maxPrice !== '';
        },
        filter_parameter() { // 꼼꼼하게 찾기 모달 파라미터
            return {
                disp_category : this.parameter.category_code,
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
        products() { // 상품 리스트
            return this.$store.getters.products;
        },
        product_count() { // 상품 갯수
            return this.$store.getters.product_count;
        },
        last_page() { // 마지막 페이지
            return this.$store.getters.last_page;
        },
        first_loading_complete() { // 첫 로딩 끝났는지 여부
            return this.$store.getters.first_loading_complete;
        },
        filter_recommend() { // 필터 - 추천 for Wish Amplitude
            return amplitudeFilterRecommend(this.parameter.deliType);
        },
        filter_delivery() { // 필터 - 배송 for Wish Amplitude
            return amplitudeFilterDelivery(this.parameter.deliType);
        }
    },

    methods : {
        move_category(category_code, has_row_list) { // 카테고리 이동
            location.href = '/category/category_detail2020.asp?disp=' + category_code;
        },
        move_page(page) { // 페이지 이동
            this.go_page(null, null, page);
        },
        loading_more_wonders(type) { // 뭐 없을까 싶을 때 더 불러오기
            this.$store.dispatch('GET_MORE_WONDERS', type);
        },
        wish_brand(id, on_flag) { // 지금 뜨고있는 브랜드 위시
            console.log('wish_brand', id, on_flag);
            this.$store.commit('UPDATE_BRAND_WISH', on_flag);
        },
        pop_category_explorer() { // 카테고리 익스플로어 팝업
            this.$refs.category_explorer.refresh();
            this.open_pop('category_explorer');
        },
        main_scroll() { // 페이지 스크롤 시
            const picky = document.getElementById('picky'); // 피키

            window.addEventListener('scroll', () => {

                // 피키보다 현재 Y좌표가 크면 숨김 else 등장
                if( window.scrollY > picky.offsetTop ) {
                    picky.classList.remove('show');
                } else {
                    picky.classList.add('show');
                }
            });
        },
        open_wonder_modal() { // 추천 상품 모달 Open
            if( this.$refs.wonder.active_wonder_type === '' ) {
                this.$refs.wonder.set_default_wonder_type(this.titles[0].value);
            }
            this.open_pop('wonder_modal');
        },
        pop_modal_filter() { // 꼼꼼하게찾기 팝업
            this.$refs.modal_filter.refresh();
            this.open_pop('modal_filter');
        },
        kkomkkom_reset() { // 꼼꼼하게찾기 초기화
            this.go_page(null, null, 1, {
                deliType: [], makerIds: [], minPrice: '', maxPrice: ''
            });
        },
        change_sort_option(option) { // 정렬 옵션 변경
            this.close_pop('modal_sorting');
            this.go_page(null, option, 1);
        },
        change_view_type(type) { // 뷰타입 전환
            this.go_page(type);
        },
        do_kkomkkom_search(parameters) { // 꼼꼼하게찾기 실행
            this.go_page(null, null, 1, parameters);
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
        click_return_button() { // 초기화
            history.back();
        },
        go_page(view_type, sort_method, page, parameters) {
            const current_param = this.parameter;
            if( parameters == null )
                parameters = {};

            location.href = `?disp=${current_param.category_code}&viewType=${view_type != null ? view_type : current_param.view_type}`
                            + `&sortMethod=${sort_method != null ? sort_method : current_param.sort_method}`
                            + `&page=${page != null ? page : current_param.page}`
                            + `&deliType=${(parameters.deliType != null ? parameters.deliType : current_param.deliType).join(',')}`
                            + `&makerIds=${(parameters.makerIds != null ? parameters.makerIds : current_param.makerIds).join(',')}`
                            + `&minPrice=${parameters.min_price != null ? parameters.min_price : current_param.minPrice}`
                            + `&maxPrice=${parameters.max_price != null ? parameters.max_price : current_param.maxPrice}`
        },
        go_item_detail(index, product) {
            // Android일 경우 뒤로가기용 현재 조건들 저장
            if( window.userAgent.indexOf('android') > -1 ) {
                localStorage.setItem('category_parameter', JSON.stringify({
                    'sort_method' : this.parameter.sort_method,
                    'view_type' : this.parameter.view_type,
                    'page' : this.parameter.page,
                    deliType: amplitudeFilterToDeliType(this.filter_delivery, this.filter_recommend),
                    makerIds: this.parameter.makerIds,
                    minPrice: this.parameter.minPrice,
                    maxPrice: this.parameter.maxPrice
                }));
            }

            // Amplitude 전송
            fnAmplitudeEventObjectAction('click_category_productlist_item', {
                'item_index' : index,
                'list_style' : this.parameter.view_type === 'detail' ? 'list' : 'photo',
                'sort' : amplitudeSort(this.parameter.sort_method),
                'category_code' : this.this_category.category_code,
                'itemid' : product.item_id,
                'category_name' : product.category_name,
                'brand_name' : product.brand_name_en,
                'page_number' : this.parameter.page
            });
        }
    }
});