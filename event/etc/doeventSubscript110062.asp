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
' Description : 2021 정기세일 타임세일 티저
' History : 2021-03-23 정태훈 생성
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
    dim mode, referer,refip, apgubun, phoneNumber, mktTest, currentTime, currentDate
    mode = requestcheckvar(request("mode"),32)
    referer = request.ServerVariables("HTTP_REFERER")
    refip = request.ServerVariables("REMOTE_ADDR")
    phoneNumber = requestCheckVar(request("phoneNumber"),100)
    mktTest = False
    dim eCode, userid
    Dim sqlstr, vQuery
    IF application("Svr_Info") = "Dev" THEN
        eCode   =  "104334"
        mktTest = True
    ElseIf application("Svr_Info")="staging" Then
        eCode   =  "110062"
        mktTest = True
    Else
        eCode   =  "110062"
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
            currentDate = CDate("2021-03-28 15:00:00")
        end if
        currentTime = Cdate(Format00(2,hour(currentDate))&":"&Format00(2,minute(currentDate))&":"&Format00(2,second(currentDate)))
    else
        currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
        currentTime = Cdate(Format00(2,hour(currentDate))&":"&Format00(2,minute(currentDate))&":"&Format00(2,second(currentDate)))
    end if

    IF application("Svr_Info") <> "Dev" THEN
        if InStr(referer,"10x10.co.kr")<1 then
            Response.Write "Err|잘못된 접속입니다."
            dbget.close() : Response.End
        end If
    end If

    If (left(now(),10)<"2021-03-28") and not mktTest Then
        Response.Write "Err|알림 신청기간이 아닙니다."
        dbget.close() : Response.End
    elseIf (left(now(),10)>"2021-04-13") and not mktTest Then
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
        dim eventCount , eventTime, episode2
        if mktTest then
            requestDate = formatdate(DateAdd("n",2,now()),"0000.00.00 00:00:00")
        else
            If currentDate >= #03/28/2021 00:00:00# and currentDate < #03/29/2021 00:00:00# Then
                requestDate = formatdate(DateAdd("n",-40,#03/29/2021 09:00:00#),"0000.00.00 00:00:00")
                episode2=1
            elseIf currentDate >= #03/30/2021 00:00:00# and currentDate < #03/31/2021 00:00:00# Then
                requestDate = formatdate(DateAdd("n",-40,#03/31/2021 09:00:00#),"0000.00.00 00:00:00")
                episode2=2
            elseIf currentDate >= #04/01/2021 00:00:00# and currentDate < #04/05/2021 00:00:00# Then
                requestDate = formatdate(DateAdd("n",-40,#04/05/2021 09:00:00#),"0000.00.00 00:00:00")
                episode2=3
            elseIf currentDate >= #04/06/2021 00:00:00# and currentDate < #04/07/2021 00:00:00# Then
                requestDate = formatdate(DateAdd("n",-40,#04/07/2021 09:00:00#),"0000.00.00 00:00:00")
                episode2=4
            elseIf currentDate >= #04/08/2021 00:00:00# and currentDate < #04/12/2021 00:00:00# Then
                requestDate = formatdate(DateAdd("n",-40,#04/12/2021 09:00:00#),"0000.00.00 00:00:00")
                episode2=5
            elseIf currentDate >= #04/13/2021 00:00:00# and currentDate < #04/14/2021 00:00:00# Then
                requestDate = formatdate(DateAdd("n",-40,#04/14/2021 09:00:00#),"0000.00.00 00:00:00")
                episode2=6
            else
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
    Else
        Response.Write "Err|잘못된 접속입니다."
        dbget.close() : Response.End
    End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->