var likeCountUrl = "/apps/appcom/wish/webapi/media/setContentsLikeCountProc.asp";
var origin = '\
<div>\
    <div class="clap-wrap"\
        :class="[isLikeClick ? \'is-touched\' : \'\']"\
    >\
        <div class="count">{{c_myLikeCount}}</div>\
        <button type="button" class="btn-clap"\
            :class="dispLikeCountClass"\
            @click="handleClickLikeBtn"\
        >\
            <i>박수</i>\
            <span>{{dispLikeCount}}</span>\
        </button>\
    </div>\
</div>\
'
Vue.component('clap-icon', {    
    template: origin,
    props: {
        cIdx: {
            type: [String, Number],
            default: ''
        },
        isLogin: {
            type: Boolean,
            default: false
        },        
        likeCount: {
            type: Number,
            default: 0
        },        
        myLikeCount: {
            type: Number,
            default: 0
        },
        setLikeCount: {
            type: Function,
            default: function(){
                alert('default function')
            }
        },
        isSharedComponent: {
            type: Boolean,
            default: false
        }
    },
    data: function(){
        return {
            isLikeClick: false,
            c_likeCount: this.likeCount,
            c_myLikeCount: this.myLikeCount,
            c_isLogin: this.isLogin,
            isMaxLike: false,
            maxLikeLimit: 30,
            accumulatedLikeCnt: 0,
            randomNumber: 0            
        }
    },
    methods: {        
        handleClickLikeBtn: function(e){                               
            var currentElement = e.currentTarget            
            var $currentElement = $(currentElement);            

            if(!this.c_isLogin){
                this.linkLogin()
                return false;
            }
            if(this.isMaxLike == true){
                this.showLikeCount($currentElement)
                this.randomNumber = this.getRandomKey()
                return false;
            } 

            if(this.c_myLikeCount >= this.maxLikeLimit){
                this.popupMaxLikeLayer()
            }else{
                // this.isIconClicked = !this.isIconClicked
                this.c_likeCount++
                this.c_myLikeCount++
                this.accumulatedLikeCnt++                
                
                this.showLikeCount($currentElement)
            }            
        },        
        sparkleAnimation: function(currentElement){
            var point = "<div class='point'><span class='point-item'></span><span class='point-item'></span><span class='point-item'></span><span class='point-item'></span><span class='point-item'></span><span class='point-item'></span><span class='point-item'></span><span class='point-item'></span></div>";

            currentElement.siblings(".point").remove();
            currentElement.parent(".clap-wrap").append(point);                        
        },
        showLikeCount: function(currentElement){
            this.isLikeClick = true;  
            currentElement.siblings(".count").show()
            this.sparkleAnimation(currentElement)                                           
        },
        setLikeClass: function(flag){            
            this.isLikeClick = flag;
        },
        plusLike: function(){            
            var params = {
                cidx: this.cIdx, 
                device: 'M',
                likeCount: this.accumulatedLikeCnt
            };
            var url = likeCountUrl;
            var _this = this;
            // console.log(params)            

            $.getJSON(url, params, function (data, status, xhr) {                            
                if (status == "success") {                                      
                    if(data.response == "ok"){
                        console.log(data)
                        if(_this.isSharedComponent){
                            window.setTimeout(function(){
                                _this.handleLikeCount(_this.c_likeCount, _this.c_myLikeCount)                        
                            }, 300)                            
                        }                                            
                        _this.accumulatedLikeCnt = 0
                        _this.c_myLikeCount = data.myLikeCount;
                        _this.setLikeClass(false); 
                    }else if(data.faildesc == "login"){
                        _this.setLikeClass(false)
                        _this.c_isLogin = false
                        _this.linkLogin();
                    }else{
                        alert('시스템 오류입니다.');
                    } 
                }else{
                    console.log("JSON data not Loaded.");
                }
            });       
        },
        handleLikeCount: function(likeCnt, myLikeCnt){
            this.setLikeCount(likeCnt, myLikeCnt)
        },
        popupMaxLikeLayer: function(){
            $(".ly-clap").delay(300).show(0).delay(2100).hide(0); 
            this.isMaxLike = true
            return false;          
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
        getRandomKey: function(){
            var ranNum = Math.floor(Math.random() * (26243 - 1) + 1)
            return "key-" + ranNum
        }                                        
    },
    computed: {
        dispLikeCount: function(){
            return this.c_likeCount == 0 ? "짝짝짝" : this.c_likeCount;
        },
        dispLikeCountClass: function(){
            return this.c_likeCount == 0 ? "" : "on";
        }
    }, watch: {
        c_likeCount: _.debounce(function(){                        
            this.plusLike()            
        }, 1200),                
        randomNumber: _.debounce(function(){                        
            this.setLikeClass(false)            
        }, 1200)                
    }    
})    
