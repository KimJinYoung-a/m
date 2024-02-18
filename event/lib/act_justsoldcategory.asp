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
' Description : 카테고리 방금판매된
' History : 2020-06-04 이종화
'####################################################
dim oJustSold , i
dim itemsJustSold
dim page : page = requestCheckVar(request("cpg"),10)
dim pageSize : pageSize = 6
dim totalPrice , salePercentString , couponPercentString , totalSalePercent

IF page = "" THEN page = 1

set oJustSold = new sale2020Cls
    itemsJustSold = oJustSold.getCategoryItemsJustSoldLists(page , pageSize)
set oJustSold = nothing 

IF isArray(itemsJustSold) THEN
    FOR i = 0 TO Ubound(itemsJustSold) - 1 
    CALL itemsJustSold(i).fnItemPriceInfos(totalPrice , salePercentString , couponPercentString , totalSalePercent)
%> 
<li>
    <% If isapp="1" Then %>
        <a href="" onclick="fnAPPpopupAutoUrl('/category/category_itemPrd.asp?itemid=<%=itemsJustSold(i).FItemID%>');return false;">
    <% Else %>
        <a href="/category/category_itemprd.asp?itemid=<%=itemsJustSold(i).FItemID%>">
    <% End If %>
        <div class="thumbnail">
            <img src="<%=itemsJustSold(i).FPrdImage%>" alt="" />
            <div class="badge  badge-time"><%=Gettimeset(DateDiff("s",itemsJustSold(i).FSellDate, now()))%></div>
            <% IF itemsJustSold(i).IsFreeBeasong THEN %>
            <div class="badge-group">
                <div class="badge-item badge-delivery">무료배송</div>
            </div>
            <% END IF %>
            <% IF itemsJustSold(i).FsellYn = "N" THEN %>
            <span class="soldout"><span class="ico-soldout">일시품절</span></span>
            <% END IF %>
        </div>
        <div class="desc">
            <div class="price">
                <b class="sum"><%=totalPrice%><span class="won">원</span></b>
                <% IF salePercentString > "0"  THEN %><b class="discount color-red"><%=salePercentString%></b><% END IF %>
                <% IF couponPercentString > "0" THEN %><b class="discount color-green"><%=couponPercentString%></b><% END IF %>
            </div>
            <p class="name"><%=itemsJustSold(i).Fitemname%></p>
            <p class="brand"><%=itemsJustSold(i).FbrandName%></p>
        </div>
        <% If itemsJustSold(i).FevalCnt > 0 Then %>
        <div class="etc">								
            <div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(itemsJustSold(i).FPoints,"")%>%;"><%=fnEvalTotalPointAVG(itemsJustSold(i).FPoints,"search")%>점</i></span><span class="counting" title="리뷰 갯수"><%=CHKIIF(itemsJustSold(i).FevalCnt>999,"999+",itemsJustSold(i).FevalCnt)%></span></div>
        </div>
        <% End If %>
    </a>
</li>
<% 
    NEXT 
END IF
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->