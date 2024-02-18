/* 
    평점 : 4점(80%) 이상일 경우 노출
      ㄴ 5점만점으로 API에서 내려줘서 width값으로 넣어주기위해 100점만점으로 변경해서 style bind
    상품평 : 평점 있을 경우 && 상품평 5개 이상일 경우 노출
*/
Vue.component('Product-Evaluate',{
    template : `<div v-if="cal_review_rating > 79" class="user_side">
                    <span class="user_eval"><dfn>평점</dfn><i v-bind:style="{width : cal_review_rating +\'%\'}"></i></span>
                    <span class="user_comment" v-if="cal_review_rating > 79 && review_cnt > 4"><dfn>상품평</dfn>{{number_format(review_cnt)}}</span>
                </div>`,
    props : {
        review_cnt: { type: Number, default: 0 }, // 후기 갯수
        review_rating : { type : Number, default : 0 }, // 후기 점수
    },
    computed : {
        cal_review_rating() { // 5점만점 -> 100점만점
            return this.review_rating * 20;
        }
    }
})