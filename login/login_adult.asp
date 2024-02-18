<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description :  로그인
' History : 2014.09.01 허진원 리뉴얼
' History : 2017.12.01 원승현 수정
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/member/iPin/nice.nuguya.oivs.asp" -->

<%
Response.Charset = "utf-8"
	Dim C_dumiKey : 

	'#######################################################################################
	'#####	개인인증키(대체인증키;아이핀) 서비스				한국신용정보(주)
	'#######################################################################################
	Dim NiceId, SIKey, ReturnURL, pingInfo, strOrderNo
	'// 텐바이텐
	NiceId = "Ntenxten4"		'// 회원사 ID
	SIKey = "N0001N013276"		'// 사이트식별번호 12자리

	'randomize(time())
	strOrderNo = Replace(date, "-", "")  & round(rnd*(999999999999-100000000000)+100000000000)

	'// 해킹방지를 위해 요청정보를 세션에 저장
	session("niceOrderNo") = strOrderNo




'해더 타이틀
strHeadTitleName = "로그인"


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

dim adultProductIdForApp 
adultProductIdForApp = Request.QueryString("adtprdid")

dim tabFlag 
tabFlag = IsUserLoginOK() 
if adultProductIdForApp <> "" then
	tabFlag = true
end if

'///로그인 분기처리 (TAB BAR)
Dim bp : bp = chkiif(strBackPath<>"", strBackPath, "/")
Dim footflag : footflag = False

	session("adultProductId") = adultProductIdForApp
	session("backpath") = bp
		
	if (IsUserLoginOK() And session("isAdult") = True) then	
		if isApp = 1 then
			dbget.Close : response.redirect "/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=" & adultProductIdForApp
		else
			dbget.Close : response.redirect bp				
		end if		
	end if

	If InStr(bp,"mymain.asp") > 0 Or InStr(bp,"myorderlist.asp") > 0 Or InStr(bp,"myrecentview.asp") > 0 Then
		footflag = true
	End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<%
If isApp <> 0 Then
%>
	<script src="/apps/appCom/wish/web2014/lib/js/customapp.js?v=1.01"></script>
	
	<script type="text/javascript">

	if(!navigator.cookieEnabled) alert("쿠키를 허용해주세요.\n쿠키가 허용되어야 로그인을 하실 수 있습니다.");

	function Nonmember(frm) {
		//frm.action = '<%=wwwUrl%>/apps/appCom/wish/web2014/inipay/nonmember.asp';
		frm.action = '/login/dobagunilogin.asp';
		frm.chkAgree.value="Y";
		frm.submit();
	}

	function NonmemberLogin(frm) {
		frm.action = '<%=wwwUrl%>/apps/appCom/wish/web2014/login/login_nonmember.asp';
		frm.submit();
	}

	function popFindIDPW() {
		fnAPPpopupBrowserURL("아이디/비밀번호 찾기","<%=wwwUrl%>/apps/appCom/wish/web2014/member/find_idpw.asp?t=id");
	}

	function popMemJoin() {
		fnAPPpopupBrowserURL("회원가입","<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp");
	}
	</script>

<%else%>
	
	<title>10x10: 로그인</title>
	<script type="text/javascript">
	$(function(){
		$(".btnGroupSocial").each(function(){
			var checkItem = $(this).children("ul").children("li").length;
			if (checkItem == 1) {
				$(this).children("ul").children("li").addClass("full");
			}
		});

		fnAmplitudeEventAction("view_login","","");
	});

	if(!navigator.cookieEnabled) alert("쿠키를 허용해주세요.\n쿠키가 허용되어야 로그인을 하실 수 있습니다.");

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

	function TnDoGuestLogin(frm){
		if (frm.orderserial.value.length<1) {
			alert('주문완료 후 발급받은 주문번호를 입력해주세요.');
			frm.orderserial.focus();
			return;
		}

		if (frm.buyemail.value.length<1) {
			alert('주문 시 입력한 주문고객의 이메일을 입력해주세요.');
			frm.buyemail.focus();
			return;
		}

		frm.action = '<%=wwwUrl%>/login/doguestlogin.asp';
		frm.submit();
	}

	function Nonmember(frm) {
		//frm.action = '/inipay/nonmember.asp';
		frm.chkAgree.value="Y";
		frm.action = '/login/dobagunilogin.asp';
		frm.submit();
	}

	function fnPopSNSLogin(snsgb,wd,hi) {
		var snsbackpath = '<%=strBackPath%>';
		var popup = window.open("/login/mainsnslogin.asp?snsdiv="+snsgb+"&pggb=id&snsbackpath="+snsbackpath,"","width=600, height=800");
	}

		function chkAgreement() {
			gfrm = document.frmLoginGuest;

		}
	</script>
<%End if%>
</head>
<body class="default-font body-sub body-1depth bg-grey">
<%If isApp = 0 then%>
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
<%End if%>
<!-- contents -->
	<div id="content" class="content">
		<div class="alert-text adult-text">
			<div class="inner">
				<strong>19세 미만의 청소년 접근이 제한된 정보로 본인인증이 필요합니다.</strong>
				<p>이 정보는 청소년 유해매체물로서 정보통신망이용촉진 및 정보보호 등에 관한 법률 및 청소년보호법의 규정에 의하여 19세 미만의 청소년이 이용할 수 없습니다.</p>
				<p>이 상품은 <span class="color-red">비회원 주문이 불가</span>합니다.</p>
			</div>
		</div>
	<% if (typegb<>"NM") then %>
		<% if (vType="B") then %>
			<form name="frmLogin4" method="post" action="">
				<input type="hidden" name="backpath" value="/login/login_adult.asp">
				<input type="hidden" name="strGD" value="<%=strGetData%>">
				<input type="hidden" name="strPD" value="<%=strPostData%>">
				<input type="hidden" name="chkAgree" value="N" />
			</form>
		<% End If %>
		<div class="login-form">
			<div class="nav nav-stripe-top nav-stripe-large nav-stripe-red">
				<ul class="grid2">
					<li><a href="javascript:void(0);" <%=chkiif(tabFlag,"","class='on'")%>>STEP 1<br /><strong>로그인</strong></a></li>
					<li><a href="javascript:void(0);" <%=chkiif(tabFlag,"class='on'","")%>>STEP 2<br /><strong>성인 본인인증</strong></a></li>
				</ul>
			</div>
			<!-- STEP1 로그인 내용 -->
			<%If tabFlag <> true then%>
			<div id="basicLogin" class="login-input-cont">
				<form name="frmLogin2" method="post" onSubmit="return TnCSlogin(this);">
					<input type="hidden" name="backpath" value="/login/login_adult.asp?backpath=<%=server.urlencode(strBackPath)%>">
					<input type="hidden" name="strGD" value="<%=strGetData%>">
					<input type="hidden" name="strPD" value="<%=strPostData%>">
					<fieldset>
					<legend class="hidden">로그인 폼</legend>
						<div class="form-group">
							<input type="text" name="userid" id="id" autocorrect="off" autocapitalize="off" value="<%=vSavedID%>" onKeyPress="if (event.keyCode == 13) frmLogin2.userpass.focus();" maxlength="32" required />
							<label for="id">아이디</label>
						</div>
						<div class="form-group">
							<input type="password" name="userpass" id="password" autocorrect="off" autocapitalize="off" value="<%=vSavedPW%>" onKeyPress="if (event.keyCode == 13) TnCSlogin(frmLogin2);" maxlength="32" required />
							<label for="password">비밀번호</label>
						</div>
						<div class="auto-login">
							<input type="checkbox" name="saved_auto" id="autoLogin" value="o" <% If vSavedAuto <> "" Then Response.Write "checked" End If %> /> <label for="autologin">로그인 유지</label>
						</div>
						<% if session("chkLoginLock") then %>
						<div class="loginLimitV15a">
							<div class="txtBoxV15a">ID/PW 입력 오류로 인해 로그인이 제한되었습니다.<br />개인정보 보호를 위해 아래 항목을 입력해주세요.</div>
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
							<input type="submit" onclick="TnCSlogin(frmLogin2); fnAmplitudeEventMultiPropertiesAction('click_login_button', 'action|autologin', 'nomal|<% If vSavedAuto <> "" Then Response.write "on" Else Response.write "off" End If %>'); return false;" value="로그인" class="btn btn-red btn-xlarge btn-block" />
						</div>
						<div class="login-utility">
							<div class="utility-link">
								<a href="/member/join.asp">회원가입</a>
								<a href="/member/find_idpw.asp?t=id">아이디/비밀번호 찾기</a>
							</div>
						</div>
					</fieldset>
				</form>
			</div>
			<%else%>
			<!-- STEP2 성인 본인인증 내용 -->
			<div id="adultCertify" class="login-input-cont adult-cont">
				<p>본인명의 휴대폰 번호로 <br />인증이 가능합니다.</p>
				<div class="btn-group" onclick=jsOpenCert()>
					<input type="submit" value="휴대폰 인증" class="btn btn-red btn-xlarge btn-block"  />
				</div>
				<span>인증 후 1년간은 별도 인증단계 없이 이용하실 수 있습니다.</span>
			</div>
			<form name="reqMobiForm" method="post" action=""></form>
			<script>		
				function jsOpenCert() {
					<%If isApp = 0 then%>
						var popupWindow = window.open( "", "KMCISWindow", "width=425, height=550, resizable=0, scrollbars=no, status=0, titlebar=0, toolbar=0, left=435, top=250" );
						document.reqMobiForm.action = '/member/popCheckWhoAmI.asp';
						document.reqMobiForm.target = "KMCISWindow";
						document.reqMobiForm.submit();
						popupWindow.focus();
					<%else%>
						document.reqMobiForm.action = '/member/popCheckWhoAmI.asp';
						document.reqMobiForm.submit();
					<%end if%>
				}
			</script>
			<%End if%>
		</div>

		
		<%If tabFlag <> True then%>
		<div class="sns-login">
			<h2>다음 계정으로 로그인 / 회원가입</h2>
			<ul class="sns-accountV20">
				<li class="kakao"><a href="" onclick="fnPopSNSLogin('ka','470','570');fnAmplitudeEventMultiPropertiesAction('click_login_button', 'action|autologin', 'kakao|<% If vSavedAuto <> "" Then Response.write "on" Else Response.write "off" End If %>');return false;"><i class="icon"></i><span class="text">카카오톡</span></a></li>
                <li class="google"><a href="" onclick="fnPopSNSLogin('gl','410','420');fnAmplitudeEventMultiPropertiesAction('click_login_button', 'action|autologin', 'google|<% If vSavedAuto <> "" Then Response.write "on" Else Response.write "off" End If %>');return false;"><i class="icon"></i><span class="text">구글</span></a></li>
                <li class="naver"><a href="" onclick="fnPopSNSLogin('nv','400','800');fnAmplitudeEventMultiPropertiesAction('click_login_button', 'action|autologin', 'naver|<% If vSavedAuto <> "" Then Response.write "on" Else Response.write "off" End If %>');return false;"><i class="icon"></i><span class="text">네이버</span></a></li>
                <li class="facebook"><a href="" onclick="fnPopSNSLogin('fb','410','300');fnAmplitudeEventMultiPropertiesAction('click_login_button', 'action|autologin', 'facebook|<% If vSavedAuto <> "" Then Response.write "on" Else Response.write "off" End If %>');return false;"><i class="icon"></i><span class="text">페이스북</span></a></li>
			</ul>
		</div>

		<div class="nonmember-link">
			<% if vType="B" Then %>
				<div>
					<a href="" onclick="Nonmember(frmLogin4); fnAmplitudeEventAction('click_loginview_button','action','nonmember_purchase'); return false;">비회원 구매하기<i class="ico-arrow"></i></a>
					<p class="tPad1r">장바구니, 마일리지, 쿠폰적용 등의<br>혜택을 받으실 수 없습니다.</p>
				</div>
			<% End If %>
			<% if vType="G" Then %>
				<a href="/login/login.asp?typegb=NM" onclick="fnAmplitudeEventAction('click_loginview_button','action','nonmember_order');">비회원 주문조회<i class="ico-arrow"></i></a>
			<% End If %>			
		</div>
		<%End if%>
<% else %>
	<%'// 비회원이 주문조회를 클릭시에 나오는 화면 %>
	<%' content area %>
		<div class="login-form">
			<form name="frmLoginGuest" method="post" action="">
			<input type="hidden" name="backpath" value="<%=strBackPath%>">
			<input type="hidden" name="strGD" value="<%=strGetData%>">
			<input type="hidden" name="strPD" value="<%=strPostData%>">
				<fieldset>
				<legend class="hidden">비회원 로그인 폼</legend>
					<div class="form-group">
						<input type="number" name="orderserial" autocorrect="off" autocapitalize="off"  maxlength="11" onKeyPress="if (event.keyCode == 13) frmLoginGuest.buyemail.focus();" id="orderno" required />
						<label for="orderno">주문번호</label>
					</div>
					<div class="form-group">
						<input type="email" id="email" autocorrect="off" autocapitalize="off"  name="buyemail" onKeyPress="if (event.keyCode == 13) TnDoGuestLogin(frmLoginGuest);" maxlength="128" required />
						<label for="email">주문고객 이메일</label>
					</div>
					<div class="btn-group">
						<input type="submit" value="비회원 로그인" onclick="TnDoGuestLogin(frmLoginGuest); fnAmplitudeEventAction('click_login_button','action','normalguest'); return false;" class="btn btn-red btn-xlarge btn-block" />
					</div>
				</fieldset>
			</form>
		</div>

		<div class="login-utility">
			<div class="utility-link">
				<a href="/member/join.asp" onclick="fnAmplitudeEventAction('click_loginview_button','action','signup');">회원가입</a>
				<a href="/member/find_idpw.asp?t=id" onclick="fnAmplitudeEventAction('click_loginview_button','action','find_id_pw');">아이디/비밀번호 찾기</a>
			</div>
		</div>
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
elseif Date() >= "2017-07-01" Then '신규가입
	NewUserEvtcode = 78784
end If
%>
<% if Date() >= "2017-05-01" then %>
	<%If tabFlag <> True then%>
	<!--aside class="bnr bnr-newmember-event">
		<a href="/event/eventmain.asp?eventid=<%= NewUserEvtcode %>" onclick="fnAmplitudeEventAction('click_loginview_button','action','newmember_coupon');">
			<h2 class="headline"><strong>신규회원</strong> 웰컴쿠폰</h2>
			<p>지금 회원가입하고 <strong>최대 10,000원 쿠폰 받아가세요!</strong></p>
		</a>
	</aside-->
	<% server.Execute("/login/include_login_banner.asp") %>	
	<%End if%>
<% end if %>
</div>
<!-- //content area -->
<!-- #include virtual="/lib/inc/incFooter.asp" -->
		
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->