<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
response.charset = "utf-8"
%>


<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbCTopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/betweenItemcls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->


<%
Dim vDisp : vDisp = requestCheckVar(request("disp"),15)
'Dim vDepth, i,TotalCnt
'	vDepth = "1"
dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),9))
'dim searchFlag 	: searchFlag = "sale"
dim CurrPage 	: CurrPage = getNumeric(requestCheckVar(request("cpg"),9))
'dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
'dim CurrPage2 	: CurrPage2 = getNumeric(requestCheckVar(request("scpg"),9))
Dim SortMet	: SortMet = requestCheckVar(request("ord"),1)

'If CurrPage2 <> "1" Then
'	CurrPage = CurrPage2+1
'End If


'response.write vDisp
'response.End


'dim ListDiv,ScrollCount
'ListDiv="salelist"
'ScrollCount = 20

if CurrPage="" then CurrPage=1
If PageSize="" Then PageSize = 10
If vDisp="" Then vDisp="101"
If SortMet = "" Then SortMet = "1"

dim oDoc,iLp, TotalCnt, i
set oDoc = new CAutoCategory
	oDoc.FPageSize 			= PageSize
	oDoc.FRectbetCateCd			= vDisp
	oDoc.FCurrPage 			= CurrPage
	oDoc.FSellScope 		= "Y"
	oDoc.FSortMet 			= SortMet
	oDoc.GetBetCategoryList
	
TotalCnt = oDoc.FResultCount
%>

	<% IF oDoc.FResultCount >0 then %>
	<%
	For i=0 To TotalCnt-1
	
	IF (i <= TotalCnt-1) Then
	%>
	<li id="<%=vDisp%>ListA<%=i%>">
		<div <% If oDoc.FCategoryPrdList(i).IsSoldOut Then %> class="soldout" <% Else %><% IF oDoc.FCategoryPrdList(i).isSaleItem then %> class="sale"<% End If %><% End If %> >
			<a href="category_itemPrd.asp?itemid=<%=oDoc.FCategoryPrdList(i).FItemID%>&dispCate=<%=vDisp%>" id="Hlink" class="<%=i%>">
				<p class="pdtPic"><img src="<% = oDoc.FCategoryPrdList(i).FImageList %>" alt="<% = oDoc.FCategoryPrdList(i).FItemName %>" /></p>
				<p class="pdtName"><% = oDoc.FCategoryPrdList(i).FItemName %></p>
				<p class="price">
					<%
						If oDoc.FCategoryPrdList(i).IsSaleItem Then
							IF oDoc.FCategoryPrdList(i).IsSaleItem Then
								Response.Write FormatNumber(oDoc.FCategoryPrdList(i).getRealPrice,0) & "원"
							End IF
						Else
							Response.Write FormatNumber(oDoc.FCategoryPrdList(i).getRealPrice,0) & "원"
						End If
					%>
				</p>
			</a>
			<% If oDoc.FCategoryPrdList(i).isSaleItem Then %>
				<p class="pdtTag saleRed"><%=oDoc.FCategoryPrdList(i).getSalePro%></p>
			<% End If %>
			<% If oDoc.FCategoryPrdList(i).IsSoldOut Then %>
				<% 'for dev msg : 품절 상품일때 추가됨%>
				<p class="pdtTag soldOut">품절</p>
			<% End If %>
		</div>
	</li>
	<% End IF %>
	<% Next %>
	<% end if %>
<%
SET oDoc = Nothing
%>
<!-- #include virtual="/lib/db/dbCTclose.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->