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
' Discription : 스페셜브랜드 - 브랜드 리스트
' History : 2019-07-25
'###############################################

Response.ContentType = "application/json"
dim oJson, i

Dim oBrand, brandList

SET oBrand = new SpecialBrandCls
brandList = oBrand.getSpecialBrandInfo( "A", "500" , "" ) 

'object 초기화
Set oJson = jsObject()
set oJson("brands") = jsArray()
'set oJson("test") = jsObject()
'oJson("test") = ubound(brandList)

if isArray(brandList) then 
    for i = 0 to ubound(brandList) -1
        set oJson("brands")(null) = jsObject()
        oJson("brands")(null)("brandId") = brandList(i).FBrandid
        oJson("brands")(null)("socname") = brandList(i).Fsocname
        oJson("brands")(null)("socname_kor") = brandList(i).Fsocname_kor
        oJson("brands")(null)("brand_icon") = brandList(i).Fbrand_icon
        oJson("brands")(null)("isNew") = brandList(i).FgotNewItem
    next
end if

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
