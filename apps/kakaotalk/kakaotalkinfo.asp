<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
	Response.Charset = "UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 카카오톡 맞춤정보 서비스</title>
<link rel="stylesheet" type="text/css" href="/lib/css/mytenten2013.css">
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<img src="http://fiximage.10x10.co.kr/m/kakaotalk/kakao_setting_svc1.png" alt="주문,배송정보 이젠 카카오톡으로 받자!" width="100%" class="vTop" />
				<img src="http://fiximage.10x10.co.kr/m/kakaotalk/kakao_setting_svc2.png" alt="PC버전 웹에서 인증하기" width="100%" class="vTop" />
				<img src="http://fiximage.10x10.co.kr/m/kakaotalk/kakao_setting_svc3.png" alt="Mobile 버전 웹에서 인증하기" width="100%" class="vTop" />
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
