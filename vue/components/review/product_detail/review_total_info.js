Vue.component('REVIEW-TOTAL-INFO', {
    template : `
        <div class="review-dashboard">
            <!-- 총 후기 수, 평균 평점 -->
            <div class="total-review ">
                <b class="headline"><strong>{{totalReviewCount}}</strong>개의 후기</b>
                <span class="icon-rating2">
                    <i :style="{width : totalReviewPoint + '%'}">
                        {{totalReviewPoint}}점
                    </i>
                </span>
            </div>

            <!-- 평균 평점, 평점별 수, 비율 -->
            <div class="rate-review overHidden">
                <b class="headline ftLt">구매자 평점<br /><strong>{{totalReviewPointAverage}}</strong></b>
                <ul class="ftRt">
                    <li v-for="group in reviewPointGroup">
                        <span>{{group.point}}점</span>
                        <span class="bar">
                            <i :style="{width : group.percent + '%'}">
                                <b>{{group.percent}}%</b>
                            </i>
                        </span>
                    </li>
                </ul>
            </div>
        </div>
    `,
    props : {
        totalReviewCount : { type:Number, default:0 }, // 후기 총 갯수
        totalReviewPointAverage : { type:Number, default:0 }, // 후기 평균 점수
        reviewPointGroup : { // 후기 점수별 정보
            point : { type:Number, default:0 },
            percent : { type:Number, default:0 }
        },
    },
    computed : {
        totalReviewPoint() { return Math.round(this.totalReviewPointAverage * 20); }, // 총 후기 점수
    }
})