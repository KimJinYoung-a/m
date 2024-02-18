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
'	Description : 나의정보
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/apps/appcom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
dim userid, userpass, myUserInfo, chkKakao
	userid = getEncLoginUserID

chkKakao = false

set myUserInfo = new CUserInfo
	myUserInfo.FRectUserID = userid
	
	if (userid<>"") then
	    myUserInfo.GetUserData 
	    chkKakao = myUserInfo.chkKakaoAuthUser	'// 카카오톡 인증여부
	end if

if (myUserInfo.FResultCount<1) then
    response.write "<script>alert('정보를 가져올 수 없습니다.');</script>"
    response.end
end If

strHeadTitleName = "개인정보관리"
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script language='javascript'>

function ChangeMyPass(frm){
	if (frm.oldpass.value.length<1){
		alert('기존 비밀번호를 입력하세요.');
		frm.oldpass.focus();
		return;
	}

	if (frm.newpass1.value.length<8){
		alert('새로운 비밀번호는 8자 이상으로 입력하세요.');
		frm.newpass1.focus();
		return;
	}

	if (frm.newpass1.value=='<%=userid%>'){
		alert('아이디와 동일한 비밀번호는 사용하실 수 없습니다.');
		frm.newpass1.focus();
		return;
	}

	if( frm.newpass1.value.indexOf("'") > -1 ) {
		alert('새로운 비밀번호는 특수문자(\')를 포함 하실 수 없습니다.');
		frm.newpass1.focus();
		return;
	}

	if (!fnChkComplexPassword(frm.newpass1.value)) {
		alert('새로운 비밀번호는 영문/숫자 등 두가지 이상의 조합으로 입력하세요.');
		frm.newpass1.focus();
		return;
	}

	if (frm.newpass1.value!=frm.newpass2.value){
		alert('새로운 비밀번호가 일치하지 않습니다.');
		frm.newpass1.focus();
		return;
	}

	var ret = confirm('비밀번호를 변경하시겠습니까?');

	if(ret){
		frm.submit();
	}
}

</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content bgGry" id="contentArea">
				<div class="inner5">
					<div class="tab01 tMar15">
						<ul class="tabNav tNum2 noMove">
							<li><a href="/my10x10/userinfo/membermodify.asp">개인정보관리<span></span></a></li>
							<li class="current"><a href="/my10x10/userinfo/memberUserPass.asp">비밀번호 변경<span></span></a></li>
						</ul>
						<div class="tabContainer">
							<!-- 비밀번호 변경 -->
							<div class="tabContent">
								<div class="box1">
									<div class="writeInfo">
										<table class="writeTbl01">
											<colgroup>
												<col width="27%" />
												<col width="" />
											</colgroup>
											<form name="frmpass" method="post" action="<%=M_SSLUrl%>/my10x10/userinfo/membermodify_process.asp" style="margin:0px;" onsubmit="return false;">
											<input type="hidden" name="mode" value="passmodi">
											<tbody>
												<tr>
													<th>현재 비밀번호</th>
													<td><input type="password" name="oldpass" onKeyPress="if (event.keyCode == 13) ChangeMyPass(frmpass);" class="w100p" /></td>
												</tr>
												<tr>
													<th>신규 비밀번호</th>
													<td><input type="password" name="newpass1" onKeyPress="if (event.keyCode == 13) ChangeMyPass(frmpass);" class="w100p" /></td>
												</tr>
												<tr>
													<th>비밀번호 확인</th>
													<td>
														<input type="password" name="newpass2" onKeyPress="if (event.keyCode == 13) ChangeMyPass(frmpass);" class="w100p" />
														<p class="cRd1 tMar05">8~16자의 영문/숫자를 조합하여 입력</p>
													</td>
												</tr>
											</tbody>
											</form>
										</table>
										<p class="tMar30 bPad10"><span class="button btB1 btRed cWh1 w100p"><input type="submit" onclick="ChangeMyPass(document.frmpass);" value="비밀번호 변경" /></span></p>
									</div>
								</div>
							</div>
							<!--// 비밀번호 변경 -->
						</div>
					</div>
				</div>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>

<%
set myUserInfo = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->