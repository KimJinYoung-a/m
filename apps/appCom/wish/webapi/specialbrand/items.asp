<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/inc_const.asp"-->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #INCLUDE Virtual="/lib/classes/specialbrand/SpecialBrandCls.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<%
'###############################################
' Discription : 스페셜브랜드 - 상품리스트
' History : 2019-07-25
'###############################################

Response.ContentType = "application/json"
' 이미지
dim oJson, oExhibition, i

dim itemid, itemname, makerid, basicImage, orgprice, sailprice, sailyn, itemcouponyn, itemcoupontype, sailsuplycash, orgsuplycash, couponbuyprice, sellcash, wishItemList, wishItemStr, isWishItem
dim buycash, itemcouponvalue, sellyn, brandname, totalpoint, EVALCNT, FAVCOUNT, tentenimage, tentenimage200, tentenimage400, itemscoreMake, totalpointAvg, itemImg, couponPer, couponPrice, tempPrice, sellDateDiff
dim saleStr, saleType

Dim oBrand, itemList, listType, numOfItems
SET oExhibition = new ExhibitionCls

numOfItems = request("numOfItems")
listType = request("listType")
if listType = "" then listType = "A"
if numOfItems = "" then numOfItems = 100

SET oBrand = new SpecialBrandCls
itemList = oBrand.getSpecialBrandItems(listType, numOfItems, "")
wishItemList = oBrand.getMyWishList(GetEncLoginUserID())

if isarray(wishItemList) then
    for i = 0 to ubound(wishItemList,2)
        wishItemStr = wishItemStr & wishItemList(0,i) & "|" 
    next
end if

'object 초기화
Set oJson = jsObject()
set oJson("items") = jsArray()

if isArray(itemList) then
    for i = 0 to ubound(itemList,2)
        set oJson("items")(null) = jsObject()

        itemid = itemList(0, i)
        itemname = itemList(1, i)
        makerid = itemList(2, i)
        basicImage = itemList(3, i)
        orgprice = itemList(4, i)
        sailprice = itemList(5, i)
        sailyn = itemList(6, i)
        itemcouponyn = itemList(7, i)
        itemcoupontype = itemList(8, i)
        sailsuplycash = itemList(9, i)
        orgsuplycash = itemList(10, i)
        couponbuyprice = itemList(11, i)
        sellcash = itemList(12, i)
        buycash = itemList(13, i)
        itemcouponvalue = itemList(14, i)
        sellyn = itemList(15, i)
        brandname = itemList(16, i)
        totalpoint = itemList(17, i)
        EVALCNT = itemList(18, i)
        FAVCOUNT = itemList(19, i)
        tentenimage = itemList(20, i)
        tentenimage200 = itemList(21, i)
        tentenimage400 = itemList(22, i)
        itemscoreMake = itemList(23, i)
        if listType = "C" then
            sellDateDiff = itemList(24, i)
        end if

        '할인율 계산
        couponPer = oExhibition.GetCouponDiscountStr(itemcoupontype, itemcouponvalue)
        couponPrice = oExhibition.GetCouponDiscountPrice(itemcoupontype, itemcouponvalue, sellcash)
        if sailyn = "Y" and itemcouponyn = "Y" then '세일, 쿠폰
            tempPrice = sellcash - couponPrice
            saleStr = CLng((orgprice-tempPrice)/orgprice*100)
            saleType = "B"
        elseif itemcouponyn = "Y" then    '쿠폰
            tempPrice = sellcash - couponPrice
            saleStr = CLng((orgprice-tempPrice)/orgprice*100)
            saleType = "C"
        elseif sailyn = "Y" then  '세일
            tempPrice = sellcash
            saleStr = CLng((orgprice-tempPrice)/orgprice*100)
            saleType = "S"
        else
            tempPrice = sellcash
            saleStr = ""
            saleType = ""
        end if

        ' 평점
        totalpointAvg = fnEvalTotalPointAVG(totalpoint,"search")

        if ImageExists(tentenimage400) Then
            itemImg = "http://"&vIsTest&"webimage.10x10.co.kr/image/tenten400/" + GetImageSubFolderByItemid(itemid) + "/" + tentenimage400
        ElseIf ImageExists(tentenimage200) Then
            itemImg = "http://"&vIsTest&"webimage.10x10.co.kr/image/tenten200/" + GetImageSubFolderByItemid(itemid) + "/" + tentenimage200
        else
            itemImg	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(itemid) + "/" + basicImage
        End If

        ' fix
        oJson("items")(null)("itemid") = itemid
        oJson("items")(null)("itemName") = itemName
        oJson("items")(null)("brandName") = brandName
        oJson("items")(null)("sellyn") = sellyn
        oJson("items")(null)("evalCnt") = EVALCNT
        oJson("items")(null)("favCnt") = FAVCOUNT
        oJson("items")(null)("price") = tempPrice
        oJson("items")(null)("saleStr") = saleStr
        oJson("items")(null)("saleType") = saleType
        oJson("items")(null)("totalpointAvg") = totalpointAvg
        oJson("items")(null)("itemImg") = itemImg
        oJson("items")(null)("sellDiff") = sellDateDiff        
        if InStr(wishItemStr, itemid) > 0 then
            isWishItem		= true
        else
            isWishItem		= false
        end if        		            
        oJson("items")(null)("isWishItem") = isWishItem				

    next
end if

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
