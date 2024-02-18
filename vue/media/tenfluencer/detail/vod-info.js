Vue.component('vod-info', {
    template: '\
    <div>\
        <div class="vod-info">\
            <h2 class="info-tit">{{cTitle}}</h2>\
            <clap-icon\
                :is-login="isLogin"\
                :like-count="interLikeCount"\
                :my-like-count="interMyLikeCount"\
                :c-idx="cIdx"\
                :set-like-count="setLikeCount"\
                :is-shared-component="true"\
                :key="getRandomKey()"\
            ></clap-icon>\
            <div class="info-view">view {{setComma(viewCount)}}</div>\
            <div class="info-txt">{{contentText}}</div>\
            <div class="info-tags"\
                v-if="contentTag.length > 0">\
                <div class="swiper-container">\
                    <ul class="swiper-wrapper">\
                        <li class="swiper-slide"\
                            v-for="tag in contentTag"\
                        ><a @click="searchTag(tag)">#{{tag}}</a></li>\
                    </ul>\
                </div>\
            </div>\
        </div>\
        <div class="info-floating">\
            <div class="thm"\
                v-bind:style="{\'background-image\': \'url(\'+ mainImage +\')\'}">\
            <span class="badge"\
                v-if="isNew"\
            >NEW</span>\
            </div>\
            <button type="button" class="btn-go-video"\
                @click="scrollTop"\
            >영상으로 돌아가기</button>\
            <clap-icon\
                :is-login="isLogin"\
                :like-count="interLikeCount"\
                :my-like-count="interMyLikeCount"\
                :c-idx="cIdx"\
                :set-like-count="setLikeCount"\
                :is-shared-component="true"\
                :key="getRandomKey()"\
            ></clap-icon>\
        </div>\
        <!-- 박수 30번 축하 레이어 -->\
        <div class="ly-clap">\
            <div class="inner">\
                <div class="dots dots1"></div>\
                <div class="dots dots2"></div>\
                <div class="dots dots3"></div>\
                <div class="dots dots4"></div>\
                <div class="dots dots5"></div>\
                <div class="dots dots6"></div>\
                <div class="dots dots7"></div>\
                <div class="dots dots8"></div>\
                <div class="hand"></div>\
                <div class="heart"><i></i></div>\
            </div>\
            <div class="mask"></div>\
        </div>\
    </div>\
    ',
    props: {
        cIdx: {
            type: String,
            default: ''
        },
        isLogin: {
            type: Boolean,
            default: false
        },
        viewCount: {
            type: Number,
            default: 0
        },
        cTitle: {
            type: String,
            default: ""
        },
        likeCount: {
            type: Number,
            default: 0
        },
        myLikeCount: {
            type: Number,
            default: 0
        },
        contentText: {
            type: String,
            default: ""
        },
        isNew: {
            type: Boolean,
            default: false
        },
        contentTag: {
            type:Array,
            default: []
        },
        mainImage: {
            type: String,
            default: ""
        },
        setComma: {
            type: Function,
            default: function(){
                return false;
            }
        }
    },
    data: function(){
        return {
            interLikeCount: this.likeCount,
            interMyLikeCount: this.myLikeCount
        }
    },
    methods: {
        searchTag: function(tagName){
            if(isapp == 1){
                fnSearchEventText(tagName)
            }else{
                window.location.href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect="+tagName
            }
        },
        setLikeCount: function(likeCnt, myLikeCnt){
            this.interLikeCount = likeCnt
            this.interMyLikeCount = myLikeCnt
        },
        //랜덤 키값 리턴
        getRandomKey: function(){
            var ranNum = Math.floor(Math.random() * (26243 - 1) + 1)
            return "key-" + ranNum
        },
        scrollTop: function(){
            $('html, body').animate({scrollTop:0}, 'fast');
        }
    }
})


