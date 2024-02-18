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
' Discription : 스페셜브랜드 - 이벤트 리스트
' History : 2019-07-25
'###############################################

Response.ContentType = "application/json"
dim oJson, i

Dim oBrand, eventsList

SET oBrand = new SpecialBrandCls
eventsList = oBrand.getSpecialBrandEvents("5")

'object 초기화
Set oJson = jsObject()
set oJson("events") = jsArray()
'set oJson("test") = jsObject()
'oJson("test") = ubound(brandList)

if isArray(eventsList) then
    for i = 0 to ubound(eventsList,2)
        set oJson("events")(null) = jsObject()

        oJson("events")(null)("evt_code") = eventsList(0,i)
        oJson("events")(null)("evt_name") = split(eventsList(1,i), "|")(0)
        oJson("events")(null)("evt_subcopyK") = eventsList(2,i)
        oJson("events")(null)("evt_subname") = eventsList(3,i)
        oJson("events")(null)("salePer") = eventsList(4,i)
        oJson("events")(null)("saleCPer") = eventsList(5,i)
        oJson("events")(null)("issale") = eventsList(6,i)
        oJson("events")(null)("iscoupon") = eventsList(7,i)
        oJson("events")(null)("isgift") = eventsList(8,i)
        oJson("events")(null)("isOnlyTen") = eventsList(9,i)
        oJson("events")(null)("isoneplusone") = eventsList(10,i)
        oJson("events")(null)("isfreedelivery") = eventsList(11,i)
        oJson("events")(null)("isbookingsell") = eventsList(12,i)
        oJson("events")(null)("iscomment") = eventsList(13,i)
        oJson("events")(null)("bannerImg") = eventsList(14,i)

    next
end if

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
