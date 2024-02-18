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

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
</head>
<body>
<div class="layerPopup">
	<div class="popWin">
		<div id="scrollarea">
			<div class="categoryListup">
				<ul>
					<li><a href="" onclick="fnAPPopenerJsCallClose('goorder(\'\')');return false;" value="">전체</a></li>
					<li><a href="" onclick="fnAPPopenerJsCallClose('goorder(\'ctab1\')');return false;" value="ctab1">NEW</a></li>
					<li><a href="" onclick="fnAPPopenerJsCallClose('goorder(\'ctab3\')');return false;" value="ctab3">BEST</a></li>
					<li><a href="" onclick="fnAPPopenerJsCallClose('goorder(\'ctab2\')');return false;" value="ctab2">ZZIM</a></li>
					<li><a href="" onclick="fnAPPopenerJsCallClose('goorder(\'ctab5\')');return false;" value="ctab5">ARTIST</a></li>
					<!--<li><a href="" onclick="fnAPPopenerJsCallClose('goorder(\'ctab7\')');return false;" value="ctab7">LOOKBOOK</a></li>-->
					<!--<li><a href="" onclick="fnAPPopenerJsCallClose('goorder(\'ctab8\')');return false;" value="ctab8">INTERVIEW</a></li>-->
				</ul>
			</div>
		</div>
	</div>
</div>

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->