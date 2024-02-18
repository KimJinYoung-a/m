Vue.component('Exhibition-Badge1',{
    template : '\
                <!-- 기획전 리스트 기획전 뱃지1 영역 -->\
                <span class="badge_type1">{{value}}</span>\
    ',
    props : {
        value : String
    }
})