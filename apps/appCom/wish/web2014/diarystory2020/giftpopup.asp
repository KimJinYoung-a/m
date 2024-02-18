<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리 2020 사은품 팝업페이지
' History : 2019-08-29 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
	strHeadTitleName = "다이어리 사은품"
%>
<link rel="stylesheet" type="text/css" href="/lib/css/diary2020.css?v=1.03" />
</head>
<body class="default-font body-sub">
    <!-- contents -->
    <div id="content" class="content diary-sub">
        <div class="gift-popup">
            <img src="//fiximage.10x10.co.kr/m/2019/diary2020/diary_gift_1.jpg" alt="like you edition">
            <img src="//fiximage.10x10.co.kr/m/2019/diary2020/diary_gift_2.jpg" alt="1,5000원 이상 구매 시">
            <img src="//fiximage.10x10.co.kr/m/2019/diary2020/diary_gift_3.jpg" alt="3,5000원 이상 구매 시">
            <img src="//fiximage.10x10.co.kr/m/2019/diary2020/diary_gift_4.jpg" alt="5,0000원 이상 구매 시">
        </div>
    </div>
	<!-- //contents -->
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->