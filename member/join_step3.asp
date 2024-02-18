<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 회원가입
' History : 2014.09.03 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'해더 타이틀
strHeadTitleName = "회원가입"

'## 로그인 여부 확인
if IsUserLoginOK then
	Call Alert_Return("이미 회원가입이 되어있습니다.")
	dbget.close(): response.End
end if

'==============================================================================
'세션에 저장된 아이디 확인
dim txUserId, txUsermail, txUserCell, chkStat, sqlStr, vReSMS
txUserId = session("sUserid")
vReSMS = requestCheckVar(Request("re"),1)
if txUserId="" then
    call Alert_Return("잘못된 접근입니다.")
    dbget.close(): response.end
end if

sqlStr = "Select usermail, usercell, userStat From db_user.dbo.tbl_user_n Where userid='" & txUserid & "' "
rsget.Open sqlStr,dbget,1
if Not(rsget.EOF or rsget.BOF) then
	txUsermail = rsget("usermail")
	txUserCell = rsget("usercell")
	chkStat = rsget("userStat")
end if
rsget.close

if txUsermail="" then
    call Alert_Return("회원 정보가 존재하지 않습니다.")
    dbget.close(): response.end
end if
if isNull(chkStat) or chkStat="Y" then
    call Alert_Move("감사합니다.\n이미 본인인증을 받으셨습니다.\n\n메인으로 이동합니다.","/")
    dbget.close(): response.end
end if
%>

<!-- #include virtual="/lib/inc/head.asp" -->

<script type="text/javascript" SRC="/lib/js/confirm.js"></script>
<script type="text/javascript">

	// 본인인증 이메일 재발송
	function sendEmail() {
		var rstStr = $.ajax({
			type: "POST",
			url: "/member/ajaxSendConfirmEmail.asp",
			data: "id=<%=txUserId%>",
			dataType: "text",
			async: false
		}).responseText;

		if (rstStr == "1"){
			//location.href="<%=wwwUrl%>/member/join_step3_email.asp";
			alert('<%=txUsermail%>으로\n인증 이메일을 발송하였습니다.\n12시간 안에 꼭 확인해주세요.');
		}else if (rstStr == "2"){
			//location.href="<%=wwwUrl%>/member/join_step3_email.asp";
			alert('<%=txUsermail%>으로\n인증 이메일을 발송하였습니다.\n12시간 안에 꼭 확인해주세요.');
		}else if(rstStr == "3"){
			alert("회원 정보가 존재하지 않습니다.");
			history.back();
		}else if(rstStr == "4"){
			alert("감사합니다.\n이미 본인인증을 받으셨습니다.\n\n메인으로 이동합니다.");
			location.href="<%=wwwUrl%>/";
		}else{
			alert("발송 중 오류가 발생했습니다."+rstStr);
		}
	}

	// 본인인증 휴대폰SMS 발송
	function sendSMS() {
		var rstStr = $.ajax({
			type: "POST",
			url: "/member/ajaxSendConfirmSMS.asp",
			data: "id=<%=txUserId%>",
			dataType: "text",
			async: false
		}).responseText;

		if (rstStr == "1"){
			alert('<%=txUserCell%>으로\n인증번호를 발송하였습니다.\n정확히 입력해 주세요.');
			//location.href="<%=wwwUrl%>/member/join_step3_sms.asp";
		}else if (rstStr == "2"){
			alert("회원 정보가 존재하지 않습니다.\n처음부터 다시 시작해주세요.");
			location.href="<%=wwwUrl%>/member/join.asp";
		}else if(rstStr == "3"){
			alert("발송이 된지 채 2분이 지나지 않았습니다.\n2분이 지나도 오지 않으면 다시 한번 재발송을 눌러주세요.");
		}else if(rstStr == "4"){
			alert("감사합니다.\n이미 본인인증을 받으셨습니다.\n\n메인으로 이동합니다.");
			location.href="<%=wwwUrl%>/";
		}else{
			alert("발송 중 오류가 발생했습니다.");
		}
	}

	 //인증 처리
	 function fnConfirmSMS() {
	 	var frm = document.cnfSMSForm;
	 	if(frm.crtfyNo.value.length<6) {
	 		alert("휴대폰으로 받으신 인증번호를 정확히 입력해주세요.");
	 		frm.crtfyNo.focus();
	 		return;
	 	}

		var rstStr = $.ajax({
			type: "POST",
			url: "/member/ajaxCheckConfirmSMS.asp",
			data: "id=<%=txUserId%>&chkFlag=N&key="+frm.crtfyNo.value,
			dataType: "text",
			async: false
		}).responseText;

		if (rstStr == "1"){
			alert("인증이 완료되었습니다.");
			location.href = "/member/join_welcome.asp";
		}else if (rstStr == "2"){
			alert("인증번호가 정확하지 않습니다.");
		}else{
			alert("처리중 오류가 발생했습니다.");
		}
	 }
<%
	'// 재전송 여부에 따라 인증 SMS 재발송
	if vReSMS="1" then
		Response.Write "sendSMS();"
	end if
%>
</script>
<title>10x10: 회원가입</title>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<!-- 회원가입 - 3.본인인증 -->
				<div class="join inner5">
					<form name="cnfSMSForm" action="" onsubmit="return false;">
					<div class="joinStep">
						<ol>
							<li class="on"><span>1</span>약관동의</li>
							<li class="on"><span>2</span>정보입력</li>
							<li class="on"><span>3</span>본인인증</li>
							<li><span>4</span>가입완료</li>
						</ol>
					</div>
					<div class="joinCert box1">
						<div class="sendNum">
							<p><strong>인증번호를 발송하였습니다. <span class="cRd1">확인해주세요!</span></strong></p>
							<p class="tMar10">(인증번호 6자리를 입력해주세요)</p> 
						</div>
						<p class="tMar20"><input type="tel" id="crtfyNo" name="crtfyNo" pattern="[0-9]*" maxlength="6" class="ct w50p" title="인증번호 입력" /> 
						<span class="button btB2 btRed cWh1"><input type="submit" onclick="fnConfirmSMS();" value="확인" /></p>
						<div class="joinHelp">
							<a href="" onclick="sendSMS(); return false;">인증번호 재발송</a>
							<a href="" onclick="sendEmail(); return false;">메일 인증받기</a>
							<a href="/member/join.asp">회원가입</a>
						</div>
						<p class="tMar10 fs11 lh12">문자가 스팸으로 분류되어 인증번호가 전달이 안될 경우<br />메일로 인증이 가능합니다.</p>
					</div>
					</form>
				</div>
				<!--// 회원가입 - 3.본인인증 -->
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->