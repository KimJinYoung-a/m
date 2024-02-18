<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 다이어리 타임세일 티저 처리 페이지
' History : 2020-11-20 원승현
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/timesale/timesaleCls.asp" -->
<%
    dim mode, referer,refip, apgubun, phoneNumber
    mode = requestcheckvar(request("mode"),32)
    referer = request.ServerVariables("HTTP_REFERER")
    refip = request.ServerVariables("REMOTE_ADDR")
    phoneNumber = requestCheckVar(request("phoneNumber"),100)

    dim eCode, userid
    Dim sqlstr, vQuery
    IF application("Svr_Info") = "Dev" THEN
        eCode   =  103268
    Else
        eCode   =  107647
    End If

    userid = GetEncLoginUserID()

    '// 모바일웹&앱전용
    If isApp="1" Then
        apgubun = "A"
    Else
        apgubun = "M"
    End If

    if InStr(referer,"10x10.co.kr")<1 then
        Response.Write "Err|잘못된 접속입니다."
        dbget.close() : Response.End
    end If

    If not( left(now(),10)>="2020-11-23" and left(now(),10)<"2020-11-25" ) Then
        Response.Write "Err|알림 신청기간이 아닙니다."
        dbget.close() : Response.End
    End IF

    If mode="kamsg" Then
        phoneNumber = left(Base64decode(phoneNumber),13)
        if isnull(phoneNumber) or len(phoneNumber) > 13 Then
            Response.Write "Err|전화 번호를 확인 해주세요."
            dbget.close() : Response.End
        end if
        dim fullText, failText, btnJson , requestDate , loopCnt
        dim eventCount , eventTime, episode
        requestDate = formatdate(DateAdd("n",-40,#11/25/2020 10:00:00#),"0000.00.00 00:00:00")
        eventTime = "11월 25일"
        episode = "1"

        '// db_temp.dbo.tbl_event_kakaoAlarm테이블에 실제 진행하는 episode 값을 넣어줌
        IF Not(fnIsSendKakaoAlarm(eCode,phoneNumber,episode)) THEN
            Response.Write "Err|이미 알림톡 서비스를 신청 하셨습니다."
            dbget.close() : Response.End        
        END IF

        fullText = "신청하신 [다이어리 선착순 무료 배포] 이벤트 알림입니다." & vbCrLf & vbCrLf &_
        eventTime &" 오늘부터" & vbCrLf &_
        "이벤트 참여가 가능합니다." & vbCrLf &_
        "서둘러 도전하세요!"
        failText = "[텐바이텐] 다이어리 선착순 무료 배포 이벤트 알림입니다."
        btnJson = "{""button"":[{""name"":""바로가기"",""type"":""WL"",""url_mobile"":""https://tenten.app.link/oegnkzewT4""}]}"

        IF application("Svr_Info") = "Dev" THEN
            Call SendKakaoMsg_LINK(phoneNumber,"1644-6030","A-0022",fullText,"SMS","",failText,btnJson)
        Else
            Call SendKakaoMsg_LINKForMaketing(phoneNumber,requestDate,"1644-6030","A-0022",fullText,"SMS","",failText,btnJson)
        End If

        Response.Write "OK|"
        dbget.close() : Response.End 
    Else
        Response.Write "Err|잘못된 접속입니다."
        dbget.close() : Response.End
    End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->