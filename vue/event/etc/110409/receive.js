Vue.component('Receive', {
    template : `
        <div class="layer">
            <div :class="{'last': last_yn}">
                <p><img :src="check_image" alt="발도장 찍기 성공"></p>
                <span class="today"><em id="today-mileage-value">{{mileage_amount}}</em>p</span>
                <span v-if="!last_yn" class="tomorrow"><em id="tomorrow-mileage-value">{{tomorrow_mileage}}</em>p</span>
                <button v-if="!last_yn" @click="request_push" type="button" class="btn-push">알림 신청하기</button>
                <a v-else @click="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110211');return false;" class="link">텐바이텐 세일 구경하기</a>
                <button type="button" @click="close_modal" class="btn-close">닫기</button>
            </div>
        </div>
    `,
    props: {
        last_yn : {type:Boolean, default:false}, // 마지막 날 여부
        mileage_amount : {type:Number, default:0}, // 마일리지 금액
    },
    computed : {
        check_image() {
            return `//webimage.10x10.co.kr/fixevent/event/2021/110409/m/pop_check${this.last_yn ? '_last' : ''}.png`;
        },
        tomorrow_mileage() {
            return this.mileage_amount + 100;
        }
    },
    methods : {
        request_push() {
            this.$emit('request_push');
        },
        close_modal() {
            this.$emit('close_modal', 'receive_modal');
        }
    }
});