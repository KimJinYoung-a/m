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
' Discription : 이벤트 댓글 가져오기
' History : 2019-05-31
'###############################################

Response.ContentType = "application/json"
dim oJson, eventCode, cEvent, currentPage, pageSize, totalpage, scrollpage, isMyComments, likeId, filterTxt
dim scrollCount

on Error Resume Next

'object 초기화
Set oJson = jsObject()

currentPage = request("currentPage")
eventCode = request("eventCode")
isMyComments = request("isMyComments")
likeId = request("likeId")
filterTxt = request("filterTxt")
pageSize = 5
scrollCount = 5
'=========================================
'코멘트 데이터
    dim cEComment, iCTotCnt, arrCList, intCLoop, arrMyList

    set cEComment = new ClsEvtUtilComment

    cEComment.FECode        = eventCode   '관련코드 = 온라인 코드

    cEComment.FCPage        = currentPage '현재페이지
    cEComment.FPSize        = pageSize '페이지 사이즈
    cEComment.FTotCnt       = -1  '전체 레코드 수
    cEComment.FLikeId       = likeId  'like아이디
    cEComment.FIsMyComment = isMyComments  'like아이디
    cEComment.FUserID       = GetLoginUserID
    cEComment.FcommtxtOption       = filterTxt

    arrCList = cEComment.fnGetComment
    iCTotCnt = cEComment.FTotCnt '리스트 총 갯수

'================일회성 데이터=======================
if eventCode = "99723" then
    dim top3
    top3 = cEComment.getTop3Comments
    set oJson("top3") = jsArray()
    if isArray(top3) then
        For intCLoop = 0 To UBound(top3,2)
            set oJson("top3")(null) = jsObject()
            oJson("top3")(null)("optionIdx") = top3(0,intCLoop)
            oJson("top3")(null)("count") = top3(1,intCLoop)
        next
    end if
end if
'=======================================

    set cEComment = nothing
'=======================================
set oJson("comments") = jsArray()
set oJson("myComments") = jsArray()
Set oJson("pagingData") = jsObject()
oJson("isLogin") = IsUserLoginOK
oJson("likeId") = likeId
oJson("userId") = GetLoginUserID
oJson("loginUserName") = GetLoginUserName

dim tmpContent, tmpContent2, tmpContent3, option1, option2, option3, tmpContentId, tmpRegDate, tmpUserId, tmpContentNum, tmpChannel, likeCnt, myLikeCnt, isLogin, userName

'response.write iCTotCnt
'response.end

IF isArray(arrCList) THEN
    For intCLoop = 0 To UBound(arrCList,2)
        tmpContent = striphtml(db2html(arrCList(1,intCLoop)))
        tmpContent2 = striphtml(db2html(arrCList(6,intCLoop)))
        tmpContent3 = striphtml(db2html(arrCList(7,intCLoop)))
        option1 = arrCList(8,intCLoop)
        option2 = arrCList(9,intCLoop)
        option3 = arrCList(10,intCLoop)
        tmpContentId = arrCList(0,intCLoop)
        tmpRegDate = FormatDate(arrCList(3,intCLoop),"0000.00.00")
        tmpUserId = arrCList(2,intCLoop)
        tmpContentNum = iCTotCnt - ((currentPage - 1) * pageSize + intCLoop)
        tmpChannel = arrCList(5,intCLoop)
        likeCnt = arrCList(11,intCLoop)
        myLikeCnt = arrCList(12,intCLoop)
        userName = arrCList(13,intCLoop)

        set oJson("comments")(null) = jsObject()

        oJson("comments")(null)("content") = tmpContent
        oJson("comments")(null)("content2") = tmpContent2
        oJson("comments")(null)("content3") = tmpContent3
        oJson("comments")(null)("option1") = option1
        oJson("comments")(null)("option2") = option2
        oJson("comments")(null)("option3") = option3
        oJson("comments")(null)("contentId") = tmpContentId
        oJson("comments")(null)("regDate") = tmpRegDate        
        oJson("comments")(null)("contentnum") = tmpContentNum
        oJson("comments")(null)("device") = tmpChannel
        oJson("comments")(null)("likeCnt") = likeCnt
        oJson("comments")(null)("myLikeCnt") = myLikeCnt        
        'response.write "내용 : " & tmpContent & ", id : " & tmpContentId & ", regdate : " & tmpRegDate & ", userid : " & tmpUserId & "<br>"
        if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then
            oJson("comments")(null)("isMyContent") = true            
        else
            oJson("comments")(null)("isMyContent") = false
            userName = printUserId(userName, 1,"*") 
            tmpUserId = printUserId(tmpUserId, 2, "*")
        end if        
        oJson("comments")(null)("userId") = tmpUserId
        oJson("comments")(null)("userName") = userName
    next
    '페이징관련

    totalpage = iCTotCnt \ pageSize
    if (totalpage<>iCTotCnt/pageSize) then totalpage = totalpage +1
    scrollpage = ((currentPage-1)\scrollCount)*scrollCount +1

    oJson("pagingData")("totalcount")       = iCTotCnt
    oJson("pagingData")("currpage")         = int(currentPage)
    oJson("pagingData")("totalpage")        = totalpage
    oJson("pagingData")("scrollpage")       = scrollpage
    oJson("pagingData")("scrollcount")      = int(scrollCount)
    oJson("pagingData")("pageSize")         = int(pageSize)
end if
'Json 출력(JSON)
oJson.flush
Set oJson = Nothing

if ERR then Call OnErrNoti()
On Error Goto 0
%>
