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
    dim isAdmin : isAdmin = requestCheckVar(request("isAdmin"),1)
    dim selectNumber : selectNumber = requestCheckVar(request("selectnumber"),1)
    dim LoginUserid : LoginUserid = GetEncLoginUserID()

    dim oJson , refer, eCode
    Set oJson = jsObject()

    IF application("Svr_Info") = "Dev" THEN
        eCode = "101595"
    Else
        eCode = "101719"
    End If

    refer = request.ServerVariables("HTTP_REFERER") '// 레퍼러

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

        if isnull(sendCount) or sendCount > 10 Then
            oJson("response") = "err"
            oJson("faildesc") = sendCount
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

        if isAdmin = "1" then
            requestDate = formatdate(DateAdd("n",5,now()),"0000.00.00 00:00:00")
            eventTime = "4월 1일"
        else
            if sendCount ="0" then
                requestDate = formatdate(DateAdd("n",-50,#04/01/2020 18:00:00#),"0000.00.00 00:00:00")
                eventTime = "4월 1일"
            elseif sendCount ="1" then
                requestDate = formatdate(DateAdd("n",-50,#04/02/2020 18:00:00#),"0000.00.00 00:00:00")
                eventTime = "4월 2일"
            elseif sendCount ="2" then
                requestDate = formatdate(DateAdd("n",-50,#04/03/2020 18:00:00#),"0000.00.00 00:00:00")
                eventTime = "4월 3일"
            elseif sendCount ="3" then
                requestDate = formatdate(DateAdd("n",-50,#04/06/2020 18:00:00#),"0000.00.00 00:00:00")
                eventTime = "4월 6일"
            elseif sendCount ="9" then
                sendCount = "3"
                requestDate = formatdate(DateAdd("n",-50,#04/06/2020 18:00:00#),"0000.00.00 00:00:00")
                eventTime = "4월 6일"
            elseif sendCount ="4" then
                requestDate = formatdate(DateAdd("n",-50,#04/07/2020 18:00:00#),"0000.00.00 00:00:00")
                eventTime = "4월 7일"
            elseif sendCount ="5" then
                requestDate = formatdate(DateAdd("n",-50,#04/08/2020 18:00:00#),"0000.00.00 00:00:00")
                eventTime = "4월 8일"
            end if
        end if

        IF isAdmin <> "1" THEN
            IF Not(fnIsSendKakaoAlarm(eCode,phoneNumber,sendCount)) THEN
                oJson("response") = "err"
                oJson("faildesc") = "이미 알림톡 서비스를 신청 하셨습니다."
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            END IF
        END IF

        

        fullText = "신청하신 타임세일 알림입니다." & vbCrLf & vbCrLf &_
                eventTime &"자 타임세일이" & vbCrLf &_
                "오후 6시에 곧 시작됩니다." & vbCrLf &_
                "판매 수량이 한정되어 빠르게 품절될 수 있으니 놓치지 않게 서둘러주세요!"
        failText = "[텐바이텐] 타임세일 안내입니다."
        btnJson = "{""button"":[{""name"":""바로가기"",""type"":""WL"",""url_mobile"":""https://tenten.app.link/8g59sXbAb5""}]}"

        IF application("Svr_Info") = "Dev" THEN
            Call SendKakaoMsg_LINK(phoneNumber,requestDate,"1644-6030","E-0004",fullText,"SMS","",failText,btnJson)
        Else
            Call SendKakaoMsg_LINKForMaketing(phoneNumber,requestDate,"1644-6030","E-0006",fullText,"SMS","",failText,btnJson)
        End If

        oJson("response") = "ok"
        oJson("sendCount") = loopCnt
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
    elseif mode = "fair" then 
        if selectNumber = "" then 
            Response.End
        end if 

        dim fairPlayHtml
        dim inputBoxLocation , ButtonLocation

        isAdmin = chkiif(isAdmin = "1" , true , false)

        SELECT CASE fnGetCurrentSingleType(isAdmin,sendCount)
            CASE 1
                inputBoxLocation = "top:28.7rem; left:2.57rem;"
                ButtonLocation = "top:34.7rem; left:2.57rem;"
            CASE ELSE
                inputBoxLocation = ""
                ButtonLocation = ""
        END SELECT

        IF inputBoxLocation = "" and ButtonLocation = "" THEN
            response.end 
        END IF

        fairPlayHtml = "<div class=""inner"">"
        fairPlayHtml = fairPlayHtml & "	<p><img src=""//webimage.10x10.co.kr/fixevent/event/2020/101719/m/txt_fair.png"" alt=""우리 페어플레이해요""></p>"
		fairPlayHtml = fairPlayHtml & " <div class=""input-box1"" style="""& inputBoxLocation &"""><input type=""checkbox"" name=""notRobot1"" id=""notRobot1""><label for=""notRobot1""></label></div>"
		fairPlayHtml = fairPlayHtml & " <button type=""button"" class=""btn-get1"" style="""& ButtonLocation &""" onclick=""goDirOrdItem('"&selectNumber&"');""><img src=""//webimage.10x10.co.kr/fixevent/event/2020/101719/m/btn_get.png"" alt=""구매하기""></button>"
		fairPlayHtml = fairPlayHtml & " <button type=""button"" onclick=""fnBtnClose();"" class=""btn-close"">닫기</button>"
		fairPlayHtml = fairPlayHtml & "</div>"

        response.write fairPlayHtml
    elseif mode = "order" THEN
        isAdmin = chkiif(isAdmin = "1" , true , false)
        
        dim itemid : itemid = fnGetCurrentSingleItemId(selectNumber)

        IF itemid = "" THEN
            oJson("response") = "fail"
            oJson("message") = "상품코드가 없습니다."
        END IF
        
        oJson("response") = "ok"
        oJson("message") = itemid
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
    END IF
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->