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
<%
'###############################################
' Discription : 스페셜브랜드 - 후기 리스트
' History : 2019-08-07
'###############################################

Response.ContentType = "application/json"
dim oJson, i

Dim oBrand, reviewList
dim file1, gubun

SET oBrand = new SpecialBrandCls
reviewList = oBrand.getSpecialBrandReviews("100")

'object 초기화
Set oJson = jsObject()
set oJson("review") = jsArray()
'set oJson("test") = jsObject()
'oJson("test") = ubound(brandList)

if isArray(reviewList) then
    for i = 0 to ubound(reviewList,2)
        set oJson("review")(null) = jsObject()

        oJson("review")(null)("itemId") = reviewList(0,i)
        oJson("review")(null)("totalPoint") = reviewList(1,i)
        oJson("review")(null)("userId") = reviewList(2,i)
        oJson("review")(null)("contents") = reviewList(3,i)

        file1 = reviewList(4,i)
        gubun = reviewList(5,i)
        
        oJson("review")(null)("reviewImg") = oBrand.getLinkImage1(gubun, file1, reviewList(0,i))
    next
end if

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
