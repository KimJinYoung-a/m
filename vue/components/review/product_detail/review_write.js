Vue.component('REVIEW-WRITE', {
    template : `
        <div class="btn-areaV19">
            <p>후기 작성시, 현금처럼 쓸 수 있는 <em class="color-red">100p</em>를 드립니다.</p>
            <a @click="clickWriteReviewButton" :class="['btn', 'btn-large', possibleWriteReview ? 'btn-red' : 'btn-grey']">후기 작성하기</a>
        </div>
    `,
    props : {
        itemId : { type:Number, default:0 }, // 상품ID
        // region stateProductReviewWrite 후기 작성 가능 여부
        stateProductReviewWrite : {
            idx : { type:Number, default:0 }, // 후기 인덱스
            isusing : { type:String, default:'' }, // 후기 사용여부
            itemid : { type:Number, default:0 }, // 상품ID
            itemoption : { type:String, default:'' }, // 상품옵션코드
            orderidx : { type:Number, default:0 }, // 오프샵 주문디테일 고유번호
            orderserial : { type:String, default:'' }, // 주문번호
        },
        // endregion
    },
    computed : {
        possibleWriteReview() { // 후기 작성 가능 여부
            return this.stateProductReviewWrite != null
                && (this.stateProductReviewWrite.idx == null || this.stateProductReviewWrite.isusing === 'Y');
        },
    },
    methods : {
        //region clickWriteReviewButton 후기 쓰기
        clickWriteReviewButton() {
            const state = this.stateProductReviewWrite;
            if( this.possibleWriteReview )
                this.moveToReviewWritePage(state);
            else
                this.alertNotAuthReviewWrite(state);
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
    }
});