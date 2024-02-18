
Vue.component('comment-list', {
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
                }
            }
        }
    },
    template: `
        <ul v-if="commentListProps.length > 0">
            <li 
              v-for="comment in commentListProps"
              :key="comment.contentId"
            >
                <p class="num">
                    {{comment.tmpContentNum}}
                    <span class="mob" v-if="comment.tmpChannel != 'W'">
                        <img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성" />
                    </span>
                </p>
                <div class="replyCont">
                    <p>{{comment.content}}</p>
                    <p class="tPad05" v-if="comment.isMyContent">
                        <span class="button btS1 btWht cBk1"><a href="#">수정</a></span>                        
                    </p>
                    <div class="writerInfo">
                        <p>{{comment.regDate}} <span class="bar">
                        /
                        </span> {{comment.userId}}</p>
                        <p class="badge">
                            <span 
                              v-for="userBadgeImg in comment.userBadgeArr"
                              v-if="comment.userBadgeArr.length > 0"
                            ><img :src="userBadgeImg" alt="" /></span>        
                        </p>
                    </div>
                </div>
            </li>
         </ul>    
    `
  })



var testTemplate =     `
<div class="inner5 tMar25">
    <div id="replyList" class="replyList box1 evtReplyV15">
        <p class="total">총 15개의 댓글이 있습니다.</p>
        <p class="goWriteV15" onclick=""><span>댓글쓰기</span></p>
        <comment-list
          :comment-event-info-props="commentEventInfo"
          :comment-list-props="commentList"
        ></comment-list>            
        <span class="button btM1 btBckBdr cBk1 w100p">
            <a @click="popupCommentList">
                <em>전체보기</em>
            </a>
        </span>
    </div>
</div>
`
 
