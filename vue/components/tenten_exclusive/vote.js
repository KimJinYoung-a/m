Vue.component('Vote',{
    template : `
        <div class="vote">
            <p class="quest">{{item.brand_name}}의 질문</p>
            <p class="question" v-html="change_nr(servey.question_contents)"></p>            
            <div class="option" v-bind:id="exclusiveIdx">
                <template v-for="(answer,index) in servey.choice">
                    <div @click="go_update_choice($event, servey.question_idx, answer.choice_idx, index)" :data-label="answer.choice_contents" :data-level="answer.vote_percent" :class="[{best : servey.already_choice_idx == answer.choice_idx}, 'chart']">
                        <span></span>
                        <p>{{answer.choice_contents}}</p>
                        <i>{{answer.vote_percent}}<b>%</b></i>    
                    </div>
                </template>
                <div class="comment" @click="click_comment()"><a>만족스러운 답이 없다면 직접 알려주세요.</a></div>
            </div>                        
            <p class="vote_noti"><span>{{servey.total_vote_cnt}}</span>명이 투표했어요</p>
            <a @click="go_share()" v-bind:id="'share'+exclusiveIdx" class="share" :data-clipboard-text="'m.10x10.co.kr/tenten_exclusive/item_detail.asp?gnbflag=1&exclusive_idx='+this.exclusiveIdx" v-if="servey.already_participate">친구에게도 공유하기</a><!-- 투표 완료 시 노출 -->
        </div>
    `,
    props : {
        exclusiveIdx : {type:String, default:''},
        index : {type:Number, default:0}
    },
    created() {
        this.get_data(this.exclusiveIdx);
        this.get_servey(this.exclusiveIdx);
        this.isLoginOk = isUserLoginOK;
    },
    mounted(){
        const _this = this;
        setTimeout(function() {
            if(_this.servey.already_participate){
                console.log("already_participate");
                _this.click_choice(_this.exclusiveIdx);
            }
        }, 1000);
    },
    data(){
        return {
            isLoginOk : false,
            item : {},
            servey : {},
            isApp : isApp
        }
    },
    methods : {
        get_data(exclusiveIdx) {
            const _this = this;
            console.log(exclusiveIdx);
            let api_data = {
                "exclusive_idx" : exclusiveIdx,
                "isApp" : isApp
            };

            call_api("GET", "/tenten-exclusive-real/item-detail", api_data
                , data=>{
                    console.log("GET_DATA", data);
                    _this.item = data;
                }
            );
        },
        get_servey(exclusiveIdx) {
            const _this = this;
            console.log(exclusiveIdx);
            let api_data = {"exclusive_idx" : exclusiveIdx};

            call_api("GET", "/tenten-exclusive-real/servey", api_data
                , data=>{
                    console.log("GET_SERVEY", data);
                    _this.servey = data;
                }
            );
        },
        click_comment() {
            // Amplitude
            fnAmplitudeEventMultiPropertiesAction('click_exclusive_main_comment', 'item_id', "'"+this.item.itemid+"'");
            if( isApp ){
                fnAPPpopupBrowserURL('코멘트',location.origin + '/apps/appCom/wish/web2014/tenten_exclusive/comment.asp?exclusiveIdx='+this.exclusiveIdx);
            } else {
                fnOpenModal('/tenten_exclusive/comment.asp?exclusiveIdx='+this.exclusiveIdx);
            }
        },
        go_share(){
            // Amplitude
            fnAmplitudeEventMultiPropertiesAction('click_exclusive_main_share', 'item_id', "'"+this.item.itemid+"'");
            let clipboard = new Clipboard('#share'+this.exclusiveIdx);
            clipboard.on('success', function(e) {
                alert('URL이 복사 되었습니다.');
                console.log(e);
            });
            clipboard.on('error', function(e) {
                console.log(e);
            });
        },
        click_choice(exclusiveIdx){
            let vote = $("#"+exclusiveIdx);
            vote.addClass('on');
            vote.find('span').delay(0).animate({"opacity" : "1"}, 0, function(){
                vote.find('span').each(function (){
                    $(this).css({"width" : $(this).parent().attr("data-level") + "%"});
                });
            });
        },
        go_update_choice(e, question_idx, choice_idx, index){
            const _this = this;
            if(this.is_saving){
                return false;
            }

            if(this.servey.already_participate){
                if(this.servey.already_choice_idx == choice_idx){

                }else{
                    alert("고마워요! 하지만 투표는 한 번만 참여 할 수 있어요 :)");
                }
            }else{
                if(this.isLoginOk){
                    this.is_saving = true;
                    const api_data = {
                        "question_idx" : question_idx
                        , "choice_idx" : choice_idx
                    }

                    call_api("POST", "/tenten-exclusive-real/servey", api_data
                        , data=>{
                            console.log("go_update_choice", data);
                            this.is_saving = false;

                            // Amplitude
                            fnAmplitudeEventMultiPropertiesAction('click_exclusive_main_vote', 'item_id|number', _this.item.itemid + '|' + (index+1));

                            if(data == 200){
                                //alert("참여 완료");
                                _this.get_servey(_this.exclusiveIdx);
                                _this.click_choice(_this.exclusiveIdx);
                            }else if(data == 101){
                                alert("이미 참여하셨습니다.");
                            }else if(data == 102){
                                if(confirm("투표를 하시려면 로그인이 필요해요!\n로그인 하시겠어요?")){
                                    if( isApp ) {
                                        calllogin();
                                    } else {
                                        location.href = '/login/login.asp?backpath=' + location.pathname + location.search;
                                    }
                                }
                            }
                        },
                        function error(xhr){
                            console.log(xhr);
                            const error = JSON.parse(xhr.responseText);
                            if( error.code === -10 ) {
                                if(confirm("투표를 하시려면 로그인이 필요해요!\n로그인 하시겠어요?")){
                                    if( isApp && isApp != '0' ) {
                                        calllogin();
                                        return false;
                                    } else {
                                        location.href = '/login/login.asp?backpath=' + location.pathname + location.search;
                                    }
                                }
                            }
                        }
                    );
                }else{
                    if(confirm("투표를 하시려면 로그인이 필요해요!\n로그인 하시겠어요?")){
                        if( isApp ) {
                            calllogin();
                        } else {
                            location.href = '/login/login.asp?backpath=' + location.pathname + location.search;
                        }
                    }
                }
            }
        },
        change_nr(text){
            if(text){
                return text.replaceAll("\r\n", "<br />");
            }
        }
    }
})