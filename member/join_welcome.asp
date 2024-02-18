<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 회원가입
' History : 2014.09.03 한용민 생성
' History : 2017.06.05 유태욱 리뉴얼
' History : 2021.07.16 정태훈 리뉴얼
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<%
'해더 타이틀
strHeadTitleName = "회원가입"

dim txUserId, evtFlag
	evtFlag = requestCheckVar(Request("eFlg"),1)
	txUserId = session("sUserid")
	'txUserId = "corpse2"

	'// appBoy CustomEvent
	appBoyCustomEvent = "appboy.logCustomEvent('userJoin');"

	'// Kakao Analytics
	kakaoAnal_AddScript = "kakaoPixel('6348634682977072419').completeRegistration();"

Dim vSavedAuto, vSavedID
	vSavedAuto = request.cookies("mSave")("SAVED_AUTO")
	vSavedID = tenDec(request.cookies("mSave")("SAVED_ID"))

Dim strsql, routeSite, useqValue
	If txUserId <> "" Then
		'// 해당 유저가 어디를 통해서 가입했는지 확인
		strsql = "Select top 1 snsgubun, tenbytenid From [db_user].[dbo].tbl_user_sns Where tenbytenid='"&txUserId&"' "
		rsget.Open strsql,dbget,1
		IF Not rsget.Eof Then
			Select Case Trim(rsget("snsgubun"))
				Case "nv"
					routeSite = "naver"
				Case "ka"
					routeSite = "kakao"
				Case "fb"
					routeSite = "facebook"
				Case "gl"
					routeSite = "google"
				Case Else
					routeSite = ""
			End Select
		Else
			routeSite = "normal"
		End IF
		rsget.close

		'// 해당 유저의 useq 값을 가져옴
		strsql = "Select top 1 useq*3 From [db_user].[dbo].tbl_logindata WITH(NOLOCK) Where userid='"&txUserId&"' "
		rsget.Open strsql,dbget,1
		IF Not rsget.Eof Then
			useqValue = rsget(0)
		Else
			useqValue = ""
		End If
		rsget.close			
	End If
%>

<!-- #include virtual="/lib/inc/head.asp" -->

<title>10x10: 가입완료</title>

<script type="application/x-javascript" src="/lib/js/iui_clickEffect.js"></script>

<% if evtFlag="C" then %>
	<script type='text/javascript'>alert('회원가입 이벤트 쿠폰이 발행 되었습니다.');</script>
<% end if %>
<script>
	<% 	If txUserId <> "" Then %>
		<%' amplitude 이벤트 로깅 %>
			fnAmplitudeEventMultiPropertiesAction('complete_signup','route','<%=routeSite%>');
		<%'// amplitude 이벤트 로깅 %>
		/*
		* Appier Event Logging
		* */
		let now = new Date();
		let month = now.getMonth()+1;
		if(month < 10){
		    month = "0" + month;
		}
        qg("event", "registration_completed", {"register_date" : now.getFullYear() + "-" + month + "-" + now.getDate(), "register_type" : "<%=routeSite%>"});

		<%' Branch Event Logging %>
			<%'// Branch Init %>
			<% if application("Svr_Info")="staging" Then %>
				branch.init('key_test_ngVvbkkm1cLkcZTfE55Dshaexsgl87iz');
			<% elseIf application("Svr_Info")="Dev" Then %>
				branch.init('key_test_ngVvbkkm1cLkcZTfE55Dshaexsgl87iz');
			<% else %>
				branch.init('key_live_hpOucoij2aQek0GdzW9xFddbvukaW6le');
			<% end if %>
			branch.logEvent(
				"complete_signup",
				function(err) { console.log(err); }
			);
		<%'// Branch Event Logging %>
	<% end if %>

function TnCSlogin(frm){
	if (frm.userid.value.length<1) {
		alert('아이디를 입력해주세요.');
		frm.userid.focus();
		return false;
	}

	if (frm.userpass.value.length<1) {
		alert('비밀번호를 입력해주세요.');
		frm.userpass.focus();
		return false;
	}

	frm.action = '<%=M_SSLUrl%>/login/dologin.asp';
    frm.submit();
	return true;
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div id="content" class="content">

				<div class="welcomeV21New">
					<div class="main">
						<img src="http://fiximage.10x10.co.kr/m/2021/member/bg_confirm.png" alt="가입이 완료 되었습니다.">
						<p class="txt-welcome"><span><%=txUserId%>님</span>을 위한 위한 웰컴 마일리지와<br/>3종 쿠폰이 발급되었으니 <span>24시간 이내</span>에 꼭 사용해보세요</p>
						<div class="coupon-welcome">
							<div class="type">
								<img src="http://fiximage.10x10.co.kr/m/2021/member/bg_coupon_type02.png" alt="쿠폰">
								<p class="price red">2,000<span>p</span></p>
								<p class="priceEx red">3만원 이상 구매 시</p>
							</div>
							<div class="type">
								<img src="http://fiximage.10x10.co.kr/m/2021/member/bg_coupon_type01.png" alt="쿠폰">
								<p class="price">30,000<span>원</span></p>
								<p class="priceEx">30만원 이상 구매 시</p>
							</div>
							<div class="type">
								<img src="http://fiximage.10x10.co.kr/m/2021/member/bg_coupon_type01.png" alt="쿠폰">
								<p class="price">10,000<span>원</span></p>
								<p class="priceEx">15만원 이상 구매 시</p>
							</div>
							<div class="type">
								<img src="http://fiximage.10x10.co.kr/m/2021/member/bg_coupon_type01.png" alt="쿠폰">
								<p class="price">5,000<span>원</span></p>
								<p class="priceEx">7만원 이상 구매 시</p>
							</div>
						</div>
						<div class="noti">
							<p class="tit">잠깐, 여기서 끝이 아니에요!</p>
							<p class="sub">더 많은 추가 혜택이 준비되어 있으니<br/>
								놓치지 말고 꼭 확인해보세요!</p>
						</div>
					</div>
					<div class="joinNewLogin">
						<div class="tit">
							<h2>지금 로그인하고<br/>
								혜택을 확인하세요</h2>
						</div>
						<div class="login-form">
							<form name="frmLogin2" method="post" onSubmit="return TnCSlogin(this);">
							<input type="hidden" name="backpath" value="/event/benefit/">
							<input type="hidden" name="userid" value="<%=txUserId%>">
								<fieldset>
								<legend class="hidden">로그인 폼</legend>
									<div class="form-group">
										<input type="password" name="userpass" id="password" placeholder="아이디 <%=txUserId%>의 비밀번호를 입력해주세요" autocorrect="off" autocapitalize="off" required>
										<!-- <label for="password">아이디 <%=txUserId%>의 비밀번호를 입력해주세요</label> -->
									</div>
									<div class="auto-login"><input type="checkbox" name="saved_auto" id="autoLogin" value="o" <% If vSavedAuto <> "" Then Response.Write "checked" End If %>> <label for="autologin">로그인 유지</label></div>
									<% if session("chkLoginLock") then %>
									<div class="loginLimitV15a">
										<div class="txtBoxV15a">ID/PW 입력 오류로 인해 로그인이 제한되었습니다.<br>개인정보 보호를 위해 아래 항목을 입력해주세요.</div>
										<div class="ct">
											<script src="https://www.google.com/recaptcha/api.js" async defer></script>
											<div id="g-recaptcha" class="g-recaptcha" data-sitekey="6LdSrA8TAAAAAD0qwKkYWFQcex-VzjqJ6mbplGl6"></div>
											<style>
											.g-recaptcha {margin:0 auto; padding:0; transform-origin:0 0; -webkit-transform-origin:0 0;}
											.g-recaptcha > div {margin:0 auto;}
											.g-recaptcha > div > div {width:100% !important;}
											</style>
										</div>
									</div>
									<% end if %>
									<div class="btn-group">
										<input type="submit" value="로그인하기" class="btn btn-red btn-xlarge btn-block" onclick="TnCSlogin(frmLogin2); fnAmplitudeEventMultiPropertiesAction('click_login_button', 'action|autologin', 'nomal|<% If vSavedAuto <> "" Then Response.write "on" Else Response.write "off" End If %>'); return false;">
									</div>
									<div class="btn-gohome"><a href="/">홈으로 가기</a><span class="icon"><img src="http://fiximage.10x10.co.kr/m/2021/member/icon_arrow_right.png" alt="arrow"></span></div>
								</fieldset>
							</form>
						</div>
						
					</div>
				</div>

			</div>	
			<!-- //content area -->
			<%
			'페이스북 스크립트 incFooter.asp에서 출력; 2016.01.15 허진원 추가
			facebookSCRIPT = "<script>" & vbCrLf &_
							"!function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;" & vbCrLf &_
							"n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;" & vbCrLf &_
							"t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,document,'script','//connect.facebook.net/en_US/fbevents.js');" & vbCrLf &_
							"fbq('init', '260149955247995');" & vbCrLf &_
							"fbq('init', '889484974415237');" & vbCrLf &_
							"fbq('track','PageView');" & vbCrLf &_
							"fbq('track', 'CompleteRegistration');</script>" & vbCrLf &_
							"<noscript><img height=""1"" width=""1"" style=""display:none"" src=""https://www.facebook.com/tr?id=260149955247995&ev=PageView&noscript=1"" /></noscript>" & vbCrLf &_
							"<noscript><img height=""1"" width=""1"" style=""display:none"" src=""https://www.facebook.com/tr?id=889484974415237&ev=PageView&noscript=1"" /></noscript>"														
			%>
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
<%' 크레센도 스크립트 추가 %>
<script type="text/javascript"> csf('event','2','',''); </script>
<%'// 크레센도 스크립트 추가 %>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->