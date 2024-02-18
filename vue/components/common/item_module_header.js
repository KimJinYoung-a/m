Vue.component('Item-Module-Header',{
    template : `
            <!-- 아이템 모듈 헤더 -->
            <header class="head_type1">
                <a v-if="move_url" :href="move_url">
                    <span v-if="top_text" class="txt">{{top_text}}</span>
                    <h2 v-if="bottom_text" class="ttl">{{bottom_text}}<i class="i_arw_r2"></i></h2>
                </a>
                <template v-else>
                    <span v-if="top_text" class="txt">{{top_text}}</span>
                    <h2 v-if="bottom_text" class="ttl">{{bottom_text}}</h2>
                </template>
            </header>
    `,
    props : {
        move_url : {type:String, default:''}, // 이동할 URL
        top_text : {type:String, default:''}, // 위 텍스트
        bottom_text : {type:String, default:''} // 아래 텍스트
    }
})