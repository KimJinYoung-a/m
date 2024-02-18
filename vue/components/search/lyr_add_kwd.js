Vue.component('Add-Keyword',{
    template : `
        <!-- 이 안에서 검색 -->
        <div id="add_keyword" class="lyr_add_kwd" style="display:none;">
            <div class="inner">
                <button @click="close_add_keyword" class="btn_close"><i class="i_close"></i>닫기</button>
                <ul class="kwd_list">
                    <div class="kwd_inner">
                        <span v-for="(keyword, index) in keywords" :key="index">{{keyword}}</span>
                    </div>
                </ul>
                <p>{{number_format(result_count)}}건 안에서 다시 찾아볼게요!</p>
                <div id="searchbar2" class="srchbar_wrap">
                    <div class="srchbar input_txt">
                        <input type="search" v-model="addKeyword" title="검색어 입력" placeholder="검색어를 입력해주세요" class="srch_input" @keyup.enter="search_add_keyword" />

                        <button class="btn_del" @mousedown="delete_searched_keyword" v-if="addKeyword"><i class="i_close"></i></button>
                    </div>
                </div>
            </div>
        </div>
    `,
    props : {
        result_count : { type : Number, default : 0 }, // 검색 결과 수
        search_keyword : { type : String, default : '' }, // 검색어
    }
    , data() {return {
        addKeyword: ""
    }}
    , computed : {
        keywords() { // 띄어쓰기로 구분해서 리스트로 반환
            return this.search_keyword.split(' ');
        }
    },
    methods : {
        close_add_keyword() {
            $('.lyr_add_kwd').hide();
        },
        search_add_keyword(e) {
            const add_keyword = e.target.value.trim();
            if( add_keyword !== '' ) {
                this.$emit('search_add_keyword', encodeURIComponent(this.search_keyword + ' ' + add_keyword));
            }
        }
        , delete_searched_keyword() { // 내부 data 기존검색어 제거
            this.addKeyword = "";
            $('#searchbar2 .srch_input').focus();
        }
    }
})