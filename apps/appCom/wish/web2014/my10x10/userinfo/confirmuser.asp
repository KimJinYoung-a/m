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
'	Description : 나의정보 / 비밀번호 재확인
'	History	:  2014.09.17 한용민 생성
'#######################################################
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->

<%
dim errcode
errcode = request("errcode")

Dim vSavedID, vSavedPW
vSavedID = tenDec(request.cookies("SAVED_ID"))
vSavedPW = tenDec(request.cookies("SAVED_PW"))
%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type='text/javascript'>

function TnConfirmlogin(frm){
	if (frm.userpass.value.length<1) {
		alert('패스워드를 입력하세요.');
		frm.userpass.focus();
		return false;
	}

	frm.action = '<%=M_SSLUrl%>/apps/appCom/wish/web2014/my10x10/userinfo/doConfirmUserByForm.asp';
	frm.submit();
}

</script>
</head>
<body class="bg-grey">
<div class="heightGrid">
	<div class="container popWin bg-grey">
		<!-- content area -->
		<div class="content myInfoMod" id="contentArea">
			<div class="inner5">
				<!--h2 class="tit01 tMar15">개인정보수정</h2-->
				<div class="writeInfo">
					<% if (errcode="1") then %>
						<p id="lyrFailPass" class="ct fs12 cGy3 bPad10"><span class="cRd1">비밀번호 오류</span>입니다. 비밀번호를 다시 입력해주세요</p>
					<% end if %>

					<table class="writeTbl01">
						<colgroup>
							<col width="27%" />
							<col width="" />
						</colgroup>
						<form name="frmLoginConfirm" method="post" action="" onSubmit="return false;" style="margin:0px;">
						<tbody>
							<tr>
								<th>아이디</th>
								<td><input type="text" name="userid" id="userid" value="<%= getEncLoginUserID %>" maxlength="32" autocomplete="off" ReadOnly class="w100p" /></td>
							</tr>
							<tr>
								<th>비밀번호</th>
								<td>
									<input type="password" name="userpass" id="pwd" maxlength="32" onKeyPress="if (event.keyCode == 13) TnConfirmlogin(frmLoginConfirm);" class="w100p" />
									<p class="cRd1 tMar05 fs11">회원님의 정보를 안전하게 보호하기 위해<br />비밀번호를 다시 한 번 확인합니다.</p>
								</td>
							</tr>
						</tbody>
						</form>
					</table>
					<p class="tMar30"><span class="button btB1 btRed cWh1 w100p"><input type="submit" onclick="TnConfirmlogin(frmLoginConfirm);" value="로그인" /></span></p>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->