<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/JSON2.asp" -->
<!--<//script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script-->
<%
	dim oHTBCItem, chkHT, itemid, catecode, rcpUid, vPrdList, vMtdList, mtv, tmpArr
	dim lp, vIid, vMtd(), vLnk(), IValue
	ReDim vMtd(8), vLnk(8)

	chkHT = requestCheckVar(request("chk"),1)		'RecoPick A/B 테스트용 구분 (N:recoPick, O:텐바이텐 로직)
	itemid = requestCheckVar(request("itemid"),128)	'상품코드
	catecode = requestCheckVar(request("disp"),18)	'전시카테고리
	rcpUid = requestCheckVar(request("ruid"),32)	'recoPick 사용자번호
	vPrdList = requestCheckVar(request("prdlist"), 128) 'recopick에서 가져온 추천리스트 itemid값
	vMtdList = requestCheckVar(request("MtdList"), 32) 'recopick에서 가져온 method 값

	If Trim(vPrdList) <> "" Then
		vPrdList = CStr(vPrdList)
	End If

	If Trim(vMtdList) <> "" Then
		tmpArr = Split(vMtdList, ",")
		For mtv = 0 To UBound(tmpArr)
			vMtd(mtv) = tmpArr(mtv)
		Next
	End If


Dim optionBoxHtml
'' OldType Option Box를 한 콤보로 표시// 마일리지 및 위시리스트 동시사용
function getOneTypeOptionBoxHtmlMile(byVal iItemID, byVal isItemSoldOut, byval iOptionBoxStyle, byVal isLimitView)
	dim i, optionHtml, optionTypeStr, optionKindStr, optionSoldOutFlag, optionSubStyle
    dim oItemOption

	set oItemOption = new CItemOption
    oItemOption.FRectItemID = iItemID
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList

    if (oItemOption.FResultCount<1) then Exit Function

    optionTypeStr = oItemOption.FItemList(0).FoptionTypeName
    if (Trim(optionTypeStr)="") then
        optionTypeStr = "옵션 선택"
    else
        optionTypeStr = optionTypeStr + " 선택"
    end if
	optionHtml = "<select class='optSelect2' title='옵션을 선택해주세요' name='item_option_"&iItemID&"' " + iOptionBoxStyle + ">"
    optionHtml = optionHtml + "<option value='' selected>" & optionTypeStr & "</option>"


    for i=0 to oItemOption.FResultCount-1
	    optionKindStr       = oItemOption.FItemList(i).FOptionName
	    optionSoldOutFlag   = ""

		if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="S"

		''품절일경우 한정표시 안함
    	if ((isItemSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) then
    		optionKindStr = optionKindStr + " (품절)"
    		optionSubStyle = "style='color:#DD8888'"
    	else
    	    if (oitemoption.FItemList(i).Foptaddprice>0) then
    	    '' 추가 가격
    	        optionKindStr = optionKindStr + " (" + FormatNumber(oitemoption.FItemList(i).Foptaddprice,0)  + "원 추가)"
    	    end if

    	    if (oitemoption.FItemList(i).IsLimitSell) then
    		''옵션별로 한정수량 표시
    		    If (isLimitView) then
        			optionKindStr = optionKindStr + " (한정 " + CStr(oItemOption.FItemList(i).GetOptLimitEa) + " 개)"
        		end if
        	end if
        	optionSubStyle = ""
        end if

        optionHtml = optionHtml + "<option id='" + optionSoldOutFlag + "' " + optionSubStyle + " value='" + oItemOption.FItemList(i).FitemOption + "'>" + optionKindStr + "</option>"
	next

    optionHtml = optionHtml + "</select>"

	getOneTypeOptionBoxHtmlMile = optionHtml
	set oItemOption = Nothing
end function


	'//클래스 선언
	set oHTBCItem = New CAutoCategory
	oHTBCItem.FRectItemId = itemid
	oHTBCItem.FRectDisp = catecode


	if chkHT="N" then
		If vPrdList<>"" Then
			oHTBCItem.FRectitemarr = vPrdList
			oHTBCItem.GetRecoPick_CateBestItemList
		Else
			oHTBCItem.GetCateRightHappyTogetherNCateBestItemList
		End If
	Else
		'// 텐바이텐 해피투게더 상품 목록
		oHTBCItem.GetCateRightHappyTogetherNCateBestItemList
	end If
	

	if oHTBCItem.FResultCount>0 then
%>
<div class="ctgyPopularList3">
	<h2 class="tit02 tMar30"><span>ONLY YOU</span></h2>
	<div class="swiper-container swiper7">
		<div class="swiper-wrapper">
			<ul class="simpleList swiper-slide">
				<%	For lp = 0 To oHTBCItem.FResultCount - 1 %>
				<% if lp>8 then Exit For %>
					<li>
						<a href="" onclick="FnGoProdItem(<%=oHTBCItem.FItemList(lp).FItemId %>,<%=itemid%>,'<%=chkIIF(oHTBCItem.FItemList(lp).FUseETC="R",vMtd(lp),"20")%>','<%=oHTBCItem.FItemList(lp).FUseETC%>','<%=rcpUid%>','<%=chkIIF(oHTBCItem.FItemList(lp).FUseETC="R",vLnk(lp),"")%>','recopick_itemprd_onlyyou'); return false;">
							<p><img src="<%=oHTBCItem.FItemList(lp).FImageicon1 %>" alt="<%=oHTBCItem.FItemList(lp).FItemName%>" /></p>
							<span><%=oHTBCItem.FItemList(lp).FItemName%></span>
							<span class="price"><% = FormatNumber(oHTBCItem.FItemList(lp).getRealPrice,0) %>원</span>
						</a>
					</li>
					<% Select Case Trim(lp) %>
						<% Case "2", "5" %>
							</ul>
							<ul class="simpleList swiper-slide">
						<% Case "8" %>
							</ul>
					<% End Select %>
				<% Next %>
		</div>
	</div>
	<div class="pagination"></div>
</div>

<%
	end if
	set oHTBCItem = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->

<script>
	mySwiper7 = new Swiper('.swiper7',{
		pagination:'.ctgyPopularList3 .pagination',
		paginationClickable:true,
		loop:true,
		resizeReInit:true,
		calculateHeight:true
	});
</script>