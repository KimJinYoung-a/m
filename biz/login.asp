<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description :  로그인
' History : 2014.09.01 허진원 리뉴얼
' History : 2017.12.01 원승현 수정
' History : 2019.12.02 이종화 수정 -- enter 중복처리
' History : 2020.03.20 원승현 수정 -- UI 변경
' History : 2020.11.09 정태훈 수정 -- UI 변경
' History : 2021.07.01 정태훈 수정 -- biz 로그인 추가
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'해더 타이틀
strHeadTitleName = "로그인"

dim userid
	userid = GetLoginUserID

if (userid<>"") then
	response.redirect "/biz/"
    dbget.Close : response.end ''2015/04/21
end if

dim strBackPath, strGetData, strPostData
	strBackPath = ReplaceRequestSpecialChar(request("backpath"))
	strBackPath = Replace(strBackPath,"^^","&")
	strGetData  = ReplaceRequestSpecialChar(request("strGD"))
	strPostData = ReplaceRequestSpecialChar(request("strPD"))

Dim vSavedAuto, vSavedID, vSavedPW
	vSavedAuto = request.cookies("mSave")("SAVED_AUTO")
	vSavedID = tenDec(request.cookies("mSave")("SAVED_ID"))
	'vSavedPW = tenDec(request.cookies("mSave")("SAVED_PW"))

'///로그인 분기처리 (TAB BAR)
Dim bp : bp = ReplaceRequestSpecialChar(request("backpath"))
Dim footflag : footflag = false

If InStr(bp,"mymain.asp") > 0 Or InStr(bp,"myorderlist.asp") > 0 Or InStr(bp,"myrecentview.asp") > 0 Then
	footflag = true
End If 
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 로그인</title>
<link rel="stylesheet" type="text/css" href="/lib/css/common.css?v=2.03" />
<link rel="stylesheet" type="text/css" href="/lib/css/content.css?v=4.90" />
<script type="text/javascript">
$(function(){
	$(".btnGroupSocial").each(function(){
		var checkItem = $(this).children("ul").children("li").length;
		if (checkItem == 1) {
			$(this).children("ul").children("li").addClass("full");
		}
	});

	fnAmplitudeEventAction("view_login","","");
});

if(!navigator.cookieEnabled) alert("쿠키를 허용해주세요.\n쿠키가 허용되어야 로그인을 하실 수 있습니다.");

function TnCSlogin(frm){
	if (frm.userid.value.length<1) {
		alert('아이디를 입력해주세요.');
		frm.userid.focus();
		return false;
	}

	if (frm.userpass.value.length<1) {
		alert('비밀번호를 입력해주세요.');
		frm.userpass.focus();
		return false;
	}

	frm.action = '<%=M_SSLUrl%>/biz/dologin.asp';
    frm.submit();
	return true;
}

function TnBizJoin(){
	location.href="/biz/join_step1.asp?biz=Y";
}
</script>
</head>
<body class="default-font body-sub body-1depth">
<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<div id="content" class="content">

		<div class="login-form bizForm">
			<form name="frmLogin2" method="post" onSubmit="return TnCSlogin(this);">
			<input type="hidden" name="backpath" value="<%=strBackPath%>">
			<input type="hidden" name="strGD" value="<%=strGetData%>">
			<input type="hidden" name="strPD" value="<%=strPostData%>">
				<fieldset>
					<legend class="hidden">로그인</legend>
                    <div class="loginBizTit">
                        <h2>BIZ 로그인</h2>
                        <p>텐바이텐 BIZ 아이디와 비밀번호를 입력해주세요.<br/>기존 텐바이텐 계정은 사용하실 수 없습니다.</p>
                    </div>
					<div class="form-group">
						<input type="text" name="userid" id="id" autocorrect="off" autocapitalize="off" value="<%=vSavedID%>" onKeyPress="if (event.keyCode == 13) frmLogin2.userpass.focus();" maxlength="32" required />
						<label for="id">아이디</label>
					</div>
					<div class="form-group">
						<input type="password" name="userpass" id="password" autocorrect="off" autocapitalize="off" value="" required />
						<label for="password">비밀번호</label>
					</div>
					<div class="auto-login"><input type="checkbox" name="saved_auto" id="autoLogin" value="o" <% If vSavedAuto <> "" Then Response.Write "checked" End If %> /> <label for="autologin">로그인 유지</label></div>
					<% if session("chkLoginLock") then %>
                    <div class="loginLimitV15a">
						<div class="txtBoxV15a">ID/PW 입력 오류로 인해 로그인이 제한되었습니다.<br />개인정보 보호를 위해 아래 항목을 입력해주세요.</div>
                        <div class="ct">
                            <script src="https://www.google.com/recaptcha/api.js" async defer></script>
                            <div id="g-recaptcha" class="g-recaptcha" data-sitekey="6LdSrA8TAAAAAD0qwKkYWFQcex-VzjqJ6mbplGl6"></div>
                            <style>
                            .g-recaptcha {margin:0 auto; padding:0; transform-origin:0 0; -webkit-transform-origin:0 0;}
                            .g-recaptcha > div {margin:0 auto;}
                            .g-recaptcha > div > div {width:100% !important;}
                            </style>
                        </div>
					</div>
                    <% end if %>
                    <div class="btnBizLog">
                        <div class="btn-group">
                            <input type="submit" value="BIZ 로그인" class="btn btn-red btn-xlarge btn-block" onclick="TnCSlogin(frmLogin2); fnAmplitudeEventMultiPropertiesAction('click_login_button', 'action|autologin', 'nomal|<% If vSavedAuto <> "" Then Response.write "on" Else Response.write "off" End If %>'); return false;" />
                        </div>
                        <div class="btn-group">
                            <input type="submit" value="BIZ 회원가입" onclick="TnBizJoin();return false;" class="btn btn-red btn-xlarge btn-block" />
                        </div>
                    </div>
                    <div class="login-utility utilityBiz"><!-- for dev msg : 2021-06-30 biz 추가 -->
						<div class="utility-link">
							<a href="/member/find_idpw.asp?t=id">아이디/비밀번호 찾기</a>
						</div>
					</div>
				</fieldset>
			</form>
		</div>
	</div>

<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->