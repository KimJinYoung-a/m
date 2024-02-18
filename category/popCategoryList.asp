<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/MyCategoryCls.asp" -->
<%
Dim oGrCat, vDisp, vDepth, lp
vDisp =  getNumeric(request("disp"))

vDepth = (Len(vDisp)/3)

Set oGrCat = new MyCategoryCls
	oGrCat.FDepth = vDepth+1
	oGrCat.FDisp = vDisp
	oGrCat.fnDisplayCategoryList
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 카테고리 선택</title>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="header">
			<h1>카테고리</h1>
			<p class="btnPopClose"><button class="pButton" onclick="goBack('/category/category_list.asp?disp=101'); return false;">닫기</button></p>
		</div>
		<div class="content" id="contentArea">
			<div class="categoryListup">
				<ul>
				<% If oGrCat.FResultCount>0 Then %>
					<% FOR lp = 0 to oGrCat.FResultCount-1 %>
					<li><a href="/category/category_list.asp?disp=<%= oGrCat.FItemList(lp).Fcatecode %>"><%= oGrCat.FItemList(lp).Fcatename %> <% if oGrCat.FItemList(lp).fisnew ="o" then %><span class="icoHot">HOT</span><% End If %></a></li>
					<% Next %>
				<% end if %>
				</ul>
			</div>
		</div>
	</div>
</div>
</body>
</html>
<% set oGrCat = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->