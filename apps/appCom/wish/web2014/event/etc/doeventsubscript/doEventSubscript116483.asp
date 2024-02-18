<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 새해맞이 내 장비에 새 옷 입히기
' History : 2022.01.10 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
	dim currentDate, eventStartDate, eventEndDate, i, refer
	Dim eCode, LoginUserid, mode, sqlStr, device, snsType, returntext, eventobj
	dim result, oJson, mktTest, couponNumber, cnt, idx, coupondiv, couponCode, rvalue, itemid
    refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러
	Set oJson = jsObject()
	mode = request("mode")
    couponNumber = request("couponNum")
	IF application("Svr_Info") = "Dev" THEN
	else
		If InStr(refer, "10x10.co.kr") < 1 Then
			oJson("response") = "err"
			oJson("faildesc") = "잘못된 접속입니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		End If
	End If

	mktTest = False

    IF application("Svr_Info") = "Dev" THEN
        eCode = "109442"
        mktTest = True
    ElseIf application("Svr_Info")="staging" Then
        eCode = "116483"
        mktTest = True
    Else
        eCode = "116483"
        mktTest = False
    End If


    eventStartDate  = cdate("2022-01-12")		'이벤트 시작일
    eventEndDate 	= cdate("2022-01-25")		'이벤트 종료일

    LoginUserid		= getencLoginUserid()

    if mktTest then
        currentDate = cdate("2022-01-12")
    else
        currentDate = date()
    end if

    if isApp="1" then
	    device = "A"
    else
        device = "M"
    end if

	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 참여하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

if mode = "add" then
    sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode & " and sub_opt3='try' And regdate>='" & currentDate & "' and regdate<'" & dateadd("d", 1, currentDate) & "'"
    rsget.Open sqlstr, dbget, 1
        cnt = rsget("cnt")
    rsget.close

    If cnt < 1 Then
        '쿠폰 지급 로직
        sqlstr = "SELECT top 1 idx, coupondiv FROM [db_temp].[dbo].[tbl_event_116483]  WHERE isusing='N' order by newid()"
        rsget.Open sqlstr, dbget, 1
        IF Not rsget.Eof Then
            idx = rsget("idx")
            coupondiv = rsget("coupondiv")
        else
            coupondiv = "4"
        end if
        rsget.close

        couponCode = fnCouponIDX(currentDate,coupondiv)
        rvalue = fnSetSelectCouponDown(LoginUserid,couponCode)

        SELECT CASE  rvalue
			CASE 0
                oJson("response") = "err"
                oJson("message") = "정상적인 경로가 아닙니다."
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
			CASE 1
                sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt2, sub_opt3)" & vbCrlf
                sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '" & device & "', '" & coupondiv & "','try')"
                dbget.execute sqlstr

                if idx <> "" then
                    sqlStr = "update [db_temp].[dbo].[tbl_event_116483] set isusing='Y' where idx=" & Cstr(idx)
                    dbget.Execute(sqlStr)
                end if
                oJson("response") = "ok"
                oJson("message") = fnCouponName(coupondiv) & "이 지급되었습니다. 오늘까지 사용하지 않으면 사라져요!"
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
			CASE 2
				oJson("response") = "err"
                oJson("message") = "기간이 종료되었거나 유효하지 않은 쿠폰입니다."
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
			CASE 3
				oJson("response") = "err"
                oJson("message") = "오늘 쿠폰을 받으셨습니다. 내일 랜덤쿠폰에 다시 도전하세요!"
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
		END SELECT
    Else
        oJson("response") = "retry"
        oJson("message") = "오늘 쿠폰을 받으셨습니다. 내일 랜덤쿠폰에 다시 도전하세요!"
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    End If
elseif mode="join" then
    sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode & " and sub_opt3='join'"
    rsget.Open sqlstr, dbget, 1
        cnt = rsget("cnt")
    rsget.close

    If cnt < 1 Then
        sqlStr = "EXEC [db_event].[dbo].[usp_WWW_Event_Mybaguni_PadPouchItem_Get] '" & LoginUserid & "'"
        rsget.CursorLocation = adUseClient
        rsget.CursorType = adOpenStatic
        rsget.LockType = adLockOptimistic
        rsget.Open sqlStr,dbget,1
            If not rsget.EOF Then
                itemid = rsget(0)
            End If
        rsget.Close
        if itemid>0 then
            sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt2, sub_opt3)" & vbCrlf
            sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '" & device & "', '" & itemid & "','join')"
            dbget.execute sqlstr
            oJson("response") = "ok"
            oJson("message") = "장바구니에 노트북파우치 or 아이패드 파우치를 넣어주세요!"
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End
        else
            oJson("response") = "err"
            oJson("message") = "장바구니에 노트북파우치 or 아이패드 파우치를 넣어주세요!"
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End
        end if
    else
        oJson("response") = "retry"
        oJson("message") = "이미 응모하셨습니다."
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    end if
elseif mode = "pushadd" then
	dim vQuery, pushDate
	''푸시 신청
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("message") = "로그인 후 알림 신청이 가능합니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

	pushDate = dateadd("d", 1, currentDate)

	'// 다음날 푸쉬 신청을 했는지 확인한다.
	vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_pickUpEvent_Push2] WITH (NOLOCK) WHERE userid='"&LoginUserid&"' And convert(varchar(10), SendDate, 120) = '"&Left(pushDate, 10)&"' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		If rsget(0) > 0 Then
			oJson("response") = "err"
			oJson("message") = "이미 신청이 완료되었습니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		End If
	End IF
	rsget.close

	vQuery = " INSERT INTO [db_temp].[dbo].[tbl_pickUpEvent_Push2](userid, SendDate, Sendstatus, RegDate) VALUES('" & LoginUserid & "', '"&Left(pushDate, 10)&"', 'N', getdate())"
	dbget.Execute vQuery

	oJson("response") = "ok"
	oJson("sendCount") = 0
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode="alarm" then
    sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode & " and sub_opt3='alarm'"
    rsget.Open sqlstr, dbget, 1
        cnt = rsget("cnt")
    rsget.close

    If cnt < 1 Then
        sqlStr = ""
        sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt3)" & vbCrlf
        sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '" & device & "', 'alarm')"
        dbget.execute sqlstr

        oJson("response") = "ok"
        oJson("message") = "알림 신청이 완료되었습니다. 1월 27일 당첨일을 기다려주세요!"
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    Else
        oJson("response") = "retry"
        oJson("message") = "이미 신청이 완료되었습니다. 1월 27일 당첨일을 기다려주세요!"
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    End If
end if
function fnCouponName(couponDiv)
    if couponDiv="1" then
        fnCouponName="[디지털짝꿍] 디지털/핸드폰 30,000원 쿠폰"
    elseif couponDiv="2" then
        fnCouponName="[디지털짝꿍] 디지털/핸드폰 10,000원 쿠폰"
    elseif couponDiv="3" then
        fnCouponName="[디지털짝꿍] 디지털/핸드폰 5,000원 쿠폰"
    else
        fnCouponName="[디지털짝꿍] 디지털/핸드폰 3,000원 쿠폰"
    end if

end function
function fnCouponIDX(joinDate,couponDiv)
    if joinDate="2022-01-12" then
        If application("Svr_Info")="staging" Then
            if couponDiv="1" then
                fnCouponIDX="2009"
            elseif couponDiv="2" then
                fnCouponIDX="2010"
            elseif couponDiv="3" then
                fnCouponIDX="2011"
            else
                fnCouponIDX="2012"
            end if
        else
            if couponDiv="1" then
                fnCouponIDX="1952"
            elseif couponDiv="2" then
                fnCouponIDX="1953"
            elseif couponDiv="3" then
                fnCouponIDX="1954"
            else
                fnCouponIDX="1955"
            end if
        end if
    elseif joinDate="2022-01-13" then
        if couponDiv="1" then
            fnCouponIDX="1956"
        elseif couponDiv="2" then
            fnCouponIDX="1957"
        elseif couponDiv="3" then
            fnCouponIDX="1958"
        else
            fnCouponIDX="1959"
        end if
    elseif joinDate="2022-01-14" then
        if couponDiv="1" then
            fnCouponIDX="1960"
        elseif couponDiv="2" then
            fnCouponIDX="1961"
        elseif couponDiv="3" then
            fnCouponIDX="1962"
        else
            fnCouponIDX="1963"
        end if
    elseif joinDate="2022-01-15" then
        if couponDiv="1" then
            fnCouponIDX="1964"
        elseif couponDiv="2" then
            fnCouponIDX="1965"
        elseif couponDiv="3" then
            fnCouponIDX="1966"
        else
            fnCouponIDX="1967"
        end if
    elseif joinDate="2022-01-16" then
        if couponDiv="1" then
            fnCouponIDX="1968"
        elseif couponDiv="2" then
            fnCouponIDX="1969"
        elseif couponDiv="3" then
            fnCouponIDX="1970"
        else
            fnCouponIDX="1971"
        end if
    elseif joinDate="2022-01-17" then
        if couponDiv="1" then
            fnCouponIDX="1972"
        elseif couponDiv="2" then
            fnCouponIDX="1973"
        elseif couponDiv="3" then
            fnCouponIDX="1974"
        else
            fnCouponIDX="1975"
        end if
    elseif joinDate="2022-01-18" then
        if couponDiv="1" then
            fnCouponIDX="1976"
        elseif couponDiv="2" then
            fnCouponIDX="1977"
        elseif couponDiv="3" then
            fnCouponIDX="1978"
        else
            fnCouponIDX="1979"
        end if
    elseif joinDate="2022-01-19" then
        if couponDiv="1" then
            fnCouponIDX="1980"
        elseif couponDiv="2" then
            fnCouponIDX="1981"
        elseif couponDiv="3" then
            fnCouponIDX="1982"
        else
            fnCouponIDX="1983"
        end if
    elseif joinDate="2022-01-20" then
        if couponDiv="1" then
            fnCouponIDX="1984"
        elseif couponDiv="2" then
            fnCouponIDX="1985"
        elseif couponDiv="3" then
            fnCouponIDX="1986"
        else
            fnCouponIDX="1987"
        end if
    elseif joinDate="2022-01-21" then
        if couponDiv="1" then
            fnCouponIDX="1988"
        elseif couponDiv="2" then
            fnCouponIDX="1989"
        elseif couponDiv="3" then
            fnCouponIDX="1990"
        else
            fnCouponIDX="1991"
        end if
    elseif joinDate="2022-01-22" then
        if couponDiv="1" then
            fnCouponIDX="1992"
        elseif couponDiv="2" then
            fnCouponIDX="1993"
        elseif couponDiv="3" then
            fnCouponIDX="1994"
        else
            fnCouponIDX="1995"
        end if
    elseif joinDate="2022-01-23" then
        if couponDiv="1" then
            fnCouponIDX="1996"
        elseif couponDiv="2" then
            fnCouponIDX="1997"
        elseif couponDiv="3" then
            fnCouponIDX="1998"
        else
            fnCouponIDX="1999"
        end if
    elseif joinDate="2022-01-24" then
        if couponDiv="1" then
            fnCouponIDX="2000"
        elseif couponDiv="2" then
            fnCouponIDX="2001"
        elseif couponDiv="3" then
            fnCouponIDX="2002"
        else
            fnCouponIDX="2003"
        end if
    elseif joinDate="2022-01-25" then
        if couponDiv="1" then
            fnCouponIDX="2004"
        elseif couponDiv="2" then
            fnCouponIDX="2005"
        elseif couponDiv="3" then
            fnCouponIDX="2006"
        else
            fnCouponIDX="2007"
        end if
    end if
end function

Function fnSetSelectCouponDown(ByVal LoginUserid, ByVal idx)
    dim sqlStr
    Dim objCmd
    Set objCmd = Server.CreateObject("ADODB.COMMAND")
    With objCmd
        .ActiveConnection = dbget
        .CommandType = adCmdText
        .CommandText = "{?= call [db_user].[dbo].sp_Ten_eventcoupon_down_selected("&idx&",'"&LoginUserid&"')}"
        .Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
        .Execute, , adExecuteNoRecords
        End With
        fnSetSelectCouponDown = objCmd(0).Value
    Set objCmd = Nothing
END Function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->