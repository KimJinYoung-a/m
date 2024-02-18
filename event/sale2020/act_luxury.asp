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
' Description : 정기세일 BEST 명품
' History : 2020-03-20 이종화
'####################################################
dim oLuxury , i
dim luxuryItems
dim page : page = requestCheckVar(request("cpg"),10)
dim pageSize : pageSize = 20
dim totalPrice , salePercentString , couponPercentString , totalSalePercent

IF page = "" THEN page = 1

set oLuxury = new sale2020Cls
    luxuryItems = oLuxury.getLuxuryProductsLists(page , pageSize)
set oLuxury = nothing 

IF isArray(luxuryItems) THEN
    FOR i = 0 TO Ubound(luxuryItems) - 1 
    CALL luxuryItems(i).fnItemPriceInfos(totalPrice , salePercentString , couponPercentString , totalSalePercent)
%> 
<li>
    <% If isapp="1" Then %>
        <a href="" onclick="fnAPPpopupAutoUrl('/category/category_itemPrd.asp?itemid=<%=luxuryItems(i).FItemID%>');return false;">
    <% Else %>
        <a href="/category/category_itemprd.asp?itemid=<%=luxuryItems(i).FItemId%>">
    <% End If %>
        <div class="thumbnail">
            <img src="<%=luxuryItems(i).FPrdImage%>" alt="" />
            <div class="badge"><%= chkiif(page > 1 ,i+1 + ((page-1)*pageSize)  ,i+1) %></div>
            <% IF luxuryItems(i).IsFreeBeasong THEN %>
            <div class="badge-group">
                <div class="badge-item badge-delivery">무료배송</div>
            </div>
            <% END IF %>
            <% IF luxuryItems(i).FsellYn = "N" THEN %>
            <span class="soldout"><span class="ico-soldout">일시품절</span></span>
            <% END IF %>
        </div>
        <div class="desc">
            <div class="price-area"><span class="price"><%=totalPrice%></span>
                <% IF salePercentString > "0"  THEN %><b class="discount sale"><%=salePercentString%></b><% END IF %>
                <% IF couponPercentString > "0" THEN %><b class="discount coupon"><%=couponPercentString%></b><% END IF %>
            </div>
            <p class="name"><%=luxuryItems(i).Fitemname%></p>
            <span class="brand"><%=luxuryItems(i).FbrandName%></span>
        </div>
        <div class="etc">
            <% if luxuryItems(i).FEvalcnt > 0 then %>
            <div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(luxuryItems(i).FPoints,"")%>%;">리뷰 종합 별점</i></span><span class="counting" title="리뷰 갯수"><%=chkIIF(luxuryItems(i).FEvalcnt>999,"999+",luxuryItems(i).FEvalcnt)%></span></div>
            <% end if %>
            <button class="tag wish btn-wish">
                <%
                If luxuryItems(i).FFavCount > 0 Then
                    Response.Write "<span class=""icon icon-wish"" id=""wish"&luxuryItems(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"">"& CHKIIF(luxuryItems(i).FFavCount>999,"999+",formatnumber(luxuryItems(i).FFavCount,0)) & "</span>"
                Else
                    Response.Write "<span class=""icon icon-wish"" id=""wish"&luxuryItems(i).FItemID&"""><i> wish</i></span><span class=""counting""></span>"
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