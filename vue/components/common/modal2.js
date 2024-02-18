Vue.component('Modal',{
    template : `
            <!-- 모달 -->
            <div :id="modal_id" :class="'modalV20 modal_type' + type">
                <div @click="close_modal" class="modal_overlay"></div>
                <div :class="['modal_wrap', {'modal_forum':linker}]">
                    <div class="modal_header">
                        <h2>모달</h2>
                        <button class="btn_close" @click="close_modal"><i class="i_close"></i>모달닫기</button>
                    </div>
                    
                    <!-- Body -->
                    <slot name="body"></slot>
                </div>
            </div>
    `,
    data() {return {
        currentY : 0 // 현재 Y 좌표
    }},
    props : {
        isApp : {type : Boolean , default : false}, // 앱 여부
        type : {type : Number, default:0}, // 모달 type 1~4
        modal_id : {type:String, default:'modal'}, // 모달 ID
        linker : {type:Boolean, default:false}, // 링커 모달 여부
    },
    methods : {
        close_modal() {
            this.close_pop(this.modal_id);
            this.$emit('close_modal');
        }
    }
});