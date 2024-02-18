// 히치하이커 우편번호
Vue.component('Hitchhiker-Zipcode',{
    template : `
        <div class="modal_body">
            <div class="modal_cont zipcode">
                <div id="zipcode_area" class="zipcode_area"></div>
            </div>
        </div>
    `,
    methods : {
        search_zip(screen_id) {
            const _this = this;

            // 우편번호 찾기 찾기 화면을 넣을 element
            const screen = document.getElementById(screen_id);
            // 우편번호
            let zip_code = '';
            let address_main = '';

            daum.postcode.load(function(){
                new daum.Postcode({
                    oncomplete: function(data) {
                        let addr = ''; // 주소 변수
                        let extraAddr = ''; // 참고항목 변수

                        //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                        if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                            addr = data.roadAddress;
                        } else { // 사용자가 지번 주소를 선택했을 경우(J)
                            addr = data.jibunAddress;
                        }

                        // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                        if(data.userSelectedType === 'R'){
                            // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                            // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                            if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                                extraAddr += data.bname;
                            }
                            // 건물명이 있고, 공동주택일 경우 추가한다.
                            if(data.buildingName !== '' && data.apartment === 'Y'){
                                extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                            }
                            // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                            if(extraAddr !== ''){
                                extraAddr = ' (' + extraAddr + ')';
                            }
                            // 조합된 참고항목을 해당 필드에 넣는다.
                            $("#extraAddr").val(extraAddr);
                        } else {
                            $("#extraAddr").val("");
                        }

                        // 우편번호와 주소 정보를 넣는다.
                        zip_code = data.zonecode;
                        address_main = (addr + extraAddr).replace("・","/");

                        // iframe을 넣은 element를 안보이게 한다.
                        // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
                        screen.style.display = 'none';

                        $(window).scrollTop($(screen).offset().top-150);
                    },
                    // 사용자가 주소를 클릭했을때
                    onclose : function(state) {
                        if(state === 'COMPLETE_CLOSE'){
                            _this.$emit('choose_address', {
                                'zipcode' : zip_code,
                                'basic' : address_main,
                                'detail' : ''
                            });
                        }
                    },
                    onresize : function(size) {
                        screen.style.height = size.height+'px';
                        $(window).scrollTop($(screen).offset().top-150);
                    },
                    width : '100%',
                    height : '100%',
                    hideMapBtn : true,
                    hideEngBtn : true,
                    shorthand : false,
                    maxSuggestItems : 5
                }).embed(screen);
            });
            // iframe을 넣은 element를 보이게 한다.
            screen.style.display = 'block';
        }
    }
});