Vue.component('Alert', {
    template : `
        <div class="layer">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2021/110409/m/pop_push.png" alt="알림 신청 완료"></p>
            <button class="btn-setting" onclick="fnAPPpopupSetting();return false;">PUSH 설정 확인하기</button>
            <button type="button" @click="close_modal" class="btn-close">닫기</button>
        </div>
    `,
    methods : {
        close_modal() {
            this.$emit('close_modal', 'alert_modal');
        }
    }
});