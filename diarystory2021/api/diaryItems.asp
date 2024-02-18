<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/inc_const.asp"-->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<%
'###############################################
' Discription : 2021다이어리 - 상품리스트
' History : 2020-08-18 이종화
'###############################################
Response.ContentType = "application/json"

dim oDoc
dim ListDiv

dim CurrPage    : CurrPage = getNumeric(requestCheckVar(request("cpg"),8))
dim PageSize    : PageSize = getNumeric(requestCheckVar(request("pageSize"),5))
dim SubShopCd   : SubShopCd = request("SubShopCd")
dim SortMet		: SortMet = request("srm")
dim deliType	: deliType = request("deliType")
dim giftdiv		: giftdiv = request("giftdiv")
dim attribCd    : attribCd = request("attribCd")
dim colorCD     : colorCD = request("colorCd")
dim catecode    : cateCode = requestCheckVar(request("cateCode"),100)
dim SubShopGroupCode : SubShopGroupCode = requestCheckVar(request("subShopGroupCode"),12)

dim rectCateCode , arrRectCateCode
if catecode <> "" then
    if instr(catecode,",") > 0 then
        arrRectCateCode = catecode
    else
        rectCateCode = catecode
    end if 
end if 

dim ScrollCount : ScrollCount = 10
dim icoSize : icoSize = "M"
if SortMet = "" then SortMet="be"		'베스트:be, 신상:ne
if PageSize = "" then PageSize=16
if CurrPage = "" then CurrPage=1
if colorCD = "" then colorCD="0"
if SubShopGroupCode <> "" THEN 
    SubShopCd = 100
    ListDiv = "subshop"
else
    SubShopCd = ""
    ListDiv = "fulllist"
END IF 

dim imgSz	: imgSz = chkIIF(icoSize="M",240,150)

set oDoc = new SearchItemCls

oDoc.FCurrPage          = CurrPage
oDoc.FPageSize          = PageSize
oDoc.FScrollCount       = ScrollCount
oDoc.FListDiv           = ListDiv
oDoc.FSubShopCd         = SubShopCd '서브샵(100:다이어리스토리)
oDoc.FGiftDiv           = giftdiv '사은품 종류 ( R: 다이어리 사은품 )
oDoc.FRectSortMethod	= SortMet
oDoc.FcolorCode         = colorCD
oDoc.FattribCd          = attribCd
oDoc.FdeliType	        = deliType
oDoc.FsubShopGroupCode  = SubShopGroupCode '서브샵 그룹코드 

IF ListDiv = "fulllist" THEN
    oDoc.FarrCateForAnyString = catecode
else
    oDoc.FarrCate	        = arrRectCateCode '복수 카테고리
    oDoc.FRectCateCode      = rectCateCode '카테고리
END IF

IF SortMet = "be" THEN 
    oDoc.FminPrice = 3000
END IF

oDoc.getSearchList

dim oJson, oExhibition, i
SET oExhibition = new ExhibitionCls

dim itemid, itemname, basicImage, orgprice, sailyn, itemcouponyn, itemcoupontype, sellcash, salePer, sellYN
dim itemcouponvalue, brandname, itemImg, couponPer, couponPrice, tempPrice, sellDateDiff, isFreeDelivery
dim bestYn, newYn, vgiftDiv
dim saleStr, couponStr
dim evalcount , evaltotalpoint

'object 초기화
Set oJson = jsObject()
    oJson("totalpage") = FormatNumber(oDoc.FTotalPage,0)
set oJson("items") = jsArray()
'Set oJson("pagingData") = jsObject()

IF oDoc.FResultCount > 0 then
    For i = 0 To oDoc.FResultCount -1 
        set oJson("items")(null) = jsObject()

        itemid = oDoc.FItemList(i).FItemID
        itemname = oDoc.FItemList(i).FItemName
        basicImage = oDoc.FItemList(i).FImageBasic
        orgprice = oDoc.FItemList(i).FOrgPrice
        sailyn = oDoc.FItemList(i).IsSaleItem
        itemcouponyn = oDoc.FItemList(i).isCouponItem
        itemcoupontype = oDoc.FItemList(i).Fitemcoupontype
        sellcash = oDoc.FItemList(i).Fsellcash
        itemcouponvalue = oDoc.FItemList(i).Fitemcouponvalue
        brandname = oDoc.FItemList(i).FBrandName
        bestYn = oDoc.FItemList(i).FBestYn
        newYn = oDoc.FItemList(i).FNewYn
        vgiftDiv = oDoc.FItemList(i).FGiftDiv        
        isFreeDelivery = oDoc.FItemList(i).FFreeDeliveryYN
        sellYN = oDoc.FItemList(i).FSellYn

        evalcount = oDoc.FItemList(i).FEvalCnt
        evaltotalpoint = oDoc.FItemList(i).FPoints

        '할인율 계산
        couponPer = oExhibition.GetCouponDiscountStr(itemcoupontype, itemcouponvalue)
        couponPrice = oExhibition.GetCouponDiscountPrice(itemcoupontype, itemcouponvalue, sellcash)
        salePer     = CLng((orgprice-sellcash)/orgprice*100)
        if sailyn and itemcouponyn then '세일, 쿠폰
            tempPrice = sellcash - couponPrice
            saleStr = salePer & "%"
            couponStr = couponPer
        elseif itemcouponyn then    '쿠폰
            tempPrice = sellcash - couponPrice
            saleStr = ""
            couponStr = couponPer
        elseif sailyn then  '세일
            tempPrice = sellcash
            saleStr = salePer & "%"
            couponStr = ""
        else
            tempPrice = sellcash
            saleStr = ""
            couponStr = ""
        end if

        ' fix
        oJson("items")(null)("itemid")      = itemid
        oJson("items")(null)("itemName")    = itemName
        oJson("items")(null)("brandName")   = brandName
        oJson("items")(null)("price")       = formatNumber(tempPrice, 0)
        oJson("items")(null)("saleStr")     = saleStr
        oJson("items")(null)("couponStr")   = couponStr
        oJson("items")(null)("itemImg")     = getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,imgSz,imgSz,"true","false")
        oJson("items")(null)("bestYn")      = bestYn
        oJson("items")(null)("newYn")       = newYn
        oJson("items")(null)("giftDiv")     = vgiftDiv
        oJson("items")(null)("sellYN")      = sellYN
        oJson("items")(null)("isFreeDelivery")  = isFreeDelivery
        oJson("items")(null)("evalcount")   = FormatNumber(evalcount,0)
        oJson("items")(null)("evaltotalpoint")  = fnEvalTotalPointAVG(evaltotalpoint,"search")
    next
end if

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
set oDoc = Nothing
SET oExhibition = Nothing
%> 
<!-- #include virtual="/lib/db/dbclose.asp" -->
