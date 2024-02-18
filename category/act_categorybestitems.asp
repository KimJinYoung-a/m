<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/JSON2.asp" -->
<!-- #include virtual="/lib/classes/search/searchCls.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
	Dim itemid, catecode, i

	itemid = requestCheckVar(request("itemid"),9)	'상품코드
	catecode = requestCheckVar(request("disp"),20)	'카테고리 코드

	dim oCBDoc , ichk
	set oCBDoc = new SearchItemCls
		oCBDoc.FRectSearchTxt = ""
		oCBDoc.FRectPrevSearchTxt = ""
		oCBDoc.FRectExceptText = ""
		oCBDoc.FRectSortMethod	= "be"		'인기상품
		oCBDoc.FRectSearchFlag = "n"			'일반상품
		oCBDoc.FRectSearchItemDiv = "n"		'기본 카테고리만
		oCBDoc.FRectSearchCateDep = "T"		'하위 카테고리 포함
		oCBDoc.FRectCateCode	= CHKIIF(Len(catecode)>8,Left(catecode,9),catecode)
		oCBDoc.FminPrice	= ""
		oCBDoc.FmaxPrice	= ""
		oCBDoc.FdeliType	= ""
		oCBDoc.FCurrPage = 1
		oCBDoc.FPageSize = 37					'9개 접수
		oCBDoc.FScrollCount = 5
		oCBDoc.FListDiv = "list"				'상품목록
		oCBDoc.FLogsAccept = False			'로그 기록안함
		oCBDoc.FAddLogRemove = true			'추가로그 기록안함
		oCBDoc.FcolorCode = "0"				'전체컬러
		oCBDoc.FSellScope= "Y"				'판매중인 상품만
		oCBDoc.getSearchList

	If oCBDoc.FResultCount > 0 Then
		ichk = 1
%>
		<div class="itemAddWrapV16a ctgyBestV16a">
			<div class="bxLGy2V16a">
				<h3><strong>카테고리 인기상품</strong></h3>
			</div>
			<div class="bxWt1V16a">
				<ul class="simpleListV16a simpleListV16b">
                    <%  For i=0 To oCBDoc.FResultCount-1 %>
                        <% if cStr(oCBDoc.FItemList(i).Fitemid)<>cStr(itemid) then	'현재보는 상품이 아니면 표시 %>
                            <li>
                                <a href="/category/category_itemPrd.asp?itemid=<%= oCBDoc.FItemList(i).Fitemid %>&rc=item_cate_<%=ichk%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_categorybest_in_product','itemid|index|searchkeyword|disptype|categoryname','<%= oCBDoc.FItemList(i).Fitemid %>|<%=i%>|none|g|<%=fnCateCodeToCategory1DepthName(left(catecode, 3))%>');">
                                    <p><img src="<%=getStonThumbImgURL(oCBDoc.FItemList(i).FImageBasic,200,200,"true","false")%>" alt="<%=oCBDoc.FItemList(i).FitemName%>" /></p>
                                    <span class="name"><%=oCBDoc.FItemList(i).FitemName%></span>
									<span class="price">
										<b class="sum"><% = FormatNumber(oCBDoc.FItemList(i).getRealPrice,0) %><small class="won">원</small></b>
										<% If oCBDoc.FItemList(i).IsSaleItem Then %>
										<b class="discount color-red"><% = oCBDoc.FItemList(i).getSalePro %></b>
										<% end if %>
									</span>
                                </a>
                            </li>
                            <% ichk = ichk+1 %>
                        <% End If %>
				        <% if ichk>36 then Exit For %>
                    <% Next %>
		        </ul>
	        </div>
        </div>
<%
	End if
	set oCBDoc = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->