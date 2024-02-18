$(document).ready(function() {
    const subscriptButton = document.getElementById('subscriptButton');
    const eventId = location.search.substr(1).split('&').find(a => a.substr(0, 7) === 'eventid').substr(8);

    // 응모 버튼 있을 때 작동
    if( subscriptButton ) {
        let apiCalling = false;
        const device = location.pathname.toLowerCase().indexOf('/apps/appcom/wish/web2014') > -1 ? 'A' : 'M';
        document.querySelectorAll('.modalUserId').forEach(el => el.innerText=subscriptUserId);

        // API CALL
        const callFrontApi = function(type, uri, data, success, fail) {
            $.ajax({
                type: type,
                url: apiurlv2 + uri,
                data: data,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: success,
                error: fail,
                complete: function() {
                    apiCalling = false;
                }
            });
        }

        // URL 카피
        const createClipboard = function() {
            const clipboard = new Clipboard('#copyUrl');
            clipboard.on('success', function() {
                alert('URL이 복사 되었습니다.');
            });
            clipboard.on('error', function() {
                alert('URL을 복사하는 도중 에러가 발생했습니다.');
            });
            console.log(clipboard);
        };
        createClipboard();
        
        // 응모 클릭 이벤트
        subscriptButton.addEventListener('click', () => {
            if( apiCalling )
                return false;

            if( !eventId ) {
                alert('응모 중 에러가 발생했습니다.\n잠시 후 다시 시도 해 주세요\n(에러코드 : 001)');
                return false;
            }

            // Success Subscript
            const success = function(data) {
                $('#successModal').fadeIn();
                fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode', eventId);
            }

            // Fail Subscript
            const handleError = function(e) {
                try {
                    const error = JSON.parse(e.responseText);
                    switch (error.code) {
                        case -10:
                            alert('이벤트에 응모를 하려면 로그인이 필요합니다.');
                            calllogin();
                            break;
                        case -603:
                            $('#duplicatedModal').fadeIn();
                            break;
                        default:
                            alert(error.message);
                    }
                } catch(error) {
                    alert('응모 중 에러가 발생했습니다.\n잠시 후 다시 시도 해 주세요\n(에러코드 : 002)');
                }
            }

            const data = {
                'eventCode': eventId,
                'device': device
            };

            callFrontApi('POST', '/event/subscript', data, success, handleError);
        });

        // 모달 닫기 이벤트
        const closeModal = e => $(e.target).closest('.popup').fadeOut();
        document.querySelectorAll('.btn_close').forEach(btn => btn.addEventListener('click', closeModal));

        // 알림 신청 이벤트
        const requestAlarm = function() {
            const alertSuccess = () => alert("알림신청이 완료됐습니다.");
            const handleError = function(e) {
                try {
                    const error = JSON.parse(e.responseText);
                    switch (error.code) {
                        case -10:
                            alert('알림 신청을 하려면 로그인이 필요합니다.');
                            calllogin();
                            break;
                        default:
                            alert(error.message);
                    }
                } catch(error) {
                    alert('알림 신청 중 에러가 발생했습니다.\n잠시 후 다시 시도 해 주세요\n(에러코드 : 003)');
                }
            }

            callFrontApi('POST', `/event/${eventId}/subscript/alarm`, null, alertSuccess, handleError);
        };
        document.querySelectorAll('.requestAlarm').forEach(btn => btn.addEventListener('click', requestAlarm));

        // 카카오 공유
        const shareKakao = function() {
            if( device === 'A' ) {
                callFrontApi('GET', `/event/share/sns/${eventId}`, null, data => {
                    if( data.kakaoTitle && data.kakaoImage ) {
                        fnAPPshareKakao('etc',data.kakaoTitle,'','',
                            'url=https://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=' + eventId,
                            data.kakaoImage, '','','', data.kakaoDescription);
                    }
                });
            }
        };
        document.querySelectorAll('.shareKakao').forEach(btn => btn.addEventListener('click', shareKakao));
    }
});