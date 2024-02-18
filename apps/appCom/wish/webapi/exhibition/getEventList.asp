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
DIM masterCode , pageSize , listType , i
DIM oExhibition , eventList
'// json객체 선언
DIM oJson
DIM eventName

masterCode =  requestCheckvar(request("mastercode"),10)
pageSize = NullFillWith(requestCheckVar(request("pagesize"),5),"10")
listType = NullFillWith(requestCheckVar(request("listType"),1),"A")

ON ERROR RESUME NEXT

SET oJson = jsObject()
SET oJson("eventlist") = jsArray()

SET oExhibition = new ExhibitionCls
eventList = oExhibition.getEventListProc( listType , pageSize , masterCode, 0 )     '리스트타입, row개수, 마스터코드, 디테일코드		

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
ELSE
    '// event 
    if isArray(eventList) then 
        for i = 0 to Ubound(eventList) - 1

            If eventList(i).Fissale Or eventList(i).Fiscoupon Then
                if ubound(Split(eventList(i).Fevt_name,"|"))> 0 Then
                    If eventList(i).Fissale Or (eventList(i).Fissale And eventList(i).Fiscoupon) then
                        eventName	= cStr(Split(eventList(i).Fevt_name,"|")(0))
                    ElseIf arrList(13,intLoop) Then
                        eventName	= cStr(Split(eventList(i).Fevt_name,"|")(0))
                    End If
                Else
                    eventName = eventList(i).Fevt_name
                end If
            Else
                eventName = eventList(i).Fevt_name
            End If

            SET oJson("eventlist")(NULL) = jsObject()
                oJson("eventlist")(NULL)("idx")             = eventList(i).Fidx
                oJson("eventlist")(NULL)("eventid")         = eventList(i).Fevt_code
                oJson("eventlist")(NULL)("eventname")       = eventName
                oJson("eventlist")(NULL)("subcopy")         = eventList(i).Fevt_subcopy
                oJson("eventlist")(NULL)("squareimage")     = eventList(i).Fsquareimage
                oJson("eventlist")(NULL)("rectangleimage")  = eventList(i).Frectangleimage
                oJson("eventlist")(NULL)("saleper")         = eventList(i).Fsaleper
                oJson("eventlist")(NULL)("salecper")        = eventList(i).Fsalecper
                oJson("eventlist")(NULL)("startdate")       = eventList(i).Fstartdate
                oJson("eventlist")(NULL)("enddate")         = eventList(i).Fenddate
                oJson("eventlist")(NULL)("evt_startdate")   = eventList(i).Fevt_startdate
                oJson("eventlist")(NULL)("evt_enddate")     = eventList(i).Fevt_enddate
                oJson("eventlist")(NULL)("evtsorting")      = eventList(i).Fevtsorting
                oJson("eventlist")(NULL)("isusing")         = eventList(i).Fisusing
                oJson("eventlist")(NULL)("isgift")          = eventList(i).Fisgift
                oJson("eventlist")(NULL)("issale")          = eventList(i).Fissale
                oJson("eventlist")(NULL)("isoneplusone")    = eventList(i).Fisoneplusone
                oJson("eventlist")(NULL)("iscoupon")        = eventList(i).Fiscoupon
            if listtype = "B" then
                oJson("eventlist")(NULL)("etc_itemid")  = eventList(i).Fetc_itemid
                oJson("eventlist")(NULL)("itemname")    = eventList(i).Fitemname
            end if
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