<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : app 다운로드 신규회원
' History : 2018-12-14 이종화
'###########################################################
dim currentDate

currentDate = date()
'test
'currentDate = Cdate("2019-07-01")
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 텐바이텐 APP 다운로드</title>
<style type="text/css">
.memberGuide {background-color: #4deece;}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
</head>
<body>
<body class="default-font body-sub bg-grey">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<div id="content" class="content">
		<div class="evtCont">
            <%'!--// 텐바이텐 신규 회원을 위한 혜택 가이드! new --%>
            <div class="memberGuide">
                <p class="topic"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/newmember/m/tit_newmember.png" alt="텐바이텐 신규 회원을 위한 혜택 가이드!"></p>
                <div class="benefit">
                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2019/newmember/m/img_01.png" alt="신규회원 가입하고, 쿠폰 받기! "></p>
                    <a href="https://tenten.app.link/5s7CgrtDSX" onclick="fnAmplitudeEventAction('click_newmember_button','action','join');"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/newmember/m/btn_join.png" alt="회원가입 하러 가기"></a>
                </div>
                <p class="benefit">
                    <img src="http://webimage.10x10.co.kr/fixevent/event/2019/newmember/m/img_02.png" alt="APP설치하고, 쿠폰 받기!">
                    <a href="https://tenten.app.link/BaHFpXGCSX"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/newmember/m/btn_app.png" alt="app 설치하기"></a>
                </p>
                <div class="benefit">
                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2019/newmember/m/img_03.png" alt="무료배송 및 마일리지 혜택 확인하기 !"></p>
                </div>
            </div>
            <%'!--// 텐바이텐 신규 회원을 위한 혜택 가이드! --%>
		</div>
	</div>
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>