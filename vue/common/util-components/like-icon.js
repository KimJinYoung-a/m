Vue.component('like-icon', {
    template: '\
    <div>\
            <slot name="likeIcon"\
                :is-like-click="isLikeClick"\
                :my-like-cnt="myLikeCnt"\
                :handle-click-like-btn="handleClickLikeBtn"\
                :like-cnt="likeCnt"\
                :initial-state="initialState"\
            />\
        </div>\
    </div>\
    ',
    data: function(){
        return {
            likeApI: '/apps/appCom/wish/webapi/like/like.asp',
            initialState: true,
            isLikeClick: false,
            isMaxLike: false,            
            accumulatedLikeCnt: 0,
            randomNumber: 0,
        }
    },
    props: {
        likeCnt: {
            type: Number,
            default: 0
        },
        myLikeCnt: {
            type: Number,
            default: 0
        },
        likeId: {
            type: Number,
            default: 0
        },
        isLogin: {
            type: Boolean,
            default: false
        },
        contentsSubId: {
            type: Number,
            default: 0
        },
        afterLikeCallback: {
            type: Function,
            default: function(){
                console.log('default')
            }
        },
        lyrClassName: {
            type: String,
            default: ""
        },
        maxLikeLimit: {
            type: Number,
            default: 30
        }
    },
    methods: {
        handleClickLikeBtn: function(){
            if(!this.isLogin){
                this.linkLogin()
                return false;
            }
            if(this.isMaxLike){
                this.showLikeCount()
                this.randomNumber = this.getRandomKey()
                return false;
            }
            if(this.myLikeCnt >= this.maxLikeLimit){
                this.popupMaxLikeLayer()
                console.log('wow')
            }else{
                // this.isIconClicked = !this.isIconClicked
                this.accumulatedLikeCnt++
                this.$emit('update:likeCnt', this.likeCnt + 1)
                this.$emit('update:myLikeCnt', this.myLikeCnt + 1)
                this.showLikeCount()
            }
        },
        showLikeCount: function(){
            this.isLikeClick = true;
            this.initialState = false;
            this.$parent.$refs['cnt'].forEach(function(el){
                if(el['accessKey'] == this.contentsSubId) el.style.display = 'block';
            }.bind(this));
        },
        popupMaxLikeLayer: function(){
            $("."+this.lyrClassName).delay(300).show(0).delay(2000).fadeOut(300);
            this.isMaxLike = true
            return false;
        },
        setLikeClass: function(flag){
            this.isLikeClick = flag;
        },
        getRandomKey: function(){
            var ranNum = Math.floor(Math.random() * (26243 - 1) + 1)
            return "key-" + ranNum
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
        plusLike: function(){
            if(this.accumulatedLikeCnt == 0) return false;
            $.ajax({
                type: "POST",
                url: this.likeApI,
                data: {
                    likeId: this.likeId,
                    contentsSubId: this.contentsSubId,
                    likeCnt: this.accumulatedLikeCnt
                },
                success: function(data){
                    if(data.response == "loginerr"){
                        this.linkLogin()
                    }else if(data.response == "ok"){
                        this.afterLikeCallback(this.contentsSubId ,this.accumulatedLikeCnt)
                    }
                }.bind(this),
                error: function(e){
                    console.log(e)
                }
            })
            // if success
            window.setTimeout(function(){
                this.accumulatedLikeCnt = 0
            }.bind(this), 300)
            this.setLikeClass(false);
        }
    },
    watch: {
        myLikeCnt: _.debounce(function(){
            this.plusLike()
        }, 1200),
        randomNumber: _.debounce(function(){
            this.setLikeClass(false)
        }, 1200)
    }
})
