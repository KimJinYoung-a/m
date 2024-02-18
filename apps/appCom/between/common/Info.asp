<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.Charset="UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
</head>
<body>
<div class="wrapper" id="">
	<div id="content">
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="hWrap hrBlk">
				<h1 class="headingA">사업자 정보</h1>
			</div>

			<div class="licenseeInfo">
				<div class="tenLogo"><img src="http://fiximage.10x10.co.kr/m/webview/between/common/img_tentenlogo.png" alt="텐바이텐" /></div>
				<p><strong>㈜텐바이텐</strong></p>
				<ul>
					<li>서울시 종로구 대학로12길 31 자유빌딩 5층 (110-510) / 대표자 : 최은희</li>
					<li>사업자등록번호 : 211-87-00620 / 통신판매업 신고번호 : 제 01-1968호 <strong><a href="external+http://www.ftc.go.kr/info/bizinfo/communicationView.jsp?apv_perm_no=2004300010130201968&amp;area1=&amp;area2=&amp;currpage=1&amp;searchKey=01&amp;searchVal=텐바이텐&amp;stdate=&amp;enddate=" target="_blank" title="새창">사업자정보확인</a></strong></li>
					<li>개인정보 관리 및 청소년 보호책임자 : 이문재 / 호스팅서비스 : (주)텐바이텐</li>
				</ul>
			</div>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->