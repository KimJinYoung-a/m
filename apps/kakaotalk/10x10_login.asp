<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim userid, strTmpUserKey
userid = GetLoginUserID
strTmpUserKey = requestCheckVar(request("temp_user_key"),32)

if (userid<>"") then
	'response.redirect "/"
end if

Dim vSavedID
vSavedID = tenDec(request.cookies("mSave")("SAVED_ID"))
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/oldContent.css">
<title>10x10: 텐바이텐 사용자 인증</title>
<script type="application/x-javascript" src="/lib/js/iui_clickEffect.js"></script>
<script language='javascript'>
if(!navigator.cookieEnabled) alert("쿠키를 허용해주세요.\n쿠키가 허용되어야 로그인을 하실 수 있습니다.");

function TnCSlogin(frm){
	if (frm.userid.value.length<1) {
		alert('아이디를 입력하세요.');
		frm.userid.focus();
		return false;
	}

	if (frm.userpass.value.length<1) {
		alert('패스워드를 입력하세요.');
		frm.userpass.focus();
		return false;
	}

	if(!frm.kakaoMsg.checked) {
		alert("서비스 이용에 동의하셔야 카카오톡 맞춤정보 서비스 신청이 가능합니다.")
		return false;
	}


	frm.submit();
//	return true;
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<div class="kakaoHead">
				<p class="kakao"><img src="http://fiximage.10x10.co.kr/m/kakaotalk/img_tmsplus_logo@2x.png" alt="KakaoTalk Plus친구" width="115px" height="19px" /></p>
				<p class="cert"><em class="elmBg3">사용자 인증</em></p>
			</div>
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<div id="kakaoTms">
					<h2>텐바이텐 사용자 인증</h2>
					<p class="tMar10 pDesc cc91314">본 화면은 텐바이텐에서 제공하는 페이지입니다.</p>
					<p class="tMar5 pDesc">카카오톡으로 텐바이텐의 맞춤정보를 수신하기 위해서 최초 1회 사용자 인증이 필요합니다.<br />고객님의 텐바이텐 아이디와 비밀번호를 입력해 주세요.</p>
					<form name="frm" method="post" action="<%=M_SSLUrl%>/apps/kakaotalk/dologin.asp" target="ifmProc" onSubmit="return false;">
					<!--input type="hidden" name="backpath" value="/apps/kakaotalk/kakaotalk_proc.asp" -->
					<!--input type="hidden" name="strGD" value="mode=step1"-->
					<input type="hidden" name="backpath" value="/apps/kakaotalk/step1.asp">
					<input type="hidden" name="strGD" value="flow=drt">
					<input type="hidden" name="fullhp" value="">
					<div id="login_box" class="tMar20">
						<div class="memWrap">
							<table border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<table border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="60px;" class="id">아이디</td>
												<td><input type="text" id="tentenId" class="text" name="userid" value="<%=vSavedID%>" maxlength="32" autocomplete="off" style="width:95%;" /></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<table border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="60px;" class="id">비밀번호</td>
												<td><input type="password" id="tentenPw" class="text" name="userpass" maxlength="32" style="width:95%;" /></td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
							<div class="kakaoSendMsg">
								<input type="checkbox" id="kakaoMsg" name="kakaoMsg" class="check" />
								<p><label for="kakaoMsg">카카오톡으로 텐바이텐의 맞춤정보를 수신하겠습니다.</label><br />본 서비스를 신청하시면 텐바이텐의 주문 및 배송 관련 메시지와 다양한 혜택/이벤트 정보가 카카오톡으로 발송됩니다.</p>
							</div>
							<p class="ct tMar10"><span class="btn btn1 redB w90B"><a href="javascript:TnCSlogin(document.frm)">확인</a></span></p>
						</div>
					</div>
					</form>
					<div class="btnArea tMar15">
						<span class="btn btn1 gryB w90B"><a href="/member/find_id.asp">아이디 찾기</a></span>
						<span class="btn btn1 gryB w90B"><a href="/member/find_pw.asp">비밀번호 찾기</a></span>
						<span class="btn btn1 whtB w90B"><a href="/member/join.asp">회원가입하기</a></span>
					</div>
				</div>
			</div>
			<!-- //content area -->
		</div>
		<!-- #include virtual="/lib/inc/incFooter.asp" -->
	</div>
	 <!-- #include virtual="/category/incCategory.asp" -->
</div>
<iframe name="ifmProc" id="ifmProc" frameborder=0 width="100%" height="150"></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->