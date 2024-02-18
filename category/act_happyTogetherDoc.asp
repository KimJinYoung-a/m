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
	dim oHTBCItem, chkHT, itemid, catecode, rcpUid, vPrdList, vMtdList, mtv, tmpArr, mAbTestMobile
	dim lp, vIid, vMtd(), vLnk(), IValue
	dim oDoc, isSearchUsed, rect, iDocResultNo, iDocResultArr
	Dim sNo, viewMaxItemNo : viewMaxItemNo=12
	ReDim vMtd(8), vLnk(8)

	itemid = requestCheckVar(request("itemid"),10)	'상품코드 128=>10
	catecode = requestCheckVar(request("disp"),18)	'전시카테고리
    rect = requestCheckVar(request("rect"),30)  ''검색키워드 30자정도..
	'// 모바일 고도화용 a/b 테스트
	mAbTestMobile = requestCheckVar(request("amp"),18)
    
    if (rect<>"") then
        rect = Trim(replace(rect,"텐바이텐",""))
        rect = RepWord(rect,"[^ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9.&%+\-\_\s]","")
    end if
    
    isSearchUsed = False
    if (LEN(rect)>=2) then
        
        isSearchUsed = True
    	set oDoc = new SearchItemCls
    		oDoc.FRectSearchTxt = rect
    		oDoc.FRectPrevSearchTxt = ""
    		oDoc.FRectExceptText = ""
    		oDoc.FRectSortMethod	= "be"		'인기상품
    		oDoc.FRectSearchFlag = "n"			'일반상품
    		oDoc.FRectSearchItemDiv = "n"		'기본 카테고리만
    		oDoc.FRectSearchCateDep = "T"		'하위 카테고리 포함
    		oDoc.FRectCateCode	= ""            ''vDisp
    		oDoc.FminPrice	= ""
    		oDoc.FmaxPrice	= ""
    		oDoc.FdeliType	= ""
    		oDoc.FCurrPage = 1
    		oDoc.FPageSize = viewMaxItemNo+1	'12개 접수
    		oDoc.FScrollCount = 5
    		oDoc.FListDiv = "search"				'상품목록
    		oDoc.FLogsAccept = False			'로그 기록안함
			oDoc.FAddLogRemove = true			'추가로그 기록안함
    		oDoc.FcolorCode = "0"				'전체컬러
    		oDoc.FSellScope= "Y"				'판매중인 상품만
    		oDoc.getSearchList
        
        iDocResultNo = oDoc.FResultCount
        
    end if
    
	'//클래스 선언
	set oHTBCItem = New CAutoCategory
	oHTBCItem.FRectItemId = itemid
	oHTBCItem.FRectDisp = catecode


	'// 텐바이텐 해피투게더 상품 목록
	if (iDocResultNo<viewMaxItemNo+1) then
	    oHTBCItem.GetCateRightHappyTogetherList
    end If
%>
<%
    if (oHTBCItem.FResultCount+iDocResultNo>3) Then
%>
		<div class="itemAddWrapV16a ctgyBestV16a">
			<div class="bxLGy2V16a">
				<h3><strong>같이 본 상품</strong></h3>
			</div>
			<div class="bxWt1V16a">
				<ul class="simpleListV16a simpleListV16b">
					<% if (isSearchUsed) then %>
					<% For lp = 0 To oDoc.FResultCount - 1 %>
						<% if sNo>=viewMaxItemNo then Exit For %>
						<% if (oDoc.FItemList(lp).FItemId<>itemid) then %>
						<% iDocResultArr = iDocResultArr & CStr(oDoc.FItemList(lp).FItemId) & "," %>
						<li>
							<a href="/category/category_itemprd.asp?itemid=<%= oDoc.FItemList(lp).FItemId %>&rc=item_happy_<%=lp+1%>&disptype=n" onclick="fnAmplitudeEventMultiPropertiesAction('click_itemprd_happytogether','itemid|index|searchkeyword|disptype','<%= oDoc.FItemList(lp).FItemId %>|<%=lp%>|<%=rect%>|n');">
								<p><img src="<%=oDoc.FItemList(lp).FImageIcon1 %>" alt="<%=oDoc.FItemList(lp).FItemName%>" /></p>
								<span class="name"><%=oDoc.FItemList(lp).FItemName%></span>
								<span class="price">
									<b class="sum"><% = FormatNumber(oDoc.FItemList(lp).getRealPrice,0) %><small class="won"><%=chkIIF(oDoc.FItemList(lp).IsMileShopitem,"Point","원")%></small></b>
									<% If oDoc.FItemList(lp).IsSaleItem Then %>
									<b class="discount color-red"><% = oDoc.FItemList(lp).getSalePro %></b>
									<% end if %>
								</span>																								
							</a>
						</li>
						<% sNo = sNo+1 %>
						<% end if %>
					<% Next %>
					<% end if %>
					
					<%	For lp = 0 To oHTBCItem.FResultCount - 1 %>
						<% if sNo>=viewMaxItemNo then Exit For %>
						<% if InStr(iDocResultArr,CStr(oHTBCItem.FItemList(lp).FItemId)&",")<1 then %>
						<li>
							<a href="/category/category_itemprd.asp?itemid=<%= oHTBCItem.FItemList(lp).FItemId %>&rc=item_happy_<%=lp+1%>&disptype=n" onclick="fnAmplitudeEventMultiPropertiesAction('click_itemprd_happytogether','itemid|index|searchkeyword|disptype','<%= oHTBCItem.FItemList(lp).FItemId %>|<%=lp%>|none|n');">
								<p><img src="<%=oHTBCItem.FItemList(lp).FIcon1Image %>" alt="<%=oHTBCItem.FItemList(lp).FItemName%>" /></p>
								<span class="name"><%=oHTBCItem.FItemList(lp).FItemName%></span>

								<span class="price">
									<b class="sum"><% = FormatNumber(oHTBCItem.FItemList(lp).getRealPrice,0) %><small class="won"><%=chkIIF(oHTBCItem.FItemList(lp).IsMileShopitem,"Point","원")%></small></b>
									<% If oHTBCItem.FItemList(lp).IsSaleItem Then %>
									<b class="discount color-red"><% = oHTBCItem.FItemList(lp).getSalePro %></b>
									<% end if %>
								</span>				
							</a>
						</li>
						<% sNo = sNo+1 %>
						<% end if %>
					<% Next %>
				</ul>
			</div>
		</div>
<%
    end if
    
	set oHTBCItem = nothing
	if (isSearchUsed) then
	    set oDoc = Nothing
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->