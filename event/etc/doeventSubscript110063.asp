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
' Description : 2021 정기세일 타임세일
' History : 2021-03-24 정태훈 생성
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
    dim mode, referer,refip, apgubun, phoneNumber, mktTest
    dim currentDate, currentTime, episode
    dim timesaleItemIdList, timesaleitemid
    mode = requestcheckvar(request("mode"),32)
    referer = request.ServerVariables("HTTP_REFERER")
    refip = request.ServerVariables("REMOTE_ADDR")
    phoneNumber = requestCheckVar(request("phoneNumber"),100)

    mktTest = False

    dim eCode, userid
    Dim sqlstr, vQuery
    IF application("Svr_Info") = "Dev" THEN
        eCode   =  "104333"
        mktTest = True
    ElseIf application("Svr_Info")="staging" Then
        eCode   =  "110063"
        mktTest = True
    Else
        eCode   =  "110063"
        mktTest = False
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
        if request("testdate")<>"" then
            currentDate = CDate(request("testdate"))
        else
            currentDate = CDate("2021-03-29 15:00:00")
        end if
        currentTime = Cdate(Format00(2,hour(currentDate))&":"&Format00(2,minute(currentDate))&":"&Format00(2,second(currentDate)))
    else
        currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
        currentTime = Cdate(Format00(2,hour(currentDate))&":"&Format00(2,minute(currentDate))&":"&Format00(2,second(currentDate)))
    end if

    '// 각 일자별 타임세일 진행여부를 episode로 정함
    If currentDate >= #2021-03-29 00:00:00# and currentDate < #2021-03-30 00:00:00# Then
        timesaleItemIdList = "3713161,3715297,3708341,3690021,3714968,3715334,3713169,3715328,3715002,3701844"
        If currentTime >= #09:00:00# and currentTime < #10:00:00# Then
            episode=1
            timesaleitemid = "3713161"
        elseIf currentTime >= #10:00:00# and currentTime < #11:00:00# Then
            episode=2
            timesaleitemid = "3715297"
        elseIf currentTime >= #11:00:00# and currentTime < #12:00:00# Then
            episode=3
            timesaleitemid = "3708341"
        elseIf currentTime >= #12:00:00# and currentTime < #13:00:00# Then
            episode=4
            timesaleitemid = "3690021"
        elseIf currentTime >= #13:00:00# and currentTime < #14:00:00# Then
            episode=5
            timesaleitemid = "3714968"
        elseIf currentTime >= #14:00:00# and currentTime < #15:00:00# Then
            episode=6
            timesaleitemid = "3715334"
        elseIf currentTime >= #15:00:00# and currentTime < #16:00:00# Then
            episode=7
            timesaleitemid = "3713169"
        elseIf currentTime >= #16:00:00# and currentTime < #17:00:00# Then
            episode=8
            timesaleitemid = "3715328"
        elseIf currentTime >= #17:00:00# and currentTime < #18:00:00# Then
            episode=9
            timesaleitemid = "3715002"
        elseIf currentTime >= #18:00:00# Then
            episode=10
            timesaleitemid = "3701844"
        else
            episode=0
            timesaleitemid = ""
        end if
    elseIf currentDate >= #2021-03-31 00:00:00# and currentDate < #2021-04-01 00:00:00# Then
        timesaleItemIdList = "3713643,3731023,3708348,3715298,3714963,3715197,3709143,3713170,3715332,3717425"
        If currentTime >= #09:00:00# and currentTime < #10:00:00# Then
            episode=1
            timesaleitemid = "3713643"
        elseIf currentTime >= #10:00:00# and currentTime < #11:00:00# Then
            episode=2
            timesaleitemid = "3731023"
        elseIf currentTime >= #11:00:00# and currentTime < #12:00:00# Then
            episode=3
            timesaleitemid = "3708348"
        elseIf currentTime >= #12:00:00# and currentTime < #13:00:00# Then
            episode=4
            timesaleitemid = "3715298"
        elseIf currentTime >= #13:00:00# and currentTime < #14:00:00# Then
            episode=5
            timesaleitemid = "3714963"
        elseIf currentTime >= #14:00:00# and currentTime < #15:00:00# Then
            episode=6
            timesaleitemid = "3715197"
        elseIf currentTime >= #15:00:00# and currentTime < #16:00:00# Then
            episode=7
            timesaleitemid = "3709143"
        elseIf currentTime >= #16:00:00# and currentTime < #17:00:00# Then
            episode=8
            timesaleitemid = "3713170"
        elseIf currentTime >= #17:00:00# and currentTime < #18:00:00# Then
            episode=9
            timesaleitemid = "3715332"
        elseIf currentTime >= #18:00:00# Then
            episode=10
            timesaleitemid = "3717425"
        else
            episode=0
            timesaleitemid = ""
        end if
    elseIf currentDate >= #2021-04-05 00:00:00# and currentDate < #2021-04-06 00:00:00# Then
        timesaleItemIdList = "3718849,3686950,3709144,3721795,3725107,3721797,3718165,3722309,3730632,3725215"
        If currentTime >= #09:00:00# and currentTime < #10:00:00# Then
            episode=1
            timesaleitemid = "3718849"
        elseIf currentTime >= #10:00:00# and currentTime < #11:00:00# Then
            episode=2
            timesaleitemid = "3686950"
        elseIf currentTime >= #11:00:00# and currentTime < #12:00:00# Then
            episode=3
            timesaleitemid = "3709144"
        elseIf currentTime >= #12:00:00# and currentTime < #13:00:00# Then
            episode=4
            timesaleitemid = "3721795"
        elseIf currentTime >= #13:00:00# and currentTime < #14:00:00# Then
            episode=5
            timesaleitemid = "3725107"
        elseIf currentTime >= #14:00:00# and currentTime < #15:00:00# Then
            episode=6
            timesaleitemid = "3721797"
        elseIf currentTime >= #15:00:00# and currentTime < #16:00:00# Then
            episode=7
            timesaleitemid = "3718165"
        elseIf currentTime >= #16:00:00# and currentTime < #17:00:00# Then
            episode=8
            timesaleitemid = "3722309"
        elseIf currentTime >= #17:00:00# and currentTime < #18:00:00# Then
            episode=9
            timesaleitemid = "3730632"
        elseIf currentTime >= #18:00:00# Then
            episode=10
            timesaleitemid = "3725215"
        else
            episode=0
            timesaleitemid = ""
        end if
    elseIf currentDate >= #2021-04-07 00:00:00# and currentDate < #2021-04-08 00:00:00# Then
        timesaleItemIdList = "3741794,3717297,3731986,3741793,3731934,3738663,3742256,3738635,3742255,3738453"
        If currentTime >= #09:00:00# and currentTime < #10:00:00# Then
            episode=1
            timesaleitemid = "3741794"
        elseIf currentTime >= #10:00:00# and currentTime < #11:00:00# Then
            episode=2
            timesaleitemid = "3717297"
        elseIf currentTime >= #11:00:00# and currentTime < #12:00:00# Then
            episode=3
            timesaleitemid = "3731986"
        elseIf currentTime >= #12:00:00# and currentTime < #13:00:00# Then
            episode=4
            timesaleitemid = "3741793"
        elseIf currentTime >= #13:00:00# and currentTime < #14:00:00# Then
            episode=5
            timesaleitemid = "3731934"
        elseIf currentTime >= #14:00:00# and currentTime < #15:00:00# Then
            episode=6
            timesaleitemid = "3738663"
        elseIf currentTime >= #15:00:00# and currentTime < #16:00:00# Then
            episode=7
            timesaleitemid = "3742256"
        elseIf currentTime >= #16:00:00# and currentTime < #17:00:00# Then
            episode=8
            timesaleitemid = "3738635"
        elseIf currentTime >= #17:00:00# and currentTime < #18:00:00# Then
            episode=9
            timesaleitemid = "3742255"
        elseIf currentTime >= #18:00:00# Then
            episode=10
            timesaleitemid = "3738453"
        else
            episode=0
            timesaleitemid = ""
        end if
    elseIf currentDate >= #2021-04-12 00:00:00# and currentDate < #2021-04-13 00:00:00# Then
        timesaleItemIdList = "3746914,3746908,3722405,3752141,3454935,3742749,3742229,3747691,3747692,3738455"
        If currentTime >= #09:00:00# and currentTime < #10:00:00# Then
            episode=1
            timesaleitemid = "3746914"
        elseIf currentTime >= #10:00:00# and currentTime < #11:00:00# Then
            episode=2
            timesaleitemid = "3746908"
        elseIf currentTime >= #11:00:00# and currentTime < #12:00:00# Then
            episode=3
            timesaleitemid = "3722405"
        elseIf currentTime >= #12:00:00# and currentTime < #13:00:00# Then
            episode=4
            timesaleitemid = "3752141"
        elseIf currentTime >= #13:00:00# and currentTime < #14:00:00# Then
            episode=5
            timesaleitemid = "3454935"
        elseIf currentTime >= #14:00:00# and currentTime < #15:00:00# Then
            episode=6
            timesaleitemid = "3742749"
        elseIf currentTime >= #15:00:00# and currentTime < #16:00:00# Then
            episode=7
            timesaleitemid = "3742229"
        elseIf currentTime >= #16:00:00# and currentTime < #17:00:00# Then
            episode=8
            timesaleitemid = "3747691"
        elseIf currentTime >= #17:00:00# and currentTime < #18:00:00# Then
            episode=9
            timesaleitemid = "3747692"
        elseIf currentTime >= #18:00:00# Then
            episode=10
            timesaleitemid = "3738455"
        else
            episode=0
            timesaleitemid = ""
        end if
    elseIf currentDate >= #2021-04-14 00:00:00# and currentDate < #2021-04-15 00:00:00# Then
        timesaleItemIdList = "3753079,3748354,3731940,3739018,3753051,3752204,3754681,3699585,3752630,3738469"
        If currentTime >= #09:00:00# and currentTime < #10:00:00# Then
            episode=1
            timesaleitemid = "3753079"
        elseIf currentTime >= #10:00:00# and currentTime < #11:00:00# Then
            episode=2
            timesaleitemid = "3748354"
        elseIf currentTime >= #11:00:00# and currentTime < #12:00:00# Then
            episode=3
            timesaleitemid = "3731940"
        elseIf currentTime >= #12:00:00# and currentTime < #13:00:00# Then
            episode=4
            timesaleitemid = "3739018"
        elseIf currentTime >= #13:00:00# and currentTime < #14:00:00# Then
            episode=5
            timesaleitemid = "3753051"
        elseIf currentTime >= #14:00:00# and currentTime < #15:00:00# Then
            episode=6
            timesaleitemid = "3752204"
        elseIf currentTime >= #15:00:00# and currentTime < #16:00:00# Then
            episode=7
            timesaleitemid = "3754681"
        elseIf currentTime >= #16:00:00# and currentTime < #17:00:00# Then
            episode=8
            timesaleitemid = "3699585"
        elseIf currentTime >= #17:00:00# and currentTime < #18:00:00# Then
            episode=9
            timesaleitemid = "3752630"
        elseIf currentTime >= #18:00:00# Then
            episode=10
            timesaleitemid = "3738469"
        else
            episode=0
            timesaleitemid = ""
        end if
    end if


    IF application("Svr_Info") <> "Dev" THEN
        if InStr(referer,"10x10.co.kr")<1 then
            Response.Write "Err|잘못된 접속입니다."
            dbget.close() : Response.End
        end If
    end If

    If mode="kamsg" Then
        phoneNumber = left(Base64decode(phoneNumber),13)
        if isnull(phoneNumber) or len(phoneNumber) > 13 Then
            Response.Write "Err|전화 번호를 확인 해주세요."
            dbget.close() : Response.End
        end if
        dim fullText, failText, btnJson , requestDate , loopCnt
        dim eventCount , eventTime, episode2
        if mktTest then
            requestDate = formatdate(DateAdd("n",2,now()),"0000.00.00 00:00:00")
        else
            If currentDate >= #2021-03-29 00:00:00# and currentDate < #2021-03-30 00:00:00# Then
                requestDate = formatdate(DateAdd("n",-40,#03/31/2021 09:00:00#),"0000.00.00 00:00:00")
                episode2=2
            elseIf currentDate >= #2021-03-31 00:00:00# and currentDate < #2021-04-01 00:00:00# Then
                requestDate = formatdate(DateAdd("n",-40,#04/05/2021 09:00:00#),"0000.00.00 00:00:00")
                episode2=3
            elseIf currentDate >= #2021-04-05 00:00:00# and currentDate < #2021-04-06 00:00:00# Then
                requestDate = formatdate(DateAdd("n",-40,#04/07/2021 09:00:00#),"0000.00.00 00:00:00")
                episode2=4
            elseIf currentDate >= #2021-04-07 00:00:00# and currentDate < #2021-04-08 00:00:00# Then
                requestDate = formatdate(DateAdd("n",-40,#04/12/2021 09:00:00#),"0000.00.00 00:00:00")
                episode2=5
            elseIf currentDate >= #2021-04-12 00:00:00# and currentDate < #2021-04-13 00:00:00# Then
                requestDate = formatdate(DateAdd("n",-40,#04/14/2021 09:00:00#),"0000.00.00 00:00:00")
                episode2=6
            end if
        end if

        '// db_temp.dbo.tbl_event_kakaoAlarm테이블에 실제 진행하는 episode 값을 넣어줌
        IF Not(fnIsSendKakaoAlarm(eCode,phoneNumber,episode2)) THEN
            Response.Write "Err|이미 알림톡 서비스를 신청 하셨습니다."
            dbget.close() : Response.End
        END IF

        fullText = "신청하신 [타임세일] 이벤트 알림입니다." & vbCrLf & vbCrLf &_
        "잠시 후 9시부터 이벤트 참여가 가능합니다." & vbCrLf & vbCrLf &_
        "맞아요, 이 가격." & vbCrLf &_
        "고민하는 순간 품절됩니다." & vbCrLf &_
        "서두르세요!"
        failText = "[텐바이텐] 신청하신 타임세일 이벤트 알림입니다."
        btnJson = "{""button"":[{""name"":""참여하러 가기"",""type"":""WL"",""url_mobile"":""https://tenten.app.link/n0YytasjKeb""}]}"

        IF application("Svr_Info") = "Dev" THEN
            Call SendKakaoMsg_LINK(phoneNumber,"1644-6030","A-0032",fullText,"SMS","",failText,btnJson)
        Else
            Call SendKakaoMsg_LINKForMaketing(phoneNumber,requestDate,"1644-6030","A-0032",fullText,"SMS","",failText,btnJson)
        End If

        Response.Write "OK|"
        dbget.close() : Response.End
    ElseIf mode="order" Then
        '// 응모 시간대가 아니면 튕겨낸다.
        If episode=0 Then
            Response.Write "Err|응모 가능한 상태가 아닙니다."
            Response.End
        End If

        '// 현재 해당 시간대의 상품의 재고가 있는지 확인한다.
		If getitemlimitcnt(timesaleitemid) < 1 Then 
            Response.Write "Err|준비된 수량이 소진되었습니다."
            Response.End
        End If

        '// 해당 사용자가 타임세일 상품을 구매 했는지 확인한다.
        vQuery = vQuery & " select count(*) as cnt"
        vQuery = vQuery & " from db_order.dbo.tbl_order_master m"
        vQuery = vQuery & " join db_order.dbo.tbl_order_detail d"
        vQuery = vQuery & " 	on m.orderserial=d.orderserial"
        vQuery = vQuery & " where "
        vQuery = vQuery & " m.jumundiv<>9"
        vQuery = vQuery & " and m.ipkumdiv>1"
		vQuery = vQuery & " and m.userid='"& userid &"'"
		vQuery = vQuery & " and m.cancelyn<>'Y'"
        vQuery = vQuery & " and d.itemid in ("& timesaleItemIdList &")"
        rsget.CursorLocation = adUseClient
        rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
        If rsget(0) > 0 Then
            Response.Write "Err|이미 1개 결제하셨습니다.>?nID당 1회만 구매 가능합니다."
            response.End
        End If        
        rsget.close

        '// 이벤트 응모내역을 남긴다.
        vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', '"&mode&"', '"&timesaleitemid&"', '"&apgubun&"')"
        dbget.Execute vQuery

        Response.Write "OK|"&timesaleitemid
        Response.End
    Else
        Response.Write "Err|잘못된 접속입니다."
        dbget.close() : Response.End
    End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->