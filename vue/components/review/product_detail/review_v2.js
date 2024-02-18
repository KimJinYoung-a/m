Vue.component('REVIEW', {
    template : `
        <li :class="['review-info', {'blind-conts' : review.reportType === 2 || review.reportCount >=10}]">
            <div v-if="review.reportType === 2" class="bg-blind block">
                차단된 작성자의 후기입니다
                <button @click="cancelReportReview" type="button">차단 해제하기</button>
            </div>
            <div v-else-if="review.reportCount >= 10" class="bg-blind">여러 명의 신고로 가려진 후기입니다</div>
            <template v-else>
                <div class="writer">
                    <span :class="['thumb', getUserLevelClass(review.userLevel)]">{{getUserLevelClass(review.userLevel)}}등급</span>
                    <span>{{review.userId}}</span>
                </div>
                <div class="review-conts">
                    <div class="items review"><span class="icon icon-rating"><i :style="{width : review.point + '%'}"></i></span></div>
                    <div v-if="review.productOption" class="purchaseOption"><em><strong>구매옵션</strong> : {{review.productOption}}</em></div>
                    <div v-html="convertedEnterContent"></div>
                        <div :class="photoClass">
                            <a @click="openReviewDetail">
                                <span v-for="image in review.images">
                                    <i :style="{'background-image' : 'url(' + decodeBase64(image) + ')'}"></i>
                                </span>
                            </a>
                        </div>
                    <p class="date">{{review.regDate}}</p>
                    <button v-if="review.reportType == 0" @click="reportReview(review)" type="button" class="btn-Declaration">신고/차단하기</button>
                    <button v-else @click="cancelReportReview" type="button" class="btn-Declaration">신고 취소</button>
                    <div v-show="showReportAlert" class="alert"><span>신고 10회 누적 시 내용이 가려집니다</span></div>
                </div>
            </template>
        </li>
    `,
    data() {return {
        showReportAlert : false
    }},
    props : {
        review : { type:Object, default:() =>{return {}} },
        isLogin : { type:Boolean, default:false }, // 로그인 여부
        isApp : { type:Boolean, default:false }, // App 여부
    },
    computed : {
        //region convertedEnterContent \r\n => <br> 후기 내용
        convertedEnterContent() {
            return this.review.content.replace(/(\n|\r\n)/g, '<br>');
        },
        //endregion
        //region photoClass 사진 영역 클래스
        photoClass() {
            const photoClass = ['photo'];
            if( this.review.images.length === 3 )
                photoClass.push('photo-3');
            else if( this.review.images.length === 2 )
                photoClass.push('photo-2');
            return photoClass;
        },
        //endregion
    },
    methods : {
        //region getUserLevelClass GET 유저 등급 클래스명
        getUserLevelClass(userLevel) {
            switch(userLevel) {
                case 1: return "red";
                case 2: return "vip";
                case 3: return "vipgold";
                case 4:
                case 6:
                case 7:
                    return "vvip";
                default:
                    return "white";
            }
        },
        //endregion
        //region openReviewDetail 후기 상세 열기
        openReviewDetail() {
            this.$emit('openReviewDetail', this.review.index);
        },
        //endregion
        //region decodeBase64 Base64 디코딩
        decodeBase64(str) {
            return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
        },
        //endregion
        //region reportReview 후기 신고
        reportReview(review) {
            if( !this.isLogin ) {
                this.goLogin();
                return false;
            }

            this.$emit('report', review);
        },
        //endregion
        //region cancelReportReview 후기 신고 취소
        cancelReportReview() {
            if( !this.isLogin ) {
                this.goLogin();
                return false;
            }

            const confirmMessage = this.review.reportType === 1 ? '신고를 취소하시겠어요?' : '차단을 해제하시겠어요?';
            if( !confirm(confirmMessage) )
                return false;

            const url = `/review/${this.review.index}/type/${this.review.type}/report/cancel`;
            getFrontApiDataV2('POST', url, null, this.successCancelReportReview, this.errorReportReview);
        },
        successCancelReportReview(count) {
            this.$emit('cancelReport', this.review.index, count);
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
    },
    watch : {
        //region review.reportType 신고했을 때 토스트 메세지 띄움
        'review.reportType'(type) {
            if( type === 1 ) {
                this.showReportAlert = true;
                setTimeout(() => this.showReportAlert = false, 5000);
            }
        },
        //endregion
    },
});