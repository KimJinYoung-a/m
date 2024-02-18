const app = new Vue({
    el : '#app',
    template : `
        <div class="mEvt110104 checklist">
            <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/110104/m/tit_checklist.jpg" alt="체크리스트"></h2>
            
            <div class="btns-wrap">
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2021/110104/m/txt_btns.jpg" alt=""></p>
                <div class="btn-list">
                    <h3>푸시알림 동의하기</h3>
                    <button onclick="fnAPPpopupSetting();return false;" class="btn-push">푸시 동의하러 가기</button>
                    <button @click="call_api('push', 1000)" class="btn-try">1,000p 받기</button>
                    <h3>장바구니에 상품 5회 더 담기</h3>
                    <button onclick="fnAPPpopupBrowserURL('방금판매된','http://m.10x10.co.kr/apps/appCom/wish/web2014/justsold/');return false;" class="btn-cart">상품 담으러 가기</button>
                    <button @click="call_api('cart', 500)" class="btn-try">500p 받기</button>
                    <h3>첫 구매하기</h3>
                    <button onclick="fnAPPpopupBrowserURL('이벤트','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107535');return false;" class="btn-buy">첫 구매하러 가기</button>
                    <button @click="call_api('order', 2000)" class="btn-try">2,000p 받기</button>
                    <h3>APP 신규 설치하기</h3>
                    <button @click="call_api('app', 500)" class="btn-try">500p 받기</button>
                </div>
            </div>
            
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2021/110104/m/txt_notice.jpg" alt="유의사항"></p>
            
            <!-- 모달 -->
            <Modal ref="modal" @close_modal="close_modal" :is_show="is_popup">
                <button v-if="popup_type === 'no_push'" slot="body" type="button" onclick="fnAPPpopupSetting();return false;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110104/m/pop_push.png" alt="푸시 알림 설정 확인하기">
                </button>
                <p v-else-if="popup_type === 'no_cart'" slot="body">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110104/m/pop_cart.png" alt="대상자가 아닙니다">
                </p>
                <p v-else-if="popup_type === 'no_order'" slot="body">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110104/m/pop_buy.png" alt="대상자가 아닙니다">
                </p>
                <p v-else-if="popup_type === 'no_app'" slot="body">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110104/m/pop_install.png" alt="대상자가 아닙니다">
                </p>
                <a v-else-if="popup_type.startsWith('mileage_')" slot="body" 
                    @click="fnAPPpopupBrowserURL('마일리지 내역', 'http://m.10x10.co.kr/apps/appCom/wish/web2014/offshop/point/mileagelist.asp')">
                    <img :src="mileage_modal_image" alt="마일리지 확인하기">
                </a>
            </Modal>
        </div>
    `,
    data() { return {
        is_popup : false, // 모달 팝업 여부
        popup_type : 'no_push', // 모달 팝업 유형
        is_calling : false
    } },
    mounted() {
        if ( !unescape(location.href.toLowerCase()).includes('/apps/appcom/')) {
            location.href = '/event/eventmain.asp?eventid=110103';
        }
    },
    computed : {
        mileage_modal_image() { // 마일리지 지급 모달 이미지
            if( this.popup_type.startsWith('mileage_') ) {
                return `//webimage.10x10.co.kr/fixevent/event/2021/110104/m/pop_mileage_${this.popup_type.replace('mileage_', '')}.png`;
            } else {
                return '';
            }
        },
        is_develop() { // 개발서버 여부
            return !unescape(location.href).includes('//stgm') && !unescape(location.href).includes('//m');
        },
        event_code() { // 이벤트 코드
            if( this.is_develop ) {
                return 104332;
            } else {
                return 110104;
            }
        },
        api_url() { // API url
            if( this.is_develop ) {
                return '//testfapi.10x10.co.kr/api/web/v1/event';
            } else {
                return '//fapi.10x10.co.kr/api/web/v1/event';
            }
        }
    },
    methods : {
        popup(type) { // 모달 팝업
            this.popup_type = type;
            this.is_popup = true;
        },
        close_modal() { // 모달 닫기
            this.is_popup = false;
        },
        call_api(type, mileage) { // API 호출
            if( this.is_calling )
                return false;

            this.is_calling = true; // 중복 호출 방지

            const _this = this;
            const api_url = this.api_url;

            const mileage_key = this.get_mileage_key(type);

            $.ajax({
                type: 'post',
                url: `${api_url}/${this.event_code}/mileage/${mileage_key}/device/A`,
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: data => {
                    _this.validate_mileage_give(data, mileage_key);
                    _this.popup('mileage_' + mileage); // 성공시 마일리지 지급 모달 팝업
                },
                error: e => {
                    try {
                        const error = JSON.parse(e.responseText);
                        switch(error.code) {
                            case -10: case -11: fnAPPpopupLogin(); return;
                            case -600: alert('처리과정 중 오류가 발생했습니다.\n코드:001'); return;
                            case -602: alert('이벤트가 종료되었습니다'); return;
                            case -609: alert('이미 지급되었습니다.\nID당 1회만 받을 수 있습니다'); return;
                            case -611:
                                _this.popup('no_' + type);
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
                complete : () => {
                    _this.is_calling = false;
                }
            });
        },
        get_mileage_key(type) { // GET 마일리지 키
            switch (type) {
                case 'push': return 1;
                case 'cart': return 2;
                case 'order': return 3;
                case 'app': return 4;
            }
        },
        validate_mileage_give(result_data, mileage_key) {
            const url = this.api_url + '/mileage/validate';
            const send_data = {
                'mileage_log_id' : result_data.mileage_log_id,
                'mileage_key' : mileage_key,
                'round' : result_data.round,
                'device' : 'A'
            };

            $.ajax({
                type: 'post',
                url: url,
                crossDomain: true,
                data: send_data,
                xhrFields: {
                    withCredentials: true
                }
            });
        }
    }
});