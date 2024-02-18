const app = new Vue({
    el : '#app',
    template : /* html */`
    <div class="evtContV15">
        
            <div class="mEvt114117">
                <!--region 타이틀-->
                <section class="section01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/top.jpg?v=3" alt="">
                    <p class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/txt01.png" alt=""></p>
                    <p class="txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/txt02.png" alt=""></p>
                </section>
                <!--endregion-->
                
                <!--region 응모-->
                <section class="section02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/submit.jpg?v=2" alt="">
                    <p class="float01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/float01.png" alt=""></p>
                    <button @click="subscript" class="submit"></button>
                </section>
                <!--endregion-->
                
                <!--region 유의사항-->
                <section class="section03">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/notice.jpg" alt="">
                    <a @click="onOffPrecaution" class="notice"><span :class="{'on':showPrecaution}"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/arrow_down.png" alt=""></span></a>
                    <div v-show="showPrecaution" class="info">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/info.jpg" alt="">
                    </div>
                </section>
                <!--endregion-->
                
                <!--region 알림신청-->
                <section class="section04">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/alert.jpg" alt="">
                    <button @click="requestAlarm" class="alert"></button>
                </section>
                <!--endregion-->
                
                <!--region 경품-->
                <section class="section05">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/product.jpg" alt="">
                    <div class="swiper-container slide">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/slide01.png?v=2" alt="slide01"></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/slide02.png?v=2" alt="slide02"></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/slide03.png" alt="slide03"></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/slide04.png" alt="slide02"></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/slide05.png" alt="slide03"></div>
                        </div>
                    </div>
                </section>
                <!--endregion-->
                
                <!--region 추천 상품-->
                <section class="section06">
                    <div class="item01">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/item01.jpg" alt="">
                        <p class="float02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/float02.png" alt=""></p>
                        <a href="#" onclick="fnAPPpopupProduct('3767177&pEtr=114117'); return false;" class="prd01"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3987474&pEtr=114117'); return false;" class="prd02"></a>
                        <a onclick="fnAPPpopupSearchOnNormal('캔들', 'product')" class="url01"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3812529&pEtr=114117'); return false;" class="prd03"></a>
                        <a onclick="fnAPPpopupSearchOnNormal('무드등', 'product')" class="url02"></a>
                    </div>
                    <div class="item02">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/item02.jpg" alt="">
                        <a onclick="fnAPPpopupSearchOnNormal('머그컵', 'product')" class="url01"></a>
                        <a href="#" onclick="fnAPPpopupProduct('4017518&pEtr=114117'); return false;" class="prd01"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3855587&pEtr=114117'); return false;" class="prd02"></a>
                        <a onclick="fnAPPpopupSearchOnNormal('와인잔', 'product')" class="url02"></a>                        
                    </div>
                    <div class="item03">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/item03.jpg" alt="">
                        <a onclick="fnAPPpopupEvent(113987)" class="url01"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3507415&pEtr=114117'); return false;" class="prd01"></a>
                    </div>
                    <div class="item04">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/item04.jpg" alt="">
                        <a href="#" onclick="fnAPPpopupProduct('3997620&pEtr=114117'); return false;" class="prd01"></a>
                        <a onclick="fnAPPpopupEvent(113899)" class="url01"></a>        
                    </div>
                    <div class="item05">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/item05.jpg" alt="">
                        <a onclick="fnAPPpopupSearchOnNormal('노트', 'product')" class="url01"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3852495&pEtr=114117'); return false;" class="prd01"></a>
                    </div>
                </section>
                <!--endregion-->
                
                <!--region 첫구매샵-->
                <section class="section07">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/bottom.jpg" alt="">
                    <a @click="openFirstBuyShop" class="new_page"></a>
                </section>
                <!--endregion-->
                
                <!--region 팝업-->
                <transition name="fade">
                    <div v-show="showPopupNumber !== 0" class="popup">
                        <div class="bg_dim"></div>
                        
                        <!--region 신청완료-->
                        <div v-show="showPopupNumber === 1" class="pop01">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/popup01.png?v=2" alt="">
                            <p class="user"><span>{{userId}}</span>님</p>
                            <a @click="showPopupNumber = 0" class="btn_close"></a>
                            <button @click="requestAlarm" class="pop_submit"></button>
                        </div>
                        <!--endregion-->
                        
                        <!--region 중복신청-->
                        <div v-show="showPopupNumber === 2" class="pop02">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/popup02.png?v=2" alt="">
                            <p class="user"><span>{{userId}}</span>님</p>
                            <a @click="showPopupNumber = 0" class="btn_close"></a>
                            <button @click="shareKakao" class="pop_kakao"></button>
                            <button class="pop_url" id="urlCopy" data-clipboard-text="https://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=114117"></button>
                        </div>
                        <!--endregion-->
                    </div>
                </transition>
                <!--endregion-->
                
                <div v-show="showPopupWinner" class="popup pop_win">
                    <div class="bg_dim"></div>
                    <div class="pop02">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114117/m/pop_win.png" alt="당첨안내">
                        <a href="#" onclick="fnAPPpopupBrowserURL('기획전','https://m.10x10.co.kr/apps/appCom/wish/web2014/linker/forum.asp?idx=1');return false;" class="go_link" style="display:inline-block; width:100%; height:12rem; position:absolute; left:0; bottom:0;"></a>
                        <a @click="closeWinner" href="#" class="btn_close"></a>
                    </div>
                </div>
            </div>
            
        </div>
    `,
    mounted() {
        this.eventCode = isDevelop ? 108396 : 114117;
        this.transTitleSection();
        this.createClipBoard();
        this.createGiveawaySwiper();
    },
    data() {return {
        eventCode : 0, // 이벤트 코드
        showPrecaution : false, // 유의사항 노출 여부
        isApiCalling : false, // API 호출 중 여부
        userId : '', // 유저ID -- inc_114117.asp 하단에서 값 등록
        showPopupNumber : 0, // 비노출:0, 신청완료:1, 중복신청:2
        showPopupWinner : true, //당첨자 팝업 노출여부
    }},
    computed : {
        //region currentDate 현재 날짜(yyyy-MM-dd)
        currentDate() {
            const date = new Date();
            return `${date.getFullYear()}-${date.getMonth()<10 ? '0' : ''}${date.getMonth()+1}-${date.getDate()}`;
        }
        //endregion
    },
    methods : {
        //region transTitleSection 타이틀 섹션 transaction 적용
        transTitleSection() {
            $(function() { $('.mEvt114117 .section01 p').addClass('on'); });
        },
        //endregion
        //region onOffPrecaution 유의사항 on/off
        onOffPrecaution() {
            this.showPrecaution = !this.showPrecaution;
        },
        //endregion

        //region 응모 관련
        subscript() {
            if( this.isApiCalling )
                return false;

            this.isApiCalling = true;
            this.postFrontApi('subscript', this.subscriptSuccess, this.subscriptFail);
        },
        subscriptSuccess(data) {
            if( data.result ) {
                this.showPopupNumber = 1;
                fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode', this.eventCode.toString());
            } else {
                alert('데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망. (에러코드 : 001)');
            }
        },
        subscriptFail(xhr) {
            const _this = this;
            try {
                const err_obj = JSON.parse(xhr.responseText);
                switch (err_obj.code) {
                    case -10:
                        alert('이벤트에 응모를 하려면 로그인이 필요합니다.');
                        calllogin();
                        break;
                    case -603:
                        _this.showPopupNumber = 2;
                        break;
                    default:
                        alert(err_obj.message);
                }
            } catch(error) {
                alert('데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망. (에러코드 : 002)');
            }
        },
        //endregion

        //region 알림 신청 관련
        requestAlarm() {
            if( this.isApiCalling )
                return false;

            this.isApiCalling = true;
            this.postFrontApi('alarm', this.alarmSuccess, this.alarmFail);
        },
        alarmSuccess(data) {
            if( data.result ) {
                alert("알림신청이 완료됐습니다.");
            } else {
                alert('데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망. (에러코드 : 001)');
            }
        },
        alarmFail(xhr) {
            try {
                const err_obj = JSON.parse(xhr.responseText);
                switch (err_obj.code) {
                    case -10:
                        alert('알림신청을 하려면 로그인이 필요합니다.');
                        callLogin();
                        break;
                    case -603 :
                        alert('이미 알림신청을 하셨습니다.');
                        break;
                    default:
                        alert(err_obj.message);
                }
            } catch(error) {
                alert('데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망. (에러코드 : 003)');
            }
        },
        //endregion

        //region postFrontApi api 호출
        postFrontApi(type, success, fail) {
            const _this = this;

            $.ajax({
                type: "POST",
                url: apiurl + '/event/common/subscription',
                data: _this.createSendData(type),
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: success,
                error: fail,
                complete: function() {
                    _this.isApiCalling = false;
                }
            });
        },
        //endregion
        //region createSendData api 보내는 data 생성
        createSendData(type) {
            return {
                'event_code': this.eventCode,
                'event_option1': this.currentDate,
                'check_option1': false,
                'event_option3': type,
                'check_option3': true
            };
        },
        //endregion
        //region openFirstBuyShop 첫 구매샵 열기
        openFirstBuyShop() {
            fnAPPpopupBrowserRenewal('push', '첫구매샵', 'https://m.10x10.co.kr/apps/appCom/wish/web2014/event/benefit/');
        },
        //endregion
        //region shareKakao 카카오 공유
        shareKakao() {
            fnAPPshareKakao('etc','음악을 선물합니다','','',
                'url=http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=114117',
                'https://webimage.10x10.co.kr/fixevent/event/2021/114117/m/img_kakao.jpg',
                '','','',
                '당신의 가을을 음악으로 가득 채워 줄 턴테이블 세트를 9,900원에 구매하세요');
        },
        //endregion
        //region createClipBoard 클립보드 생성
        createClipBoard() {
            const clipboard = new Clipboard('#urlCopy');
            clipboard.on('success', function() {
                alert('URL이 복사 되었습니다.');
            });
            clipboard.on('error', function() {
                alert('URL을 복사하는 도중 에러가 발생했습니다.');
            });
        },
        //endregion
        //region createGiveawaySwiper 경품 슬라이더 생성
        createGiveawaySwiper() {
            new Swiper('.slide',{ slidesPerView: 2, });
        },
        //endregion
        closeWinner(){
            this.showPopupWinner = false;
        }
    }
});