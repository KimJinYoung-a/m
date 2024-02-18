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
                    <div class="modal_cont pt0">
                        <div class="modal_profile" v-if="writeUserProfile.userId">
                            <div class="pro_image">
                            <img :src="writeUserProfile.profileImage"/>
                            </div>
                            <p class="level">{{writeUserProfile.levelName}}</p>
                            <p class="name">{{writeUserProfile.userId}}</p>
                        </div>
                        
                        <div class="review-block">
                            <button @click="reportType = 3" :class="{on : reportType === 3}" type="button">
                                <div class="radio"></div>
                                <div class="txt">
                                    <h3>불량 작성자 신고하기</h3>
                                    <p>접수된 신고 사유를 통해 불량 작성자로 확인될 경우<br/>해당 작성자의 모든 후기가 즉시 제거됩니다.</p>
                                </div>
                            </button>
                            <div v-if="reportType === 3" class="input-area">
                                <textarea @input="inputContents" type="text" :placeholder="reportContentsPlaceHolder">{{contents}}</textarea>
                                <span class="count">{{contents.length}}/30</span>
                            </div>
                            
                            <button @click="reportType = 1" :class="{on : reportType === 1}" type="button">
                                <div class="radio"></div>
                                <div class="txt">
                                    <h3>후기 신고하기</h3>
                                    <p>부적합한 후기일 경우 선택해주세요.<br/>신고가 10회 누적될 경우 내용이 가려집니다.</p>
                                </div>
                            </button>
                            <div v-if="reportType === 1" class="input-area">
                                <textarea @input="inputContents" type="text" :placeholder="reportContentsPlaceHolder">{{contents}}</textarea>
                                <span class="count">{{contents.length}}/30</span>
                            </div>
                            
                            <button @click="reportType = 2" :class="{on : reportType === 2}" type="button">
                                <div class="radio"></div>
                                <div class="txt">
                                    <h3>작성자의 후기 차단하기</h3>
                                    <p>부적절한 작성자일 경우 선택해주세요.<br/>해당 작성자의 후기가 즉시 차단됩니다.</p>
                                </div>
                            </button>
                            <div v-if="reportType === 2" class="input-area">
                                <textarea @input="inputContents" type="text" :placeholder="blockContentsPlaceHolder">{{contents}}</textarea>
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
        reportType : 3, // 신고 유형(1:신고, 2:차단)
        contents : '', // 기타 사유
        reportContentsPlaceHolder : '신고 사유를 입력해주세요. 자세한 내용은 신고 처리에 큰 도움이 됩니다.(선택사항)',
        blockContentsPlaceHolder : '차단 사유를 입력해주세요.(선택사항)',
        writeUserProfile : {}, // 작성 유저 프로필
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
            let confirmMessage;
            if( this.reportType === 1 )
                confirmMessage = '후기를 신고하시겠어요?';
            else if( this.reportType === 2 )
                confirmMessage = '후기를 차단하시겠어요?';
            else
                confirmMessage = '작성자를 신고하시겠어요?';

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
            let alertMessage;
            if( this.reportType === 2 )
                alertMessage = '차단이 완료되었습니다.';
            else
                alertMessage = '신고가 완료되었습니다.';

            alert(alertMessage);

            this.clearContents();
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
            this.clearContents();
            this.$emit('close');
        },
        //endregion
        //region clearContents 컨텐츠 초기화
        clearContents() {
            this.contents = '';
            this.$el.querySelector('textarea').value = '';
        },
        //endregion
        //region getWriteUserProfile 작성자 프로필 조회
        getWriteUserProfile(index) {
            getFrontApiDataV2('GET', '/review/write/user/profile', {reviewIdx : index},
                data => this.writeUserProfile = data);
        },
        //endregion
    },
    watch : {
        //region review 모달 열릴 때 마다 후기 작성자 프로필 조회
        review(review) {
            if( review != null ) {
                this.getWriteUserProfile(review.index);
            }
        },
        //endregion
        //region reportType 신고구분값 바뀔 때 마다 내용 초기화, focus
        reportType() {
            this.clearContents();
            setTimeout(this.$el.querySelector('textarea').focus(), 200);
        },
        //endregion
    }
})