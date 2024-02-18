Vue.component('Modal',{
    template : `
        <transition name="fade">
            <div class="popup" @click="close_modal" v-show="is_show">
                <div class="inner">
                    <slot name="body"></slot>
                    <button @click="close_modal" type="button" class="btn-close">닫기</button>
                </div>
            </div>
        </transition>
    `,
    props : {
        is_show : false
    },
    methods : {
        close_modal() {
            this.$emit('close_modal');
        }
    }
});