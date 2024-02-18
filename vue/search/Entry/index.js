
var app = new Vue({
    el: '#app',
    store: store,
    mixins: [search_mixin],
    template: `
			<div>
				<div class="srchbar_wrap">
                    <div class="srchbar input_txt">
                        <input type="search" title="검색어 입력" placeholder="검색어를 입력해주세요" class="srch_input"
                            :value="keyword" @input="update_keyword" @keyup.enter="move_search_result(keyword)">
                    </div>
                </div>
                
                <!-- 자동완성 -->
                <div v-show="keyword && auto_keywords.length > 0" class="srch_kwd_list type3">
                    <h2>혹시 이런걸 찾고 있나요?</h2>
                    <ul>
                        <li v-for="(k, index) in auto_keywords" :key="index">
                            <a @click="move_search_result(k)" v-html="k"></a>
                        </li>
                    </ul>
                </div>
                
                <!-- 최근 검색어 -->
                <div v-show="!keyword && recent_keywords.length > 0" class="srch_kwd_list type1" id="srch_rcnt">
                    <h2>최근 검색어</h2>
                    <ul>
                        <li v-for="(k, index) in recent_keywords" :key="index">
                            <a @click="move_search_result(k)">{{k}}</a>
                        </li>
                    </ul>
                    <button @click="delete_recent_keywords" class="btn_reset">모두 지우기</button>
                </div>
                
                <!-- 인기검색어 -->
                <div v-show="!keyword && best_keywords.length > 0" class="srch_kwd_list type2" id="srch_pop">
                    <h2>많이 찾고 있어요 👀</h2>
                    <ul>
                        <li v-for="(k, index) in best_keywords" :key="index">
                            <a @click="move_search_result(k.keyword)">{{k.keyword}}</a>
                            <span v-if="k.tag" class="label">{{k.tag}}</span>
                        </li>
                    </ul>
                </div>
			</div>
    `,

    created() {
        this.$store.dispatch('READ_BEST_KEYWORDS'); // READ 인기검색어
        this.$store.commit('SET_RECENT_KEYWORDS', tenRecentKeywords); // 최근검색어 store 저장
    },

    computed : {
        keyword() { // 입력 키워드
            return this.$store.getters.keyword;
        },
        best_keywords() { // 인기 검색어 리스트
            return this.$store.getters.best_keywords;
        },
        auto_keywords() { // 자동완성 키워드 리스트
            const temp_auto_keywords = this.$store.getters.auto_keywords;
            let auto_keywords = [];
            if( temp_auto_keywords != null && temp_auto_keywords.length > 0 ) {
                for( let i=0 ; i<temp_auto_keywords.length ; i++ ) {
                    // 일치하는 문자 <b>태그 처리
                    auto_keywords.push(temp_auto_keywords[i].keyword.replaceAll(this.keyword, `<b>${this.keyword}</b>`));
                }
            }
            return auto_keywords;
        },
        recent_keywords() { // 최근검색어 리스트
            return this.$store.getters.recent_keywords;
        }
    },

    methods : {
        move_search_result : function(keyword) { // 검색결과 페이지 이동
            if( keyword.trim() !== '' ) {
                keyword = keyword.replace(/(<([^>]+)>)/ig,'');
                location.href = './search_product2020.asp?keyword=' + keyword;
            }
        },
        update_keyword(e) { // 키워드 수정
            this.$store.commit('UPDATE_KEYWORD', e.target.value);
            this.$store.dispatch('READ_AUTO_KEYWORDS');
        },
        delete_recent_keywords() {
            this.$store.commit('DELETE_RECENT_KEYWORDS');
            $.ajax({
                type: "GET",
                url: "/search/delete_recent_keywords.asp"
            })
        }
    }
});