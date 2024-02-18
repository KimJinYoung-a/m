<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/commlib.asp" -->
<%
'## 로그인 여부 확인
if IsUserLoginOK then
	response.write "<script type='text/javascript'>"
	response.write "	alert('이미 회원가입이 되어있습니다.');"
	response.write "	location.href='/apps/appcom/wish/web2014/login/login.asp'"
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

''2015/05/15
Dim isIOSreviewSkip : isIOSreviewSkip=FALSE   ''IOS 심사중 배너 띠우지 않음.
'isIOSreviewSkip = (flgDevice="I") and (InStr(Lcase(Request.ServerVariables("HTTP_USER_AGENT")),"tenapp i1.996")>1) ''심사후 액티브 하면 이줄을 주석 처리 할것
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript" SRC="/lib/js/confirm.js"></script>
<script type="text/javascript">

$(function(){
	$('.agrReceive .agree').click(function(){
		$('.agrCont').slideToggle();
		$(this).toggleClass('on')

		if (document.getElementById("emailsmsok").checked == true){
			document.getElementById("email_10x10temp").checked = true
			document.getElementById("email_way2waytemp").checked = true
			document.getElementById("smsoktemp").checked = true
			document.getElementById("smsok_fingerstemp").checked = true
		}else{
			document.getElementById("email_10x10temp").checked = false
			document.getElementById("email_way2waytemp").checked = false
			document.getElementById("smsoktemp").checked = false
			document.getElementById("smsok_fingerstemp").checked = false
		}
	});
});

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
			$("#checkMsgID").html("사용하실 수 없는 아이디입니다.");
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
		$("#checkMsgEmail").show();
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

	if (frm.selfemail.value == ""){
		alert("이메일 입력해주세요");
		frm.selfemail.focus();
		return ;
	}
	email = frm.selfemail.value;

	if (email == ''){
		return;
	}else if (!check_form_email(email)){
        alert("이메일 주소가 유효하지 않습니다.");
		frm.selfemail.focus();
		return ;
	}else{
		var rstStr = $.ajax({
			type: "POST",
			url: "/apps/appCom/wish/web2014/member/ajaxEmailCheck.asp",
			data: "email="+email,
			dataType: "text",
			async: false
		}).responseText;

		if (rstStr == "ERR"){
			$("#checkMsgEmail").html("오류가 발생했습니다.");
			$("#checkMsgEmail").show();
			chkEmail = false;
			document.myinfoForm.selfemail.focus();
		}else if (rstStr == "3"){
			$("#checkMsgEmail").html("이메일 주소가 유효하지 않습니다.");
			$("#checkMsgEmail").show();
			chkEmail = false;
			document.myinfoForm.selfemail.focus();
		}else if(rstStr == "2"){
			$("#checkMsgEmail").html("입력하신 이메일로 이미 가입된 아이디가 있습니다.");
			$("#checkMsgEmail").show();
			chkEmail = false;
			document.myinfoForm.selfemail.focus();
		}else{
			$("#checkMsgEmail").html("사용가능 한 이메일 주소입니다.");
			$("#checkMsgEmail").show();
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

// 본인인증 휴대폰SMS 발송
function sendSMS() {
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

	if (jsChkBlank(frm.txCell2.value) || jsChkBlank(frm.txCell3.value)){
	    alert("휴대전화 번호를 입력해주세요");
		frm.txCell2.focus();
		return ;
	}

	if (!jsChkNumber(frm.txCell2.value) || !jsChkNumber(frm.txCell3.value)){
	    alert("휴대전화 번호는 공백없는 숫자로 입력해주세요.");
		frm.txCell2.focus();
		return ;
	}
	
	var usrph = frm.txCell1.value + "-" + frm.txCell2.value + "-" + frm.txCell3.value;
	var rstStr = $.ajax({
		type: "POST",
		url: "/apps/appCom/wish/web2014/member/ajaxSendConfirmSMS2015.asp",
		data: "id="+frm.txuserid.value+"&ph="+usrph+"",
		dataType: "text",
		async: false
	}).responseText;

	$("#sendSMSnumber").empty().html(rstStr);
	if(rstStr.length == 31){
		$("#certNum").val("").focus();
	}	
}

function fnConfirmSMS() {
	var frm = document.myinfoForm;
	if(frm.crtfyNo.value.length<6) {
		alert("휴대폰으로 받으신 인증번호를 정확히 입력해주세요.");
		frm.crtfyNo.focus();
		return;
	}
	
	var rstStr = $.ajax({
		type: "POST",
		url: "/apps/appCom/wish/web2014/member/ajaxCheckConfirmSMS2015.asp",
		data: "id="+frm.txuserid.value+"&chkFlag=N&key="+frm.crtfyNo.value,
		dataType: "text",
		async: false
	}).responseText;
	
	if (rstStr == "1"){
		$("#smsRstMsg").html("인증이 완료되었습니다.");
		$("#certNum").attr("readonly", true);
		$("#txCell2").attr("readonly", true);
		$("#txCell3").attr("readonly", true);
		$("#smsButtonn1").hide();
		$("#smsButtonn2").hide();
		$("#sendSMSnumber").hide();
	}else if (rstStr == "2"){
		$("#smsRstMsg").html("인증번호가 정확하지 않습니다.");
	}else{
		$("#smsRstMsg").html("인증번호를 입력해주세요.");
		alert("처리중 오류가 발생했습니다."+rstStr);
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
		frm.selfemail.focus();
		return;
	}
	if (frm.selfemail.value == ""){
		alert("이메일을 입력해주세요.");
		frm.selfemail.focus();
		return ;
	}
	frm.usermail.value = frm.selfemail.value;
	if (jsChkBlank(frm.txCell2.value) || jsChkBlank(frm.txCell3.value)){
	    alert("휴대전화 번호를 입력해주세요");
		frm.txCell2.focus();
		return ;
	}
	if (!jsChkNumber(frm.txCell2.value) || !jsChkNumber(frm.txCell3.value)){
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
	<% if (NOT isIOSreviewSkip) then %>
	if (!frm.txSex[0].checked&&!frm.txSex[1].checked){
		alert("성별을 선택 해주세요");
		frm.txSex[0].focus();
		return ;
	}
    <% end if %>
	if (document.getElementById("emailsmsok").checked == true){
		if (document.getElementById("email_10x10temp").checked == true){
			frm.email_10x10.value = 'Y';
		}else{
			frm.email_10x10.value = 'N';
		}
		if (document.getElementById("email_way2waytemp").checked == true){
			frm.email_way2way.value = 'Y';
		}else{
			frm.email_way2way.value = 'N';
		}
		if (document.getElementById("smsoktemp").checked == true){
			frm.smsok.value = 'Y';
		}else{
			frm.smsok.value = 'N';
		}
		if (document.getElementById("smsok_fingerstemp").checked == true){
			frm.smsok_fingers.value = 'Y';
		}else{
			frm.smsok_fingers.value = 'N';
		}						
	}

	if($("#smsRstMsg").html() != "인증이 완료되었습니다."){
	    alert("휴대폰 인증이 완료되지 않았습니다.\n인증을 완료해주세요.");
		frm.crtfyNo.focus();
		return ;
	}

	var ret = confirm('텐바이텐 회원에 가입하시겠습니까?');
	if(ret){
		frm.submit();
	}
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin bgGry">
		<!-- content area -->
		<div class="content" id="contentArea">
			<!-- 회원가입 - 2.정보입력 -->
			<div class="join inner5">
				<form name="myinfoForm" method="post" action="<%=M_SSLUrl%>/apps/appcom/wish/web2014/member/dojoin_step2.asp" onsubmit="return false;">
				<input type="hidden" name="hideventid" value="<%= ihideventid %>">
				<input type="hidden" name="usermail" value="">
				<input type="hidden" name="email_10x10" value="">
				<input type="hidden" name="smsok" value="">
				<input type="hidden" name="email_way2way" value="">
				<input type="hidden" name="smsok_fingers" value="">
				<input type="hidden" name="txSolar" value="Y">
				<input type="hidden" name="chkFlag" value="N">
				<div class="joinStep">
					<ol>
						<li class="on"><span>1</span>약관동의</li>
						<li class="on"><span>2</span>정보입력</li>
						<li><span>3</span>가입완료</li>
					</ol>
				</div>
				<div class="writeInfo box1">
					<section>
						<table class="writeTbl01">
							<colgroup>
								<col width="25%" />
								<col width="" />
							</colgroup>
							<tbody>
								<tr>
									<th>아이디</th>
									<td>
										<input type="text" name="txuserid" maxlength="16" onKeyDown="keyCodeCheckID(event,this);" onKeyUp="jsChkID();" onClick="jsChkID();" onBlur="isToLowerCase(this,0); DuplicateIDCheck(this);" class="w60p" title="아이디 입력" autocorrect="off" autocapitalize="off" />
										<span class="button btB2 btGry cBk1 lMar05"><a href="" onclick="isToLowerCase(document.myinfoForm.txuserid,0); DuplicateIDCheck(document.myinfoForm.txuserid); return false;">중복확인</a></span>
										<p id="checkMsgID" class="tMar05">3~15자의 영문/숫자를 조합하여 입력</p>
									</td>
								</tr>
								<tr>
									<th>비밀번호</th>
									<td><input type="password" name="txpass1" maxlength="32" class="w100p" title="비밀번호 입력" /></td>
								</tr>
								<tr>
									<th>비밀번호 확인</th>
									<td>
										<input type="password" name="txpass2" maxlength="32" class="w100p" title="비밀번호 확인" />
										<p id="checkMsgPW" class="cRd1 tMar05">8~16자의 영문/숫자를 조합하여 입력</p>
									</td>
								</tr>
							</tbody>
						</table>
					</section>
					<section>
						<table class="writeTbl01">
							<colgroup>
								<col width="25%" />
								<col width="" />
							</colgroup>
							<tbody>
								<tr>
									<th>이름</th>
									<td><input type="text" name="txName" maxlength="30" class="w100p" title="이름 입력" /></td>
								</tr>
								<% if (isIOSreviewSkip) then %>
								    <input type="hidden" name="txSex" value="F">
								    <input type="hidden" name="txBirthday1" value="1900">
								    <input type="hidden" name="txBirthday2" value="01">
								    <input type="hidden" name="txBirthday3" value="01">
								<% else %>
								<tr>
									<th>성별</th>
									<td>
										<span><input type="radio" name="txSex" value="M" id="male" /> <label for="male" class="lMar05">남자</label></span>
										<span class="lMar30"><input type="radio" name="txSex" value="F" id="female" /> <label for="female" class="lMar05">여자</label></span>
									</td>
								</tr>
								<tr>
									<th>생일</th>
									<td>
										<select name="txBirthday1" id="txBirthday1" title="태어난 년도 선택" class="w30p">
										<%
										Dim yyyy,mm,dd
											For yyyy = year(now())-100 to year(now())-14
										%>
											<option value="<%=yyyy%>" <%=chkIIF(yyyy=year(now())-14,"selected","")%>><%=yyyy%></option>
										<% Next %>
										</select>
										<select name="txBirthday2" id="txBirthday2" title="태어난 월 선택" class="w30p lMar05">
										<% For mm = 1 to 12 %>
											<option value="<%=mm%>"><%=mm%></option>
										<% Next %>
										</select>
										<select name="txBirthday3" id="txBirthday3" title="태어난 일 선택" class="w30p lMar05">
										<% For dd = 1 to 31%>
											<option value="<%=dd%>"><%=dd%></option>
										<% Next %>
										</select>
										<p class="cRd1 tMar05">★ 생일 쿠폰을 선물로 드립니다.</p>
									</td>
								</tr>
							    <% end if %>
							</tbody>
						</table>
					</section>
					<section>
						<table class="writeTbl01">
							<colgroup>
								<col width="22%" />
								<col width="" />
							</colgroup>
							<tbody>
								<tr>
									<th>이메일</th>
									<td>
										<input type="email" name="selfemail" maxlength="80" onKeyDown="keyCodeCheckEmail(event);" onKeyUp="jsChkEmail();" onClick="jsChkEmail();" class="w60p" />
										<span class="button btB2 btGry cBk1 lMar05"><a href="" onclick="DuplicateEmailCheck(); return false;">중복확인</a></span>
										<p id="checkMsgEmail" style="display:none;" class="cRd1 tMar05">사용 가능한 이메일 주소입니다.</p>
									</td>
								</tr>
								<tr>
									<th>휴대폰</th>
									<td>
										<p>
											<select name="txCell1" title="휴대전화 앞자리 선택" style="width:26%">
												<option value="010">010</option>
												<option value="011">011</option>
												<option value="016">016</option>
												<option value="017">017</option>
												<option value="018">018</option>
												<option value="019">019</option>
											</select>
											<input type="tel" name="txCell2" id="txCell2" maxlength="4" pattern="[0-9]*" onkeyup="TnTabNumber('txCell2','txCell3',4);" style="width:23%" />
											<input type="tel" name="txCell3" id="txCell3" maxlength="4" pattern="[0-9]*" style="width:23%" />
											<span id="smsButtonn1" class="button btB2 btGry cBk1"><a href="" onclick="sendSMS(); return false;">인증</a></span>
											<p id="sendSMSnumber" class="cRd1 tMar05"></p>
										</p>
										<p class="tMar05">
											<input type="text" name="crtfyNo" id="certNum" maxlength="6" title="인증번호 6자리 입력" placeholder="인증번호 6자리 입력" class="w60p" />
											<span id="smsButtonn2" class="button btB2 btGry cBk1"><a href="" onclick="fnConfirmSMS(); return false;">확인</a></span>
											<p id="smsRstMsg" class="cRd1 tMar05"></p>
										</p>
										<p class="tMar05 lh12">이메일 및 휴대폰 정보는 보안 인증 및 아이디 찾기, 비밀번호 재발급시 이용됩니다.</p>
									</td>
								</tr>
							</tbody>
						</table>
					</section>
				</div>
				<div class="box1 inner5 agrReceive">
					<p class="agree"><input type="checkbox" name="emailsmsok" id="emailsmsok" /> <em class="lMar05">이메일/SMS 수신에 동의합니다.</em></p>
					<div class="agrCont">
						<dl>
							<dt>이메일 수신동의</dt>
							<dd>
								<p><input type="checkbox" name="email_10x10temp" id="email_10x10temp" /> <label for="mTenten">텐바이텐</label></p>
								<p><input type="checkbox" name="email_way2waytemp" id="email_way2waytemp" /> <label for="mFingers">더핑거스</label></p>
							</dd>
						</dl>
						<dl>
							<dt>SMS 수신동의</dt>
							<dd>
								<p><input type="checkbox" name="smsoktemp" id="smsoktemp" /> <label for="sTenten">텐바이텐</label></p>
								<p><input type="checkbox" name="smsok_fingerstemp" id="smsok_fingerstemp" /> <label for="sFingers">더핑거스</label></p>
							</dd>
						</dl>
						<p class="lh14">수신동의를 하시면 텐바이텐 및 더핑거스에서 제공하는 다양한 할인 혜택과 이벤트/신상품 등의 정보를 만나실 수 있습니다. <br /><em class="cRd1">주문 및 배송관련 SMS는 수신동의와 상관없이 자동 발송합니다.</em></p>
					</div>
				</div>
				<p class="tMar20"><span class="button btB1 btRed cWh1 w100p"><a href="" onclick="FnJoin10x10(); return false;">다음</a></span></p>
				</form>
			</div>
			<!--// 회원가입 - 2.정보입력 -->
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->