// 오타 교정
Vue.component('Correct-Typos',{
    template : `
        <div v-if="correct_keyword" class="kwd_typo_wrap">
            <p class="kwd_typo"><em>{{correct_keyword}}</em>{{postPosition(correct_keyword)}} 교정된 검색 결과에요</p>
            <p @click="moveIgnoreCorrect" class="kwd_typo_before"><em>{{pre_correct_keyword}}</em>{{postPosition(pre_correct_keyword)}} 검색할게요</p>
        </div>
    `,
    props : {
        correct_keyword : {type:String, default:''}, // 교정 후 검색어
        pre_correct_keyword : {type:String, default:''}, // 교정 전 검색어
    },
    methods : {
        // 후치사 (~로, ~으로)
        postPosition(keyword) {
            if( keyword == null || keyword.trim() === '' )
                return '으로';

            const last_char = keyword.charAt(keyword.length - 1);
            if( !this.isHangulChar(last_char) )
                return '으로';

            return this.getFinalSound(last_char).charCodeAt(0).toString(16) === '11a7' ? '로' : '으로';
        },
        // 한글 여부
        isHangulChar(ch) {
            const c = ch.charCodeAt(0);
            return (0x1100<=c && c<=0x11FF) || (0x3130<=c && c<=0x318F) || (0xAC00<=c && c<=0xD7A3);
        },
        // get 종성
        getFinalSound(a) {
            const r = (a.charCodeAt(0) - parseInt('0xac00',16)) % 28;
            const t = String.fromCharCode(r + parseInt('0x11A8') -1);
            return t;
        },
        // 교정무시 이동
        moveIgnoreCorrect() {
            this.$emit('moveIgnoreCorrect');
        }
    }
});