<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/shopping/favoriteColorCls.asp" -->
<%
	dim i,lp
	dim ofavColor
	dim category,colorCD, colorName
	Dim oCIcon, schcolorCD , idx
	dim icon1Image

	category	= RequestCheckVar(request("cat"),8)
	colorCD		= RequestCheckVar(request("ccd"),8)
	idx			= RequestCheckVar(request("schcd"),8)

	'카테고리 제외
	'if category="" then
	'	randomize
	'	category=int(Rnd*5)+1
	'end if
	if colorCD="" then
		randomize
		colorCD=cStr(int(Rnd*31))
	end If

	'// 컬러 아이콘 접수
	set oCIcon = new CItemColor
		oCIcon.FPageSize = 50
		oCIcon.FRectUsing = "Y"
		oCIcon.GetColorList
		
		for i=0 to oCIcon.FResultCount-1
			if cStr(i)=cStr(colorCD) Then
				'선택컬러명
				colorName = oCIcon.FItemList(i).FcolorName
				'IDX가 없을때
				If idx = "" then idx = oCIcon.FItemList(i).FcolorCode
			end if
		next

	'// 컬러 상품 접수
	set ofavColor = new CfavoriteColor
		ofavColor.FCurrPage = 1
		ofavColor.FPageSize = 20
		ofavColor.FRectCategory = category
		ofavColor.FRectColorCD = idx
		ofavColor.GetfavoriteColor

		ofavColor.GetfavoriteColorTop1 'top1 
		icon1Image = ofavColor.Ficon1Image 'top1 image
%>
	<dl class="colorInfo">
		<dt><img src="http://fiximage.10x10.co.kr/m/2013/color/tit_color<%=Num2Str(colorCd+1,2,"0","R")%>.png" alt="<%=colorName%>" style="height:29px" /></dt>
		<dd><%=arrColorDesc(colorCd+1)%></dd>
		<dd class="pic">
		<%
			if ofavColor.FResultCount > 0 Then
				if Not(ofavColor.FItemList(0).FImageIcon1="" or isNull(ofavColor.FItemList(0).FImageIcon1)) then
		%> 
			<img src="<%=ofavColor.FItemList(0).FImageIcon1 %>" alt="<%=colorName%>" style="width:100px;height:100px;" />
		<%	else %>
			<img src="<%=ofavColor.FItemList(0).FListImage %>" alt="<%=colorName%>" style="width:100px;height:100px;" />
		<%
				End if
			End if
		%> 
		</dd>
	</dl>

	<!--컬러상품리스트 20개 -->
	<ul class="cPrdList topGyBdr">
	<%
		if ofavColor.FResultCount>0 then
			for lp=0 to ofavColor.FResultCount-1
	%>
		<li><a href="/category/category_itemPrd.asp?itemid=<%=ofavColor.FItemList(lp).Fitemid %>"><img src="<%=ofavColor.FItemList(lp).FImageIcon2 %>" style="width:80px;height:80px;" alt="<%=ofavColor.FItemList(lp).Fitemname %>"></a></li>
	<%
			Next
		End if
	%>
	</ul>
<%
	set oCIcon = Nothing
	set ofavColor = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->