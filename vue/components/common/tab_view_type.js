Vue.component('Tab-View-Type',{
    template : `
            <!-- 뷰 타입 탭 -->
            <div class="tab_view_type">
                <button @click.prevent="change_view_type('detail')" type="button" :class="['btn_view_type', {active : view_type == 'detail'}]">
                    <i class="i_list_detail"></i>자세히
                </button>
                <button @click.prevent="change_view_type('photo')" type="button" :class="['btn_view_type', {active : view_type == 'photo'}]">
                    <i class="i_list_photo"></i>사진만
                </button>
            </div>
    `,
    props : {
        view_type : { type : String, default : 'detail'}  // 뷰 타입 default - 자세히
    },
    methods : {
        // 뷰타입 전환
        change_view_type : function (type) {
            this.$emit('change_view_type', type);
        }
    }
})