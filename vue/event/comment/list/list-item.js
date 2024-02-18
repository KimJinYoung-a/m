
var listUrl = "/event/evt_comment/api/comment_list.asp"
var actionUrl = "/event/evt_comment/api/comment_action.asp"

Vue.component('event-comment', {
    data: function(){
        return {
            commentEventInfo: {
                evtCommentCopy: '',
                evtStartDate: '',
                evtEndDate: '',
                winnerPresentDate: '',
                totalCommentCount: '',
                giftImg: '',
                isCommentEvent: '',
                isCommentEnd: false
            },
            commentList: [],
            param: {
                evtCmtDataType: 3,
                currentPage: 1,
                eventCode: 0,
                pageSize: 3
            },
            isLogin: false
        }

    },
    props: {
        eventCode: Number
    },
    methods: {
        getComment: function(){
            var _this = this;
            this.param.eventCode = this.eventCode;
            var param = this.param
            $.getJSON(listUrl, param, function (data, status, xhr) {
                if (status == "success") {
                    _this.commentList = data.comments;
                    _this.commentEventInfo.evtCommentCopy = data.evtCommentCopy
                    _this.commentEventInfo.evtStartDate = data.evtStartDate
                    _this.commentEventInfo.evtEndDate = data.evtEndDate
                    _this.commentEventInfo.winnerPresentDate = data.winnerPresentDate
                    _this.commentEventInfo.totalCommentCount = data.totalCommentCount
                    _this.commentEventInfo.giftImg = data.giftImg
                    _this.isLogin = data.isLogin
                    _this.commentEventInfo.isCommentEvent = data.isCommentEvent
                    _this.commentEventInfo.isCommentEnd = data.isCommentEnd
                } else {
                    console.log("JSON data not Loaded.");
                }
            });
        },
        popupCommentList: function(){
            if(isapp == 1){
                fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '댓글', [BtnType.SHARE, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/evt_comment/view/index.asp?eventcode='+this.eventCode); return false;
            }else{
                window.location.href="/event/evt_comment/view/index.asp?eventcode="+this.eventCode
            }
        },
        handleCommentData: function(commentObj){
            var result

            $.ajax({
                type: "post",
                url: actionUrl,
                data: {
                    inputCommentData: commentObj.inputComment,
                    mode: commentObj.mode,
                    idx: commentObj.idx,
                    eventCode: this.eventCode
                },
                async: false,
				success : function(Data, textStatus, jqXHR){
                    if(Data!="") {
                        var str= Data;
                        res = str.split("|");
                        if (res[0]=="ok"){
                            result = true;
                        } else if(res[1]=="login"){
                            jsChklogin_mobile('',window.location.href)
                            result = false;
                        }else{
                            console.log(Data)
                            result = false;
                        }
                    } else {
                        console.log(Data)
                        alert("잘못된 접근 입니다.");
                        result = false;
                    }
				},
				error:function(jqXHR, textStatus, errorThrown){
                    console.log(Data)
					alert("잘못된 접근 입니다.");
					result = false;
				}
            })
            if(result)this.getComment();

            return result;
        }
    },
    mounted:function(){
        this.getComment();
    },
    template: '\
    <div>\
        <media-comment-list\
            :is-comment-event="commentEventInfo.isCommentEvent"\
            :comment-event-info-props="commentEventInfo"\
            :comment-list-props="commentList"\
            :handle-comment-data="handleCommentData"\
            :popup-comment-list="popupCommentList"\
            :is-login="isLogin"\
        ></media-comment-list>\
    </div>\
    '
})
