Vue.component('Exhibition-Name',{
    template : '\
                <!-- 기획전 리스트 기획전 명 영역 -->\
                <div class="evt_name">{{name}}</div>\
    ',
    props : {
        name : String
    }
})