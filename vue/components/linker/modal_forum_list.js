Vue.component('MODAL-FORUM-LIST', {
    template : `
        <div id="modalForumList" class="modalV20 modal_type5 show" style="-webkit-overflow-scrolling: touch;">
            <div class="modal_overlay md_white"></div>
            <div class="modal_wrap modal_forum modal_full">
                <div class="modal_header">
                    <h2>모달</h2>
                    <button @click="$emit('closeModal')" class="btn_close"><i class="i_close"></i>모달닫기</button>
                </div>
                <div class="modal_body">
                    <div class="modal_cont forum_conts list_view">
                        <ul class="forum_list_view">
                            <li v-for="forum in forumList" class="list" :style="getBackgroundImage(forum)" @click="forumMove(forum)">
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
            </div>
        </div>
    `,
    props : {
        forumList : {
            type: Array,
            default: null
        }
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
        //region close 모달 닫기
        close() {
            this.$emit("closeModal");
        },
        //endregion
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
            location.replace('?idx=' + forum.forumIdx);
        }
    }
});