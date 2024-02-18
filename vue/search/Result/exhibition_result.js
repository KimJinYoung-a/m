
var app = new Vue({
    el: '#app',
    store: store,
    mixins : [search_mixin, modal_mixin],
    template: `
        <div id="content" class="content search_detail">
            <!-- 검색바 -->
            <Searchbar
                v-if="is_searched"
                :searched_keyword="parameter.keyword"
                :correct_keyword="correct_keyword"
                :alternative_keyword="alternative_keyword"
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
                :text_color="quicklink.text_color" />
            
            <!-- 검색 결과 구분 -->
            <Search-Category
                :search_keyword="parameter.keyword"
                :groups_count="groups_count"
                active_group="exhibition"
            ></Search-Category>
            
            <hr class="hr_div">
            
            <!-- 정렬 바 -->
            <Sortbar
                :sort="parameter.sort_method"
                :kkomkkom_flag="false"
                :do_search_flag="false"
                search_type="exhibition"
            ></Sortbar>
            
            <!-- 검색결과 존재 -->
            <template v-if="is_searched && exhibition_count > 0">
                <header class="head_type2">
                    <h2 class="ttl">{{number_format(exhibition_count)}}건의 기획전을<br>찾아냈어요!</h2>
                </header>
                
                <!-- 기획전 검색 결과 -->
                <Event-List-Md
                    v-if="exhibitions.length > 0"
                    @click_exhibition="send_click_search_result_item_amplitude"
                    :exhibitions="exhibitions"
                ></Event-List-Md>
                
            </template>

            <!-- 검색결과 없음 -->
            <template v-else-if="is_searched && exhibition_count == 0">
                <Search-Result-Nodata/>
            </template>
            
            <!-- 이 안에서 검색 -->
            <Add-Keyword
                @search_add_keyword="do_search_within_this"
                :result_count="exhibition_count"
                :search_keyword="parameter.keyword"
            ></Add-Keyword>
            
            <!-- 정렬 옵션 모달 -->
            <Modal-Sorting
                :is_groups_show="true"
                :groups_count="groups_count"
                :search_keyword="parameter.keyword"
                :sort_option="parameter.sort_method"
                search_type="exhibition"
            ></Modal-Sorting>

            <!-- 탑 버튼 -->
            <Button-Top/>
            
        </div>
    </div>
    `,

    created() {
        this.$store.commit('SET_PARAMETER', parameter); // SET 파라미터
        this.$store.dispatch('READ_SEARCH_EXHIBITIONS'); // READ 검색결과
    },

    mounted() {
        this.scroll(this.loading_page); // 스크롤 시 페이지 로딩

        this.send_search_amplitude(this.parameter.keyword, 'event'
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
        exhibition_count() { // 기획전 검색결과 수
            return this.$store.getters.exhibition_count;
        },
        exhibitions() { // 기획전 리스트
            return this.$store.getters.exhibitions;
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
        is_loading_complete() { // 페이지 로딩 종료 여부
            return this.$store.getters.is_loading_complete;
        }
    },

    methods : {
        loading_page() { // 페이지 데이터 불러옴
            const next_page = this.$store.getters.next_page;

            this.$store.commit('SET_PAGE', next_page);
            this.$store.dispatch('READ_SEARCH_EXHIBITIONS'); // READ 검색결과

            this.send_search_amplitude(this.parameter.keyword, 'event'
                , '', this.parameter.sort_method, []
                , [], [], '', '', next_page);
        },
        // click_search_result_item Amplitude전송
        send_click_search_result_item_amplitude(index, exhibition) {
            fnAmplitudeEventObjectAction('click_search_result_item', {
                'item_index' : index + 1,
                'item_type' : 'planning',
                'sort' : amplitudeSort(this.parameter.sort_method),
                'keyword' : this.parameter.keyword,
                'list_type' : 'planning'
            });
        }
    }
});