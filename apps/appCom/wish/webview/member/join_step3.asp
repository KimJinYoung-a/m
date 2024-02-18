<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : 회원가입
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<%
'## 로그인 여부 확인
if IsUserLoginOK then
	response.write "<script type='text/javascript'>"
	response.write "	alert('이미 회원가입이 되어있습니다.');"
	response.write "	location.href='/apps/appcom/wish/webview/login/login.asp'"
	response.write "</script>"
	dbget.close(): response.End
end if

'==============================================================================
'세션에 저장된 아이디 확인
dim txUserId, txUsermail, txUserCell, chkStat, sqlStr, vReSMS
txUserId = session("sUserid")
vReSMS = requestCheckVar(Request("a"),1)
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
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
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
			jsOpenModal("/apps/appcom/wish/webview/my10x10/userinfo/pop_sendModiemail.asp?id=<%=txUserId%>&mail=<%= txUsermail %>")
			return;
		}else if (rstStr == "2"){
			jsOpenModal("/apps/appcom/wish/webview/my10x10/userinfo/pop_sendModiemail.asp?id=<%=txUserId%>&mail=<%= txUsermail %>")
			return;
		}else if(rstStr == "3"){
			alert("회원 정보가 존재하지 않습니다.");
			return;
		}else if(rstStr == "4"){
			alert("감사합니다.\n이미 본인인증을 받으셨습니다.");
			return;
		}else{
			alert("발송 중 오류가 발생했습니다."+rstStr);
			return;
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
			jsOpenModal("/apps/appcom/wish/webview/my10x10/userinfo/pop_sendModiSMS.asp?id=<%=txUserId%>&phone=<%= txUserCell %>")
			return;
		}else if (rstStr == "2"){
			alert("회원 정보가 존재하지 않습니다.\n처음부터 다시 시작해주세요.");
			return;
		}else if(rstStr == "3"){
			alert("발송이 된지 채 2분이 지나지 않았습니다.\n2분이 지나도 오지 않으면 다시 한번 재발송을 눌러주세요.");
			return;
		}else if(rstStr == "4"){
			alert("감사합니다.\n이미 본인인증을 받으셨습니다.");
			return;
		}else{
			alert("발송 중 오류가 발생했습니다.");
		}
	}

	// 레이어 본인인증 휴대폰SMS 발송
	function resendSMS() {
		var rstStr = $.ajax({
			type: "POST",
			url: "/member/ajaxSendConfirmSMS.asp",
			data: "id=<%=txUserId%>",
			dataType: "text",
			async: false
		}).responseText;

		if (rstStr == "1"){
			alert("휴대폰으로 받으신 인증번호를 정확히 입력해주세요.");
			return;			
		}else if (rstStr == "2"){
			alert("회원 정보가 존재하지 않습니다.\n처음부터 다시 시작해주세요.");
			return;
		}else if(rstStr == "3"){
			alert("발송이 된지 채 2분이 지나지 않았습니다.\n2분이 지나도 오지 않으면 다시 한번 재발송을 눌러주세요.");
			return;
		}else if(rstStr == "4"){
			alert("감사합니다.\n이미 본인인증을 받으셨습니다.");
			return;
		}else{
			alert("발송 중 오류가 발생했습니다.");
			return;
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
			location.href = "join_welcome.asp";
		}else if (rstStr == "2"){
			alert("인증번호가 정확하지 않습니다.");
		}else{
			alert("처리중 오류가 발생했습니다.");
		}
	 }
	 
</script>

</head>
<body class="util">
    <!-- wrapper -->
    <div class="wrapper">
        <!-- #header -->
        <header id="header">
            <h1 class="page-title">회원가입</h1>
            <ul class="process clear">
                <li><span class="label">약관동의</span></li>
                <li><span class="label">정보입력</span></li>
                <li class="active"><span class="label">본인인증</span></li>
                <li><span class="label">가입완료</span></li>
            </ul>
        </header><!-- #header -->
        <!-- #content -->
        <div id="content">
            <div class="inner">
                <div class="main-title">
                    <h2 class="title"><span class="label">본인인증</span></h2>
                </div>
                <p><strong><%=txUserCell%></strong>로 휴대폰 인증번호를 발송하였습니다. <br>꼭 확인해 주세요. </p>
                <div class="diff"></div>
                <form name="cnfSMSForm" action="" onsubmit="return false;">
                    <div class="input-block">
                        <label for="authCode" class="input-label">인증번호</label>
                        <div class="input-controls">
                            <input type="text" id="crtfyNo" name="crtfyNo" pattern="[0-9]*" class="form" maxlength="6">
                            <button onclick="fnConfirmSMS();" class="btn type-c btn-checkcode side-btn">인증번호확인</button>
                        </div>
                    </div>
                    <em class="em red">* 인증번호 6자리를 입력해주세요.</em>
                    <div class="diff"></div>
                    <div class="well">인증번호가 도착하지 않았을 경우</div>
                    <div class="two-btns">
                        <div class="col">
                            <!--<a href="#resendAuthcode" class="btn type-a btn-show-modal">인증번호 재발송</a>-->
                            <a href="#resendAuthcode" onclick="sendSMS(); return false;" class="btn type-a">인증번호 재발송</a>
                        </div>
                        <div class="col">
                            <!--<a href="#authByEmail" class="btn type-a btn-show-modal">메일로 인증받기</a>-->
                            <a href="#authByEmail" onclick="sendEmail(); return false;" class="btn type-a">
                            메일로 인증받기</a>
                        </div>
                    </div>
                </form>
            </div>
        </div><!-- #content -->
        <!-- #footer -->
        <footer id="footer">
        </footer><!-- #footer -->
    </div><!-- wrapper -->
	<div id="modalCont" style="display:none;"></div>   
	
	<!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" --> 
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->