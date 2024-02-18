const app = new Vue({
    el: '#app'
    , template : `
        <div class="mEvt116696">
            <section class="section01">
                <img src="//webimage.10x10.co.kr/fixevent/event/2022/116696/title.jpg" alt="">
                <p>
                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116696/title_btn.png" alt="">
                </p>
                <button @click="go_attendance" class="btn_check" >출석체크하기</button>
            </section>
            
            <section class="section02">
                <div v-if="is_login_ok" class="content01_02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116696/content01_01.jpg" alt="">
                    <p class="user_id"><span>{{userid}}</span> 님의</p>
                    <p class="user_id2">마일리지 지급 현황</p>
                    <p class="mileage"><span>{{received_mileage_sum}}</span>p</p>
                    <a @click="go_app_popup" href="javascript:void(0)" class="mApp myMileage"></a>
                </div>
                <div v-else class="content01_01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116696/content01_02.jpg" alt="">
                    <p class="user_id"><span>고객</span> 님이 받을 수 있는</p>
                    <p class="user_id2">최대 마일리지</p>
                    <p class="mileage"><span>4,500</span>p</p>
                    <a href="javascript:void(0)" class="mApp myMileage"></a>
                </div>
            </section>
            
            <section class="section03">
                <img src="//webimage.10x10.co.kr/fixevent/event/2022/116696/content02_01.jpg" alt="">
                <div class="btnWrap">
                    <div v-for="(item, index) in 9" :class="'btn0' + (index+1)">
                        <img v-if="index < received_mileage_days_count" :src="'//webimage.10x10.co.kr/fixevent/event/2022/116696/btn0' + (index+1) + '_off.png'" :id="'day' + (index+1)" />
                        <img v-else :src="'//webimage.10x10.co.kr/fixevent/event/2022/116696/btn0' + (index+1)  + '_off.png'" :id="'day' + (index+1) " class="btn_off" />
                        
                        <img v-if="index == today_index" src="//webimage.10x10.co.kr/fixevent/event/2022/116696/btn_on.png" />
                    </div>
                </div>
            </section>
            <section class="section04">
                <div class="noti_wrap">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116696/info01.jpg" alt="">
                    <button class="btn-apply" @click="go_push"></button>
                    <p class="noti"></p>
                    <p class="notice"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116696/notice.jpg" alt=""></p>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2022/116696/info02.jpg" alt="">
            </section>
            <section class="section05">
                <div class="bg_dim"></div>
                <div class="popup01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116696/popup01.png?v=1.3" alt="">
                    <p class="day"><span>{{received_mileage_days_count}}</span>일째</p>
                    <p class="point"><span class="today">{{received_mileage}}</span><span>P</span>가 적립되었어요!<br>이벤트에 참여해 주셔서 감사합니다. :)</p>
                    <a href="javascript:void(0)" class="btn_close"></a>
                    <a href="" onclick="fnAPPpopupBrowserURL('이벤트','https://m.10x10.co.kr/apps/appcom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp?scTgb=mktevt');return false;" class="btn_alert"></a>
                </div>
                <div class="popup02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116696/popup02.png?v=1.3" alt="">
                    <p class="day"><span>{{received_mileage_days_count}}</span>일째</p>
                    <p class="point"><span class="today" id="nowmile">{{received_mileage}}</span><span>P</span>가 적립되었어요!<br>내일 받을 마일리지는 <span class="tomorrow">{{received_mileage + 100}}P</span>입니다.<br>마지막까지 도전하세요!</p>
                    <a href="javascript:void(0)" class="btn_close"></a>
                    <button class="btn_alert" @click="go_push">내일 알림 신청하기</button>
                </div>
                <div class="popup03">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116696/popup03.png?v=1.3" alt="">
                    <p class="day"><span>{{received_mileage_days_count}}</span>일째</p>
                    <p class="point"><span class="today">{{received_mileage}}</span><span>P</span>가 적립되었어요!<br>9일간 참여해 주셔서 감사합니다. :)</p>
                    <a href="javascript:void(0)" class="btn_close"></a>
                    <a href="" onclick="fnAPPpopupBrowserURL('이벤트','https://m.10x10.co.kr/apps/appcom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp?scTgb=mktevt');return false;" class="btn_alert"></a>
                </div>
                <div class="popup04">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116696/popup04.png?v=1.3" alt="">
                    <a href="javascript:void(0)" class="btn_close"></a>
                    <button @click="go_setting" class="btn_alert">나의 설정 확인하기</button>
                </div>
            </section>				
        </div>
    `
    , created() {
        this.is_login_ok = isLoginOk;
        if(!this.is_login_ok){
            this.userid = '고객';
        }else{
            this.userid = userid;
        }

        this.get_mileage_info()
    }
    , mounted(){
        $('.noti_wrap .noti').click(function(){
            if($(this).hasClass('on')){
                $(this).removeClass('on');
                $('.notice').css('display','none');
            }else{
                $(this).addClass('on');
                $('.notice').css('display','block');
            }
        });

        $('.btn_close').click(function(){
            $('.bg_dim').css('display','none');
            $(this).parent().css('display','none');
            return false;
        });
    }
    , computed : {
    }
    , data(){
        return {
            userid : ''
            , is_login_ok : false
            , received_mileage : 0 //오늘 받은 마일리지
            , received_mileage_sum : 0 //받은 마일리지 총합
            , received_mileage_days_count : 0 //마일리지를 받은 날짜 총합
            , today_index : 0 //오늘자 인덱스
            , is_requesting_push : false
            , is_posting_subscript : false
        }
    }
    , methods : {
        get_mileage_info(){
            const _this = this;
            getFrontApiDataV2('get', '/event/everyday-mileage', {"event_code" : event_code, "start_date" : start_date, "end_date" : end_date}, data => {
                _this.received_mileage_days_count = 0;
                _this.received_mileage_sum = data.received_mileage_sum;
                _this.today_index = data.today_index;
                _this.received_mileage_days_count = data.received_days_count
                _this.last_yn = data.last_yn;
            });
        }
        , go_attendance(){
            const _this = this;

            if(!this.is_login_ok){
                calllogin();
            }else {
                if (this.is_posting_subscript) {
                    return false;
                }

                this.is_posting_subscript = true;
                getFrontApiDataV2('post', `/event/${event_code}/mileage/1/device/A`
                    , null, data => {
                        _this.is_posting_subscript = false;

                        _this.received_mileage = data.mileage_amount;
                        _this.get_mileage_info();

                        if(data.round == 9){
                            $('.bg_dim').css('display','block');
                            $("#day" + data.round).removeClass("btn_off");
                            $('.popup03').css('display','block');
                        }else if(_this.last_yn){
                            $('.bg_dim').css('display','block');
                            $("#day" + data.round).removeClass("btn_off");
                            $('.popup01').css('display','block');
                        }else{
                            $('.bg_dim').css('display','block');
                            $("#day"+data.round).removeClass("btn_off");
                            $('.popup02').css('display','block');
                        }

                        // 마일리지 지급 앰플리튜드
                        fnAmplitudeEventMultiPropertiesAction('click_event_apply','eventcode|actype', event_code + '|mileageok','');
                    },
                    e => {
                        _this.is_posting_subscript = false;

                        try {
                            const error = JSON.parse(e.responseText);
                            switch(error.code) {
                                case -10: case -11: fnAPPpopupLogin(); return;
                                case -600: alert('처리과정 중 오류가 발생했습니다.\n코드:001'); return;
                                case -602: alert('이벤트가 종료되었습니다'); return;
                                case -608:  alert('최대 마일리지 지급 횟수를 초과했습니다.'); return;
                                case -609:
                                    if( _this.last_yn )
                                        alert('오늘의 출석체크는 이미 완료했어요!\n감사합니다.');
                                    else
                                        alert('오늘의 출석체크는 이미 완료했어요.\n내일도 꼭 참여하세요!');
                                    return;
                                default:
                                    alert('처리과정 중 오류가 발생했습니다.\n코드:003');
                                    return;
                            }
                        } catch(e) {
                            console.log(e);
                            alert('처리과정 중 오류가 발생했습니다.\n코드:002');
                        }
                    }
                );
            }
        }
        , go_push(){
            const _this = this;

            if(!this.is_login_ok){
                calllogin();
            }else {
                if( this.is_requesting_push ) {
                    return false;
                }
                this.is_requesting_push = true;

                getFrontApiDataV2('post', '/event/everyday-mileage/push', null, result => {
                        _this.is_requesting_push = false;

                        if( result ) {
                            $('.popup02').css('display','none');

                            $('.bg_dim').css('display','block'); //유지
                            $('.popup04').css('display','block');

                            fnAmplitudeEventMultiPropertiesAction('click_event_apply','eventcode|actype', event_code + '|alarm','');
                        } else {
                            alert('처리과정 중 오류가 발생했습니다.\n코드:001');
                        }
                    }
                    , e => {
                        _this.is_requesting_push = false;

                        try {
                            const error = JSON.parse(e.responseText);
                            switch(error.code) {
                                case -10: case -11: fnAPPpopupLogin(); return;
                                case -602: alert('이벤트가 종료되었습니다'); return;
                                case -603: alert('오늘은 이미 신청하였습니다'); return;
                                default:
                                    alert('처리과정 중 오류가 발생했습니다.\n코드:003');
                                    return;
                            }
                        } catch(e) {
                            console.log(e);
                            alert('처리과정 중 오류가 발생했습니다.\n코드:002');
                        }
                    }
                );
            }
        }
        , go_setting(){
            fnAPPpopupSetting();
        }
        , go_app_popup(){
            fnAPPpopupMy10x10();
        }
    }
});