<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'//헤더 출력
Response.ContentType = "application/json"
response.charset = "utf-8"

'//테스트용 실서버 올릴땐 제거
'Call Response.AddHeader("Access-Control-Allow-Origin", "http://testm.10x10.co.kr:8080")

'#######################################################
' Discription : diarystoryitems // 72서버
' History : 2018-09-05 이종화 생성
'#######################################################
Dim icnt
Dim sqlStr , rsMem
Dim arrList
Dim cTime : cTime = 60*5
dim dummyName : dummyName = "DHITEM"
dim itemid , itemname , icon1image , basicimage , brandname , makerid
dim sellcash , orgprice , saleyn , sellyn , itemcouponyn , itemcoupontype , itemcouponvalue
dim totalprice , totalsaleper

'// json객체 선언
Dim oJson

sqlStr = "EXEC db_diary2010.dbo.usp_WWW_diary_happytogether_get"
set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
    arrList = rsMem.GetRows
END IF
rsMem.close

on Error Resume Next

Set oJson = jsObject()
Set oJson("diaryitems") = jsArray()

if isarray(arrList) Then
    for icnt = 0 to ubound(arrList,2)

        itemid          = arrList(0,icnt)
        itemname        = arrList(1,icnt)
        icon1image      = webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(itemid) + "/" & arrList(2,icnt)
        basicimage      = webImgUrl & "/image/basic/" & GetImageSubFolderByItemid(itemid) + "/" & arrList(3,icnt) 
        brandname       = arrList(4,icnt) 
        makerid         = arrList(6,icnt)
        sellcash        = arrList(5,icnt)
        orgprice        = arrList(8,icnt)
        saleyn          = arrList(7,icnt)
        sellyn          = arrList(9,icnt)
        itemcouponyn    = arrList(10,icnt)
        itemcoupontype  = arrList(11,icnt)
        itemcouponvalue = arrList(12,icnt)

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

        Set oJson("diaryitems")(null) = jsObject()
            oJson("diaryitems")(null)("itemid")     = itemid
            oJson("diaryitems")(null)("itemname")   = itemname
            oJson("diaryitems")(null)("icon1image") = icon1image
            oJson("diaryitems")(null)("basicimage") = basicimage
            oJson("diaryitems")(null)("brandname")  = brandname
            oJson("diaryitems")(null)("makerid")    = makerid
            oJson("diaryitems")(null)("saleyn")     = saleyn
            oJson("diaryitems")(null)("sellyn")     = sellyn
            oJson("diaryitems")(null)("totalprice") = totalprice
            oJson("diaryitems")(null)("totalsaleper") = totalsaleper
    next
end If
	'Json 출력(JSON)
	oJson.flush
Set oJson = Nothing

on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
