let store = new Vuex.Store({
    state : {
        //region forum 포럼
        'forum' : {
            'title' : '', // 제목
            'subTitle' : '', // 부 제목
            'description' : '', // 포럼 설명
            'backgroundMediaType' : '', // 배경 유형
            'backgroundMediaValue' : '', // 배경 값
            'descriptions' : [] // 설명 리스트
        },
        //endregion
        myProfile : {
            'userId' : '',
            'auth' : 'N',
            'avataNo' : '0',
            'description' : null,
            'image' : null,
            'nickName' : '',
            'levelName' : '',
            'nickNameRecommendation' : null,
            'registration' : false
        },
        //region descriptions 포럼 설명
        descriptions : [
            {
                appTitle : '',      // app 제목
                appContent : '',    // app 내용
                mobileTitle : '',   // mobile 제목
                mobileContent : '', // mobile 내용
            }
        ],
        //endregion
        forumCount: 0, // 포럼 수
        forumList: [], // 포럼 목록
        myClapCounts : {}, // 내 박수 정보
    },
    getters : {
        forum(state) { return state.forum; },
        myProfile(state) { return state.myProfile; },
        forumList(state) { return state.forumList; },
        forumCount(state){ return state.forumCount; },
        descriptions(state) { return state.descriptions; },
        myClapCounts(state) { return state.myClapCounts; },
    },
    mutations : {
        //region SET_FORUM Set 포럼
        SET_FORUM(state, payload) {
            state.forum.title = payload.title;
            state.forum.subTitle = payload.subTitle;
            state.forum.description = payload.description;
            state.forum.backgroundMediaType = payload.backgroundMediaType;
            state.forum.backgroundMediaValue = decodeBase64(payload.backgroundMediaValue);
        },
        //endregion
        //region SET_MY_PROFILE Set 내 프로필
        SET_MY_PROFILE(state, payload) {
            state.myProfile = payload;
        },
        //endregion
        //region SET_FORUMS Set 포럼
        SET_FORUMS(state, payload) {
            state.forumList = payload.forums;
            state.forumCount = payload.forumCount;
        },
        //endregion
        //region SET_DESCRIPTIONS Set 포럼
        SET_DESCRIPTIONS(state, payload) {
            state.descriptions = payload;
        },
        //endregion
        //region SET_MY_CLAP_COUNTS Set 내 박수 갯수 리스트 조회
        SET_MY_CLAP_COUNTS(state, counts) {
            state.myClapCounts = counts;
        },
        //endregion
        PUT_MY_CLAP_COUNTS(state, idx) {
            state.myClapCounts[idx] = 1;
        },
        ADD_MY_CLAP_COUNTS(state, idx) {
            state.myClapCounts[idx]++;
        },
    },
    actions : {
        //region GET_FORUM_INFO Get 포럼 정보
        GET_FORUM_INFO(context, forumIndex) {
            const success = function(data) {
                context.commit('SET_FORUM', data);
            }
            getFrontApiDataV2('GET', '/linker/forum/' + forumIndex, null, success);
        },
        //endregion
        //region GET_MY_PROFILE Get 내 프로필
        GET_MY_PROFILE(context) {
            const success = function(data) {
                context.commit('SET_MY_PROFILE', data);
            }

            getFrontApiData('GET', '/user/profile', null, success, function() {});
        },
        //endregion
        //region GET_FORUMS Get 포럼 리스트
        GET_FORUMS(context) {
            const success = function(data) {
                context.commit('SET_FORUMS', data);
            }
            getFrontApiDataV2('GET', '/linker/forums', null, success, function() {});
        },
        //endregion
        //region GET_DESCRIPTIONS Get 포럼 설명 목록
        GET_DESCRIPTIONS(context, isApp) {
            const success = function(data) {
                context.commit('SET_DESCRIPTIONS', data);
            }
            const url = `/linker/forum/descriptions/${forumIndex}/device/${isApp ? 'APP' : 'MOBILE'}`;
            getFrontApiDataV2('GET', url, null, success);
        },
        //endregion
        //region GET_MY_CLAP_COUNTS Get 내 박수 갯수 리스트 조회
        GET_MY_CLAP_COUNTS(context) {
            getFrontApiDataV2('GET', '/linker/clap/my/count', null,
                    data => context.commit('SET_MY_CLAP_COUNTS', data));
        },
        //endregion
    }
});

const decodeBase64 = function(str) {
    if( str == null ) return null;
    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
}