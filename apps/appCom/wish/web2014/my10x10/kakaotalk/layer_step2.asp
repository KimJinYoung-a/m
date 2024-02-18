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
'	Description : 카카오톡
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/apps/appcom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim sflow, usrHp1, usrHp2, usrHp3
	sflow	= requestCheckVar(Request("flow"),3)
	usrHp1	= requestCheckVar(Request("hpNo1"),4)
	usrHp2	= requestCheckVar(Request("hpNo2"),4)
	usrHp3	= requestCheckVar(Request("hpNo3"),4)
%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript">

function chkForm() {
	var frm = document.frm;
	var frmp = parent.document.frminfo;

	if(!frm.hpNo1.value) {
		alert("휴대폰국번을 입력해주세요.")
		frm.hpNo1.focus();
		return false;
	}
	if(!IsDigit(frm.hpNo1.value)) {
		alert("휴대폰국번을 숫자로 입력해주세요.")
		frm.hpNo1.focus();
		return false;
	}
	if(!frm.hpNo2.value) {
		alert("휴대폰 앞자리를 입력해주세요.")
		frm.hpNo2.focus();
		return false;
	}
	if(!IsDigit(frm.hpNo2.value)) {
		alert("휴대폰 앞자리를 숫자로 입력해주세요.")
		frm.hpNo2.focus();
		return false;
	}
	if(!frm.hpNo3.value) {
		alert("휴대폰 뒷자리를 입력해주세요.")
		frm.hpNo3.focus();
		return false;
	}
	if(!IsDigit(frm.hpNo3.value)) {
		alert("휴대폰 뒷자리를 숫자로 입력해주세요.")
		frm.hpNo3.focus();
		return false;
	}
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
		alert("서비스 이용에 동의하셔야 카카오톡 맞춤정보 서비스 신청이 가능합니다.");
		frm.kakaoMsg.focus();
		return false;
	}

	// 인증번호 받기 전송
	var rstStr = $.ajax({
		type: "POST",
		url: "/apps/appCom/wish/web2014/my10x10/kakaotalk/ajax_kakaoTalk_proc.asp",
		data: "mode=step2&flow=<%=sflow%>&certifyNo="+frm.certifyNo.value+"&hpNo1="+frm.hpNo1.value+"&hpNo2="+frm.hpNo2.value+"&hpNo3="+frm.hpNo3.value,
		dataType: "text",
		async: false
	}).responseText;
	//rstStr='1000';
	if (rstStr == "2"){
		alert('잘못된 인증번호입니다.');
		return false;
	}else if (rstStr == "3"){
		alert('잘못된 휴대폰번호입니다.');
		return false;			
	}else if (rstStr == "3008"){
		alert('인증번호가 만료되었습니다.\n새로운 인증번호를 받아주세요.');
		location.replace("/apps/appCom/wish/web2014/my10x10/kakaotalk/layer_step1.asp");
		return false;
		//jsOpenModal("/apps/appCom/wish/web2014/my10x10/kakaotalk/layer_step1.asp")

	}else if (rstStr == "9999"){
		alert('로그인을 해주세요.');
		return false;
	}else if (rstStr == "1000"){
		location.replace("/apps/appCom/wish/web2014/my10x10/kakaotalk/layer_step3.asp");
		return false;

	}else{
		//alert(rstStr);
		alert('오류가 발생했습니다.');
		return false;
	}	
}

function sendSMS() {
	var frm = document.frm;
	var frmp = parent.document.frminfo;

	if(!frm.hpNo1.value) {
		alert("휴대폰국번을 입력해주세요.")
		frm.hpNo1.focus();
		return false;
	}
	if(!IsDigit(frm.hpNo1.value)) {
		alert("휴대폰국번을 숫자로 입력해주세요.")
		frm.hpNo1.focus();
		return false;
	}
	if(!frm.hpNo2.value) {
		alert("휴대폰 앞자리를 입력해주세요.")
		frm.hpNo2.focus();
		return false;
	}
	if(!IsDigit(frm.hpNo2.value)) {
		alert("휴대폰 앞자리를 숫자로 입력해주세요.")
		frm.hpNo2.focus();
		return false;
	}
	if(!frm.hpNo3.value) {
		alert("휴대폰 뒷자리를 입력해주세요.")
		frm.hpNo3.focus();
		return false;
	}
	if(!IsDigit(frm.hpNo3.value)) {
		alert("휴대폰 뒷자리를 숫자로 입력해주세요.")
		frm.hpNo3.focus();
		return false;
	}

	// 인증번호 받기 전송
	var rstStr = $.ajax({
		type: "POST",
		url: "/apps/appCom/wish/web2014/my10x10/kakaotalk/ajax_kakaoTalk_proc.asp",
		data: "mode=step1&flow=<%=sflow%>&hpNo1="+frm.hpNo1.value+"&hpNo2="+frm.hpNo2.value+"&hpNo3="+frm.hpNo3.value,
		dataType: "text",
		async: false
	}).responseText;

	if (rstStr == "2"){
		alert('잘못된 휴대폰번호입니다.');
		return false;
	}else if (rstStr == "3009"){
		alert('이전에 받으신 인증번호가 아직 유효합니다.\n먼저 받으신 번호를 입력해주세요.');
		location.replace("/apps/appCom/wish/web2014/my10x10/kakaotalk/layer_step2.asp?flow=<%=sflow%>&hpNo1="+frm.hpNo1.value+"&hpNo2="+frm.hpNo2.value+"&hpNo3="+frm.hpNo3.value);
		return false;

	}else if (rstStr == "2103"){
		alert('본 서비스는 스마트폰에 카카오톡이 설치되어 있어야 이용이 가능합니다.\n카카오톡이 설치 되어있지 않다면 설치 후 이용해주시기 바랍니다.');
		return false;
	}else if (rstStr == "1000"){
		location.replace("/apps/appCom/wish/web2014/my10x10/kakaotalk/layer_step2.asp?flow=<%=sflow%>&hpNo1="+frm.hpNo1.value+"&hpNo2="+frm.hpNo2.value+"&hpNo3="+frm.hpNo3.value);
		return false;

	}else{
		alert(rstStr);
		//alert('오류가 발생했습니다.');
		return false;
	}
}

</script>
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container popWin bgGry">
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
		    <form name="frm" method="POST" style="margin:0px;" onsubmit="return false;">
			<input type="hidden" name="mode" value="step2">
			<input type="hidden" name="hpNo1" value="<%=usrHp1%>">
			<input type="hidden" name="hpNo2" value="<%=usrHp2%>">
			<input type="hidden" name="hpNo3" value="<%=usrHp3%>">
			<input type="hidden" name="flow" value="<%=sflow%>">
			<input type="hidden" name="cp" value="">
			<div class="inner5">
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
			</div>
			</form>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->