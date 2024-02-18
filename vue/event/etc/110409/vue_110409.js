const app = new Vue({
    el : '#app',
    template : `
        <div class="mEvt110409">
            <div class="topic">
                <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/110409/m/tit_footprint.png" alt="출석체크 이벤트"></h2>
                <button class="get-mileage" onclick="fnAPPpopupBrowserURL('마일리지 내역', 'http://m.10x10.co.kr/apps/appCom/wish/web2014/offshop/point/mileagelist.asp');return false;">
                    <span><em id="mileage-current">{{received_mileage_sum_format}}</em>p</span>
                </button>
                <button class="chk-attendance" @click="post_subscript">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110409/m/btn_try.png" alt="발도장 찍기">
                </button>
                <div class="dc-group">
                    <span class="dc dc1"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110409/m/img_dc_01.png" alt=""></span>
                    <span class="dc dc2"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110409/m/img_dc_02.png" alt=""></span>
                    <span class="dc dc3"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110409/m/img_dc_03.png" alt=""></span>
                    <span class="dc dc4"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110409/m/img_dc_04.png" alt=""></span>
                </div>
            </div>
        
            <!-- 현재 진행 현황 -->
            <div class="process">
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2021/110409/m/bg_process.png" alt="배경이미지"></p>
                <Day v-for="day in day_logs" :key="day.date" :date="day.date" :status="day.status" :mileage_amount="day.mileage_amount"/>
            </div>
        
            <!-- 알림 신청 -->
            <button v-if="!last_yn" class="btn-push" @click="request_push"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110409/m/btn_push.jpg" alt="알림 신청하기"></button>
        
            <!-- 지급완료 모달 -->
            <Modal this_id="receive_modal" :show_yn="receive_modal_show_yn">
                <Receive @request_push="request_push" @close_modal="close_modal" slot="body" :last_yn="last_yn" :mileage_amount="current_mileage_received"/>
            </Modal>
            
            <!-- 알림신청 모달 -->
            <Modal v-if="!last_yn" this_id="alert_modal" :show_yn="alert_modal_show_yn">
                <Alert slot="body" @close_modal="close_modal"/>
            </Modal>
        
            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110211');return false;">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/110409/m/bnr_sale.jpg" alt="텐바이텐 2021 봄 정기세일">
            </a>
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2021/110409/m/txt_notice.jpg" alt="유의사항"></p>
        </div>
    `,
    created() {
        //마일리지 정보 조회
        this.get_info();
    },
    mounted() {
        if( !unescape(location.href.toLowerCase()).includes('/apps/appcom/') ) {
            location.replace('/event/eventmain.asp?eventid=' + (this.event_code - 1))
        }
    },
    data() {return {
        mileage_key : 1,
        last_yn : false, // 마지막일 여부
        received_mileage_sum : 0, // 현재까지 받은 마일리지
        day_logs : [], // 일별 로그 리스트
        current_mileage_received : 0, // 현재 받은 마일리지
        receive_modal_show_yn : false, // 지급결과 모달 노출여부
        is_posting_subscript : false, // 마일리지 지급 신청 중 여부
        alert_modal_show_yn : false, // 알림신청 모달 노출여부
        is_requesting_push : false, // 알림 신청 중 여부
    }},
    computed : {
        is_develop() { // 개발서버 여부
            return !unescape(location.href).includes('//stgm') && !unescape(location.href).includes('//m');
        },
        event_code() { // 이벤트 코드
            if( this.is_develop ) {
                return 104340;
            } else {
                return 110409;
            }
        },
        api_url() { // API url
            if( this.is_develop ) {
                return '//testfapi.10x10.co.kr/api/web/v1';
            } else {
                return '//fapi.10x10.co.kr/api/web/v1';
            }
        },
        received_mileage_sum_format() {
            return this.received_mileage_sum.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        },
    },
    methods : {
        // 이벤트 정보 조회
        get_info() {
            this.call_api('get', '/tempEvent/maileage', null, data => {
                this.received_mileage_sum = data.received_mileage_sum;
                this.day_logs = data.days;
                this.last_yn = data.last_yn;
            });
        },
        // 마일리지 지급 신청
        post_subscript() {
            if( this.is_posting_subscript ) {
                return false;
            }
            this.is_posting_subscript = true;

            const _this = this;
            this.call_api('post', `/event/${this.event_code}/mileage/${this.mileage_key}/device/A`
                , null, data => {
                    _this.current_mileage_received = data.mileage_amount;
                    _this.validate_mileage_give(data);
                    _this.get_info();
                    _this.receive_modal_show_yn = true;

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
                                    alert('오늘의 발도장 찍기는 이미 완료했어요!\n감사합니다.');
                                else
                                    alert('오늘의 발도장 찍기는 이미 완료했어요.\n내일도 꼭 참여하세요!');
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
        },
        // 검증
        validate_mileage_give(result_data) {
            const url = `/event/mileage/validate`;
            const send_data = {
                'mileage_log_id' : result_data.mileage_log_id,
                'mileage_key' : this.mileage_key,
                'round' : result_data.round,
                'device' : 'A'
            };
            this.call_api('post', url, send_data);
        },
        // 알림 신청
        request_push() {
            if( this.is_requesting_push ) {
                return false;
            }
            this.receive_modal_show_yn = false;
            this.is_requesting_push = true;
            const _this = this;

            this.call_api('post', '/tempEvent/maileage/push', null, result => {
                    if( result ) {
                        _this.alert_modal_show_yn = true;

                        // 마일리지 지급 앰플리튜드
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
            })
        },
        // API Call
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
        },
        // 모달 닫기
        close_modal(modal_id) {
            if( modal_id === 'receive_modal' ) {
                this.receive_modal_show_yn = false;
            } else if( modal_id === 'alert_modal' ) {
                this.alert_modal_show_yn = false;
            }
        },
    }
});