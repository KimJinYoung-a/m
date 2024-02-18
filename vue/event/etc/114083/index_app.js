const app = new Vue({
    el: '#app'
    , template : `
        <div class="mEvt114083">
            <section v-show="show_section == 1" class="section01">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/section01.jpg?v=3" alt="">
                <button @click="go_section(2)" class="next"></button>
            </section>
            
            <section v-show="show_section == 2" class="section02">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/bg_quiz.jpg" alt="">
                <div v-show="show_quiz == 1" class="quiz quiz01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz01.png" alt="">
                    <div class="quiz_wrap">
                        <p :class="['q01', {on : quiz_choice[0] == 1}]"><img @click="click_quiz_answer(1, 1)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz01_01.png" :alt="show_section"></p>
                        <p :class="['q02', {on : quiz_choice[0] == 2}]"><img @click="click_quiz_answer(1, 2)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz01_02.png" alt=""></p>
                        <p :class="['q03', {on : quiz_choice[0] == 3}]"><img @click="click_quiz_answer(1, 3)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz01_03.png" alt=""></p>
                        <p :class="['q04', {on : quiz_choice[0] == 4}]"><img @click="click_quiz_answer(1, 4)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz01_04.png" alt=""></p>
                    </div>
                    <button @click="go_quiz_submit(1)" class="submit"></button>
                </div>
                <div v-show="show_quiz == 2" class="quiz quiz02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz02.png" alt="">
                    <div class="quiz_wrap">
                        <p :class="['q01', {on : quiz_choice[1] == 1}]"><img @click="click_quiz_answer(2, 1)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz02_01.png" alt=""></p>
                        <p :class="['q02', {on : quiz_choice[1] == 2}]"><img @click="click_quiz_answer(2, 2)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz02_02.png" alt=""></p>
                        <p :class="['q03', {on : quiz_choice[1] == 3}]"><img @click="click_quiz_answer(2, 3)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz02_03.png" alt=""></p>
                        <p :class="['q04', {on : quiz_choice[1] == 4}]"><img @click="click_quiz_answer(2, 4)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz02_04.png" alt=""></p>
                    </div>
                    <button @click="go_quiz_submit(2)" class="submit"></button>
                </div>
                <div v-show="show_quiz == 3" class="quiz quiz03">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz03.png" alt="">
                    <div class="quiz_wrap">
                        <p :class="['q01', {on : quiz_choice[2] == 1}]"><img @click="click_quiz_answer(3, 1)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz03_01.png" alt=""></p>
                        <p :class="['q02', {on : quiz_choice[2] == 2}]"><img @click="click_quiz_answer(3, 2)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz03_02.png" alt=""></p>
                        <p :class="['q03', {on : quiz_choice[2] == 3}]"><img @click="click_quiz_answer(3, 3)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz03_03.png" alt=""></p>
                        <p :class="['q04', {on : quiz_choice[2] == 4}]"><img @click="click_quiz_answer(3, 4)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz03_04.png" alt=""></p>
                    </div>
                    <button @click="go_quiz_submit(3)" class="submit"></button>
                </div>
                <div v-show="show_quiz == 4" class="quiz quiz04">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz04.png" alt="">
                    <div class="quiz_wrap">
                        <p :class="['q01', {on : quiz_choice[3] == 1}]"><img @click="click_quiz_answer(4, 1)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz04_01.png" alt=""></p>
                        <p :class="['q02', {on : quiz_choice[3] == 2}]"><img @click="click_quiz_answer(4, 2)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz04_02.png" alt=""></p>
                        <p :class="['q03', {on : quiz_choice[3] == 3}]"><img @click="click_quiz_answer(4, 3)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz04_03.png" alt=""></p>
                        <p :class="['q04', {on : quiz_choice[3] == 4}]"><img @click="click_quiz_answer(4, 4)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz04_04.png" alt=""></p>
                    </div>
                    <button @click="go_quiz_submit(4)" class="submit"></button>
                </div>
                <div v-show="show_quiz == 5" class="quiz quiz05">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz05.png" alt="">
                    <div class="quiz_wrap">
                        <p :class="['q01', {on : quiz_choice[4] == 1}]"><img @click="click_quiz_answer(5, 1)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz05_01.png" alt=""></p>
                        <p :class="['q02', {on : quiz_choice[4] == 2}]"><img @click="click_quiz_answer(5, 2)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz05_02.png" alt=""></p>
                        <p :class="['q03', {on : quiz_choice[4] == 3}]"><img @click="click_quiz_answer(5, 3)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz05_03.png" alt=""></p>
                        <p :class="['q04', {on : quiz_choice[4] == 4}]"><img @click="click_quiz_answer(5, 4)" src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz05_04.png" alt=""></p>
                    </div>
                    <button @click="go_quiz_submit(5)" class="submit"></button>
                </div>
                <div v-show="success_flag || fail_flag" @click="close_popup" class="popup">
                    <div class="bg_dim"></div>
                    <div v-show="success_flag" class="pop success">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/success.png" alt="">
                    </div>
                    <div v-show="fail_flag" class="pop fail">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/fail.png" alt="">
                    </div>
                </div>
            </section>
            
            <section v-show="show_section == 3" class="section03">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/result.png" alt="">
                <a @click="go_section(4)" href="javascript:void(0)" class="btn_close"></a>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/list01.png" alt="">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/list02.png" alt="">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/list03.png" alt="">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/list04.png" alt="">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/list05.png" alt="">
                <button @click="go_section(4)"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/btn_score.png" alt=""></button>
            </section>
            
            <section v-show="show_section == 4" class="section04">
                <div v-if="total_point == 100" class="result result01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/result01.png" alt="">
                    <a @click="click_sns_layer('open')" href="javascript:void(0)" class="share"></a>
                    <a href="#group382147" class="shopping"></a>
                </div>
                <div v-else-if="total_point == 80" class="result result02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/result02.png" alt="">
                    <a @click="click_sns_layer('open')" href="javascript:void(0)" class="share"></a>
                    <a href="#group382147" class="shopping"></a>
                </div>
                <div v-else-if="total_point == 60" class="result result03">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/result03.png" alt="">
                    <a @click="click_sns_layer('open')" href="javascript:void(0)" class="share"></a>
                    <a href="#group382147" class="shopping"></a>
                </div>
                <div v-else-if="total_point == 40" class="result result04">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/result04.png" alt="">
                    <a @click="click_sns_layer('open')" href="javascript:void(0)" class="share"></a>
                    <a href="#group382147" class="shopping"></a>
                </div>
                <div v-else-if="total_point == 20" class="result result05">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/result05.png" alt="">
                    <a @click="click_sns_layer('open')" href="javascript:void(0)" class="share"></a>
                    <a href="#group382147" class="shopping"></a>
                </div>
                <div v-else class="result result06">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114083/m/result06.png" alt="">
                    <a @click="click_sns_layer('open')" href="javascript:void(0)" class="share"></a>
                    <a href="#group382147" class="shopping"></a>
                </div>
            </section>
            
            <div id="lySns" class="ly-sns">
                <div class="inner fixed-bottom">
                    <div class="tenten-header header-popup header-white">
                        <div class="title-wrap">
                            <h2>공유하기</h2>
                            <button @click="click_sns_layer('close')" type="button" class="btn-close">닫기</button>
                        </div>
                    </div>
                    <!-- app-->
                    <div class="sns-list">
                        <ul>
                            <li><a @click="go_share('kakao')" href="javascript:void(0)"><span class="icon icon-kakao">카카오톡으로 공유</span></a></li>
                            <li><a @click="go_share('facebook')" href="javascript:void(0)"><span class="icon icon-facebook">페이스북으로 공유</span></a></li>
                            <li><a @click="go_share('twitter')" href="javascript:void(0)"><span class="icon icon-twitter">트위터로 공유</span></a></li>
                            <li class="share-url">
                                <div class="ellipsis">https://m.10x10.co.kr/event/eventmain.asp?eventid=114419</div>
                                <button @click="go_share('clipboard')" class="btn-url">URL 복사</button>
                            </li>
                        </ul>
                    </div>
                    <!--// app -->
                </div>
                <div @click="click_sns_layer('close')" id="mask" style="overflow:hidden; display:block; position:fixed; top:0; left:0; z-index:10; width:100%; height:100%; background:rgba(0, 0, 0, 0.5);"></div>
            </div>
        </div>
    `
    , created() {
        let query_param = new URLSearchParams(window.location.search);
        this.event_code =  query_param.get("eventid");

        this.isUserLoginOK = isUserLoginOK;
    }
    , mounted(){
    }
    , computed : {
    }
    , data(){
        return {
            isUserLoginOK : false
            , event_code : ""
            , total_point : 0
            , show_section : 1
            , show_quiz : 1
            , quiz_answer : [2, 4, 1, 3, 3]
            , quiz_choice : []
            , success_flag : false
            , fail_flag : false
            , share_flag : false
        }
    }
    , methods : {
        go_section(idx){
            const _this = this;

            if(idx == 2){
                if(!this.isUserLoginOK){
                    calllogin();

                    return false;
                }else{
                    call_api("GET", "/event/common/subscription", {"event_code" : "114083"}, function(data){
                        console.log("select subscript is OK", data);
                        if(data){
                            alert("이미 참여하셨습니다.");
                            return false;
                        }else{
                            _this.show_section = idx;
                        }
                    });
                }
            }else if(idx == 3){
                this.go_subscript();
                this.show_section = idx;
            }else if(idx == 4){
                $('html, body').animate({scrollTop:0}, 'fast');

                if(this.total_point == 100){
                    give_coupon("prd,prd", "159775,160035", this.event_code); // 10% 쿠폰
                }

                this.show_section = idx;
            }


        }
        , click_quiz_answer(quiz_idx, index){
            if(this.quiz_choice.length == quiz_idx){
                this.quiz_choice.pop();
            }
            this.quiz_choice.push(index);
        }
        , go_quiz_submit(quiz_idx){
            if(!this.quiz_choice[quiz_idx-1]){
                alert("정답을 선택해주세요.");

                return false;
            }

            if(this.quiz_answer[quiz_idx-1] == this.quiz_choice[quiz_idx-1]){
                this.total_point += 20;
                this.success_flag = true;
            }else{
                this.fail_flag = true;
            }
        }
        , close_popup(){
            this.success_flag = false;
            this.fail_flag = false;

            if(this.show_quiz == 5){
                this.go_section(3);
            }else{
                this.show_quiz += 1;
            }
        }
        , click_sns_layer(type){
            if(type == "open"){
                if(this.share_flag){
                    alert("공유하기는 한번만 가능합니다.");
                    return false;
                }

                $("#lySns").show();
                $("#lySns .inner").removeClass("lySlideDown").addClass("lySlideUp");
                return false;
            }else{
                $("#lySns .inner").removeClass("lySlideUp").addClass("lySlideDown");
                $("#lySns").show(0).delay(300).hide(0);
            }

        }
        , go_share(sns_type){
            const title = "텐텐마인드";
            const imageurl = "https://webimage.10x10.co.kr/eventIMG/2021/114083/etcitemban20211021183747.JPEG";
            const appurl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=114083";

            if(sns_type == "kakao"){
                kakao_share_event_app(title, appurl, imageurl, '텐텐마인드에서 만점 받고 쿠폰받자!');
            }else if(sns_type == "insta"){
                insta_share_event_app(imageurl, this.event_code, title);
            }else if(sns_type == "twitter"){
                twitter_share_event_app(title, appurl, this.event_code);
            }else if(sns_type == "facebook"){
                facebook_share_event_app(appurl, this.event_code, title);
            }else if(sns_type == "clipboard"){
                copy_clipboard_app("https://m.10x10.co.kr/event/eventmain.asp?eventid=114419", this.event_code, title);
            }

            this.share_flag = true;
            this.click_sns_layer("close");

            this.show_quiz = 1;
            this.quiz_choice = [];
            this.total_point = 0;
            this.show_section = 2;
        }
        , go_subscript(){
            const _this = this;

            if(this.share_flag){
                let api_data = {
                    "event_code" : "114083"
                    , "event_option2" : this.total_point
                };

                call_api("POST", "/event/common/update-subscription", api_data, function(data){
                    console.log("update_subscript is OK", data);
                }, function(e){
                    const error = JSON.parse(e.responseText);
                    console.log("update_subscript is Fail", error);
                });
            }else{
                let api_data = {
                    "event_code" : "114083"
                    , "event_option1" : this.total_point
                    , check_option1: false
                    , "event_option3" : "try"
                    , check_option3 : false
                };

                call_api("POST", "/event/common/subscription", api_data, function(data){
                    console.log("insert_subscript is OK",data);
                }, function(e){
                    const error = JSON.parse(e.responseText);
                    console.log(error);
                    alert(error.message);

                    return false;
                });
            }
        }
    }
});