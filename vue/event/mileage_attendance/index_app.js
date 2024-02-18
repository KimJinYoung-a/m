const app = new Vue({
    el: '#app'
    , template : `
        <div class="mEvt113634">
            <div class="topic">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/bg_main02.jpg" alt="">
                <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/tit_main.png" alt="추석 출석체크 이벤트"></h2>
                <p class="txt"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/txt_main.png" alt="마일리지 최대 4500p 받아가세요."></p>
            </div>

            <div class="section-photo">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/bg_family.jpg" alt="">
                <div class="ph01"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_01_' + (received_mileage_days_count > 0 ? 'on' : 'off') + '.png'" alt="할머니"></div>
                <div class="ph02"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_02_' + (received_mileage_days_count > 1 ? 'on' : 'off') + '.png'" alt="이모부"></div>
                <div class="ph03"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_03_' + (received_mileage_days_count > 2 ? 'on' : 'off') + '.png'" alt="할아버지"></div>
                <div class="ph04"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_04_' + (received_mileage_days_count > 3 ? 'on' : 'off') + '.png?v=2'" alt="엄마"></div>
                <div class="ph05"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_05_' + (received_mileage_days_count > 4 ? 'on' : 'off') + '.png'" alt="강아지"></div>
                <div class="ph06"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_06_' + (received_mileage_days_count > 5 ? 'on' : 'off') + '.png'" alt="이모"></div>
                <div class="ph07"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_07_' + (received_mileage_days_count > 6 ? 'on' : 'off') + '.png'" alt="조카"></div>
                <div class="ph08"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_08_' + (received_mileage_days_count > 7 ? 'on' : 'off') + '.png'" alt="아빠"></div>
                <div class="ph09"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_09_' + (received_mileage_days_count > 8 ? 'on' : 'off') + '.png'" alt="아기"></div>
                <div class="bar"></div>
            </div>
            <div class="section-check">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_check.jpg" alt="">
                <!-- 출석체크 버튼 -->
                <!-- 비로그인 : 로그인 페이지 이동 / 로그인 : 팝업 노출 -->
                <button @click="go_attendance" type="button" class="btn-check"></button>
                <div class="bar"></div>
            </div>
            <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/info_event.jpg" alt="">
            <div class="section-mileage">
                <div class="id-area">
                    <p><span>{{userid}}</span> 님의</p>
                    <p>마일리지 지급 현황</p>
                </div>
                <div class="event-area">
                    <div v-for="(item, index) in calendar_days" :class="'day' + (index+1)">
                        <template v-if="item.status == 'W'">
                            <div class="ch-before">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_day_before.png" :alt="item.date">
                                <div class="point">{{item.mileage_amount}}P</div>
                                <div class="day">{{item.date}}</div>
                            </div>
                        </template>
                        <template v-else-if="item.status == 'R'">
                            <div class="ch-after">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_day_after.png" :alt="item.date">
                                <div class="point">{{item.mileage_amount}}P</div>
                                <div class="day">{{item.date}}</div>
                            </div>
                        </template>
                        <template v-else>
                            <div class="ch-fail">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_day_fail.png" :alt="item.date">
                                <div class="point">0P</div>
                                <div class="day">{{item.date}}</div>
                            </div>
                        </template>
                    </div>                    
                </div>
                <div class="show-mileage">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_show_milige.jpg" alt="현재까지 받은 마일리지">
                    <!-- 현재까지 받은 마일리지 -->
                    <div class="num">{{received_mileage_sum}}P</div>
                    <!-- 클릭시 마일리지 페이지로 이동 -->
                    <a href="/offshop/point/mileagelist.asp" class="btn-mileage"></a>
                </div>
            </div>
            <div class="section-alram">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_alram.jpg" alt="내일 알림 신청하기">
                <!-- 알람신청 버튼 -->
                <!-- 비 로그인 : 로그인 화면 > 다시 이벤트 페이지 / 로그인 : 팝업노출 -->
                <button @click="go_push" type="button" class="btn-alram"></button>
            </div>
            <div class="section-detail">
                <div class="btn-area">
                    <button type="button" class="btn-detail">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/btn_detail.jpg" alt="이벤트 유의사항 자세히보기" />
                        <span class="icon"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/icon_arrow.png" alt=""></span>
                    </button>
                    <div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_detail.jpg" alt="이벤트 유의사항" /></div>
                </div>
            </div>
            <div class="section-bnr">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_banner.jpg?v=2" alt="이번 추석은 미리 준비해볼까요?">
                <div class="prd01">
                    <a href="#" onclick="fnAPPpopupProduct('3988801&pEtr=113634'); return false;" class=""></a>
                </div>
                <div class="prd02">
                    <a href="#" onclick="fnAPPpopupProduct('2591592&pEtr=113634'); return false;" class=""></a>
                </div>
                <div class="prd03">
                    <a href="#" onclick="fnAPPpopupProduct('2172278&pEtr=113634'); return false;" class=""></a>
                </div>
                <div class="prd04">
                    <a href="#" onclick="fnAPPpopupProduct('3977897&pEtr=113634'); return false;" class=""></a>
                </div>
                <div class="prd05">
                    <a href="#" onclick="fnAPPpopupProduct('3986060&pEtr=113634'); return false;" class=""></a>
                </div>
                <div class="prd06">
                    <a href="#" onclick="fnAPPpopupProduct('3992093&pEtr=113634'); return false;" class=""></a>
                </div>
                <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=113035');return false;" class="btn-go"></a>
            </div>

            <div class="pop-container check01">
                <div class="pop-inner">
                    <div class="pop-contents">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/pop_win.jpg" alt="출석체크 완료">
                        <div class="point">{{received_mileage}}P</div>
                        <div class="txt">
                            <p><span>{{received_mileage}}P</span>가 적립되었어요!</p>
                            <p>내일 받을 마일리지는 <span>{{received_mileage + 100}}P</span>입니다.</p>
                        </div>
                        <button @click="go_push" type="button" class="btn-tomorrow"></button>
                    </div>
                    <button type="button" class="btn-close">닫기</button>
                </div>
            </div>
            <!-- 팝업 - 출석완료 9일차인 고객 -->
            <div class="pop-container check02">
                <div class="pop-inner">
                    <div class="pop-contents">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/pop_win02.jpg" alt="출석체크 완료">
                        <div class="txt">
                            <p><span>{{received_mileage}}P</span>가 적립되었어요.</p>
                            <p>가족 사진도 완성해주셨군요!</p>
                            <p>9일간 참여해주셔서 감사합니다. :)</p>
                            <div class="bold">이제 본격적으로 추석 준비해볼까요!</div>
                        </div>
                        <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=113035');return false;" class="btn-event"></a>
                    </div>
                    <button type="button" class="btn-close">닫기</button>
                </div>
            </div>
            <!-- 팝업 - 마지막날 모든 고객 -->
            <div class="pop-container check03">
                <div class="pop-inner">
                    <div class="pop-contents">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/pop_last.jpg" alt="출석체크 완료">
                        <div class="point">{{received_mileage}}P</div>
                        <div class="txt">
                            <p><span>{{received_mileage}}P</span>가 적립되었어요!</p>
                            <p>이벤트에 참여해주셔서 감사합니다. :)</p>
                            <div class="bold">이제 본격적으로 추석 준비해볼까요!</div>
                        </div>
                        <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=113035');return false;" class="btn-event"></a>
                    </div>
                    <button type="button" class="btn-close">닫기</button>
                </div>
            </div>
            <!-- 팝업 - 알림신청 -->
            <div class="pop-container alram">
                <div class="pop-inner">
                    <div class="pop-contents">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/pop_alram.jpg" alt="알림신청 완료">
                        <!-- 내 설정 확인하기 버튼 -->
                        <button @click="go_setting" type="button" class="btn-alram-page"></button>
                    </div>
                    <button type="button" class="btn-close">닫기</button>
                </div>
            </div>
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
        /* 팝업 닫기 */
        $('.mEvt113634 .btn-close').click(function(){
            $(".pop-container").fadeOut();
        })
        // btn more
        $('.mEvt113634 .btn-detail').click(function (e) {
            $(this).next().toggleClass('on');
            $(this).find('.icon').toggleClass('on');
        });
    }
    , computed : {
        is_develop() { // 개발서버 여부
            return !unescape(location.href).includes('//stgm') && !unescape(location.href).includes('//m');
        }
        , api_url() { // API url
            if( this.is_develop ) {
                return '//localhost:8080/api/web/v1';
            } else {
                return '//fapi.10x10.co.kr/api/web/v1';
            }
        }
    }
    , data(){
        return {
            userid : ''
            , is_login_ok : false
            , calendar_days : []
            , received_mileage : 0 //오늘 받은 마일리지
            , received_mileage_sum : 0 //받은 마일리지 총합
            , received_mileage_days_count : 0 //마일리지를 받은 날짜 총합
            , is_requesting_push : false
            , is_posting_subscript : false
        }
    }
    , methods : {
        call_api(method, uri, data, success, error, complete) {
            if( error == null ) {
                error = function(xhr) {
                    console.log(xhr.responseText);
                }
            }

            $.ajax({
                type: method,
                url: this.api_url + uri,
                data: data,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: success,
                error: error,
                complete: complete
            });
        }
        , get_mileage_info(){
            const _this = this;
            this.call_api('get', '/tempEvent/mileage_calendar', {"event_code" : event_code, "start_date" : start_date, "end_date" : end_date}, data => {
                _this.received_mileage_days_count = 0;
                _this.received_mileage_sum = data.received_mileage_sum;
                _this.calendar_days = data.days;
                _this.last_yn = data.last_yn;

                data.days.forEach(function(item){
                    if(item.status == "R"){
                        _this.received_mileage_days_count += 1;
                    }
                });
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
                this.call_api('post', `/event/${event_code}/mileage/1/device/A`
                    , null, data => {
                        _this.received_mileage = data.mileage_amount;
                        _this.get_mileage_info();

                        if(_this.last_yn){
                            $('.pop-container.check03').fadeIn();
                        }else{
                            if(_this.received_mileage_days_count == 8){
                                $('.pop-container.check02').fadeIn();
                            }else{
                                $('.pop-container.check01').fadeIn();
                            }
                        }

                        // 마일리지 지급 앰플리튜드
                        fnAmplitudeEventMultiPropertiesAction('click_event_apply','eventcode|actype', _this.event_code + '|mileageok','');
                    },
                    e => {
                        try {
                            const error = JSON.parse(e.responseText);
                            switch(error.code) {
                                case -10: case -11: fnAPPpopupLogin(); return;
                                case -600: alert('처리과정 중 오류가 발생했습니다.\n코드:001'); return;
                                case -602: alert('이벤트가 종료되었습니다'); return;
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
                    },
                    () => {
                        _this.is_posting_subscript = false;
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

                this.call_api('post', '/tempEvent/maileage/push', null, result => {
                        if( result ) {
                            console.log(result);
                            $('.pop-container.alram').fadeIn();

                            fnAmplitudeEventMultiPropertiesAction('click_event_apply','eventcode|actype', _this.event_code + '|alarm','');
                        } else {
                            alert('처리과정 중 오류가 발생했습니다.\n코드:001');
                        }
                    }
                    , e => {
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
                    },
                    () => {
                        _this.is_requesting_push = false;
                    }
                );
            }
        }
        , go_setting(){
            fnAPPpopupSetting();
        }
    }
});