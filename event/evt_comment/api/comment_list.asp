<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/inc_const.asp"-->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<%
'###############################################
' Discription : 이벤트 댓글 json
' History : 2019-05-31
'###############################################

Response.ContentType = "application/json"
dim oJson, eventCode, cEvent, evtCmtDataType, currentPage, pageSize, totalpage, scrollpage, isMyComments, scrollCount
on Error Resume Next

'object 초기화
Set oJson = jsObject()
Set oJson("pagingData") = jsObject()

'evtCmtDataType 1:이벤트정보, 2:코멘트리스트, 3:정보, 리스트
    evtCmtDataType = request("evtCmtDataType")
    currentPage = request("currentPage")    
    eventCode = request("eventCode")
    pageSize = request("pageSize")
    scrollCount = request("scrollCount")

if scrollCount = "" then scrollCount = 4

if evtCmtDataType = 1 or evtCmtDataType = 3 then
    '=======================================
    '이벤트 데이터
    set cEvent = new ClsEvtCont
        cEvent.FECode = eventCode

        cEvent.fnGetEvent

    '이벤트명, 코멘트 텍스트박스 내용, 이벤트 기간, 당첨자 발표
    dim evtName, evtCommentCopy, evtStartDate, evtEndDate, winnerPresentDate, giftImg, isCommentEvent, isCommentEnd
    
    evtCommentCopy = cEvent.Fcomm_text
    evtStartDate = cEvent.Fcomm_start
    evtEndDate = cEvent.Fcomm_end
    winnerPresentDate = cEvent.FEPDate
    giftImg = cEvent.Ffreebie_img
    isCommentEvent = cEvent.Fcomm_isusing
    isCommentEnd = false

    oJson("evtCommentCopy") = nl2br(evtCommentCopy)
    if evtStartDate <> "" then 
        oJson("evtStartDate") = FormatDate(evtStartDate, "0000.00.00")
    else
        oJson("evtStartDate") = ""
    end if 

    if evtEndDate <> "" then 
        oJson("evtEndDate") = FormatDate(evtEndDate, "00.00")
    else
        oJson("evtEndDate") = ""
    end if 

    if winnerPresentDate <> "" then 
        oJson("winnerPresentDate") = FormatDate(winnerPresentDate, "0000.00.00")   
    else
        oJson("winnerPresentDate") = ""
    end if 
    oJson("giftImg") = giftImg
    oJson("isCommentEvent") = isCommentEvent        

    if isCommentEvent = "Y" then
        if not (date() <= Cdate(evtEndDate)) then
            isCommentEnd = true
        end if    
    end if
    oJson("isCommentEnd") = isCommentEnd

    '로그인 확인
    oJson("isLogin") = IsUserLoginOK
end if
if evtCmtDataType = 2 or evtCmtDataType = 3 then
    '=========================================
    '코멘트 데이터 
        dim cEComment, iCTotCnt, arrCList, intCLoop

        set cEComment = new ClsEvtComment

        cEComment.FECode        = eventCode   '관련코드 = 온라인 코드  
        
        'cEComment.FEBidx        = bidx
        cEComment.FCPage        = currentPage '현재페이지
        cEComment.FPSize        = pageSize '페이지 사이즈
        cEComment.FTotCnt       = -1  '전체 레코드 수
        arrCList = cEComment.fnGetComment
        iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
        set cEComment = nothing
    '=======================================    
    set oJson("comments") = jsArray()        

    dim tmpContent, tmpContentId, tmpRegDate, tmpUserId, tmpContentNum, tmpChannel
    oJson("totalCommentCount") = iCTotCnt    

       dim arrUserid, bdgUid, bdgBno
       '사용자 아이디 모음 생성(for Badge)
       IF isArray(arrCList) THEN
        for intCLoop = 0 to UBound(arrCList,2)
            arrUserid = arrUserid & chkIIF(arrUserid<>"",",","") & "''" & trim(arrCList(2,intCLoop)) & "''"
        next
       end if

       '뱃지 목록 접수(순서 랜덤)
       Call getUserBadgeList(arrUserid,bdgUid,bdgBno,"Y")               
           
    IF isArray(arrCList) THEN
        For intCLoop = 0 To UBound(arrCList,2)
            tmpContent = striphtml(db2html(arrCList(1,intCLoop)))
            tmpContentId = arrCList(0,intCLoop)
            tmpRegDate = FormatDate(arrCList(4,intCLoop),"0000.00.00")
            tmpUserId = printUserId(arrCList(2,intCLoop),2,"*")
            tmpContentNum = iCTotCnt-intCLoop-(Int(iCTotCnt/3)*(1-1))
            tmpChannel = arrCList(8,intCLoop)

            set oJson("comments")(null) = jsObject()

'=======================뱃지==================================
            set oJson("comments")(null)("userBadgeArr") = jsArray()
            Dim strRst, tmpBdg, i, arrBdgNm, tmpImg, tmpTitle
            arrBdgNm = split("슈퍼 코멘터||기프트 초이스||위시 메이커||포토 코멘터||브랜드 쿨!||얼리버드||세일헌터||스타일리스트||컬러홀릭||텐텐 트윅스||카테고리 마스터||톡! 엔젤||10월 스페셜||11월 스페셜||12월 스페셜","||")


            if chkArrValue(bdgUid, arrCList(2,intCLoop)) then
                tmpBdg = chkArrSelVal(bdgUid, bdgBno, arrCList(2,intCLoop))
                tmpBdg = split(tmpBdg,"||")		
                for i=0 to ubound(tmpBdg)
                    tmpImg = "http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge" & Num2Str(tmpBdg(i),2,"0","R") & ".png"
                    tmpTitle = arrBdgNm(tmpBdg(i)-1)			
                    oJson("comments")(null)("userBadgeArr")(null) = tmpImg                    
                    if i>=(3-1) then Exit For
                next
            end if
'=======================뱃지==================================

            oJson("comments")(null)("content") = tmpContent
            oJson("comments")(null)("contentId") = tmpContentId
            oJson("comments")(null)("regDate") = tmpRegDate
            oJson("comments")(null)("userId") = tmpUserId
            oJson("comments")(null)("tmpContentNum") = tmpContentNum
            oJson("comments")(null)("tmpChannel") = tmpChannel                                            

            'response.write "내용 : " & tmpContent & ", id : " & tmpContentId & ", regdate : " & tmpRegDate & ", userid : " & tmpUserId & "<br>"        
            if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then
                oJson("comments")(null)("isMyContent") = true
            else    
                oJson("comments")(null)("isMyContent") = false
            end if

            totalpage = iCTotCnt \ pageSize
            if (totalpage<>iCTotCnt/pageSize) then totalpage = totalpage +1
            scrollpage = ((currentPage-1)\scrollCount)*scrollCount +1

            oJson("pagingData")("totalcount")       = iCTotCnt
            oJson("pagingData")("currpage")         = currentPage
            oJson("pagingData")("totalpage")        = totalpage
            oJson("pagingData")("scrollpage")       = scrollpage
            oJson("pagingData")("scrollcount")      = scrollCount       
        next
    end if       
end if

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing

if ERR then Call OnErrNoti()
On Error Goto 0
%>
