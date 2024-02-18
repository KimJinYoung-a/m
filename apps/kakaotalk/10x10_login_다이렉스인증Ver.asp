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
<!-- #INCLUDE Virtual="/lib/header.asp" -->
<%
dim userid, strTmpUserKey
userid = GetLoginUserID
strTmpUserKey = requestCheckVar(request("temp_user_key"),32)

if Len(strTmpUserKey)<16 or Not(isNumeric(strTmpUserKey)) then
	Call Alert_return("파라메터 오류입니다.")
	response.End
end if

if (userid<>"") then
	'response.redirect "/"
end if

Dim vSavedID
vSavedID = tenDec(request.cookies("mSave")("SAVED_ID"))
%>
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

	if (!frm.chkKakao.checked) {
		alert('카카오톡 맞춤정보 서비스 수신에 동의하여야 서비스 신청이 가능합니다.');
		frm.chkKakao.focus();
		return false;
	}

	frm.action = '<%=M_SSLUrl%>/apps/kakaotalk/dologin.asp';
	return true;
}
</script>

<div class="kakaoHead toolbar">
	<p><img src="http://fiximage.10x10.co.kr/m/kakaotalk/img_tmsplus_logo@2x.png" alt="KakaoTalk Plus친구" width="115px" height="19px" /></p>
	<span><img src="http://fiximage.10x10.co.kr/m/kakaotalk/img_tmsplus_lock@2x.png" alt="사용자 인증" width="9px" height="12px" /> 사용자 인증</span>
</div>
<!-- header area //-->
<div selected="true">
	<div class="container" id="kakaoTms">
		<h1><img src="http://fiximage.10x10.co.kr/m/kakaotalk/tit_kakao_1010.png" alt="텐바이텐 사용자 인증" width="196px" height="22px" /></h1>
		<p class="tm15 pointTxt01 fs12">본 화면은 텐바이텐에서 제공하는 페이지입니다.</p>
		<p class="tm10 txt01">카카오톡으로 텐바이텐의 맞춤정보를 수신하기 위해서 최초 1회 사용자 인증이 필요합니다.<br />고객님의 텐바이텐 아이디와 비밀번호를 입력해 주세요.</p>
		<div class="tm20 loginBox">
			<form name="frmLogin2" method="post" action="" onSubmit="return TnCSlogin(this);" target="ifmProc">
			<input type="hidden" name="backpath" value="/apps/kakaotalk/kakaotalk_proc.asp">
			<input type="hidden" name="strGD" value="strTmpUserKey=<%=strTmpUserKey%>&mode=AddTmp">
			<div class="loginForm">
				<fieldset>
				<p>
					<span class="loginTit"><label for="tentenId">아이디</label></span>
					<input type="text" id="tentenId" class="txtBasic" name="userid" value="<%=vSavedID%>" maxlength="32" autocomplete="off" style="width:180px;" title="아이디를 입력해 주세요." />
				</p>
				<p class="tm10">
					<span class="loginTit"><label for="tentenPw">비밀번호</label></span>
					<input type="password" id="tentenPw" class="txtBasic" name="userpass" maxlength="32" style="width:180px;" title="비밀번호를 입력해 주세요." />
				</p>
				<p class="tm20 kakaoInfo">
					<input type="checkbox" name="chkKakao" id="kakaoMsg" class="check" checked />
					<label for="kakaoMsg">카카오톡으로 텐바이텐의 맞춤정보를 수신하겠습니다.<br /><br />본 서비스를 신청하시면 텐바이텐의 주문 및 배송 관련 메시지와 다양한 혜택/이벤트 정보가 카카오톡으로 발송됩니다.</label>
				</p>
				</fieldset>
				<p class="loginOk tm10"><input type="image" src="http://fiximage.10x10.co.kr/m/kakaotalk/btn_okay.png" alt="확인" width="153px" height="44px" /></p>
			</div>
			</form>
		</div>
		<div id="login_bt">
			<a href="/member/find_id.asp" title="_webapp"><img src="http://fiximage.10x10.co.kr/m/login/btn_log_findid.jpg" alt="아이디 찾기" width="95px" /></a>
			<a href="/member/find_pw.asp" title="_webapp"><img src="http://fiximage.10x10.co.kr/m/login/btn_log_findpw.jpg" alt="비밀번호 찾기" width="95px" /></a>
			<a href="/member/join.asp" title="_webapp"><img src="http://fiximage.10x10.co.kr/m/login/btn_log_join.jpg" alt="회원가입하기" width="95px" /></a>
		</div>
	</div>
</div>
<iframe name="ifmProc" id="ifmProc" frameborder=0 width="100%" height="150"></iframe>

<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->