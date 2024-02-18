/*
    베스트 상품 : 순위 표시 (label_rank)
*/
Vue.component('Product-Rank',{
    template : `<div class="label_rank" v-if="item_rank > 0"><span class="num">{{item_rank}}</span><span class="blind">위</span></div>`,
    props : {
        item_rank : { type : Number, default : 0 },
    }
})