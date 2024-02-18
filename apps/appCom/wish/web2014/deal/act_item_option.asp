<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<%
function getOneTypeOptionBoxHtml(byVal iItemID, byVal isItemSoldOut, byVal minnum, byVal maxnum)
	dim i, optionHtml, optionTypeStr, optionKindStr, optionSoldOutFlag, optionSubStyle
    dim oItemOption, minOrderNum, maxOrderNum
    
	set oItemOption = new CItemOption
    oItemOption.FRectItemID = iItemID
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList2
    
	optionHtml = ""
    if (oItemOption.FResultCount<1) Then
		'optionHtml="<li><a href='#' onclick=""fnTempShoppingBagSelect('',"+Cstr(iItemID)+",'0000',0,'','');return false;""><div class='option'>상품선택</div></a></li>"
	End If
	
    
    for i=0 to oItemOption.FResultCount-1
	    optionKindStr       = oItemOption.FItemList(i).FOptionName
	    optionSubStyle = ""
		optionSoldOutFlag   = ""

		'옵션 한정판매 확인
		minOrderNum = chkIIF(oItemOption.FItemList(i).IsLimitSell and oItemOption.FItemList(i).GetOptLimitEa<=0,"0",minnum)
		maxOrderNum = chkIIF(oItemOption.FItemList(i).IsLimitSell, CHKIIF(oItemOption.FItemList(i).GetOptLimitEa<=maxnum,oItemOption.FItemList(i).GetOptLimitEa,maxnum),maxnum)

		if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="S"

		''품절일경우 한정표시 안함
    	if ((isItemSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) then
    		optionKindStr = optionKindStr + " (품절)"
    		optionSubStyle = "soldout"
			optionSoldOutFlag   = true
    	else
    	    if (oitemoption.FItemList(i).Foptaddprice>0) then
    	    '' 추가 가격
    	        optionKindStr = optionKindStr + " (" + FormatNumber(oitemoption.FItemList(i).Foptaddprice,0)  + "원 추가)"
     	    end if
    	
    	    if (oitemoption.FItemList(i).IsLimitSell) then
    		''옵션별로 한정수량 표시
    			optionKindStr = optionKindStr + " (한정 " + CStr(oItemOption.FItemList(i).GetOptLimitEa) + " 개)"
        	end if
        end if
		optionHtml = optionHtml + "<li class='" + optionSubStyle + "'><a href='#' onclick=""fnTempShoppingBagSelect('"+optionKindStr+"',"+Cstr(iItemID)+",'"+Cstr(oItemOption.FItemList(i).Fitemoption)+"',"+CStr(oitemoption.FItemList(i).Foptaddprice)+",'"+CStr(optionSoldOutFlag)+"','"+CStr(oItemOption.FItemList(i).Fitemdiv) + "'," + CStr(minOrderNum) + "," + CStr(maxOrderNum) + ");return false;""><div class='option'>" + optionKindStr + "</div></a></li>"
	next

	getOneTypeOptionBoxHtml = optionHtml
	set oItemOption = Nothing
end Function

Dim itemid, oItem, optionBoxHtml, minnum, maxnum
itemid = requestCheckVar(request("itemid"),10)

set oItem = new CatePrdCls
oItem.GetItemData itemid
minnum = oItem.Prd.ForderMinNum
maxnum = oItem.Prd.ForderMaxNum

optionBoxHtml = getOneTypeOptionBoxHtml(oItem.Prd.FItemID,oItem.Prd.IsSoldOut,minnum,maxnum)

if optionBoxHtml = "" then
	'옵션 장바구니 최대 수량 확인
	minnum = chkIIF(oItem.Prd.IsLimitItemReal and oItem.Prd.FRemainCount<=0,"0",oItem.Prd.ForderMinNum)
	maxnum = chkIIF(oItem.Prd.IsLimitItemReal,CHKIIF(oItem.Prd.FRemainCount<=oItem.Prd.ForderMaxNum,oItem.Prd.FRemainCount,oItem.Prd.ForderMaxNum),oItem.Prd.ForderMaxNum)
	Response.write "notoption="& minnum & "|" & maxnum
else
	Response.write optionBoxHtml
end if
%>



<!-- #include virtual="/lib/db/dbclose.asp" -->