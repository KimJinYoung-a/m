<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : 카카오톡
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim fullhp, sflow
	fullhp	= requestCheckVar(Request("fullhp"),12)
	sflow	= requestCheckVar(Request("flow"),3)
%>

<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">

function chkForm() {
	var frm = document.frm;

	if(!frm.certifyNo.value) {
		alert("카카오톡으로 받으신 인증번호를 입력해주세요.")
		frm.certifyNo.focus();
		return false;
	}
	if(!IsDigit(frm.certifyNo.value)) {
		alert("인증번호는 숫자로 입력해주세요.")
		frm.certifyNo.focus();
		return false;
	}
	if(!frm.kakaoMsg.checked) {
		alert("서비스 이용에 동의하셔야 카카오톡 맞춤정보 서비스 신청이 가능합니다.")
		return false;
	}

	// 인증번호 받기 전송
	frm.target="ifmProc";
	frm.action="kakaoTalk_proc.asp";
	frm.mode.value="step2";
	frm.submit();
	return true;
}

function sendSMS() {
	var frm = document.frm;

	// 인증번호 받기 전송
	frm.target="ifmProc";
	frm.action="kakaoTalk_proc.asp";
	frm.mode.value="step1";
	frm.submit();
	return true;
}

</script>
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container popWin bgGry">
		<div class="header">
			<h1>카카오톡 맞춤정보 서비스</h1>
			<p class="btnPopClose"><button class="pButton" onclick="self.close();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content kakaoService" id="contentArea">
			<h2><img src="http://fiximage.10x10.co.kr/m/2014/my10x10/txt_kakao_head.gif" alt="카카오톡 플러스친구 사용자 인증" /></h2>
			<div class="joinStep">
				<ol>
					<li class="on"><span>1</span>텐바이텐 인증</li>
					<li class="on"><span>2</span>카카오톡 인증</li>
					<li><span>3</span>신청완료</li>
				</ol>
			</div>
			<div class="inner5">
				<form name="frm" method="POST" style="margin:0px;">
				<input type="hidden" name="mode" value="step2">
				<input type="hidden" name="fullhp" value="<%=fullhp%>">
				<input type="hidden" name="flow" value="<%=sflow%>">
				<input type="hidden" name="cp" value="">
				<div class="box1">
					<div>
						<input type="number" name="certifyNo" maxlength="4" class="inpNum w60p" placeholder="인증번호 입력" />
					</div>
					<p class="tMar15 cBk1 lh14"><strong>카카오톡으로 받은 인증번호를 입력하고<br />확인 버튼을 눌러주세요!</strong></p>
					<div class="infoBox">
						<input type="checkbox" name="kakaoMsg" class="ftLt" />
						<dl>
							<dt>맞춤정보 수신동의</dt>
							<dd>카카오톡으로 텐바이텐의 맞춤정보를 수신하겠습니다. 본 서비스를 신청하시면 텐바이텐 주문 및 배송관련 메시지와 다양한 혜택/이벤트 정보가 카카오톡으로 발송됩니다.</dd>
						</dl>
					</div>
					<div class="btnWrap tMar20">
						<p class="ftLt w50p"><span class="button btB1 btRedBdr cRd1 w100p"><a href="" onclick="sendSMS(); return false;">인증번호 재전송</a></span></p>
						<p class="ftRt w50p"><span class="button btB1 btRed cWh1 w100p"><a href="" onclick="chkForm(); return false;">확인</a></span></p>
					</div>
				</div>
				</form>
				<iframe name="ifmProc" id="ifmProc" frameborder=0 width="400" height="400"></iframe>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->