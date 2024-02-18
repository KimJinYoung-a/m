Vue.component('Button-Top-Best',{
    template : `
        <div id="btn_top" style="display: none">
            <!-- 탑 버튼 -->
            <button @click="move_top" type="button" :class="['btn_top', 'btn_best', {on : refresh_flag}]">
                <div class="chart1" v-show="refresh_gage_flag"></div>
                <i :class="[refresh_flag ? 'refresh1 on' : 'i_arw_line_r']"></i><span class="blind">{{refresh_flag ? '새로고침' : '맨위로'}}</span>          
            </button>
            <template v-if="refresh_gage_flag" >
                <div class="update_ment" v-if="refresh_flag">바뀐 순위를 확인해보세요!</div>
                <div class="update_ment" v-else-if="left_update_minutes == 0">랭킹 업데이트 {{left_update_second}}초 전</div>
                <div class="update_ment" v-else>랭킹 업데이트 {{left_update_minutes}}분 전</div>
            </template>      
        </div>
    `
    , props : {
        last_update_time : {type : String, default : ''}
        , left_update_hour : {type : Number, default : 0}
        , left_update_minutes : {type : Number, default : 0}
        , left_update_second : {type : Number, default : 0}
        , refresh_gage_flag: {type:Boolean, default:false}
        , refresh_flag: {type:Boolean, default:false}
    }
    , mounted() {
        const _this = this;

        let timeout;
        let lastScrollTop = 0;
        window.addEventListener('scroll', function () {
            if(!_this.refresh_gage_flag) {
                if ($(window).scrollTop() <= lastScrollTop) { //스크롤 다운
                    // 화면크기만틈 아래로 스크롤 하면 탑버튼 노출
                    if ($(window).scrollTop() >= $(window).height()) {
                        if (timeout !== undefined)
                            clearTimeout(timeout); // 스크롤 시 timeout 취소

                        $('#btn_top').fadeIn('fast');

                        // 5초간 아무 행동 하지 않으면 탑버튼 숨김
                        timeout = setTimeout(function () {
                            $('#btn_top').fadeOut('fast');
                        }, 5000);
                    }
                }
            }

            lastScrollTop = $(window).scrollTop();
        });
    },
    methods : {
        move_top() { // 탑으로 이동
            $('html, body').animate({scrollTop:0}, 'fast');

            if(this.refresh_flag){
                this.$emit('change_flag');
                this.$emit("reload");

                fnAmplitudeEventObjectAction('click_best_refresh', {});
            }
        }
        , start_progress_gage(){
            const during_time = 3*60*1000;
            const left_time = (this.left_update_minutes * 60 + this.left_update_second) * 1000;
            const start_time_percent = 1.0 - left_time / during_time;

            $('.chart1').circleProgress({
                size:50 //그래프 크기
                , startAngle: -Math.PI/2 //시작지점
                , animationStartValue:start_time_percent //시작값
                , value: 1.0
                , animation: {
                    duration: left_time
                    , easing: "linear"
                }
                , fill: {gradient: ['#FF214F']}
                , thickness : 2
            });
        }
    }
    , watch : {
        refresh_gage_flag(refresh_gage_flag){
            if(refresh_gage_flag){
                this.start_progress_gage();
                $('#btn_top').fadeIn('fast');
            }
        }
    }
})