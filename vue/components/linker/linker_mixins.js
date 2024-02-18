const linker_mixin = Vue.mixin({
    computed : {
        linkerApp() {
            return isApp;
        }
    },
    methods: {
        //region goLoginPage 로그인 페이지 이동
        goLoginPage() {
            if( this.linkerApp )
                calllogin();
            else
                location.href = '/login/login.asp?backpath=' + location.pathname + location.search;
        },
        //endregion
        commonApiError(e) {
            console.log(e);
        },
        numberFormat(num){
            num = num.toString();
            return num.replace(/(\d)(?=(?:\d{3})+(?!\d))/g,'$1,');
        },
        openModal(modalId) {
            $('#' + modalId).addClass('show');
            $('#' + modalId + ' .modal_cont').animate({scrollTop : 0}, 0);
        },
        closeModal(modalId) {
            $('#' + modalId).removeClass('show');
        }
    }
});