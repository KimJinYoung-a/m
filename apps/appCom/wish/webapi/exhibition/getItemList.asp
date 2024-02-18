<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<%
'//헤더 출력
Response.ContentType = "application/json"
Response.charset = "utf-8"

'//테스트용 실서버 올릴땐 제거
Call Response.AddHeader("Access-Control-Allow-Origin", "http://localhost:5002")

'#######################################################
' Discription : 통합 기획전 - 상품 api
' History : 2019-11-05 이종화 생성
'#######################################################
DIM masterCode , detailCode , page , pageSize , listType , isPick
DIM oExhibition , i
DIM oJson
DIM itemId , listImage , brandName , itemName
DIM totalPoint , evalCount , favCount , optioncode
DIM listTotalCount , listTotalPage
DIM addText1 , addText2 , optionCount , sellCash

masterCode =  requestCheckvar(request("mastercode"),10)
detailCode =  requestCheckvar(request("detailcode"),10)
page = NullFillWith(requestCheckVar(request("page"),5),"1")
pageSize = NullFillWith(requestCheckVar(request("pagesize"),5),"16")
listType = NullFillWith(requestCheckVar(request("listtype"),1),"A")
isPick = requestCheckvar(request("ispick"),1)

IF isPick <> "1" THEN isPick = ""

ON ERROR RESUME NEXT

SET oJson = jsObject()
SET oJson("itemlist") = jsArray()

SET oExhibition = new ExhibitionCls
	oExhibition.FPageSize = pageSize '// 페이지사이즈
	oExhibition.FCurrPage = page '// 페이지 
	oExhibition.FrectMasterCode = masterCode '// 기획전 고유번호
	oExhibition.FrectDetailCode = detailCode '// 하위 카테고리 번호
	oExhibition.FrectListType = listType
    oExhibition.Frectpick = isPick '// best 여부
	oExhibition.getItemsPageListProc

    listTotalCount = oExhibition.FTotalCount
    listTotalPage = oExhibition.FTotalPage

    oJson("listtotalcount") = listTotalCount
    oJson("listtotalpage") = listTotalPage

IF (Err) THEN
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
ELSE
    DIM totalPrice , salePercentString , couponPercentString , totalSalePercent
    IF oExhibition.FTotalCount > 0 THEN
        FOR i = 0 TO oExhibition.FResultCount-1
            CALL oExhibition.FItemList(i).fnItemPriceInfos(totalPrice , salePercentString , couponPercentString , totalSalePercent)
            
            itemId      = oExhibition.FItemList(i).Fitemid
            itemName    = oExhibition.FItemList(i).Fitemname
            listImage   = oExhibition.FItemList(i).FPrdImage
            brandName   = oExhibition.FItemList(i).FbrandName
            totalPoint  = oExhibition.FItemList(i).FtotalPoint
            evalCount   = oExhibition.FItemList(i).FevalCnt
            favCount    = oExhibition.FItemList(i).FfavCnt
            optioncode  = oExhibition.FItemList(i).Foptioncode
            addText1    = oExhibition.FItemList(i).FAddtext1
            addtext2    = oExhibition.FItemList(i).FAddtext2
            optionCount = oExhibition.FItemList(i).Foptioncnt
            sellCash    = oExhibition.FItemList(i).Fsellcash  

            SET oJson("itemlist")(NULL) = jsObject()
                oJson("itemlist")(NULL)("itemid")           = itemId
                oJson("itemlist")(NULL)("itemname")         = itemName
                oJson("itemlist")(NULL)("itemimage")        = listImage
                oJson("itemlist")(NULL)("brandname")        = brandName
                oJson("itemlist")(NULL)("totalprice")       = totalPrice
                oJson("itemlist")(NULL)("totalsaleper")     = totalSalePercent
                oJson("itemlist")(NULL)("saleperstring")    = salePercentString
                oJson("itemlist")(NULL)("couponperstring")  = couponPercentString
                oJson("itemlist")(NULL)("totalPoint")       = cint(totalPoint*2/10)
                oJson("itemlist")(NULL)("evalCount")        = cint(evalCount)
                oJson("itemlist")(NULL)("favCount")         = cint(favCount)
                oJson("itemlist")(NULL)("optionCode")       = cstr(optioncode)
                oJson("itemlist")(NULL)("addText1")         = cstr(addText1)
                oJson("itemlist")(NULL)("addText2")         = cstr(addtext2)
                oJson("itemlist")(NULL)("optionCount")      = optionCount
                oJson("itemlist")(NULL)("selCash")          = sellCash
        NEXT
    END IF
END IF
	'Json 출력(JSON)
	oJson.flush
SET oJson = NOTHING
SET oExhibition = NOTHING

if ERR then CALL OnErrNoti()
ON ERROR GOTO 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->