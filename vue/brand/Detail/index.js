var app = new Vue({
    el: '#app',
    store: store,
    mixins: [common_mixin, item_mixin, modal_mixin],
    template: `
		<div id="content" class="content brand_detail">
		    <article :class="['brd_item','type2',{active: is_show_story}]">
                <figure class="brd_img">
                    <img :src="brand_info.brand_image" alt="">
                </figure>
                <div class="brd_info">
                    <div class="brd_name">{{brand_info.brand_name_kr}}</div>
                    <div class="brd_name">{{brand_info.brand_name_en}}</div>
                    <div v-if="brand_info.brand_story" class="brd_desc">
                        <p v-show="is_show_story" v-html="brand_info.brand_story"></p>
                        <button @click="click_story_button" type="button" class="btn_tgl">
                            브랜드 소개글 {{is_show_story ? '접기' : '보기'}}<i class="i_arw_d1"></i>
                        </button>
                    </div>
                </div>
                <WISH
                    @change_wish_flag="change_wish_brand"
                    :id="brand_id"
                    :wish_cnt="brand_info.wish_cnt"
                    :brand_name_en="brand_info.brand_name_en"
                    type="brand"
                    place="brand_list_brand"
                    :on_flag="brand_info.wish_yn"
                    :isApp="isApp"
                ></WISH>
                <div v-if="events && events.length > 0" class="evt_list">
                    <article
                        v-for="event in events"
                        :key="event.evt_code"
                        class="evt_item">
                        <span class="label">{{event.marketing_yn ? '이벤트' : '기획전'}}</span>
                        <div class="evt_name">{{event.evt_name}}</div>
                        <a @click="go_event(event.move_url)" class="evt_link"><span class="blind">{{event.marketing_yn ? '이벤트' : '기획전'}} 바로가기</span></a>
                    </article>
                </div>
            </article>
            
            <!-- 퀵링크 -->
            <div v-if="quick_link.move_url && quick_link.background_image" class="bnr_item">
                <img :src="quick_link.background_image" alt="">
                <a :href="quick_link.move_url" class="bnr_link">기획전 명</a>
            </div>
            
            <Item-Module-Header
                :top_text="number_format(product_count) + '건의'"
                bottom_text="상품이 있어요"
            ></Item-Module-Header>
            
            <!-- 정렬바 -->
            <Sortbar
                v-show="is_first_loaded && (product_count > 0 || is_filter_searched)"
                ref="sort_bar"
                :sort="sort_method"
                :kkomkkom_flag="true"
                :do_search_flag="is_filter_searched"
                @pop_sort_option="pop_sort_option"
                @pop_kkomkkom="pop_modal_filter"
                @kkomkkom_reset="kkomkkom_reset"
            ></Sortbar>
            
            <template v-if="is_first_loaded && (product_count > 0 || is_filter_searched)">
                
                <!-- 뷰 타입 탭 -->
                <Tab-View-Type
                    :view_type="view_type"
                    @change_view_type="change_view_type"
                ></Tab-View-Type>
                
                <!-- 상품 리스트 - 자세히 -->
                <div class="prd_list type_basic" v-if="product_count > 0 && view_type == 'detail'">
                    <Product-Item-Basic
                        v-for="(product, index) in products"
                        :key="product.item_id"
                        :index="index + 1"
                        @change_wish_flag="change_wish_flag_product"
                        @go_item_detail="go_item_detail"
                        :isApp="false"
                        :product="product"
                        wish_place="brand_list_item"
                        wish_type="list"
                        :view_type="view_type"
                        :sort="sort_method"
                        :brand="brand_id"
                        :filter_recommend="filter_recommend"
                        :filter_category="filter_parameter.dispCategories"
                        :filter_delivery="filter_delivery"
                        :filter_lowprice="filter_parameter.minPrice"
                        :filter_highprice="filter_parameter.maxPrice"
                    ></Product-Item-Basic>
                </div>
                
                <!-- 상품 리스트 - 사진만 -->
                <Product-List-Photo2
                    v-else-if="product_count > 0 && view_type == 'photo'"
                    @change_wish_flag="change_wish_flag_product"
                    @go_item_detail="go_item_detail"
                    :isApp="isApp"
                    :products="products"
                    wish_place="brand_list_item"
                    wish_type="list"
                    :view_type="view_type"
                    :sort="sort_method"
                    :brand="brand_id"
                    :filter_recommend="filter_recommend"
                    :filter_category="filter_parameter.dispCategories"
                    :filter_delivery="filter_delivery"
                    :filter_lowprice="filter_parameter.minPrice"
                    :filter_highprice="filter_parameter.maxPrice"
                ></Product-List-Photo2>
                
                <No-Data
                    v-else
                    @click_return_button="click_return_button"
                ></No-Data>
                
            </template>
            <template v-else-if="is_first_loaded">
                <div class="no_data">
                    <p><strong>이런, 해당하는 상품이 없어요!</strong> 빠른 시일 내로 준비해볼게요</p>
                </div>
            </template>
            
            <!-- 정렬 옵션 모달 -->
            <Modal-Sorting
                @change_sort_option="change_sort_option"
                :is_groups_show="false"
                :sort_option="sort_method"
                search_type="product"
            ></Modal-Sorting>
            
            <!-- 꼼꼼하게 찾기 모달 -->
            <Modal-Filter
                ref="modal_filter"
                @modal_paging="get_more_kkomkkom_brands"
                @change_makerIds="change_kkomkkom_makerIds"
                :is_brand_detail="true"
                :parameter="filter_modal_parameter"
            ></Modal-Filter>

            <!-- 탑 버튼 -->
            <Button-Top/>
		</div>
    `,
    data() {return {
        isApp : isApp, // 앱 여부
        is_show_story : false, // 스토리 펼쳐있는지 여부
    }},

    created() {
        const store = this.$store;
        store.commit('SET_PARAMETER', parameter);
        store.dispatch('GET_BRAND_INFO_AND_PRODUCTS');
        store.dispatch('GET_FILTER_CRITERIA');
    },

    mounted() {
        this.products_scroll();
        this.$refs.sort_bar.set_sortbar_float(); // 정렬바 scroll float
    },

    computed : {
        brand_id() { // 브랜드ID
            return this.$store.getters.brand_id;
        },
        sort_method() { // 정렬조건
            return this.$store.getters.sort_method;
        },
        view_type() { // 뷰 타입
            return this.$store.getters.view_type;
        },
        filter_parameter() { // 필터 파라미터
            return this.$store.getters.filter_parameter;
        },
        filter_criteria() { // 필터 조건
            return this.$store.getters.filter_criteria;
        },
        filter_modal_parameter() { // 필터 모달 파라미터
            return {
                searched_categories : this.filter_parameter.dispCategories,
                searched_deliType : this.filter_parameter.deliType,
                searched_min_price : this.filter_parameter.minPrice,
                searched_max_price : this.filter_parameter.maxPrice,
                view_type : this.view_type,
                sort_method : this.sort_method,
                result_count : this.product_count,
                brand_id : this.brand_id,
                categories: this.filter_criteria.categories,
                result_price : {
                    min: this.filter_criteria.min_price,
                    max: this.filter_criteria.max_price
                }
            }
        },
        brand_info() { // 브랜드 정보
            return this.$store.getters.brand_info;
        },
        quick_link() { // 퀵링크
            return this.$store.getters.quick_link;
        },
        product_count() { // 상품 갯수
            return this.$store.getters.product_count;
        },
        products() { // 상품 리스트
            return this.$store.getters.products;
        },
        events() { // 이벤트 리스트
            return this.$store.getters.events;
        },
        is_loading() { // 페이지 로딩 중 여부
            return this.$store.getters.is_loading;
        },
        is_first_loaded() { // 첫 로딩 완료 여부
            return this.$store.getters.is_first_loaded;
        },
        is_filter_searched() { // 꼼꼼하게찾기 실행 여부
            return this.filter_parameter.deliType.length > 0 || this.filter_parameter.dispCategories.length > 0
                || this.filter_parameter.minPrice !== '' || this.filter_parameter.maxPrice !== ''
        },
        is_loading_complete() { // 페이지 종료 여부
            return this.$store.getters.is_loading_complete;
        },
        current_page() { // 현재 페이지
            return this.$store.getters.current_page;
        },
        filter_recommend() { // 필터 - 추천 for Wish Amplitude
            return amplitudeFilterRecommend(this.filter_parameter.deliType);
        },
        filter_delivery() { // 필터 - 배송 for Wish Amplitude
            return amplitudeFilterDelivery(this.filter_parameter.deliType);
        }
    },

    methods : {
        pop_modal_filter() { // 꼼꼼하게찾기 팝업
            this.$refs.modal_filter.refresh();
            this.open_pop('modal_filter');
        },
        kkomkkom_reset() { // 꼼꼼하게찾기 초기화
            location.href = '?brandid=' + this.brand_id
                + '&sort_method=' + this.sort_method
                + '&view_type=' + this.view_type;
        },
        get_more_kkomkkom_brands(parameter) { // 꼼꼼하게 찾기 브랜드 더 불러오기
            this.$store.dispatch('GET_MORE_KKOMKKOM_BRANDS', parameter.brand_name_keyword);
        },
        change_kkomkkom_makerIds(parameter) { // 꼼꼼하게 찾기 브랜드 추가/삭제 시
            this.$store.commit('UPDATE_KKOMKKOM_MAKERIDS', parameter);
        },
        go_event(uri) { // 클릭한 이벤트 페이지로 이동
            location.href = this.decode_base64(uri);
        },
        change_view_type(type) { // 뷰 타입 변경
            location.href = this.create_uri('view_type', type);
        },
        change_sort_option(option) { // 정렬옵션 변경
            location.href = this.create_uri('sort_method', option);
        },
        pop_sort_option() { // 정렬옵션 팝업
            console.log('pop_sort_option');
        },
        click_story_button(e) { // 소개글 보기/접기
            this.is_show_story = !this.is_show_story
        },
        click_return_button() { // 꼼꼼하게 찾기 돌아가기 버튼
            history.back();
        },
        products_scroll : function() { // 스크롤 시 상품 리스트 더 가져옴
            const _this = this;

            window.onscroll = function () {
                if ( !_this.is_loading && _this.is_first_loaded && !_this.is_loading_complete
                    && $(window).scrollTop() >= ($(document).height() - $(window).height()) - 500) {
                    _this.$store.commit('SET_IS_LOADING', true);
                    _this.$store.commit('SET_CURRENCT_PAGE', _this.current_page + 1);
                    _this.$store.dispatch('GET_PRODUCTS');
                }
            };
        },
        create_uri(key, value) {
            const parameters = location.search.substr(1).split('&');

            let contain_sort_method = false, contain_view_type = false;
            parameters.forEach(parameter => {
                if( parameter.startsWith('sort_method=') )
                    contain_sort_method = true;
                if( parameter.startsWith('view_type=') )
                    contain_view_type = true;
            });
            if( !contain_sort_method ) {
                parameters.push('sort_method=' + this.sort_method);
            }
            if( !contain_view_type ) {
                parameters.push('view_type=' + this.view_type);
            }
            let return_uri = '';
            let param_arr, k, v;
            parameters.forEach(p => {
                param_arr = p.split('=');
                k = param_arr[0];
                v = param_arr[1];
                if( param_arr[0] === key ) {
                    k = key; v = value;
                }
                return_uri += '&' + k + '=' + v;
            });
            return '?' + return_uri.substr(1);
        },
        change_wish_brand(wish_place, wish_yn) {
            this.$store.commit('UPDATE_BRAND_WISH', wish_yn);
        },
        // 상품 클릭 시 Amplitude 전송
        go_item_detail(index, product) {
            fnAmplitudeEventObjectAction('click_brand_productlist_item', {
                'item_index' : index,
                'list_style' : this.view_type === 'detail' ? 'list' : 'photo',
                'sort' : amplitudeSort(this.sort_method),
                'brand_id' : this.brand_id,
                'itemid' : product.item_id,
                'category_name' : product.category_name,
                'brand_name' : product.brand_name_en
            });
        }
    }
});