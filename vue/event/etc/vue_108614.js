var app = new Vue({
    el      : '#app',
    mixins  : [item_mixin],
    template: `
        <!-- 108614 연말 이벤트-->
        <div class="mEvt108614">
            <div class="topic">
                <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/108614/m/img_tit.jpg" alt="2020 랜선 송년회 쓸데 없는 선물하기"></h2>
                <!-- 이미지아이콘 영역 -->
                <div class="item-area">
                    <div class="thumb item1"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108614/m/img_item01.png" alt="item" class="item1"></div>
                </div>
                <!-- // -->
            </div>
            <div class="section-01">
                <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/108614/m/img_sub01.jpg" alt="만나지 못하는 이번 연말 텐바이텐 랜선 송년회를 열렸습니다."></h3>
                <button type="button" class="number"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108614/m/img_number.png" alt="50명"></button>
            </div>
            <div class="section-02">
                <button type="button" class="btn-simple"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108614/m/img_btn01.jpg" alt="참여 방법은 아주 간단해요."></button>
                <div class="hidden-txt">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/108614/m/img_hidden_txt.jpg" alt="이벤트 참여방법">
                    <!-- for dev msg : 이벤트 참여하기 버튼 -->
                    <button @click="sub_event" type="button" class="btn-apply"></button>
                </div>
            </div>
            <div class="section-03">
                <!-- for dev msg : 카카오톡 공유하기 -->
                <a @click="share_sns"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108614/m/img_banner01.jpg" alt="친구에게 공유하면 당첨확률 2배"></a>
                <!-- 기획전 이동하기 -->
                <a href="/event/eventmain.asp?eventid=108338" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108614/m/img_banner02.jpg" alt="기획전 이동"></a>
                <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108338');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108614/m/img_banner02.jpg" alt="기획전 이동"></a>
            </div>
            <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108614/m/img_noti.jpg" alt="유의 사항"></div>
            <div class="section-04">
                <div class="tit">
                    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/108614/m/img_tit02.jpg" alt="2020 랜선 송년회"></h3>
                    <div class="count">
                        <!-- for dev msg : 현재 참석 인원수 노출 -->
                        <p>현재 참석 인원</p>
                        <p class="num">: <span>{{subscription_count}}명</span></p>
                    </div>
                </div>
                <!-- for dev msg : wish 상품 리스트 -->
                <div class="view-wish">
                    <ul>
                        <li v-for="product in products">
                            <a @click="itemUrl(product.item_id)">
                                <div class="thum"><img :src="product.item_image" alt=""></div>
                                <p class="id">{{product.user_id}}</p>
                                <p class="name">{{product.item_name}}</p>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            <!-- 팝업 - 자세히 보기 -->
            <div class="pop-container">
                <div class="pop-inner">
                    <div class="pop-contents">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/108614/m/img_popup.png" alt="위시 폴더가 생성되었습니다.">
                    </div>
                    <button @click="close_pop" type="button" class="btn-close">닫기</button>
                </div>
            </div>
        </div>
    `,
    data() {
        return {
            is_page_loading   : true, // 페이지 로딩 중 여부
            is_complete       : false, // 리스트 조회 종료 여부
            current_page      : 0, // 현재 페이지
            isApp            : isApp, // app 여부
            products          : [], // 상품 리스트
            subscription_count: 0, // 참석인원 수
            is_called         : false, // 접수 호출 중 여부

            /* 카카오톡 공유용 */
            kakao_title      : '2020 랜선 송년회 : 쓸데없는 선물하기 이벤트',
            kakao_description: '당첨자는 총 50명! 재치있는 선물을 찾아주세요.',
            kakao_image : 'http://webimage.10x10.co.kr/fixevent/event/2020/108614/m/img_kakao.png',
        }
    },
    mounted() {
        const _this = this;
        _this.get_products(true);

        setTimeout(function () {
            _this.scroll_event();
        }, 1000);

        /* slide */
        changingImg();

        function changingImg() {
            let i = 1;
            const repeat = setInterval(function () {
                i++;
                if (i > 5) {
                    i = 1;
                }
                $('.mEvt108614 .item-area .thumb img').attr('src', '//webimage.10x10.co.kr/fixevent/event/2020/108614/m/img_item0' + i + '.png').attr('class', 'item' + i);
                /* if(i == 5) {
                    clearInterval(repeat);
                } */
            }, 1000);
        }
    },
    computed : {
        app_link() {
            return "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=" + this.get_event_code();
        },
        mobile_link() {
            return "http://m.10x10.co.kr/event/eventmain.asp?eventid=" + this.get_event_code();
        },
        web_link() {
            return "http://www.10x10.co.kr/event/eventmain.asp?eventid=" + this.get_event_code();
        },
    },
    methods : {
        sub_event() { // 이벤트 응모
            if( this.is_called )
                return false;
            else
                this.is_called = true;

            const _this = this;
            const url = apiurl + '/event/common/wish/subscription?event_code=' + _this.get_event_code()
                + '&folder_name=쓸데없는 선물'
                + '&device=' + (_this.isApp ? 'A' : 'M');

            $.ajax({
                type       : "POST",
                url        : url,
                ContentType: "json",
                crossDomain: true,
                xhrFields  : {
                    withCredentials: true
                },
                success    : function (data) {
                    console.log(data);
                    _this.is_called = false;
                    if (data) {
                        fnAmplitudeEventMultiPropertiesAction('click_event_apply', 'eventid', _this.get_event_code());
                        $('.pop-container').fadeIn();
                    } else {
                        alert('데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망. (에러코드 : 002)');
                    }
                },
                error      : function (xhr) {
                    console.log(xhr.responseText);
                    _this.is_called = false;
                    try {
                        const err = JSON.parse(xhr.responseText);
                        if(err.code == -10) {
                            alert('이벤트에 응모를 하려면 로그인이 필요합니다.');
                        } else if (err.code == -601 || err.code == -602 || err.code == -604) {
                            alert(err.message);
                        } else {
                            alert(`데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망. (에러코드 : ${err.code})`);
                        }
                    } catch (e) {
                        alert('데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망. (에러코드 : 001)');
                    }
                }
            });
        },
        close_pop() { // 팝업 닫기
            $(".pop-container").fadeOut();
        },
        scroll_event() {
            const _this = this;
            window.onscroll = function () {
                if (!_this.is_page_loading && !_this.is_complete && ($(window).scrollTop() >= ($(document).height() - $(window).height()) - 1000)) {
                    _this.is_page_loading = true;
                    _this.get_products(false);
                }
            }
        },
        get_products(is_first) {
            const _this = this;
            const url = apiurl + '/event/common/wish/products?event_code=' + _this.get_event_code()
                + '&current_page=' + (_this.current_page + 1)
                + '&row_count=60';
            $.ajax({
                type       : "GET",
                url        : url,
                ContentType: "json",
                crossDomain: true,
                xhrFields  : {
                    withCredentials: true
                },
                success    : function (data) {
                    console.log(data);
                    if (is_first) {
                        _this.subscription_count = data.subscription_count;
                    }
                    if (data.products != null) {
                        function decodeBase64(str) {
                            return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
                        }

                        data.products.forEach(p => {
                            p.item_image = decodeBase64(p.item_image);
                            _this.products.push(p);
                        });
                        _this.is_page_loading = false;
                        _this.current_page++;
                        if (_this.current_page === data.last_page) {
                            _this.is_complete = true;
                        }
                    }
                },
                error      : function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        get_event_code() {
            let event_code;
            const parameter_arr = location.search.substr(1).split('&');
            parameter_arr.forEach(p => {
                const keyValue = p.split('=');
                if (keyValue[0] === 'eventid') {
                    event_code = keyValue[1];
                }
            });
            return event_code;
        },
        share_sns() {
            $.ajax({
                type       : "POST",
                url        : apiurl + '/event/common/sns/log?event_code=' + this.get_event_code(),
                ContentType: "json",
                crossDomain: true,
                xhrFields  : {
                    withCredentials: true
                }
            });
            if (this.isApp) {
                fnAPPshareKakao('etc', this.kakao_title, this.web_link, this.mobile_link
                    , 'url=' + this.app_link, this.kakao_image, '', ''
                    , '', this.kakao_description);
            } else {
                event_sendkakao(this.kakao_title, this.kakao_description, this.kakao_image, this.mobile_link);
            }
        }
    }
})