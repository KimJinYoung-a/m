Vue.use(VueAwesomeSwiper)

const app = new Vue({
    el: '#app'
    , template : `
        <div class="mEvt116051">
            <div class="topic">
                <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_tit.jpg" alt="선착순 무료 배포 텐바이텐이 다이어리 쏜다! 여러분의 2021년을 응원하며, 텐바이텐이 내년 다이어리를 무료로 쏩니다!"></h2>
                <div class="number"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_number.png" alt="총 1,000개"></div>
                <div class="slide-area">
                    <swiper :options="swiperOption">
                        <swiper-slide>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_slide01.png?v=1.1" alt="diary">
                        </swiper-slide>
                        <swiper-slide>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_slide02.png?v=1.1" alt="diary">
                        </swiper-slide>
                        <swiper-slide>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_slide03.png?v=1.1" alt="diary">
                        </swiper-slide>
                        <swiper-slide>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_slide04.png?v=1.1" alt="diary">
                        </swiper-slide>
                        <swiper-slide>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_slide05.png?v=1.1" alt="diary">
                        </swiper-slide>
                        <swiper-slide>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_slide06.png?v=1.1" alt="diary">
                        </swiper-slide>
                        <swiper-slide>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_slide07.png?v=1.1" alt="diary">
                        </swiper-slide>
                        <swiper-slide>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_slide08.png?v=1.1" alt="diary">
                        </swiper-slide>
                        <swiper-slide>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_slide09.png?v=1.1" alt="diary">
                        </swiper-slide>
                        <swiper-slide>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_slide10.png?v=1.1" alt="diary">
                        </swiper-slide>
                    </swiper>
                </div>
            </div>
            
            <div v-if="is_app" class="section-01">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_sub_tit.jpg" alt="알람 신청하면 오픈되기 전에 잊지 않게 알려드릴게요!">
                <div class="go-link">
                    <button @click="click_popup('open')" type="button" class="btn-open"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_btn01.png" alt="사전 알림 신청하기"></button>
                </div>                
            </div>
            <div v-else class="section-01">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_sub_tit02.jpg" alt="지금 텐바이텐 APP에서 확인하세요!">
                <div class="go-link">
                    <a href="https://tenten.app.link/klUNJtlvRlb" class="btn-open"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_btn02.png" alt="APP 다운받고 참여하기"></a>
                </div>
            </div>
            
            <div class="section-02">
                <a href="/diarystory2021/" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_sub.jpg" alt="텐바이텐에서 28,487 개의 다이어리 중 나만의 다디어리를 찾아보세요!"></a>
            </div>
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_noti.jpg" alt="유의사항"></p>
            
            <div class="pop-container">
                <div class="pop-inner">
                    <div class="pop-contents">
                        <p class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_pop_txt.png" alt="오픈 시간이 다가오면 카카오 알림톡 또는 문자메시지로 빠르게 알려드립니다."></p>
                        <div class="pop-input">
                            <input type="number" id="phone" maxlength="11" @input="maxLengthCheck" placeholder="휴대폰 번호를 입력해주세요" />
                            <button @click="fnSendToKakaoMessage" type="button">확인</button>
                        </div>
                        <p class="notice"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116051/m/img_pop_txt02.png" alt="알림은 11월 23일 10시오픈 전에 1회만 발송되는 메시지입니다."></p>
                    </div>
                    <button @click="click_popup('close')" type="button" class="btn-close">닫기</button>
                </div>
            </div>
        </div>
    `
    , created() {
        let query_param = new URLSearchParams(window.location.search);
        this.setting_time = query_param.get("setting_time");

        let now  = new Date();
        now = now.getFullYear() + "-" + (now.getMonth()+1) + "-" + now.getDate() + " " + now.getHours() + ":" + now.getMinutes() + ":" + now.getSeconds();
        if(now > "2021-12-20 00:00:00"){
            if(isApp){
                location.href = "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=114083";
            }else{
                location.href = "/event/eventmain.asp?eventid=116052";
            }

        }
    }
    , data(){
        return {
            setting_time : ""
            , swiperOption: {
                slidesPerView: 'auto'
                , speed: 5000
                , autoplay: 1
                , loop:true
            }
            , is_app : isApp
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

                let request_date  = new Date();
                request_date = request_date.getFullYear() + "-" + (request_date.getMonth()+1) + "-" + request_date.getDate() + " " + request_date.getHours() + ":" + request_date.getMinutes() + ":" + request_date.getSeconds();
                console.log("request_date", request_date);

                $.ajax({
                    type:"GET",
                    url:"/apps/appCom/wish/web2014/event/timesale/v2/mkt/do_script.asp",
                    data: "mode=kamsg&testCheckDate=" + request_date + "&phoneNumber="+ btoa(phoneNumber),
                    dataType: "text",
                    async:false,
                    cache:true,
                    success : function(Data, textStatus, jqXHR){
                        if (jqXHR.readyState == 4) {
                            if (jqXHR.status == 200) {
                                if(Data!="") {
                                    var str;
                                    for(var i in Data){
                                        if(Data.hasOwnProperty(i)){
                                            str += Data[i];
                                        }
                                    }
                                    str = str.replace("undefined","");
                                    res = str.split("|");
                                    if (res[0]=="OK") {
                                        alert('신청이 완료되었습니다.');
                                        $("#phone").val('')
                                        $(".pop-container").fadeOut();
                                        return false;
                                    }else{
                                        errorMsg = res[1].replace(">?n", "\n");
                                        alert(errorMsg );
                                        return false;
                                    }
                                } else {
                                    alert("잘못된 접근 입니다.");
                                    document.location.reload();
                                    return false;
                                }
                            }
                        }
                    },
                    error:function(jqXHR, textStatus, errorThrown){
                        alert("잘못된 접근 입니다.");
                        return false;
                    }
                });
            }
        }
        , click_popup(type){
            if(type == "open"){
                $(".pop-container").fadeIn();
            }else{
                $(".pop-container").fadeOut();
            }
        }
    }
});