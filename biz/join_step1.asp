<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 회원가입
' History : 2017.05.29 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'해더 타이틀
strHeadTitleName = "회원가입"
dim smartAlarm, email_10x10, email_way2way, smsok, smsok_fingers

if request("sec30") <> "" then
else
	response.redirect "/biz/join.asp"
	dbget.close(): response.End
end if
'## 로그인 여부 확인
if IsUserLoginOK then
'	Call Alert_Return("이미 회원가입이 되어있습니다.")
'	dbget.close(): response.End
end if

'외부 URL 체크
dim backurl
backurl = request.ServerVariables("HTTP_REFERER")

If application("Svr_Info")<>"Dev" Then
	if InStr(LCase(backurl),"10x10.co.kr") < 1 then
		if (Len(backurl)>0) then
			response.redirect backurl
			response.end
		else
	'        response.write "<script>alert('유효한 접근이 아닙니다.'); history.back();</script>"
	'        response.end
		end if
	end if
end if

'// 유입경로
Dim ihideventid
	ihideventid = session("hideventid")

if ihideventid="" and request.cookies("rdsite")<>"" then
	ihideventid = request.cookies("rdsite")
else
	ihideventid = "mobile"
end if

smartAlarm 	= requestCheckVar(request("smartAlarm"),3)
if smartAlarm<>"" then
	email_10x10 = "N"
	email_way2way = "N"
	smsok = "N"
	smsok_fingers = "N"
else
	email_10x10 = "Y"
	email_way2way = "Y"
	smsok = "Y"
	smsok_fingers = "Y"
end if

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/common.css?v=2.03" />
<link rel="stylesheet" type="text/css" href="/lib/css/content.css?v=4.90" />
<link rel="stylesheet" type="text/css" href="/lib/css/contentV20.css?v=1.85" />
<link rel="stylesheet" type="text/css" href="/lib/css/commonV20.css?v=1.43" />
<script style="text/css">
	
$(function(){
    var topHeight = $('#header').outerHeight();
    var simpleTit = $('.simpleTit');
    $(simpleTit).css('top',topHeight);
});
chkSocNo = false;

function fnNextJoin(){
	var frm = document.myinfoForm;
//alert(chkSocNo);
	if(!chkSocNo){
		alert('정확한 사업자 등록번호를 입력해주세요.');
		frm.socno.focus();
		return;
	}

	// 사업자 번호 확인
	if( frm.socno.value.trim() === '' ) {
		alert('정확한 사업자 등록번호를 입력해주세요.');
		frm.socno.focus();
		return;
	}

	if( frm.socname.value.trim() === '' ) {
		alert('사업자명을 입력해주세요.');
		frm.socname.focus();
		return;
	}

	frm.action = '/biz/join_step2.asp';
	frm.submit();
}

// 사업자번호 check
function checkSocnum(number){

	var numberMap = number.replace(/-/gi, '').split('').map(function (d){
		return parseInt(d, 10);
	});
	
	if(numberMap.length == 10){
		var keyArr = [1, 3, 7, 1, 3, 7, 1, 3, 5];
		var chk = 0;
		
		for( let i=0 ; i<keyArr.length ; i++ ) {
			chk += keyArr[i] * numberMap[i];
		}
		
		chk += parseInt((keyArr[8] * numberMap[8])/ 10, 10);

		//return Math.floor(numberMap[9]) === ( (10 - (chk % 10) ) % 10);

		var rstStr = $.ajax({
			type: "POST",
			url: "/biz/ajax/ajaxCheckSocNo.asp",
			data: "socno="+number,
			dataType: "text",
			async: false
		}).responseText;
		if (rstStr == "ERR"){
			$("#checkSocNOOK").hide();
			$("#checkMsgSocNO").show();
			chkSocNo=false;
		}else if (rstStr == "fail"){
			$("#checkSocNOOK").hide();
			$("#checkMsgSocNO").show();
			chkSocNo=false;
		}else{
			$("#checkMsgSocNO").hide();
			$("#checkSocNOOK").show();
			chkSocNo=true;
		}
	}
	else{
		$("#checkSocNOOK").hide();
		//$("#checkMsgSocNO").show();
		//$("#sonum").hide();
		chkSocNo=false;
	}
	return false;
}

// 사업자번호 check
function checkSocnum2(number){

	var numberMap = number.replace(/-/gi, '').split('').map(function (d){
		return parseInt(d, 10);
	});
	
	if(numberMap.length == 10){
		var keyArr = [1, 3, 7, 1, 3, 7, 1, 3, 5];
		var chk = 0;
		
		for( let i=0 ; i<keyArr.length ; i++ ) {
			chk += keyArr[i] * numberMap[i];
		}
		
		chk += parseInt((keyArr[8] * numberMap[8])/ 10, 10);
		$("#checkSocNOOK").show();
		$("#checkMsgSocNO").hide();
		//return Math.floor(numberMap[9]) === ( (10 - (chk % 10) ) % 10);
		var rstStr = $.ajax({
			type: "POST",
			url: "/biz/ajax/ajaxCheckSocNo.asp",
			data: "socno="+number,
			dataType: "text",
			async: false
		}).responseText;
		if (rstStr == "ERR"){
			$("#checkSocNOOK").hide();
			$("#checkMsgSocNO").show();
			chkSocNo=false;
		}else if (rstStr == "fail"){
			$("#checkSocNOOK").hide();
			$("#checkMsgSocNO").show();
			chkSocNo=false;
		}else{
			$("#checkMsgSocNO").hide();
			$("#checkSocNOOK").show();
			chkSocNo=true;
		}
	}
	else{
		$("#checkSocNOOK").hide();
		$("#checkMsgSocNO").show();
		//$("#sonum").hide();
		chkSocNo=false;
	}
	return false;
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="section simpleJoinForm">
                    <div class="simpleTit">
                        <h2>텐바이텐 BIZ<br/>회원가입</h2>
                        <div class="step">
                            <span class="boll"></span>
                            <span class="bar"></span>
                            <span class="number">2</span>
                            <span class="bar"></span>
                            <span class="boll"></span>
                        </div>
                    </div>
                    <div class="login-form">
                        <div class="txt-noti">
                            <div class="icon"><img src="http://fiximage.10x10.co.kr/m/2021/member/icon_noti.png" alt="icon"></div>
                            <p>입력된 사업자 정보는 가입시 정보확인 용으로,<br/>
                                해당 사업자에게 전달되거나 별도로 조회되지 않습니다 :)</p>
                        </div>
						<form name="myinfoForm" method="post" onsubmit="return false;">
						<input type="hidden" name="hideventid" value="<%= ihideventid %>">
						<input type="hidden" name="usermail" value="">
						<input type="hidden" name="email_10x10" value="<%= email_10x10 %>">
						<input type="hidden" name="smsok" value="<%= smsok %>">
						<input type="hidden" name="email_way2way" value="<%= email_way2way %>">
						<input type="hidden" name="smsok_fingers" value="<%= smsok_fingers %>">
                            <fieldset>
                            <legend class="hidden">회원가입 폼</legend>
                                <div class="form-group first">
                                    <input type="text" name="socno" id="socnoInput" maxlength="10" placeholder="사업자 등록번호" onKeyDown="checkSocnum(this.value);" onKeyUp="checkSocnum(this.value);" onClick="checkSocnum(this.value);" onBlur="checkSocnum2(this.value);">
                                    <!-- <label for="socnoInput" id="sonum">사업자 등록번호</label> -->
                                    <div class="hint" id="checkMsgSocNO" style="display:none">사업자 번호를 올바르게 입력해주세요.</div>
                                    <span class="arrow" id="checkSocNOOK" style="display:none"><img src="http://fiximage.10x10.co.kr/m/2021/member/icon_member_check.png" alt="check"></span>
                                </div>
                                <div class="form-group">
                                    <input type="text" name="socname" id="socnameinput" maxlength="32" placeholder="사업자명">
                                    <!-- <label for="socnameinput" id="soname">사업자명</label> -->
                                    <!-- for dev msg : 입력 완료 시 노출 -->
                                    <span class="arrow" id="checkSocNameOK" style="display:none"><img src="http://fiximage.10x10.co.kr/m/2021/member/icon_member_check.png" alt="check"></span>
                                </div>
                            </fieldset>
						</form>
                    </div>
                    <div class="btnGroup">
                        <!-- for dev msg : 버튼 문구 마지막단계에서 다음단계 > 회원가입 신청하기로 변경 -->
                        <input type="submit" class="btnV16a btnRed2V16a btnLarge btnBlock" onclick="fnNextJoin();" value="다음단계">
                    </div>
				
				</div>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
<script>
	const socnoInput = document.getElementById('socnoInput');
	socnoInput.addEventListener('focus', function(e) {
		e.target.value = e.target.value.replace(/-/gi, '');
	});
	socnoInput.addEventListener('blur', function(e) {
		e.target.value = socnoFormatter(e.target.value);
	});

	// 사업자 번호 format
	function socnoFormatter(num) {
		var formatNum = num;
		try{
			formatNum = num.replace(/(\d{3})(\d{2})(\d{5})/, '$1-$2-$3');
		} catch(e) {
			formatNum = num;
		}
		return formatNum;
	}
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->