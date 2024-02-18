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
' Description : 다이어리 타임세일 처리 페이지
' History : 2020-11-23 원승현
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/timesale/timesaleCls.asp" -->
<%
    dim mode, referer,refip, apgubun, phoneNumber, mktTest
    dim currentDate, currentTime, episode
    dim diaryItemIdList, diaryItemId
    mode = requestcheckvar(request("mode"),32)
    referer = request.ServerVariables("HTTP_REFERER")
    refip = request.ServerVariables("REMOTE_ADDR")
    phoneNumber = requestCheckVar(request("phoneNumber"),100)
    diaryItemIdList = "3424997,3424998,3418284,3424999,3425011,3418290,3425012,3425021,3425022"


    dim eCode, userid
    Dim sqlstr, vQuery
    mktTest = false

    IF application("Svr_Info") = "Dev" THEN
        eCode = "103269"
        mktTest = true
    ElseIf application("Svr_Info")="staging" Then
        eCode = "107649"
        mktTest = true    
    Else
        eCode = "107649"
        mktTest = false
    End If

    userid = GetEncLoginUserID()

    '// 모바일웹&앱전용
    If isApp="1" Then
        apgubun = "A"
    Else
        apgubun = "M"
    End If

    if mktTest then
        '// 테스트용
        'currentDate = CDate("2020-11-27 19:00:00")
        'currentTime = Cdate("19:00:00")
        '// 테스트 끝나면 사고 방지 차원에서 서버 시간으로 변경
        currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
        currentTime = time()        
    else
        currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
        currentTime = time()    
    end if

    '// 각 일자별 타임세일 진행여부를 episode로 정함
    If currentDate >= #11/25/2020 10:00:00# and currentDate < #11/25/2020 15:00:00# Then
        '// 2020년 11월 25일 10시~15시 진행
        episode=1
        IF application("Svr_Info") = "Dev" THEN
            diaryItemId = "3369941"
        Else
            diaryItemId = "3424997"
        End If
    elseIf currentDate >= #11/25/2020 15:00:00# and currentDate < #11/25/2020 18:00:00# Then
        '// 2020년 11월 25일 15시~18시 진행
        episode=2
        IF application("Svr_Info") = "Dev" THEN
            diaryItemId = "3369942"
        Else        
            diaryItemId = "3424998"        
        End If
    elseIf currentDate >= #11/25/2020 18:00:00# and currentDate < #11/25/2020 23:59:59# Then
        '// 2020년 11월 25일 18시~23시59분59초 진행
        episode=3
        IF application("Svr_Info") = "Dev" THEN
            diaryItemId = "3369943"
        Else        
            diaryItemId = "3418284"        
        End If
    elseIf currentDate >= #11/26/2020 10:00:00# and currentDate < #11/26/2020 15:00:00# Then
        '// 2020년 11월 26일 10시~15시 진행
        episode=4
        IF application("Svr_Info") = "Dev" THEN
            diaryItemId = "3369944"
        Else        
            diaryItemId = "3424999"        
        End If
    elseIf currentDate >= #11/26/2020 15:00:00# and currentDate < #11/26/2020 18:00:00# Then
        '// 2020년 11월 26일 15시~18시 진행
        episode=5
        IF application("Svr_Info") = "Dev" THEN
            diaryItemId = "3369945"
        Else        
            diaryItemId = "3425011"        
        End If
    elseIf currentDate >= #11/26/2020 18:00:00# and currentDate < #11/26/2020 23:59:59# Then
        '// 2020년 11월 26일 18시~23시59분59초 진행
        episode=6
        IF application("Svr_Info") = "Dev" THEN
            diaryItemId = "3369947"
        Else        
            diaryItemId = "3418290"        
        End If
    elseIf currentDate >= #11/27/2020 10:00:00# and currentDate < #11/27/2020 15:00:00# Then
        '// 2020년 11월 27일 10시~15시 진행
        episode=7
        IF application("Svr_Info") = "Dev" THEN
            diaryItemId = "3369948"
        Else        
            diaryItemId = "3425012"        
        End If
    elseIf currentDate >= #11/27/2020 15:00:00# and currentDate < #11/27/2020 18:00:00# Then
        '// 2020년 11월 27일 15시~18시 진행
        episode=8
        IF application("Svr_Info") = "Dev" THEN
            diaryItemId = "3369949"
        Else        
            diaryItemId = "3425021"        
        End If
    elseIf currentDate >= #11/27/2020 18:00:00# and currentDate < #11/27/2020 23:59:59# Then
        '// 2020년 11월 27일 18시~23시59분59초 진행
        episode=9
        IF application("Svr_Info") = "Dev" THEN
            diaryItemId = "3369950"
        Else        
            diaryItemId = "3425022"        
        End If
    else
        '// 그 외에는 episode 0으로 인식
        episode=0
        diaryItemId = ""
    end if

    if InStr(referer,"10x10.co.kr")<1 then
        Response.Write "Err|잘못된 접속입니다."
        dbget.close() : Response.End
    end If

    If mode="kamsg" Then
        If not(left(currentDate,10)>="2020-11-25" and left(currentDate,10)<"2020-11-27" ) Then
            Response.Write "Err|알림 신청기간이 아닙니다."
            dbget.close() : Response.End
        End IF

        phoneNumber = left(Base64decode(phoneNumber),13)
        if isnull(phoneNumber) or len(phoneNumber) > 13 Then
            Response.Write "Err|전화 번호를 확인 해주세요."
            dbget.close() : Response.End
        end if
        dim fullText, failText, btnJson , requestDate , loopCnt
        dim eventCount , eventTime, episodeGroup
        
        If currentDate >= #11/25/2020 00:00:00# and currentDate < #11/26/2020 00:00:00# Then
            requestDate = formatdate(DateAdd("n",-40,#11/26/2020 10:00:00#),"0000.00.00 00:00:00")
            eventTime = "11월 26일"
            episodeGroup = "1" '// 발송 중복 체크를 위한 에피소드 그룹 값
        ElseIf currentDate >= #11/26/2020 00:00:00# and currentDate < #11/27/2020 00:00:00# Then
            requestDate = formatdate(DateAdd("n",-40,#11/27/2020 10:00:00#),"0000.00.00 00:00:00")
            eventTime = "11월 27일"
            episodeGroup = "2"
        Else
            Response.Write "Err|알림톡 서비스 신청 기간이 아닙니다."
            dbget.close() : Response.End
        End If

        '// db_temp.dbo.tbl_event_kakaoAlarm테이블에 실제 진행하는 episode 값을 넣어줌
        IF Not(fnIsSendKakaoAlarm(eCode,phoneNumber,episodeGroup)) THEN
            Response.Write "Err|이미 알림톡 서비스를 신청 하셨습니다."
            dbget.close() : Response.End        
        END IF

        fullText = "신청하신 [다이어리 선착순 무료 배포] 이벤트 알림입니다." & vbCrLf & vbCrLf &_
        "오늘부터 이벤트 참여가 가능합니다." & vbCrLf &_
        "서둘러 도전하세요!"
        failText = "[텐바이텐] 다이어리 선착순 무료 배포 이벤트 알림입니다."
        btnJson = "{""button"":[{""name"":""자세히 보러 가기"",""type"":""WL"",""url_mobile"":""https://tenten.app.link/oegnkzewT4""}]}"

        IF application("Svr_Info") = "Dev" THEN
            Call SendKakaoMsg_LINK(phoneNumber,"1644-6030","A-0022",fullText,"SMS","",failText,btnJson)
        Else
            Call SendKakaoMsg_LINKForMaketing(phoneNumber,requestDate,"1644-6030","A-0022",fullText,"SMS","",failText,btnJson)
        End If

        Response.Write "OK|"
        dbget.close() : Response.End
    ElseIf mode="order" Then

        '// 응모 시간대가 아니면 튕겨낸다.
        If episode=0 Then
            Response.Write "Err|응모 가능한 상태가 아닙니다."
            Response.End
        End If

        '// 현재 해당 시간대의 다이어리 상품의 재고가 있는지 확인한다.
		If getitemlimitcnt(diaryItemId) < 1 Then 
            Response.Write "Err|준비된 수량이 소진되었습니다."
            Response.End
        End If

        '// 해당 사용자가 다이어리 타임세일 상품을 구매 했는지 확인한다.
        vQuery = vQuery & " select count(*) as cnt"
        vQuery = vQuery & " from db_order.dbo.tbl_order_master m"
        vQuery = vQuery & " join db_order.dbo.tbl_order_detail d"
        vQuery = vQuery & " 	on m.orderserial=d.orderserial"
        vQuery = vQuery & " where "
        vQuery = vQuery & " m.jumundiv<>9"
        vQuery = vQuery & " and m.ipkumdiv>1"
		vQuery = vQuery & " and m.userid='"& userid &"'"
		vQuery = vQuery & " and m.cancelyn<>'Y'"
        vQuery = vQuery & " and d.itemid in ("& diaryItemIdList &")"
        rsget.CursorLocation = adUseClient
        rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
        If rsget(0) > 0 Then
            Response.Write "Err|이미 무료 다이어리를 1개 결제하셨습니다.>?nID당 1회만 구매 가능합니다."
            response.End
        End If        
        rsget.close

        '// 이벤트 응모내역을 남긴다.
        vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', '"&mode&"', '"&diaryItemId&"', '"&apgubun&"')"
        dbget.Execute vQuery

        Response.Write "OK|"&diaryItemId
        Response.End  

    Else
        Response.Write "Err|잘못된 접속입니다."
        dbget.close() : Response.End
    End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


