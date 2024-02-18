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
'	Description : 회원가입
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/lib/util/commlib.asp" -->
<%
'## 로그인 여부 확인
if IsUserLoginOK then
	response.write "<script type='text/javascript'>"
	response.write "	alert('이미 회원가입이 되어있습니다.');"
	response.write "	location.href='/apps/appcom/wish/webview/login/login.asp'"
	response.write "</script>"
	dbget.close(): response.End
end if

'외부 URL 체크
dim backurl
backurl = request.ServerVariables("HTTP_REFERER")
if InStr(LCase(backurl),"10x10.co.kr") < 1 then
    if (Len(backurl)>0) then
        response.redirect backurl
        response.end
    else
        response.write "<script>alert('유효한 접근이 아닙니다.');history.back();</script>"
        response.end
    end if
end if

	'### 약관체크
	Dim agreeUse, agreePrivate, agreeUseAdult
	agreeUse = requestCheckVar(request("agreeUse"),1)
	agreePrivate = requestCheckVar(request("agreePrivate"),1)
	agreeUseAdult = requestCheckVar(request("agreeUseAdult"),1)

	If agreeUse <> "o" OR agreePrivate <> "o" OR agreeUseAdult <> "o" Then
        response.write "<script>alert('약관에 모두 체크하셔야 합니다.');history.back();</script>"
        response.end
	End If

'// 유입경로
Dim ihideventid
ihideventid = session("hideventid")
if ihideventid="" and request.cookies("rdsite")<>"" then
	ihideventid = left("mobile_app_wish_" & request.cookies("rdsite"),32)
else
	ihideventid = "mobile_app_wish"
end if
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script type="text/javascript" src="/lib/js/confirm.js"></script>
<script type="text/javascript">

var chkID = false, chkAjaxID = false;
var chkEmail = false, chkAjaxEmail = false;

//아이디 중복확인
function DuplicateIDCheck(comp){
	var id;
	id = comp.value;

	if (id == ''){
		return;
	}else if((id.length<3) || (id.length>16)){
		alert('아이디는 공백없는 3~15자의 영문/숫자 조합입니다.');
		comp.focus();
	}else{
		var rstStr = $.ajax({
			type: "POST",
			url: "/member/ajaxIdCheck.asp",
			data: "id="+id,
			dataType: "text",
			async: false
		}).responseText;

		if (rstStr == "ERR"){
			$("#checkMsgID").html("오류가 발생했습니다.");
			chkID = false;
			document.myinfoForm.txuserid.focus();
		}else if (rstStr == "3"){
			$("#checkMsgID").html("특수문자나 한글/한문은 사용불가능합니다.");
			chkID = false;
			document.myinfoForm.txuserid.focus();
		}else if(rstStr == "2"){
			$("#checkMsgID").html("<font class='tMar05 fsBig cc91314'>사용하실 수 없는 아이디입니다.</font>");
			chkID = false;
			document.myinfoForm.txuserid.focus();
		}else{
			$("#checkMsgID").html("사용하실 수 있습니다.");
			chkID = true;
		}
		chkAjaxID = true;
	}
}

function jsChkID(){
	if(chkID){
		$("#checkMsgID").html("공백없는 3~15자의 영문/숫자를 조합하여 입력해야 합니다.");
		chkID = false;
	}
}

function jsChkEmail(){
	if(chkEmail){
		$("#checkMsgEmail").html("이메일을 입력해주세요.");
		chkEmail = false;
	}
}

//소문자로 변환; index를 지정할 경우 index길이만큼만 소문자로 변환
function isToLowerCase(obj, index){
	if(typeof(index) != 'undefined' && index != ""){
		obj.value =
			obj.value.substring(0, index).toLowerCase()
			+ obj.value.substring(index, obj.value.length);
		return;
	}
	obj.value = obj.value.toLowerCase();
}

// 이벤트 키코드 체크
function keyCodeCheckID(event,id) {
	if(event.keyCode == 13){
		DuplicateIDCheck(id);
	}
}
function keyCodeCheckEmail(event) {
	if(event.keyCode == 13){
		DuplicateEmailCheck();
	}
}

//이메일 중복확인
function DuplicateEmailCheck(){
	var email, frm = document.myinfoForm;

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

	if (frm.txEmail2.value == ""){
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
	}else{
	    email = frm.txEmail1.value + '@' + frm.txEmail2.value;
	}

	if (email == ''){
		return;
	}else if (!check_form_email(email)){
        alert("이메일 주소가 유효하지 않습니다.");
		frm.txEmail1.focus();
		return ;
	}else{

		var rstStr = $.ajax({
			type: "POST",
			url: "/member/ajaxEmailCheck.asp",
			data: "email="+email,
			dataType: "text",
			async: false
		}).responseText;

		if (rstStr == "ERR"){
			$("#checkMsgEmail").html("오류가 발생했습니다.");
			chkEmail = false;
			document.myinfoForm.txEmail1.focus();
		}else if (rstStr == "3"){
			$("#checkMsgEmail").html("이메일 주소가 유효하지 않습니다.");
			chkEmail = false;
			document.myinfoForm.txEmail1.focus();
		}else if(rstStr == "2"){
			$("#checkMsgEmail").html("<font class='tMar05 fsBig cc91314'>입력하신 이메일로 이미 가입된 아이디가 있습니다.</font>");
			chkEmail = false;
			document.myinfoForm.txEmail1.focus();
		}else{
			$("#checkMsgEmail").html("사용가능 한 이메일 주소입니다.");
			chkEmail = true;
		}
		chkAjaxEmail = true;
	}
}

function TnTabNumber(thisform,target,num) {
	if (eval("document.myinfoForm." + thisform + ".value.length") == num) {
		eval("document.myinfoForm." + target + ".focus()");
	}
}

function FnJoin10x10(){
	var frm = document.myinfoForm;
	
	if(!chkID){
		if((!chkAjaxID) && frm.txuserid.value.length>3 && frm.txuserid.value.length<16) {}
		else {
			alert("아이디를 확인해주세요");
		   	DuplicateIDCheck(frm.txuserid);
		   	frm.txuserid.focus();
		   	return;
		}
	}
	if (jsChkBlank(frm.txpass1.value)){
		alert("비밀번호를 입력하세요");
		frm.txpass1.focus();
		return ;
	}
	if (frm.txpass1.value.length < 8 || frm.txpass1.value.length > 16){
		alert("비밀번호는 공백없이 8~16자입니다.");
		frm.txpass1.focus();
		return ;
	}

	if (frm.txpass1.value==frm.txuserid.value){
		alert('아이디와 동일한 패스워드는 사용하실 수 없습니다.');
		frm.txpass1.focus();
		return;
	}

	if (!fnChkComplexPassword(frm.txpass1.value)) {
		alert('패스워드는 영문/숫자/특수문자 중 두 가지 이상의 조합으로 입력해주세요.');
		frm.txpass1.focus();
		return;
	}

	if (frm.txpass2.value == ""){
		alert("비밀번호를 확인해주세요");
		frm.txpass2.focus();
		return ;
	}
	if (frm.txpass1.value!=frm.txpass2.value){
			$("#checkMsgPW").html("비밀번호가 일치하지 않습니다.");
		frm.txpass1.focus();
		return ;
	}
	if(!chkEmail){
		alert("이메일을 확인해주세요.");
		frm.txEmail1.focus();
		return;
	}

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

	if (frm.txEmail2.value == ""){
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
	    frm.usermail.value = frm.txEmail1.value + '@' + frm.selfemail.value;
	}else{
	    frm.usermail.value = frm.txEmail1.value + '@' + frm.txEmail2.value;
	}

	if ( jsChkBlank(frm.txCell2.value) || jsChkBlank(frm.txCell3.value) ){
	    alert("휴대전화 번호를 입력해주세요");
		frm.txCell2.focus();
		return ;
	}

	if ( !jsChkNumber(frm.txCell2.value) || !jsChkNumber(frm.txCell3.value) ){
	    alert("휴대전화 번호는 공백없는 숫자로 입력해주세요.");
		frm.txCell2.focus();
		return ;
	}

	if (frm.txName.value == ""){
		alert("성명을 입력하세요");
		frm.txName.focus();
		return ;
	}

	if (GetByteLength(frm.txName.value) > 30){
		alert("성명은 한글 15자, 영문 30자 이내 입니다.");
		frm.txName.focus();
		return ;
	}

	var tmptxSex='';
	if ( $("#memMale").hasClass('active') ){
		tmptxSex=$("#memMale").val()
	}
	if ( $("#memFemale").hasClass('active') ){
		tmptxSex=$("#memFemale").val()
	}
	if (tmptxSex==''){
		alert("성별을 선택 해주세요");
		return ;
	}
	frm.txSex.value=tmptxSex;

	var tmptxSolar='';
	if ( $("#solar").hasClass('active') ){
		tmptxSolar=$("#solar").val()
	}
	if ( $("#lunar").hasClass('active') ){
		tmptxSolar=$("#lunar").val()
	}
	if (tmptxSolar==''){
		alert("생년월일(양력,음력)을 선택해주세요.");
		return ;
	}
	frm.txSolar.value=tmptxSolar;

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
	
	var ret = confirm('텐바이텐 회원에 가입하시겠습니까?');
	if(ret){
		frm.submit();
	}
}

</script>
</head>
<body class="util">
    <!-- wrapper -->
    <div class="wrapper">
        <!-- #header -->
        <header id="header">
            <h1 class="page-title">회원가입</h1>
            <ul class="process clear">
                <li><span class="label">약관동의</span></li>
                <li class="active"><span class="label">정보입력</span></li>
                <li><span class="label">본인인증</span></li>
                <li><span class="label">가입완료</span></li>
            </ul>
        </header><!-- #header -->

        <!-- #content -->
        <div id="content">

			<form name="myinfoForm" method="post" action="<%=M_SSLUrl%>/apps/appcom/wish/webview/member/dojoin_step2.asp" onsubmit="return false;">
			<input type="hidden" name="hideventid" value="<%= ihideventid %>">
			<input type="hidden" name="usermail" value="">
            <div class="inner"> 
                <!-- basic info -->
                <div class="main-title">
                    <h2 class="title"><span class="label">회원기본정보</span></h2>
                </div>
                <div class="input-block">
                    <label for="name" class="input-label">이름</label>
                    <div class="input-controls">
                        <input type="text" name="txName" id="name" maxlength="30" class="form full-size">
                    </div>
                </div>
                
                <div class="form toggle small">
                    <button value="M" id="memMale" class="active"><span class="label">남자</span></button>
                    <button value="F" id="memFemale"><span class="label">여자</span></button>
                    <input type="hidden" name="txSex" id="gender" value="M">
                </div>
                <div class="clear"></div>
                <div class="input-block">
                    <label for="phone" class="input-label">생년월일</label>
                    <div class="input-controls">
                        <select name="txBirthday1" style="width:30%;" id="txBirthday1" class="form">
							<%
							Dim yyyy,mm,dd
							For yyyy = year(now())-100 to year(now())-14
							%>
								<option value="<%=yyyy%>" <%=chkIIF(yyyy=year(now())-14,"selected","")%>><%=yyyy%></option>
							<% Next %>							
                        </select>
                        <select name="txBirthday2" style="width:30%;" id="txBirthday2" class="form">
							<% For mm = 1 to 12 %>
								<% If mm < 10 Then mm = Format00(2,mm) End If %>
								<option value="<%=mm%>"><%=mm%></option>
							<% Next %>
                        </select>
                        <select name="txBirthday3" style="width:30%;" id="txBirthday3" class="form">
							<% For dd = 1 to 31%>
								<% If dd < 10 Then dd =Format00(2,dd) End If %>
								<option value="<%=dd%>"><%=dd%></option>
							<% Next%>
                        </select>                        
                    </div>
                </div>
                <div class="form toggle small">
                    <button value="Y" id="solar" class="active"><span class="label">양력</span></button>
                    <button value="N" id="lunar"><span class="label">음력</span></button>
                    <input type="hidden" name="txSolar" id="birthType" value="sun">
                </div>
                <div class="clear"></div>
                <em class="em">* 등록된 생일 1주일 전 생일 축하쿠폰을 선물로 드립니다.</em>

                <div class="input-block">
                    <label for="userid" class="input-label">아이디</label>
                    <div class="input-controls">
                        <input type="text" name="txuserid" id="userid" class="form full-size" maxlength="16" onKeyDown="keyCodeCheckID(event,this);" onKeyUp="jsChkID();" onClick="jsChkID();" onBlur="isToLowerCase(this,0); DuplicateIDCheck(this);">
                        <button onclick="isToLowerCase(document.myinfoForm.txuserid,0); javascript:DuplicateIDCheck(document.myinfoForm.txuserid);" class="btn type-c btn-checkid side-btn">중복확인</button>
                    </div>
                </div>
                <em id="checkMsgID" class="em red">* 영문/숫자 조합 3~15자리로 입력해 주세요.</em>
                
                <div class="input-block">
                    <label for="pwd" class="input-label">비밀번호</label>
                    <div class="input-controls">
                        <input type="password" name="txpass1" id="pwd" class="form full-size" maxlength="32">
                    </div>
                </div>
                <div class="input-block">
                    <label for="pwdCheck" class="input-label">비밀번호확인</label>
                    <div class="input-controls">
                        <input type="password" name="txpass2" id="pwdCheck" class="form full-size" maxlength="32">
                    </div>
                </div>
                <em class="em red">* 8~16자의 영문/숫자 등 2가지 이상 조합</em>
                <div class="diff"></div>
                <div class="main-title">
                    <h2 class="title"><span class="label">이메일/휴대폰</span></h2>
                </div>

                <p>이메일 및 휴대폰 번호는 본인 인증 및 아이디 찾기, 비밀번호 재발급시 이용되는 정보이므로 정확하게 입력하여 주세요.</p>

                <div class="input-block email-block">
                    <label for="email" class="input-label">이메일</label>
                    <div class="input-controls email-type-b">
						<input type="text" id="email1" name="txEmail1" value="" onKeyDown="keyCodeCheckEmail(event);" onKeyUp="jsChkEmail();" onClick="jsChkEmail();" maxlength="32" class="form">
                        @
                        <% call DrawEamilBoxHTML_App("document.myinfoForm","selfemail","txEmail2","","form","form bordered"," onKeyDown=""keyCodeCheckEmail(event);"" onKeyUp=""jsChkEmail();"" onClick=""jsChkEmail();"" onkeyup=""chkChangeAuth(this.form,'E');"""," onchange=""jsShowMailBox('document.myinfoForm','txEmail2','selfemail'); """) %>
					</div>
                </div>
                <div class="input-block t-r">
                    <button onclick="DuplicateEmailCheck()" class="btn type-a small">중복확인</button>
                </div>
                <em id="checkMsgEmail" class="em red warning">* 이메일 주소가 유효하지 않습니다.</em>
                <div class="input-block">
                    <label for="phone" class="input-label">휴대폰</label>
                    <div class="input-controls">
                        <select name="txCell1" style="width:30%;" id="phone1" class="form">
							<option value="010">010</option>
							<option value="011">011</option>
							<option value="016">016</option>
							<option value="017">017</option>
							<option value="018">018</option>
							<option value="019">019</option>
                        </select>
                        <input type="tel" name="txCell2" pattern="[0-9]*" onkeyup="TnTabNumber('txCell2','txCell3',4);" style="width:30%;" id="phone2" class="form" maxlength="4">
                        <input type="tel" name="txCell3" pattern="[0-9]*" style="width:30%;" id="phone3" class="form" maxlength="4">
                    </div>
                </div>
                <div class="diff"></div>
                <!-- basic info -->
                
                <!-- additional info -->
                <div class="main-title">
                    <h2 class="title"><span class="label">수신동의</span></h2>
                </div>
                <div class="radio-block">
                    <span class="label">이메일 수신동의</span>
                    <span class="radios">
                        <label for="10x10">
                            <input type="checkbox" name="email_10x10check" class="form" value="Y" id="10x10" checked="checked"> 텐바이텐
                        </label>
                        <label for="fingers">
                            <input type="checkbox" name="email_way2waycheck" class="form" value="Y" id="fingers" checked="checked"> 핑거스 아카데미
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
                            <input type="checkbox" name="smsokcheck" class="form" value="Y" id="sms10x10" checked="checked"> 텐바이텐
                        </label>
                        <label for="smsfingers">
                            <input type="checkbox" name="smsok_fingerscheck" class="form" value="Y" id="smsfingers" checked="checked"> 핑거스 아카데미
                        </label>
                        <input type="hidden" name="smsok" id="smsok">
                        <input type="hidden" name="smsok_fingers" id="smsok_fingers">                        
                    </span>
                </div>
                <div class="well">SMS 수신동의를 하시면 텐바이텐 및 핑거스 아카데미에서 제공하는 다양한 할인혜택과 이벤트/신상품 등의 정보를 빠르게 만나실 수 있습니다. 주문 및 배송관련 SMS는 수신동의 여부와 상관없이 자동으로 발송됩니다.</div>
                <!-- additional info -->
            </div>
            <div class="form-actions highlight">
                <button onclick="FnJoin10x10();" class="btn type-b full-size">회원등록</button>
            </div>
            </form>
        </div><!-- #content -->

        <!-- #footer -->
        <footer id="footer">
            
        </footer><!-- #footer -->
    </div><!-- wrapper -->
    
    <!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->