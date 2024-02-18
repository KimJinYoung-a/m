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
'	Description : 회원가입 선택
'	History	:  2017.06.07 유태욱 생성
'#######################################################
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/commlib.asp" -->
<%
dim snsid, tenbytenid, snsusermail, snsisusing, snsgubun, tokenval, snsusername, sns_sexflag, kakaoterms, code, state, age
snsid	= requestCheckVar(request("snsid"),64)
tenbytenid	= requestCheckVar(request("tenbytenid"),32)
snsusermail	= requestCheckVar(request("usermail"),1200)
snsisusing	= requestCheckVar(request("snsisusing"),1)
snsgubun	= requestCheckVar(request("snsgubun"),2)
snsusername	= requestCheckVar(request("snsusername"),16)
sns_sexflag	= requestCheckVar(request("sexflag"),10)
tokenval	= request("tokenval")
tokenval	= replace(tokenval," ","+")
kakaoterms 	= requestCheckVar(request("kakaoterms"),2400)
code 	= requestCheckVar(request("code"),2400)
state 	= requestCheckVar(request("state"),10)
age 	= requestCheckVar(request("age"),10)
%>
<script type="text/javascript">
$(function(){
    fnAPPchangPopCaption('');
    fnGetAppVersion();
});

function fnJoinPageMove(){
    document.myinfoForm.action="join_step1.asp";
    document.myinfoForm.submit();
}

// 모달 열기
function fnOpenModalTerms(obj) {
	$('#'+obj).addClass('show');
	$('#'+obj+' .modal_cont').animate({scrollTop : 0}, 0);
	fnSetHeaderDim(true);
	toggleScrolling();
};
// 모달 닫기
function fnCloseModal(obj) {
	$('#'+obj).removeClass('show');
	fnSetHeaderDim(false);
	toggleScrolling();
}
// 모달 호출될 때, 부모창 스크롤 방지
function toggleScrolling() {
	if ($('.modalV20').hasClass('show')) {
		currentY = $(window).scrollTop();
		//$('html').addClass('not_scroll');
	} else {
		//$('html').removeClass('not_scroll');
		$('html').animate({scrollTop : currentY}, 0);
	}
}

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
			if (deviceInfo.version >= 4.039)
			{
				$("#snstitle").show();
			}
		}
		if (isMobile.Android())
		{
			if (deviceInfo.version >= 4.039)
			{
				$("#snstitle").show();
			}
		}
	}});
}
</script>
<link rel="stylesheet" type="text/css" href="/lib/css/common.css?v=2.03" />
<link rel="stylesheet" type="text/css" href="/lib/css/content.css?v=4.90" />
<link rel="stylesheet" type="text/css" href="/lib/css/contentV20.css?v=1.85" />
<link rel="stylesheet" type="text/css" href="/lib/css/commonV20.css?v=1.43" />
<link rel="stylesheet" type="text/css" href="/lib/css/appV20.css?v=1.06" />
</head>
<body style="height: 100vh;" class="bg-grey02">
<div class="heightGrid">
	<div class="mainSection" style="background:transparent;">
		<!-- #include virtual="/member/pop_terms.asp" -->
		<div class="container">
			<!-- content area -->
			<div class="content" id="contentArea" style="padding-bottom:0;">
				<div class="section simpleJoinForm" style="height: calc(var(--vh, 1vh) * 100 - 4.8rem);">
                    <% if (snsid ="" and snsusermail="" and snsgubun="") then %>
                    <% else 'SNS 회원가입일때 텐바이텐 로그인 버튼 활성화 %>
                    <div class="connect-area new" id="snstitle" style="display:none">
                        <a href="" onClick="fnPopupSnsJoin();return false;" class="btn-connect-id">
							<div class="bnr-aready-member">
                                <p class="tit">이미 텐바이텐 계정이 있다면?</p>
                                <div class="btn-connecte">연결하기</div>
                            </div>
						</a>
                    </div>
                    <% end if %>
                    <form name="myinfoForm" method="post">
                    <input type="hidden" name="snsid" value="<%= snsid %>">
                    <input type="hidden" name="tenbytenid" value="<%= tenbytenid %>">
                    <input type="hidden" name="snsusermail" value="<%= snsusermail %>">
                    <input type="hidden" name="snsisusing" value="<%= snsisusing %>">
                    <input type="hidden" name="snsgubun" value="<%= snsgubun %>">
                    <input type="hidden" name="tokenval" value="<%= tokenval %>">
                    <input type="hidden" name="snsusername" value="<%= snsusername %>">
                    <input type="hidden" name="sns_sexflag" value="<%= sns_sexflag %>">
                    <input type="hidden" name="kakaoterms" value="<%= kakaoterms %>">
                    <input type="hidden" name="code" value="<%= code %>">
                    <input type="hidden" name="state" value="<%= state %>">
					<input type="hidden" name="sec30" value="on">
                    <div class="simpleTit">
                        <h2>텐바이텐<br/>회원가입약관</h2>
                        <div class="step">
                            <span class="number">1</span>
                            <span class="bar"></span>
                            <span class="boll"></span>
                        </div>
                    </div>
                    <div class="teram-area">
                        <div class="teram">
                            <p class="tit">저는 만 14세 이상입니다.</p>
                            <div class="must">필수</div>
                        </div>
                        <button type="button" class="teram" onclick="fnOpenModalTerms('terms');">
                            <p class="tit arrow">다음 이용약관에 동의합니다</p>
                            <div class="must">필수</div>
                        </button>
                        <button type="button" class="teram none" onclick="fnOpenModalTerms('privacy2');">
                            <p class="tit arrow">개인정보 수집 및 이용에 동의합니다</p>
                            <div class="must">필수</div>
                        </button>
                        <div class="bar"></div>
                        <div class="teram none" onclick="fnOpenModalTerms('smart');">
                            <p class="tit arrow">쿠폰/혜택 발생 시 스마트 알림</p>
                            <div class="must">선택</div>
                        </div>
                        <p class="noti">알림을 받으면 매달 추첨을 통해 10,000P를 선물로 드려요</p>
                        <div class="auto-login">
                            <input type="checkbox" name="smartAlarm" id="smartAlarm"> 
                            <label for="autologin">스마트알림 받지 않기</label>
                        </div>
                    </div>
                    <div class="btnGroup">
                        <input type="submit" class="btnV16a btnRed2V16a btnLarge btnBlock" id="" onclick="fnJoinPageMove();" value="동의 후 가입하기">
                    </div>
                    </form>
				</div>
			</div>
			<!-- //content area -->
		</div>
	</div>
</div>
</body>
</html>