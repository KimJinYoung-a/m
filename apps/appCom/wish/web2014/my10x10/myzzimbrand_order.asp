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
' Description : 찜 브랜드
' History : 2014.09.21 한용민 생성
' History : 2014.09.22 이종화 추가
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
</head>
<body>
<div class="layerPopup">
	<div class="popWin">
		<div id="scrollarea">
			<div class="categoryListup">
				<ul>
					<li><a href="#" onclick="fnAPPopenerJsCallClose('fnSearchSort(\'recent\')');return false;" value="new">최근 등록순</a></li>
					<li><a href="#" onclick="fnAPPopenerJsCallClose('fnSearchSort(\'brandname\')');return false;" value="hit">이름 순</a></li>
				</ul>
			</div>
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->