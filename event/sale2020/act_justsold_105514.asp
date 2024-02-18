<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/sale2020/sale2020Cls.asp" -->
<%
'####################################################
' Description : 9월 쇼핑지원 방금판매된
' History : 2020-09-03 허진원
'####################################################
dim oJustSold , i
dim itemsJustSold
dim vDisp : vDisp = requestCheckVar(request("vdisp"),3)
dim page : page = requestCheckVar(request("cpg"),10)
dim pageSize : pageSize = 100
dim totalPrice , salePercentString , couponPercentString , totalSalePercent

IF page = "" THEN page = 1

set oJustSold = new sale2020Cls
    itemsJustSold = oJustSold.getItemsJustSoldLists(vDisp , page , pageSize)
set oJustSold = nothing 

IF isArray(itemsJustSold) THEN
    FOR i = 0 TO Ubound(itemsJustSold) - 1 
    CALL itemsJustSold(i).fnItemPriceInfos(totalPrice , salePercentString , couponPercentString , totalSalePercent)
%> 
<li <%=chkIIF(itemsJustSold(i).FsellYn="N","class=""soldout""","")%> style="display:none;">
    <% If isapp="1" Then %>
    <a href="" onclick="fnAPPpopupAutoUrl('/category/category_itemPrd.asp?itemid=<%=itemsJustSold(i).FItemID%>');return false;">
    <% Else %>
    <a href="/category/category_itemprd.asp?itemid=<%=itemsJustSold(i).FItemID%>">
    <% End If %>
        <div class="label-time"><%=Gettimeset(DateDiff("s",itemsJustSold(i).FSellDate, now()))%></div>
        <div class="thumbnail"><img src="<%=itemsJustSold(i).FPrdImage%>" alt="" /></div>
        <div class="desc">
			<div class="price">
				<%=totalPrice%>
				<% if salePercentString>"0" AND couponPercentString>"0" then %>
				<span>더블할인</span>
				<% elseif salePercentString>"0" then %>
				<span><%=salePercentString%></span>
				<% elseif couponPercentString>"0" then %>
				<span><%=couponPercentString%></span>
				<% end if %>
			</div>
            <div class="name"><%=itemsJustSold(i).Fitemname%></div>
            <div class="brand"><%=itemsJustSold(i).FbrandName%></div>
			<% if itemsJustSold(i).FEvalcnt>"0" then %>
			<div class="review">
				<span class="rating"><i style="width:<%=fnEvalTotalPointAVG(itemsJustSold(i).FPoints,"")%>%;"></i></span>
			</div>
			<% end if %>
        </div>
    </a>
</li>
<% 
    NEXT 
END IF
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->