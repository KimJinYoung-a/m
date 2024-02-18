const app = new Vue({
    el: '#app'
    , store : store
    , mixin : [common_mixin]
    , template : `
        <div v-show="now_mikki.itemid" class="mEvt111787 time-sale">
            <div class="time-ing">
                <div class="top">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/img_main.jpg?v=2.1" alt="시작합니다. 오늘의 타임세일">
                    <!-- 몇시타임 진행중인지 타임 노출 리스트 -->
                    <div class="show-time-current">
                        <div class="time-current-wrap">
                            <div v-for="item in mikki_time">
                                <img :src="'//upload.10x10.co.kr/linkweb/timesale/time_' + item.active_name + '_' + item.mikki_time + '.png'" :alt="item.mikki_time + '시 노출'" />
                            </div>
                        </div>
                    </div>
                    <div class="tit-ready"><h2>{{time_text}}</h2></div>
                    <div class="sale-timer">
                        <div><span>-</span><span id="countdown">00:00:00</span></div>
                    </div>
                </div>
                <div class="list-wrap">
                    <!-- 6/7일 타임세일 상품 리스트 -->
                    <div class="special-item">
                        <ul id="list1" class="list list1">
                            <li :class="[{'sold-out' : now_mikki.is_soldout, 'not-open' : now_mikki.is_open == 'N'}]">
                                <a @click="goDirOrdItem(now_mikki.itemid)">
                                    <div class="product-inner">
                                        <div class="thum"><img :src="now_mikki.moItemImage" :alt="now_mikki.itemName"></div>
                                        <div class="desc">
                                            <p class="name">{{now_mikki.itemName}}</p>
                                            <div class="price"><s>{{format_price(now_mikki.orgPrice)}}</s> {{format_price(now_mikki.sellCash)}} <span class="p-won">원</span><span class="sale">{{now_mikki.saleValue}}%</span></div>
                                            <p class="buy_now"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/btn_purchase.png" alt="바로 구매"></p>
                                        </div>
                                        <span class="num-limite">{{now_mikki.itemCnt}}개 한정</span>
                                    </div>
                                </a>
                            </li>    
                            <p class="txt-noti">선착순 특가 상품 구매 시 하단의 '유의사항'을 참고 바랍니다.</p>                        
                        </ul>                        
                    </div>
                    
                    <!-- MD상품 -->
                    <ul v-if="time_text != '세일 오픈까지'" id="itemList"></ul>
                    <!--// MD상품 -->
                </div>
                <!-- 오픈예정 상품 리스트 -->
                <div v-show="pre_mikki.length > 0" class="ready_list_wrap">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/tit_ready.png" alt="잠시 후 오픈합니다.">
                    <div class="product-list">
                        <ul id="list2" class="list list2">
                            <li v-for="(item, index) in pre_mikki">
                                <p class="open-time">{{item.mikki_time >= 12 ? '오후' : '오전'}} <span><em>{{item.mikki_time - 12 > 0 ? item.mikki_time - 12 : item.mikki_time}}</em>시</span></p>
                                <!--<img :src="'//upload.10x10.co.kr/linkweb/timesale/teaser/m/time_header_' + item.mikki_time + '.png'" alt="시간" />-->
                                <div class="product-inner">
                                    <img :src="item.moTzImage" :alt="item.itemName">
                                    <span class="num-limite"><em>{{item.itemCnt}}</em>개 한정</span>
                                </div>
                            </li>                            
                        </ul>
                    </div>
                </div>
                <!-- 오늘, 지난 시간 판매 완료된 상품 리스트 -->
                <div v-show="post_mikki.length > 0" class="sold-out-list">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/tit_sold.png?v=3" alt="오늘, 지난시간 판매 완료된 대표 상품">
                    <div class="slide-area">
                        <div class="swiper-container">
                            <ul id="lis3" class="list list3 swiper-wrapper">
                                <!-- 판매완료 상품 class sold-out 추가 -->
                                <li v-for="item in post_mikki" :class="['swiper-slide', 'sold-prd', {'sold-out' : item.limitno - item.limitsold < 1}]">
                                    <div class="tit-prd">
                                        <div class="thum"><img :src="item.moSoldoutImage" :alt="item.itemName"></div>
                                        <div class="desc">
                                            <p class="name">{{item.itemName}}</p>
                                            <div class="price"><s>{{item.orgPrice}}</s> {{item.sellCash}} <span class="p-won">원</span><span class="sale">{{item.saleValue}}%</span></div>
                                        </div>
                                    </div>
                                    <div class="sold-time">
                                        <p class="am">{{item.mikki_time > 12 ? '오후' : '오전'}} <em>{{item.mikki_time - 12 > 0 ? item.mikki_time - 12 : item.mikki_time}}</em>시</p>
                                    </div>
                                </li>                                
                            </ul>                               
                        </div>
                    </div>
                </div>

                <!-- 유의사항 -->
                <div class="noti-area">
                    <button type="button" class="btn-noti"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/tit_noti.jpg" alt="유의사항 확인하기"><span class="arrow"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/icon_noti_arrow.png" alt=""></span></button>
                    <div class="noti-info"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/img_noti_info.jpg?v=2" alt="유의사항"></div>
                </div>

                <!-- 다음 타임세일 시작전 알림받기 -->
                <div v-show="next_schedule != null" class="teaser-timer">
                    <div>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/img_left_time02.jpg" alt="다음 타임세일 시간을 잊을까봐 걱정된다면?">
                        <!-- 알림팝업 노출 버튼 -->
                        <button type="button" class="btn-push"></button>
                    </div>
                </div>
                
                <!-- 쿠폰영역 생성 -->
                <!--<div class="coupon-area">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/111786_m.jpg" alt="쿠폰 바로가기">
                    <a @click="go_coupon" href="javascript:void(0)" class="go-coupon"></a>
                </div>-->
            </div>

            <!-- 알림받기 팝업 -->
            <div class="lyr lyr-alarm" style="display:none;">
                <div class="inner">
                    <p><img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/txt_push.png?v=2" alt="기회를 놓치지 않는 가장 확실한 방법"></p>
                    <!-- 휴대폰 번호 입력 input -->
                    <div class="input-box">
                        <input type="number" id="phone" placeholder="휴대폰 번호를 입력해주세요" />
                        <button @click="fnSendToKakaoMessage" type="button" class="btn-submit">확인</button>
                    </div>
                    <button class="btn-close"></button>
                </div>
            </div>

            <form method="post" name="directOrd" action="">
                <input type="hidden" name="itemid" id="itemid" value="">
                <input type="hidden" name="itemoption" value="0000">
                <input type="hidden" name="itemea" value="1">
                <input type="hidden" name="sitename" :value="rd_sitename" />
                <input type="hidden" name="isPresentItem" value="" />
                <input type="hidden" name="mode" value="">
            </form>
        </div>
    `
    , created() {
        let query_param = new URLSearchParams(window.location.search);
        this.$store.commit("SET_EVT_CODE", query_param.get("eventid"));
        this.$store.dispatch("GET_DATA");
        this.$store.dispatch("GET_NEXT_SCHEDULE");

        this.setting_time = query_param.get("setting_time");

        this.isUserLoginOK = isUserLoginOK;
        this.rd_sitename = rd_sitename;
    }
    , mounted(){
        const _this = this;
        this.$nextTick(function() {
            if(isApp){
                $("form[name=directOrd]").attr("action", "/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp");
                $("input[name=mode]").val("DO3");
            }else{
                $("form[name=directOrd]").attr("action", "/inipay/shoppingbag_process.asp");
                $("input[name=mode]").val("DO1");
            }

            // 알림받기 레이어
            $('.btn-push').click(function (e) {
                $('.lyr-alarm').show();
            });
            // 레이어 닫기
            $('.btn-close').click(function (e) {
                $('.lyr').hide();
            });
            //유의사항 버튼
            $('.btn-noti').on("click",function(){
                $('.noti-info').toggleClass("on");
                $(this).toggleClass("on");
            });
        });
    }
    , computed : {
        normal_list(){
            return this.$store.getters.normal_list;
        }
        , schedule_idx() {
            return this.$store.getters.schedule_idx;
        }
        , mikki_time(){
            return this.$store.getters.mikki_time;
        }
        , time_text(){
            return this.$store.getters.time_text;
        }
        , now_mikki(){
            return this.$store.getters.now_mikki;
        }
        , pre_mikki(){
            return this.$store.getters.pre_mikki;
        }
        , post_mikki() {
            return this.$store.getters.post_mikki;
        }
        , next_mikki(){
            return this.$store.getters.next_mikki;
        }
        , evt_code(){
            return this.$store.getters.evt_code;
        }
        , next_schedule() {
            return this.$store.getters.next_schedule;
        }
    }
    , data(){
        return {
            setting_time : ""
            , isUserLoginOK : ""
            , rd_sitename : ""
            , is_buying : false

            , swiper : null
        }
    }
    , methods : {
        format_price(price){
            if(price){
                return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
            }
        }
        , goDirOrdItem(itemid){
            if(itemid){
                if(this.isUserLoginOK == "False"){
                    if(confirm("로그인을 하셔야 이벤트에 참여하실 수 있습니다.")){
                        if(isApp){
                            calllogin();
                        }else{
                            jsChklogin_mobile('','/event/eventmain.asp?eventid=' + this.evt_code);
                        }
                    }
                }else if(loginUserLevel == 7 && (!isProduction && loginUserID != "corpse2"&& loginUserID != "seojb1983"&& loginUserID != "pinokio5600")){
                    alert("텐바이텐 스탭은 참여할 수 없습니다.");
                }else{
                    const _this = this;

                    if(this.is_buying){
                        return false;
                    }
                    this.is_buying = true;

                    let query_param = new URLSearchParams(window.location.search);
                    let setting_time = query_param.get("setting_time");
                    let data = {"evt_code" : this.evt_code , "schedule_idx" : this.schedule_idx, "itemid" : itemid};
                    if(setting_time){
                        data = {"evt_code" : this.evt_code , "schedule_idx" : this.schedule_idx, "itemid" : itemid, "setting_time" : setting_time}
                    }

                    call_api("GET", "/timedeal/timedeal-now-mikki-realtime", data, function (data){
                        if(data.buyable == 0){
                            alert("응모 가능한 상태가 아닙니다.");
                            _this.is_buying = false;
                            return false;
                        }else if(data.limitno - data.limitsold < 1) {
                            alert("준비된 수량이 소진되었습니다.");
                            _this.is_buying = false;
                            return false;
                        }else if(data.bought_count > 0){
                            alert("이미 1개 결제하셨습니다.\nID당 1회만 구매 가능합니다.");
                            _this.is_buying = false;
                            return false;
                        }else{
                            call_api("POST", "/timedeal/timedeal-eventlog", {"evt_code" : _this.evt_code, "mode" : "order", "itemid" : itemid, "device" : "M"});

                            call_api("GET", "/timedeal/timedeal-order-count-check", {"itemid" : itemid}, function(data){
                                console.log("timedeal-order-count-check", data);
                                _this.is_buying = false;
                                if(data){
                                    $("#itemid").val(itemid);
                                    setTimeout(function() {
                                        document.directOrd.submit();
                                    },300);
                                }else{
                                    alert("준비된 수량이 소진되었습니다.");
                                    return false;
                                }
                            });
                        }
                    });
                }
            }
        }
        , fnSendToKakaoMessage(){
            const _this = this;

            if ($("#phone").val() == '' || $("#phone").val().length > 13) {
                alert('알림 받으실 전화번호를 정확히 입력해 주세요.');
                $("#phone").focus();
                return;
            }else{
                let phoneNumber;
                if ($("#phone").val().length > 10) {
                    phoneNumber = $("#phone").val().substring(0,3)+ "-" +$("#phone").val().substring(3,7)+ "-" +$("#phone").val().substring(7,11);
                } else {
                    phoneNumber = $("#phone").val().substring(0,3)+ "-" +$("#phone").val().substring(3,6)+ "-" +$("#phone").val().substring(6,10);
                }

                let request_date
                if(this.setting_time){
                    request_date = new Date();
                    request_date.setMinutes(request_date.getMinutes() - 2);
                }else{
                    request_date = new Date(
                        this.next_schedule.substr(0, 4)
                        , this.next_schedule.substr(5, 2) - 1
                        , this.next_schedule.substr(8, 2)
                        , /*this.next_schedule.substr(11, 2)*/ "09"
                        , this.next_schedule.substr(14, 2)
                        , this.next_schedule.substr(17, 2)
                    );
                    request_date.setMinutes(request_date.getMinutes() - 20);
                }
                request_date = request_date.getFullYear() + "-" + (request_date.getMonth() + 1) + "-" + request_date.getDate() + " " + request_date.getHours() + ":" + request_date.getMinutes() + ":" + request_date.getSeconds();
                //console.log("request_date", request_date);

                call_api("POST", "/timedeal/timedeal-kakao-joined", {"evt_code" : this.evt_code, "schedule_idx" : this.schedule_idx + 1, "usercell" : phoneNumber}, function (data){
                    if(!data){
                        alert("이미 알림톡 서비스를 신청 하셨습니다.");
                    }else{
                        let fullText = "신청하신 [타임세일] 이벤트 알림입니다.\n\n";
                        fullText += "잠시 후 9시부터 이벤트 참여가 가능합니다.\n\n";
                        fullText += "맞아요, 이 가격.\n";
                        fullText += "고민하는 순간 품절됩니다.\n";
                        fullText += "서두르세요!";

                        let failText = "[텐바이텐] 신청하신 타임세일 이벤트 알림입니다."

                        let btnJson = '{"button":[{"name":"참여하러 가기","type":"WL","url_mobile":"https://tenten.app.link/n0YytasjKeb"}]}';

                        let join_request = {"evt_code" : _this.evt_code, "usercell" : phoneNumber
                            , "request_date" : request_date.toString(), "fullText" : fullText, "failText" : failText, "btnJson" : btnJson};
                        //console.log("join_request", join_request);

                        call_api("POST", "/timedeal/timedeal-kakao-join", join_request, function (data){
                            if(data > 0){
                                alert("신청이 완료되었습니다.");
                                $("#phone").val('');
                                $('.lyr').hide();
                            }else{
                                alert("신청 실패. 오류발생");
                            }
                        });
                    }
                });
            }
        }
        , go_coupon(){
            if(isApp){
                fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp?tab=2');
            }else{
                location.href = "/my10x10/couponbook.asp?tab=2";
            }
        }
    }
    , watch : {
        next_mikki(data){
            let now = new Date();

            if(this.setting_time){
                console.log("countdown by setting_time", this.setting_time);
                now = new Date(
                    this.setting_time.substr(0, 4)
                    , this.setting_time.substr(5, 2) - 1
                    , this.setting_time.substr(8, 2)
                    , this.setting_time.substr(11, 2)
                    , this.setting_time.substr(14, 2)
                    , this.setting_time.substr(17, 2)
                );
            }

            countDownTimer(data.substr(0, 4)
                , data.substr(5, 2)
                , data.substr(8, 2)
                , data.substr(11, 2)
                , data.substr(14, 2)
                , data.substr(17, 2)
                , now
            );
        }
    }
});