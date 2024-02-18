
const app = new Vue({
    el : '#app',
    mixins: [linker_mixin, modal_mixin],
    template : `
        <div style="overflow:scroll-y;">
            <div class="modal_cont forum_conts list_view">
                <ul class="forum_list_view">
                    <li v-for="forum in getForumData.forums" class="list" :style="getBackgroundImage(forum)" @click="forumMove(forum)">
                        <p class="tit">{{forum.subTitle}}</p>
                        <p class="txt" v-html="forum.title"></p>
                        <!-- 신규일때 노출 -->
                        <span v-if="forumIconClass(forum) === 'new'" class="icon_noti new">
                            <img src="http://fiximage.10x10.co.kr/web2021/anniv2021/m/icon_new.png" alt="new">
                        </span>
                        <!-- 종료시 노출 -->
                        <span v-if="forumIconClass(forum) === 'close'" class="icon_noti close">
                            <img src="http://fiximage.10x10.co.kr/web2021/anniv2021/m/icon_txt_close.png" alt="종료">
                        </span>
                        <div v-if="forumIconClass(forum) === 'close'" class="dim"></div>
                        <!-- bg가 영상일때 노출 -->
                        <div class="video_wrap" v-if="forum.backgroundMediaType === 'video'">
                            <video loop="" autoplay="" muted="">
                                <source :src="decodeBase64(forum.backgroundMediaValue)" type="video/mp4"">
                            </video>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    `,
    data() {return {
        forumList : {
            forums: {
                backgroundMediaType: {type:String, default: ''},
                backgroundMediaValue: {type:String, default: ''},
                subTitle: {type:String, default: ''},
                title: {type:String, default: ''},
            }
        }
    }},
    //region mounted
    mounted() {
        this.getForumList();
    },
    //endregion
    computed : {
        getForumData() {
            return this.forumList;
        }
    },
    methods : {
        getForumList() {
            const _self = this;
            const success = function(data) {
                _self.forumList = data;
            }
            getFrontApiDataV2('GET', '/linker/forums', null, success, function() {});
        },
        // new, 종료 icon 처리
        forumIconClass(forum) {
            let result = "";
            let now = new Date();
            let startDate = new Date(forum.startDate);
            let endDate = new Date(forum.endDate);
            if (startDate >= now || endDate <= now) {
                result = "close";
                return result;
            }
            let newIcon = new Date(forum.startDate);
            newIcon.setDate(newIcon.getDate() + 14);
            if (newIcon >= now) {
                result = "new"
            }
            return result;
        },
        // 배경 이미지
        getBackgroundImage(forum) {
            const _self = this;
            let result = {};
            if (forum.backgroundMediaType === 'image') {
                result = {
                    'background-image': 'url(' + _self.decodeBase64(forum.backgroundMediaValue) + ')'
                }
            } else if (forum.backgroundMediaType === 'color') {
                result = {
                    'background-color' : _self.decodeBase64(forum.backgroundMediaValue)
                }
            }
            return result;
        },
        decodeBase64(str) {
            if( str == null ) return null;
            return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
        },
        // 포럼 이동
        forumMove(forum) {
            fnAmplitudeEventMultiPropertiesAction("click_forum","forum_index",forum.forumIdx.toString());

            if (this.linkerApp) {
                setTimeout(() => fnAPPpopupBrowserRenewal('push', '😘💬', wwwUrl + '/apps/appCom/wish/web2014/linker/forum.asp?idx=' + forum.forumIdx), 300);
            } else {
                setTimeout(() => location.replace('/linker/forum.asp?idx=' + forum.forumIdx), 300);
            }
        }
    }
});