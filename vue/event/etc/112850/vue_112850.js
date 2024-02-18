var app = new Vue({
    el: '#app',
    template: `
        <div class="mEvt112850">
            <div class="topic">
              <img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/bg_title.jpg?v=3" alt="행운의 언빡씽!">
               <div class="icon"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/icon_arrow.png" alt="화살표"></div>
            </div>
            
            <!-- 이벤트 응모 영역 -->
            <div class="section-01">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/bg_event.jpg" alt="행운의 언빡씽!">
                <div class="img-01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/event_box.png" alt="박스"></div>
                <div class="img-02 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/event_heart.png" alt="하트"></div>
                <div class="img-03 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/event_star.png" alt="반짝"></div>
                <button type="button" class="event-btn" @click="subscriptEvent">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/event_btn.png" alt="지금은 언박싱 타임!">
                </button>
            </div>
            
            <!-- 적립완료 팝업 -->
            <transition name="fade">
                <div v-show="isPopModal" class="pop-container">
                    <div class="pop-inner">
                        <div :class="['pop-contents', {'last-day' : isLastDay}]">
                            <!-- 포인트 -->
                            <div class="pop-point">
                                <p>{{numberFormat(mileage)}}P</p>
                            </div>
                            <div class="img-04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/popup_box.png" alt="박스"></div>
                            <div class="img-05"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/popup_coin.png" alt="코인"></div>
                            <img :src="'//webimage.10x10.co.kr/fixevent/event/2021/112850/m/' + (isLastDay ? 'bg_lastpopup.png' : 'bg_popup.png')" alt="포인트로 스티커 사러 가자">
                            <button @click="isPopModal = false;" type="button" class="btn-close">닫기</button>
                        </div>
                    </div>
                </div>
            </transition>
            
            <div class="event-list">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/bg_eventlist.jpg?v=2" alt="행운의 언빡씽!">
                
                <!-- 이벤트 배너 -->
                <template v-for="banner in banners">
                    <a v-if="isApp" @click="clickAppEventBanner(banner.eventId)"><img :src="banner.image" alt=""></a>
                    <a v-else :href="'/event/eventmain.asp?eventid=' + banner.eventId" class="mWeb"><img :src="banner.image" alt=""></a>
                </template>
                
            </div>
        
            <img :src="top7ItemImage1" alt="">
             <!-- 풀꾸,탑꾸 스티커 리스트 -->
            <div class="prd-list">
                <ul class="itemList">
                    <Spetival-Item v-for="item in top7Items1"
                        @goProductDetail="goProductDetail" :isApp="isApp" :item="item"/>
                </ul>
            </div>
            
            <img :src="top7ItemImage2" alt="">
             <!-- 스꾸스티커 리스트 -->
            <div class="prd-list">
                <ul class="itemList01">
                    <Spetival-Item v-for="item in top7Items2"
                        @goProductDetail="goProductDetail" :isApp="isApp" :item="item"/>
                </ul>
            </div>
            
            <div class="section-02">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/bg_sticker01.jpg?v=2" alt="">
                <a @click="goProductDetail(3666165)" class="item-01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/list01_01.png" alt=""></a>
                <a @click="goProductDetail(3895597)" class="item-02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/list01_02.png" alt=""></a>
                <a @click="goProductDetail(3603641)" class="item-03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/list01_03.png" alt=""></a>
                <a @click="goProductDetail(3816493)" class="item-04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/list01_04.png" alt=""></a>
            </div>
            <div class="prd-WRAP prd-wrap">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/bg_sticker02.jpg?v=2" alt="">
                <a @click="goProductDetail(2682613)" class="item-01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/list02_01.png" alt=""></a>
                <a @click="goProductDetail(3789290)" class="item-02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/list02_02.png" alt=""></a>
            </div>
            <div class="section-04 prd-wrap">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/bg_sticker03.jpg?v=2" alt="">
                <a @click="goProductDetail(3903293)" class="item-01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/list03_01.png" alt=""></a>
                <a @click="goProductDetail(3900384)" class="item-02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/list03_02.png" alt=""></a>
            </div>
            <div class="section-05 prd-wrap">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/bg_sticker04.jpg?v=2" alt="">
                <a @click="goProductDetail(3640712)" class="item-01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/list04_01.png" alt=""></a>
                <a @click="goProductDetail(2469706)" class="item-02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/list04_02.png" alt=""></a>
            </div>
            <div class="section-06">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112850/m/bg_list.jpg?v=2" alt="">
                <div class="link-conts">
                    <div><a href="#group375167"></a></div>
                    <div><a href="#group375168"></a></div>
                    <div><a href="#group375169"></a></div>
                    <div><a href="#group375170"></a></div>
                    <div><a href="#group375171"></a></div>
                    <div><a href="#group375172"></a></div>
                    <div><a href="#group375173"></a></div>
                    <div><a href="#group375174"></a></div>
                    <div><a href="#group375175"></a></div>
                </div>
            </div>
        </div>
    `,
    data() {return {
        mileage : 0, // 지급받은 마일리지
        isCalled : false, // 신청 중 여부
        isLastDay : false, // 마지막날 여부
        isPopModal : false, // 팝업 노출 여부
        isApp : unescape(location.href.toLowerCase()).includes('/apps/appcom/'),
        isDevelop : unescape(location.href).includes('//localhost') || unescape(location.href).includes('//testm') || unescape(location.href).includes('//localm'),
        banners: [],
        top7ItemImage1 : '',
        top7ItemImage2 : '',
        top7Items1 : [],
        top7Items2 : []
    }},
    computed : {
        spetivalApiUrl() {
            return '//' + (this.isDevelop ? 'test' : '') + 'fapi.10x10.co.kr/api/web/v2/event/temp/spetival';
        }
    },
    mounted() {
        $('.topic .tit').addClass('on');
        $(window).scroll(function(){
            $('.animate').each(function(){
                var y = $(window).scrollTop() + $(window).height() * 1;
                var imgTop = $(this).offset().top;
                if(y > imgTop) {
                    $(this).addClass('on');
                }
            });
        });

        const _this = this;

        // JSON 위치
        let jsonUrl = '/vue/event/etc/112850';
        if( this.isDevelop ) {
            jsonUrl += '/dev.json';
        } else {
            const now = new Date();

            // 이벤트 시작 전
            if( now - new Date('2021-07-26 00:00:00') ) {
                jsonUrl += '/210723.json';
            } else {
                jsonUrl += '/' + (now.getFullYear()-2000) + '0' + (now.getMonth() + 1) + (now.getDay() < 10 ? '0' : '') + now.getDay() + '.json';
            }
        }

        this.banners = eventData.banners;

        this.top7ItemImage1 = eventData.top7Item1.titleImage;
        let top7ItemData1 = {'itemIds' : eventData.top7Item1.itemIds.join(',')}
        this.getFrontApiData('GET', '/items', top7ItemData1,
            data => {
                data.forEach(item => {
                    item.itemImage = _this.decodeBase64(item.itemImage);
                    this.top7Items1.push(item);
                });
            },
            xhr => {
                console.log(xhr.responseText);
            }
        );
        this.top7ItemImage2 = eventData.top7Item2.titleImage;
        let top7ItemData2 = {'itemIds' : eventData.top7Item2.itemIds.join(',')}
        _this.getFrontApiData('GET', '/items', top7ItemData2,
            data => {
                data.forEach(item => {
                    item.itemImage = _this.decodeBase64(item.itemImage);
                    this.top7Items2.push(item);
                });
            },
            xhr => {
                console.log(xhr.responseText);
            }
        );

    },
    methods : {
        subscriptEvent() {
            const _this = this;
            this.isCalled = false;

            const sendData = {
                'deviceType' : this.isApp ? 'APP' : 'MOBILE'
            }
            this.getFrontApiData('POST', '/subscript', sendData,
                data => {
                    _this.isCalled = false;
                    _this.mileage = data;
                    _this.isPopModal = true;
                },
                xhr => {
                    console.log(xhr.responseText);
                    _this.isCalled = false;

                    try {
                        const err = JSON.parse(xhr.responseText);
                        _this.handleError(err);
                    } catch (e) {
                        alert('데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망. (에러코드 : 001)');
                    }
                }
            );
        },
        handleError(err) {
            if(err.code === -10) {
                alert('언박싱 하려면 로그인이 필요합니다.');
                if( this.isApp ) {
                    fnAPPpopupLogin();
                } else {
                    location.href = '/login/login.asp?backpath=' + location.pathname + location.search
                }
            } else if (err.code === -603) {
                alert('이미 언박싱 하셨습니다.\n매일 한번씩만 가능합니다.');
            } else if (err.code === -601 || err.code === -602 || err.code === -615) {
                alert(err.message);
            } else {
                alert(`데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망. (에러코드 : ${err.code})`);
            }
        },
        numberFormat(number) {
            if( number == null || isNaN(number) )
                return '';
            else
                return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        },
        getFrontApiData(method, uri, data, success, error) {
            $.ajax({
                type: method,
                url: this.spetivalApiUrl + uri,
                data: data,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: success,
                error: error
            });
        },
        decodeBase64(str) {
            if (str == null) return null;
            return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
        },
        goProductDetail(itemId) {
            this.isApp ? fnAPPpopupProduct(itemId) : function() {
                location.href = "/category/category_itemPrd.asp?itemid="+ itemId +"&flag=e&pEtr=112850";
            }();
        },
        clickAppEventBanner(eventId) {
            fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=' + eventId);
        }
    }
});