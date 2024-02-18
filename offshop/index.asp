<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/offshop/lib/classes/offshopCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'#######################################################
'	Description : 오프라인페이지
'	History	:  2018.06.18 정태훈 생성
'#######################################################

'매장 리스트 가져오기
Dim offshoplist, ix
Set  offshoplist = New COffShop
offshoplist.GetOffShopList
%>
<!-- #include virtual="/lib/inc/head.asp" -->
</head>
<body class="default-font body-sub">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<div class="content offshopV18" id="contentArea">
		<h2 class="hidden">오프라인매장 목록</h2>
		<div class="offshop-thumb"><img src="http://fiximage.10x10.co.kr/m/2018/common/img_offshop_main.jpg" alt=""></div>
		<% If offshoplist.FResultCount >0 Then %>
		<ul class="offshop-list">
			<% For ix=0 To offshoplist.FResultCount-1 %>
			<li>
				<a href="shopinfo.asp?shopid=<%=offshoplist.FItemList(ix).FShopID%>">
					<h3><p><%=offshoplist.FItemList(ix).FShopName%></p><%=offshoplist.FItemList(ix).FEngName%></h3>
				</a>
			</li>
			<% Next %>
		</ul>
		<% End If %>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<%
Set  offshoplist = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->