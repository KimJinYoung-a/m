<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 브랜드
' History : 2014.09.21 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 브랜드 필터</title>
</head>
<body>
<div class="layerPopup">
	<div class="popWin">
		<div class="header">
			<h1>브랜드</h1>
			<p class="btnPopClose"><button type="button" class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
		<div class="content" id="layerScroll">
			<div id="scrollarea">
				<div class="categoryListup">
					<ul>
						<li><a href="" onclick="goorder(''); return false;" value="">전체</a></li>
						<li><a href="" onclick="goorder('ctab1'); return false;" value="ctab1">NEW</a></li>
						<li><a href="" onclick="goorder('ctab3'); return false;" value="ctab3">BEST</a></li>
						<li><a href="" onclick="goorder('ctab2'); return false;" value="ctab2">ZZIM</a></li>
						<li><a href="" onclick="goorder('ctab5'); return false;" value="ctab5">ARTIST</a></li>
						<!--<li><a href="" onclick="goorder('ctab7'); return false;" value="ctab7">LOOKBOOK</a></li>-->
						<!--<li><a href="" onclick="goorder('ctab8'); return false;" value="ctab8">INTERVIEW</a></li>-->
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->