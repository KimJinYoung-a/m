<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : 나의정보 / 비밀번호 재확인
'	History	:  2014.09.17 한용민 생성
'#######################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim errcode
errcode = request("errcode")

'####### POINT1010 에서 넘어온건지 체크 #######
Dim pFlag
pFlag	= requestCheckVar(request("pflag"),1)
'####### POINT1010 에서 넘어온건지 체크 #######

Dim vSavedID, vSavedPW
vSavedID = tenDec(request.cookies("SAVED_ID"))
vSavedPW = tenDec(request.cookies("SAVED_PW"))

strHeadTitleName="개인정보관리"
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type='text/javascript'>

function TnConfirmlogin(frm){
	if (frm.userpass.value.length<1) {
		alert('비밀번호를 입력해주세요');
		frm.userpass.focus();
		return false;
	}
	frm.action = '<%=M_SSLUrl%>/my10x10/userinfo/doConfirmUser.asp';
	frm.submit();
}

<%''간편로그인수정;허진원 2018.04.24%>
function fnPopSNSLogin(snsgb,wd,hi) {
	var snsbackpath = '<%=strBackPath%>';
	var popup = window.open("/login/mainsnslogin.asp?snsdiv="+snsgb+"&pggb=mc&snsbackpath="+snsbackpath,"","width=600, height=800");
}
</script>
</head>
<body class="default-font body-sub body-1depth bg-grey">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- content area -->
	<div class="content" id="contentArea" class="content">
		<div class="alert-text">
			<div class="inner">
				<p>회원님의 정보를 안전하게 보호하기 위해 비밀번호를 다시 한 번 확인합니다.</p>
			</div>
		</div>
		<%
			''간편로그인수정;허진원 2018.04.24
			if GetLoginUserDiv="05" then
		%>
			<div class="login-form">
				<h2>SNS 인증 확인</h2>
				<div class="sns-login">
					<ul class="sns-accountV20">
						<li class="kakao"><a href="" onclick="fnPopSNSLogin('ka','470','570');return false;"><i class="icon"></i><span class="text">카카오톡</span></a></li>
						<li class="google"><a href="" onclick="fnPopSNSLogin('gl','410','420');return false;"><i class="icon"></i><span class="text">구글</span></a></li>
						<li class="naver"><a href="" onclick="fnPopSNSLogin('nv','400','800');return false;"><i class="icon"></i><span class="text">네이버</span></a></li>
						<li class="facebook"><a href="" onclick="fnPopSNSLogin('fb','410','300');return false;"><i class="icon"></i><span class="text">페이스북</span></a></li>
					</ul>
				</div>
			</div>
		<% else %>
			<div class="login-form">
				<% if (errcode="1") then %>
					<p id="er" class="ct fs12 cGy3 bPad10"><span class="cRd1">비밀번호 오류</span>입니다. 비밀번호를 다시 입력해주세요</p>
				<% end if %>

				<form name="frmLoginConfirm" method="post" action="" onSubmit="return TnConfirmlogin(this);" style="margin:0px;">
				<input type="hidden" name="pflag" value="<%=pFlag%>">
					<fieldset>
						<legend class="hidden">로그인 폼</legend>
						<div class="form-group">
							<input type="text" name="userid" id="login_input" value="<%= getEncLoginUserID %>" required ReadOnly />
							<label for="id"></label>
						</div>
						<div class="form-group">
							<input type="password" name="userpass" id="login_input" onKeyPress="if (event.keyCode == 13) TnConfirmlogin(frmLoginConfirm);" required />
							<label for="password">비밀번호</label>
						</div>

						<div class="btn-group">
							<input type="submit" value="로그인" onclick="TnConfirmlogin(frmLoginConfirm); return false;" class="btn btn-red btn-xlarge btn-block" />
						</div>
					</fieldset>
				</form>
			</div>
		<% end if %>
	</div>
	<!-- //content area -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->