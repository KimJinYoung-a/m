var app = new Vue({
    el: '#app',
    template: '\
    <div>\
        <comment-container\
            :list-query="listQuery"\
            :input-validation="inputValidation"\
            :chk-col-name="chkColName"\
            :chk-alert-msg="chkAlertMsg"\
        >\
            <template slot="commentForm" slot-scope="sp">\
                <div class="cmt-write">\
                    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/tit_cmt_v2.png" alt="친구들과 함께 받는 다이어리 신청하기"></h3>\
                    <div class="input-section">\
                        <div class="input-box input-grp"><span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/txt_grp_name_v2.png" alt="그룹명"></span>\
                            <input type="text" @click="sp.loginChk" ref="txtcomm" placeholder="텐텐클럽" v-model.trim="sp.formData.txtcomm">\
                            <button class="btn-chck" @click="sp.chkDataDuplication(\'그룹명을 넣어주세요.\')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/btn_chck_v2.png" alt="중복확인"></button>\
                        </div>\
                        <div class="input-box input-num"><span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/txt_num_v2.png" alt="인원수"></span>\
                            <input type="number" @click="sp.loginChk" ref="txtcomm2" placeholder="0" v-model.trim="sp.formData.txtcomm2">명\
                        </div>\
                        <div class="input-box input-reason"><span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/txt_reason_v2.png" alt="이유"></span>\
                            <textarea name="reason"  ref="txtcomm3" cols="30" rows="10" v-model.trim="sp.formData.txtcomm3" placeholder="100자 이내로 입력해주세요."></textarea>\
                        <em class="txt-num"><i>{{ sp.txt3Length }}</i>/100</em></div>\
                    </div>\
                    <button class="btn-submit" @click="handleClickSubmit(sp.submitComment, sp.downCoupon)"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/btn_submit_v2.png" alt="응모하기"></button>\
                </div>\
                <div class="search-section">\
                    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/txt_search_v2.png" alt="응모하기"></p>\
                    <div class="input-box">\
                        <input type="text" v-model.trim="listQuery.filterTxt" placeholder="그룹명을 입력해주세요.">\
                        <button class="btn-search" @click="handleClickSearch(sp.getCommentList)"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/btn_search_v2.png" alt="검색"></button>\
                    </div>\
                </div>\
            </template>\
            \
            <template slot="commentList" slot-scope="sp">\
                <comment-list-98339\
                    :comments="sp.comments"\
                    :like-id="listQuery.likeId"\
                    :is-login="sp.isLogin"\
                    :update-like-cnt="sp.updateLikeCnt"\
                    :delete-content="sp.deleteContent"\
                    :filter-param="sp.filterParam"\
                />\
            </template>\
            \
            <template slot="paging" slot-scope="sp">\
                <div class="paging pagingV15a"\
                    v-if="sp.pagingData.totalcount != 0"\
                >\
                    <span class="arrow prevBtn"\
                        v-if="sp.isPreArrowButton"\
                        @click="sp.handleClickPreArrow"\
                    ><a>prev</a></span>\
                    <span\
                        v-for="i in sp.pageIdx"\
                        :class="[sp.dispPageNumber(i) == sp.pagingData.currpage ? \'current\' : \'\']"\
                    >\
                        <a\
                            @click="sp.handleClickPageNumber( sp.dispPageNumber(i) )"\
                        >{{ sp.dispPageNumber(i) }}</a></span>\
                    <span class="arrow nextBtn"\
                        v-if="sp.isNextArrowButton"\
                        @click="sp.handleClickNextArrow"\
                    ><a>next</a></span>\
                </div>\
            </template>\
        </comment-container>\
        <div class="lyr-share"\
            v-if="popState"\
        >\
            <div class="inner">\
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_share.png" alt=""></p>\
                <ul>\
                    <li><a href="javascript:sharesns(\'fb\')">페이스북 공유</a></li>\
                    <li><a href="javascript:sharesns(\'ka\')">카카오톡 공유</a></li>\
                    <li><a href="javascript:sharesns(\'tw\')">트위터 공유</a></li>\
                </ul>\
                <button class="btn-close" @click="setPopState(false)">레이어닫기</button>\
                <a href="/my10x10/couponbook.asp" class="btn-cp mWeb" v-if="isGetCoupon && !isapp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/btn_cp.png" alt="3,000원 할인 쿠폰 지급 완료"></a>\
                <a href="" v-if="isGetCoupon && isapp" onclick=\'fnAPPpopupBrowserURL("마이텐바이텐","http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp"); return false;\' class="btn-cp mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/btn_cp.png" alt="3,000원 할인 쿠폰 지급 완료"></a>\
            </div>\
        </div>\
    </div>\
    ',
    data: function(){
        return {
            // 리스트 api 파라미터
            listQuery: {
                currentPage: 1,
                eventCode: eventCode,
                pageSize: 4,
                scrollCount: 5,
                likeId: 1,
                filterTxt: ''
            },
            // 폼 유효성 체크
            inputValidation: [
                { dataKey: 'txtcomm', nullCheck: { message: '그룹명을 작성해 주세요!' }, lengthCheck: { maxlength: 8, message: '그룹명은 8자까지 입력해주세요.' } },
                { dataKey: 'txtcomm2', nullCheck: { message: '빈칸을 모두 작성해주세요!' }, lengthCheck: { maxlength: 3, message: '3자리 숫자까지 입력해주세요.' } },
                { dataKey: 'txtcomm3', nullCheck: { message: '빈칸을 모두 작성해주세요!' }, lengthCheck: { maxlength: 100, message: '100자 이내로 입력해주세요', lengthWatch: true } }
            ],
            // 중복체크 관련 데이터
            chkColName: "txtcomm",
            chkAlertMsg: "이미 등록된 그룹명입니다. 다른 그룹명을 입력해주세요.",
            popState: false,
            isGetCoupon: false,
            isapp: isapp == "0" ? false : true
        }
    },
    methods: {
        handleClickSubmit: function(submit, cb){
            submit('addpday', 10, function(res){
                if(res == "ok"){
                    cb('evtsel', couponIdx, function(res){
                        if(res == "11"){
                            this.isGetCoupon = true
                        }else{
                            this.isGetCoupon = false
                        }
                        fnAmplitudeEventMultiPropertiesAction('click_event_apply', 'evtcode', eventCode)
                        this.setPopState()
                    }.bind(this))
                }
            }.bind(this))
        },
        setPopState: function(){
            this.popState = !this.popState
        },
        handleClickSearch: function(getComm){
            this.listQuery.currentPage = 1
            getComm();
        }
    }
})
