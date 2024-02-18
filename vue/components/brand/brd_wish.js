Vue.component('Brand-Wish',{
    template : `
            <!-- 브랜드 위시(찜브랜드) -->
            <button type="button" :class="get_wish_class(wish_yn)">위시 해제</button>
    `,
    props : {
        wish_yn : Boolean
    },
    methods : {
        get_wish_class : function(wish_yn) {
            return wish_yn ? 'btn_wish_on' : 'btn_wish_off';
        }
    }
})