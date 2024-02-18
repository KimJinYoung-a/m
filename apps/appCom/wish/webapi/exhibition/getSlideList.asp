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
' Discription : 통합 기획전 - 이벤트 리스트 api
' History : 2019-11-05 이종화 생성
'#######################################################
DIM masterCode , pageSize , listType
DIM oExhibition , arrSwiperList , i
'// json객체 선언
DIM oJson

masterCode =  requestCheckvar(request("mastercode"),10)

ON ERROR RESUME NEXT

SET oJson = jsObject()
SET oJson("slidelist") = jsArray()

SET oExhibition = new ExhibitionCls
arrSwiperList = oExhibition.getSwiperListProc( masterCode , "M" , "exhibition" ) '마스터코드 , 채널 , 기획전종류

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
ELSE
    '// event 
    if isArray(arrSwiperList) then 
        for i = 0 to ubound(arrSwiperList,2)

            SET oJson("slidelist")(NULL) = jsObject()
                oJson("slidelist")(NULL)("idx")             = arrSwiperList(0,i)
                oJson("slidelist")(NULL)("device")          = arrSwiperList(2,i)
                oJson("slidelist")(NULL)("mastercode")      = arrSwiperList(3,i)
                oJson("slidelist")(NULL)("detailcode")      = arrSwiperList(4,i)
                oJson("slidelist")(NULL)("titlename")       = arrSwiperList(5,i)
                oJson("slidelist")(NULL)("imageurl")        = arrSwiperList(8,i)
                oJson("slidelist")(NULL)("isvideo")         = arrSwiperList(9,i)
                oJson("slidelist")(NULL)("videohtml")       = arrSwiperList(10,i)
                oJson("slidelist")(NULL)("linkurl")         = arrSwiperList(11,i)
                oJson("slidelist")(NULL)("eventid")         = arrSwiperList(12,i)
                oJson("slidelist")(NULL)("isusing")         = arrSwiperList(13,i)
                oJson("slidelist")(NULL)("sorting")         = arrSwiperList(14,i)
                oJson("slidelist")(NULL)("subtitlename")    = arrSwiperList(19,i)
                oJson("slidelist")(NULL)("titlecolor")      = arrSwiperList(20,i)
                oJson("slidelist")(NULL)("subcopy")         = arrSwiperList(22,i)
                oJson("slidelist")(NULL)("subname")         = arrSwiperList(23,i)
                oJson("slidelist")(NULL)("saleper")         = arrSwiperList(24,i)
                oJson("slidelist")(NULL)("salecper")        = arrSwiperList(25,i)
                oJson("slidelist")(NULL)("issale")          = arrSwiperList(26,i)
                oJson("slidelist")(NULL)("iscoupon")        = arrSwiperList(27,i)

        next
    end if 
END IF
	'Json 출력(JSON)
	oJson.flush
SET oJson = NOTHING
SET oExhibition = NOTHING

ON ERROR GOTO 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->