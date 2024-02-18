Vue.component('Product-Badge',{
    template : `<div v-if="badge1 || badge2" class="prd_badge">
                    <span class="badge_type1" v-if="badge1">{{badge1}}</span>
                    <span class="badge_type2" v-if="badge2">{{badge2}}</span>
                </div>`,
    props : {
        badge1 : { type : String, default : '' }, // 뱃지1
        badge2 : { type : String, default : '' }, // 뱃지2
    }
})