<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 회원가입
' History : 2017.05.29 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
strHeadTitleName = "회원가입"
'## 로그인 여부 확인
if IsUserLoginOK then
'	Call Alert_move("이미 회원가입이 되어있습니다.","/")
'	dbget.close(): response.End
end if
%>
<link rel="stylesheet" type="text/css" href="/lib/css/common.css?v=2.03" />
<link rel="stylesheet" type="text/css" href="/lib/css/content.css?v=4.90" />
<link rel="stylesheet" type="text/css" href="/lib/css/contentV20.css?v=1.85" />
<link rel="stylesheet" type="text/css" href="/lib/css/commonV20.css?v=1.43" />
<script style="text/javascript">
$(function(){
    var topHeight = $('#header').outerHeight();
    var simpleTit = $('.simpleTit');
    $(simpleTit).css('top',topHeight);
});
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
</script>
</head>
<body class="bg-grey02">
<div class="heightGrid">
	<div class="mainSection" style="background:transparent;">
        <!-- #include virtual="/member/pop_terms.asp" -->
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="section simpleJoinForm">
                <form name="myinfoForm" method="post">
                <input type="hidden" name="sec30" value="on">
                    <div class="simpleTit">
                        <h2>텐바이텐 BIZ<br/>회원가입약관</h2>
                        <div class="step">
                            <span class="number">1</span>
                            <span class="bar"></span>
                            <span class="boll"></span>
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
                        <div class="auto-login">
                            <input type="checkbox" name="smartAlarm" id="smartAlarm"> 
                            <label for="autologin">스마트알림 받지 않기</label>
                        </div>
                    </div>
                    <div class="teram-noti">
                        <ul>
                            <li>서비스에 필요한 이용약관, 개인정보 수집/이용 동의에 거부하실 수 있으나, 이 경우 회원제 서비스 이용이 불가능함을 알려드립니다.</li>
                        </ul>
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
	<div id="mainBlankCover" class="mainBlankCover"></div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->