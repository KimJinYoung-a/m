
var app = new Vue({
    el: '#app',
    store: store,
    mixins : [item_mixin, search_mixin, modal_mixin, common_mixin],
    template: /*html*/`
        <div id="content" class="content search_detail">
            <!-- 검색바 -->
            <Searchbar
                v-if="is_searched"
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
            <Quicklink :background_image="quicklink.background_image"
                :move_url="quicklink.move_url" :main_copy="quicklink.main_copy"
                :text_color="quicklink.text_color"
                :recommend_keywords="recommend_keywords" 
            />
            
            <!-- 검색 결과 구분 -->
            <Search-Category
                :search_keyword="parameter.keyword"
                :groups_count="groups_count"
                active_group="review"
            ></Search-Category>
            
            <hr class="hr_div">
            
            <!-- 정렬 바 -->
            <Sortbar
                :sort="parameter.sort_method"
                :kkomkkom_flag="false"
                :do_search_flag="false"
                search_type="review"
                @pop_sort_option="pop_sort_option"
            ></Sortbar>
            
            <!-- 검색결과 존재 -->
            <template v-if="is_searched && review_count > 0">
            
                <header class="head_type2">
                    <h2 class="ttl">{{number_format(review_count)}}건의 상품후기를<br>찾아냈어요!</h2>
                </header>
                
                <!-- 뷰 타입 탭 -->
                <Tab-View-Type
                    :view_type="parameter.view_type"
                    @change_view_type="change_view_type"
                ></Tab-View-Type>
                
                <!-- 상품후기 검색 결과 - 자세히 -->
                <Review-List-Type1
                    v-if="reviews.length > 0 && parameter.view_type == 'detail'"
                    @pop_view_this_item_reviews="pop_view_this_item_reviews"
                    @click_review="send_click_search_result_item_amplitude"
                    :isApp="isApp"
                    :search_keyword="parameter.keyword"
                    :reviews="reviews"
                ></Review-List-Type1>
                
                <!-- 상품후기 검색 결과 - 사진만 -->
                <Review-List-Type1-Photo
                    v-if="reviews.length > 0 && parameter.view_type == 'photo'"
                    @click_review="send_click_search_result_item_amplitude"
                    :isApp="isApp"
                    :search_keyword="parameter.keyword"
                    :reviews="reviews"
                ></Review-List-Type1-Photo>
                
            </template>

            <!-- 검색결과 없음 -->
            <template v-else-if="is_searched && review_count == 0">
                <Search-Result-Nodata/>
            </template>
            
            <!-- 이 안에서 검색 -->
            <Add-Keyword
                @search_add_keyword="do_search_within_this"
                :result_count="review_count"
                :search_keyword="parameter.keyword"
            ></Add-Keyword>
            
            <!-- 정렬 옵션 모달 -->
            <Modal-Sorting
                :is_groups_show="true"
                :groups_count="groups_count"
                :search_keyword="parameter.keyword"
                :sort_option="parameter.sort_method"
                search_type="review"
            ></Modal-Sorting>
            
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
                wish_type="review"
            ></Review-List-This-Item>

            <!-- 탑 버튼 -->
            <Button-Top/>
        </div>
    `,

    data() {return {
        isApp : isApp
    }},

    created() {
        this.$store.commit('SET_PARAMETER', parameter); // SET 파라미터
        this.$store.dispatch('READ_SEARCH_REVIEWS'); // READ 검색결과
    },

    mounted() {
        this.scroll(this.loading_page); // 스크롤 시 페이지 로딩

        this.send_search_amplitude(this.parameter.keyword, 'review'
            , '', this.parameter.sort_method, []
            , [], [], '', '', 1);
    },

    computed : {
        alternative_keyword() { // 대체 키워드
            return this.$store.getters.alternative_keyword;
        },
        recommend_keywords() { // 연관검색어 키워드 리스트
            return this.$store.getters.recommend_keywords;
        },
        groups_count() { // 검색구분별 검색결과 수
            return this.$store.getters.groups_count;
        },
        review_count() { // 상품후기 검색결과 수
            return this.$store.getters.review_count;
        },
        reviews() { // 상품 리스트
            return this.$store.getters.reviews;
        },
        is_searched() { // 검색 결과 불러왔는지 여부
            return this.$store.getters.is_searched;
        },
        current_page() { // 현재 페이지
            return this.$store.getters.current_page;
        },
        next_page() { // 다음 페이지
            return this.$store.getters.next_page;
        },
        parameter() { // 파라미터
            return this.$store.getters.parameter;
        },
        correct_keyword() { return this.$store.getters.correct_keyword; }, // 교정 후 검색어
        pre_correct_keyword() { return this.$store.getters.pre_correct_keyword; }, // 교정 전 검색어
        quicklink() { // 퀵링크
            return this.$store.getters.quicklink;
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
        },
        is_loading_complete() { // 페이지 로딩 종료 여부
            return this.$store.getters.is_loading_complete;
        }
    },

    methods : {
        loading_page() { // 페이지 데이터 불러옴
            const next_page = this.$store.getters.next_page;

            this.$store.commit('SET_PAGE', next_page);
            this.$store.dispatch('READ_SEARCH_REVIEWS'); // READ 검색결과

            this.send_search_amplitude(this.parameter.keyword, 'review'
                , '', this.parameter.sort_method, []
                , [], [], '', '', next_page);
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
        // click_search_result_item Amplitude전송
        send_click_search_result_item_amplitude(index, review) {
            fnAmplitudeEventObjectAction('click_search_result_item', {
                'item_index' : index + 1,
                'item_type' : 'review',
                'list_style' : this.parameter.view_type === 'detail' ? 'list' : 'photo',
                'sort' : amplitudeSort(this.parameter.sort_method),
                'keyword' : this.parameter.keyword,
                'list_type' : 'review',
                'itemid' : review.item_id,
                'category_name' : review.category_name,
                'brand_name' : review.brand_name_en
            });
        }
    }
});