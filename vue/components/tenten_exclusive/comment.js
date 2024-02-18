Vue.component('Exclusive-Commnet',{
    template : `
        <div class="layerPopup">
         <div class="popWin">
          <div v-if="!isApp" class="header">
            <h1>코멘트</h1>
            <p class="btnPopClose" ><button class="pButton" @click="click_modal_close();">닫기</button></p>
          </div>
          <div class="content bgGry" id="ExlayerScroll">
           <div id="scrollarea" style="overflow: auto;">
            <div class="inner5 tMar15 cmtCont">
             <div class="tab01 noMove" id="writediv" style="display:">
             <div v-if="!isApp" style="height: 50px;"></div>
              <div class="tabContainer box1">
               <div id="cmtWrite" class="tabContent">
                <form method="post" action="/gift/gifttalk/iframe_talk_comment_proc.asp" name="commfrm" id="commfrm" target="iframecproc" style="margin:0px;">
                <textarea id="txtcomm" cols="30" rows="5" maxlength="150" name="contents" :disabled="disabled" v-model="inputComment"></textarea>
                <p class="tip">통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며, 이벤트 참여에 제한을 받을 수 있습니다.</p>
                <span class="button btB1 btRed cWh1 w100p"><input type="button" value="등록" @click="click_reg()" :disabled="disabled"/></span>
                </form>
               </div>
              </div>
             </div>
             <div class="tab01 noMove" id="listdiv" style="display:">
              <div class="tabContainer box1" id="commentlistajax">
               <div id="cmtView" class="tabContent">
                <div class="replyList">
                <p class="no-data ct" v-if="comments.length <= 0">해당 게시물이 없습니다.<br><br></p>
                 <p class="total" v-if="comments.length > 0">총 <em class="cRd1">{{ totalCount }}</em>개의 댓글이 있습니다.</p>
                   <ul v-if="comments.length > 0">
                    <li v-for="(comment,index) in comments">
                      <p class="num">{{ index+1 }}
                        <span class="mob" v-if="comment.deviceType == 'M' || comment.deviceType == 'A'"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성"></span></p>
                      <div class="replyCont">
                        <p>{{ comment.contents }}</p>
                          <p class="tPad05">
                            <span class="button btS1 btWht cBk1" v-if="!disabled && loginUserId == comment.userId">
                                <a @click="click_delete(comment.commentIdx)">삭제</a>
                             </span>
                          </p>
                        <div class="writerInfo">
                          <p>{{ comment.regDt }} <span class="bar">/</span> {{ printUserName(comment.userId, 2, "*") }}</p>
                          <p class="badge"></p>
                        </div>
                      </div>
                    </li>
                  </ul>                 
                    <div class="paging pagingV15a">
                        <span class="arrow prevBtn"
                            v-if="isPreArrowButton"
                            @click="click_pre"
                        ><a>prev</a></span>
                        <span 
                            v-for="i in pageIdx"                                                        
                            :class="[dispPageNumber(i) == currentPage ? 'current' : '']"
                        >
                            <a 
                                @click="setList( dispPageNumber(i) )"
                            >{{ dispPageNumber(i) }}</a></span>
        
                        <span class="arrow nextBtn"
                            v-if="isNextArrowButton"
                            @click="click_next"
                        ><a>next</a></span>
                    </div>                
                </div>
               </div>
              </div>
             </div>
            </div>
           </div>
          </div>
         </div>
        </div>    
    `
    , props : {
        // defaultComment : {type:String, default: isUserLoginOK == 'False' ? '로그인 후 글을 남길 수 있습니다.' : ''},
        disabled : {type:Boolean, default:isUserLoginOK == 'False'},
        loginUserId : {type:String, default: loginUserID},
        exclusiveIdx : {type:String, default: ''}
    }
    , data: function() {
        return {
            inputComment: isUserLoginOK == 'False' ? '로그인 후 글을 남길 수 있습니다.' : '',
            comments : [],
            currentPage : '',
            totalCount : '',
            pageSize : 5,
            lastPage : ''

            , isApp : false
        }
    }
    , created() {
        console.log("isApp", isApp);
        if(isApp){
            this.isApp = true;
        }

        this.setList(1);
    },
    mounted() {
        $('#ExlayerScroll').height(window.outerHeight);
        // alert($('#ExlayerScroll').height());
    },
    methods : {
        click_modal_close() {
            fnCloseModal();
        },
        printUserName(name, num, replaceStr){
            return name.substr(0,name.length - num) + replaceStr.repeat(num)
        },
        click_next(){
            this.setList(this.endPage + 1)
        },
        click_pre(){
            this.setList(this.startPage - 1)
        },
        dispPageNumber(pageNum){
            return this.pageSize * this.blockNum + pageNum
        },
        setList(currentPage){
            const _this = this;

            const data = {
                exclusiveIdx : _this.exclusiveIdx,
                currentPage : currentPage
            }

            $.ajax({
                type : 'GET',
                url: apiurl+'/tenten-exclusive-real/comments',
                data: data,
                ContentType : "json",
                crossDomain: true,
                async: false,
                xhrFields: {
                    withCredentials: true
                }
                , success: function(data) {
                    _this.comments = data.comments;
                    _this.currentPage = data.currentPage;
                    _this.totalCount = data.totalCount;
                    _this.lastPage = data.lastPage;
                }
                , error: function (xhr) {
                    console.log(xhr);
                }
            });
        },
        click_reg() {
            const _this = this;

            if(_this.inputComment == ''){
                alert('코멘트를 입력해 주세요.');
                return;
            }

            const data = {
                exclusiveIdx : _this.exclusiveIdx,
                contents : _this.inputComment
            }

            $.ajax({
                type : 'POST',
                url: apiurl+'/tenten-exclusive-real/comment',
                data: data,
                ContentType : "json",
                crossDomain: true,
                async: false,
                xhrFields: {
                    withCredentials: true
                }
                , success: function(data) {
                    _this.inputComment = '';
                    _this.setList(1);
                }
                , error: function (xhr) {
                    console.log(xhr);
                }
            });
        },
        click_delete(commentIdx) {
            const _this = this;

            $.ajax({
                type : 'POST',
                url: apiurl+'/tenten-exclusive-real/comments/delete/'+commentIdx,
                ContentType : "json",
                crossDomain: true,
                async: false,
                xhrFields: {
                    withCredentials: true
                }
                , success: function(data) {
                    _this.setList(1);
                }
                , error: function (xhr) {
                    console.log(xhr);
                }
            });
        }
    },
    computed : {
        startPage: function(){
            return Math.floor((this.currentPage - 1) / this.pageSize) * this.pageSize + 1
        },
        endPage: function(){
            let tmpEndPage = this.lastPage > this.pageSize ?
                Math.floor((this.currentPage - 1) / this.pageSize) * this.pageSize + this.pageSize
                :
                this.lastPage
            return tmpEndPage
        },
        isPreArrowButton: function(){
            return this.currentPage > this.pageSize
        },
        isNextArrowButton: function(){
            return this.blockNum + 1 < Math.ceil(this.lastPage / this.pageSize)
        },
        pageIdx: function(){
            // this.blockNum
            let result = this.pageSize;
            if(this.blockNum + 1 >= Math.ceil(this.lastPage / this.pageSize)){
                result = Math.ceil(this.lastPage % this.pageSize)
            }
            return result
        },
        blockNum: function(){
            let blockNum = Math.floor(this.currentPage / this.pageSize)
            blockNum = this.currentPage % this.pageSize == 0 ? blockNum - 1 : blockNum;
            return blockNum
        }
    }
});