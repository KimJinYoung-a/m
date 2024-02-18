<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description :  로그인
' History : 2014.09.01 허진원 리뉴얼
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'해더 타이틀
strHeadTitleName = "로그인"

dim userid
	userid = GetLoginUserID

if (userid<>"") then
	response.redirect "/"
    dbget.Close : response.end ''2015/04/21
end if

''vType : G : 비회원 로그인포함, B : 장바구니 비회원주문 포함.
dim vType, vLoginFail, typegb
	vType = requestCheckVar(request("vType"),1)
	typegb = requestCheckVar(request("typegb"),2)
	vLoginFail = requestCheckVar(request("loginfail"),1)

dim strBackPath, strGetData, strPostData
	strBackPath = ReplaceRequestSpecialChar(request("backpath"))
	strBackPath = Replace(strBackPath,"^^","&")
	strGetData  = ReplaceRequestSpecialChar(request("strGD"))
	strPostData = ReplaceRequestSpecialChar(request("strPD"))

Dim vSavedAuto, vSavedID, vSavedPW
	vSavedAuto = request.cookies("mSave")("SAVED_AUTO")
	vSavedID = tenDec(request.cookies("mSave")("SAVED_ID"))
	'vSavedPW = tenDec(request.cookies("mSave")("SAVED_PW"))

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 로그인</title>
<script type="text/javascript">
$(function(){
	$(".btnGroupSocial").each(function(){
		var checkItem = $(this).children("ul").children("li").length;
		if (checkItem == 1) {
			$(this).children("ul").children("li").addClass("full");
		}
	});
});

if(!navigator.cookieEnabled) alert("쿠키를 허용해주세요.\n쿠키가 허용되어야 로그인을 하실 수 있습니다.");

function TnCSlogin(frm){
	if (frm.userid.value.length<1) {
		alert('아이디를 입력하세요.');
		frm.userid.focus();
		return false;
	}

	if (frm.userpass.value.length<1) {
		alert('패스워드를 입력하세요.');
		frm.userpass.focus();
		return false;
	}

	frm.action = '<%=M_SSLUrl%>/login/dologin.asp';
    frm.submit();
	return true;
}

function TnDoGuestLogin(frm){
    if (frm.orderserial.value.length<1) {
    	alert('주문번호를 입력하세요.');
    	frm.orderserial.focus();
    	return;
    }

    if (frm.buyemail.value.length<1) {
    	alert('구매자 이메일을 입력하세요.');
    	frm.buyemail.focus();
    	return;
    }

    frm.action = '<%=wwwUrl%>/login/doguestlogin.asp';
    frm.submit();
}

function Nonmember(frm) {
	frm.action = '<%=wwwUrl%>/inipay/nonmember.asp';
	frm.submit();
}

function fnPopSNSLogin(snsgb,wd,hi) {
	var snsbackpath = '<%=strBackPath%>';
	var popup = window.open("/login/mainsnslogin.asp?snsdiv="+snsgb+"&pggb=id&snsbackpath="+snsbackpath,"","width=600, height=800");
}
</script>
</head>
<body style="background-color:#f4f7f7;">
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<% if (typegb<>"NM") then %>
				<div class="content" id="contentArea" style="background-color:#f4f7f7;">
					<div class="loginFormV17">
						<% if vType<>"B" Then %>
							<div class="blocklink">
								<a href="/login/login.asp?typegb=NM" class="btnFlat">비회원 주문조회</a>
							</div>
						<% end if %>

						<form name="frmLogin2" method="post" onSubmit="return TnCSlogin(this);">
						<input type="hidden" name="backpath" value="<%=strBackPath%>">
						<input type="hidden" name="strGD" value="<%=strGetData%>">
						<input type="hidden" name="strPD" value="<%=strPostData%>">
							<fieldset>
							<legend class="hidden">로그인 폼</legend>
								<div class="field">
									<div class="inputGroup">
										<input type="text" name="userid" value="<%=vSavedID%>" onKeyPress="if (event.keyCode == 13) frmLogin2.userpass.focus();" maxlength="32" autocomplete="off" title="아이디 입력" placeholder="아이디" autocorrect="off" autocapitalize="off" />
										<input type="password" name="userpass" value="<%=vSavedPW%>" onKeyPress="if (event.keyCode == 13) TnCSlogin(frmLogin2);" maxlength="32" title="비밀번호 입력" placeholder="비밀번호" />
									</div>
									<% if session("chkLoginLock") then %>
									<div class="loginLimitV15a">
										<div class="txtBoxV15a">ID/PW 입력 오류로 인해 로그인이 제한되었습니다.<br />개인정보 보호를 위해 아래 항목을 입력해주세요.</div>
										<div class="tMar05 ct">

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
									<div class="btnGroup">
										<input type="submit" onclick="TnCSlogin(frmLogin2); return false;" value="로그인" class="btnV16a btnRed2V16a btnLarge btnBlock" />
									</div>
									<div class="formfield">
										<input type="checkbox" name="saved_auto" id="autoLogin" value="o" <% If vSavedAuto <> "" Then Response.Write "checked" End If %> class="frmCheckV16" /> <label for="autoLogin">자동 로그인</label>
									</div>
								</div>
							</fieldset>
						</form>
					</div>

					<div class="snsLogin">
						<h2><span>SNS 로그인</span></h2>
						<div class="btnGroup btnGroupSocial">
							<ul>
								<li><a href="" onclick="fnPopSNSLogin('nv','400','800');return false;"  class="btnNaver"><svg viewBox="0 0 89.5 79"><path d="M31.2,39.1C36.4,46.7,58.5,79,58.5,79h30.9V0H58.5l-0.1,41C52,31.4,31.2,0,31.2,0H0.2v79h30.9L31.2,39.1z"/></svg>네이버</a></li>
								<%' <li><a href="" onclick="fnPopSNSLogin('fb','410','300');return false;" class="btnFacebook"><svg viewBox="0 0 19.7 42.3"><path d="M13.1,42.3H4.4V21.2H0v-7.3h4.4V9.5c0-6,2.5-9.5,9.5-9.5h5.8v7.3H16c-2.7,0-2.9,1-2.9,2.9l0,3.7 h6.6L19,21.2h-5.8V42.3z"/></svg>페이스북</a></li> %>
								<%' <li><a href="" onclick="fnPopSNSLogin('ka','410','300');return false;" class="btnKakao"><svg viewBox="0 0 59.4 53"><path d="M29.2,0C12.7,0,0,10.2,0,22.8c0,8,5,15.1,13.2,19.1l-2.8,10.1c-0.1,0.3,0,0.6,0.2,0.9 C10.8,53,11,53,11.3,53c0.2,0,0.4-0.1,0.5-0.2l12-7.8c1.8,0.2,3.6,0.4,5.4,0.4c16.4,0,30.3-10.1,30.3-22.6S45.6,0,29.2,0z"/></svg>카카오</a></li> %>
								<%' <li><a href="" onclick="fnPopSNSLogin('gl','410','300');return false;" class="btnGoogle"><svg viewBox="0 0 348.9 356"><path d="M345.7,145.7H178v68.9h95.8c-4.1,22.3-16.7,41.1-35.4,53.7l-0.1-0.1c-15.9,10.7-36.3,17-60.3,17c-46.4,0-85.6-31.3-99.6-73.4l0,0c-3.6-10.7-5.6-22.1-5.6-33.8s2-23.1,5.6-33.8c14-42.1,53.2-73.4,99.6-73.4c26.1,0,49.6,9,68,26.6l51.1-51.1C266.3,17.6,226,0,178,0C108.4,0,48.2,39.9,18.9,98.1C6.9,122.1,0,149.3,0,178s6.9,55.9,18.9,79.9v0.1c29.3,58.1,89.5,98,159.1,98c48,0,88.3-15.9,117.7-43h0.1c33.7-31.1,53.1-76.7,53.1-130.9C348.9,169.5,347.8,157.3,345.7,145.7z"/></svg>구글</a></li> %>
							</ul>
						</div>
					</div>

					<div class="links">
						<a href="/member/find_idpw.asp?t=id">아이디 찾기</a>
						<a href="/member/find_idpw.asp?t=pw">비밀번호 찾기</a>
						<a href="/member/join.asp">회원가입</a>
					</div>
				</div>
				<!-- //content area -->

			<% else %>
				<!-- content area -->
				<div class="content" id="contentArea" style="background-color:#f4f7f7;">
					<div class="loginFormV17">
						<div class="field">
							<form name="frmLoginGuest" method="post" action="">
							<input type="hidden" name="backpath" value="<%=strBackPath%>">
							<input type="hidden" name="strGD" value="<%=strGetData%>">
							<input type="hidden" name="strPD" value="<%=strPostData%>">
								<fieldset>
								<legend class="hidden">로그인 폼</legend>
									<div class="inputGroup">
										<input type="number" name="orderserial" maxlength="11" autocomplete="off" id="login_input" onKeyPress="if (event.keyCode == 13) frmLoginGuest.buyemail.focus();" title="주문번호 입력" placeholder="주문번호" />
										<input type="email" name="buyemail" onKeyPress="if (event.keyCode == 13) TnDoGuestLogin(frmLoginGuest);" maxlength="128" autocomplete="off" title="주문고객 이메일 입력" placeholder="주문고객 이메일" />
									</div>
									<div class="btnGroup">
										<input type="submit" value="비회원 로그인" onclick="TnDoGuestLogin(frmLoginGuest); return false;" class="btnV16a btnRed2V16a btnLarge btnBlock" />
									</div>
								</fieldset>
							</form>
						</div>
					</div>

					<div class="links">
						<a href="/member/find_idpw.asp?t=id">아이디 찾기</a>
						<a href="/member/find_idpw.asp?t=pw">비밀번호 찾기</a>
						<a href="/member/join.asp">회원가입</a>
					</div>
				</div>
				<!-- //content area -->
			<% end if %>
			<%
			'/신규회원 이벤트 배너(6월부터 배너이미지 통일, 링크만 수정)
			dim NewUserEvtcode
			If Date() >= "2016-11-01" And Date() < "2016-12-01" Then	'11월 신규가입
				NewUserEvtcode = 73892
			elseif Date() >= "2016-12-01" And Date() < "2017-01-01" Then	'12월 신규가입
				NewUserEvtcode = 74620
			elseif Date() >= "2017-01-01" And Date() < "2017-02-01" Then	'1월 신규가입
				NewUserEvtcode = 75258
			elseif Date() >= "2017-02-01" And Date() < "2017-03-01" Then	'2월 신규가입
				NewUserEvtcode = 75890
			elseif Date() >= "2017-03-01" And Date() < "2017-04-01" Then	'3월 신규가입
				NewUserEvtcode = 76495
			elseif Date() >= "2017-05-01" And Date() < "2017-06-01" Then	'5월 신규가입
				NewUserEvtcode = 77665	
			elseif Date() >= "2017-06-01" And Date() < "2017-07-01" Then	'6월 신규가입
				NewUserEvtcode = 78243	
			end If
			%>
			<% if Date() >= "2017-05-01" then %>
				<div class="tMar25">
					<a href="/event/eventmain.asp?eventid=<%= NewUserEvtcode %>">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/70939/m/bnr_new_v2.png" alt="신규회원 이벤트 쿠폰 받으러가기" />
					</a>
				</div>
			<% end if %>
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->