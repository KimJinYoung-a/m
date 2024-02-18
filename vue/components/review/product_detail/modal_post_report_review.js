Vue.component('MODAL-POST-REPORT-REVIEW', {
    template : `
        <div :class="['modalV20', 'modal_type4', 'modal_SimpleMember', {show:isShow}]">
            <div class="modal_overlay" @click="close"></div>
            <div class="modal_wrap">
                <div class="modal_header">
                    <h2>모달</h2>
                    <button class="btn_close" @click="close"><i class="i_close"></i>모달닫기</button>
                </div>
                <div class="modal_body">
                    <div class="modal_cont">
                        <div class="review-block">
                            <button @click="reportType = 1" :class="{on : reportType === 1}" type="button">
                                <div class="radio"></div>
                                <div class="txt">
                                    <h3>후기 신고하기</h3>
                                    <p>부적합한 후기일 경우 선택해주세요.<br/>신고가 10회 누적될 경우 내용이 가려집니다.</p>
                                </div>
                            </button>
                            <button @click="reportType = 2" :class="{on : reportType === 2}" type="button">
                                <div class="radio"></div>
                                <div class="txt">
                                    <h3>작성자의 후기 차단하기</h3>
                                    <p>부적절한 작성자일 경우 선택해주세요.<br/>해당 작성자의 후기가 즉시 차단됩니다.</p>
                                </div>
                            </button>
                            <div class="input-area">
                                <input @input="inputContents" :value="contents" type="text" placeholder="기타 다른 사유가 있다면 입력해주세요(선택사항)">
                                <span class="count">{{contents.length}}/30</span>
                            </div>
                        </div>
                    </div>
                    <div class="btn_block">
                        <button @click="report" class="btn_ten">확인</button>
                    </div>
                </div>
            </div>
        </div>
    `,
    data() {return {
        reportType : 1, // 신고 유형(1:신고, 2:차단)
        contents : '', // 기타 사유
    }},
    props : {
        review : { type:Object, default:function() {return {};} },
        isShow : { type:Boolean, default:false },
        isLogin : { type:Boolean, default:false }, // 로그인 여부
        isApp : { type:Boolean, default:false }, // App 여부
    },
    methods : {
        //region inputContents 기타 사유 입력
        inputContents(e) {
            const value = e.target.value;
            this.contents = value.length > 30 ? value.substr(0, 30) : value;
            e.target.value = this.contents;
        },
        //endregion
        //region report 신고하기
        report() {
            const confirmMessage = this.reportType === 1 ? '후기를 신고하시겠어요?' : '후기를 차단하시겠어요?';
            if( !confirm(confirmMessage) )
                return false;

            const url = `/review/report`;
            const data = {
                reviewIdx : this.review.index,
                reviewType : this.review.type,
                reportType : this.reportType,
                contents : this.contents
            };
            getFrontApiDataV2('POST', url, data, this.successReportReview, this.errorReportReview);
        },
        successReportReview(count) {
            alert((this.reportType === 1 ? '신고가' : '차단이') + ' 완료되었습니다.');
            this.$emit('report', this.reportType, count);
        },
        errorReportReview(e) {
            const error = JSON.parse(e.responseText);
            if( error.code === -10 ) {
                this.goLogin();
                return false;
            } else if( error.message ) {
                alert(error.message);
            } else {
                alert('서버 처리중 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요');
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
        //region close 모달 닫기
        close() {
            this.contents = '';
            this.$emit('close');
        },
        //endregion
    }
})