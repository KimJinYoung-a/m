var listUrl = "/event/evt_comment/api/comment_list.asp"
var actionUrl = "/event/evt_comment/api/comment_action.asp"

var app = new Vue({
    el: '#app',    
    template: `
<div class="tab-reply" id="top">
    <ul class="tab-nav">
        <li name="tab1" 
            @click="activeTab(0)"            
            :class="[activatedTab == 0 ? 'on' : '']"
        ><a>댓글쓰기</a></li>
        <li name="tab2"
            @click="activeTab(1)"
            :class="[activatedTab == 1 ? 'on' : '']"
        ><a>전체보기</a></li>
    </ul>
    <div class="tab-container">        
        <event-comment-form
            v-if="activatedTab==0"
            :handle-comment-data="handleCommentData"
            :is-login="isLogin"
        ></event-comment-form>        <!-- 스크립트 경로 : /event/evt_comment/script/comment-form.js-->      
        <event-comment-list     
            v-if="activatedTab==1"       
            :comment-list="commentList"
            :evt-start-date="commentEventInfo.evtStartDate"
            :evt-end-date="commentEventInfo.evtEndDate"
            :total-comment-count="commentEventInfo.totalCommentCount"            
            :page-info="pageInfo"
            :move-page="movePage"
            :handle-comment-data="handleCommentData"
        ></event-comment-list>        <!-- 스크립트 경로 : /event/evt_comment/script/comment-list.js-->      
    </div>
</div>    
    `,
    data: function(){
        return {          
            commentEventInfo: {
                evtStartDate: '',
                evtEndDate: '',
                totalCommentCount: 0,
            },              
            commentList: [],
            param: {
                evtCmtDataType: 3,
                currentPage: 1,
                eventCode: 0, 
                pageSize: 10
            },
            pageInfo: {
                currentPage: 1,
                totalCnt: 0,
                pageSize: 10,
                pageCnt: 5
            },
            eventCode: 0,
            activatedTab: 1,
            isLogin: false            
        }
    },
    methods: {
        activeTab(tabIdx){
            this.activatedTab = tabIdx;
        },
        getComment(){
            var _this = this;    
            this.param.eventCode = this.eventCode = this.getParameterByName('eventcode');
            var param = this.param                           
            $.getJSON(listUrl, param, function (data, status, xhr) {
                if (status == "success") {                     
                    _this.commentList = data.comments;
                    _this.commentEventInfo.evtStartDate = data.evtStartDate
                    _this.commentEventInfo.evtEndDate = data.evtEndDate
                    _this.commentEventInfo.winnerPresentDate = data.winnerPresentDate
                    _this.commentEventInfo.totalCommentCount = data.totalCommentCount                    
                    _this.isLogin = data.isLogin
                    _this.pageInfo.totalCnt = data.totalCommentCount
                } else {
                    console.log("JSON data not Loaded.");
                }
            });                 
        },
        handleCommentData(commentObj){            
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
                            chkLogin()
                            result = false;
                        }else if(res[0]=="Err"){                            
                            alert(res[1])
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
            this.movePage(1)
            if(result){this.getComment();this.activeTab(1)}

            return result;          
        },          
        getParameterByName(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[\]]/g, "\\$&");
            var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
                results = regex.exec(url);
            return results[2];
        },
        movePage(pageNumber){            
            this.setPageInfo(pageNumber)                
            this.getComment()
            window.location.href="#top"
        },
        setPageInfo(cPage){
            this.pageInfo.currentPage = cPage            
            this.param.currentPage = cPage            
        },
        chkLogin(){
            if(this.isLogin) return false;
            var url = window.location.pathname + window.location.search;            

            if(isapp == 1){
                calllogin();
                return false;
            }else{                
                jsChklogin_mobile('',url);
            }            
        }                        
    },
    created: function(){
        this.getComment();              
    }
})