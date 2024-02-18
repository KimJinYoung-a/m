<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/enjoy/shoppingchanceCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls_B.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
Dim flag, atype, vDisp, chkCnt, PageSize
vDisp = RequestCheckVar(request("disp"),3)
flag = RequestCheckVar(request("flag"),1)
atype = RequestCheckVar(request("atype"),1)
dim CurrPage : CurrPage = getNumeric(request("cpg"))
if CurrPage="" then CurrPage=1
if PageSize="" then PageSize=30
'If atype = "" Then atype = "n"  'n 기본값
If atype = "" Then atype = "f"  'n 기본값
dim minPrice: minPrice=4500		'검색 최저가


if (CurrPage*PageSize)>90 then
	'30위까지만 표시
	dbget.Close: Response.End
end if

Dim oaward, i, iLp, sNo, eNo, tPg

set oaward = new CAWard
	oaward.FPageSize = PageSize*CurrPage
    oaward.FCurrPage 		= CurrPage
	oaward.GetBrandItemList

If (oaward.FResultCount < 3) Then
	''oaward.FRectCDL = vDisp  ''??
	''oaward.GetNormalItemList5down
	
	set oaward = Nothing
	set oaward = new SearchItemCls
		oaward.FListDiv 			= "bestlist"
		oaward.FRectSortMethod	    = "be"
		''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
		oaward.FPageSize 			= 50
		oaward.FCurrPage 			= 1
		oaward.FSellScope			= "Y"
		oaward.FScrollCount 		= 1
		oaward.FRectSearchItemDiv   ="D"
		oaward.FRectCateCode		= vDisp
		oaward.FminPrice	= minPrice
		oaward.getSearchList
End If
sNo = PageSize*(CurrPage-1)


%>
<% for i=sNo to oaward.FResultCount-1 %>
	<% If i Mod 3 = 0 Then %>
	<li <% If (i/3)+1 < 4 Then %> class="topRankV15" <% End If %> onclick="fnAPPpopupBrand('<%=oaward.FItemList(i).FMakerID %>');return false;">
		<div class="brdInfo">
			<p class="ranking"><span><%= ((i/3)-sNo)+((CurrPage-1)*PageSize)+1 %></span></p>
			<p class="brdName">
				<span class="eng"><%=oaward.FItemList(i).FBrandName %></span>
				<span class="kor"><%=oaward.FItemList(i).FSocName_Kor %></span>
			</p>
		</div>
	<div class="brdPhoto">
	<% End If %>
	<div><span><img src="<%=getThumbImgFromURL(oaward.FItemList(i).FImageBasic,"286","286","true","false") %>" alt="<%=oaward.FItemList(i).FItemName %>" /></span></div>
	<% If i Mod 3 = 2 Then %>
		</div>
	</li>
	<% End If %>
<% next %>
<%
set oaward = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->