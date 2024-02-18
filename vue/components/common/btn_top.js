Vue.component('Button-Top',{
    template : `
            <!-- 탑 버튼 -->
            <button @click="move_top" type="button" id="btn_top" class="btn_top" style="display:none;">
                <i class="i_arw_line_r"></i><span class="blind">맨위로</span>
            </button>
    `,
    mounted() {
        let timeout;
        let lastScrollTop = 0;
        window.addEventListener('scroll', function () {
            if ($(window).scrollTop() <= lastScrollTop){ //스크롤 다운
               // 화면크기만틈 아래로 스크롤 하면 탑버튼 노출
               if( $(window).scrollTop() >= $(window).height() ) {
                   if( timeout !== undefined )
                       clearTimeout(timeout); // 스크롤 시 timeout 취소

                   $('#btn_top').fadeIn('fast');

                   // 5초간 아무 행동 하지 않으면 탑버튼 숨김
                   timeout = setTimeout(function() {
                       $('#btn_top').fadeOut('fast');
                   }, 5000);
               }
            }

            lastScrollTop = $(window).scrollTop();
        });
    },
    methods : {
        move_top() { // 탑으로 이동
            $('html, body').animate({scrollTop:0}, 'fast');
        }
    }
})