Vue.component('comment-container', {
    template: '\
<div>\
    <slot name="commentForm"\
        :form-data.sync="formData"\
        :txt1-length="txt1Length"\
        :txt2-length="txt2Length"\
        :txt3-length="txt3Length"\
        :submit-comment="submitComment"\
        :login-chk="loginChk"\
        :chk-data-duplication="chkDataDuplication"\
        :get-comment-list="getCommentList"\
        :down-coupon="downCoupon"\
        :user-id="userId"\
        :disp-user-id="dispUserId"\
        :disp-user-name="dispUserName"\
    />\
    <slot name="commentList"\
        :comments="comments"\
        :top3= "top3"\
        :is-login="isLogin"\
        :update-like-cnt="updateLikeCnt"\
        :delete-content="deleteContent"\
        :filter-param="filterParam"\
    />\
    <slot name="paging"\
        :paging-data="pagingData"\
        :move-page="movePage"\
        :handle-click-page-number="handleClickPageNumber"\
        :disp-page-number="dispPageNumber"\
        :handle-click-next-arrow="handleClickNextArrow"\
        :handle-click-pre-arrow="handleClickPreArrow"\
        :is-pre-arrow-button="isPreArrowButton"\
        :is-next-arrow-button="isNextArrowButton"\
        :page-idx="pageIdx"\
    />\
</div>\
    ',
    data: function(){
        return{
            listApi: "/event/evt_comment/api/util_comment_list.asp",
            actApi: "/event/evt_comment/api/util_comment_action.asp",
            comments: [],
            myComments: [],
            top3: [],
            userId: '',
            loginUserName: '',
            pagingData: {},
            isLogin: false,
            formData: {
                txtcomm: '',
                txtcomm2: '',
                txtcomm3: '',
                option1: '',
                option2: '',
                option3: ''
            },
            chkOptions: [
                'nullCheck',
                'lengthCheck'
            ],
            watchLengthTarget: {
                txtcomm: { watch: false, length: 10 },
                txtcomm2: { watch: false, length: 10 },
                txtcomm3: { watch: false, length: 10 },
            },
            chkResult: true,
            filterParam: ''
        }
    },
    props: {
        listQuery: {
            type: Object,
            default: function(){
                return {
                    currentPage: 1,
                    eventCode: 0,
                    likeId: 0,
                    filterTxt: ''
                }
            }
        },
        inputValidation: {
            type: Array,
            default: function(){
                return []
            }
        },
        chkColName: {
            type: String,
            default: ''
        },
        chkAlertMsg: {
            type: String,
            default: ''
        }
    },
    methods: {
        getCommentList: function(cb){
            this.listQuery.filterTxt = this.getParameterByName('filterparam') || this.listQuery.filterTxt
            this.filterParam = this.getParameterByName('filterparam')
            this.resetCurrentUrl()
            $.ajax({
                type: "GET",
                url: this.listApi,
                data: this.listQuery,
                dataType: "json",
                cache: false,
                success: function(data, status){
                    var tmpKeyArr = [];
                    if (status == "success") {
                        for( var key in data ) {
                            this.$data[key] = data[key]
                            tmpKeyArr.push(key)
                        }
                    } else {
                        console.error('데이터를 받아오는데 실패하였습니다.')
                    }
                    if(this.listQuery.filterTxt != ''){
                        fnAmplitudeEventMultiPropertiesAction('click_comment_search', 'evtcode|keyword', this.listQuery.eventCode + '|' + this.listQuery.filterTxt)
                    }
                    if(cb != undefined && cb instanceof Function) cb(data);
                }.bind(this),
                error: function(e){
                    // console.log(e)
                    console.error('데이터를 받아오는데 실패하였습니다.')
                }
            })
        },
        getParameterByName: function(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(url);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        },
        getQueryStringObject: function(){
            var a = window.location.search.substr(1).split("&");

            if (a == "") return {};
            var b = {};
            for (var i = 0; i < a.length; ++i) {
              var p = a[i].split("=", 2);
              if (p.length == 1) b[p[0]] = "";
              else b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "));
            }
            return b;
        },
        getQueryStringFromObject: function (obj) {
            if (Object.keys(obj).length === 0 && obj.constructor === Object) return "";
            var result = "?";
            for (var key in obj) {
              result += key + "=" + obj[key] + "&";
            }
            result = result.substr(0, result.length - 1);
            return result;
        },
        resetCurrentUrl: function(){
            var tmpObj = this.getQueryStringObject()
            delete tmpObj.filterparam
            var queryStr = this.getQueryStringFromObject(tmpObj)
            history.replaceState({}, "", location.pathname + queryStr);
        },
        setComma: function(x){
            return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        },
        printUserName: function(name, num, replaceStr){
            return name.substr(0,name.length - num) + replaceStr.repeat(num)
        },
        dispUserId: function(subTxt){
            return this.userId ? this.userId : subTxt
        },
        dispUserName: function(subTxt){
            return this.loginUserName ? this.loginUserName : subTxt
        },                
        linkLogin: function(){
            var url = window.location.pathname + window.location.search;
            if(isapp == 1){
                calllogin();
                return false;
            }else{
                jsChklogin_mobile('',url);
            }
        },
        loginChk: function(){
            if(!this.isLogin){
                this.linkLogin()
                return false;
            }
        },
        movePage: function(pageNumber){
            this.listQuery.currentPage = pageNumber
            this.getCommentList()
            window.location.href="#cmtTop"
        },
        handleClickPageNumber: function(pageNum){
            this.movePage(pageNum)
        },
        dispPageNumber: function(pageNum){
            return this.pagingData.scrollcount * (this.blockNum - 1) + pageNum
        },
        handleClickNextArrow: function(){
            this.movePage(this.endPage + 1)
        },
        handleClickPreArrow: function(){
            this.movePage(this.startPage - 1)
        },
        req: function(param, cb){
            if(!this.isLogin){
                this.linkLogin()
                return false;
            }
            $.ajax({
                type: "POST",
                url: this.actApi,
                data: param,
                success: function(data){
                    if(cb != undefined && cb instanceof Function) cb(data);
                }.bind(this),
                error: function(e){
                    console.error(e)
                }
            })
        },
        updateLikeCnt: function(id, likeCnt){
            if(id == "" || id== undefined) return false;
            this.req({
                mode: "like",
                commidx: id,
                likeCnt: likeCnt,
                eventCode: this.listQuery.eventCode
            })
        },
        deleteContent: function(id){
            if(id == "" || id== undefined) return false;
            if(!confirm('삭제 하시겠습니까?')) return false;
            this.req({
                mode: "del",
                commidx: id,
                eventCode: this.listQuery.eventCode
            }, this.getCommentList)
        },
        /**
         *
         * @param {String} mode - 행위구분 util_comment_action.asp 참조
         * @param {Number} commentNum - 하루 허용 댓글 수
         * @param {Function} cb - 콜백함수
         */
        submitComment: function(mode, commentNum, cb){
            this.chkResult = true
            this.executeDataValidation()
            if(!this.chkResult) return false;

            var param = {
                mode: mode,
                commentNum: commentNum,
                eventCode: this.listQuery.eventCode,
                chkColName: this.chkColName,
            }
            for(var key in this.formData){
                param[key] = this.formData[key]
            }
            this.req(param, function(data){
                if(data.response == 'ok'){
                    this.getCommentList()
                    this.resetForm()
                    window.location.href="#cmtTop"
                }else if(data.response == 'err'){
                    if(data.message == 'dup'){
                        alert(this.chkAlertMsg)
                    }else{
                        alert(data.message)
                    }
                }
                if(cb != undefined && cb instanceof Function) cb(data.response)
            }.bind(this))
        },
        /**
         *
         * @param {String} stype - 쿠폰타입 ','로 구분 ex) evtsel,evtsel
         * @param {String} idx - 쿠폰 idx ','로 구분 ex) 2903,2909
         * @param {Function} cb - 콜백함수
         * @returns {(String | Number)} - 11(발급), 12(유효하지않은쿠폰), 13(이미 받음)
         */
        downCoupon: function(stype, idx, cb){
            var res
            $.ajax({
                type: "POST",
                url: "/event/etc/coupon/couponshop_process.asp",
                data: "mode=cpok&stype="+stype+"&idx="+idx,
                dataType: "text",
                success: function(str){
                    var str1 = str.split("||")
                    res = str1[0]
                    if(cb != undefined && cb instanceof Function) cb(res);
                },
                error: function(data){
                    alert('오류가 발생했습니다.');
                }
            })
        },
        resetForm: function(){
            for(var key in this.formData){
                this.formData[key] = ""
            }
        },
        /**
         * 유효성 체크
         */
        executeDataValidation: function(){
            var dataKey = ""
            this.inputValidation.forEach(function(o){
                dataKey = o['dataKey']
                this.chkOptions.forEach(function(option){
                    if(!this.chkResult) return false
                    this.dispatcher(dataKey, option, o[option])
                }.bind(this));
            }.bind(this));
        },
        dispatcher: function(dataKey, option, optionObj){
            if(option == "nullCheck"){
                this.checkNull(dataKey, optionObj['message'], optionObj['cb'])
            }else if(option == "lengthCheck"){
                this.checkLength(dataKey, optionObj['maxlength'], optionObj['message'])
            }
        },
        checkNull: function(datakey, message, cb){
            if(this.formData[datakey] == ''){
                alert(message)
                this.$parent.$refs[datakey].focus()
                this.chkResult = false
                if(cb != undefined && cb instanceof Function) cb();
                return false;
            }
            return true
        },
        checkLength: function(datakey, txtLeng, message){
            if(this.formData[datakey].length > txtLeng){
                alert(message)
                this.$parent.$refs[datakey].focus()
                this.chkResult = false
            }
        },
        setLenWatchedData: function(){
            var dataKey = ""
            this.inputValidation.forEach(function(o){
                dataKey = o['dataKey']
                this.chkOptions.forEach(function(option){
                    if(option == "lengthCheck"){
                        this.watchLengthTarget[dataKey] = o[option]['lengthWatch'] == true ?
                        { watch: true, length: o[option]['maxlength'] } : { watch: false, length: 10 }
                    }
                }.bind(this));
            }.bind(this));
        },
        splitComment: function(dataKey){
            if(this.watchLengthTarget[dataKey]['watch']){
                var leng = this.watchLengthTarget[dataKey]['length']
                this.formData[dataKey] =  this.formData[dataKey].length > leng ? this.formData[dataKey].substr(0, leng) : this.formData[dataKey]
            }
        },
        chkDataDuplication: function(alertMsg){
            if(alertMsg == undefined) alert('빈칸을 확인해주세요.')
            if(!this.checkNull(this.chkColName, alertMsg)) return false;

            // es5 이하버전 객체병합
            var tmpKey = this.chkColName
            var tmpObj = {}
            tmpObj[tmpKey] = this.formData[this.chkColName]

            var param = {
                mode: 'chkdup',
                eventCode: this.listQuery.eventCode,
                chkColName: this.chkColName
                // [this.chkColName]: this.formData[this.chkColName] // es5 ^
            }
            for (var key in tmpObj) { param[key] = tmpObj[key]; }

            // console.log(param)
            this.req(param, function(data){
                if(data.response == 'err'){
                    if(data.message == 'dup'){
                        alert(this.chkAlertMsg)
                        return false
                    }
                }
                alert('사용 가능합니다.')
            }.bind(this))
        }
    },
    created: function(){
        this.getCommentList();
    },
    mounted: function(){
        this.setLenWatchedData()
    },
    computed: {
        /**
         * 페이징 데이터
         */
        totalScrollCnt: function(){
            return Math.ceil(this.pagingData.totalpage / this.pagingData.scrollcount)
        },
        startPage: function(){
            return Math.floor((this.pagingData.currpage - 1) / this.pagingData.scrollcount) * this.pagingData.scrollcount + 1
        },
		endPage: function(){
            var tmpEndPage = this.blockNum < this.totalScrollCnt ?
            Math.floor((this.pagingData.currpage - 1) / this.pagingData.scrollcount) * this.pagingData.scrollcount + this.pagingData.scrollcount
            :
            this.pagingData.totalpage

            return tmpEndPage
        },
        isPreArrowButton: function(){
            return this.pagingData.currpage > this.pagingData.scrollcount
        },
        isNextArrowButton: function(){
            return this.blockNum < this.totalScrollCnt
        },
        pageIdx: function(){
            if(this.pagingData.scrollcount == undefined) return 0;
            var r = this.endPage % this.pagingData.scrollcount
            return r != 0 ? r : this.pagingData.scrollcount
        },
        blockNum: function(){
            return Math.ceil(this.pagingData.currpage / this.pagingData.scrollcount)
        },
        /**
         * 폼 데이터
         */
        txt1Length: function(){
            this.splitComment('txtcomm')
            return this.formData.txtcomm.length
        },
        txt2Length: function(){
            this.splitComment('txtcomm2')
            return this.formData.txtcomm2.length
        },
        txt3Length: function(){
            this.splitComment('txtcomm3')
            return this.formData.txtcomm3.length
        }
    },
})
