<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% 
response.charset = "utf-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'###########################################################
' Description : 텐바이텐 로그인 팝업 레이어
' History : 2014.04.28 허진원
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
	Dim strBackPath
%>
<script>
function FnLogin(frm) {
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

	frm.action = "<%=M_SSLUrl%>/apps/appCom/between/login/dologin.asp";
	frm.target = "ifmLgProc";
    $(window).unbind('beforeunload');		// 언로드 이벤트 제거
    frm.submit();
	return true;
}
</script>
<div class="lyrPop tentenLogin">
	<div class="lyrPopCont">
		<h1>텐바이텐 로그인</h1>
		<div>
			<p>텐바이텐 회원으로 구매 시 마일리지 <br />적립, 쿠폰 등의 회원혜택을 받으실 수 있습니다.</p>
			<fieldset>
			<form name="frmLogin" method="post" onSubmit="return FnLogin(this);">
			<input type="hidden" name="backpath" value="<%=strBackPath%>">
				<div class="formWrap">
					<p><input type="text" id="memId" name="userid" onKeyPress="if (event.keyCode == 13) frmLogin.userpass.focus();" maxlength="32" autocomplete="off" title="아이디 입력" placeholder="아이디" /></p>
					<p><input type="password" id="memPw" name="userpass" onKeyPress="if (event.keyCode == 13) FnLogin(frmLogin);" maxlength="32" title="비밀번호 입력" placeholder="비밀번호" /></p>
				</div>
				<div class="btnWrap">
					<p class="btn02 btnOk"><a href="" onclick="FnLogin(frmLogin); return false;" class="tenRed">텐바이텐 로그인</a></p>
				</div>
				<p class="loginOpt">
					<button type="button" class="txtDkGry" onclick="openbrowser('https://m.10x10.co.kr/member/find_id.asp?rdsite=btwShop'); return false;">아이디 찾기</button> <span>l</span>
					<button type="button" class="txtDkGry" onclick="openbrowser('https://m.10x10.co.kr/member/find_pw.asp?rdsite=btwShop'); return false;">비밀번호 찾기</button> <span>l</span>
					<button type="button" class="txtDkGry" onclick="openbrowser('http://m.10x10.co.kr/member/join.asp?rdsite=btwShop'); return false;">회원가입</button>
				</p>
			</form>
			<iframe id="ifmLgProc" name="ifmLgProc" src="about:blank" height="0" width="0" frameborder="0" marginheight="0" marginwidth="0"></iframe>
			</fieldset>
		</div>
	</div>
	<div class="lyrPopCont gry243 memBenefit">
		<dl>
			<dt>텐바이텐의 남다른 회원혜택</dt>
			<dd>
				<ul class="txtList02">
					<li><span class="txtBlk">마일리지적립</span> 상품구매시마일리지적립</li>
					<li><span class="txtBlk">다양한 상품 쿠폰</span> 회원가입과 동시에 쿠폰 발급</li>
					<li><span class="txtBlk">회원 등급별 혜택</span> 구매할 수록 할인혜택은 UP</li>
				</ul>
			</dd>
		</dl>
	</div>
	<span class="lyrClose">&times;</span>
</div>
<div class="dimmed"></div>
<!-- #include virtual="/lib/db/dbclose.asp" -->