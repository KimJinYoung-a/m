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
'	Description : Biz회원 회원정보 수정 페이지
'	History	:  2021.06.30 정태훈 생성
'#######################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<!-- #include virtual="/biz/classes/memberinfocls.asp" -->
<!-- #include virtual="/offshop/lib/classes/offshopCls.asp" -->
<%
'if application("Svr_Info")<>"Dev" and application("Svr_Info")<>"staging" then
'	response.redirect "/"
'end if
dim userid, userpass
userid = getEncLoginUserID
userpass = requestCheckVar(request.Form("userpass"),32)

Dim BizUserInfo, phoneIndex, emailIndex
Set BizUserInfo = new CBizUserInfo
BizUserInfo.FUserID = userid
BizUserInfo.FUserPassword = requestCheckVar(request.Form("userpass"),32)

''개인정보보호를 위해 패스워드로 한번더 Check
dim sqlStr, checkedPass, userdiv
dim Enc_userpass, Enc_userpass64
checkedPass = false

dim EcChk : EcChk = TenDec(request.Cookies("uinfo")("EcChk"))

'// 세션 체크 후에는 세션 삭제(새로고침 하면 다시 confirmuser 페이지로 이동함)
Session("InfoConfirmFlag") = ""

BizUserInfo.CheckAndInsertBizUserInfo
'// 유저 정보 조회
BizUserInfo.GetBizUserData

If BizUserInfo.FUserID = "" Then
    response.write "<script>alert('정보를 가져올 수 없습니다.');</script>"
    response.end
end If

strHeadTitleName = "개인정보관리"
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/common.css?v=2.03" />
<link rel="stylesheet" type="text/css" href="/lib/css/content.css?v=4.90" />
<script type="text/javascript" SRC="/lib/js/confirm.js"></script>
<script type='text/javascript'>

function ChangeMyInfo(frm){	
	if (frm.username.value.length<2){
		alert('이름을 입력해 주세요.');
		frm.username.focus();
		return;
	}

	<% ''간편로그인수정;허진원 2018.04.24 - 주소입력 스크립트 제거%>

	if (GetByteLength(frm.txAddr2.value)>80){
		alert('나머지 주소가 너무 깁니다. 80byte이내로 작성해주세요.\n※한글 1글자는 2byte입니다.');
		frm.txAddr2.focus();
		return;
	}
	var sEm = chkEmailForm(frm)
	if(!sEm) {
		return;
	} else {
		frm.usermail.value = sEm;
	}
	var sHp = chkPhoneForm(frm)
	if(!sHp) {
		return;
	} else {
		
	}

	if (frm.email_10x10check.checked){
		frm.email_10x10.value="Y";
	}else{
		frm.email_10x10.value="N";
	}
	if (frm.smsokcheck.checked){
		frm.smsok.value="Y";
	}else{
		frm.smsok.value="N";
	}

	if (frm.isEmailChk.value=="N"&&(frm.isMobileChk.value=="N"||frm.orgUsercell.value!=sHp)) {
		alert('이메일 또는 휴대전화 중 하나는 반드시 인증을 받으셔야 합니다.');
		return;
	}

	var ret = confirm('정보를 수정 하시겠습니까?');
	if (ret){
		frm.submit();
	}
}

function disableEmail(frm, comp){
	if (comp.checked){
		frm.email_way2way.checked = false;
		frm.email_10x10.checked = false;
		frm.emailok.value="N";
	}else{
		frm.email_way2way.checked = true;
		frm.email_10x10.checked = true;
		frm.emailok.value="Y";
	}
}

function TnTabNumber(thisform,target,num) {
   if (eval("document.frminfo." + thisform + ".value.length") == num) {
	  eval("document.frminfo." + target + ".focus()");
   }
}

function NewEmailChecker(){
  var frm = document.frminfo;
  if( frm.txEmail2.value == "etc")  {
	frm.selfemail.style.display = '';
	frm.selfemail.focus();
  }else{
	frm.selfemail.style.display = 'none';
  }
  return;
}

// 본인인증 이메일 발송
function sendCnfEmail(frm) {
	var sEm = chkEmailForm(frm)
	if(!sEm) return;

	if(sEm==frm.orgUsermail.value&&frm.isEmailChk.value=="Y") {
		alert("'"+sEm+"'(은)는 이미 인증이 완료된 이메일입니다.");
		return;
	}
	
	if(confirm("입력하신 이메일 '"+sEm+"'(으)로 인증을 받으시겠습니까?\n\n※인증메일에서 링크를 클릭하시면 인증이 완료되며 이메일정보가 수정됩니다.")) {
		fnOpenModal('/biz/ajax/ajaxSendModifyEmail.asp?id=<%= userid %>&mail=' + sEm);
	}
}

// 본인인증 휴대폰SMS 발송
function sendCnfSMS(frm) {
	var sHp = chkPhoneForm(frm)
	if(!sHp) return;

	if(sHp==frm.orgUsercell.value&&frm.isMobileChk.value=="Y") {
		alert("'"+sHp+"'(은)는 이미 인증이 완료된 휴대폰입니다.");
		return;
	}

	if(confirm("입력하신 휴대폰 '"+sHp+"'(으)로 인증을 받으시겠습니까?\n\n※전송된 인증번호를 입력창에 넣으시면 인증이 완료되며 휴대폰정보가 수정됩니다.")) {
		fnOpenModal('/biz/ajax/ajaxSendModifySMS.asp?id=<%= userid %>&phone=' + sHp);
	}
}

// 이메일 입력 확인
function chkEmailForm(frm) {
	var email;
	if (frm.txEmail1.value == ""){
		alert("이메일 앞부분을 입력해주세요");
		frm.txEmail1.focus();
		return ;
	}
	if (frm.txEmail1.value.indexOf('@')>-1){
		alert("@를 제외한 앞부분만 입력해주세요...");
		frm.txEmail1.focus();
		return ;
	}
	if (frm.txEmail2.value == "" && frm.selfemail.value == ""){
		alert("이메일 도메인을 선택해주시거나 직접 입력해주세요...");
		frm.txEmail2.focus();
		return ;
	}
	if ((frm.txEmail2.value == "etc")&&(frm.selfemail.value.length<1)){
		alert("이메일 도메인을 선택해주시거나 직접 입력해주세요...");
		frm.selfemail.focus();
		return ;
	}
	if( frm.txEmail2.value == "etc"){
		email = frm.txEmail1.value + '@' + frm.selfemail.value;
	}else if( frm.txEmail2.value == "" && frm.selfemail.value.length>0 ){
		email = frm.txEmail1.value + '@' + frm.selfemail.value;
	}else{
		email = frm.txEmail1.value + '@' + frm.txEmail2.value;
	}

	if (email == ''){
		return;
	}else if (!check_form_email(email)){
		alert("이메일 주소가 유효하지 않습니다.");
		frm.txEmail1.focus();
		return ;
	}
	return email;
}

// 휴대폰 입력 확인
function chkPhoneForm(frm) {
	var phone;

	if (jsChkBlank(frm.usercell2.value)||frm.usercell2.value.length<3){
		alert("휴대전화 번호를 입력해주세요");
		frm.usercell2.focus();
		return ;
	}
	if (jsChkBlank(frm.usercell3.value)||frm.usercell3.value.length<4){
		alert("휴대전화 번호를 입력해주세요");
		frm.usercell3.focus();
		return ;
	}
	if (!jsChkNumber(frm.usercell2.value) || !jsChkNumber(frm.usercell3.value)){
		alert("휴대전화 번호는 공백없는 숫자로 입력해주세요.");
		frm.usercell2.focus();
		return ;
	}

	phone = frm.usercell1.value+"-"+frm.usercell2.value+"-"+frm.usercell3.value
	return phone;
}

// 인증값 변경 확인
function chkChangeAuth(frm,dv) {
	switch(dv) {
		case "E" :
			if(frm.isEmailChk.value=="Y") {
				var email;
				if( frm.txEmail2.value == "etc"){
					email = frm.txEmail1.value + '@' + frm.selfemail.value;
				}else{
					email = frm.txEmail1.value + frm.txEmail2.value;
				}

				if(frm.orgUsermail.value!=email) {
					$("#lyrMailAuthMsg").html("[인증대기]");
				} else {
					$("#lyrMailAuthMsg").html("[인증완료]");
				}
			}
			break;
		case "P" :
			if(frm.isMobileChk.value=="Y") {
				if(frm.orgUsercell.value!=(frm.usercell1.value+"-"+frm.usercell2.value+"-"+frm.usercell3.value)) {
					$("#lyrPhoneAuthMsg").html("[인증대기]");
				} else {
					$("#lyrPhoneAuthMsg").html("[인증완료]");
				}
			}
			break;
	}
}

$(function(){
	// 이메일 기본 선택 처리
	if(document.frminfo.selfemail.value!="") {
		document.frminfo.txEmail2.value = '@' + document.frminfo.selfemail.value;
		if(document.frminfo.txEmail2.selectedIndex<0){
			document.frminfo.txEmail2.value = 'etc';
		}
	}
	NewEmailChecker();
});

function fnPopSNSLogin(snsgb) {
	var popup = window.open("/login/mainsnslogin.asp?snsdiv="+snsgb+"&pggb=my","","width=600, height=800");
}

function fnSNSdisconnect(snsgb) {
	if(!snsgb){
		alert('정상적인 경로로 접속해 주세요.');
		window.location.reload(true);
	}else{
		$.ajax({
			type: "POST",
			url: "/login/snsloginprocess.asp",
			data: "mode=disc&snsgubun="+snsgb,
			dataType: "json",
			async: false,
	       	success: function (responseText, statusText) {
				if(responseText.response=="Disc") {
					alert("계정 연결 해제가 완료되었습니다");
					window.location.reload(true);
				}else if(responseText.response=="fail") {
					alert(responseText.faildesc);
				}else{
					alert("처리중 오류가 발생했습니다.\n" + responseText);
				}
			},
			//ajax error
			error: function(err){
				alert("ERR: " + err.responseText);
			}
		});
	}
}

</script>
<style>
.sticker {display:inline-block; position:relative; padding:6px 10px 4px 10px; background-color:rgba(255,255,0,0.5); }
.sticker:after {position:absolute; left:100%; top:0; width:0; height:0; border-top:22px solid rgba(255,255,0,0.5); border-right:5px solid transparent; content:'';}
</style>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content myInfoMod bgGry" id="contentArea">
				<div class="inner5">
					<div class="tab01 tMar15">
						<ul class="tabNav tNum2 noMove">
							<li class="current"><a href="/my10x10/userinfo/membermodify.asp">개인정보관리<span></span></a></li>
						</ul>
						<div class="tabContainer">
							<!-- 나의 정보 관리 -->
							<div class="tabContent">
								<div class="box1">
								<form name="frminfo" method="post" action="<%=M_SSLUrl%>/biz/membermodify_process.asp" style="margin:0px;" onsubmit="return false;">
								<input type="hidden" name="mode" value="infomodi">
								<input type="hidden" name="isEmailChk" value="<%= chkIIF(BizUserInfo.FIsEmailChk="Y", "Y", "N") %>">
								<input type="hidden" name="isMobileChk" value="<%= chkIIF(BizUserInfo.FIsMobileChk="Y", "Y", "N") %>">
									<div class="writeInfo">
										<h3>회원 기본 정보</h3>
										<% ''간편로그인수정;허진원 2018.04.24 - 필수표시 %>
										<table class="writeTbl01 addEss">
											<colgroup>
												<col width="19%" />
												<col width="" />
											</colgroup>
											<tbody>
												<tr>
													<% ''간편로그인수정;허진원 2018.04.24 - 필수표시 %>
													<th class="ess"><p class="sticker"><span>*</span>이름</p></th>
													<td><input type="text" name="username" value="<%= BizUserInfo.FUserName %>" class="w100p" /></td>
												</tr>
												<tr>
													<% ''간편로그인수정;허진원 2018.04.24 - 필수표시 제거 %>
													<th>주소</th>
													<td>
														<p>
															<input type="text" name="txZip" id="txZip" value="<%= BizUserInfo.Fzipcode %>" maxlength="5" readonly maxlength="5" class="w25p" />
															<span class="button btB2 btGry cBk1 lMar05"><a href="" onclick="searchZipKakao('searchZipWrap','frminfo'); return false;">우편번호 검색</a></span>
														</p>
														<p id="searchZipWrap" style="display:none;border:1px solid;width:100%;height:300px;margin:5px 0;position:relative">
															<img src="//fiximage.10x10.co.kr/m/2019/common/btn_delete.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-36px;z-index:1;width:35px;height:35px;" onclick="foldDaumPostcode('searchZipWrap')" alt="접기 버튼">
														</p>
														<style>
															.inp-box {display:block; padding:0.4rem 0.6rem; font-size:13px; color:#888; border-radius:0.2rem; border:1px solid #cbcbcb; width:100%;}
														</style>										
														<p class="tPad05">
															<textarea name="txAddr1" title="주소" ReadOnly class="inp-box" ><%= BizUserInfo.FAddress1 %></textarea>
														</p>															
														<p class="tPad05">
															<input type="text" name="txAddr2" value="<%= BizUserInfo.FAddress2 %>" class="w100p" />
														</p>
														<p class="tPad05 cGy1 lh12">기본 배송 주소는 상품배송이나 이벤트경품 등의 배송에 사용되므로 정확히 입력해주세요.</p>
													</td>
												</tr>
												<tr>
													<th>전화</th>
													<td>
														<input type="tel" name="userphone1" pattern="[0-9]*" value="<%= SplitValue(BizUserInfo.Fuserphone,"-",0) %>" onkeyup="TnTabNumber('userphone1','userphone2',3);" maxlength="4" class="w30p" />
														<input type="tel" name="userphone2" pattern="[0-9]*" value="<%= SplitValue(BizUserInfo.Fuserphone,"-",1) %>" onkeyup="TnTabNumber('userphone2','userphone3',4);" maxlength="4" class="w30p lMar05" />
														<input type="tel" name="userphone3" pattern="[0-9]*" value="<%= SplitValue(BizUserInfo.Fuserphone,"-",2) %>" maxlength="4" class="w30p lMar05" />
													</td>
												</tr>
											</tbody>
										</table>

										<h3>이메일/휴대폰</h3>
										<table class="writeTbl01 addEss">
											<colgroup>
												<col width="20%" />
												<col width="" />
											</colgroup>
											<tbody>
												<tr>
													<% ''간편로그인수정;허진원 2018.04.24 - 필수표시 %>
													<th class="ess"><p class="sticker"><span>*</span>이메일</p></th>
													<td>
														<!-- for dev msg : 4/28 email -->
														<div class="emailField">
															<input type="hidden" name="orgUsermail" value="<%= BizUserInfo.FUsermail %>">
															<input type="hidden" name="usermail" value="<%= BizUserInfo.FUsermail %>">
	
															<input type="email" name="txEmail1" value="<%=BizUserInfo.FPreUserMail%>" onkeyup="chkChangeAuth(this.form,'E');" maxlength="32" title="이메일 계정" class="emailAccount" />
															<span class="symbol">@</span>
															<% call DrawEamilBoxHTML_m("document.frminfo","selfemail","txEmail2",BizUserInfo.FUserMailSite,"emailService",""," onkeyup=""chkChangeAuth(this.form,'E');"" title='이메일 서비스'"," onchange=""jsShowMailBox('document.frminfo','txEmail2','selfemail'); chkChangeAuth(this.form,'E');"" title='이메일 서비스 선택'") %>
														</div>

														<div class="overHidden tPad10">
															<p id="lyrMailAuthMsg" class="ftLt fs12 tPad10">[<%=chkIIF(BizUserInfo.FisEmailChk="Y","인증완료","인증대기")%>]</p>
															<p class="ftRt"><span class="button btB2 btGry cBk1 lMar05"><a href="" onclick="sendCnfEmail(document.frminfo); return false;">이메일 인증하기</a></span></p>
														</div>
													</td>
												</tr>
												<tr>
													<th class="ess"><p class="sticker"><span>*</span>휴대폰</p></th>
													<td>
														<input type="hidden" name="orgUsercell" value="<%= BizUserInfo.Fusercell %>">
														<input type="tel" name="usercell1" value="<%= SplitValue(BizUserInfo.Fusercell,"-",0) %>" onkeyup="TnTabNumber('usercell1','usercell2',3); chkChangeAuth(this.form,'P');" pattern="[0-9]*" maxlength="4" maxlength="3" class="w30p" />
														<input type="tel" name="usercell2" value="<%= SplitValue(BizUserInfo.Fusercell,"-",1) %>" onkeyup="TnTabNumber('usercell2','usercell3',4); chkChangeAuth(this.form,'P');" pattern="[0-9]*" maxlength="4" maxlength="4" class="w30p lMar05" />
														<input type="tel" name="usercell3" value="<%= SplitValue(BizUserInfo.Fusercell,"-",2) %>" onkeyup="chkChangeAuth(this.form,'P');" pattern="[0-9]*" maxlength="4" maxlength="4" class="w30p lMar05" />

														<div class="overHidden tPad10">
															<p id="lyrPhoneAuthMsg" class="ftLt fs12 tPad10">[<%=chkIIF(BizUserInfo.FisMobileChk="Y","인증완료","인증대기")%>]</p>
															<p class="ftRt"><span class="button btB2 btGry cBk1 lMar05"><a href="" onclick="sendCnfSMS(document.frminfo); return false;">휴대폰 인증하기</a></span></p>
														</div>
													</td>
												</tr>
											</tbody>
										</table>
										<p class="tip"><em class="cRd1">본인확인을 위해 정확한 휴대폰 번호를 입력해주세요.</em> (입력된 이메일, 휴대폰 번호는 아이디 찾기, 비밀번호 재발급시 이용됩니다)<br />이메일, 휴대전화 수정은 [인증하기]를 통해서만 수정할 수 있습니다.</p>
										<h3>수신동의</h3>
										<div class="agrReceive">
											<div class="agrCont">
												<div class="overHidden">

													<input type="hidden" name="email_10x10" id="email_10x10">
													<input type="hidden" name="email_way2way" id="email_way2way" value="N">
													<p class="ftLt" style="width:50%"><input type="checkbox" name="email_10x10check" <%= ChkIIF(BizUserInfo.FEmailOk="Y","checked","") %> value="Y" id="mTenten"> <label for="mTenten">이메일 수신동의</label></p>

													<input type="hidden" name="smsok" id="smsok">
													<input type="hidden" name="smsok_fingers" id="smsok_fingers"  value="N">
													<p class="ftLt" style="width:50%"><input type="checkbox" name="smsokcheck" <%= ChkIIF(BizUserInfo.FSmsOk="Y","checked","") %> value="Y" id="sTenten"> <label for="sTenten">SMS 수신동의</label></p>

												</div>
												<p class="tip tMar10">
													수신동의를 하시면 텐바이텐에서 제공하는 다양한 할인 혜택과 이벤트/신상품 등의 정보를 만나실 수 있습니다. <br><em class="cRd1">주문 및 배송관련 SMS는 수신동의와 상관없이 자동 발송합니다.</em>
												</p>
											</div>
										</div>
										<input type="hidden" name="allow_other" value="N">
										<table class="writeTbl01">
											<colgroup>
												<col width="28%" />
												<col width="" />
											</colgroup>
											<tbody>
												<tr>
													<th>비밀번호 확인</th>
													<td>
														<input type="password" name="oldpass" maxlength="32" onKeyPress="if (event.keyCode == 13) ChangeMyInfo(document.frminfo);" class="w100p" />
														<p class="tPad05 cGy1">정보를 수정하시려면 기존 비밀번호를 입력해주세요.</p>
													</td>
												</tr>
											</tbody>
										</table>
										<div class="btnWrap tMar25">
											<%''간편로그인수정;허진원 2018.04.24 - 링크 수정 %>
											<div class="ftLt w50p"><span class="button btB1 btRedBdr cRd1 w100p"><a href="/my10x10/mymain.asp">취소</a></span></div>
											<div class="ftRt w50p"><span class="button btB1 btRed cWh1 w100p"><a href="" onclick="ChangeMyInfo(document.frminfo); return false;">수정</a></span></div>
										</div>
									</div>
								</form>
								</div>
							</div>
							<!--// 나의 정보 관리 -->
						</div>
					</div>
					<div class="btn-member-leave">
						<a href="/my10x10/userinfo/withdrawal.asp"><span>회원 탈퇴</span></a>
					</div>
				</div>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
<form name="tranFrmApi" id="tranFrmApi" method="post">
	<input type="hidden" name="tzip" id="tzip">
	<input type="hidden" name="taddr1" id="taddr1">
	<input type="hidden" name="taddr2" id="taddr2">
	<input type="hidden" name="extraAddr" id="extraAddr">
</form>
</body>
</html>

<%
set BizUserInfo = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->