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
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
dim userid, username, usrHp
	userid = GetLoginUserID
	username = GetLoginUserName

dim myUserInfo, chkKakao
	chkKakao = false

set myUserInfo = new CUserInfo
	myUserInfo.FRectUserID = userid

	if (userid<>"") then
	    myUserInfo.GetUserData
	    chkKakao = myUserInfo.chkKakaoAuthUser	'// 카카오톡 인증여부
	    usrHp = myUserInfo.FOneItem.Fusercell
	end if
set myUserInfo = Nothing

if Not(chkKakao) then
	Call Alert_Close("카카오톡 서비스가 신청되어있지 않습니다.")
	Response.End
end if
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">

function chkForm() {
	var frm = document.frm;

	if(confirm("카카오톡 서비스를 해제하시겠습니까?")) {
		frm.target="ifmProc";
		frm.action="kakaoTalk_proc.asp";
		frm.mode.value="clear";
		frm.submit();
	}
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
			<div class="inner5">
				<div class="box1">
					<p class="fs12 cBk1 lh14">카카오톡 맞춤정보 서비스를 해제합니다.<br />서비스를 해제하시면,<br />카카오톡 맞춤정보 서비스를 받을 수 없게 됩니다.<br />단, 서비스 해제시에도 상품 주문 및 배송 관련 정보는<br />정보수신 동의와 별도로 SMS로 자동 발송됩니다.</p>
					<p class="fs11 tMar25">서비스 해제할 휴대폰 번호는 아래와 같습니다.</p>
					<p class="cRd1 fs15 tMar10"><strong><%=usrHp%></strong></p>
					<div class="btnWrap tMar25">
						<span class="button btB1 btRed cWh1 w50p"><a href="" onclick="chkForm(); return false;">서비스 해제</a></span>
					</div>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
	<form name="frm" method="POST" style="margin:0px;">
	<input type="hidden" name="mode" value="clear">
	</form>
	<iframe name="ifmProc" id="ifmProc" frameborder=0 width="0" height="0"></iframe>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->