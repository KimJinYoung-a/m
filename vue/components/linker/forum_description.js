Vue.component('FORUM_DESCRIPTION', {
    template : `
        <div class="modal_body">
            <div class="modal_cont forum_conts">
                <p v-html="content"></p>
            </div>
        </div>
    `,
    data() {return {
        'content' : ''
    }},
    methods : {
        setDescription(content) {
            this.content = content;
        }
    }
});