Vue.component('Modal', {
    template: `
        <transition name="fade">
            <div :id="this_id" class="popup" v-show="show_yn">
                <slot name="body"></slot>
            </div>
        </transition>
    `,
    props : {
        this_id : {type : String, default : ''}, // 모달 ID
        show_yn : {type : Boolean, default : false} // 노출여부
    },
});