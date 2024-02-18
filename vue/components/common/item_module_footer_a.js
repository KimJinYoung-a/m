Vue.component('Item-Module-Footer-A',{
    template : '\
            <!-- 아이템 모듈 푸터 A태그 -->\
            <div class="sect_foot">\
                <a :href="move_url" class="btn_more">{{text}}<i class="i_arw_r2"></i></a>\
            </div>\
    ',
    props : {
        move_url : String,
        text : String
    }
})