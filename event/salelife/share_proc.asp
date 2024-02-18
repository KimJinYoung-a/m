<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 2019 4월 정기세일 - 릴레이 공유 이벤트
' History : 2019-03-26 이종화
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim imageNumber , userID , SNSUrl
dim eventIdx , mode
dim device , vQuery , vIdx , eCode , referer

device  = chkiif(isapp,"A","M")
eCode   = chkiif(application("Svr_Info") = "Dev","90250","93475")
mode    = requestcheckvar(request("mode"),8)
userID  = getEncLoginUserID()
SNSUrl  = requestcheckvar(request("snsurl"),250)
eventIdx    = requestcheckvar(request("eventidx"),10)
imageNumber = requestcheckvar(request("imagenumber"),1)
referer 	= request.ServerVariables("HTTP_REFERER") '// 레퍼러

if imageNumber = "" then imageNumber = 1

if InStr(referer,"10x10.co.kr")<1 Then
    Response.Write "Err|잘못된 접속입니다.referer"
    dbget.close() : Response.End
end If

If mode = "" Then
    Response.Write "Err|잘못된 접속입니다.mode"
    dbget.close() : Response.End
End IF

if Not(IsUserLoginOK) then 
    Response.Write "Err|로그인후 이용가능합니다."
    dbget.close() : Response.End
end if 

If not(date() >= "2019-04-01" and date() < "2019-04-21") Then
    Response.Write "Err|이벤트 응모기간이 아닙니다."
    dbget.close() : Response.End
End IF

'// mode imgdown , inputurl
select case mode
    case "imgdown"
        if userEventCheck(userID,mode) then 
            call addEvent(userID,imageNumber,device)
        else
            call changeEventImage(userID,imageNumber,device)
        end if 
    case "inputurl"
        if userEventCheck(userID,mode) then
            call updateEvent(eventIdx,SNSUrl)
        else
            call outAct()
        end if 
    case else
        response.write "Err|잘못된 접근입니다."
        dbget.close() : Response.End
end select

'// 참여안하고 url 입력 할경우
function outAct()
    response.write "Err|이미지를 다운 받은후 URL을 입력 해주세요."
    dbget.close() : Response.End
end function

'// 참여 유무
function userEventCheck(userID , mode)
    dim sqlStr , subidx , imageno , urlcheck
    '// sub_idx == idx , sub_opt2 == imagenumber ,  sub_opt3 == snsurl
    sqlStr = " SELECT TOP 1 sub_idx , sub_opt2 , sub_opt3 FROM [db_event].[dbo].[tbl_event_subscript] WHERE userID = '"& userID &"' and evt_code = '"& eCode &"' ORDER BY sub_idx DESC "
    rsget.Open sqlStr, dbget, 1
	If Not(rsget.bof Or rsget.Eof) Then
		subidx = rsget("sub_idx")
        imageno = rsget("sub_opt2")
        urlcheck = rsget("sub_opt3")
	Else
		subidx = ""
        imageno = ""
        urlcheck = ""
	End IF
	rsget.close

    select case mode
        case "imgdown"
            userEventCheck = chkiif(subidx = "",true,false)
        case "inputurl"
            userEventCheck = chkiif(subidx <> "" and (urlcheck = "" or isnull(urlcheck)),true,false)
        case else
            userEventCheck = false
    end select
end function

'// 이미지 변경 여부
function changeEventImage(userid,imageNumber,device)
    dim isqlStr , surl , simg
    isqlStr = " SELECT TOP 1 sub_opt2 , sub_opt3 FROM [db_event].[dbo].[tbl_event_subscript] WHERE userID = '"& userID &"' and evt_code = '"& eCode &"' ORDER BY sub_idx DESC "
    rsget.Open isqlStr, dbget, 1
    If Not(rsget.bof Or rsget.Eof) Then
        simg = rsget("sub_opt2")
        surl = rsget("sub_opt3")
    Else
        simg = ""
        surl = ""
    End if
    rsget.close

    if simg <> "" and (surl = "" or isnull(surl)) then '// update
        call updateImage(userID,imageNumber,device)
    elseif simg <> "" and surl <> ""  then  '// re-insert
        call addEvent(userID,imageNumber,device)
    else
        response.write "OK|중복이미지.|0000"
    end if 
end function

'// 이미지 업데이트
function updateImage(uid,imgnum,div)
    dim udtImgSql 

    if uid = "" then 
        response.write "Err|로그인이 필요 합니다."
        response.end
        exit function
    end if

    if imgnum = "" then
        response.write "Err|이미지를 선택 해주세요"
        response.end
        exit function
    end if 

    udtImgSql = "UPDATE db_event.dbo.tbl_event_subscript SET sub_opt2 = '"& imgnum &"' WHERE "
    udtImgSql = udtImgSql & "sub_idx in (SELECT TOP 1 sub_idx FROM db_event.dbo.tbl_event_subscript WHERE userID = '"& uid &"' and evt_code = '"& eCode &"' ORDER BY sub_idx DESC)"
    dbget.execute udtImgSql

    vQuery = " SELECT TOP 1 sub_idx FROM db_event.dbo.tbl_event_subscript WHERE userID = '"& uid &"' and evt_code = '"& eCode &"' ORDER BY sub_idx DESC"
    rsget.Open vQuery,dbget , 1
    IF Not rsget.EOF THEN
        vIdx = rsget(0)
    END IF
    rsget.close

    response.write "OK|이미지를 다운받아 공유 후 SNS URL을 입력 해주세요.|"& vIdx &""
end function

'// 입력
function addEvent(uid,imgnum,div)
    dim addSql

    if uid = "" then 
        response.write "Err|로그인이 필요 합니다."
        response.end
        exit function
    end if

    if imgnum = "" then
        response.write "Err|이미지를 선택 해주세요"
        response.end
        exit function
    end if 

    addSql = "INSERT INTO db_event.dbo.tbl_event_subscript (evt_code , userID , sub_opt2 , device) values ('"& eCode &"' , '"& uid &"' , '"& imgnum &"' , '"& div &"')"
    dbget.execute addSql

    vQuery = " SELECT TOP 1 sub_idx FROM db_event.dbo.tbl_event_subscript WHERE userID = '"& uid &"' and evt_code = '"& eCode &"' ORDER BY sub_idx DESC"
    rsget.Open vQuery,dbget
    IF Not rsget.EOF THEN
        vIdx = rsget(0)
    END IF
    rsget.close

    response.write "OK|이미지를 다운받아 공유 후 SNS URL을 입력 해주세요.|"& vIdx &""
end function

'// url 입력
function updateEvent(subidx,url)
    dim udtSql

    if subidx = "" then 
        response.write "Err|잘못된 접근입니다."
        response.end
        exit function
    end if 

    if url = "" then 
        response.write "Err|SNS URL을 입력 해주세요."
        response.end
        exit function
    end if 

    udtSql = "UPDATE db_event.dbo.tbl_event_subscript SET sub_opt3 = '"& trim(url) &"' WHERE sub_idx = "& subidx &""
    dbget.execute udtSql

    response.write "OK|응모가 완료 되었습니다.>?n당첨자 발표는 22일 오후 6시 해당 이벤트 페이지에서 진행합니다."
end function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->