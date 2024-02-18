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
' Description : 정기세일 방금판매된
' History : 2020-03-20 이종화
'####################################################
dim oJustSold , i
dim itemsJustSold
dim vDisp : vDisp = requestCheckVar(request("vdisp"),3)
dim page : page = requestCheckVar(request("cpg"),10)
dim pageSize : pageSize = 20
dim totalPrice , salePercentString , couponPercentString , totalSalePercent

IF page = "" THEN page = 1

set oJustSold = new sale2020Cls
    itemsJustSold = oJustSold.getItemsJustSoldLists(vDisp , page , pageSize)
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
            <div class="price-area"><span class="price"><%=totalPrice%></span>
                <% IF salePercentString > "0"  THEN %><b class="discount sale"><%=salePercentString%></b><% END IF %>
                <% IF couponPercentString > "0" THEN %><b class="discount coupon"><%=couponPercentString%></b><% END IF %>
            </div>
            <p class="name"><%=itemsJustSold(i).Fitemname%></p>
            <span class="brand"><%=itemsJustSold(i).FbrandName%></span>
        </div>
        <div class="etc">
            <% if itemsJustSold(i).FEvalcnt > "0" then %>
            <div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(itemsJustSold(i).FPoints,"")%>%;">리뷰 종합 별점</i></span><span class="counting" title="리뷰 갯수"><%=chkIIF(itemsJustSold(i).FEvalcnt>999,"999+",itemsJustSold(i).FEvalcnt)%></span></div>
            <% end if %>
            <button class="tag wish btn-wish">
                <%
                If itemsJustSold(i).FFavCount > 0 Then
                    Response.Write "<span class=""icon icon-wish"" id=""wish"&itemsJustSold(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"">"& CHKIIF(itemsJustSold(i).FFavCount>999,"999+",formatnumber(itemsJustSold(i).FFavCount,0)) & "</span>"
                Else
                    Response.Write "<span class=""icon icon-wish"" id=""wish"&itemsJustSold(i).FItemID&"""><i> wish</i></span><span class=""counting""></span>"
                End If
                %>
            </button>
        </div>
    </a>
</li>
<% 
    NEXT 
END IF
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->