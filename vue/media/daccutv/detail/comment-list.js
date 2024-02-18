
Vue.component('media-comment-list', {
    template: '\
    <div>\
        <div class="reply-evt"\
            :class="[commentEventInfoProps.giftImg != \'\' ? \'photo\' : \'\']">\
            <div\
                v-if="isCommentEvent==\'Y\'"\
            >\
                <h3>댓글 이벤트</h3>\
                <div class="topic"\
                    v-html="commentEventInfoProps.evtCommentCopy"\
                ></div>\
                <div class="fin-evt"\
                    v-if="commentEventInfoProps.isCommentEnd"\
                >\
				    <p>이벤트가 종료되었습니다</p>\
			    </div>\
                <div class="thumbnail"\
                    v-if="commentEventInfoProps.giftImg != \'\'">\
                    <a @click="handleImgClick">\
                        <img :src="commentEventInfoProps.giftImg" alt="">\
                    </a>\
                </div>\
                <ul>\
                    <li>이벤트 기간 <span class="date">{{commentEventInfoProps.evtStartDate}} - {{commentEventInfoProps.evtEndDate}}</span></li>\
                    <li>당첨자 발표 <span class="date">{{commentEventInfoProps.winnerPresentDate}}</span></li>\
                </ul>\
            </div>\
            <div class="write"\
                v-bind:class="{ focus: textAreaCtrObj.isFocused }"\
            >\
                <div class="inner">\
                    <textarea\
                        cols="30" rows="3"\
                        :placeholder="textAreaCtrObj.placeHolder"\
                        v-model="commentData.inputComment"\
                        id="inputText"\
                        @click="handleClickTextBox"\
                    ></textarea>\
                    <button class="btn-submit"\
                        @click="handleClickSubmit()"\
                    >등록</button>\
                </div>\
            </div>\
        </div>\
        <div class="ly-gift"\
            v-if="commentEventInfoProps.giftImg != \'\'"\
        >\
            <div class="inner">\
                <div class="thumbnail"><img :src="commentEventInfoProps.giftImg" alt=""></div>\
                <button class="btn-close"\
                    @click="handleCloseBtn"\
                >닫기</button>\
            </div>\
            <div class="mask"></div>\
        </div>\
        <div id="replyList" class="reply-list" >\
            <div class="total">\
                총 <b>{{setComma(commentEventInfoProps.totalCommentCount)}}</b>개의 댓글이 있습니다.\
            </div>\
            <p class="no-data" v-if="commentListProps.length <= 0">해당 게시물이 없습니다.</p>\
            <div v-else >\
                <ul>\
                    <li\
                        v-for="comment in commentListProps"\
                        :key="comment.contentId"\
                    >\
                        <div class="reply-cont">\
                            <p>{{comment.content}}</p>\
                            <div class="info">\
                                <span class="writer">{{comment.userId}}</span>\
                                <span class="date">{{comment.regDate}}</span>\
                            </div>\
                            <div class="edit" v-if="comment.isMyContent">\
                                <button class="btn-delete"\
                                    @click="handleClickDelete(comment.contentId)"\
                                >삭제</button>\
                            </div>\
                        </div>\
                    </li>\
                </ul>\
                <div class="btn-area">\
                    <button class="btn-all"\
                        @click="popupCommentList">댓글 전체보기</button>\
                </div>\
            </div>\
        </div>\
    </div>\
    ',
    data: function(){
        return {
            commentData:{
                inputComment: "",
                mode: "",
                idx: "",
                eventCode: 0,
            },
            textAreaCtrObj: {
                placeHolder: "댓글을 입력해주세요.",
                isFocused: false,
            }
        }
    },
    methods: {
        handleImgClick: function(){
            $(".ly-gift").show()
        },
        handleCloseBtn: function(){
            $(".ly-gift").hide();
        },
        handleClickSubmit: function(){
            if(!this.validationCheck()) return false;
            this.commentData.mode="add"

            if(this.handleCommentData(this.commentData)){
                this.resetCommentData();
                this.setTextAreaData(2)
            }
        },
        handleClickDelete: function(idx){
            if(!confirm("삭제하시겠습니까?")) return false;

            this.commentData.mode="del"
            this.commentData.idx=idx

            if(this.handleCommentData(this.commentData)){
                this.resetCommentData();
            }
        },
        resetCommentData: function(){
            this.commentData.inputComment = ""
            this.commentData.mode = ""
            this.commentData.idx = ""
        },
        validationCheck: function(){
            if(this.commentData.inputComment == ""){
                alert("댓글을 입력해주세요.")
                window.document.getElementById("inputText").focus()
                return false;
            }
            return true;
        },
        setComma: function(x){
            return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        },
        chkLogin: function(){
            if(this.isLogin) return false;
            var url = window.location.pathname + window.location.search;

            if(isapp == 1){
                calllogin();
                return false;
            }else{
                jsChklogin_mobile('',url);
            }
        },
        handleClickTextBox: function(){
            if(this.chkLogin()) return false;

            this.setTextAreaData(1)
        },
        setTextAreaData: function(flag){
            if(flag == 1){
                this.textAreaCtrObj.isFocused = true
                this.textAreaCtrObj.placeHolder = "300자 이내로 작성해주세요"
            }else{
                this.textAreaCtrObj.isFocused = false
                this.textAreaCtrObj.placeHolder = "댓글을 입력해주세요."
            }

        }
    },
    props:{
        commentListProps: {
            type: Array,
            default: []
        },
        commentEventInfoProps: {
            type: Object,
            default: function(){
                return {
                    evtCommentCopy: '',
                    evtStartDate: '',
                    evtEndDate: '',
                    winnerPresentDate: '',
                    totalCommentCount: '',
                    giftImg: '',
                }
            }
        },
        handleCommentData: {
            type: Function,
            default: function(){
                alert('default insert action');
            }
        },
        popupCommentList: {
            type: Function,
            default: function(){
                alert('default popup action');
            }
        },
        isLogin: {
            type: Boolean,
            default: false
        },
        isCommentEvent: {
            type: String,
            default: 'N'
        }
    }
})