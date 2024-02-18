const app = new Vue({
    el: '#app'
    , template : `
        <div class="mEvt113819">
            <div class="topic">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_main.jpg?v=2" alt="핑크템 콤보">
                <div class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113819/m/tit_top.png" alt="응모이벤트"></div>
            </div>
            <div class="section-apply">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_sub01.jpg?v=2.1" alt="구성품">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_item01_prd01.png" alt="ipad pro" class="item01">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_item02_prd01.png" alt="산리오" class="item02">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_item03_prd01.png" alt="로지텍 키보드" class="item03">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_item04_prd01.png" alt="로지텍 마우스" class="item04">
                <!-- 응모하기 버튼 -->
                <!-- for dev msg : 비로그인 : 로그인 페이지 / 로그인 : 팝업노출 -->
                <button @click="go_enter('try')" type="button" class="btn-apply hiddens">응모하기</button>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113819/m/icon_arrow_right.png" alt="" class="icon-arr">
            </div>
            <img src="//webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_info.jpg?v=2" alt="이벤트 기간 : 9월1일 - 9월19일">
            <div class="section-detail">
                <div class="btn-area">
                    <button type="button" class="btn-detail">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113819/m/btn_noti.jpg?v=2" alt="유의사항을 꼭 확인하세요." />
                        <span class="icon"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113819/m/icon_arrow.png?v=2" alt=""></span>
                    </button>
                    <div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_detail.jpg?v=2" alt="이벤트 유의사항" /></div>
                </div>
            </div>
            <div class="section-alram">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_alram.jpg?v=2" alt="당첨자 알림 신청">
                <button @click="go_enter('alarm')" type="button" class="btn-alram"></button>
            </div>
            <div class="section-prd"> 
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_prd.jpg?v=2" alt="내가 좋아할 스타일을 찾아보세요.">
                <div class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113819/m/tit_top02.png" alt="look it up!"></div>
                <a href="#" onclick="fnAPPpopupProduct('3672138&pEtr=113819'); return false;" class="prd01 hiddens">라이프썸 슬림 블루투스 키보드</a>
                <a href="#" onclick="fnAPPpopupProduct('1849950&pEtr=113819'); return false;" class="prd02 hiddens">엑트 헨디 버티컬 손목보호 마우스</a>
                <a href="#" onclick="fnAPPpopupProduct('3746513&pEtr=113819'); return false;" class="prd03 hiddens">트렌잇 멀티디바이스 거치대</a>
                <a href="#" onclick="fnAPPpopupProduct('2534823&pEtr=113819'); return false;" class="prd04 hiddens">페나 키보드-타자기 컨셉 블루투스 무선</a>
                <a href="#" onclick="fnAPPpopupProduct('2216981&pEtr=113819'); return false;" class="prd05 hiddens">로지텍코리아 keys to go 애플 호환 블루트스</a>
                <a href="#" onclick="fnAPPpopupProduct('3566493&pEtr=113819'); return false;" class="prd06 hiddens">위글위글 말랑무선마우스</a>
                <a href="#" onclick="fnAPPpopupProduct('3971346&pEtr=113819'); return false;" class="prd07 hiddens">헬로키티 저소음 무선마우스 + 무선충전 마우스패드</a>
                <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=113467');return false;" class="btn-event"></a>
            </div>
            <div class="section-first">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_first.jpg" alt="텐바이텐이 처음이라면?">
                <!-- 신규혜택 페이지로 이동 -->
                <a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '혜택 가이드', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/benefit/');return false;" class="btn-new"></a>
            </div>

            <!-- 팝업 - 응모완료 -->
            <div class="pop-container first">
                <div class="pop-inner">
                    <div class="pop-contents">
                        <div class="name"><span>{{userid}}</span> 님</div>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113819/m/pop_apply.jpg?v=1.01" alt="응모완료">
                        <!-- 알림받기 버튼 -->
                        <button @click="go_enter('alarm')" type="button" class="btn-talk"></button>
                    </div>
                    <button type="button" class="btn-close">닫기</button>
                </div>
            </div>
            <!-- 팝업 - 이미 응모한 경우 -->
            <div class="pop-container already">
                <div class="pop-inner">
                    <div class="pop-contents">
                        <div class="name"><span>{{userid}}</span> 님</div>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113819/m/pop_apply02.jpg?v=1.01" alt="이미 응모 완료">
                        <button @click="go_share" type="button" class="btn-kakao"></button>
                        <button type="button" class="btn-url" id="urlcopy" data-clipboard-text="https://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=113819"></button>
                    </div>
                    <button type="button" class="btn-close">닫기</button>
                </div>
            </div>
            <!-- 당첨안내 팝업 -->
            <div class="pop-container win">
                <div class="pop-inner">
                    <div class="pop-contents">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113819/m/pop_win.png" alt="당첨자 발표">
                        <a href="https://m.10x10.co.kr/shoppingtoday/shoppingchance_allevent.asp?scTgb=mktevt" target="_blank" class="mWeb go_link"></a>
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','https://m.10x10.co.kr/apps/appcom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp?scTgb=mktevt'); return false;" class="mApp go_link"></a>
                    </div>
                    <button type="button" class="btn-close">닫기</button>
                </div>
            </div>
        </div>
    `
    , created() {
        let query_param = new URLSearchParams(window.location.search);
        this.event_code =  query_param.get("eventid");

        this.isLoginOk = isLoginOk;
        this.userid = userid;
    }
    , mounted(){
        /* 팝업 닫기 */
        $('.mEvt113819 .btn-close').click(function(){
            $(".pop-container").fadeOut();
        })
        // btn more
        $('.mEvt113819 .btn-detail').click(function (e) {
            $(this).next().toggleClass('on');
            $(this).find('.icon').toggleClass('on');
        });
        /* 이미지 순차 노출 */
        changingImg();
        function changingImg(){
            var i=1;
            var repeat = setInterval(function(){
                i++;
                if(i>2){i=1;}
                $('.mEvt113819 .item01').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_item01_prd0'+ i +'.png');
                $('.mEvt113819 .item02').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_item02_prd0'+ i +'.png');
                $('.mEvt113819 .item03').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_item03_prd0'+ i +'.png');
                $('.mEvt113819 .item04').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_item04_prd0'+ i +'.png');
                /* if(i == 5) {
                    clearInterval(repeat);
                } */
            },1300);
        }

        let clipboard = new Clipboard('#urlcopy');
        clipboard.on('success', function(e) {
            alert('URL이 복사 되었습니다.');
            console.log(e);
        });
        clipboard.on('error', function(e) {
            console.log(e);
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
            isLoginOk : false
            , userid : ""
            , ing_enter : false
            , event_code : ""
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
        , go_enter(type){
            const _this = this;

            if(!isLoginOk) {
                calllogin();
            }else{
                if (this.ing_enter) {
                    return false;
                }

                _this.ing_enter = true;

                let api_data = {
                    "event_code" : _this.event_code
                    , check_option1: false
                    , "event_option3" : type
                    , check_option3 : true
                };
                this.call_api("POST", "/event/common/subscription", api_data
                    , function (data){
                        if( data.result ) {
                            if(type == "alarm"){
                                alert("알림신청이 완료됐습니다.");
                            }else{
                                $('.pop-container.first').fadeIn();
                            }

                            fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode', _this.event_code);
                        } else {
                            alert('데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망. (에러코드 : 001)');
                        }
                    }, function(xhr){
                        console.log(xhr.responseText);
                        try {
                            const err_obj = JSON.parse(xhr.responseText);
                            console.log(err_obj);
                            switch (err_obj.code) {
                                case -10: alert('이벤트에 응모를 하려면 로그인이 필요합니다.'); return false;
                                case -603 :
                                    if(type == "alarm"){
                                        alert("이미 알림신청을 하셨습니다.");
                                    }else{
                                        $('.pop-container.already').fadeIn();
                                    }
                                    break;
                                default: alert(err_obj.message); return false;
                            }
                        }catch(error) {
                            console.log(error);
                            alert('데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망. (에러코드 : 002)');
                        }
                    }, () => {
                        _this.ing_enter = false;
                    }
                );
            }
        }
        , go_share(){
            fnAPPshareKakao('etc','핑크템 콤보','','','url=http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=113819','https://webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_kakao.jpg','','','','텐바이텐에 핑크에 진심인 분들께 핑크 콤보팩을 선물합니다.');
        }
    }
});