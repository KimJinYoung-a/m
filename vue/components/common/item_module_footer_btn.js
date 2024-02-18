Vue.component('Item-Module-Footer-Button',{
    template : '\
            <!-- 아이템 모듈 푸터 버튼 태그 -->\
            <div class="sect_foot">\
                <button @click="click_item_module_footer_btn" type="button" class="btn_more type1">{{text}}</button>\
            </div>\
    ',
    props : {
        text : String
    },
    methods : {
        click_item_module_footer_btn : function () {
            this.$emit('click_item_module_footer_btn');
        }
    }
})