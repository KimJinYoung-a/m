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
' Description : 2021 타임세일
' History : 2021-10-06 정태훈 생성
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
        eCode   =  "109398"
        mktTest = True
    ElseIf application("Svr_Info")="staging" Then
        eCode   =  "114434"
        mktTest = True
    Else
        eCode   =  "114434"
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
            currentDate = CDate("2021-10-12 09:00:00")
        end if
        currentTime = Cdate(Format00(2,hour(currentDate))&":"&Format00(2,minute(currentDate))&":"&Format00(2,second(currentDate)))
    else
        currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
        currentTime = Cdate(Format00(2,hour(currentDate))&":"&Format00(2,minute(currentDate))&":"&Format00(2,second(currentDate)))
    end if

    '// 각 일자별 타임세일 진행여부를 episode로 정함
    If currentDate >= #2021-10-12 00:00:00# and currentDate < #2021-10-13 00:00:00# Then
        timesaleItemIdList = "4122929,4121544,4115708,3687839"
        If currentTime >= #09:00:00# and currentTime < #12:00:00# Then
            episode=1
            timesaleitemid = "4122929"
        elseIf currentTime >= #12:00:00# and currentTime < #15:00:00# Then
            episode=2
            timesaleitemid = "4121544"
        elseIf currentTime >= #15:00:00# and currentTime < #18:00:00# Then
            episode=3
            timesaleitemid = "4115708"
        elseIf currentTime >= #18:00:00# Then
            episode=4
            timesaleitemid = "3687839"
        else
            episode=0
            timesaleitemid = ""
        end if
    elseIf currentDate >= #2021-10-14 00:00:00# and currentDate < #2021-10-15 00:00:00# Then
        timesaleItemIdList = "3897254,3896082,3895119,3894266"
        If currentTime >= #09:00:00# and currentTime < #12:00:00# Then
            episode=1
            timesaleitemid = "3897254"
        elseIf currentTime >= #12:00:00# and currentTime < #15:00:00# Then
            episode=2
            timesaleitemid = "3896082"
        elseIf currentTime >= #15:00:00# and currentTime < #18:00:00# Then
            episode=3
            timesaleitemid = "3895119"
        elseIf currentTime >= #18:00:00# Then
            episode=4
            timesaleitemid = "3894266"
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
            If currentDate >= #2021-10-12 00:00:00# and currentDate < #2021-10-13 00:00:00# Then
                requestDate = formatdate(DateAdd("n",-40,#10/14/2021 09:00:00#),"0000.00.00 00:00:00")
                episode2=2
            elseIf currentDate >= #2021-10-14 00:00:00# and currentDate < #2021-10-15 00:00:00# Then
                requestDate = formatdate(DateAdd("n",-40,#10/19/2021 09:00:00#),"0000.00.00 00:00:00")
                episode2=3
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

        sqlStr = "EXEC [db_event].[dbo].[usp_WWW_Event_TimeDeal_OrderCountCheck_Get] " & timesaleitemid
        'response.write sqlStr & "<br>"
        rsget.CursorLocation = adUseClient
        rsget.CursorType = adOpenStatic
        rsget.LockType = adLockOptimistic
        rsget.Open sqlStr,dbget,1
            If not(rsget(0)) Then
                Response.Write "Err|준비된 수량이 소진되었습니다."
                Response.End
            End If
        rsget.Close

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