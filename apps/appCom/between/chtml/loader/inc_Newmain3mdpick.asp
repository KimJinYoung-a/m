<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbCTopen.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/mainCls.asp"-->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<%
response.charset = "utf-8"
Dim strMDPickURL, linkurl, filename, oMainMDPick
Dim sqlStr, arrMDpick, totMdcnt, strBody, i
Dim rsMem
Public Function getSalePros(orgprice, sellcash)
	If orgprice=0 then
		getSalePros = 0 & "%"
	Else
		getSalePros = CLng((orgprice-sellcash)/orgprice*100) & "%"
	End if
End Function

If fnGetUserInfo("sex") = "M" Then
	sqlStr = ""
	sqlStr = sqlStr & " SELECT TOP 3 i.*, "
	sqlStr = sqlStr & " pg.idx, isnull(pg.MainMdpickSortNo, 0) as MainMdpickSortNo, pg.MainMdpickXMLRegdate "
	sqlStr = sqlStr & " FROM db_outmall.dbo.tbl_between_project_groupItem as pg "
	sqlStr = sqlStr & " JOIN db_AppWish.dbo.tbl_item as i on pg.itemid = i.itemid "
	sqlStr = sqlStr & " WHERE 1 = 1 "
	sqlStr = sqlStr & " and pg.mdpickgender = 'M' and pg.mdpickIsUsing = 'Y' "
	sqlStr = sqlStr & " ORDER BY pg.MainMdpickSortNo ASC "
	'response.write sqlStr
	set rsMem = getDBCacheSQL(dbCTget,rsCTget,"MDPm",sqlStr,60*3)
	If Not rsMem.EOF Then
		arrMDpick 	= rsMem.GetRows
		totMdcnt   = ubound(arrMDpick,2)
	End if
	rsMem.close
Else
	sqlStr = ""
	sqlStr = sqlStr & " SELECT TOP 3 i.*, "
	sqlStr = sqlStr & " pg.idx, isnull(pg.MainMdpickSortNo, 0) as MainMdpickSortNo, pg.MainMdpickXMLRegdate "
	sqlStr = sqlStr & " FROM db_outmall.dbo.tbl_between_project_groupItem as pg "
	sqlStr = sqlStr & " JOIN db_AppWish.dbo.tbl_item as i on pg.itemid = i.itemid "
	sqlStr = sqlStr & " WHERE 1 = 1 "
	sqlStr = sqlStr & " and pg.mdpickgender = 'F' and pg.mdpickIsUsing = 'Y' "
	sqlStr = sqlStr & " ORDER BY pg.MainMdpickSortNo ASC "
	'response.write sqlStr
	set rsMem = getDBCacheSQL(dbCTget,rsCTget,"MDPf",sqlStr,60*3)
	If Not rsMem.EOF Then
		arrMDpick 	= rsMem.GetRows
		totMdcnt   = ubound(arrMDpick,2)
	End if
	rsMem.close
End If

Dim sailyn, orgprice, sellcash, salepro, itemid, itemname, basicImg

if totMdcnt>0 then
For i = 0 to totMdcnt
	itemid		= arrMDpick(0,i)
	itemname	= arrMDpick(7,i)
	sailyn		= arrMDpick(21,i)
	orgprice 	= arrMDpick(10,i)
	sellcash 	= FormatNumber(arrMDpick(8,i), 0)
	basicImg	= arrMDpick(49,i)
	basicImg = "http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(itemid) & "/" & basicImg
	
	If sailyn = "Y" Then
		salepro = getSalePros(orgprice, sellcash)
	Else
		salepro = "NotSale"
	End If
%>

	<li>
		<div <%= ChkIIF(salepro <> "NotSale", " class='sale'", "") %>>
		<a href='/apps/appCom/between/category/category_itemPrd.asp?itemid=<%=itemid%>'>
			<p class='pdtPic'><img src='<%= basicImg %>' alt='<%= itemname %>' /></p>
			<p class='pdtName'><%= itemname %></p>
			<p class='price'><%= sellcash %>원</p>
		<% If salepro <> "NotSale" Then %>
			<p class='pdtTag saleRed'><%= salepro %></p>
		<% End If %>
		</a>
	</div>
</li>
<%
Next
end if
%>
<!-- #include virtual="/lib/db/dbCTclose.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
