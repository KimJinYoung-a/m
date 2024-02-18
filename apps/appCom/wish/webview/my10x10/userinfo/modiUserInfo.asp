<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
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
<!-- #include virtual="/apps/appcom/wish/webview/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/lib/util/commlib.asp" -->
<%
dim userid, userpass
	userid = getEncLoginUserID

''개인정보보호를 위해 패스워드로 한번더 Check
dim sqlStr, checkedPass, userdiv
dim Enc_userpass, Enc_userpass64
checkedPass = false

dim EcChk : EcChk = TenDec(request.Cookies("uinfo")("EcChk"))

if (LCase(Session("InfoConfirmFlag"))<>LCase(userid)) and (LCase(EcChk)<>LCase(userid)) then
    ''패스워드없이 쿠키로만 들어온경우
    if (userpass="") then
        response.redirect "confirmuser.asp"
        response.end    
    end if
    
    Enc_userpass = MD5(CStr(userpass))
    Enc_userpass64 = SHA256(MD5(CStr(userpass)))
    
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
        response.redirect wwwUrl & "confirmuser.asp?errcode=1"
        response.end    
    end if
    
    ''업체인경우 수정 불가
    if (userdiv="02") or (userdiv="03") then
        response.write "<script>alert('업체 및 기타권한은 이곳에서 수정하실 수 없습니다.');</script>"
        response.end  
    end if
    Session("InfoConfirmFlag") = userid
end if

dim myUserInfo, chkKakao
	chkKakao = false
set myUserInfo = new CUserInfo
	myUserInfo.FRectUserID = userid
	
	if (userid<>"") then
	    myUserInfo.GetUserData 
	    chkKakao = myUserInfo.chkKakaoAuthUser	'// 카카오톡 인증여부
	end if

dim oAllowsite, IsAcademyUsing
	IsAcademyUsing = true  ''Default True

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
end if
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script language='javascript'>

function ChangeMyInfo(frm){	
	if (frm.username.value.length<2){
		alert('이름을 입력해 주세요.');
		frm.username.focus();
		return;
	}
	if (frm.txZip1.value.length<3){
		alert('우편번호를 입력해 주세요.');
		frm.txZip1.focus();
		return;
	}
	if (frm.txAddr2.value.length<1){
		alert('나머지 주소를 입력해 주세요.');
		frm.txAddr2.focus();
		return;
	}
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

	if (frm.userbirthday1.value.length!=4){
		alert('생년월일을 정확히 입력해주세요.');
		frm.userbirthday1.focus();
		return;
	}
	if (jsChkBlank(frm.userbirthday1.value) || jsChkBlank(frm.userbirthday1.value)){
		alert("생년월일을 정확히 입력해주세요");
		frm.userbirthday1.focus();
		return ;
	}
	if (!jsChkNumber(frm.userbirthday1.value) || !jsChkNumber(frm.userbirthday1.value)){
		alert("생년월일을 정확히 입력해주세요");
		frm.userbirthday1.focus();
		return ;
	}
	if (frm.userbirthday2.value.length!=2){
		alert('생년월일을 정확히 입력해주세요.');
		frm.userbirthday2.focus();
		return;
	}
	if (jsChkBlank(frm.userbirthday2.value) || jsChkBlank(frm.userbirthday2.value)){
		alert("생년월일을 정확히 입력해주세요");
		frm.userbirthday2.focus();
		return ;
	}
	if (!jsChkNumber(frm.userbirthday2.value) || !jsChkNumber(frm.userbirthday2.value)){
		alert("생년월일을 정확히 입력해주세요");
		frm.userbirthday2.focus();
		return ;
	}
	if (frm.userbirthday3.value.length!=2){
		alert('생년월일을 정확히 입력해주세요.');
		frm.userbirthday3.focus();
		return;
	}
	if (jsChkBlank(frm.userbirthday3.value) || jsChkBlank(frm.userbirthday3.value)){
		alert("생년월일을 정확히 입력해주세요");
		frm.userbirthday3.focus();
		return ;
	}
	if (!jsChkNumber(frm.userbirthday3.value) || !jsChkNumber(frm.userbirthday3.value)){
		alert("생년월일을 정확히 입력해주세요");
		frm.userbirthday3.focus();
		return ;
	}

	if (frm.email_10x10check.checked){
		frm.email_10x10.value="Y";
	}else{
		frm.email_10x10.value="N";
	}
	if (frm.email_way2waycheck.checked){
		frm.email_way2way.value="Y";
	}else{
		frm.email_way2way.value="N";
	}
	if (frm.smsokcheck.checked){
		frm.smsok.value="Y";
	}else{
		frm.smsok.value="N";
	}
	if (frm.smsok_fingerscheck.checked){
		frm.smsok_fingers.value="Y";
	}else{
		frm.smsok_fingers.value="N";
	}
	
	var tmpallow_other='';
	if ( $("#allow_otherY").hasClass('active') ){
		tmpallow_other=$("#allow_otherY").val()
	}
	if ( $("#allow_otherN").hasClass('active') ){
		tmpallow_other=$("#allow_otherN").val()
	}
	if (tmpallow_other==''){
		alert("핑거스 아카데미 이용여부를 선택해 주세요.");
		return ;
	}
	frm.allow_other.value=tmpallow_other;
	
	<% if (IsAcademyUsing) then %>
	if (frm.allow_other.value=='N'){
		alert('핑거스 아케데미 서비스를 이용하지않음 으로 설정하실 경우 \n핑거스 아카데미 로그인 및 관련 서비스를 이용하실 수 없습니다.');
	}
	<% end if %>

	if (frm.isEmailChk.value=="N"&&(frm.isMobileChk.value=="N"||frm.orgUsercell.value!=sHp)) {
		alert('이메일 또는 휴대전화 중 하나는 반드시 인증을 받으셔야 합니다.');
		return;
	}
	if (frm.oldpass.value.length < 1){
		jsOpenModal("pop_ConfirmPass.asp?target=frminfo")
		return;
	}

	var ret = confirm('정보를 수정 하시겠습니까?');
	if (ret){
		frm.submit();
	}
}

function checkSiteComp(comp){
	var frm = comp.form;
	
	if (comp.value=="Y"){
		frm.email_way2way[0].disabled = false;
		frm.email_way2way[1].disabled = false;
		frm.smsok_fingers[0].disabled = false;
		frm.smsok_fingers[1].disabled = false;
	}else{
		frm.email_way2way[1].checked = true;
		frm.email_way2way[0].disabled = true;
		frm.email_way2way[1].disabled = true;
		frm.smsok_fingers[1].checked = true;
		frm.smsok_fingers[0].disabled = true;
		frm.smsok_fingers[1].disabled = true;
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

// 카카오톡 인증
function popKakaoAuth() {
	<% if Not(chkKakao) then %>
		jsOpenModal("/apps/appCom/wish/webview/my10x10/kakaotalk/pop_step1.asp")
		return;
	<% else %>
		jsOpenModal("/apps/appCom/wish/webview/my10x10/kakaotalk/pop_clear.asp")
		return;
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
		jsOpenModal("pop_sendModiemail.asp?id=<%=userid%>&mail="+sEm)
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
		jsOpenModal("pop_sendModiSMS.asp?id=<%=userid%>&phone="+sHp)
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
	if( frm.txEmail2.value == "etc" ){
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
				if(frm.orgUsercell.value!=(frm.usercell1.value+"-"+frm.usercell2.value)) {
					$("#lyrPhoneAuthMsg").html("[인증대기]");
				} else {
					$("#lyrPhoneAuthMsg").html("[인증완료]");
				}
			}
			break;
	}
}

//주소찾기
function searchzipBuyer(tmpurl){
	jsOpenModal(tmpurl);
}

</script>
	
</head>
<body class="mypage">
    <!-- wrapper -->
    <div class="wrapper myinfo">
        <!-- #header -->
        <header id="header">
            <div class="tabs type-c">
                <a href="modiUserInfo.asp" class="active">나의 정보 관리</a>
                <a href="modiUserPass.asp">비밀번호 변경</a>
            </div>
        </header><!-- #header -->
        <!-- #content -->
        <div id="content">
            <div class="inner">
				<form name="frminfo" method="post" action="<%=M_SSLUrl%>/apps/appcom/wish/webview/my10x10/userinfo/membermodify_process.asp" style="margin:0px;" onsubmit="return false;">
				<input type="hidden" name="oldpass">
				<input type="hidden" name="mode" value="infomodi">
				<input type="hidden" name="isEmailChk" value="<%=chkIIF(myUserInfo.FOneItem.FisEmailChk="Y","Y","N")%>">
				<input type="hidden" name="isMobileChk" value="<%=chkIIF(myUserInfo.FOneItem.FisMobileChk="Y","Y","N")%>">
                <div class="main-title">
                    <h1 class="title"><span class="label">회원 기본 정보</span></h1>
                </div>
                <div class="input-block">
                    <label for="name" class="input-label">이름</label>
                    <div class="input-controls">
                        <input type="text" id="name" name="username" value="<%= myUserInfo.FOneItem.FUserName %>" class="form full-size">
                    </div>
                </div>
                <div class="input-block">
                    <label for="birth" class="input-label">생년월일</label>
                    <div class="input-controls phone">
						<div><input type="tel" name="userbirthday1" value="<%= SplitValue(myUserInfo.FOneItem.FBirthDay,"-",0) %>" pattern="[0-9]*" id="birth1" class="form" maxlength="4"></div>
                        <div><input type="tel" name="userbirthday2" value="<%= SplitValue(myUserInfo.FOneItem.FBirthDay,"-",1) %>" pattern="[0-9]*" id="birth2" class="form" maxlength="2"></div>
                        <div><input type="tel" name="userbirthday3" value="<%= SplitValue(myUserInfo.FOneItem.FBirthDay,"-",2) %>" pattern="[0-9]*" id="birth3" class="form" maxlength="2"></div>                       
                    </div>
                </div>                
                <div class="toggle form small">
                    <button value="Y" class="<% if myUserInfo.FOneItem.Fissolar="Y" then response.write "active" %>" id="solar"><span class="label">양력</span></button>
                    <button value="N" class="<% if myUserInfo.FOneItem.Fissolar="N" then response.write "active" %>" id="lunar"><span class="label">음력</span></button>
                    <input type="hidden" name="issolar" id="birthType" value="Y">
                </div>
                <div class="clear"></div>
                <em class="em">* 등록된 생일 1주일 전 생일 축하쿠폰을 선물로 드립니다.</em>
				<%
					Dim txZip1, txZip2
					if Not(isNull(myUserInfo.FOneItem.Fzipcode)) then
						if ubound(split(myUserInfo.FOneItem.Fzipcode,"-"))>0 then
							txZip1 = Trim(split(myUserInfo.FOneItem.Fzipcode,"-")(0))
							txZip2 = Trim(split(myUserInfo.FOneItem.Fzipcode,"-")(1))
						end if
					end if
				%>                
                <div class="input-block">
                    <label for="zipcode" class="input-label">주소</label>
                    <div class="input-controls zipcode">
                        <div><input type="text" name="txZip1" value="<%= txZip1 %>" id="zipcode1" class="form full-size" maxlength="3"></div>
                        <div><input type="text" name="txZip2" value="<%= txZip2 %>" id="zipcode2" class="form full-size" maxlength="3" value="123"></div>
                        <button onclick="searchzipBuyer('/apps/appcom/wish/webview/lib/layer_searchzipNew.asp?strMode=userinfo&target=frminfo');" class="btn type-c btn-findzipcode side-btn">우편번호검색</button>
                    </div>
                </div>				
                <div class="input-block no-label">
                    <label for="address1" class="input-label">주소2</label>
                    <div class="input-controls disabled">
                        <input type="text" name="txAddr1" value="<%= myUserInfo.FOneItem.FAddress1 %>" readonly id="address1" class="form full-size" >
                    </div>
                </div>
                <div class="input-block no-label">
                    <label for="address2" class="input-label">주소3</label>
                    <div class="input-controls">
                        <input type="text" name="txAddr2" value="<%= myUserInfo.FOneItem.FAddress2 %>" id="address2" class="form full-size">
                    </div>
                </div>
                <em class="em">* 기본배송시 주소는 상품배송이나 이벤트경품 등의 배송에 사용되므로 정확히 입력해 주세요.</em>
                <div class="main-title">
                    <h2 class="title"><span class="label">이메일/휴대폰</span></h2>
                </div>
                <p>이메일 주소 및 휴대폰 번호는 본인인증 및 아이디 찾기, 비밀번호 재발급시 이용되는 정보이므로 정확하게 입력하여 주세요. 아직 인증대기상태이신 경우 이메일 또는 휴대폰으로 사용자 인증을 해주세요. 본인확인 용도로 사용됩니다. </p>
                <div class="diff-10"></div>
				<input type="hidden" name="orgUsermail" value="<%= myUserInfo.FOneItem.FUsermail %>">
				<input type="hidden" name="usermail" value="<%= myUserInfo.FOneItem.FUsermail %>">
                <div class="input-block email-block">
                    <label for="email" class="input-label">이메일</label>
                    <div class="input-controls email-type-b">
						<input type="text" id="email1" name="txEmail1" value="<%= E1 %>" onkeyup="chkChangeAuth(this.form,'E');" maxlength="32" class="form">
                        @
                        <% call DrawEamilBoxHTML_App("document.frminfo","selfemail","txEmail2",E2,"form","form bordered"," onkeyup=""chkChangeAuth(this.form,'E');"""," onchange=""jsShowMailBox('document.frminfo','txEmail2','selfemail'); chkChangeAuth(this.form,'E');""") %>
					</div>
                </div>
                <div class="auth-area">
                    <span id="lyrMailAuthMsg" class="pull-left">[<%=chkIIF(myUserInfo.FOneItem.FisEmailChk="Y","인증완료","인증대기")%>]</span>
                    <button onclick="sendCnfEmail(document.frminfo);" class="btn type-d pull-right">이메일 인증하기</button>
                </div>
                <div class="clear"></div>
                <div class="input-block">
                    <label for="phone" class="input-label">휴대폰</label>
                    <div class="input-controls phone">
                    	<input type="hidden" name="orgUsercell" value="<%= myUserInfo.FOneItem.Fusercell %>">
						<input type="hidden" name="userphone1" value="<%= SplitValue(myUserInfo.FOneItem.Fuserphone,"-",0) %>" >
						<input type="hidden" name="userphone2" value="<%= SplitValue(myUserInfo.FOneItem.Fuserphone,"-",1) %>" >
						<input type="hidden" name="userphone3" value="<%= SplitValue(myUserInfo.FOneItem.Fuserphone,"-",2) %>" >
						                    
                        <div><input type="tel" name="usercell1" value="<%= SplitValue(myUserInfo.FOneItem.Fusercell,"-",0) %>" onkeyup="TnTabNumber('usercell1','usercell2',3); chkChangeAuth(this.form,'P');" pattern="[0-9]*" id="phone1" class="form" maxlength="4"></div>
                        <div><input type="tel" name="usercell2" value="<%= SplitValue(myUserInfo.FOneItem.Fusercell,"-",1) %>" onkeyup="TnTabNumber('usercell2','usercell3',4); chkChangeAuth(this.form,'P');" pattern="[0-9]*" id="phone2" class="form" maxlength="4"></div>
                        <div><input type="tel" name="usercell3" value="<%= SplitValue(myUserInfo.FOneItem.Fusercell,"-",2) %>" onkeyup="chkChangeAuth(this.form,'P');" pattern="[0-9]*" id="phone3" class="form" maxlength="4"></div>
                    </div>
                </div>
                <div class="auth-area">
                    <span id="lyrPhoneAuthMsg" class="pull-left">[<%=chkIIF(myUserInfo.FOneItem.FisEmailChk="Y","인증완료","인증대기")%>]</span>
                    <button onclick="sendCnfSMS(document.frminfo);" class="btn type-d pull-right">휴대폰 인증하기</button>
                </div>
                <div class="clear"></div>
                
                <div class="diff"></div>
                <div class="main-title">
                    <h2 class="title"><span class="label">수신동의</span></h2>
                </div>
                <div class="radio-block">
                    <span class="label">이메일 수신동의</span>
                    <span class="radios">
                        <label for="10x10">
                            <input type="checkbox" name="email_10x10check" <%= ChkIIF(myUserInfo.FOneItem.Femail_10x10="Y","checked","") %> class="form" value="Y" id="10x10"> 텐바이텐
                        </label>
                        <label for="fingers">
                            <input type="checkbox" name="email_way2waycheck" <%= ChkIIF(myUserInfo.FOneItem.Femail_way2way="Y","checked","") %> <%= ChkIIF(IsAcademyUsing,""," disabled") %> class="form" value="Y" id="fingers"> 핑거스 아카데미
                        </label>
                        <input type="hidden" name="email_10x10" id="email_10x10">
                        <input type="hidden" name="email_way2way" id="email_way2way">                        
                    </span>
                </div>
                <div class="well">이메일 수신동의를 하시면 텐바이텐 및 핑거스 아카데미에서 제공하는 다양한 할인혜택과 이벤트/신상품 등의 정보를 빠르게 만나실 수 있습니다.</div>
                <div class="radio-block">
                    <span class="label">SMS 수신동의</span>
                    <span class="radios">
                        <label for="sms10x10">
                            <input type="checkbox" name="smsokcheck" <%= ChkIIF(myUserInfo.FOneItem.Fsmsok="Y","checked","") %> class="form" value="Y" id="sms10x10"> 텐바이텐
                        </label>
                        <label for="smsfingers">
                            <input type="checkbox" name="smsok_fingerscheck" <%= ChkIIF(myUserInfo.FOneItem.Fsmsok_fingers="Y","checked","") %> <%= ChkIIF(IsAcademyUsing,""," disabled") %> class="form" value="Y" id="smsfingers"> 핑거스 아카데미
                        </label>
                        <input type="hidden" name="smsok" id="smsok">
                        <input type="hidden" name="smsok_fingers" id="smsok_fingers">                           
                    </span>
                </div>
                <div class="well">SMS 수신동의를 하시면 텐바이텐 및 핑거스 아카데미에서 제공하는 다양한 할인혜택과 이벤트/신상품 등의 정보를 빠르게 만나실 수 있습니다. 주문 및 배송관련 SMS는 수신동의 여부와 상관없이 자동으로 발송됩니다.</div>
                <div class="radio-block">
                    <span class="label">카카오톡 맞춤정보 수신동의</span>
					<%
						'// 카카오톡 인증 //
						if Not(chkKakao) then
					%>
						<button onclick="popKakaoAuth();" class="btn type-c btn-kakao-auth full-size">카카오톡 인증하기</button>
					<% else %>
						<button onclick="popKakaoAuth();" class="btn type-c btn-kakao-auth full-size">서비스 해제 및 수정</button>
                	<% end if %>
                </div>
                <div class="well">카카오톡 맞춤정보 서비스는 주문 및 배송 관련 메시지 및 다양한 혜택과 이벤트에 대한 정보를 SMS 대신 카카오톡으로 발송 드리는서비스입니다. 본 서비스는 스마트폰에 카카오톡이 설치되어 있어야 이용이 가능합니다. 카카오톡이 설치 되어 있지 않다면 설치 후 이용해 주시기 바랍니다.</div>
                <div class="diff"></div>
                <div class="main-title">
                    <h2 class="title"><span class="label">이용 사이트 관리</span></h2>
                </div>
                <div class="t-c">
                    <p style="margin:8px; font-size:14px;">핑거스 아카데미 www.thefingers.co.kr</p>
                    <div class="toggle form small no-pull full-size" style="width:280px; margin:0 auto;">
                        <button name="allow_otherY" id="allow_otherY" value="Y" class='<%= chkIIF(IsAcademyUsing,"active","") %>'><span class="label">이용함</span></button>
                        <button name="allow_otherN" id="allow_otherN" value="N" class='<%= chkIIF(IsAcademyUsing,"","active'") %>'><span class="label">이용하지 않음</span></button>
                        <input type="hidden" name="allow_other" id="theFingers" value="yes">
                    </div>
                </div>
                <div class="form-actions highlight">
                    <div class="two-btns">
                        <div class="col">
                            <button onclick="ChangeMyInfo(document.frminfo);" class="btn type-b full-size">수정</button>
                        </div>
                        <div class="col">
                            <button onclick="return callmain();" class="btn type-a full-size">취소</button>
                        </div>
                    </div>
                    <div class="clear"></div>
                </div>
				</form>
            </div>                
        </div><!-- #content -->
        <!-- #footer -->
        <footer id="footer">
        </footer><!-- #footer -->
    </div><!-- wrapper -->
	<div id="modalCont" style="display:none;"></div>
	
	<!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->