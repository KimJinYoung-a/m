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
Dim oGrCat, vDisp, vDepth, lp, vIsMine, vSelOP
vDisp =  getNumeric(request("disp"))
If vDisp <> "" Then vDisp = "" End If
vIsMine = requestCheckVar(Request("ismine"),1)
vSelOP	=  requestCheckVar(Request("selOP"),1) '정렬

vDepth = (Len(vDisp)/3)

Set oGrCat = new MyCategoryCls
	oGrCat.FDepth = vDepth+1
	oGrCat.FDisp = vDisp
	oGrCat.fnDisplayCategoryList
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">

</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="header">
			<h1>카테고리</h1>
			<p class="btnPopClose"><button class="pButton" onclick="goBack('/shoppingtoday/shoppingchance_allevent.asp'); return false;">닫기</button></p>
		</div>
		<div class="content" id="contentArea">
			<div class="categoryListup">
				<ul>
				<% If oGrCat.FResultCount>0 Then %>
					<% FOR lp = 0 to oGrCat.FResultCount-1 %>
					<li><a href="/shoppingtoday/shoppingchance_allevent.asp?disp=<%= oGrCat.FItemList(lp).Fcatecode %>&ismine=<%=vIsMine%>&selOP=<%=vSelOP%>"><%= oGrCat.FItemList(lp).Fcatename %> <% if oGrCat.FItemList(lp).fisnew ="o" then %><span class="icoHot">HOT</span><% End If %></a></li>
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