<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 회원가입
'	History	:  2014.01.08 한용민 생성
'	History	:  2014-12-02 [럭키백]크리스박스의 기적 이미지추가 유태욱
'			   request.cookies("etc")("evtcode") = "57117"
'	History	:  2014-12-16 크리스머니의 기적 추가 원승현, 기존 57117을 57691로 변경
'			   request.cookies("etc")("evtcode") = "57691"
'	History	:  2016-01-18 소스 최하단에 FaceBook 분석용 커스텀펑션 추가 김동현
'	History	:  2017-06-05 유태욱 리뉴얼
'#######################################################
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim txUserId, evtFlag
	evtFlag = requestCheckVar(Request("eFlg"),1)
	txUserId = session("sUserid")

	'// appBoy CustomEvent
	appBoyCustomEvent = "userJoin"

Dim vSavedAuto, vSavedID
	vSavedAuto = request.cookies("mSave")("SAVED_AUTO")
	vSavedID = tenDec(request.cookies("mSave")("SAVED_ID"))

Dim routeSite, strsql, useqValue
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
				Case "ap"
					routeSite = "apple"
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

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

<script type="application/x-javascript" src="/lib/js/iui_clickEffect.js"></script>

<% if evtFlag="C" then %>
	<script type='text/javascript'>alert('회원가입 이벤트 쿠폰이 발행 되었습니다.');</script>
<% end if %>
<script>
$(function(){
    fnAPPchangPopCaption('');
});
function fnGetAppVersion() {
	var isMobile = {
			Android: function () {
					 return (/Android/i).test(navigator.userAgent);
			},
			BlackBerry: function () {
					 return (/BlackBerry/i).test(navigator.userAgent);
			},
			iOS: function () {
					 return (/iPhone|iPad|iPod/i).test(navigator.userAgent);
			},
			Opera: function () {
					 return (/Opera Mini/i).test(navigator.userAgent);
			},
			Windows: function () {
					 return (/IEMobile/i).test(navigator.userAgent);
			},
			any: function () {
					 return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
			}
	};
	callNativeFunction('getDeviceInfo', {"callback": function(deviceInfo) {
		if (isMobile.iOS())
		{
			if (deviceInfo.version >= 4.031)
			{
				$("#joinlogin").show();
				$("#joinhome").hide();
			}
			else
			{
				$("#joinhome").show();
				$("#joinlogin").hide();
			}
		}
		if (isMobile.Android())
		{
			if (deviceInfo.version >= 99255)
			{
				$("#joinlogin").show();
				$("#joinhome").hide();
			}
			else
			{
				$("#joinhome").show();
				$("#joinlogin").hide();
			}
		}
	}});
}
function TnCSlogin2(frm){
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
	if($("input:checkbox[name=saved_auto]").is(":checked") == true) {
		setTimeout(function () { fnRequestLogin(frm.userid.value,frm.userpass.value,true)}, 1500);
	}else{
		setTimeout(function () { fnRequestLogin(frm.userid.value,frm.userpass.value,false)}, 1500);
	}
	return true;
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div id="content" class="content">
			<div class="welcomeV21New">
				<div class="main">
					<img src="http://fiximage.10x10.co.kr/m/2021/member/bg_confirm.png" alt="가입이 완료 되었습니다.">
					<p class="txt-welcome"><span><%=txUserId%>님</span>을 위한 위한 웰컴 마일리지와 3종 쿠폰이<br/> 발급되었으니 <span>24시간 이내</span>에 꼭 사용해보세요</p>
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
				<div class="joinNewLogin" id="joinlogin" style="display:none">
					<div class="tit">
						<h2>지금 로그인하고<br/>
							혜택을 확인하세요</h2>
					</div>
					<div class="login-form">
						<form name="frmLogin2" method="post">
						<input type="hidden" name="backpath" value="/apps/appcom/wish/web2014/event/benefit/">
						<input type="hidden" name="userid" value="<%=txUserId%>">
							<fieldset>
							<legend class="hidden">로그인 폼</legend>
								<div class="form-group">
									<input type="password" name="userpass" id="password" placeholder="아이디 <%=txUserId%>의 비밀번호를 입력해주세요" autocorrect="off" autocapitalize="off" required>
									<!-- <label for="password">아이디 <%=txUserId%>의 비밀번호를 입력해주세요</label> -->
								</div>
								<div class="auto-login"><input type="checkbox" name="saved_auto" id="autoLogin" value="o" <% If vSavedAuto <> "" Then Response.Write "checked" End If %>> <label for="autologin">로그인 유지</label></div>
								<div class="btn-group">
									<input type="submit" value="로그인하기" class="btn btn-red btn-xlarge btn-block" onclick="TnCSlogin2(frmLogin2); fnAmplitudeEventMultiPropertiesAction('click_login_button', 'action|autologin', 'nomal|<% If vSavedAuto <> "" Then Response.write "on" Else Response.write "off" End If %>');return false;">
								</div>
								<div class="btn-gohome"><a href="/">홈으로 가기</a><span class="icon"><img src="http://fiximage.10x10.co.kr/m/2021/member/icon_arrow_right.png" alt="arrow"></span></div>
							</fieldset>
						</form>
					</div>
				</div>

				<div class="joinNewLogin" id="joinhome" style="display:none">
					<div class="login-form">
						<div class="btn-gohome"><a href="" onclick="callgotoday(); return false;">홈으로 가기</a><span class="icon"><img src="http://fiximage.10x10.co.kr/m/2021/member/icon_arrow_right.png" alt="arrow"></span></div>
					</div>
				</div>

			</div>
		</div>		
		<!-- //content area -->
	</div>
</div>
<script type="text/javascript">
	<%' amplitude 이벤트 로깅 %>
		setTimeout("fnAPSignUpEvent('<%=useqValue%>');", 1000);
		//setTimeout("fnAmplitudeEventMultiPropertiesAction('complete_signup','route|retrieved_user_id','<%=routeSite%>|<%=useqValue%>','');", 3700);
	<%'// amplitude 이벤트 로깅 %>
	$(function() {
		//창 타이틀 변경
		setTimeout(function(){
			fnAPPchangPopCaption("가입완료");
		}, 100);
	});
$(function(){
	<% if routeSite="normal" or routeSite="" then %>
	fnGetAppVersion();
	<% else %>
	$("#joinhome").show();
	<% end if %>	
});

</script>
</body>
</html>
<%
	vAdrVer = mid(uAgent,instr(uAgent,"tenapp")+8,5)
	if Not(isNumeric(vAdrVer)) then vAdrVer=1.0
	
	if (flgDevice="I" and vAdrVer>="1.984") or (flgDevice="A" and vAdrVer>="1.79") then
%>
<script type="text/javascript">callNativeFunction('doFBAction', {'join':'1'}); </script>
<% 
	end if 
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->