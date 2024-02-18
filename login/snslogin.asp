<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/membercls/snsloginCls.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
	'해더 타이틀
	strHeadTitleName = "로그인"

	Dim userid, referer
	userid = GetencLoginUserID

	dim mysns, mysnsgb, snsbackpath, snsjoingubun, itemid, blnclose
	mysns = session("snsParam")		'id-기본로그인, my-마이페이지, mc-개인정보수정확인
	mysnsgb = session("snsgbParam")	'nv-네이버, fb-페이스북, ka-카카오, gl-구글
	snsbackpath = session("snsbackpath")
	snsjoingubun = session("snsjoingubun")
	itemid = session("snsitemid")
	blnclose = "YY"

	''간편로그인수정;허진원 2018.04.24
	if Not(mysns="my" or mysns="mc") then
		If (userid<>"") Then
			Response.Write "<script type=""text/javascript"">window.close();</script>"
			response.end
		End If
	end if

	dim errormsg, fberrorcode
	errormsg = request("error")
	fberrorcode = request("error_code")
	if errormsg <> "" or fberrorcode <> "" then
		Response.Write "<script type=""text/javascript"">window.close();</script>"
		response.end
	end if

	''vType : G : 비회원 로그인포함, B : 장바구니 비회원주문 포함.
	dim vType, vLoginFail
		vType = requestCheckVar(request("vType"),1)
		vLoginFail = requestCheckVar(request("loginfail"),1)

	dim strBackPath, strGetData, strPostData
'		strBackPath = ReplaceRequestSpecialChar(request("backpath"))
		strBackPath = snsbackpath
		strBackPath = Replace(strBackPath,"^^","&")
'		strGetData  = ReplaceRequestSpecialChar(request("strGD"))
'		strPostData = ReplaceRequestSpecialChar(request("strPD"))
		strGetData  = session("strGD")
		if strGetData <> "" and itemid <> "" then
			strGetData = strGetData&"&itemid="&itemid
			blnclose = "YI"
		end if
		strPostData = session("strPD")
		if instr(strBackPath,"join_step1.asp")>0 then
			strBackPath = ""
		end if
	Dim vSavedAuto, vSavedID, vSavedPW
'		vSavedAuto = request.cookies("mSave")("SAVED_AUTO")
'		vSavedID = tenDec(request.cookies("mSave")("SAVED_ID"))
		'vSavedPW = tenDec(request.cookies("mSave")("SAVED_PW"))

'==============================================================================
dim nvid, nvaccess_token, nvemail, snstitlename, loginsnsname, reoJsns
dim nvrefresh_token, nvtoken_type, nvexpires_in
dim client_id, client_secret
dim code : code = request("code")
dim state : state = request("state")
dim snstoten : snstoten = request("snstoten")
dim tokenval : tokenval = request("tokenval")
dim redirectURI
dim url
dim kakaoTermsData, roopVal

if mysnsgb = "nv" or mysnsgb = "ka" or mysnsgb = "gl"  or mysnsgb = "fb"then
	redirectURI = M_SSLUrl&"/login/snslogin.asp"

	if tokenval<>"" then
		nvaccess_token=tokenval
	else
		Select Case mysnsgb
			Case "nv"
				snstitlename = "네이버 인증이 완료 되었습니다."
				loginsnsname = "네이버"
				client_id = "bI8tkz5b5W5IdMPD3_AN"			''테스트용 네이버앱id : 4xjaEZMGAoiudDSz06d9
				client_secret = "Tlt0EEBPWo"				''네이버 테스트용 시크릿코드 : "wdRTtRyDCA" 
				url = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code&client_id=" & client_id & "&client_secret=" & client_secret & "&redirect_uri=" & redirectURI & "&code=" & code & "&state=" & state
			Case "ka"
				snstitlename = "카카오 인증이 완료 되었습니다."
				loginsnsname = "카카오"
				If application("Svr_Info")="Dev" Then
					client_id = "63d2829d10554cdd7f8fab6abde88a1a"
					client_secret = "oS4jNWkySRuGJzSTun4TcbBb8OjsTPIB"			
				Else
					client_id = "de414684a3f15b82d7b458a1c28a29a2"
					client_secret = "IRgr5zxQEuS4uABqV30k6lik94qlk3PF"
				End If
				url = "https://kauth.kakao.com/oauth/token?grant_type=authorization_code&client_id=" & client_id & "&redirect_uri=" & redirectURI & "&code=" & code & "&client_secret=" & client_secret
			Case "gl"
				snstitlename = "구글 인증이 완료 되었습니다."
				loginsnsname = "구글"
				client_id = "614712658656-s78hbq7158i9o92f57dnoiq9env0cd9q.apps.googleusercontent.com"
				client_secret = "ha-9fm6gR4iLf4VuWglsP0Vz"
				url = "https://www.googleapis.com/oauth2/v4/token?grant_type=authorization_code&access_type=offline&client_id=" & client_id & "&client_secret=" & client_secret & "&redirect_uri=" & redirectURI & "&code=" & code
			Case "fb"
				snstitlename = "페이스북 인증이 완료 되었습니다."
				loginsnsname = "페이스북"
				client_id = "687769024739561"
				client_secret = "69f2a6ab39e64e3185e5c1c783617846"
				'grant_type=client_credentials&
				url = "https://graph.facebook.com/oauth/access_token?client_id=" & client_id & "&client_secret=" & client_secret & "&code="& code &"&redirect_uri=" & redirectURI
		End Select

		dim xml, params, res, oJrt, NvToken
		set xml = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
		xml.open "POST", url, false
		xml.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		xml.send

		If xml.Status = "200" Then
			res = xml.responseText
			on error resume next
			Set oJrt = JSON.Parse(res)
				nvaccess_token = oJrt.access_token
				if mysnsgb <> "fb" then
	'				nvrefresh_token = oJrt.refresh_token	'oJrt.id_token
					nvtoken_type = oJrt.token_type
					nvexpires_in = oJrt.expires_in
				end if
	'			Response.Write "<script type=""text/javascript"">alert('"&nvaccess_token&"');</script>"
			if err then
				response.write "error01:sns 인증을 다시 시도해 주시기 바랍니다."
				Response.Write "<script type=""text/javascript"">window.close();</script>"
				response.end
			end if
			on error goto 0
		else
			response.write "sns 인증을 다시 시도해 주시기 바랍니다."
			Response.Write "<script type=""text/javascript"">window.close();</script>"
			response.end
		end if
		Set oJrt = Nothing
		set xml = Nothing
		'==============================================================================
	end if

	'==============================================================================
	'사용자 추가 정보받기
	dim nvmessage, nvname, nvage, nvgender
	dim snsemailyn, snsidyn
	dim usercallurl

	Select Case mysnsgb
		Case "nv"
			usercallurl = "https://openapi.naver.com/v1/nid/me"
		Case "ka"
			usercallurl = "https://kapi.kakao.com/v2/user/me"
		Case "gl"
			usercallurl = "https://www.googleapis.com/oauth2/v1/tokeninfo?access_token="&nvaccess_token
		Case "fb"
			usercallurl = "https://graph.facebook.com/me?access_token="&nvaccess_token&"&fields=email,gender,age_range"
	End Select

	set xml = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
	xml.open "POST", usercallurl, false
	xml.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	xml.SetRequestHeader "Authorization", "Bearer " & nvaccess_token
	xml.send
	If xml.Status = "200" Then
		res = xml.responseText
		on error resume next
		Set oJrt = JSON.Parse(res)
			if mysnsgb = "nv" then
				nvmessage = oJrt.message
				if nvmessage = "success" then
					nvid = oJrt.response.id
					if Not ERR THEN
						nvemail = oJrt.response.email
						nvname = oJrt.response.name
						nvage = oJrt.response.age		'나이대 추가
						nvgender = oJrt.response.gender	'성별 추가
						if ERR THEN Err.Clear ''이메일과 이름이 없을 수 도 있음 > 건너뜀
					END IF
				else
					response.write "error02:sns 인증을 다시 시도해 주시기 바랍니다.."
					Response.Write "<script type=""text/javascript"">window.close();</script>"
					response.end
				end if
			elseif mysnsgb = "ka" or mysnsgb = "gl" or mysnsgb = "fb" then
				Select Case mysnsgb
					Case "ka"
						snsidyn = oJrt.id
						if Not ERR THEN
							snsemailyn = oJrt.kaccount_email
							if ERR THEN Err.Clear ''이메일이 없을 수 도 있음 > 건너뜀
						END IF
					Case "gl"
						snsidyn = oJrt.user_id
						if Not ERR THEN
							snsemailyn = oJrt.email
							if ERR THEN Err.Clear ''이메일이 없을 수 도 있음 > 건너뜀
						END IF
					Case "fb"
						snsidyn = oJrt.id
						if Not ERR THEN
							snsemailyn = oJrt.email
							nvgender = oJrt.gender
							if nvgender = "male" then
								nvgender = "M"
							elseif nvgender = "female" then
								nvgender = "F"
							else
								nvgender = ""
							end if
							if ERR THEN Err.Clear ''이메일이 없을 수 도 있음 > 건너뜀
						END IF
				End Select

				if snsidyn <> "" then	'snsemailyn <> "" and 
					nvid = snsidyn
					if Not ERR THEN
						nvemail = snsemailyn
						if ERR THEN Err.Clear ''이메일이 없을 수 도 있음 > 건너뜀
					END IF
				else
					response.write "error03:sns 인증을 다시 시도해 주시기 바랍니다.."
					Response.Write "<script type=""text/javascript"">window.close();</script>"
					response.end
				end if
			else
				response.write "error04:sns 인증을 다시 시도해 주시기 바랍니다.."
				Response.Write "<script type=""text/javascript"">window.close();</script>"
				response.end
			end if
			params = "snsid="&nvid&"&tokenval="&server.urlencode(nvaccess_token)&"&snsgubun="&mysnsgb&"&mysns="&mysns&"&snsusermail="&nvemail&"&mysnsuserid="&userid&"&snsjoingubun="&snsjoingubun

			if err then
				response.write "<script type=""text/javascript"">alert('추가권한을 해제할경우 가입에 제한이 있을 수 있습니다.');</script>"
				Response.Write "<script type=""text/javascript"">history.back();</script>"
				response.end
			end if
		on error goto 0
	end if
	Set oJrt = Nothing
	set xml = Nothing
	'===================================================

	'==============================================================================
	if mysnsgb = "gl" then
		'구글 사용자 추가 정보받기(email과 성별을 한번에 안주기때문에 성별만 따로 가져옴
		usercallurl = "https://www.googleapis.com/oauth2/v3/userinfo?access_token="&nvaccess_token

		set xml = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
		xml.open "POST", usercallurl, false
		xml.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		xml.SetRequestHeader "Authorization", "Bearer " & nvaccess_token
		xml.send

		If xml.Status = "200" Then
			res = xml.responseText
			on error resume next
			Set oJrt = JSON.Parse(res)
				if Not ERR THEN
					nvgender = oJrt.gender
					if nvgender = "male" then
						nvgender = "M"
					elseif nvgender = "female" then
						nvgender = "F"
					else
						nvgender = ""
					end if			
					if ERR THEN Err.Clear ''성별이 없을 수 도 있음 > 건너뜀
				END IF

				if err then
					response.write "<script type=""text/javascript"">alert('추가권한을 해제할경우 가입에 제한이 있을 수 있습니다.');</script>"
					Response.Write "<script type=""text/javascript"">history.back();</script>"
					response.end
				end if
			on error goto 0
		end if
		Set oJrt = Nothing
		set xml = Nothing
	end if
	'===================================================

	'==============================================================================
	if mysnsgb = "ka" then
		'카카오 싱크 관련 사용자 약관 동의 정보 가져오기
		usercallurl = "https://kapi.kakao.com/v1/user/service/terms"

		set xml = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
		xml.open "GET", usercallurl, false
		xml.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		xml.SetRequestHeader "Authorization", "Bearer " & nvaccess_token
		xml.send

		If xml.Status = "200" Then
			res = xml.responseText
			on error resume next
			Set oJrt = JSON.Parse(res)
				if Not ERR THEN
					kakaoTermsData = ""
					For roopVal=0 to oJrt.allowed_service_terms.length-1
						If roopVal = 0 Then
							kakaoTermsData = oJrt.allowed_service_terms.get(roopVal).tag&":"&oJrt.allowed_service_terms.get(roopVal).agreed_at
						Else
							kakaoTermsData = oJrt.allowed_service_terms.get(roopVal).tag&":"&oJrt.allowed_service_terms.get(roopVal).agreed_at&"|"&kakaoTermsData
						End If
					Next
					if ERR THEN Err.Clear ''카카오에서 약관 동의 관련 정보 설정 꺼놓으면 없을수도 있음 건더뜀
				END IF

				if err then
					'response.write "<script type=""text/javascript"">alert('추가권한을 해제할경우 가입에 제한이 있을 수 있습니다.');</script>"
					'Response.Write "<script type=""text/javascript"">history.back();</script>"
					'response.end
				end if
			on error goto 0
		end if
		Set oJrt = Nothing
		set xml = Nothing
	end if
	'===================================================	

	'==============================================================================
	' 텐바이텐쪽에 네이버 데이터 처리
	dim oSns
	set oSns = new cSNSLogin
		oSns.sGubun = mysnsgb
		oSns.sUserNo = nvid
		oSns.sSnsToken = nvaccess_token
		oSns.sTenUserid = userid
		oSns.sSnsPagegubun = mysns
		oSns.sEmail = nvemail
		oSns.sAge = nvage			'나이대
		oSns.sSexflag = nvgender	'성별

		if oSns.checkSNSLogin() then	'로그인처리
			if mysns = "my" then			'마이텐바이텐일경우 연동해제는 마이페이지쪽에서 따로함
				if oSns.connSNSLogin() = "OK" then
					reoJsns = "my"
				else
					reoJsns = oSns.connSNSLogin()
					reoJsns = oSns.GetErrorMsg(reoJsns)
				end if
			''간편로그인수정;허진원 2018.04.24
			elseif  mysns = "mc" then			'개인정보 수정 접근 확인
				reoJsns = oSns.connSNSLogin()
				if reoJsns="ERR01" then
					Session("InfoConfirmFlag") = userid
				    '//세션이 안먹는경우;;
					response.Cookies("uinfo").domain = "10x10.co.kr"
					response.Cookies("uinfo")("EcChk") = TenEnc(userid)    
					reoJsns = "memInfo"
				end if
			else							'로그인페이지일경우
				reoJsns = "Sns"			'연동되있으면 로그인 시킴
			end if
		else								'연동,회원가입해라
			if mysns = "my" then
				if oSns.connSNSLogin() = "OK" then
					reoJsns = "my"
				else
					reoJsns = oSns.connSNSLogin()
					reoJsns = GetErrorMsg(reoJsns)
				end if
			else
				if snsjoingubun = "ji" then
					reoJsns = "Join2"		'회원가입
				else
					reoJsns = "Join"		'회원가입 혹은 연동하기
				end if
			end if
		end if

	set oSns = Nothing
else
	response.write "sns 인증을 다시 시도해 주시기 바랍니다."
'	Response.Write "<script type=""text/javascript"">window.close();</script>"
	response.end
end if
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 로그인</title>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
<script type="text/javascript">
var valsnsid = "<%= nvid %>";
var valnickname = "";
var valusermail = "<%= Server.URLEncode(tenEnc(nvemail)) %>";
var valsexflag = "<%= nvgender %>";
var valage = "<%= nvage %>";
var valsnsgubun = "<%= mysnsgb %>";
var valtenbytenid = "";
var valsnsname = "";
var acc_token_val = "<%= server.urlencode(nvaccess_token) %>";
var valname_val = "<%= Server.URLEncode(tenEnc(nvname)) %>";
var mysns = "<%= mysns %>";
var mysnsgb = "<%= mysnsgb %>";
var kakaoterms = "<%=kakaoTermsData%>";
var snscode = "<%=code%>";
var snsstate = "<%=state%>";

function join(val) {
	var form = document.MemberJoinForm;
	form.action = "/member/join.asp";
	var param = "";
	var strURL = "";
	if (val == "snsJoin") {
		param+= "&snsid="+valsnsid;
		param+= "&usermail=" + valusermail;
		param+= "&snsusername=" + valname_val;
		param+= "&snsisusing=Y"
		param+= "&snsgubun="+valsnsgubun;
		param+= "&tenbytenid="+valtenbytenid;
		param+= "&tokenval="+acc_token_val;
		param+= "&age="+valage;
		param+= "&sexflag="+valsexflag;
		param+= "&kakaoterms="+kakaoterms;
		param+= "&code="+snscode;
		param+= "&state="+snsstate;
		strURL="<%=M_SSLUrl%>/member/join.asp?authtp=sns" + param;
		if(typeof(opener.window)=="object"){
			opener.top.location.href = strURL;
		}
		self.close();
	} 
}

function jsGoURL(strURL){
	if(typeof(opener.window)=="object"){
		opener.top.location.href = strURL;
	}	
	self.close();
}

function TnCSlogin(frm){
	if (frm.userid.value.length<1) {
		alert('보유하고 계신 텐바이텐 계정의 아이디를 입력해주세요');
		frm.userid.focus();
		return;
	}

	if (frm.userpass.value.length<1) {
		alert('보유하고 계신 텐바이텐 계정의 비밀번호를 입력해주세요');
		frm.userpass.focus();
		return;
	}

	var snsname = $("#loginsnsname").val();
	var tokenval = $("#tokenval").val();
	var snsMsg = frm.elements["userid"].value + " 아이디와 " + snsname + "계정을 연결하시겠습니까?";
	//if (confirm(snsMsg)) {
		frm.action = '<%=M_SSLUrl%>/login/dologin.asp';
		frm.submit();
	//}
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
		<% if snstoten="Y" then 'SNS 텐바이텐 로그인 연동 %>
            <div class="content" id="contentArea">
                <div class="section simpleJoinForm">
                    <div class="simpleTit">
                        <h2>한 번의 연결로<br/>자유롭게!</h2>
                    </div>
					<div class="login-form">
						<div class="txt-noti sns">
							<p>연결 한 번으로 텐바이텐 또는 SNS 계정으로<br/>자유롭게 로그인 하실 수 있습니다.</p>
						</div>
						<form name="frmLogin2" method="post" action="">
						<input type="hidden" name="backpath" value="<%=strBackPath%>">
						<input type="hidden" name="strGD" value="<%=strGetData%>">
						<input type="hidden" name="strPD" value="<%=strPostData%>">
						<input type="hidden" name="snsisusing" value="Y">
						<input type="hidden" id="loginsnsid" name="snsid" value="<%=nvid%>">
						<input type="hidden" id="snslogin" name="snslogin" value="">
						<input type="hidden" id="loginsnsgubun" name="snsgubun" value="<%=mysnsgb%>">
						<input type="hidden" id="loginsnusermail" name="snsusermail" value="<%=nvemail%>">
						<input type="hidden" id="loginsnsname" name="loginsnsname" value="<%= loginsnsname %>">
						<input type="hidden" id="tokenval" name="tokenval" value="<%=nvaccess_token%>">
						<input type="hidden" name="isopenerreload" value="on">
						<input type="hidden" name="blnclose" value="YY">
						<input type="hidden" name="snsjoingubun" value="<%= snsjoingubun %>">
						<input type="hidden" name="sns_sexflag" value="<%= nvgender %>">
						<input type="hidden" name="age" value="<%= nvage %>">
							<fieldset>
							<legend class="hidden">로그인 폼</legend>
								<div class="form-group first">
									<input type="text" name="userid" value="<%=vSavedID%>" maxlength="32" autocomplete="off" title="아이디 입력" placeholder="아이디" autocorrect="off" autocapitalize="off">
								</div>
								<div class="form-group">
									<input type="password" name="userpass" value="<%=vSavedPW%>" maxlength="32" title="비밀번호 입력" placeholder="비밀번호">
								</div>
							</fieldset>
						</form>
					</div>
					<div class="btnGroup">
						<input type="submit" class="btnV16a btnRed2V16a btnLarge btnBlock" onclick="TnCSlogin(document.frmLogin2); return false;" value="연결하기">
					</div>
				</div>
			</div>
		<% else %>
			<div class="content" id="contentArea" style="background-color:#f4f7f7;" style="display:none;">
				<div class="section snsConfirm">
					<div class="icon"><svg viewBox="0 0 20.4 18.4"><path d="M7.6,18.2C7.6,18.2,7.6,18.2,7.6,18.2c-0.5,0-0.9-0.3-1.2-0.7L0.4,7.1C0,6.5,0.3,5.7,0.9,5.3C1.6,5,2.4,5.2,2.8,5.8l5,8.6l10-13.7c0.4-0.6,1.3-0.7,1.9-0.3c0.6,0.4,0.7,1.3,0.3,1.9L8.7,17.6C8.5,18,8.1,18.2,7.6,18.2z"/></svg></div>
					<p id="snstitlename"><%= snstitlename %></p>
				</div>

				<section class="section joinType">
					<div class="sectionContent tentenMember">
						<div class="copyWrap">
							<h2 class="headline">이미 텐바이텐 회원이신가요?</h2>
							<p>로그인 후 텐바이텐 ID와 SNS 계정을 연동할 수 있습니다.</p>
						</div>
						<div class="loginFormV17">
							<form name="frmLogin2" method="post" action="">
							<input type="hidden" name="backpath" value="<%=strBackPath%>">
							<input type="hidden" name="strGD" value="<%=strGetData%>">
							<input type="hidden" name="strPD" value="<%=strPostData%>">
							<input type="hidden" name="snsisusing" value="Y">
							<input type="hidden" id="loginsnsid" name="snsid" value="<%=nvid%>">
							<input type="hidden" id="snslogin" name="snslogin" value="">
							<input type="hidden" id="loginsnsgubun" name="snsgubun" value="<%=mysnsgb%>">
							<input type="hidden" id="loginsnusermail" name="snsusermail" value="<%=nvemail%>">
							<input type="hidden" id="loginsnsname" name="loginsnsname" value="<%= loginsnsname %>">
							<input type="hidden" id="tokenval" name="tokenval" value="<%=nvaccess_token%>">
							<input type="hidden" name="isopenerreload" value="on">
							<input type="hidden" name="blnclose" value="YY">
							<input type="hidden" name="snsjoingubun" value="<%= snsjoingubun %>">
							<input type="hidden" name="sns_sexflag" value="<%= nvgender %>">
							<input type="hidden" name="age" value="<%= nvage %>">
								<fieldset>
								<legend class="hidden">로그인 폼</legend>
									<div class="field">
										<div class="inputGroup">
											<input type="text" name="userid" value="<%=vSavedID%>" onKeyPress="if (event.keyCode == 13) frmLogin2.userpass.focus();" maxlength="32" autocomplete="off" title="아이디 입력" placeholder="아이디" autocorrect="off" autocapitalize="off" />
											<input type="password" name="userpass" value="<%=vSavedPW%>" maxlength="32" title="비밀번호 입력" placeholder="비밀번호" />
										</div>
										<div class="btnGroup">
											<input type="submit" onclick="TnCSlogin(document.frmLogin2); return false;" value="로그인" class="btnV16a btnRed2V16a btnLarge btnBlock" />
										</div>
									</div>
								</fieldset>
							</form>
						</div>
					</div>

					<div class="sectionContent joinSnsConfirm">
						<div class="copyWrap">
							<h2 class="headline">SNS 인증으로 회원가입</h2>
							<p>SNS 계정으로 간편하게 텐바이텐에 가입합니다.</p>
						</div>
						<FORM name="MemberJoinForm" method="post" action="<%=M_SSLUrl%>/member/join_step1.asp" onSubmit="return false;" class="termHT">
						<input type="hidden" name="memId" value="">
						<input type="hidden" name="memNm" value="">
						<input type="hidden" name="memEmail" value="">
						<input type="hidden" name="pwd" value="">
						<input type="hidden" name="accessToken" value="">
						<input type="hidden" name="refreshToken" value="">
						<input type="hidden" name="onlySnsYn" value="N">
						<input type="hidden" name="code" value="<%=code%>">
						<input type="hidden" name="state" value="<%=state%>">
							<div class="btnGroup">
								<a href=""  onclick="join('snsJoin'); return false;" class="btnV16a btRedBdr btnLarge btnBlock cRd1">회원가입</a>
							</div>
						</form>
					</div>
				</section>
			</div>
		<% end if%>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
<script type="text/javascript">
	window.resizeTo(450, 850);
	if(mysnsgb=="nv" || mysnsgb=="ka" || mysnsgb=="gl" || mysnsgb=="fb"){
		var frm = document.frmLogin2;
		<% if reoJsns = "Sns" then %>
			<% if snsjoingubun = "ji" then %>
				alert('이미 연동된 계정 입니다.\n로그인 되었습니다.')
			<% end if %>
			$("#snslogin").val('<%= nvaccess_token %>');
			frm.action = '<%=M_SSLUrl%>/login/dologin.asp';
			frm.submit();
		<% elseif  reoJsns = "Join" then %>
			<% if snstoten<>"Y" then %>
			join('snsJoin');
			<% end if %>
			//$("#contentArea").show();
		<% elseif  reoJsns = "Join2" then %>
			join('snsJoin');
		<% elseif  reoJsns = "my" then %>
			window.opener.document.location.reload();
			self.close();
		<%
			''간편로그인수정;허진원 2018.04.24
			elseif  reoJsns = "memInfo" then
		%>
			window.opener.document.location.replace("<%=M_SSLUrl%>/my10x10/userinfo/membermodify.asp");
			self.close();
		<% else %>
			alert("<%= reoJsns %>");
			alert("SNS 인증을 다시 시도해 주시기 바랍니다.");
			self.close();
		<% end if %>
	}else{
		alert('sns구분오류');
		self.close();
	}
</script>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->