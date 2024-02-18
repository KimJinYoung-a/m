Vue.component('No-Data',{
    template : `
            <div class="no_data">
                <p class="txt">
                    <template v-if="type == 'soldout'">
                        <strong>아직 판매 완료된 상품이 없어요!</strong>
                        판매 중인 상품들이 품절되기 전에 구매해보세요!<br>또 다른 상품들도 준비 중이니 많이 기대해주세요 :)                    
                    </template>
                    <template v-if="type == 'upcoming'">
                        <strong>아직 판매 예정인 상품이 없어요</strong>
                        더 좋은 상품을 선보이기 위해 준비 중이에요 :)<br>지금 판매 중인 상품도 놓치지 마세요!                    
                    </template>                    
                </p>
                <template v-if="type == 'soldout'">
                    <button class="btn_type2 btn_blk" @click="go_other('upcoming.asp')">준비 중인 상품 보러가기<i class="i_refresh2"></i></button>                
                </template>
                <template v-if="type == 'upcoming'">
                    <button class="btn_type2 btn_blk" @click="go_other('main.asp')">준비 중인 상품 보러가기<i class="i_refresh2"></i></button>                
                </template>                
            </div>  
    `
    ,
    props : {
        type : {type:String, default: 'soldout'},
    },
    methods : {
        go_other(path){
            location.href = path + location.search;
        }
    }

})