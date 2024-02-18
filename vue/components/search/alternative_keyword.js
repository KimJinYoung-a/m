Vue.component('Alternative-Keyword',{
    template : /*html*/`
        <!-- 대체 검색어 -->
        <p v-show="alternative_keyword" @click="move_search_result(alternative_keyword)" class="kwd_alter">
            혹시<em>{{alternative_keyword}}</em>찾으셨나요?
            <i class="i_arw_r2"></i>
        </p>
    `,
    props : {
        alternative_keyword : {type:String, default:''}, // 대체검색어
    }
});