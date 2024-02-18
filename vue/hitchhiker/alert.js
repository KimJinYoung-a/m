var hitchhiker_alert = {
    template : `
        <div class="modal_body">
            <div class="modal_cont alert">
                {{ msg }}
            </div>
			<div class="btn_block">
				<button class="btn_ten" @click="close_pop('alert')">확인</button>
			</div>
        </div>
    `,
    data() {
        return {}
    },
    props : {
        msg : { type : String, default : '' },
    },
    methods : {
        // close_modal() {}
    }
}