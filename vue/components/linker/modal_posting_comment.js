Vue.component('MODAL-POSTING-COMMENT', {
    template : `
        <div class="comment_list">
            <template v-if="!comment.blocked">
                <div class="login_profile">
                    <div class="login_info_area">
                        <div class="img"><img :src="comment.creatorThumbnail"></div>
                        <div class="info">
                            <p class="txt">{{filterCreatorDescription(comment.creatorDescription)}}</p>
                            <p class="id">{{comment.creatorNickname}}</p>
                        </div>
                    </div>
                    <button v-if="comment.creator" @click="deleteComment(comment.commentIndex)" type="button" class="btn_co_delete">삭제</button>
                    <button v-else @click="clickReportComment(comment)" type="button" class="btn_co_delete">
                        {{comment.reported ? '신고 취소' : '신고'}}
                        <div v-if="showPostingReportBubbleNumber === comment.commentIndex" class="sp_bubble">신고 5회 누적 시 내용이 가려집니다.</div>
                    </button>
                </div>
                <div class="co_txt">{{comment.content}}</div>
                <button @click="postReComment(comment)" type="button" class="btn_re_comment">답글달기</button>
            </template>
            <div v-else class="bg_blind">
                <img src="http://fiximage.10x10.co.kr/web2021/anniv2021/m/bg_blind.png?v=1.0" alt="여러 명의 신고로 블라인드된 댓글입니다.">
            </div>
            
            <!-- 대댓글 -->
            <div v-for="reComment in comment.comments" class="re_comment_list">
                <div v-if="!reComment.blocked" class="co_inner">
                    <div class="login_profile">
                        <div class="login_info_area">
                            <div class="img"><img :src="reComment.creatorThumbnail"></div>
                            <div class="info">
                                <p class="txt">{{filterCreatorDescription(reComment.creatorDescription)}}</p>
                                <p class="id">{{reComment.creatorNickname}}</p>
                            </div>
                        </div>
                        <button v-if="reComment.creator" @click="deleteComment(reComment.commentIndex)" type="button" class="btn_co_delete">삭제</button>
                        <button v-else @click="clickReportComment(reComment)" type="button" class="btn_co_delete">
                            {{reComment.reported ? '신고 취소' : '신고'}}
                            <div v-if="showPostingReportBubbleNumber === reComment.commentIndex" class="sp_bubble">신고 5회 누적 시 내용이 가려집니다.</div>
                        </button>
                    </div>
                    <div class="co_txt">{{reComment.content}}</div>
                </div>
                <div v-else class="bg_blind">
                    <img src="http://fiximage.10x10.co.kr/web2021/anniv2021/m/bg_blind.png?v=1.0" alt="여러 명의 신고로 블라인드된 댓글입니다.">
                </div>
            </div>
            
        </div>
    `,
    data() {return {
        showPostingReportBubbleNumber : -1, // 댓글 신고 말풍선 노출 할 댓글 일련번호
    }},
    props : {
        //region comment 댓글
        comment : {
            commentIndex : { type:Number, default:0 }, // 댓글 일련번호
            content : { type:String, default:'' }, // 댓글 내용
            creatorDescription : { type:String, default:'' }, // 작성자 설명
            creatorNickname : { type:String, default:'' }, // 작성자 별명
            creatorThumbnail : { type:String, default:'' }, // 작성자 썸네일
            creator : { type:Boolean, default:false }, // 작성자 여부
            blocked : { type:Boolean, default:false }, // 작성자 여부
            reported : { type:Boolean, default:false }, // 본인 신고 여부
            comments : { type:Array, default:function(){return [];} }, // 대댓글 리스트
        },
        //endregion
    },
    methods : {
        //region filterCreatorDescription 작성자설명 필터
        filterCreatorDescription(description) {
            if( description === 'RED' || description === 'WHITE' )
                return '';
            else
                return description;
        },
        //endregion
        //region postReComment 대댓글 등록
        postReComment(comment) {
            this.$emit('postReComment', comment);
        },
        //endregion
        //region deleteComment 댓글 삭제
        deleteComment(commentIndex) {
            const _this = this;
            if ( confirm('답글을 제거하시겠어요?') ) {
                const success = function () { _this.$emit('deleteComment'); };
                getFrontApiDataV2('POST', `/linker/posting/comment/delete/${commentIndex}`, null, success);
            }
        },
        //endregion
        //region clickReportComment 댓글 신고 클릭
        clickReportComment(comment) {
            if( !comment.reported )
                this.reportComment(comment);
            else
                this.cancelReportComment(comment);
        },
        //endregion
        //region reportComment 댓글 신고 등록
        reportComment(comment) {
            if( !confirm('답글을 신고하시겠어요?') )
                return false;

            const _this = this;
            const success = function() {
                comment.reported = true;
                _this.showPostingReportBubbleNumber = comment.commentIndex;
                setTimeout(function() {_this.showPostingReportBubbleNumber = -1;}, 5000);
            }
            getFrontApiDataV2('POST', `/linker/posting/comment/${comment.commentIndex}/report`,
                null, success);
        },
        //endregion
        //region cancelReportComment 댓글 신고 취소
        cancelReportComment(comment) {
            if( !confirm('신고를 취소하시겠어요?') )
                return false;

            const success = function() { comment.reported = false; }
            getFrontApiDataV2('POST', `/linker/posting/comment/${comment.commentIndex}/report/delete`,
                null, success);
        },
        //endregion
    }
});