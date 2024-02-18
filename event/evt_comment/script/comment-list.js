Vue.component('event-comment-list', {

    template: `
    <div id="tab2" class="tab-cont reply-view">
        <div id="replyList" class="reply-list">
            <div class="total">
                총 {{setComma(totalCommentCount)}}개의 댓글이 있습니다.                
            </div>                        
            <p class="no-data"
                v-if="commentList.length <= 0"
            >해당 게시물이 없습니다.</p>
            <ul
                v-if="commentList.length > 0"
            >
                <li
                    v-for="comment in commentList"
                    :key="comment.contentId"
                >
                    <div class="reply-cont">
                        <p>{{comment.content}}</p>
                        <div class="info">
                            <span class="writer">{{comment.userId}}</span>
                            <span class="date">{{comment.regDate}}</span>
                        </div>
                        <div class="edit" v-if="comment.isMyContent">                                
                        <button class="btn-delete"
                            @click="handleClickDelete(comment.contentId)"
                        >삭제</button>
                        </div>                                                    
                    </div>
                </li>     
            </ul>
            <div class="paging pagingV15a">
                <span class="arrow prevBtn"
                    v-if="isPreArrowButton"
                    @click="handleClickPreArrow"
                ><a>prev</a></span>
                <span 
                    v-for="i in pageIdx"                                                        
                    :class="[dispPageNumber(i) == pageInfo.currentPage ? 'current' : '']"
                >
                    <a 
                        @click="handleClickPageNumber( dispPageNumber(i) )"
                    >{{ dispPageNumber(i) }}</a></span>

                <span class="arrow nextBtn"
                    v-if="isNextArrowButton"
                    @click="handleClickNextArrow"
                ><a>next</a></span>
            </div>
        </div>
    </div>    
    `,
    props: {
        commentList: {
            type: Array,
            defualt: []
        },
        evtStartDate: {
            type: String,
            defualt: ""
        },
        evtEndDate: {
            type: String,
            defualt: ""            
        },
        totalCommentCount: {
            type: Number,
            defualt: 0
        },
        pageInfo: {
            type: Object,
            default: function(){
                return {
                    currentPage: 0,
                    totalCnt: 0,
                    pageSize: 0,
                    pageCnt: 0
                }
            }
        },
        movePage: {
            type: Function,
            default: function(){
                alert('default Page button Clicked')
            }
        },
        handleCommentData: {
            type: Function,
            default: function(){
                alert('default insert action');
            }            
        }
    },
    data: function(){
        return {                        
            commentData:{
                inputComment: "",
                mode: "",
                idx: "",
                eventCode: 0,
            }
        }
    },
    methods: {
        setComma(x){
            return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        },
        handleClickPageNumber(pageNum){
            this.movePage(pageNum)
        },
        dispPageNumber(pageNum){            
            return this.pageInfo.pageCnt * this.blockNum + pageNum
        },
        handleClickNextArrow(){
            this.movePage(this.endPage + 1)
        },
        handleClickPreArrow(){
            this.movePage(this.startPage - 1)
        },        
        handleClickDelete(idx){
            if(!confirm("삭제하시겠습니까?")) return false;            
            
            this.commentData.mode="del"
            this.commentData.idx=idx

            if(this.handleCommentData(this.commentData)){
                this.resetCommentData();
            }
        },        
        resetCommentData(){
            this.commentData.inputComment = ""            
            this.commentData.mode = ""
            this.commentData.idx = ""           
        }        
    },
    computed: {
        totalPages: function(){
            return Math.floor(this.pageInfo.totalCnt/this.pageInfo.pageSize +1)
        },        
        startPage: function(){
            return Math.floor((this.pageInfo.currentPage - 1) / this.pageInfo.pageCnt) * this.pageInfo.pageCnt + 1
        },         
		endPage: function(){
            var tmpEndPage = this.totalPages > this.pageInfo.pageCnt ? 
            Math.floor((this.pageInfo.currentPage - 1) / this.pageInfo.pageCnt) * this.pageInfo.pageCnt + this.pageInfo.pageCnt
            :
            this.totalPages
            return tmpEndPage
        },
        isPreArrowButton: function(){
            return this.pageInfo.currentPage > this.pageInfo.pageCnt
        },
        isNextArrowButton: function(){
            return this.blockNum + 1 < Math.ceil(this.totalPages / this.pageInfo.pageCnt) 
        },
        pageIdx: function(){
            // this.blockNum
            var result = this.pageInfo.pageCnt;
            if(this.blockNum + 1 >= Math.ceil(this.totalPages / this.pageInfo.pageCnt)){
                result = Math.ceil(this.totalPages % this.pageInfo.pageCnt)
            }
            return result 
        },
        blockNum: function(){
            var blockNum = Math.floor(this.pageInfo.currentPage / this.pageInfo.pageCnt)
            blockNum = this.pageInfo.currentPage % this.pageInfo.pageCnt == 0 ? blockNum - 1 : blockNum;                            
            
            return blockNum
        }
    },
    watch: {
        pageInfo: {
            handler: function(){                
                // console.log(`${this.blockNum}, ${Math.ceil(this.totalPages / this.pageInfo.pageCnt)}`)                
            },
            deep: true
        }
    }    
})