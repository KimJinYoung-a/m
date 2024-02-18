<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/MyCategoryCls.asp" -->
<%
'####################################################
' Description : 카테고리 선택
' History : 2014.09.22 이종화 추가
'####################################################

Dim oGrCat, vDisp, vDepth, lp, vIsMine, vSelOP , backurl
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
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
</head>
<body>
<div class="layerPopup">
	<div class="popWin">
		<div id="scrollarea">
			<div class="categoryListup">
				<ul>
				<% If oGrCat.FResultCount>0 Then %>
					<li><a href="#" onclick="fnAPPopenerJsCallClose('fnChgDispCate(\'\',\'전체\')');return false;">전체</a></li>
					<% FOR lp = 0 to oGrCat.FResultCount-1 %>
					<li><a href="#" onclick="fnAPPopenerJsCallClose('fnChgDispCate(\'<%= oGrCat.FItemList(lp).Fcatecode %>\',\'<%= oGrCat.FItemList(lp).Fcatename %>\')');return false;"><%= oGrCat.FItemList(lp).Fcatename %> <% if oGrCat.FItemList(lp).fisnew ="o" then %><span class="icoHot">HOT</span><% End If %></a></li>
					<% Next %>
				<% end if %>
				</ul>
			</div>
		</div>
	</div>
</div>
<% set oGrCat = nothing %>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->