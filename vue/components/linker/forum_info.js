Vue.component('FORUM-INFO', {
    template : `
        <div class="forum_top" :style="forumTopStyle">
            <p class="h_txt">{{forum.subTitle}}</p>
            <h2 v-html="forum.title" v-show="!showDescription"></h2>
            <p class="h_sub" v-html="forum.description"></p>
            <template v-if="descriptions.length === 1">
                <div class="forum_ex_only"></div>
                <button type="button" v-show="!showDescription" @click="viewDetail" :class="['btn_detail', {on:!showDescription}]">자세히보기</button>
                <div class="pop_forum_detail" v-show="showDescription">
                    <div v-html="getDescriptionContent"></div>
                    <button @click="showDescription = false" type="button" class="btn_pop_forum_close">닫기</button>
                </div>
            </template>
            <div v-else-if="descriptions.length > 1" class="forum_ex_multi">
                <div class="list_wrap">
                    <div v-if="forumIndex === 1" class="list" @click="goSaleEvent"><p>40% 쿠폰을 준다구?<br>20주년 세일 시작!</p></div>
                    <div v-for="description in descriptions" class="list" @click="openForumDescription(description)"><p v-html="description.title"></p></div>
                </div>
            </div>
            <button type="button" v-show="showDescription" @click="showDescription = !showDescription" class="btn_detail close">접기</button>
            <button type="button" class="btn_forum_menu" @click="openForumList">
                <img src="http://fiximage.10x10.co.kr/web2021/anniv2021/m/icon_menu.png" alt="포럼 목록 menu">
                <div class="num">{{numberFormat(forumCnt)}}</div>
            </button>
            <div class="talk_bubble">다른 텐텐토크 보러가기</div>
        </div>
    `,
    data() {return {
        showDescription : false, // 설명 노출 여부
        title : ''
    }},
    mounted() {
        const _self = this;
        // 텐텐 토크 숨김 처리
        setTimeout(function() {
            _self.talkBubbleHide();
        },
         5000);
    },
    props : {
        forumIndex : { type:Number, default:0 }, // 포럼 일련번호
        //region forum 포럼
        forum : {
            'title' : { type:String, default:'' }, // 제목
            'subTitle' : { type:String, default:'' }, // 부 제목
            'description' : { type:String, default:'' }, // 부 제목
            'backgroundMediaType' : { type:String, default:'image' }, // 배경 유형
            'backgroundMediaValue' : { type:String, default:'' }, // 배경 값
            'descriptions' : { // 설명 리스트
                'infoIdx' : { type:Number, default:0 }, // 설명 일련번호
                'title' : { type:String, default:'' }, // 제목
                'content' : { type:String, default:'' } // 내용
            },
        },
        //endregion
        forumCnt : { type:Number, default: 0 }, // forum 개수
        //region descriptions 포럼 설명
        descriptions : {
                appTitle : { type:String, default:'' },     // app 제목
                appContent : { type:String, default:'' },   // app 내용
                mobileTitle : { type:String, default:'' },  // mobile 제목
                mobileContent : { type:String, default:'' },// mobile 내용
        },
        //endregion
    },
    computed : {
        //region forumTopStyle 포럼 정보 스타일
        forumTopStyle() {
            // TODO : 동영상 배경
            if( this.forum.backgroundMediaType === 'image' ) {
                return {'background' : 'no-repeat 50% 99% / cover url(' + this.forum.backgroundMediaValue + ')'}
            } else if( this.forum.backgroundMediaType === 'color' ) {
                return {'background' : this.forum.backgroundMediaValue}
            } else {
                return {};
            }
        },
        //endregion
    },
    methods : {
        //region viewDetail 자세히 보기
        viewDetail() {
            this.showDescription = true;
        },
        //endregion
        //region openForumDescription 포럼 설명 모달 열기
        openForumDescription(description) {
            fnAmplitudeEventMultiPropertiesAction("click_forum_info","forum_index|info_index", `${this.forumIndex}|${description.infoIdx}`);
            this.$emit('openForumDescription', description.content);
        },
        //endregion
        //region setDescriptionTitle 포럼 설명 타이틀 정의
        setDescriptionTitle(description) {
            let title = '';
            if (this.linkerApp) {
                title = description.appTitle;
            } else {
                title = description.mobileTitle;
            }
            return title;
        },
        //endregion
        //region goSaleEvent 정기세일 이벤트 이동
        goSaleEvent() {
            if( this.linkerApp )
                fnAPPpopupEvent(113925);
            else
                location.href = '/event/eventmain.asp?eventid=113925';
        },
        //endregion
        //region openForumList 포럼 리스트 열기
        openForumList() {
            if (this.linkerApp) {
                fnAPPpopupBrowserURL('', wwwUrl + '/apps/appCom/wish/web2014/linker/forums.asp');
            } else {
                this.$emit('openForumList');
            }
            setTimeout(() => fnAmplitudeEventMultiPropertiesAction("click_forum_list","forum_index",forumIndex.toString()), 500);
        },
        //endregion
        // region talkBubbleHide 문구 노출 숨김 처리
        talkBubbleHide() {
            $(".talk_bubble").hide();
        },
        // endregion
        //region getDescriptionContent 포럼 설명 내용
        getDescriptionContent() {
            let result = '';
            if (this.linkerApp) {
                result = this.descriptions[0].appContent;
            } else {
                result = this.descriptions[0].mobileContent;
            }
        }
        //endregion
    }
});