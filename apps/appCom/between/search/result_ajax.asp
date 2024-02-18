<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbCTopen.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/searchCls.asp" -->
<%
Dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
dim page 		: page = request("cpg")
dim SortMet		: SortMet = request("srm")
dim dispCate 	: dispCate = getNumeric(requestCheckVar(request("dispCate"),18))
dim lp, i

'// 상품검색
Dim oDoc,iLp
set oDoc = new CSearchItemCls
	oDoc.FCurrPage 			= page
	oDoc.FPageSize 			= 6
	oDoc.FRectSearchTxt		= SearchText
	oDoc.FRectSortMethod	= SortMet
	oDoc.FRectCateCode		= dispCate
	oDoc.getSearchList
%>
<script type="text/javascript">
$(function() {
	<% If CStr(oDoc.FTotalPage) = CStr(page) Then %>
	$(".listAddBtn").hide();
	<% End If %>
});
</script>
<%
	If oDoc.FResultCount > 0 Then 
		For i = 0 To oDoc.FResultCount - 1 
%>
					<li>
						<div <% If oDoc.FItemlist(i).IsSoldOut Then %> class="soldout" <% Else %><% IF oDoc.FItemlist(i).isSaleItem then %> class="sale"<% End If %><% End If %> >
							<a href="/apps/appCom/between/category/category_itemPrd.asp?itemid=<%=oDoc.FItemlist(i).FItemID%>&dispCate=<%=dispCate%>">
								<p class="pdtPic"><img src="<% = oDoc.FItemlist(i).FImageList %>" alt="<% = oDoc.FItemlist(i).FItemName %>" /></p>
								<p class="pdtName"><% = oDoc.FItemlist(i).FItemName %></p>
								<p class="price">
								<%
									If oDoc.FItemlist(i).IsSaleItem Then
										IF oDoc.FItemlist(i).IsSaleItem Then
											Response.Write FormatNumber(oDoc.FItemlist(i).getRealPrice,0) & "원"
										End IF
									Else
										Response.Write FormatNumber(oDoc.FItemlist(i).getRealPrice,0) & "원"
									End If
								%>
								</p>
							<% If oDoc.FItemlist(i).isSaleItem Then %>
								<p class="pdtTag saleRed"><%=oDoc.FItemlist(i).getSalePro%></p>
							<% End If %>
							<% If oDoc.FItemlist(i).IsSoldOut Then %>
								<p class="pdtTag soldOut">품절</p>
							<% End If %>
							</a>
						</div>
					</li>
<% 
		Next 
	End If 
Set oDoc = nothing
%>
<!-- #include virtual="/lib/db/dbCTclose.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->