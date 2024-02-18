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
<%
'###############################################
' Discription : 스페셜브랜드 - 메인롤링배너
' History : 2019-07-24
'###############################################

Response.ContentType = "application/json"
dim oJson, i

Dim oExhibition, arrSwiperList
dim masterCode

IF application("Svr_Info") = "Dev" THEN
    masterCode = "1"
else
    masterCode = "9"
end if

SET oExhibition = new ExhibitionCls
arrSwiperList = oExhibition.getSwiperListProc( masterCode, "M" , "exhibition" ) '마스터코드 , 채널 , 기획전종류

'object 초기화
Set oJson = jsObject()
set oJson("banners") = jsArray()

if isArray(arrSwiperList) then 
    for i = 0 to ubound(arrSwiperList,2)
        set oJson("banners")(null) = jsObject()
        oJson("banners")(null)("eventCode") = arrSwiperList(12,i)
        oJson("banners")(null)("imgURL") = arrSwiperList(8,i)
        oJson("banners")(null)("headLine") = nl2br(arrSwiperList(5,i))
        oJson("banners")(null)("subCopy") = nl2br(arrSwiperList(20,i))
        oJson("banners")(null)("salePer") = arrSwiperList(22,i)
        oJson("banners")(null)("saleCPer") = arrSwiperList(23,i)
        oJson("banners")(null)("isSale") = arrSwiperList(24,i)
        oJson("banners")(null)("isCoupon") = arrSwiperList(25,i)
        oJson("banners")(null)("leftBGColor") = arrSwiperList(6,i)
        oJson("banners")(null)("rightBGColor") = arrSwiperList(7,i)        
    next
end if

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
