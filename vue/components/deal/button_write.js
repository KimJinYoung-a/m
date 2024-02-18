Vue.component('BUTTON-WRITE', {
    template : `
        <div class="btnAreaV16a">
            <a @click="writeReview" class="btnV16a btnRed1V16a">후기 작성하기</a>
        </div>
    `,
    props : {
        itemId : { type:Number, default:0 }, // 상품 ID
        isLogin : { type:Boolean, default:false }, // 로그인 여부
        isApp : { type:Boolean, default:false }, // App 여부
    },
    methods : {
        //region writeReview 후기 작성
        writeReview() {
            if( !this.isLogin ) {
                this.goLogin();
                return false;
            }

            const url = `/review/write/state/product/${this.itemId}`;
            getFrontApiDataV2('GET', url, null, this.successGetStateReviewWrite)
        },
        successGetStateReviewWrite(data) {
            const possibleWriteReview = data.itemId != null && (data.idx == null || data.isusing === 'Y');
            if( possibleWriteReview )
                this.moveToReviewWritePage(data);
            else
                this.alertNotAuthReviewWrite(data);
        },
        //endregion
        //region moveToReviewWritePage 후기 작성 페이지 이동
        moveToReviewWritePage(state) {
            if( state.idx != null ) {
                alert('이미 후기가 등록된 상품 입니다.수정 페이지로 이동합니다.');
            }
            AddEval(state.orderserial, this.itemId, state.itemoption, state.orderidx); // 후기 작성 이동
        },
        //endregion
        //region alertNotAuthReviewWrite 후기 작성 페이지 불가 알림 메세지 alert
        alertNotAuthReviewWrite(state) {
            if( state != null && state.idx != null && state.isusing === 'Y' ) {
                alert('삭제한 후기는 다시 작성할 수 없습니다.');
            } else {
                alert('구매하지 않은 상품 이거나 구매후 6개월이 지난 상품입니다. 상품을 구매하신 뒤 다시 상품평을 작성해주세요.');
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