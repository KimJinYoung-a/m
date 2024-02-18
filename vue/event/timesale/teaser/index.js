const app = new Vue({
    el: '#app'
    , store : store
    , mixin : [common_mixin]
    , template : `
        <div class="mEvt111786">
            <!-- 티저 main -->
            <div class="teaser-main">
                <div>
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/img_teaser_main.jpg?v=2.1" alt="타임세일 티저">
                    <div class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/tit_teaser_txt01.png" alt="이건 기회야"></div>
                    <!-- 이미지아이콘 영역 -->
                    <div class="item-area">
                        <div class="thumb item1"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/time_1.png" alt="item" class="item1"></div>
                    </div>
                </div>
            </div>
            
            <div class="time-ing">
                <div class="list-wrap">
                    <!-- 티저 상품 -->
                    <div class="product-list">
                        <ul id="list1" class="list list1">
                            <li v-for="(item, index) in mikki_list">
                                <img :src="'//webimage.10x10.co.kr/fixevent/event/2021/111786/m/time_header_0' + (index +1) + '.png'" alt="시간 이미지">
                                <div class="product-inner">
                                    <img :src="item.moTzImage" :alt="item.itemName">
                                    <span class="num-limite"><em>{{item.itemCnt}}</em>개 한정</span>
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

            <!-- 티저 시작전 알림받기 -->
            <div class="teaser-timer">
                <div>
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/img_left_time.jpg" alt="타임세일 시작까지">
                    <div class="sale-timer">
                        <div><span>-</span><span id="countdown">00:00:00</span></div>
                    </div>
                    <!-- 알림팝업 노출 버튼 -->
                    <button type="button" class="btn-push"></button>
                </div>
            </div>

            <!-- 알림받기 팝업 -->
            <div class="lyr lyr-alarm" style="display:none;">
                <div class="inner">
                    <p><img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/txt_push.png?v=2" alt="기회를 놓치지 않는 가장 확실한 방법"></p>
                    <!-- 휴대폰 번호 입력 input -->
                    <div class="input-box">
                        <input type="number" id="phone" maxlength="11" @input="maxLengthCheck" placeholder="휴대폰 번호를 입력해주세요" />
                        <button type="button" class="btn-submit" @click="fnSendToKakaoMessage">확인</button>
                    </div>
                    <button class="btn-close"></button>
                </div>
            </div>                
        </div>
    `
    , created() {
        let query_param = new URLSearchParams(window.location.search);
        this.$store.dispatch("GET_MIKKI_LIST", query_param.get("eventid"));
        this.$store.dispatch("GET_TEASER_INFO", query_param.get("eventid"));

        this.setting_time = query_param.get("setting_time");
    }
    , mounted(){
        this.$nextTick(function() {
            let i=1;
            let repeat = setInterval(function(){
                i++;
                if(i>4){i=1;}
                $('.teaser-main .item-area .thumb img').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/111786/m/time_'+ i +'.png?v=2').attr('class','item' + i);
                /* if(i == 5) {
                    clearInterval(repeat);
                } */
            },1000);

            //유의사항 버튼
            $('.btn-noti').on("click",function(){
                $('.noti-info').toggleClass("on");
                $(this).toggleClass("on");
            });
            // 알림받기 팝업
            $('.btn-push').click(function (e) {
                $('.lyr-alarm').show();
            });
            // 팝업 닫기
            $('.btn-close').click(function (e) {
                $('.lyr').hide();
            });
        });
    }
    , computed : {
        mikki_list(){
            return this.$store.getters.mikki_list;
        }
        , teaser_info(){
            return this.$store.getters.teaser_info;
        }
    }
    , data(){
        return {
            setting_time : ""
        }
    }
    , methods : {
        maxLengthCheck(object){
            if (object.target.value.length > object.target.maxLength){
                object.target.value = object.target.value.slice(0, object.target.maxLength);
            }
        }
        , fnSendToKakaoMessage() {
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

                let request_date;
                let real_evt_code = this.teaser_info.evt_code;
                if(this.setting_time){
                    request_date = new Date();
                    request_date.setMinutes(request_date.getMinutes() - 2);
                }else{
                    request_date = new Date(
                        this.mikki_list[0].startDate.substr(0, 4)
                        , this.mikki_list[0].startDate.substr(5, 2) - 1
                        , this.mikki_list[0].startDate.substr(8, 2)
                        , this.mikki_list[0].startDate.substr(11, 2)
                        , this.mikki_list[0].startDate.substr(14, 2)
                        , this.mikki_list[0].startDate.substr(17, 2)
                    );

                    request_date.setMinutes(request_date.getMinutes() - 20);
                }
                request_date = request_date.getFullYear() + "-" + (request_date.getMonth() + 1) + "-" + request_date.getDate() + " " + request_date.getHours() + ":" + request_date.getMinutes() + ":" + request_date.getSeconds();
                //console.log("request_date", request_date);

                call_api("POST", "/timedeal/timedeal-kakao-joined", {"evt_code" : real_evt_code, "schedule_idx" : "0" + (this.teaser_info.schedule_idx + 1), "usercell" : phoneNumber}, function (data){
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

                        let join_request = {"evt_code" : real_evt_code, "schedule_idx" : "0" + (_this.teaser_info.schedule_idx + 1), "usercell" : phoneNumber
                            , "request_date" : request_date.toString(), "fullText" : fullText, "failText" : failText, "btnJson" : btnJson};
                        //console.log("join_request", join_request);

                        call_api("POST", "/timedeal/timedeal-kakao-join", join_request, function (data){
                            if(data > 0){
                                alert("신청이 완료되었습니다.");
                                $("#phone").val('');
                                $(".pop-container").fadeOut();
                            }else{
                                alert("신청 실패. 오류발생");
                            }
                        });
                    }
                });
            }
        }
    }
    , watch : {
        mikki_list(data){
            console.log("data", data);
            let now = new Date();

            if(this.setting_time){
                now = new Date(
                    this.setting_time.substr(0, 4)
                    , this.setting_time.substr(5, 2) - 1
                    , this.setting_time.substr(8, 2)
                    , this.setting_time.substr(11, 2)
                    , this.setting_time.substr(14, 2)
                    , this.setting_time.substr(17, 2)
                );
            }

            countDownTimer(data[0].startDate.substr(0, 4)
                , data[0].startDate.substr(5, 2)
                , data[0].startDate.substr(8, 2)
                , data[0].startDate.substr(11, 2)
                , data[0].startDate.substr(14, 2)
                , data[0].startDate.substr(17, 2)
                , now
            );
        }
    }
});