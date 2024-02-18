const app = new Vue({
    el: '#app'
    , template : `
        <div class="mEvt113992 box-tape">
            <h2>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_main.jpg" alt="텐바이텐 박스테이프 카피 공모전" />
                <div class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113992/m/txt_main01.png" alt="제 6회 텐바이텐 박스테이프 카피 공모전" /></div>
                <div class="txt"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113992/m/txt_main02.png" alt="원하는 카피를 선택해주세요!" /></div>
            </h2>
            <div class="section-01">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_sub01.jpg" alt="" />
                <div class="txt01 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113992/m/txt_sub01.png" alt="텐바이텐 택백 박스에 쓰여 있으면 재미있을 것 같은 카피를 선택해 주세요."></div>
                <div class="txt02 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113992/m/txt_sub02.png" alt="투표기간 9월 10 - 20일"></div>
            </div>
            <img src="//webimage.10x10.co.kr/fixevent/event/2021/113992/m/tit_box.jpg" alt="카피 후보작">
            <!-- 투표 리스트 영역 -->
            <div class="section-02">
                <!-- 이미지 변경 예정! 이미지명 _on / _off 로 클릭시 변경되게 설정했습니다.  -->
                <ul>
                    <li><button @click="click_candidate(1, candidates.candidate1)" :class="[{on : candidates.candidate1 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy01_' + (candidates.candidate1 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(2, candidates.candidate2)" :class="[{on : candidates.candidate2 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy02_' + (candidates.candidate2 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(3, candidates.candidate3)" :class="[{on : candidates.candidate3 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy03_' + (candidates.candidate3 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(4, candidates.candidate4)" :class="[{on : candidates.candidate4 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy04_' + (candidates.candidate4 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(5, candidates.candidate5)" :class="[{on : candidates.candidate5 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy05_' + (candidates.candidate5 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(6, candidates.candidate6)" :class="[{on : candidates.candidate6 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy06_' + (candidates.candidate6 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(7, candidates.candidate7)" :class="[{on : candidates.candidate7 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy07_' + (candidates.candidate7 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(8, candidates.candidate8)" :class="[{on : candidates.candidate8 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy08_' + (candidates.candidate8 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(9, candidates.candidate9)" :class="[{on : candidates.candidate9 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy09_' + (candidates.candidate9 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(10, candidates.candidate10)" :class="[{on : candidates.candidate10 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy10_' + (candidates.candidate10 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(11, candidates.candidate11)" :class="[{on : candidates.candidate11 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy11_' + (candidates.candidate11 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(12, candidates.candidate12)" :class="[{on : candidates.candidate12 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy12_' + (candidates.candidate12 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(13, candidates.candidate13)" :class="[{on : candidates.candidate13 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy13_' + (candidates.candidate13 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(14, candidates.candidate14)" :class="[{on : candidates.candidate14 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy14_' + (candidates.candidate14 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(15, candidates.candidate15)" :class="[{on : candidates.candidate15 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy15_' + (candidates.candidate15 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(16, candidates.candidate16)" :class="[{on : candidates.candidate16 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy16_' + (candidates.candidate16 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(17, candidates.candidate17)" :class="[{on : candidates.candidate17 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy17_' + (candidates.candidate17 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(18, candidates.candidate18)" :class="[{on : candidates.candidate18 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy18_' + (candidates.candidate18 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(19, candidates.candidate19)" :class="[{on : candidates.candidate19 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy19_' + (candidates.candidate19 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(20, candidates.candidate20)" :class="[{on : candidates.candidate20 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy20_' + (candidates.candidate20 == true ? 'on' : 'off') + '.png'" alt="후보작 예시"></button></li>
                    <li><button @click="click_candidate(21, candidates.candidate21)" :class="[{on : candidates.candidate21 ? 'on' : ''}]" type="button"><img :src="'//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_copy21_' + (candidates.candidate21 == true ? 'on' : 'off') + '.png?v=2'" alt="후보작 예시"></button></li>
                </ul>
            </div>
            <!-- // -->
            <div class="section-03">   
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113992/m/btn_apply.jpg" alt="투표완료">
                <button @click="go_save()" type="button" class="btn-apply"></button>
            </div>
            <img src="//webimage.10x10.co.kr/fixevent/event/2021/113992/m/img_noti.jpg" alt="유의사항">
            <div class="section-04">
                <div class="tit">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/img_sub05.jpg" alt="박스테이프 카피" />
                    <div class="icon"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/icon_arrow_right01.png" alt=""></div>
                </div>
                <div class="copy-list">
                    <div class="num-th"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/img_01th.png" alt="제 1회"></div>
                    <div class="list list01">
                        <div class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve_tit01.png" alt=""></div>
                        <div class="txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve_tit02.png" alt=""></div>
                        <div class="txt03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve_tit03.png" alt=""></div>
                        <div class="txt04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve_tit04.png" alt=""></div>
                        <div class="txt05"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve_tit05.png" alt=""></div>
                    </div>
                </div>
                <div class="copy-list copy-pd">
                    <div class="num-th"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/img_02th.png" alt="제 2회"></div>
                    <div class="list list02">
                        <div class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve02_tit01.png" alt=""></div>
                        <div class="txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve02_tit02.png" alt=""></div>
                        <div class="txt03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve02_tit03.png" alt=""></div>
                        <div class="txt04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve02_tit04.png" alt=""></div>
                        <div class="txt05"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve02_tit05.png" alt=""></div>
                    </div>
                </div>
                <div class="copy-list copy-pd">
                    <div class="num-th"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/img_03th.png" alt="제 3회"></div>
                    <div class="list list03">
                        <div class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve03_tit01.png" alt=""></div>
                        <div class="txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve03_tit02.png" alt=""></div>
                        <div class="txt03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve03_tit03.png" alt=""></div>
                        <div class="txt04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve03_tit04.png" alt=""></div>
                        <div class="txt05"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve03_tit05.png" alt=""></div>
                    </div>
                </div>
                <div class="copy-list copy-pd">
                    <div class="num-th"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/img_04th.png" alt="제 4회"></div>
                    <div class="list list04">
                        <div class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve04_tit01.png" alt=""></div>
                        <div class="txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve04_tit02.png" alt=""></div>
                        <div class="txt03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve04_tit03.png" alt=""></div>
                        <div class="txt04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve04_tit04.png" alt=""></div>
                        <div class="txt05"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve04_tit05.png" alt=""></div>
                    </div>
                </div>
                <div class="copy-list copy-pd">
                    <div class="num-th"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/img_05th.png" alt="제 5회"></div>
                    <div class="list list05">
                        <div class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve05_tit01.png" alt=""></div>
                        <div class="txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve05_tit02.png" alt=""></div>
                        <div class="txt03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve05_tit03.png" alt=""></div>
                        <div class="txt04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve05_tit04.png" alt=""></div>
                        <div class="txt05"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113476/m/txt_eve05_tit05.png" alt=""></div>
                    </div>
                </div>
            </div>            
        </div>
    `
    , data : function(){
        return {
            candidates : {
                candidate1 : false
                , candidate2 : false
                , candidate3 : false
                , candidate4 : false
                , candidate5 : false
                , candidate6 : false
                , candidate7 : false
                , candidate8 : false
                , candidate9 : false
                , candidate10 : false
                , candidate11 : false
                , candidate12 : false
                , candidate13 : false
                , candidate14 : false
                , candidate15 : false
                , candidate16 : false
                , candidate17 : false
                , candidate18 : false
                , candidate19 : false
                , candidate20 : false
                , candidate21 : false
            }
            , selected_candi_count : 0

            , ing_save : false
        }
    }
    , mounted(){
        $('h2 .tit, h2 .txt').addClass('on');
        /* 글자,이미지 스르륵 모션 */
        $(window).scroll(function(){
            $('.animate').each(function(){
                var y = $(window).scrollTop() + $(window).height() * 1;
                var imgTop = $(this).offset().top;
                if(y > imgTop) {
                    $(this).addClass('on');
                }
            });
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
    , methods : {
        click_candidate : function(candi_index, go_unactive){
            if(this.selected_candi_count >= 3 && !go_unactive){
                alert("최대 3개까지 선택하실 수 있습니다.");
                return false;
            }

            if(go_unactive){
                this.selected_candi_count -= 1;
            }else{
                this.selected_candi_count += 1;
            }

            if(candi_index == 1){
                this.candidates.candidate1 = !this.candidates.candidate1
            }else if(candi_index == 2){
                this.candidates.candidate2 = !this.candidates.candidate2
            }else if(candi_index == 3){
                this.candidates.candidate3 = !this.candidates.candidate3
            }else if(candi_index == 4){
                this.candidates.candidate4 = !this.candidates.candidate4
            }else if(candi_index == 5){
                this.candidates.candidate5 = !this.candidates.candidate5
            }else if(candi_index == 6){
                this.candidates.candidate6 = !this.candidates.candidate6
            }else if(candi_index == 7){
                this.candidates.candidate7 = !this.candidates.candidate7
            }else if(candi_index == 8){
                this.candidates.candidate8 = !this.candidates.candidate8
            }else if(candi_index == 9){
                this.candidates.candidate9 = !this.candidates.candidate9
            }else if(candi_index == 10){
                this.candidates.candidate10 = !this.candidates.candidate10
            }else if(candi_index == 11){
                this.candidates.candidate11 = !this.candidates.candidate11
            }else if(candi_index == 12){
                this.candidates.candidate12 = !this.candidates.candidate12
            }else if(candi_index == 13){
                this.candidates.candidate13 = !this.candidates.candidate13
            }else if(candi_index == 14){
                this.candidates.candidate14 = !this.candidates.candidate14
            }else if(candi_index == 15){
                this.candidates.candidate15 = !this.candidates.candidate15
            }else if(candi_index == 16){
                this.candidates.candidate16 = !this.candidates.candidate16
            }else if(candi_index == 17){
                this.candidates.candidate17 = !this.candidates.candidate17
            }else if(candi_index == 18){
                this.candidates.candidate18 = !this.candidates.candidate18
            }else if(candi_index == 19){
                this.candidates.candidate19 = !this.candidates.candidate19
            }else if(candi_index == 20){
                this.candidates.candidate20 = !this.candidates.candidate20
            }else if(candi_index == 21){
                this.candidates.candidate21 = !this.candidates.candidate21
            }
        }
        , go_save(){
            const _this = this;

            if(this.selected_candi_count != 3){
                alert("3개를 선택해주세요.");
                return false;
            }

            if(!isLoginOk) {
                calllogin();
            }else{
                if (this.ing_save) {
                    return false;
                }

                _this.ing_save = true;

                let option_list = [];
                if(this.candidates.candidate1){
                    option_list.push(1);
                }
                if(this.candidates.candidate2){
                    option_list.push(2);
                }
                if(this.candidates.candidate3){
                    option_list.push(3);
                }
                if(this.candidates.candidate4){
                    option_list.push(4);
                }
                if(this.candidates.candidate5){
                    option_list.push(5);
                }
                if(this.candidates.candidate6){
                    option_list.push(6);
                }
                if(this.candidates.candidate7){
                    option_list.push(7);
                }
                if(this.candidates.candidate8){
                    option_list.push(8);
                }
                if(this.candidates.candidate9){
                    option_list.push(9);
                }
                if(this.candidates.candidate10){
                    option_list.push(10);
                }
                if(this.candidates.candidate11){
                    option_list.push(11);
                }
                if(this.candidates.candidate12){
                    option_list.push(12);
                }
                if(this.candidates.candidate13){
                    option_list.push(13);
                }
                if(this.candidates.candidate14){
                    option_list.push(14);
                }
                if(this.candidates.candidate15){
                    option_list.push(15);
                }
                if(this.candidates.candidate16){
                    option_list.push(16);
                }
                if(this.candidates.candidate17){
                    option_list.push(17);
                }
                if(this.candidates.candidate18){
                    option_list.push(18);
                }
                if(this.candidates.candidate19){
                    option_list.push(19);
                }
                if(this.candidates.candidate20){
                    option_list.push(20);
                }
                if(this.candidates.candidate21){
                    option_list.push(21);
                }

                let api_data = {
                    "event_code" : "113992"
                    , "event_option1" : option_list[0]
                    , check_option1: false
                    , "event_option2" : option_list[1]
                    , check_option2 : false
                    , "event_option3" : option_list[2]
                    , check_option3 : false
                };
                this.call_api("POST", "/event/common/subscription", api_data
                    , function (data){
                        if( data.result ) {
                            alert("투표가 완료됐습니다.");

                            fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode', "113992");
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
                                    alert("이미 투표를 하셨습니다.");
                                    break;
                                default: alert(err_obj.message); return false;
                            }
                        }catch(error) {
                            console.log(error);
                            alert('데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망. (에러코드 : 002)');
                        }
                    }, () => {
                        _this.ing_save = false;
                    }
                );
            }
        }
        , call_api(method, uri, data, success, error, complete) {
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
    }
});