<script>
function fnCheckMoreInfo(){
    var frm = document.myinfoForm;
    if(frm.txName.value==""){
        alert("이름을 확인해주세요.");
        return false;
    }
    if(frm.usermail.value==""){
        alert("이메일을 확인해주세요.");
        return false;
    }
    if(frm.txBirthday.value==""){
        alert("생년월일을 확인해주세요.");
        return false;
    }
    if(frm.txBirthday.value.length<10){
        alert("생년월일을 확인해주세요.");
        return false;
    }
    if(frm.txSex.value==""){
        alert("성별을 확인해주세요.");
        return false;
    }
    $('#moreinfobtn').html('추가입력한 정보 수정하기');
    fnCloseModalMember();
}
function fnGenderCheck(obj){
    document.myinfoForm.txSex.value=obj;
}

function inputLengthCheck(eventInput){
	var inputText = $(eventInput).val();
	var inputMaxLength = $(eventInput).prop("maxlength");
	var j = 0;
	var count = 0;
	var nameJ = /^[A-Za-z가-힣]{2,15}$/;
	if(inputText.search(nameJ)){
		$("#nameCheckResult").show();
        $("#checkNameOK").hide();
        //$("#uname").hide();
		return false;
	}
    for(var i = 0;i < inputText.length;i++) { 
		val = escape(inputText.charAt(i)).length; 
		if(val == 6){
			j++;
		}
		j++;
		if(j <= inputMaxLength){
			count++;
		}
	}
    //$("#uname").hide();
    
	if(j > inputMaxLength){
		$("#nameCheckResult").show();
        $("#checkNameOK").hide();
		$(eventInput).val(inputText.substr(0, count));
	}else if(j==0){
        $("#nameCheckResult").show();
        $("#checkNameOK").hide();
        //$("#uname").show();
    }else{
		$("#nameCheckResult").hide();
        $("#checkNameOK").show();
	}
}

// 모달 열기
function fnOpenModalMember() {
	$('.modalV20').addClass('show');
	$('.modalV20 .modal_cont').animate({scrollTop : 0}, 0);
    <% if isApp then %>
    fnSetHeaderDim(true);
    <% end if %>
	toggleScrolling();
};
// 모달 닫기
function fnCloseModalMember(){
    var frm = document.myinfoForm;
    if(frm.txName.value=="" && frm.usermail.value=="" && frm.txBirthday.value==""){
        $(".modalV20").removeClass('show');
        <% if isApp then %>
        fnSetHeaderDim(false);
        <% end if %>
        toggleScrolling();
    }
    else{
        if(frm.txName.value=="" || frm.usermail.value=="" || frm.txBirthday.value==""){
            if (confirm("아직 정보가 저장되지 않았어요!\n창을 닫으시겠어요?")){
                frm.txName.value="";
                frm.usermail.value="";
                frm.txBirthday.value="";
                frm.txSex.value="";
                
                $("#checkMailOK").hide();
                $("#checkNameOK").hide();
                $("#nameCheckResult").hide();
                $("#checkMsgEmail").hide();
                //$("#uname").show();
                //$("#umail").show();
                $(".modalV20").removeClass('show');
                $('#moreinfobtn').html('3개만 더 입력하고 생일쿠폰 받기');
                <% if isApp then %>
                fnSetHeaderDim(false);
                <% end if %>
                toggleScrolling();
            }
        }else{
            $(".modalV20").removeClass('show');
            <% if isApp then %>
            fnSetHeaderDim(false);
            <% end if %>
            toggleScrolling();
        }
    }
}
// 모달 호출될 때, 부모창 스크롤 방지
function toggleScrolling() {
	if ($('.modalV20').hasClass('show')) {
		currentY = $(window).scrollTop();
		//$('html').addClass('not_scroll');
	} else {
		//$('html').removeClass('not_scroll');
		$('html').animate({scrollTop : currentY}, 0);
	}
}
$(function(){
    //성별 선택 버튼
    $('.btnSex').on('click',function(){
        $(this).addClass('on').siblings().removeClass('on');
    });
});

function chkMemBirth(obj){
    obj.value = obj.value.replace(/-/gi, "");
    if(obj.value.length>0){
        $("#birthtxt").hide();
    }else{
        $("#birthtxt").show();
    }
	if(obj.value.length>8){
		obj.value = obj.value.slice(0,8);
	}
    if(obj.value.length==8){
        $("#checkMsgBirth").hide();
    }else{
        $("#checkMsgBirth").show();
    }
}
</script>

	<div class="modalV20 modal_type4 modal_SimpleMember">
		<div class="modal_overlay" onclick="fnCloseModalMember();"></div>
		<div class="modal_wrap">
			<div class="modal_header">
				<h2>모달</h2>
				<button class="btn_close" onclick="fnCloseModalMember();"><i class="i_close"></i>모달닫기</button>
			</div>
			<div class="modal_body">
				<!-- 퍼블 영역 -->
				<!-- scroll auto 영역 -->
				<div class="modal_cont">
					<h3>조금만 더<br/>
                        알려주세요!</h3>
                    <p class="titSub">3개만 더 입력하면 텐텐메일진과 생일쿠폰을 드려요!</p>
                    <div class="login-form">
                            <input type="hidden" name="txSex" value="F">
                            <fieldset>
                            <legend class="hidden">로그인 폼</legend>
                                <div class="form-group first">
                                    <input type="text" name="txName" id="name" maxlength="30" placeholder="이름" value="<%= snsusername %>" onblur="inputLengthCheck(this);" onKeyDown="inputLengthCheck(this);" onKeyUp="inputLengthCheck(this);">
                                    <!-- <label for="name" id="uname">이름</label> -->
                                    <div class="hint" id="nameCheckResult" style="display:none">한글 15자, 영문 30자 이내로 입력해주세요.</div>
                                    <span class="arrow" id="checkNameOK" style="display:none"><img src="http://fiximage.10x10.co.kr/m/2021/member/icon_member_check.png" alt="check"></span>
                                </div>
                                <div class="form-group">
                                    <input type="email" name="usermail" id="email" value="<%= snsusermail %>"  maxlength="80" placeholder="이메일" onKeyDown="keyCodeCheckEmail(event);" onKeyUp="DuplicateEmailCheck();" onClick="DuplicateEmailCheck();">
                                    <!-- <label for="email" id="umail">이메일</label> -->
                                    <div class="hint" id="checkMsgEmail" style="display:none"></div>
                                    <span class="arrow" id="checkMailOK" style="display:none"><img src="http://fiximage.10x10.co.kr/m/2021/member/icon_member_check.png" alt="check"></span>
                                </div>
                                <div class="form-group">
                                    <input type="text" id="birth" name="txBirthday" placeholder="생년월일" onclick="chkMemBirth(this);" onKeyDown="chkMemBirth(this);" onKeyUp="chkMemBirth(this);" onblur="date_format()">
                                    <!-- <label for="birth" id="birthtxt">생년월일</label> -->
                                    <div class="hint" id="checkMsgBirth" style="display:none">8자리(예: <%=replace(left(now(),10),"-","")%>) 형식으로 입력해주세요</div>
                                    <button type="button" class="btnSex man on" onclick="fnGenderCheck('F');">여자</button>
                                    <button type="button" class="btnSex " onclick="fnGenderCheck('M');">남자</button>
                                </div>
                                <div class="form-group">
                                    <ul class="list_boll">
                                        <li>개인정보 수집 및 이용에 동의합니다(선택)<br/>수집 목적 : 혜택 또는 해당 정보를 활용한 기획전/이벤트 안내<br/>보유 및 이용기간 : 회원가입 철회 시 까지</li>
                                        <li>정보 수집 및 이용에 동의하지 않으실 수 있으며<br />동의를 거부하실 경우 혜택/기획전/이벤트 안내를 받으실 수 없지만 회원가입에는 지장이 없음을 알려드립니다.</li>
                                    </ul>
                                </div>

                            </fieldset>


                    </div>
				</div>
				<!--// scroll auto 영역 -->
				<!-- 고정 영역 -->
				<div class="btn_block">
					<button class="btn_ten" onclick="fnCheckMoreInfo();">동의 후 등록하기</button>
				</div>
				<!--// 고정 영역 -->
				<!--// 퍼블 영역 -->
			</div>
		</div>
	</div>
<script>
function date_format(){
	var birth = $("#birth").val();
	var birth_date = birth.replace(/(^02.{0}|^01.{1}|[0-9]{4})([0-9]+)([0-9]{2})/,"$1-$2-$3");
	$("#birth").val(birth_date);
}
</script>