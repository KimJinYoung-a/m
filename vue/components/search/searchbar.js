Vue.component('Searchbar',{
    template : /*html*/`
            <!-- 검색 바 -->
            <div id="searchbar" class="srchbar_wrap">
                <div class="srchbar input_txt">
                    <input v-show="!data_search_keyword" id="searchbar_input" v-model="new_keyword"
                        type="search" title="검색어 입력" placeholder="검색어를 입력해주세요" class="srch_input"
                        @keyup.enter="do_search(new_keyword)" @blur="blur_searchbar_input">
                    <div class="kwd_list">
                        <div @click="change_to_input" class="kwd_inner">
                            <span>
                                <em>{{data_search_keyword}}</em>
                            </span>
                        </div>
                    </div>
                    <button class="btn_del" style="display: none;" @mousedown="delete_searched_keyword"><i class="i_close"></i></button>
                    <button v-if="is_show_within_this" @click="click_search_within_this" class="btn_add_kwd">이 안에서 검색</button>
                </div>
            </div>
    `,
    data() {
        return {
            new_keyword: '', // 새로 입력한 키워드
            data_search_keyword: '', // 검색했던 키워드
            is_input_focusing: false
        }
    },
    mounted() {
        // 검색했던 키워드 내부 data에 저장 - 교정키워드가 있다면 교정키워드로 저장
        const isExistCorrectKeyword = this.correct_keyword != null && this.correct_keyword !== '';
        this.data_search_keyword = isExistCorrectKeyword ? this.correct_keyword : this.searched_keyword;
    },
    props : {
        searched_keyword : {type:String, default:''}, // 검색했던 키워드
        correct_keyword : {type:String, default:''}, // 교정 키워드
        is_show_within_this : {type:Boolean, default:true}, // 이 안에서 검색 활성화 여부
    },
    methods : {
        delete_searched_keyword(e) { // 내부 data 기존검색어 제거
            this.is_input_focusing = true;
            $('#searchbar .srch_input').val('');
            $('#searchbar .btn_del').hide();
        },
        change_to_input() { // 검색바 input으로 전환
            const keyword = this.data_search_keyword;
            $('#searchbar .kwd_list, .btn_add_kwd').hide();
            $('#searchbar .btn_del').show();
            $('#searchbar .srch_input').show();
            $('#searchbar .srch_input').val(keyword).focus();
        },
        blur_searchbar_input() { // 검색바에서 focus out 되면 원복
            if( this.is_input_focusing ) {
                this.is_input_focusing = false;
                $('#searchbar .srch_input').focus();
                return;
            }

            $('#searchbar .srch_input').hide();
            $('#searchbar .kwd_list, .btn_add_kwd').show();
            $('#searchbar .btn_del').hide();
            $('#searchbar .srch_input').val(this.data_search_keyword);
        },
        click_search_within_this() { // 이 안에서 검색 버튼 클릭
            this.$emit('click_search_within_this');
        },
        do_search(keyword) { // 검색 실행
            this.$emit('do_search', keyword);
        }
    }
})