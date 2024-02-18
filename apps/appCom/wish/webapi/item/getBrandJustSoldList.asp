<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/sale2020/sale2020Cls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<%
'//헤더 출력
Response.ContentType = "application/json"
Response.charset = "utf-8"

'//테스트용 실서버 올릴땐 제거
Call Response.AddHeader("Access-Control-Allow-Origin", "http://localhost:11119")

'#######################################################
' Description : 방금판매된 상품 리스트
' History : 2020-05-07 이종화
'#######################################################
DIM oJson
DIM oJustSold , i
DIM itemsJustSold
DIM cateCode : cateCode = requestCheckVar(request("catecode"),3)
DIM page : page = requestCheckVar(request("page"),10)
DIM pageSize : pageSize = requestCheckVar(request("pagesize"),2)
DIM itemId , itemImage , sellDate , freeDeliveryFlag , isSellYN
DIM itemName , brandName , evaluateCount , evaluatePointAVG , favoriteCount
DIM totalPrice , salePercentString , couponPercentString , totalSalePercent

IF pageSize = "" THEN pageSize = "20"

ON ERROR RESUME NEXT

IF page = "" THEN page = 1

set oJustSold = new sale2020Cls
    itemsJustSold = oJustSold.getItemsStationeryFairJustSoldLists()
set oJustSold = nothing 

SET oJson = jsObject()
SET oJson("itemlist") = jsArray()

IF (Err) THEN
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
ELSE
    IF isArray(itemsJustSold) THEN
        FOR i = 0 TO Ubound(itemsJustSold) - 1 
        CALL itemsJustSold(i).fnItemPriceInfos(totalPrice , salePercentString , couponPercentString , totalSalePercent)
            
            itemId      = itemsJustSold(i).FItemID
            itemImage   = itemsJustSold(i).FPrdImage
            sellDate    = Gettimeset(DateDiff("s",itemsJustSold(i).FSellDate, now()))
            freeDeliveryFlag = itemsJustSold(i).IsFreeBeasong
            isSellYN    = itemsJustSold(i).FsellYn
            itemName    = itemsJustSold(i).Fitemname
            brandName   = itemsJustSold(i).FbrandName
            evaluateCount = itemsJustSold(i).FEvalcnt
            evaluatePointAVG = fnEvalTotalPointAVG(itemsJustSold(i).FPoints,"")
            favoriteCount = itemsJustSold(i).FFavCount

            SET oJson("itemlist")(NULL) = jsObject()
                oJson("itemlist")(NULL)("itemId")           = itemId
                oJson("itemlist")(NULL)("itemImage")        = itemImage
                oJson("itemlist")(NULL)("sellDate")         = sellDate
                oJson("itemlist")(NULL)("freeDeliveryFlag") = freeDeliveryFlag
                oJson("itemlist")(NULL)("isSellYN")         = isSellYN
                oJson("itemlist")(NULL)("itemName")         = itemName
                oJson("itemlist")(NULL)("brandName")        = brandName
                oJson("itemlist")(NULL)("evaluateCount")    = evaluateCount
                oJson("itemlist")(NULL)("evaluatePointAVG") = evaluatePointAVG
                oJson("itemlist")(NULL)("favoriteCount")    = favoriteCount
                oJson("itemlist")(NULL)("totalPrice")       = totalPrice
                oJson("itemlist")(NULL)("salePercentString")= salePercentString
                oJson("itemlist")(NULL)("couponPercentString") = couponPercentString
                oJson("itemlist")(NULL)("totalSalePercent") = totalSalePercent
                
        NEXT
    END IF
END IF
	'Json 출력(JSON)
	oJson.flush
SET oJson = NOTHING

if ERR then CALL OnErrNoti()
ON ERROR GOTO 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->