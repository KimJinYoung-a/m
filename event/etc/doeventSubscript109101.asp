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
' Description : 타임세일 티저
' History : 2021-01-20 정태훈 생성
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
    mode = requestcheckvar(request("mode"),32)
    referer = request.ServerVariables("HTTP_REFERER")
    refip = request.ServerVariables("REMOTE_ADDR")
    phoneNumber = requestCheckVar(request("phoneNumber"),100)

    dim eCode, userid
    Dim sqlstr, vQuery
    IF application("Svr_Info") = "Dev" THEN
        eCode   =  "104302"
    Else
        eCode   =  "109101"
    End If

    userid = GetEncLoginUserID()

    if Userid="ley330" or Userid="greenteenz" or Userid="rnldusgpfla" or Userid="cjw0515" or Userid="thensi7" or Userid = "jj999a" or Userid = "phsman1" or Userid = "jjia94" or Userid = "seojb1983" or Userid = "kny9480" or Userid = "bestksy0527" or Userid = "mame234" or Userid = "corpse2" then
        mktTest = true
    end if

    '// 모바일웹&앱전용
    If isApp="1" Then
        apgubun = "A"
    Else
        apgubun = "M"
    End If

    if application("Svr_Info") <> "Dev" THEN
        if InStr(referer,"10x10.co.kr")<1 then
            Response.Write "Err|잘못된 접속입니다."
            dbget.close() : Response.End
        end If
    end If

    If not(left(now(),10)>="2021-01-23" and left(now(),10)<"2021-01-25" ) and not mktTest Then
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
        if mktTest then
            requestDate = formatdate(DateAdd("n",2,now()),"0000.00.00 00:00:00")
        else
            requestDate = formatdate(DateAdd("n",-40,#01/25/2021 10:00:00#),"0000.00.00 00:00:00")
        end if
        eventTime = "01월 25일"
        episode = "1"

        '// db_temp.dbo.tbl_event_kakaoAlarm테이블에 실제 진행하는 episode 값을 넣어줌
        IF Not(fnIsSendKakaoAlarm(eCode,phoneNumber,episode)) THEN
            Response.Write "Err|이미 알림톡 서비스를 신청 하셨습니다."
            dbget.close() : Response.End
        END IF

        fullText = "신청하신 [타임세일] 이벤트 알림입니다." & vbCrLf & vbCrLf &_
        "잠시 후 오전 10시부터 이벤트 참여가 가능합니다." & vbCrLf &_
        "서둘러 도전하세요!"
        failText = "[텐바이텐] 신청하신 타임세일 이벤트 알림입니다."
        btnJson = "{""button"":[{""name"":""참여하러 가기"",""type"":""WL"",""url_mobile"":""https://tenten.app.link/WPXIpyer8cb""}]}"

        IF application("Svr_Info") = "Dev" THEN
            Call SendKakaoMsg_LINK(phoneNumber,"1644-6030","A-0029",fullText,"SMS","",failText,btnJson)
        Else
            Call SendKakaoMsg_LINKForMaketing(phoneNumber,requestDate,"1644-6030","A-0029",fullText,"SMS","",failText,btnJson)
        End If

        Response.Write "OK|"
        dbget.close() : Response.End 
    Else
        Response.Write "Err|잘못된 접속입니다."
        dbget.close() : Response.End
    End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->