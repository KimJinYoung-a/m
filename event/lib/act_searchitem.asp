<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls_B.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<%
dim oDoc , i
dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
dim SearchItemDiv : SearchItemDiv="y"	'기본 카테고리만
dim CurrPage : CurrPage = getNumeric(requestCheckVar(request("cpg"),6))
dim SearchFlag : SearchFlag = NullfillWith(requestCheckVar(request("sflag"),2),"n")
dim minPrice : minPrice = getNumeric(requestCheckVar(Replace(request("minPrc"),",",""),8))
dim maxPrice : maxPrice = getNumeric(requestCheckVar(Replace(request("maxPrc"),",",""),8))
dim CheckResearch : CheckResearch= request("chkr")
dim CheckExcept : CheckExcept= request("chke")
dim SellScope 	: SellScope=requestCheckVar(request("sscp"),1)			'품절상품 제외여부
dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),5))
dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
Dim mode : mode = requestCheckVar(request("mode"),1) ''리스트형 썸네일형
Dim ListDiv : ListDiv = ReplaceRequestSpecialChar(request("lstdiv"))	'카테고리/검색 구분용
Dim linkUrl


if SortMet="" then SortMet="bs"		'베스트:be, 신상:ne
if ListDiv="" then ListDiv="search"
if CurrPage = "" then CurrPage = 1
if PageSize = "" then PageSize = 5
if SellScope = "" then SellScope = "N"

SearchText = RepWord(SearchText,"[^ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9.&%+\-\_\(\)\/\\\[\]\~\s]","")

set oDoc = new SearchItemCls
    oDoc.FRectSearchTxt = SearchText
    oDoc.FminPrice	= minPrice
	oDoc.FmaxPrice	= maxPrice
    oDoc.FCurrPage = CurrPage
	oDoc.FPageSize = PageSize
    oDoc.FListDiv  = ListDiv
    oDoc.FRectSortMethod = SortMet
    oDoc.FSellScope		= SellScope
    oDoc.FScrollCount 	= 1
    oDoc.FRectSearchItemDiv = SearchItemDiv
    oDoc.getSearchList

    If oDoc.FTotalCount > 0 Then
%>
<style>
.moreitems {display : none;}
</style>
<ul>
<%
        For i=0 To oDoc.FResultCount-1

        if isapp then
            linkUrl = "javascript:fnAPPpopupProduct('"& oDoc.FItemList(i).FItemID &"')"
        else
            linkUrl = "/category/category_itemPrd.asp?itemid="& oDoc.FItemList(i).FItemID &"&disp="& oDoc.FItemList(i).FCateCode
        end if 
%>
        <% If oDoc.FItemList(i).FItemDiv="21" Then %>
            <li <%=chkiif(i>5,"class='moreitems'","")%>>
                <a href="<%=linkUrl%>">
                    <div class="thumbnail">
                        <img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,300,300,"true","false") %>" alt="<%=oDoc.FItemList(i).FItemName%>">
                        <% If oDoc.FItemList(i).isSoldOut Then Response.Write "<b class=""soldout"">일시 품절</b>" End If %>
                    </div>
                    <div class="desc">
                        <div class="price">
                            <%
                                If oDoc.FItemList(i).FOptionCnt="" Or oDoc.FItemList(i).FOptionCnt="0" Then	'### 쿠폰 X 세일 O
                                    Response.Write "<b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getOrgPrice,0) & "<span class=""won"">" & CHKIIF(oDoc.FItemList(i).IsMileShopitem," Point","원") & "</span></b>" &  vbCrLf
                                Else
                                    Response.Write "<b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getOrgPrice,0) & "<span class=""won"">원</span></b>"
                                    Response.Write "<b class=""discount color-red"">" & oDoc.FItemList(i).FOptionCnt & "%</b>"
                                End If
                            %>
                        </div>
                        <p class="name"><%=oDoc.FItemList(i).FItemName%></p>
                        <p class="brand"><%=oDoc.FItemList(i).FBrandName %></p>
                    </div>
                    <% If oDoc.FItemList(i).FEvalCnt > 0 Then %>
                    <div class="etc">								
                        <div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(oDoc.FItemList(i).FPoints,"search")%>%;"><%=fnEvalTotalPointAVG(oDoc.FItemList(i).FPoints,"search")%>점</i></span><span class="counting" title="리뷰 갯수"><%=CHKIIF(oDoc.FItemList(i).FEvalCnt>999,"999+",oDoc.FItemList(i).FEvalCnt)%></span></div>
                    </div>
                    <% End If %>
                </a>
            </li>
        <% else %>
            <li <%=chkiif(i>5,"class='moreitems'","")%>>
                <a href="<%=linkUrl%>">
                    <div class="thumbnail">
                        <img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,300,300,"true","false") %>" alt="<%=oDoc.FItemList(i).FItemName%>">
                        <% If oDoc.FItemList(i).isSoldOut Then Response.Write "<b class=""soldout"">일시 품절</b>" End If %>
                    </div>
                    <div class="desc">
                        <div class="price">
                            <%
                                If oDoc.FItemList(i).IsSaleItem AND oDoc.FItemList(i).isCouponItem Then	'### 쿠폰 O 세일 O
                                    Response.Write "<b class=""sum"">" & FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
                                    Response.Write "<b class=""discount color-red"">" & oDoc.FItemList(i).getSalePro & "</b>"
                                    If oDoc.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
                                        If InStr(oDoc.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
                                            Response.Write "<b class=""discount color-green""><small>쿠폰</small></b>"
                                        Else
                                            Response.Write "<b class=""discount color-green"">" & oDoc.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
                                        End If
                                    End If
                                ElseIf oDoc.FItemList(i).IsSaleItem AND (Not oDoc.FItemList(i).isCouponItem) Then	'### 쿠폰 X 세일 O
                                    Response.Write "<b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "<span class=""won"">원</span></b>"
                                    Response.Write "<b class=""discount color-red"">" & oDoc.FItemList(i).getSalePro & "</b>"
                                ElseIf oDoc.FItemList(i).isCouponItem AND (NOT oDoc.FItemList(i).IsSaleItem) Then	'### 쿠폰 O 세일 X
                                    Response.Write "<b class=""sum"">" & FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
                                    If oDoc.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
                                        If InStr(oDoc.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
                                            Response.Write "<b class=""discount color-green""><small>쿠폰</small></b>"
                                        Else
                                            Response.Write "<b class=""discount color-green"">" & oDoc.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
                                        End If
                                    End If
                                Else
                                    Response.Write "<b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "<span class=""won"">" & CHKIIF(oDoc.FItemList(i).IsMileShopitem,"Point","원") & "</span></b>" &  vbCrLf
                                End If
                            %>
                        </div>
                        <p class="name"><%=oDoc.FItemList(i).FItemName%></p>
                        <p class="brand"><%=oDoc.FItemList(i).FBrandName %></p>
                    </div>
                    <% If oDoc.FItemList(i).FEvalCnt > 0 Then %>
                    <div class="etc">								
                        <div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(oDoc.FItemList(i).FPoints,"search")%>%;"><%=fnEvalTotalPointAVG(oDoc.FItemList(i).FPoints,"search")%>점</i></span><span class="counting" title="리뷰 갯수"><%=CHKIIF(oDoc.FItemList(i).FEvalCnt>999,"999+",oDoc.FItemList(i).FEvalCnt)%></span></div>
                    </div>
                    <% End If %>
                </a>
            </li>
        <% end if %>
<%
        next
%>
</ul>
<button class="btn-more" id="addmore">더 많은 상품보기</button>
<button class="btn-more" id="searchmore" style="display:none;">더 보러가기</button>
<script>
$(function() {
    $("#addmore").click(function() {
        $(this).hide();
        $("#searchmore").show();
        $(".moreitems").show();
    })

    $("#searchmore").click(function() {
        <% if isapp then %>
            fnAPPpopupSearch('<%=SearchText%>');
        <% else %>
            top.location.href = "/search/search_item.asp?search_on=on&rect=<%=SearchText%>&cpg=1&psz=15&minPrc=<%=minPrice%>&maxPrc=<%=maxPrice%>";
        <% end if %>
    })
})
</script>
<%
    end if 
set oDoc = nothing
%>