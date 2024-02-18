<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/MyCategoryCls.asp" -->
<%
	Dim i, cMyZzim, vZarrList, vResultCount, vLink
	SET cMyZzim = new MyCategoryCls
		cMyZzim.FUserID = getLoginUserID
		vZarrList = cMyZzim.fnMyZzimBrandList
		vResultCount = cMyZzim.FResultCount
	SET cMyZzim = Nothing
	
	If vZarrList(3,0) = "m" Then
		vLink = "GoMyZzimBrand();"
	Else
		vLink = ""
	End If
%>
<li class="topDepth"><div onclick=""><p class="c333"><%=CHKIIF(vZarrList(3,0)="m","나의","추천")%> <span class="cC40">찜 브랜드</span></p><dfn class="elmBg"></dfn></div>
	<ul class="brandList">
	<%
		For i = 0 To UBound(vZarrList,2)
			Response.Write "<li " & CHKIIF("o"="o","class=""new""","") & "><div onclick=""ShowBrandDetail('"&vZarrList(0,i)&"');""><p>" & vZarrList(1,i) & "</p></div></li>" & vbCrLf
			If i > 1 Then
				If vResultCount > 3 AND vLink <> "" Then
					Response.Write "<li><div onclick=""" & vLink & """><p class=""more elmBg""><span>more</span></p></div></li>" & vbCrLf
				End If
				EXIT FOR
			End If
		Next
	%>
	</ul>
</li>
<!-- #include virtual="/lib/db/dbclose.asp" -->