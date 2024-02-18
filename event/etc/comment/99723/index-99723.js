var app = new Vue({
    el: '#app',
    template: '\
<div>\
    <rolling v-once></rolling>\
    <div class="cmt-section">\
        <comment-container\
            :list-query="listQuery"\
            :input-validation="inputValidation"\
        >\
        <template slot="commentForm" slot-scope="sp">\
            <div class="cmt-box">\
                <div class="preview">\
                    <span class="writer">{{sp.dispUserName("___")}}님의 화끈다짐</span>\
                    <span class="word">{{sp.formData.txtcomm}}</span>\
                    <p>만큼은 화끈하게!</p>\
                </div>\
                <div class="select-group">\
                    <ul class="select-list" ref="options">\
                        <li v-for="op in options"><input type="radio" v-on:click.stop="setComm(op.option, sp, op.id)" name="selct" :id="op.id"><label :for="op.id">{{op.option}}</label></li>\
                        <li @click="setComm(\'\', sp, \'10\')"><input type="radio" name="selct" id="selct10"><label for="selct10">직접쓰기</label>\
                            <input type="text" v-model.trim="sp.formData.txtcomm" ref="txtcomm" id="own-word" placeholder="최대 6글자">\
                        </li>\
                    </ul>\
                    <button class="btn-submit"\
                        @click="handleClickSubmit(sp.submitComment)"\
                    >\
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/btn_submit.png" alt="응모하기">\
                    </button>\
                </div>\
            </div>\
        </template>\
        <template slot="commentList" slot-scope="sp">\
            <div class="cmt-list-wrap" id="cmtTop">\
                <div class="ranking" v-if="sp.top3.length > 0">\
                    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/tit_ranking.png" alt="RANKING"></p>\
                    <ul>\
                        <li v-for="(item, idx) in sp.top3">{{idx + 1}}위 &sol; {{item.count}}명의 {{ options[item.optionIdx - 1].option }}</li>\
                    </ul>\
                </div>\
                <ul class="cmt-list">\
                    <li v-for="comment in sp.comments" :key="comment.contentnum"\>\
                        <span class="num">{{"No." + comment.contentnum}}</span>\
                        <button class="btn-delete"\
                            v-if="comment.isMyContent"\
                            @click="sp.deleteContent(comment.contentId)"\
                        >[삭제]</button>\
                        <span class="writer">{{comment.userName}}님의 화끈다짐</span>\
                        <div class="promise">\
                            <span class="word">{{comment.content}}</span>\
                            <p>만큼은 화끈하게!</p>\
                        </div>\
                    </li>\
                </ul>\
            </div>\
            </template>\
            <template slot="paging" slot-scope="sp">\
                <comment-paging\
                :slot-props="sp"\
                ></comment-paging>\
            </template>\
        </comment-container>\
    </div>\
</div>'
    ,
    data: function(){
        return {
            // 리스트 api 파라미터
            listQuery: {
                currentPage: 1,
                eventCode: eventCode,
            },
            // 폼 유효성 체크
            inputValidation: [
                { dataKey: 'txtcomm', nullCheck: { message: '빈 칸을 채워주세요!', cb: this.chkCallBack }, lengthCheck: { maxlength: 6, message: '6자까지 입력해주세요.', lengthWatch: true } },
                // { dataKey: 'txtcomm2', nullCheck: { message: '빈칸을 모두 작성해주세요!' }, lengthCheck: { maxlength: 3, message: '3자리 숫자까지 입력해주세요.' } },
                // { dataKey: 'txtcomm3', nullCheck: { message: '빈칸을 모두 작성해주세요!' }, lengthCheck: { maxlength: 100, message: '100자 이내로 입력해주세요', lengthWatch: true } }
            ],
            isapp: isapp == "0" ? false : true,
            options: [
                {id : '1', option: '사랑'},
                {id : '2', option: '우정'},
                {id : '3', option: '다이어트'},
                {id : '4', option: '쇼핑'},
                {id : '5', option: '취미'},
                {id : '6', option: '취업'},
                {id : '7', option: '할말'},
                {id : '8', option: '운동'},
                {id : '9', option: '공부'},
            ]
        }
    },
    methods: {
        handleClickSubmit: function(submit){
            submit('addpday', 10, function(res){
                if(res == "ok"){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply', 'evtcode', eventCode)
                    var ele = document.getElementsByName("selct");
                    for(var i=0;i<ele.length;i++)
                        ele[i].checked = false;
                        alert('화끈 다짐이 응모되었습니다. :)\n많이 응모할수록 당첨확률 UP!')
                }
            }.bind(this))
        },
        setComm: function(op, sp, id){
            sp.formData.txtcomm = op
            sp.formData.option1 = id
            if(id == "10"){
                document.getElementById('selct10').checked = true
            }else{
                document.getElementById(id).checked = true
                window.setTimeout(function(){this.$refs["txtcomm"].value = ""}.bind(this), 0)
            }
        },
        chkCallBack: function(){
            document.getElementById('selct10').checked = true
        }
    }
})
