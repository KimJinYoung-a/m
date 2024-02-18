Vue.component('REVIEW', {
    template : `
        <li :class="{'blind-conts' : review.reportType === 2 || review.reportCount >=10}">
            <div v-if="review.reportType === 2" class="bg-blind block">
                차단된 작성자의 후기입니다
                <button @click="cancelReport" type="button">차단 해제하기</button>
            </div>
            <div v-else-if="review.reportCount >= 10" class="bg-blind">여러 명의 신고로 가려진 후기입니다</div>
            <template v-else>
                <div class="items review">
                    <span class="icon icon-rating">
                        <i :style="{width : review.point + '%'}">리뷰 별점 {{review.point}}점</i>
                    </span>
                    <p class="writer">{{review.userId}} / {{review.regDate}}</p>
                </div>
                <div v-if="review.productOption" class="purchaseOption"><em><strong>구매옵션</strong> : {{review.productOption}}</em></div>
                <div>{{review.content}}</div>
                <p v-if="decodeBase64Image" class="photo">
                    <img :src="decodeBase64Image" alt=""/>
                </p>
                <button v-if="review.reportType == 0" @click="report" type="button" class="btn-Declaration">신고/차단하기</button>
                <button v-else @click="cancelReport" type="button" class="btn-Declaration">신고 취소</button>
                <div v-show="showReportAlert" class="alert"><span>신고 10회 누적 시 내용이 가려집니다</span></div>
            </template>
        </li>
    `,
    data() {return {
        showReportAlert : false, // 신고 alert 노출 여부
    }},
    props : {
        isLogin : { type:Boolean, default:false }, // 로그인 여부
        isApp : { type:Boolean, default:false }, // APP 여부
        //region review 후기
        review : {
            index : { type:Number, default:0 },
            userId : { type:String, default:'' },
            content : { type:String, default:'' },
            productOption : { type:String, default:'' },
            point : { type:Number, default:0 },
            regDate : { type:String, default:'' },
            reportCount : { type:Number, default:0 },
            reportType : { type:Number, default:0 },
            images : { type:Array, default:() => [] },
        },
        //endregion
    },
    computed : {
        decodeBase64Image() {
            if (this.review.images && this.review.images.length > 0)
                return atob(this.review.images[0].replace(/_/g, '/').replace(/-/g, '+'));
        },
    },
    methods : {
        //region report 신고하기
        report() {
            if( !this.isLogin )
                this.goLogin();
            else
                this.$emit('report', this.review);
        },
        //endregion
        //region cancelReport 신고 취소
        cancelReport() {
            if( !this.isLogin ) {
                this.goLogin();
            } else {
                const confirmMessage = this.review.reportType === 1 ? '신고를 취소하시겠어요?' : '차단을 해제하시겠어요?';
                if( confirm(confirmMessage) )
                    getFrontApiDataV2('POST', `/review/${this.review.index}/type/${this.review.type}/report/cancel`,
                        null, count => this.$emit('cancelReport', this.review.index, count));
            }
        },
        //endregion
        //region goLogin 로그인 페이지 이동
        goLogin() {
            if( confirm("로그인이 필요한 서비스 입니다. 로그인 하시겠습니까?") ) {
                if( this.isApp )
                    calllogin();
                else
                    location.href = '/login/login.asp?backpath=' + location.pathname + location.search;
            }
        },
        //endregion
    }
});