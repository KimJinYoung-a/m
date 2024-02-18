Vue.component('event-comment-form', {
    template: `
    <div id="tab1" class="tab-cont reply-write">
        <div class="write focus">            
            <div class="inner">
                <textarea 
                    cols="30" rows="3" placeholder="300자 이내로 작성해주세요"                                        
                    v-model="commentData.inputComment"
                    maxlength="300"
                    id="inputText"        
                    @click="chkLogin"            
                ></textarea>
                <button class="btn-submit"
                    @click="handleClickSubmit()"
                >등록</button>
            </div>            
        </div>
    </div>
    `,
    props: {
        handleCommentData: {
            type: Function,
            default: function(){
                alert('default insert action');
            }            
        },
        isLogin: {
            type: Boolean,
            default: false
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
        handleClickSubmit(){
            if(!this.validationCheck()) return false;
            this.commentData.mode="add"
            
            if(this.handleCommentData(this.commentData)){
                this.resetCommentData();        
            }
        },
        validationCheck(){
            if(this.commentData.inputComment == ""){
                alert("댓글을 입력해주세요.")
                window.document.getElementById("inputText").focus()
                return false;
            }
            return true;
        },
        resetCommentData(){
            this.commentData.inputComment = ""            
            this.commentData.mode = ""
            this.commentData.idx = ""           
        },                             
        chkLogin(){
            if(this.isLogin) return false;
            var url = window.location.pathname + window.location.search;            

            if(isapp == 1){
                calllogin();
                return false;
            }else{
                jsChklogin_mobile('', url);
            }            
        }        
    }
})