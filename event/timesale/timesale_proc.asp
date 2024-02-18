<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 타임세일 처리 페이지 - app 전용 단일 상품
' History : 2020-02-04 이종화 수정
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/event/timesale/timesaleCls.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
	dim mode : mode = requestCheckVar(request("mode"),5)
    dim phoneNumber : phoneNumber = requestCheckVar(request("phoneNumber"),100)
    dim sendCount : sendCount = requestCheckVar(request("sendCount"),1)
    dim selectNumber : selectNumber = requestCheckVar(request("selectnumber"),1)
    dim LoginUserid : LoginUserid = GetEncLoginUserID()
    dim currentDate, currentTime
    dim episode
    dim mktTest
    dim oJson , refer, eCode
    Set oJson = jsObject()

    mktTest = false

    IF application("Svr_Info") = "Dev" THEN
        eCode = "102196"
        mktTest = true
    ElseIf application("Svr_Info")="staging" Then
        eCode = "104371"
        mktTest = true    
    Else
        eCode = "104371"
        mktTest = false
    End If

    refer = request.ServerVariables("HTTP_REFERER") '// 레퍼러

    '// 해당 아이디들은 테스트 할때 mktTest값을 true로 강제로 적용하여 테스트
    '// TEST
    if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" then
        'mktTest = true
    end if

    if mktTest then
        '// 테스트용
        'currentDate = CDate("2020-07-23 18:00:00")
        'currentTime = Cdate("18:00:00")
        '// 테스트 끝나면 사고 방지 차원에서 서버 시간으로 변경
        currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
        currentTime = time()            
    else
        currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
        currentTime = time()    
    end if

    '// 각 일자별 타임세일 진행여부를 episode로 정함
    If currentDate >= #07/20/2020 00:00:00# and currentDate < #07/21/2020 00:00:00# Then
        '// 2020년 7월 20일 진행
        episode=1
    elseIf currentDate >= #07/21/2020 00:00:00# and currentDate < #07/22/2020 00:00:00# Then
        '// 2020년 7월 21일 진행
        episode=2
    elseIf currentDate >= #07/22/2020 00:00:00# and currentDate < #07/23/2020 00:00:00# Then
        '// 2020년 7월 22일 진행
        episode=3
    elseIf currentDate >= #07/23/2020 00:00:00# and currentDate < #07/24/2020 00:00:00# Then
        '// 2020년 7월 23일 진행
        episode=4
    else
        '// 그 외에는 티져로 인식
        episode=0
    end if    

    IF application("Svr_Info") <> "Dev" THEN
        If InStr(refer, "10x10.co.kr") < 1 Then
            oJson("response") = "err"
            oJson("faildesc") = "잘못된 접속입니다."
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End
        End If
    END IF

    if mode = "kamsg" then 
        phoneNumber = left(Base64decode(phoneNumber),13)

        if isnull(episode) or episode > 4 Then
            oJson("response") = "err"
            oJson("faildesc") = episode
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End
        end if

        if isnull(phoneNumber) or len(phoneNumber) > 13 Then
            oJson("response") = "err"
            oJson("faildesc") = "전화 번호를 확인 해주세요."
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End
        end if
        dim fullText, failText, btnJson , requestDate , loopCnt
        dim eventCount , eventTime

        if episode ="0" then
            requestDate = formatdate(DateAdd("n",-50,#07/20/2020 18:00:00#),"0000.00.00 00:00:00")
            eventTime = "7월 20일"
        elseif episode ="1" then
            requestDate = formatdate(DateAdd("n",-50,#07/21/2020 18:00:00#),"0000.00.00 00:00:00")
            eventTime = "7월 21일"
        elseif episode ="2" then
            requestDate = formatdate(DateAdd("n",-50,#07/22/2020 18:00:00#),"0000.00.00 00:00:00")
            eventTime = "7월 22일"
        elseif episode ="3" then
            requestDate = formatdate(DateAdd("n",-50,#07/23/2020 18:00:00#),"0000.00.00 00:00:00")
            eventTime = "7월 23일"
        end if

        '// db_temp.dbo.tbl_event_kakaoAlarm테이블에 실제 진행하는 episode 값을 넣어줌
        '// ex) 2020년 7월 20일 카카오 알림톡 신청시 20일자 episode는 1이지만 그 다음날 알림톡을 신청하는것이기 때문에 episode값은 2를 넣어줌
        IF Not(fnIsSendKakaoAlarm(eCode,phoneNumber,episode+1)) THEN
            oJson("response") = "err"
            oJson("faildesc") = "이미 알림톡 서비스를 신청 하셨습니다."
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End
        END IF

        fullText = "신청하신 타임세일 알림입니다." & vbCrLf & vbCrLf &_
                eventTime &"자 타임세일이" & vbCrLf &_
                "오후 6시에 곧 시작됩니다." & vbCrLf &_
                "수량이 한정되어 빠르게 품절될 수 있으니 놓치지 않게 서둘러주세요!"
        failText = "[텐바이텐] 타임세일 안내입니다."
        btnJson = "{""button"":[{""name"":""바로가기"",""type"":""WL"",""url_mobile"":""https://tenten.app.link/venIaR6j87""}]}"

        IF application("Svr_Info") = "Dev" THEN
            Call SendKakaoMsg_LINK(phoneNumber,"1644-6030","E-0008",fullText,"SMS","",failText,btnJson)
        Else
            Call SendKakaoMsg_LINKForMaketing(phoneNumber,requestDate,"1644-6030","E-0008",fullText,"SMS","",failText,btnJson)
        End If

        oJson("response") = "ok"
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
    elseif mode = "fair" then 
        if selectNumber = "" then 
            Response.End
        end if 

        dim fairPlayHtml
        dim inputBoxLocation , ButtonLocation

        SELECT CASE episode
            CASE 1
                inputBoxLocation = "top:89vw; left:8.25vw;"
                ButtonLocation = "top:109vw; left:8.25vw;"
            CASE 2
                inputBoxLocation = "top:99.31vw; left:8.25vw;"
                ButtonLocation = "top:122.59vw; left:8.25vw;"
            CASE 3
                inputBoxLocation = "top:89vw; left:22.48vw;"
                ButtonLocation = "top:109vw; left:22.48vw;"
            CASE 4
                inputBoxLocation = "top:99.31vw; left:22.48vw;"
                ButtonLocation = "top:122.59vw; left:22.48vw;"            
            CASE ELSE
                inputBoxLocation = ""
                ButtonLocation = ""
        END SELECT

        IF inputBoxLocation = "" and ButtonLocation = "" THEN
            response.end 
        END IF

        fairPlayHtml = "<div class=""inner"">"
        fairPlayHtml = fairPlayHtml & "	<p><img src=""//webimage.10x10.co.kr/fixevent/event/2019/98760/m/txt_fair.png"" alt=""우리, 페어플레이해요!""></p>"
        fairPlayHtml = fairPlayHtml & "	<div class=""input-box"&episode&""" style="""&inputBoxLocation&"""><input type=""checkbox"" name=""notRobot"&episode&""" id=""notRobot"&episode&"""><label for=""notRobot"&episode&"""></label></div>"
        fairPlayHtml = fairPlayHtml & "	<button class=""btn-get"&episode&""" style="""&ButtonLocation&""" onclick=""goDirOrdItem('"&selectNumber&"');""><img src=""//webimage.10x10.co.kr/fixevent/event/2019/98760/m/btn_get.png"" alt=""구매하기""></button> "
        fairPlayHtml = fairPlayHtml & "	<div class=""noti2""><img src=""//webimage.10x10.co.kr/fixevent/event/2020/104371/m/txt_noti2.png"" alt=""유의사항""></div>"
        fairPlayHtml = fairPlayHtml & "	<button class=""btn-close"" onclick=""fnBtnClose();""></button> "
        fairPlayHtml = fairPlayHtml & "	</div> "

        response.write fairPlayHtml

    elseif mode = "order" THEN

        dim itemid : itemid = fnGetCurrentSingleItemId(selectNumber)

        IF trim(itemid) = "" THEN
            oJson("response") = "fail"
            oJson("message") = "상품코드가 없습니다."
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End
        END IF
        
        oJson("response") = "ok"
        oJson("message") = itemid
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
    END IF
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->