Vue.component('TAB-REVIEW-TYPE', {
    template : `
        <div class="bxWt1V16a">
            <ul class="btnBarV16a">
                <li :class="{current : reviewType === 'a'}" style="width:50%;">
                    <div>
                        <a @click="$emit('changeReviewType', 'a')">
                            상품후기<span>({{numberFormat(productReviewTypeCount.total)}}/{{numberFormat(totalCount)}})</span>
                        </a>
                    </div>
                </li>
                <li :class="{current : reviewType === 'p'}" style="width:50%;">
                    <div>
                        <a @click="$emit('changeReviewType', 'p')">
                            포토후기<span>({{numberFormat(productReviewTypeCount.photo)}})</span>
                        </a>
                    </div>
                </li>
            </ul>
        </div>
    `,
    props : {
        reviewType : { type:String, default:'a' }, // 후기 구분
        totalCount : { type:Number, default:0 }, // 총 후기 갯수
        productReviewTypeCount : {
            total : { type:Number, default:0 }, // 상품 총 후기 갯수
            photo : { type:Number, default:0 }, // 상품 포토 후기 갯수
        },
    },
    methods : {
        //region numberFormat 숫자 포맷
        numberFormat(num){
            num = num.toString();
            return num.replace(/(\d)(?=(?:\d{3})+(?!\d))/g,'$1,');
        },
        //endregion
    }
});