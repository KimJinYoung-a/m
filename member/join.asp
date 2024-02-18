<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 회원가입
' History : 2017.06.07 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<%
'해더 타이틀
strHeadTitleName = "회원가입"


'response.redirect "/member/join_step1.asp"
'dbget.close(): response.End

'## 로그인 여부 확인
if IsUserLoginOK then
'	Call Alert_move("이미 회원가입이 되어있습니다.","/")
'	dbget.close(): response.End
end if

dim strBackPath, strGetData, strPostData
	strBackPath = ReplaceRequestSpecialChar(request("backpath"))
	strBackPath = Replace(strBackPath,"^^","&")
	strGetData  = ReplaceRequestSpecialChar(request("strGD"))
	strPostData = ReplaceRequestSpecialChar(request("strPD"))

dim snsid, tenbytenid, snsusermail, snsisusing, snsgubun, tokenval, snsusername, sns_sexflag, kakaoterms, code, state, age
snsid	= requestCheckVar(request("snsid"),64)
tenbytenid	= requestCheckVar(request("tenbytenid"),32)
snsusermail	= requestCheckVar(request("usermail"),1200)
snsisusing	= requestCheckVar(request("snsisusing"),1)
snsgubun	= requestCheckVar(request("snsgubun"),2)
snsusername	= requestCheckVar(request("snsusername"),16)
sns_sexflag	= requestCheckVar(request("sexflag"),10)
tokenval	= request("tokenval")
kakaoterms 	= requestCheckVar(request("kakaoterms"),2400)
code 	= requestCheckVar(request("code"),2400)
state 	= requestCheckVar(request("state"),10)
age 	= requestCheckVar(request("age"),10)
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 회원가입</title>
<style type="text/css">
.gnbWrapV16a {display:none;}
body {
  overflow: hidden;
  touch-action: none;
}
</style>
<script style="text/javascript">
$(function(){
    var topHeight = $('#header').outerHeight();
    var simpleTit = $('.simpleTit');
    $(simpleTit).css('top',topHeight);

    funciton setScreenSize() {
        let vh = window.innerHeight * 0.01;
        document.documentElement.style.setProperty('--vh', `${vh}px`);
    }
    etScreenSize();
    window.addEventListener('resize', () => setScreenSize());
});
</script>
<script type="text/javascript">
function fnJoinPageMove(){
    document.myinfoForm.action="join_step1.asp";
    document.myinfoForm.submit();
}

// 모달 열기
function fnOpenModal(obj) {
	$('#'+obj).addClass('show');
    $('#'+obj).show();
	$('#'+obj+' .modal_cont').animate({scrollTop : 0}, 0);
	toggleScrolling();
};
// 모달 닫기
function fnCloseModal(obj) {
	$('#'+obj).removeClass('show');
    $('#'+obj).hide();
	toggleScrolling();
}
// 모달 호출될 때, 부모창 스크롤 방지
function toggleScrolling() {
	if ($('.modalV20').hasClass('show')) {
		currentY = $(window).scrollTop();
		$('html').addClass('not_scroll');
	} else {
		$('html').removeClass('not_scroll');
		$('html').animate({scrollTop : currentY}, 0);
	}
}
function fnPopTenSNSLogin() {
	var popup = window.open("","tenSNSPopup","width=600, height=800");
	$('#snsForm').attr('target',"tenSNSPopup");
	$('#snsForm').submit();     
}
</script>
<link rel="stylesheet" type="text/css" href="/lib/css/common.css?v=2.03" />
<link rel="stylesheet" type="text/css" href="/lib/css/content.css?v=4.90" />
<link rel="stylesheet" type="text/css" href="/lib/css/contentV20.css?v=1.85" />
<link rel="stylesheet" type="text/css" href="/lib/css/commonV20.css?v=1.43" />
</head>
<body class="bg-grey02">
<div class="heightGrid">
	<div class="mainSection" style="background:transparent;">
		<!-- #include virtual="/member/pop_terms.asp" -->
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea" style="padding-bottom:0;">
				<div class="section simpleJoinForm" style="height: calc(var(--vh, 1vh) * 100);">
                <% if (snsid ="" and snsusermail="" and snsgubun="") then %>
				<% else %>
                    <form name="snsForm" id="snsForm" method="post" action="/login/snslogin.asp">
                    <input type="hidden" name="code" value="<%= code %>">
                    <input type="hidden" name="state" value="<%= state %>">
                    <input type="hidden" name="tokenval" value="<%= tokenval %>">
                    <input type="hidden" name="snstoten" value="Y">
                    <div class="connect-area new">
                        <a href="javascript:fnPopTenSNSLogin();" class="btn-connect-id">
                            <div class="bnr-aready-member">
                                <p class="tit">이미 텐바이텐 계정이 있다면?</p>
                                <div class="btn-connecte">연결하기</div>
                            </div>
                        </a>
                    </div>
                    </form>
                <% end if %>
                    <form name="myinfoForm" id="myinfoForm" method="post">
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
                        <button type="button" class="teram" onclick="fnOpenModal('terms');">
                            <p class="tit arrow">다음 이용약관에 동의합니다</p>
                            <div class="must">필수</div>
                        </button>
                        <button type="button" class="teram none" onclick="fnOpenModal('privacy2');">
                            <p class="tit arrow">개인정보 수집 및 이용에 동의합니다</p>
                            <div class="must">필수</div>
                        </button>
                        <div class="bar"></div>
                        <button type="button" class="teram none" onclick="fnOpenModal('smart');">
                            <p class="tit arrow">쿠폰/혜택 발생 시 스마트 알림</p>
                            <div class="must">선택</div>
                        </button>
                        <p class="noti">알림을 받으면 매달 추첨을 통해 10,000P를 선물로 드려요</p>
                        <div class="auto-login">
                            <input type="checkbox" name="smartAlarm" id="smartAlarm"> 
                            <label for="autologin">스마트알림 받지 않기</label>
                        </div>
                    </div>
                    <div class="btnGroup">
                        <input type="submit" class="btnV16a btnRed2V16a btnLarge btnBlock" onclick="fnJoinPageMove();" value="동의 후 가입하기">
                    </div>
                    </form>
				</div>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->