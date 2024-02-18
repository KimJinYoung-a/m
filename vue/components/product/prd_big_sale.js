Vue.component('Product-Big-Sale', {
    template : `
        <a href="#" @click="click" class="mApp bnr_big">
            <img src="//fiximage.10x10.co.kr/m/2021/banner/bnr_big_smsale.png?v=2" alt="가장큰 세일">
        </a>
    `,
    props : {
        isApp : { type:Boolean, default:false },
    },
    methods : {
        click() {
            if( this.isApp )
                fnAPPpopupBrowserURL('기획전',vueAppUrlSsl + '/apps/appCom/wish/web2014/event/eventmain.asp?eventid=116957');
            else
                location.href = '/event/eventmain.asp?eventid=116957';
        }
    }
})