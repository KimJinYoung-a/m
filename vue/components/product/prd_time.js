/*
    클리어런스 상품 : 판매로부터 시간 표시 (label_time)
*/
Vue.component('Product-Time',{
    template : `<div class="label_time" v-if="sell_minute > 0">{{sell_minute}}분 전</div>`,
    props : {
        sell_minute : { type : Number, default : 0 },
    }
})