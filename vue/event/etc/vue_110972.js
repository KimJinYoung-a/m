var app = new Vue({
    el      : '#app',
    mixins  : [item_mixin],
    template: `
                <div class="view-wish">
                    <ul>
                        <li v-for="product in products">
                            <a @click="itemUrl(product.item_id)">
                                <div class="thum"><img :src="product.item_image" alt=""></div>
                            </a>
                        </li>
                    </ul>
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
            const url = '/event/etc/wishlist/act_wishlist.asp?current_page=' + (_this.current_page + 1) + '&row_count=40';
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
                        data.products.forEach(p => {
                            p.item_image = p.item_image;
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
        }
    }
})