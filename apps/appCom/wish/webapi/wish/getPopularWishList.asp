<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbCTopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<%
'//헤더 출력
Response.ContentType = "application/json"
response.charset = "utf-8"

'//테스트용 실서버 올릴땐 제거
'Call Response.AddHeader("Access-Control-Allow-Origin", "http://localhost:5002")

'#######################################################
' Discription : 퍼퓰러 위시 데이터 - api
' History : 2019-09-02 이종화 생성
'#######################################################
Dim cPopular, vDisp, vSort, vCurrPage, i, j, vArrEval
	vDisp = RequestCheckVar(Request("disp"),18)
	vSort = NullFillWith(RequestCheckVar(Request("sort"),1),"1")
	vCurrPage = NullFillWith(RequestCheckVar(Request("cpg"),5),"1")

dim itemid , itemname , basicimage , brandname , makerid , sellcash , orgprice
dim saleyn , sellyn , itemcouponyn , itemcoupontype , itemcouponvalue
dim totalprice , totalsaleper , itemoptioncount

'// json객체 선언
Dim oJson

If vCurrPage = "" Then vCurrPage = 1

SET cPopular = New CMyFavorite
	cPopular.FPageSize = 20
	cPopular.FCurrpage = vCurrPage
	cPopular.FRectDisp = vDisp
	cPopular.FRectSortMethod = vSort
	cPopular.FRectUserID = GetLoginUserID()
	cPopular.fnPopularList_CT

on Error Resume Next

Set oJson = jsObject()
Set oJson("wish") = jsArray()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
ELSE
    if cPopular.FResultCount > 0 Then
        For i = 0 To cPopular.FResultCount-1

            itemid          = cPopular.FItemList(i).FItemID
            itemname        = cPopular.FItemList(i).FItemName
            basicimage      = cPopular.FItemList(i).FImageBasic
            brandname       = cPopular.FItemList(i).FBrandName
            makerid         = cPopular.FItemList(i).Fmakerid
            sellcash        = cPopular.FItemList(i).FSellCash
            orgprice        = cPopular.FItemList(i).FOrgPrice
            saleyn          = cPopular.FItemList(i).FSaleyn
            sellyn          = cPopular.FItemList(i).FSellyn
            itemcouponyn    = cPopular.FItemList(i).FItemcouponyn
            itemcoupontype  = cPopular.FItemList(i).FItemCouponType
            itemcouponvalue = cPopular.FItemList(i).FItemCouponValue
            itemoptioncount = cPopular.FItemList(i).FItemOptCount

            If saleyn = "N" and itemcouponyn = "N" Then
                totalprice = formatNumber(orgPrice,0)
            End If
            If saleyn = "Y" and itemcouponyn = "N" Then
                totalprice = formatNumber(sellCash,0)
            End If

            if itemcouponyn = "Y" And itemcouponvalue>0 Then
                If itemcoupontype = "1" Then
                    totalprice =  formatNumber(sellCash - CLng(itemcouponvalue*sellCash/100),0)
                ElseIf itemcoupontype = "2" Then
                    totalprice =  formatNumber(sellCash - itemcouponvalue,0)
                ElseIf itemcoupontype = "3" Then
                    totalprice =  formatNumber(sellCash,0)
                Else
                    totalprice =  formatNumber(sellCash,0)
                End If
            End If

            If saleyn = "Y" and itemcouponyn = "N" Then
                If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then
                    totalsaleper = CLng((orgPrice-sellCash)/orgPrice*100) &"%"
                End If
            ElseIf itemcouponyn = "Y" And itemcouponvalue>0 Then
                If itemcoupontype = "1" Then
                    totalsaleper = CStr(itemcouponvalue) &"%"
                End If
            Else
                    totalsaleper = ""
            End If

            Set oJson("wish")(null) = jsObject()
                oJson("wish")(null)("itemid")       = itemid
                oJson("wish")(null)("itemname")     = itemname
                oJson("wish")(null)("icon1image")   = icon1image
                oJson("wish")(null)("basicimage")   = basicimage
                oJson("wish")(null)("brandname")    = brandname
                oJson("wish")(null)("makerid")      = makerid
                oJson("wish")(null)("saleyn")       = saleyn
                oJson("wish")(null)("sellyn")       = sellyn
                oJson("wish")(null)("totalprice")   = totalprice
                oJson("wish")(null)("totalsaleper") = totalsaleper
                oJson("wish")(null)("itemoptioncount") = itemoptioncount
        next
    end If
END IF
	'Json 출력(JSON)
	oJson.flush
Set oJson = Nothing
SET cPopular = Nothing

on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbCTclose.asp" -->