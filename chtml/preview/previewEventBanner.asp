<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<%
	Dim chkDt, startDt
	chkDt = Request("cTm")
	startDt = Request("sDt")
%>
<!doctype html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=9">
	<link rel="stylesheet" type="text/css" href="css/default.css">
	<link rel="stylesheet" type="text/css" href="css/common.css">
	<link rel="stylesheet" type="text/css" href="css/content.css">
	<title>이벤트 배너 미리보기</title>
	<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
	<script src="/lib/js/swiper-1.8.min.js"></script>
	<script src="/lib/js/swiper.scrollbar-1.0.js"></script>
</head>
<body>
<div class="heightGrid" id="main">
	<div class="dateWrap" style="background-color:#F8F8F8">
		<ul class="dateList" style="position:relative;margin:auto;">
			<li style="background-color:<%=chkIIF(chkDt="0" or chkDt="","#FFEEDD","#F8F8F8")%>;font-size:11px;"><a href="?cTm=0&sDt=<%=startDt%>"><strong>오늘</strong><br />[<%=startDt%>]</a></li>
			<li style="background-color:<%=chkIIF(chkDt="1","#FFEEDD","#F8F8F8")%>;font-size:11px;"><a href="?cTm=1&sDt=<%=startDt%>"><strong>내일</strong><br />[<%=dateadd("d",1,startDt)%>]</a></li>
			<li style="background-color:<%=chkIIF(chkDt="2","#FFEEDD","#F8F8F8")%>;font-size:11px;"><a href="?cTm=2&sDt=<%=startDt%>"><strong>모레</strong><br />[<%=dateadd("d",2,startDt)%>]</a></li>
			<li style="background-color:<%=chkIIF(chkDt="3","#FFEEDD","#F8F8F8")%>;font-size:11px;"><a href="?cTm=3&sDt=<%=startDt%>"><strong>글피</strong><br />[<%=dateadd("d",3,startDt)%>]</a></li>
		</ul>
	</div>
	<div class="innerH15W10">
		<h2>이벤트</h2>
		<p class="c999 ftMidSm2 tMar05">즐거운 쇼핑을 위한 알뜰정보</p>
	</div>
	<div class="eventTheme">
		<div class="container">
			<%
				'// 메인 xml 파일 생성 (오늘자만 파일 생성)
				if chkDt="" then
					Server.Execute("/chtml/preview/make_event_xml.asp")
				end if

				'## 메인 템플릿 로드
				server.Execute("/chtml/preview/eventLoader.asp")
			%>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
<html>