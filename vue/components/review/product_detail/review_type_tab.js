Vue.component('REVIEW-TYPE-TAB', {
    template : `
        <div class="bxWt1V16a">
            <ul class="btnBarV16a">
                <li :style="{width : (existOffShopReviews ? 34 : 50) + '%'}" @click="$emit('changeReviewType', 'a')"
                    :class="{'current' : reviewParameter.reviewType === 'a'}" name="cmtTab01">
                    <div>
                        {{isTicketItem ? '후기' : '전체'}}
                        <span >{{numberFormat(reviewCountGroup.total)}}</span>
                    </div>
                </li>
                <li :style="{width : (existOffShopReviews ? 33 : 50) + '%'}" @click="$emit('changeReviewType', 'p')"
                    :class="{'current' : reviewParameter.reviewType === 'p'}" name="cmtTab02">
                    <div>사진후기<span>{{numberFormat(reviewCountGroup.photo)}}</span></div>
                </li>
                <li v-if="existOffShopReviews" style="width:33%;" @click="$emit('changeReviewType', 'o')"
                    :class="{'current' : reviewParameter.reviewType === 'o'}" name="cmtTab03">
                    <div>매장후기<span>{{numberFormat(reviewCountGroup.offline)}}</span></div>
                </li>
            </ul>
        </div>
    `,
    props : {
        existOffShopReviews : { type:Boolean, default:false }, // 오프라인 후기 존재 여부
        isTicketItem : { type:Boolean, default:false }, // 티켓 상품 여부
        //region reviewParameter 후기 파라미터
        reviewParameter : {
            page : { type:Number, default:1 }, // 현재 후기 페이지
            pageSize : { type:Number, default:1 }, // 페이지 별 노출 후기 수
            productOptionCode : { type:String, default:'' }, // 페이지 별 노출 후기 수
            reviewType : { type:String, default:'a' }, // 후기 유형
            sortMethod : { type:String, default:'ne' }, // 후기 정렬 기준
        },
        //endregion
        //region reviewCountGroup 유형별 후기 갯수
        reviewCountGroup : {
            total : { type:Number, default:0 },
            offline : { type:Number, default:0 },
            photo : { type:Number, default:0 },
        },
        //endregion
    },
    methods : {
        //region numberFormat 숫자 format
        numberFormat(number) {
            if( number == null || isNaN(number) )
                return '0';
            else
                return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        },
        //endregion
    }
});