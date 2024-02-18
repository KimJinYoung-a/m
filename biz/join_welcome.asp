<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 회원가입
' History : 2014.09.03 한용민 생성
' History : 2017.06.05 유태욱 리뉴얼
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

'if application("Svr_Info")<>"Dev" and application("Svr_Info")<>"staging" then
'	response.redirect "/"
'end if

dim txUserId, evtFlag
	evtFlag = requestCheckVar(Request("eFlg"),1)
	txUserId = session("sUserid")

	'// appBoy CustomEvent
	appBoyCustomEvent = "appboy.logCustomEvent('userJoin');"

	'// Kakao Analytics
	kakaoAnal_AddScript = "kakaoPixel('6348634682977072419').completeRegistration();"
%>

<!-- #include virtual="/lib/inc/head.asp" -->

<title>10x10: 가입완료</title>
<link rel="stylesheet" type="text/css" href="/lib/css/common.css?v=2.03" />
<link rel="stylesheet" type="text/css" href="/lib/css/content.css?v=4.90" />
<script type="application/x-javascript" src="/lib/js/iui_clickEffect.js"></script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
                <div class="joinBizCompWrap simpleMember">
                    <div class="joinBizComp">
                        <div class="titText">
                            <h2>BIZ 가입 신청이<br/>완료되었어요!</h2>
                            <p class="joinText">가입 승인 후 상품을 구매하실 수 있어요!<br/>가입 승인은 최대 24시간 내 이루어집니다.</p>
                        </div>
                        <div class="josinStepMember">
                            <div class="step point">회원가입 신청</div>
                            <div class="step arrow">승인</div>
                            <div class="step">회원가입 완료</div>
                        </div>
                    </div>
                    <div class="btnGroup">
                        <input type="submit" class="btnV16a btnRed2V16a btnLarge btnBlock" onclick="location.href='/biz/';" value="BIZ 홈으로 가기">
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