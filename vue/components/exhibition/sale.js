Vue.component('Exhibition-Sale',{
    template : '\
                <!-- 기획전 리스트 기획전 할인 영역 -->\
                <span class="discount">{{value}}</span>\
    ',
    props : {
        value : String
    }
})