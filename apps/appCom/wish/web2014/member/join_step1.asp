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
'	History	:  2017.06.05 유태욱 생성
'#######################################################
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
'        response.write "<script>alert('유효한 접근이 아닙니다.');history.back();</script>"
'        response.end
    end if
end if

dim snsid, tenbytenid, snsusermail, tmpsnsusermail, snsusermailid, snsusermaildomain
dim snsisusing, snsgubun, tokenval, snsusername, sns_sexflag, kakaoterms
dim smartAlarm, email_10x10, email_way2way, smsok, smsok_fingers
snsid	= requestCheckVar(request("snsid"),64)
tenbytenid	= requestCheckVar(request("tenbytenid"),32)
snsusermail	= requestCheckVar(request("usermail"),128)
snsisusing	= requestCheckVar(request("snsisusing"),1)
snsgubun	= requestCheckVar(request("snsgubun"),2)
snsusername	= requestCheckVar(request("snsusername"),16)
sns_sexflag	= requestCheckVar(request("sexflag"),10)
tokenval	= request("tokenval")
tokenval	= replace(tokenval," ","+")
kakaoterms 	= requestCheckVar(request("kakaoterms"),2400)
smartAlarm 	= requestCheckVar(request("smartAlarm"),3)

'약관 동의 페이지 이전일때 다시 보냄 
if request("sec30") <> "" then
else
%>
<html>
<head>
<script>
function fnTermsGo(){
	document.snsinfo.submit();
}
</script>
</head>
<body onload="fnTermsGo();">
<form name="snsinfo" method="post" action="<%=M_SSLUrl%>/apps/appcom/wish/web2014/member/join.asp">
<input type="hidden" name="hideventid" value="<%= ihideventid %>">
<input type="hidden" name="email_10x10" value="<%= email_10x10 %>">
<input type="hidden" name="smsok" value="<%= smsok %>">
<input type="hidden" name="email_way2way" value="<%= email_way2way %>">
<input type="hidden" name="smsok_fingers" value="<%= smsok_fingers %>">
<input type="hidden" name="txSolar" value="Y">
<input type="hidden" name="chkFlag" value="N">
<input type="hidden" name="snsgubun" value="<%= snsgubun %>">
<input type="hidden" name="snsid" value="<%= snsid %>">
<input type="hidden" name="tokenval" value="<%= tokenval %>">
<input type="hidden" name="sns_sexflag" value="<%= sns_sexflag %>">
<input type="hidden" name="kakaoterms" value="<%=kakaoterms%>">
</form>
</body>
</html>
<%
response.end
end if

'// 유입경로
Dim ihideventid
ihideventid = session("hideventid")
if ihideventid="" and request.cookies("rdsite")<>"" then
	ihideventid = left("mobile_app_wish_" & request.cookies("rdsite"),32)
else
	ihideventid = "mobile_app_wish"
end if

if smartAlarm<>"" then
	email_10x10 = "N"
	email_way2way = "N"
	smsok = "N"
	smsok_fingers = "N"
else
	email_10x10 = "Y"
	email_way2way = "Y"
	smsok = "Y"
	smsok_fingers = "Y"
end if

if snsusermail="" or isnull(snsusermail) or snsusermail="null" then snsusermail=""
if snsusername="" or isnull(snsusername) or snsusername="null" then snsusername=""

if Not(snsusermail="" or isNull(snsusermail) or snsusermail="null" ) Then
	tmpsnsusermail = Split(snsusermail,"@")
	if isArray(tmpsnsusermail) then
		snsusermailid = tmpsnsusermail(0)
		snsusermaildomain = tmpsnsusermail(1)
	end if
end if

if snsusername="" then
	'snsusername=left(snsgubun,1) & "_" & lcase(left(md5(now()),8))
end if
''2015/05/15
Dim isIOSreviewSkip : isIOSreviewSkip=FALSE   ''IOS 심사중 배너 띠우지 않음.
''isIOSreviewSkip = (flgDevice="I") and (InStr(Lcase(Request.ServerVariables("HTTP_USER_AGENT")),"tenapp i1.94")>1) ''심사후 액티브 하면 이줄을 주석 처리 할것
%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript" SRC="/lib/js/confirm.js"></script>
<link rel="stylesheet" type="text/css" href="/lib/css/common.css?v=2.03" />
<link rel="stylesheet" type="text/css" href="/lib/css/content.css?v=4.90" />
<link rel="stylesheet" type="text/css" href="/lib/css/contentV20.css?v=1.85" />
<link rel="stylesheet" type="text/css" href="/lib/css/commonV20.css?v=1.43" />
<link rel="stylesheet" type="text/css" href="/lib/css/appV20.css?v=1.06" />
<script style="text/css">
$(function(){
    var topHeight = $('#header').outerHeight();
    var simpleTit = $('.simpleTit');
    $(simpleTit).css('top',topHeight);
	fnAPPchangPopCaption('');
});

var chkID = false, chkAjaxID = false;
var chkEmail = false, chkAjaxEmail = false;
var chkSMS = false;

//아이디 중복확인
function DuplicateIDCheck(comp){
	var id;
	id = comp.value;
	var frm = document.myinfoForm;
    var uid = frm.txuserid.value;
    var num = uid.search(/[0-9]/g);
    var eng = uid.search(/[a-z]/ig);
	var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;
	if (id == ''){
		$("#checkIDOK").hide();
		//$("#uid").show();
		chkID = false;
	}else if((id.length<3) || (id.length>15)){
		//$("#uid").hide();
		$("#checkIDOK").hide();
		$("#checkMsgID").show();
		$("#checkMsgID").html("3~15자 이내의 영문/숫자 조합으로 입력해주세요.");
		chkID = false;
	}else if(num < 0 || eng < 0){
		//$("#uid").hide();
        $("#checkMsgID").show();
        $("#checkIDOK").hide();
		$("#checkMsgID").html("영문/숫자 조합으로 입력해주세요.");
		chkID = false;
    }else if(regExp.test(uid)){
		//$("#uid").hide();
		$("#checkMsgID").show();
        $("#checkIDOK").hide();
		$("#checkMsgID").html("영문/숫자 조합으로 입력해주세요.");
		chkID = false;
	}else{
		//$("#uid").hide();
		var rstStr = $.ajax({
			type: "POST",
			url: "/member/ajaxIdCheck.asp",
			data: "id="+id,
			dataType: "text",
			async: false
		}).responseText;
		if (rstStr == "ERR"){
			$("#checkIDOK").hide();
			$("#checkMsgID").show();
			$("#checkMsgID").html("오류가 발생했습니다.");
			chkID = false;
			document.myinfoForm.txuserid.focus();
		}else if (rstStr == "3"){
			$("#checkIDOK").hide();
			$("#checkMsgID").show();
			$("#checkMsgID").html("3~15자 이내의 영문/숫자 조합으로 입력해주세요.");
			chkID = false;
			document.myinfoForm.txuserid.focus();
		}else if(rstStr == "2"){
			$("#checkIDOK").hide();
			$("#checkMsgID").show();
			$("#checkMsgID").html("이미 사용 중인 아이디에요.");
			chkID = false;
		}else{
			$("#checkMsgID").hide();
            $("#checkIDOK").show();
			chkID = true;
		}
		chkAjaxID = true;
	}
}

function jsChkID(){
	if(!chkID){
		$("#checkMsgID").show();
		$("#checkMsgID").html("3~15자 이내의 영문/숫자 조합으로 입력해주세요.");
		chkID = false;
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

function check_form_email(email)
{

	var pos;


	pos = email.indexOf('@');

	if (pos < 0)				//@가 포함되어 있지 않음
		return(false);
	else
		{
		pos = email.indexOf('@', pos + 1)
		if (pos >= 0)			//@가 두번이상 포함되어 있음
			return(false);
		}


	pos = email.indexOf('.');

	if (pos < 0)				//@가 포함되어 있지 않음
		return false;


	return(true);

}
//이메일 중복확인
function DuplicateEmailCheck(){
	var email, frm = document.myinfoForm;
	email = frm.usermail.value;

	if (email == ''){
		$("#checkMailOK").hide();
		//$("#umail").show();
		return;
	}else if (!check_form_email(email)){
		$("#checkMailOK").hide();
		$("#checkMsgEmail").show();
		$("#checkMsgEmail").html("이메일을 올바른 형식으로 입력해주세요.");
		//$("#umail").hide();
		frm.usermail.focus();
		return ;
	}else{
		//$("#umail").hide();
		var rstStr = $.ajax({
			type: "POST",
			url: "/apps/appCom/wish/web2014/member/ajaxEmailCheck.asp",
			data: "email="+email,
			dataType: "text",
			async: false
		}).responseText;

		if (rstStr == "ERR"){
			$("#checkMailOK").hide();
			$("#checkMsgEmail").html("오류가 발생했습니다.");
			$("#checkMsgEmail").show();
			chkEmail = false;
			document.myinfoForm.usermail.focus();
		}else if (rstStr == "3"){
			$("#checkMailOK").hide();
			$("#checkMsgEmail").show();
			$("#checkMsgEmail").html("이메일을 올바른 형식으로 입력해주세요.");
			chkEmail = false;
			document.myinfoForm.usermail.focus();
		}else if(rstStr == "2"){
			$("#checkMailOK").hide();
			$("#checkMsgEmail").show();
			$("#checkMsgEmail").html("이미 가입된 이메일이에요.");
			chkEmail = false;
			document.myinfoForm.usermail.focus();
		}else{
			$("#checkMsgEmail").hide();
			$("#checkMailOK").show();
			//$("#umail").hide();
			chkEmail = true;
		}
		chkAjaxEmail = true;
	}
}

// 본인인증 휴대폰SMS 발송
function sendSMS() {
	phone_format();
	var frm = document.myinfoForm;
	if(!chkID){
		alert("아이디를 확인해주세요");
		DuplicateIDCheck(frm.txuserid);
		frm.txuserid.focus();
		return;
	}

	if(!chkAjaxID){
		alert("아이디를 확인해주세요");
		DuplicateIDCheck(frm.txuserid);
		frm.txuserid.focus();
		return;
	}

	if (jsChkBlank(frm.txCell.value)){
	    alert("휴대전화 번호를 입력해주세요");
		frm.txCell.focus();
		return ;
	}

	$("#smsConfirm").show();

//	if (jsChkBlank(frm.txCell2.value) || jsChkBlank(frm.txCell3.value)){
//	    alert("휴대전화 번호를 입력해주세요");
//		frm.txCell2.focus();
//		return ;
//	}

//	if (!jsChkNumber(frm.txCell2.value) || !jsChkNumber(frm.txCell3.value)){
//	    alert("휴대전화 번호는 공백없는 숫자로 입력해주세요.");
//		frm.txCell2.focus();
//		return ;
//	}
	
//	var usrph = frm.txCell1.value + "-" + frm.txCell2.value + "-" + frm.txCell3.value;
	var usrph = frm.txCell.value;
	var rstStr = $.ajax({
		type: "POST",
		url: "/apps/appCom/wish/web2014/member/ajaxSendConfirmSMS2015.asp",
		data: "id="+frm.txuserid.value+"&ph="+usrph+"",
		dataType: "text",
		async: false
	}).responseText;
	if(rstStr=="1분 후에 다시 시도해주세요."){
		alert(rstStr);
	}else if(rstStr=="2분 후에 다시 시도해주세요."){
		alert(rstStr);
	}else{
		if(rstStr=="SMS로 받으신 인증번호를 입력해주세요."){
			$("#hpConfirmBTN").html("다시 받기");
			$("#checkMsgHP").show();
			fnRunSMSDetect();
			//$("#hpplaceholder1").hide();
			if(!chkSMS){
				$("#checkMsgHP").empty().html(rstStr);
			}else{
				$("#checkMsgHP").empty().html("다시 발송된 인증번호를 입력해주세요.");
			}
			chkSMS = true;
		}else{
			$("#checkMsgHP").show();
			$("#checkMsgHP").empty().html(rstStr);
		}
	}
    $(".num-certi-check").removeClass("disabled");
	if(rstStr.length == 31){
		$("#certNum").val("").focus();
	}	
}

function fnConfirmSMS() {
	var frm = document.myinfoForm;
	if($("#checkMsgHP").html() != "인증이 완료되었습니다."){
		if(frm.crtfyNo.value.length<6) {
			alert("휴대폰으로 받으신 인증번호를 정확히 입력해주세요.");
			frm.crtfyNo.focus();
			return;
		}
		//$("#hpplaceholder2").hide();
		$.ajax({
			type:"POST",
			url:"/apps/appCom/wish/web2014/member/ajaxCheckConfirmSMS2015.asp",
			data: "id="+frm.txuserid.value+"&chkFlag=N&key="+frm.crtfyNo.value,
			dataType: "text",
			success : function(Data){
				if (Data == "1"){
					$("#checkMsgHP").hide();
					$("#checkMsgHP").html("인증이 완료되었습니다.");
					$("#certNum").attr("readonly", true);
					$("#cellPhone").attr("readonly", true);
					$("#hpConfrim").show();
					$("#hpConfirmBTN").attr("disabled", true);
					//$("#hpConfirmBTN2").hide();
				}else if (Data == "2"){
					$("#checkMsgHP").show();
					$("#checkMsgHP").html("인증번호를 정확하게 입력해주세요.");
				}else{
					$("#checkMsgHP").show();
					$("#checkMsgHP").html("인증번호를 정확하게 입력해주세요.");
					alert("처리중 오류가 발생했습니다.["+Data+"]");
					return;
				}
			},
			error:function(err){
				$("#checkMsgHP").show();
				$("#checkMsgHP").html("인증번호를 입력해주세요.");
				alert("처리중 오류가 발생했습니다.[E99]");
				console.log(err.responseText);
				return;
			}
		});
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
	if(frm.txpass1.value.indexOf("'") > 0){
        alert("비밀번호는 특수문자(')를 포함 하실 수 없습니다.");
        frm.txpass1.focus();
        return;
    }
	<%' if snsgubun="" then %>
//	if(!chkEmail){
//		alert("이메일을 확인해주세요.");
//		frm.selfemail.focus();
//		return;
//	}
//	if (frm.selfemail.value == ""){
//		alert("이메일을 입력해주세요.");
//		frm.selfemail.focus();
//		return ;
//	}
	<%' elseif snsgubun<>"ap" then  %>
//	if (frm.selfemail.value != ""){
//		if(!chkEmail){
//			alert("이메일 중복 확인을 해주세요.");
//			return ;
//		}
//	}
	<%' end if %>
//	frm.usermail.value = frm.selfemail.value;

	if (jsChkBlank(frm.txCell.value)){
	    alert("휴대전화 번호를 입력해주세요");
		frm.txCell.focus();
		return ;
	}

//	if (jsChkBlank(frm.txCell2.value) || jsChkBlank(frm.txCell3.value)){
//	    alert("휴대전화 번호를 입력해주세요");
//		frm.txCell2.focus();
//		return ;
//	}
//	if (!jsChkNumber(frm.txCell2.value) || !jsChkNumber(frm.txCell3.value)){
//	    alert("휴대전화 번호는 공백없는 숫자로 입력해주세요.");
//		frm.txCell2.focus();
//		return ;
//	}
	<%' if snsgubun="" then %>
//	if (frm.txName.value == ""){
//		alert("성명을 입력하세요");
//		frm.txName.focus();
//		return ;
//	}
//	if (GetByteLength(frm.txName.value) > 30){
//		alert("성명은 한글 15자, 영문 30자 이내 입니다.");
//		frm.txName.focus();
//		return ;
//	}
	<%' end if %>
	<%'' if (NOT isIOSreviewSkip) then %>
//	if (!frm.txSex[0].checked&&!frm.txSex[1].checked){
//		alert("성별을 선택 해주세요");
//		frm.txSex[0].focus();
//		return ;
//	}
    <%'' end if %>
//	var txBirthday1 = $("#txBirthday1 option:selected").val();
//	var txBirthday2 = $("#txBirthday2 option:selected").val();
//	var txBirthday3 = $("#txBirthday3 option:selected").val();
//	if(txBirthday1=='0' || txBirthday2=='0' || txBirthday3=='0'){
//		$("#txBirthday1 option:selected").val('1900');
//		$("#txBirthday2 option:selected").val('1');
//		$("#txBirthday3 option:selected").val('1');
//	}

	if($("#checkMsgHP").html() != "인증이 완료되었습니다."){
	    alert("휴대폰 인증이 완료되지 않았습니다.\n인증을 완료해주세요.");
		frm.crtfyNo.focus();
		return ;
	}
	var ret = confirm('텐바이텐에 가입하시겠어요?');
	if(ret){
		frm.submit();
	}
}

function fnCheckPwd(){
    var frm = document.myinfoForm;
    var pass = frm.txpass1.value;
    var num = pass.search(/[0-9]/g);
    var eng = pass.search(/[a-z]/ig);

    if(pass.length < 8 || pass.length > 15){
		//$("#pw1").hide();
		if(num < 0 || eng < 0){
			$("#checkMsgPW").show();
			$("#checkPWOK").hide();
			$("#checkMsgPW").html("8~16자 이내의 영문/숫자 조합으로 입력해주세요.");
		}else{
			$("#checkMsgPW").show();
			$("#checkPWOK").hide();
			$("#checkMsgPW").html("8~16자 이내로 입력해주세요.");
		}
	}else{
		//$("#pw1").hide();
		if(num < 0 || eng < 0){
			$("#checkMsgPW").show();
			$("#checkPWOK").hide();
			$("#checkMsgPW").html("영문/숫자 조합으로 입력해주세요.");
		}else{
			$("#checkPWOK").show();
			$("#checkMsgPW").hide();
		}
    }
}

function chkMemPwd(){
	var frm = document.myinfoForm;
	obj_pwdChk1 = document.getElementById("checkMsgPW");
	if(frm.txpass2.value !=null && frm.txpass2.value!= "" && frm.txpass2.value != "비밀번호 확인"){
		//$("#pw2").hide();
		if(frm.txpass1.value != frm.txpass2.value){
			$("#checkMsgPWMatching").show();
			$("#checkMsgPWMatching").html("동일한 비밀번호를 입력해주세요.");
		}else{
			$("#checkPWMatchingOK").show();
			$("#checkMsgPWMatching").hide();
		}
	}else{
		$("#checkPWMatchingOK").hide();
	}
//	if(frm.txpass2.value ==null || frm.txpass2.value== "" || frm.txpass2.value == "비밀번호 확인"){
//		$("#checkMsgPW").hide();
		//$("#pw2").show();
//	}
}

function maxLengthCheck(object){
	//$("#hpplaceholder2").hide();
    if (object.value.length > object.maxLength){
        object.value = object.value.slice(0, object.maxLength);
    }
	if(object.value.length>5){
		fnConfirmSMS();
	}
}

function chkMemHP(obj){
	obj.value = obj.value.replace(/-/gi, "");
	if(obj.value.length>0){
		//$("#hpplaceholder1").hide();
		$("#hpConfirmBTN").removeClass("disabled");
		$("#hpConfirmBTN").attr("disabled",false);
	}else{
		//$("#hpplaceholder1").show();
		$("#hpConfirmBTN").addClass("disabled");
		$("#hpConfirmBTN").attr("disabled",true);
	}
	if(obj.value.length>11){
		obj.value = obj.value.slice(0,11);
	}
}

function fnAutoCertNoInput(CertNo){
	$("#certNum").val(CertNo);
	fnConfirmSMS();
}
</script>
</head>
<body style="height: 100vh;">
<div class="heightGrid bgGry">
	<div class="mainSection">
		<form name="myinfoForm" method="post" action="<%=M_SSLUrl%>/apps/appcom/wish/web2014/member/dojoin_step2.asp" onsubmit="return false;">
		<input type="hidden" name="hideventid" value="<%= ihideventid %>">
		<input type="hidden" name="email_10x10" value="<%= email_10x10 %>">
		<input type="hidden" name="smsok" value="<%= smsok %>">
		<input type="hidden" name="email_way2way" value="<%= email_way2way %>">
		<input type="hidden" name="smsok_fingers" value="<%= smsok_fingers %>">
		<input type="hidden" name="txSolar" value="Y">
		<input type="hidden" name="chkFlag" value="N">
		<input type="hidden" name="snsgubun" value="<%= snsgubun %>">
		<input type="hidden" name="snsid" value="<%= snsid %>">
		<input type="hidden" name="tokenval" value="<%= tokenval %>">
		<input type="hidden" name="sns_sexflag" value="<%= sns_sexflag %>">
		<input type="hidden" name="kakaoterms" value="<%=kakaoterms%>">
		<!-- #include virtual="/member/pop_moreInfo.asp" -->
		<div class="container">
			<div class="content" id="contentArea">
				<div class="section simpleJoinForm">
                    <div class="simpleTit">
                        <h2>30초 만에<br/>회원가입하기</h2>
                        <div class="step">
                            <span class="boll"></span>
                            <span class="bar"></span>
                            <span class="number">2</span>
                        </div>
                    </div>
                    <div class="login-form">
						<fieldset>
						<legend class="hidden">로그인 폼</legend>
							<div class="form-group first">
								<input type="text" name="txuserid" id="txuserid" value="<%= snsusermailid %>" maxlength="15" placeholder="아이디" onKeyDown="DuplicateIDCheck(this);keyCodeCheckID(event,this);" onKeyUp="DuplicateIDCheck(this);" onClick="DuplicateIDCheck(this);" onBlur="isToLowerCase(this,0); DuplicateIDCheck(this);" autocorrect="off" autocapitalize="off">
								<!-- <label for="txuserid" id="uid">아이디</label> -->
								<div class="hint" id="checkMsgID" style="display:none"></div>
								<!-- for dev msg : 입력 완료 시 노출 -->
								<span class="arrow" id="checkIDOK" style="display:none"><img src="http://fiximage.10x10.co.kr/m/2021/member/icon_member_check.png" alt="check"></span>
							</div>
							<%
								''간편로그인수정;허진원 2018.04.24
								'SNS 로그인 경유 회원가입이 아니면 비밀번호 받음(2018.04.12; 허진원)
								if (snsid ="" and snsusermail="" and snsgubun="") then
							%>
							<div class="form-group">
								<input type="password" name="txpass1" id="txpass1" maxlength="32" placeholder="비밀번호" onKeyDown="fnCheckPwd();" onKeyUp="fnCheckPwd();" onClick="fnCheckPwd();" onBlur="fnCheckPwd();">
								<!-- <label for="txpass1" id="pw1">비밀번호</label> -->
								<div class="hint" id="checkMsgPW" style="display:none"></div>
								<span class="arrow" id="checkPWOK" style="display:none"><img src="http://fiximage.10x10.co.kr/m/2021/member/icon_member_check.png" alt="check"></span>
							</div>
							<div class="form-group">
								<input type="password" name="txpass2" id="txpass2" maxlength="32" placeholder="비밀번호 확인" onKeyDown="chkMemPwd();" onKeyUp="chkMemPwd();" onClick="chkMemPwd();" onBlur="chkMemPwd();">
								<!-- <label for="txpass2" id="pw2">비밀번호 확인</label> -->
								<div class="hint" id="checkMsgPWMatching" style="display:none">비밀번호가 일치하지 않아요</div>
								<span class="arrow" id="checkPWMatchingOK" style="display:none"><img src="http://fiximage.10x10.co.kr/m/2021/member/icon_member_check.png" alt="check"></span>
							</div>
							<%
								'SNS로그인 경유일때 임의 비밀번호 설정
								else
									dim rndPwd
									Randomize()
									rndPwd = left(md5(cLng(Rnd*800000)+10000000),16)
							%>
								<input type="hidden" name="txpass1" value="<%=rndPwd%>" />
								<input type="hidden" name="txpass2" value="<%=rndPwd%>" />
							<% end if %>
							<div class="form-group">
								<input type="text" id="cellPhone" name="txCell" placeholder="휴대폰 번호" onKeyDown="chkMemHP(this);" onKeyUp="chkMemHP(this);" onClick="chkMemHP(this);">
								<!-- <label for="cellPhone" id="hpplaceholder1">휴대폰 번호</label> -->
								<!-- for dev msg : 휴대폰 번호 입력시 버튼 문구 '' 로 변경 -->
								<button type="button" class="num-check disabled" onclick="sendSMS(); return false;" id="hpConfirmBTN" disabled>인증번호 받기</button>
							</div>
							<div class="form-group" id="smsConfirm" style="display:none">
								<input type="number" name="crtfyNo" id="certNum" maxlength="6" placeholder="인증번호를 입력해주세요" onKeyDown="maxLengthCheck(this);" onKeyUp="maxLengthCheck(this);" onblur="maxLengthCheck(this);" onfocus="maxLengthCheck(this);" autocomplete="one-time-code">
								<!-- <label for="certNum" id="hpplaceholder2">인증번호를 입력해주세요</label> -->
								<div class="hint" id="checkMsgHP" style="display:none">카카오톡이나 SMS로 받은 인증번호를 입력해주세요</div>
								<span class="arrow" id="hpConfrim" style="display:none"><img src="http://fiximage.10x10.co.kr/m/2021/member/icon_member_check.png" alt="check"></span>
							</div>
							<div class="more-info">
								<button type="button" onclick="fnOpenModalMember();" id="moreinfobtn">3개만 더 입력하고 생일쿠폰 받기</button><span class="icon"><img src="http://fiximage.10x10.co.kr/m/2021/member/icon_arrow_right.png" alt="arrow"></span>
							</div>
						</fieldset>
                    </div>
                    <div class="btnGroup">
                        <input type="submit" class="btnV16a btnRed2V16a btnLarge btnBlock" id="" onclick="FnJoin10x10(); return false;" value="다음 단계">
                    </div>
				</div>
			</div>
		</div>
		</form>
	</div>
</div>
<script>
function phone_format(){
	var num = $("#cellPhone").val();
	var phone_num = num.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
	$("#cellPhone").val(phone_num);
}
<% if snsid <>"" and snsusermail<>"" and snsgubun<>"" then %>
$(function(){
	DuplicateIDCheck(document.myinfoForm.txuserid);
});
<% end if %>
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->