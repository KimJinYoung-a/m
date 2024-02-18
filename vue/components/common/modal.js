Vue.component('Modal',{
    template : `
            <!-- 모달 -->
            <div :id="modal_id" :class="'modalV20 modal_type' + type">
                <div @click="close_modal" class="modal_overlay"></div>
                <div class="modal_wrap">
                    <div class="modal_header">
                        <h2>모달</h2>
                        <button class="btn_close" @click="close_modal"><i class="i_close"></i>모달닫기</button>
                    </div>
                    <component
                        :is="content"
                        ref="content"
                        :parameter="parameter"
                        :isApp="isApp"
                        @modal_paging="modal_paging"
                        @wish_product="wish_product"
                    ></component>
                </div>
            </div>
    `,
    props : {
        isApp : {type : Boolean , default : false}, // 앱 여부
        type : {type : Number, default:0}, // 모달 type 1~4
        content : {type: [Object , String ] , default:function(){return {};}}, // 모달 내용 컴포넌트
        parameter : {type : [Object , Array] , default:function(){return {};}}, // 모달 내용으로 넘길 파라미터
        modal_id : {type:String, default:'modal'}, // 모달 ID
    },
    methods : {
        refresh() {
            this.$refs.content.refresh();
        },
        modal_paging(parameter) {
            this.$emit('modal_paging', parameter);
        },
        close_modal() {
            this.close_pop(this.modal_id);
            this.$emit('close_modal');
            if( this.$refs.content.close_modal != null ) {
                this.$refs.content.close_modal();
            }
        },
        wish_product(wish_info) {
            console.log('wish_product', wish_info);
            this.$emit('wish_product', wish_info);
        }
    }
});