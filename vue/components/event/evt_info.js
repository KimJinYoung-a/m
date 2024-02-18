Vue.component('Event-Info',{
    template : '\
                <!-- 이벤트 정보 -->\
                <div class="evt_info">\
                    <div class="evt_name" v-html="evt_name"></div>\
                    <div class="evt_bnfit">\
                        <span v-if="discount" class="discount">{{discount}}</span>\
                        <div class="evt_badge">\
                            <span v-if="badge1" class="badge_type1">{{badge1}}</span>\
                            <span v-if="badge2" class="badge_type2">{{badge2}}</span>\
                        </div>\
                    </div>\
                </div>\
    ',
    props : {
        evt_name: String, // 이벤트 명
        discount: String, // 세일or쿠폰 텍스트
        badge1: String, // 뱃지1
        badge2: String // 뱃지2
    }
})