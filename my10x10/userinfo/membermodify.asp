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
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<!-- #include virtual="/offshop/lib/classes/offshopCls.asp" -->
<%
dim userid, userpass
userid = getEncLoginUserID
userpass = requestCheckVar(request.Form("userpass"),32)


'####### POINT1010 에서 넘어온건지 체크 #######
Dim pFlag, vParam
pFlag	= requestCheckVar(request("pflag"),1)
If pFlag = "o" Then
vParam	= "?pflag=o"
End If
If pFlag = "g" Then
	Response.Redirect "/offshop/point/point_search.asp"
	Response.End
End If
'####### POINT1010 에서 넘어온건지 체크 #######


''개인정보보호를 위해 패스워드로 한번더 Check
dim sqlStr, checkedPass, userdiv
dim Enc_userpass, Enc_userpass64
checkedPass = false

dim EcChk : EcChk = TenDec(request.Cookies("uinfo")("EcChk"))

if (LCase(Session("InfoConfirmFlag"))<>LCase(userid)) or (LCase(EcChk)<>LCase(userid)) then
    ''패스워드없이 쿠키로만 들어온경우
    if (userpass="") then
        response.redirect "/my10x10/userinfo/confirmuser.asp" & vParam
        response.end    
    end if
    
    Enc_userpass = MD5(CStr(userpass))
    Enc_userpass64 = SHA256(MD5(CStr(userpass)))
    
    ''비암호화
    ''sqlStr = "select userid, IsNULL(userdiv,'02') as userdiv from [db_user].[dbo].tbl_logindata where userid='" & userid & "' and userpass='" & userpass & "'"
    
    ''암호화 사용(MD5)
    ''sqlStr = "select userid, IsNULL(userdiv,'02') as userdiv from [db_user].[dbo].tbl_logindata where userid='" & userid & "' and Enc_userpass='" & Enc_userpass & "'"

    ''암호화 사용(SHA256)
    sqlStr = "select userid, IsNULL(userdiv,'02') as userdiv from [db_user].[dbo].tbl_logindata where userid='" & userid & "' and Enc_userpass64='" & Enc_userpass64 & "'"

    rsget.Open sqlStr, dbget, 1
    if Not rsget.Eof then
        checkedPass = true
        userdiv = rsget("userdiv")
    end if
    rsget.close
    
    ''패스워드올바르지 않음
    if (Not checkedPass) then
        response.redirect wwwUrl & "/my10x10/userinfo/confirmuser.asp?errcode=1" & Replace(vParam,"?","&") & ""
        response.end    
    end if
    
    ''업체인경우 수정 불가
    if (userdiv="02") or (userdiv="03") then
        response.write "<script>alert('업체 및 기타권한은 이곳에서 수정하실 수 없습니다.');</script>"
        response.end  
    end if
end if

'// 세션 체크 후에는 세션 삭제(새로고침 하면 다시 confirmuser 페이지로 이동함)
Session("InfoConfirmFlag") = ""

'// 세션이 유지되어 있고 쿠키가 있어도 텐바이텐을 통해서 접속하지 않으면 다시 confirm 페이지로 넘긴다.
If InStr(lcase(request.ServerVariables("HTTP_REFERER")),"10x10.co.kr")<1 Then
	response.redirect "/my10x10/userinfo/confirmuser.asp" & vParam
	response.end
End If

dim myUserInfo, chkKakao
chkKakao = false
set myUserInfo = new CUserInfo
myUserInfo.FRectUserID = userid
if (userid<>"") then
    myUserInfo.GetUserData 
    chkKakao = myUserInfo.chkKakaoAuthUser	'// 카카오톡 인증여부
end if

dim oAllowsite
dim IsAcademyUsing
IsAcademyUsing = false  ''Default True

set oAllowsite = new CUserInfo
oAllowsite.FRectUserID = userid
oAllowsite.FRectSitegubun = "academy"
if (userid<>"") then
    oAllowsite.GetOneAllowSite 
    
    if (oAllowsite.FOneItem.Fsiteusing="N") then IsAcademyUsing=false
end if

set oAllowsite = Nothing

Dim arrEmail, E1, E2
IF myUserInfo.FOneItem.FUsermail  <> "" THEN
	arrEmail = split(myUserInfo.FOneItem.FUsermail,"@")
	if ubound(arrEmail)>0 then
		E1	= arrEmail(0)
		E2	= arrEmail(1)
	end if
END IF	

if (myUserInfo.FResultCount<1) then
    response.write "<script>alert('정보를 가져올 수 없습니다.');</script>"
    response.end
end If

''간편로그인수정;허진원 2018.04.24
'SNS회원 여부
dim isSNSMember: isSNSMember = false
if GetLoginUserDiv="05" then
	isSNSMember = true
end if

strHeadTitleName = "개인정보관리"
%>
<!-- #include virtual="/lib/inc/head.asp" -->
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

	var issolar='';
	for (var i=0; i<frm.issolartemp.length; i++){
		if (frm.issolartemp[i].checked){
			issolar=frm.issolartemp[i].value;
		}
	}
	if (issolar==''){
		alert('생일이 양력인지 음력인지 선택해 주세요.');
		return false;
	}
	frm.issolar.value=issolar;
	if (frm.issolar.value==''){
		alert('생일이 양력인지 음력인지 선택해 주세요.');
		return false;
	}

	<% ''간편로그인수정;허진원 2018.04.24 - 생일입력검사 스크립트 제거%>

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

	<% if (IsAcademyUsing) then %>
		if (frm.allow_other[1].checked){
			alert('핑거스 아케데미 서비스를 이용하지않음 으로 설정하실 경우 \n핑거스 아카데미 로그인 및 관련 서비스를 이용하실 수 없습니다.');
		}
	<% end if %>

	if (frm.isEmailChk.value=="N"&&(frm.isMobileChk.value=="N"||frm.orgUsercell.value!=sHp)) {
		alert('이메일 또는 휴대전화 중 하나는 반드시 인증을 받으셔야 합니다.');
		return;
	}

	<%
		''간편로그인수정;허진원 2018.04.24
		if Not(isSNSMember) then
	%>
	if (frm.oldpass.value.length < 1){
		alert('정보를 변경 하시려면 기존 비밀번호를 입력해주세요.');
		frm.oldpass.focus();
		return;
	}
	<% end if %>

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

// 카카오톡 인증
function popKakaoAuth() {
	<% if Not(chkKakao) then %>
		//fnOpenModal('/apps/kakaotalk/step1.asp');
		var popKakaoAuth = window.open("/apps/kakaotalk/step1.asp","popKakaoAuth","width=530,height=680");
		popKakaoAuth.focus();
	<% else %>
		//fnOpenModal('/apps/kakaotalk/clear.asp');
		var popKakaoAuth = window.open("/apps/kakaotalk/clear.asp","popKakaoAuth","width=530,height=450");
		popKakaoAuth.focus();
	<% end if %>
	
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
		fnOpenModal('/my10x10/userinfo/ajaxSendModifyEmail.asp?id=<%= userid %>&mail=' + sEm);
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
		fnOpenModal('/my10x10/userinfo/ajaxSendModifySMS.asp?id=<%= userid %>&phone=' + sHp);
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
						<%
							''간편로그인수정;허진원 2018.04.24
							if Not(isSNSMember) then
						%>
							<li><a href="/my10x10/userinfo/memberUserPass.asp">비밀번호 변경<span></span></a></li>
						<%	end if %>
						</ul>
						<div class="tabContainer">
							<!-- 나의 정보 관리 -->
							<div class="tabContent">
								<div class="box1">
								<form name="frminfo" method="post" action="<%=M_SSLUrl%>/my10x10/userinfo/membermodify_process.asp" style="margin:0px;" onsubmit="return false;">
								<input type="hidden" name="mode" value="infomodi">
								<input type="hidden" name="pflag" value="<%=pFlag%>">
								<input type="hidden" name="isEmailChk" value="<%=chkIIF(myUserInfo.FOneItem.FisEmailChk="Y","Y","N")%>">
								<input type="hidden" name="isMobileChk" value="<%=chkIIF(myUserInfo.FOneItem.FisMobileChk="Y","Y","N")%>">
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
													<td><input type="text" name="username" value="<%= myUserInfo.FOneItem.FUserName %>" class="w100p" /></td>
												</tr>
												<tr>
													<% ''간편로그인수정;허진원 2018.04.24 - 필수 아이콘 제거 %>
													<th class="tPad05">생일</th>
													<td>
														<p class="bPad10">
															<input type="hidden" name="issolar" id="birthType" value="<% if myUserInfo.FOneItem.Fissolar<>"N" then %>Y<% else %>N<% end if %>">
															<span><input type="radio" name="issolartemp" value="Y" <% if myUserInfo.FOneItem.Fissolar<>"N" then response.write "checked" %> id="solar" /> <label for="solar" class="lMar05">양력</label></span>
															<span class="lMar30"><input type="radio" name="issolartemp" value="N" <% if myUserInfo.FOneItem.Fissolar="N" then response.write "checked" %> id="lunar" /> <label for="lunar" class="lMar05">음력</label></span>
														</p>
														<select name="userbirthday1" title="태어난 년도 선택" style="width:32%;">
															<option value="1900">선택</option>
															<%
															Dim yyyy,mm,dd
																For yyyy = year(now())-100 to year(now())-14
															%>
																<option value="<%=yyyy%>" <% If myUserInfo.FOneItem.FBirthDay<>"1900-01-01" and SplitValue(myUserInfo.FOneItem.FBirthDay,"-",0) = format00(4,yyyy) Then response.write "selected" %>><%=yyyy%></option>
															<% Next %>
														</select>
														<select name="userbirthday2" title="태어난 월 선택" class="w30p lMar05">
															<option value="1">선택</option>
															<% For mm = 1 to 12 %>
																<% If mm < 10 Then mm = Format00(2,mm) End If %>
																<option value="<%=mm%>" <% If myUserInfo.FOneItem.FBirthDay<>"1900-01-01" and SplitValue(myUserInfo.FOneItem.FBirthDay,"-",1) = format00(2,mm) Then response.write "selected" %>><%=mm%></option>
															<% Next %>
														</select>
														<select name="userbirthday3" title="태어난 일 선택" class="w30p lMar05">
															<option value="1">선택</option>
															<% For dd = 1 to 31%>
																<% If dd < 10 Then dd =Format00(2,dd) End If %>
																<option value="<%=dd%>" <% If myUserInfo.FOneItem.FBirthDay<>"1900-01-01" and SplitValue(myUserInfo.FOneItem.FBirthDay,"-",2) = format00(2,dd) Then response.write "selected" %>><%=dd%></option>
															<% Next %>
														</select>
														<% ''간편로그인수정;허진원 2018.04.24 - 여백조정 %>
														<p class="icoStar cRd1 tMar05 lh12 bPad10">등록된 생일에 생일 쿠폰을 선물로 드립니다.<br /><span>(생일 축하쿠폰은 연 1회 발급됩니다.)</span></p>
													</td>
												</tr>
												<% ''간편로그인수정;허진원 2018.04.24 - 성별 추가 %>
												<tr>
													<th class="tPad05">성별</th>
													<td>
														<span><input type="radio" name="gender" value="1" id="male" class="radio" <% if myUserInfo.FOneItem.Fgender="M" then response.write "checked" %> /> <label for="male" class="lMar05">남</label></span>
														<span class="lMar30"><input type="radio" name="gender" value="2" id="female" class="radio lMar10" <% if myUserInfo.FOneItem.Fgender="F" then response.write "checked" %> /> <label for="female" class="lMar05">여</label></span>
													</td>
												</tr>
												<tr>
													<% ''간편로그인수정;허진원 2018.04.24 - 필수표시 제거 %>
													<th>주소</th>
													<td>
														<p>
															<input type="text" name="txZip" id="txZip" value="<%= myUserInfo.FOneItem.Fzipcode %>" maxlength="5" readonly maxlength="5" class="w25p" />
															<span class="button btB2 btGry cBk1 lMar05"><a href="" onclick="searchZipKakao('searchZipWrap','frminfo'); return false;">우편번호 검색</a></span>
														</p>
														<p id="searchZipWrap" style="display:none;border:1px solid;width:100%;height:300px;margin:5px 0;position:relative">
															<img src="//fiximage.10x10.co.kr/m/2019/common/btn_delete.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-36px;z-index:1;width:35px;height:35px;" onclick="foldDaumPostcode('searchZipWrap')" alt="접기 버튼">
														</p>
														<style>
															.inp-box {display:block; padding:0.4rem 0.6rem; font-size:13px; color:#888; border-radius:0.2rem; border:1px solid #cbcbcb; width:100%;}
														</style>										
														<p class="tPad05">
															<textarea name="txAddr1" title="주소" ReadOnly class="inp-box" ><%= myUserInfo.FOneItem.FAddress1 %></textarea>
														</p>															
														<p class="tPad05">
															<input type="text" name="txAddr2" value="<%= myUserInfo.FOneItem.FAddress2 %>" class="w100p" />
														</p>
														<p class="tPad05 cGy1 lh12">기본 배송 주소는 상품배송이나 이벤트경품 등의 배송에 사용되므로 정확히 입력해주세요.</p>
													</td>
												</tr>
												<tr>
													<th>전화</th>
													<td>
														<input type="tel" name="userphone1" pattern="[0-9]*" value="<%= SplitValue(myUserInfo.FOneItem.Fuserphone,"-",0) %>" onkeyup="TnTabNumber('userphone1','userphone2',3);" maxlength="4" class="w30p" />
														<input type="tel" name="userphone2" pattern="[0-9]*" value="<%= SplitValue(myUserInfo.FOneItem.Fuserphone,"-",1) %>" onkeyup="TnTabNumber('userphone2','userphone3',4);" maxlength="4" class="w30p lMar05" />
														<input type="tel" name="userphone3" pattern="[0-9]*" value="<%= SplitValue(myUserInfo.FOneItem.Fuserphone,"-",2) %>" maxlength="4" class="w30p lMar05" />
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
															<input type="hidden" name="orgUsermail" value="<%= myUserInfo.FOneItem.FUsermail %>">
															<input type="hidden" name="usermail" value="<%= myUserInfo.FOneItem.FUsermail %>">
	
															<input type="email" name="txEmail1" value="<%= E1 %>" onkeyup="chkChangeAuth(this.form,'E');" maxlength="32" title="이메일 계정" class="emailAccount" />
															<span class="symbol">@</span>
															<% call DrawEamilBoxHTML_m("document.frminfo","selfemail","txEmail2",E2,"emailService",""," onkeyup=""chkChangeAuth(this.form,'E');"" title='이메일 서비스'"," onchange=""jsShowMailBox('document.frminfo','txEmail2','selfemail'); chkChangeAuth(this.form,'E');"" title='이메일 서비스 선택'") %>
														</div>

														<div class="overHidden tPad10">
															<p id="lyrMailAuthMsg" class="ftLt fs12 tPad10">[<%=chkIIF(myUserInfo.FOneItem.FisEmailChk="Y","인증완료","인증대기")%>]</p>
															<p class="ftRt"><span class="button btB2 btGry cBk1 lMar05"><a href="" onclick="sendCnfEmail(document.frminfo); return false;">이메일 인증하기</a></span></p>
														</div>
													</td>
												</tr>
												<tr>
													<th class="ess"><p class="sticker"><span>*</span>휴대폰</p></th>
													<td>
														<input type="hidden" name="orgUsercell" value="<%= myUserInfo.FOneItem.Fusercell %>">
														<input type="tel" name="usercell1" value="<%= SplitValue(myUserInfo.FOneItem.Fusercell,"-",0) %>" onkeyup="TnTabNumber('usercell1','usercell2',3); chkChangeAuth(this.form,'P');" pattern="[0-9]*" maxlength="4" maxlength="3" class="w30p" />
														<input type="tel" name="usercell2" value="<%= SplitValue(myUserInfo.FOneItem.Fusercell,"-",1) %>" onkeyup="TnTabNumber('usercell2','usercell3',4); chkChangeAuth(this.form,'P');" pattern="[0-9]*" maxlength="4" maxlength="4" class="w30p lMar05" />
														<input type="tel" name="usercell3" value="<%= SplitValue(myUserInfo.FOneItem.Fusercell,"-",2) %>" onkeyup="chkChangeAuth(this.form,'P');" pattern="[0-9]*" maxlength="4" maxlength="4" class="w30p lMar05" />

														<div class="overHidden tPad10">
															<p id="lyrPhoneAuthMsg" class="ftLt fs12 tPad10">[<%=chkIIF(myUserInfo.FOneItem.FisMobileChk="Y","인증완료","인증대기")%>]</p>
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
													<p class="ftLt" style="width:50%"><input type="checkbox" name="email_10x10check" <%= ChkIIF(myUserInfo.FOneItem.Femail_10x10="Y","checked","") %> value="Y" id="mTenten"> <label for="mTenten">이메일 수신동의</label></p>

													<input type="hidden" name="smsok" id="smsok">
													<input type="hidden" name="smsok_fingers" id="smsok_fingers"  value="N">
													<p class="ftLt" style="width:50%"><input type="checkbox" name="smsokcheck" <%= ChkIIF(myUserInfo.FOneItem.Fsmsok="Y","checked","") %> value="Y" id="sTenten"> <label for="sTenten">SMS 수신동의</label></p>

												</div>
												<p class="tip tMar10">
													수신동의를 하시면 텐바이텐에서 제공하는 다양한 할인 혜택과 이벤트/신상품 등의 정보를 만나실 수 있습니다. <br><em class="cRd1">주문 및 배송관련 SMS는 수신동의와 상관없이 자동 발송합니다.</em>
													<!--<% if date>"2015-12-31" then %>
													<em class="cRd1"><br /><br />※ 카카오톡 맞춤정보 서비스는 2015년 12월 31일부로 종료되었습니다.</em>
													<% end if %>-->
												</p>

												<% if date<="2015-12-31" then %>
												<dl class="kakao">
													<dt>카카오톡 맞춤정보 수신동의</dt>
													<dd>
														<%
														'// 카카오톡 인증 //
														if Not(chkKakao) then
														%>
															<span class="button btB1 w100p"><a href="" onclick="popKakaoAuth(); return false;">카카오톡 인증하기</a></span>
														<% else %>
															<span class="button btB1 w100p"><a href="" onclick="popKakaoAuth(); return false;">서비스 해제 및 수정</a></span>
														<% end if %>
													</dd>
												</dl>
												<p class="tip">
													<!--카카오톡 맞춤정보 서비스는 주문 및 배송 관련 메시지 및 다양한 혜택과 이벤트에 대한 정보를 SMS 대신 카카오톡으로 발송해드리는 서비스입니 다. 본 서비스는 스마트폰에 카카오톡이 설치되어 있어야 이용이 가능합 니다. 카카오톡이 설치 되어 있지 않다면 설치 후 이용해주시기 바랍니다.-->
													카카오톡 맞춤정보 서비스는 <em class="cRd1">2015년 12월 31일부로 종료</em>됩니다.<br />카카오톡으로 발송 드렸던 주문 및 배송 관련 메시지는 SMS로 발송 드릴 예정이오니, 이용에 참고 부탁드립니다.
												</p>
												<% end if %>
											</div>
										</div>

										<input type="hidden" name="allow_other" value="N">
										<!--  2017.10.1 서비스 종료
										<h3>이용 사이트 관리</h3>
										<dl class="fingers">
											<dt>더핑거스 www.thefingers.co.kr</dt>
											<dd>
												<p><input type="radio" name="allow_other" value="Y" <%= chkIIF(IsAcademyUsing,"checked","") %> onClick="checkSiteComp(this);" id="useY" /> <label for="useY">이용함</label></p>
												<p><input type="radio" name="allow_other" value="N" <%= chkIIF(IsAcademyUsing,"","checked") %> onClick="checkSiteComp(this);" id="useN" /> <label for="useN">이용하지 않음</label></p>
											</dd>
										</dl>
										-->

									<%
										''간편로그인수정;허진원 2018.04.24
										if Not(isSNSMember) then
									%>
										<!-- 소셜로그인/회원가입/정보수정/ 탈퇴 등 전반 -->
										<!-- for dev msg : SNS 연동관리, SNS당 한 계정씩만 연결 가능 -->
										<!-- SNS 연동관리 추가 -->
										<%
										dim mynvsnsgubun, mynvsnsregdate, myfbsnsgubun, myfbsnsregdate, mykasnsgubun, mykasnsregdate, myglsnsgubun, myglsnsregdate
										sqlstr = "select top 4 " + vbcrlf
										sqlstr = sqlstr & "   'nv' as nvsnsgubun, (select top 1 regdate From [db_user].[dbo].[tbl_user_sns] Where tenbytenid='"& userid &"' And snsgubun='nv' And isusing='Y') as nvregdate " + vbcrlf
										sqlstr = sqlstr & " , 'fb' as fbsnsgubun, (select top 1 regdate From [db_user].[dbo].[tbl_user_sns] Where tenbytenid='"& userid &"' And snsgubun='fb' And isusing='Y') as fbregdate " + vbcrlf
										sqlstr = sqlstr & " , 'ka' as kasnsgubun, (select top 1 regdate From [db_user].[dbo].[tbl_user_sns] Where tenbytenid='"& userid &"' And snsgubun='ka' And isusing='Y') as karegdate " + vbcrlf
										sqlstr = sqlstr & " , 'gl' as glsnsgubun, (select top 1 regdate From [db_user].[dbo].[tbl_user_sns] Where tenbytenid='"& userid &"' And snsgubun='gl' And isusing='Y') as glregdate " + vbcrlf
										sqlstr = sqlstr & " From [db_user].[dbo].[tbl_user_sns] " + vbcrlf
										sqlstr = sqlstr & " Where tenbytenid='"& userid &"' And isusing='Y' "
										rsget.CursorLocation = adUseClient
										rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
										if Not rsget.Eof then
											mynvsnsgubun = rsget("nvsnsgubun")
											mynvsnsregdate = rsget("nvregdate")
											myfbsnsgubun = rsget("fbsnsgubun")
											myfbsnsregdate = rsget("fbregdate")
											mykasnsgubun = rsget("kasnsgubun")
											mykasnsregdate = rsget("karegdate")
											myglsnsgubun = rsget("glsnsgubun")
											myglsnsregdate = rsget("glregdate")
										end if
										rsget.close
										%>
										<h3>SNS 연동관리</h3>
										<div class="connectSns">
											<ul>
												<li>
													<div class="icon btnKakao"></div>카카오톡
													<div class="switch">
														<% if mykasnsgubun = "ka" and mykasnsregdate <> "" then %>
															<input type="checkbox" id="connect03" onclick="fnSNSdisconnect('ka');return false;" class="toggle toggle-red" checked="checked"><label for="connect03"><span>켬</span></label>
														<% else %>
															<input type="checkbox" id="connect03" onclick="fnPopSNSLogin('ka');return false;" class="toggle toggle-red"><label for="connect03"><span>끔</span></label>
														<% end if %>
													</div>
												</li>

												<li>
													<div class="icon btnNaver"></div>네이버
													<div class="switch">
														<% if mynvsnsgubun = "nv" and mynvsnsregdate <> "" then %>
															<input type="checkbox" id="connect02" onclick="fnSNSdisconnect('nv');return false;" class="toggle toggle-red" checked="checked"><label for="connect02"><span>켬</span></label>
														<% else %>
															<input type="checkbox" id="connect02" onclick="fnPopSNSLogin('nv');return false;" class="toggle toggle-red"><label for="connect02"><span>끔</span></label>
														<% end if %>
													</div>
												</li>

												<li>
													<div class="icon btnFacebook"></div>페이스북
													<div class="switch">
														<% if myfbsnsgubun = "fb" and myfbsnsregdate <> "" then %>
															<input type="checkbox" id="connect01" onclick="fnSNSdisconnect('fb');return false;" class="toggle toggle-red" checked="checked"><label for="connect01"><span>켬</span></label>
														<% else %>
															<input type="checkbox" id="connect01" onclick="fnPopSNSLogin('fb');return false;" class="toggle toggle-red"><label for="connect01"><span>끔</span></label>
														<% end if %>
													</div>
												</li>

												<li>
													<div class="icon btnGoogle"></div>구글
													<div class="switch">
														<% if myglsnsgubun = "gl" and myglsnsregdate <> "" then %>
															<input type="checkbox" id="connect04" onclick="fnSNSdisconnect('gl');return false;" class="toggle toggle-red" checked="checked"><label for="connect04"><span>켬</span></label>
														<% else %>
															<input type="checkbox" id="connect04" onclick="fnPopSNSLogin('gl');return false;" class="toggle toggle-red"><label for="connect04"><span>끔</span></label>
														<% end if %>
													</div>
												</li>
											</ul>
										</div>

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
									<% end if %>

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
set myUserInfo = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->