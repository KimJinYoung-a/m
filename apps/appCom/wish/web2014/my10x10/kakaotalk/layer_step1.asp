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
<!-- #include virtual="/apps/appcom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
dim userid, username, usrHp1, usrHp2, usrHp3, sflow
	userid = getEncLoginUserID
	username = GetLoginUserName
	sflow	= requestCheckVar(Request("flow"),3)

dim myUserInfo
set myUserInfo = new CUserInfo
	myUserInfo.FRectUserID = userid
	
	if (userid<>"") then
	    myUserInfo.GetUserData
	    on Error Resume Next
	    usrHp1 = SplitValue(myUserInfo.FOneItem.Fusercell,"-",0)
	    usrHp2 = SplitValue(myUserInfo.FOneItem.Fusercell,"-",1)
	    usrHp3 = SplitValue(myUserInfo.FOneItem.Fusercell,"-",2)
	    On Error Goto 0
	end if
set myUserInfo = Nothing
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
	if(!frm.kakaoMsg.checked) {
		alert("서비스 이용에 동의하셔야 카카오톡 맞춤정보 서비스 신청이 가능합니다.")
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
	//rstStr='1000';
	if (rstStr == "2"){
		alert('잘못된 휴대폰번호입니다.');
		return false;
	}else if (rstStr == "9999"){
		alert('로그인을 해주세요.');
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
		//alert(rstStr);
		alert('오류가 발생했습니다.');
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
					<li><span>2</span>카카오톡 인증</li>
					<li><span>3</span>신청완료</li>
				</ol>
			</div>
			<form name="frm" method="post" style="margin:0px;" onsubmit="return false;">
			<input type="hidden" name="mode" value="step1">
			<input type="hidden" name="flow" value="<%=sflow%>">
			<div class="inner5">
				<div class="box1">
					<div>
						<input type="tel" name="hpNo1" value="<%=usrHp1%>" pattern="[0-9]*" maxlength="4" class="w20p inpNum" value="010" /> - 
						<input type="tel" name="hpNo2" value="<%=usrHp2%>" pattern="[0-9]*" maxlength="4" class="w20p inpNum" value="1234" /> - 
						<input type="tel" name="hpNo3" value="<%=usrHp3%>" pattern="[0-9]*" maxlength="4" class="w20p inpNum" value="5678" />
					</div>
					<!-- p class="fs11 tMar15 cGy1 lh14">휴대폰 번호를 수정하시면<br />개인정보의 휴대폰 번호도 수정됩니다.</p -->
					<div class="infoBox">
						<input type="checkbox" name="kakaoMsg" class="ftLt" />
						<dl>
							<dt>개인정보 취급 위탁동의</dt>
							<dd>
								<ul>
									<li>- 취급업체 : (주) 카카오</li>
									<li>- 위탁업무 내용 : 사용자 인증</li>
									<li>- 공유정보 : 휴대전화번호</li>
									<li>- 개인정보 이용기간 : 회원탈퇴 혹은 서비스 해제시까지</li>
								</ul>
							</dd>
						</dl>
					</div>
					<div class="btnWrap tMar20">
						<span class="button btB1 btRed cWh1 w50p"><a href="" onclick="chkForm(); return false;">인증번호 받기</a></span>
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