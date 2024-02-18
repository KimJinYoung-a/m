Vue.component('Product-Name',{
    template : `<div :class="get_name_class" v-html="item_name"></div>`,
    props : {
        item_name : { type : String, default : '' }, //상품명
        is_omit : { type : Boolean, default : false }, //말줄임 여부
    },
    computed: {
        get_name_class() {
            return 'prd_name' + (this.is_omit ? ' ellipsis2' : '');
        }
    }
})