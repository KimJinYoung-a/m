<%
'// 검색결과, 오프닝
set oPi = new SearchPieceCls
oPi.FRectSearchTxt = SearchText
oPi.FCurrPage = 1
oPi.FPageSize = 1
oPi.FRectSearchGubun = vListGubun
oPi.FRectAdminID = vAdminID
oPi.FRectIsOpening = "o"
oPi.FScrollCount = 10
oPi.getPieceList2017

vTotalCount = oPi.FTotalCount

If oPi.FResultCount>0 Then
	For i = 0 To oPi.FResultCount-1

	If oPi.FItemList(i).Fpitem <> "" Then
		vLinkItemID = Split(Split(oPi.FItemList(i).Fpitem,",")(0),"$$")(0)
	End If
%>
	<% If CStr(Replace(date(),"-","")) <> CStr(Left(oPi.FItemList(i).Fstartdate,8)) Then %>
	<!--<div class="time"><span class="icon icon-moon"></span><%=fnDayCheckText(oPi.FItemList(i).Fstartdate)%></div> -->
	<% End If %>
	
	<% If oPi.FItemList(i).Fgubun = "1" Then	'### 조각 %>
		<!-- #include file="./inc_piece.asp" -->
	<% ElseIf oPi.FItemList(i).Fgubun = "4" Then	'### 배너 %>
		<% If oPi.FItemList(i).Fbannergubun = "1" Then	'### 텍스트 %>
		<div class="bnr bnr-piece-ad type-text">
			<a href="<%=oPi.FItemList(i).Fetclink%>"><%=oPi.FItemList(i).Flisttitle%></a>
		</div>
		<% ElseIf oPi.FItemList(i).Fbannergubun = "2" Then	'### 이미지 %>
		<div class="bnr bnr-piece-ad type-img">
			<a href="<%=oPi.FItemList(i).Fetclink%>"><div class="thumbnail"><img src="<%=oPi.FItemList(i).Flistimg%>" alt=""></div></a>
		</div>
		<% End If %>
	<% End If %>
<%
		vLinkItemID = ""
	Next
End If
%>