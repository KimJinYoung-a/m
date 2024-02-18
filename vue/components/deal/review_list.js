Vue.component('REVIEW-LIST', {
    template: `
        <div class="postContV16a">
            <ul class="postListV16a">
                <REVIEW v-for="review in reviews" :key="review.index" :review="review" :isLogin="isLogin" :isApp="isApp"
                    @report="report" @cancelReport="cancelReport"/>
            </ul>
            <div v-if="reviews.length === 5" class="btnAreaV16a">
                <p><button @click="popViewAll" type="button" class="btnV16a btnRed1V16a">전체보기</button></p>
            </div>
        </div>
    `,
    props : {
        itemId : { type:Number, default:0 }, // 상품 ID
        reviewType : { type:String, default:'a' }, // 후기구분
        reviews : { type:Array, default:() => [] }, // 후기 리스트
        isLogin : { type:Boolean, default:false }, // 로그인 여부
        isApp : { type:Boolean, default:false }, // APP 여부
    },
    methods : {
        //region popViewAll 전체보기 팝업
        popViewAll() {
            let url = `/pop_ItemEvalList.asp?itemid=${this.itemId}`;
            if( this.reviewType === 'p' )
                url += '&sortMtd=ph';

            if( this.isApp )
                fnAPPpopupBrowserURL('상품후기', mUrl + '/apps/appcom/wish/web2014/category' + url);
            else
                fnOpenModal('/deal' + url);
        },
        //endregion
        //region report 신고하기
        report(review) {
            this.$emit('report', review);
        },
        //endregion
        //region cancelReport 신고 취소 하기
        cancelReport(reviewIndex, reportCount) {
            this.$emit('cancelReport', reviewIndex, reportCount);
        },
        //endregion
    }
});