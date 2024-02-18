<%
''session library 2018/15  included in commlib
'' commlib 가 중복 인클루드 되는 케이스도 있음.. 전부 함수로 치환

CALL fnChkDBSessionUpdateV2()

function fnChkDBSessionUpdateV2()
    
    dim cookieSsnhash, cookieSsnDt
    '' iOS & 네이버앱 환경에서 간헐적으로 발생하는 오류 예외 처리
    On Error Resume Next
            cookieSsnhash = request.cookies("mssn")("ssnhash")                 ''로그인시 값과 동일해야함.
            cookieSsnDt = request.Cookies("mssn")("ssndt")                      ''로그인시 값과 동일해야함.  tinfo 로변경.
        If Err.number <> 0 Then
            cookieSsnhash = ""
            cookieSsnDt = ""
        end if
    On Error Goto 0

    dim isReqSSnUp      : isReqSSnUp = false
    dim isDbssnExists   : isDbssnExists = false

    dim chksession
    dim ssnuserid  : ssnuserid  = session("ssnuserid")
    dim ssnhash : ssnhash = session("ssnhash")

    ''제외할 경로는 여기에 넣자. =====================================================================
    Dim iCurrPage : iCurrPage = LCASE(request.ServerVariables("SCRIPT_NAME"))

    '' 소문자로 비교
    'if (LEFT(iCurrPage,LEN("/index.asp")) = "/index.asp") then Exit function
    if (LEFT(iCurrPage,LEN("/apps/appcom/between/")) = "/apps/appcom/between/") then Exit function
    if (LEFT(iCurrPage,LEN("/search/act_autocomplete2017.asp")) = "/search/act_autocomplete2017.asp") then Exit function
    if (LEFT(iCurrPage,LEN("/apps/appcom/wish/protov3/loginproc.asp")) = "/apps/appcom/wish/protov3/loginproc.asp") then Exit function
    if (LEFT(iCurrPage,LEN("/apps/appcom/wish/protov2/loginproc.asp")) = "/apps/appcom/wish/protov2/loginproc.asp") then Exit function

    ''여러번 실행되는걸 막자 commlib가 여러번실행(execute) or Include 될수 있음
    if (session("duppexcept")=iCurrPage&now()) then Exit function
    session("duppexcept")=iCurrPage&now()
    '' ===========================================================================================

    if (cookieSsnhash="") and (ssnuserid<>"") then
        ''chksession = request.Cookies("CHKSESSION")
        ''if (chksession = Left(Now(), 10)) then
            '// 검증용 보안쿠키가 있으면.
            '' 크롬 SameSite 버그 있는 듯.
            Exit function
        ''end if

        session("ssnuserid") = ""
        session("ssnlogindt") = ""
        session("ssnlastcheckdt") = ""
        '' session.abandon   ''실오픈시까지 제외.
    elseif (ssnuserid<>"") then
        '// TODO : 쿠리 하이제킹 대응 해야 함
        Exit function
    end if

    if (cookieSsnhash="") then Exit function

    dim nowDateTime     : nowDateTime=now()
    dim cookieDateTime  : cookieDateTime=fnLongTimeToDateTime(cookieSsnDt)

    dim ssnlogindt : ssnlogindt = session("ssnlogindt")
    dim ssnlastcheckdt : ssnlastcheckdt = session("ssnlastcheckdt")
    dim ssnlastcheckDateTime : ssnlastcheckDateTime=fnLongTimeToDateTime(ssnlastcheckdt)
    dim nowSsnDt, iretssndata, iloginuserid
    dim isSessionExists : isSessionExists=FALSE


    ''세션이존재하고 최종업데이트 시간이 SSN_get_ssnUpdateReCycleTime 보다 크면 업데이트. (너무 자주업데이트 하지 않도록)
    if (LCASE(cookieSsnhash)=LCase(ssnhash)) then
        isSessionExists = true
        isReqSSnUp = datediff("s",ssnlastcheckDateTime,nowDateTime)>SSN_get_ssnUpdateReCycleTime

    else    ''cookieSsnDt 없는경우 등. 2016/12/15 수정.
        isReqSSnUp = TRUE
    end if

    if (ssnhash="") then
        isReqSSnUp = true
    elseif (LCASE(cookieSsnhash)<>LCase(ssnhash)) then   '' 다르면 안됨.
        ''Call CookieSessionExpire("9") '' 여기서 가끔 걸림.. 디비에 여려개 꽃히는 경우?  //어떤걸 기준으로 다시 가져와야 할거 같음.
        ''Exit function

        isReqSSnUp = true '' 이렇게 수정. 아래쪽에서 체크될듯.
    end if

    ''세션이 날라간 경우는 다시 불러와야 한다.
    if (ssnuserid="") or (ssnlogindt="") then
        isReqSSnUp = TRUE
    end if

    ''DB에 값이 있는지 체크 후 DB 값으로 재세팅.
    if (isReqSSnUp) then
        nowSsnDt = fnDateTimeToLongTime(nowDateTime)
        isDbssnExists = fnCheckDBsessionUpdateV2(cookieSsnhash,cookieSsnDt,nowSsnDt,SSN_get_MaxSessionTimedOUT,iloginuserid,iretssndata)

        if (isDbssnExists) then ''세션 업데이트.
            session("ssnlastcheckdt") = nowSsnDt    ''다시체크를 위해업데이트
            session("ssnhash") = cookieSsnhash
            if (ssnuserid<>"") and (LCASE(ssnuserid)<>LCASE(iloginuserid)) then ''이런경우는 좀..
                Call CookieSessionExpire("2")
                exit function
            end if

            Call fnRestoreSessionFromDBData(iretssndata)
            Call set_cookie_secure("CHKSESSION", Left(Now(), 10), "/", 24)

            if (LCASE(session("ssnuserid"))<>LCASE(iloginuserid)) then  ''이런경우도 좀.
                Call CookieSessionExpire("3")
                exit function
            end if

            ''쿠폰발행 체크 및 자동로그인 사용자 최종로그인 업데이트
            Call fnChkSsnLoginEvalMonthCoupon    '' in commlib => tensessionLib

            ''자동로그인 사용자
            Dim rvalue : rvalue = fnReSetSsnLoginDt(nowSsnDt)

            if rvalue = True then
                ''모웹 자동 로그인 2019년10월 18주년 상품쿠폰 지급
                Dim objCon : Set objCon = CreateObject("ADODB.Connection")
                objCon.Open Application("db_main")

                If application("Svr_Info")="Dev" Then
                    If date() > "2019-09-25" AND date() < "2019-10-01" Then
                        Call setItemCouponDown(22174,objCon)
                        Call setItemCouponDown(22173,objCon)
                        Call setItemCouponDown(22171,objCon)
                    End IF
                Else
                    If date() > "2019-09-30" AND date() < "2019-11-01" Then
                        Call setItemCouponDown(56078,objCon)
                        Call setItemCouponDown(56079,objCon)
                        Call setItemCouponDown(56080,objCon)
                        Call setItemCouponDown(56081,objCon)
                        Call setItemCouponDown(56082,objCon)
                        Call setItemCouponDown(56083,objCon)
                    End IF
                End IF

                objCon.Close
                SET objCon = Nothing
            end if

            '// 자동로그인 때도 login coupon 지급
            Call loginCouponInsert()

        else
            ''쿠키 /세션 날림.
            Call CookieSessionExpire("1")
        end if
    end if
end function

Sub setItemCouponDown(ByVal idx, ByVal oCon)
    If application("Svr_Info")="Dev" Then
        response.write("<script>alert('"&idx&"');</script>")
    End IF
    Dim objCmd : Set objCmd = Server.CreateObject("ADODB.COMMAND")
    With objCmd
		.ActiveConnection = oCon
		.CommandType = adCmdText
		.CommandText = "{?= call [db_item].[dbo].sp_Ten_itemcoupon_down("&idx&",'"&getLoginUserid()&"')}"
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With
	Set objCmd = Nothing
    If application("Svr_Info")="Dev" Then
        response.write("<script>alert('"&adParamReturnValue&"');</script>")
    End IF
END Sub

Sub setLoginMileage(ByVal oCon)
    Dim objCmd : Set objCmd = Server.CreateObject("ADODB.COMMAND")
    With objCmd
		.ActiveConnection = oCon
		.CommandType = adCmdText
		.CommandText = "{?= call [db_user].[dbo].[usp_WWW_LOGIN_Mileage_INSERT]('"&getLoginUserid()&"')}"
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With
	Set objCmd = Nothing
    If application("Svr_Info")="Dev" Then
        response.write("<script>alert('"&adParamReturnValue&"');</script>")
    End IF
END Sub

Sub fnChkSsnLoginEvalMonthCoupon()
    '' 1. 자동로그인에 대한 loginlog / lastLogindate 처리. => tenSesionLib 에서 처리하는것으로 변경
	'' 2. 월이 지났을 경우 쿠폰 발행 처리. (자동로그인, 일반 둘다.)

	if (Not IsUserLoginOK) then Exit Sub
	if (session("ltimeloginchk")<>"") then Exit Sub '' 함 체크 했으믄 그만.

	dim lgDt : lgDt = request.cookies("mssn")("dtauto") ''자동로그인체크시각 (자동로그인 한경우)
	if (lgDt="") then lgDt = request.Cookies("mssn")("ssndt")

	if (lgDt="") then Exit Sub  '' 없으면 상관없음.
	if (NOT IsNumeric(lgDt)) then Exit Sub

	''if (DateDiff("h",DateSerial(Year(date),Month(date),1), now) < 4) then Exit Sub '' 월초 1일 4시 전은 동작하지 말자..
    ''Log 방식이고 Batch 처리에서 시간체크를 하는것으로 월초에도 로그를 쌓는다.

	dim isRequireCpnEval : isRequireCpnEval = FALSE
	dim isRequireReAutologinSet : isRequireReAutologinSet = FALSE

    dim iorginDt : iorginDt = Now()
    dim nowDt : nowDt = Year(iorginDt)&Right("00"&Month(iorginDt),2)&Right("00"&Day(iorginDt),2)&Right("00"&Hour(iorginDt),2)&Right("00"&Minute(iorginDt),2)&Right("00"&Second(iorginDt),2)

	Dim diffTime
	diffTime = CLNG((nowDt-lgDt)/60/60)  '' 경과시간

	if NOT (LEFT(nowDt,6)>LEFT(lgDt,6)) then Exit Sub '' 달이 지난경우만 상관있음.

    dim iSsnCon, strSql
	if (getLoginUserDiv="01") or (getLoginUserDiv="05") or (getLoginUserDiv="99") then
		''log 방식으로 변경.
        set iSsnCon = CreateObject("ADODB.Connection")
        iSsnCon.Open Application(SSN_get_TEN_APP_CON_NAME) ''커넥션 스트링.
        strSql = "db_user.[dbo].[sp_TEN_SSN_Auto_Login_MonthCpn_CheckLOG] '"&getLoginUserid()&"'"
        iSsnCon.Execute(strSql)

        iSsnCon.Close
        SET iSsnCon = Nothing
	end if

	session("ltimeloginchk") = lgDt
End Sub

function SSN_get_MaxSessionTimedOUT()
    SSN_get_MaxSessionTimedOUT = 60*60*20    ''2Hour 이상 적당.  세션이 날라갔을경우 쿠키로 세션을 복구할 시간 (웹서버 세션시간보다 커야함..)

    IF (application("Svr_Info")="Dev") then
        SSN_get_MaxSessionTimedOUT = 60*60*1
    END IF
end function

function SSN_get_ssnUpdateReCycleTime()
    SSN_get_ssnUpdateReCycleTime = 60*20 ''20  ''10~20분사이 적당할듯. 디비 체크 및 세션 업데이트 체크 주기 C_MaxSessionTimedOUT 보다 작아야.

    IF (application("Svr_Info")="Dev") then
        SSN_get_ssnUpdateReCycleTime = 20
    END IF
end function

function SSN_get_LongTimeSessionTimedOUT()
    SSN_get_LongTimeSessionTimedOUT = 60*60*24*15 '' 15일  연결유지

    IF (application("Svr_Info")="Dev") then
        SSN_get_LongTimeSessionTimedOUT = 60*60*24*3
    END IF
end function

function SSN_get_TEN_APP_CON_NAME()
    SSN_get_TEN_APP_CON_NAME = "db_main"
end function


function fnDateTimeToLongTime(icookieLoginDt)
    dim iorginDt : iorginDt = icookieLoginDt
    iorginDt = CDate(iorginDt)

    fnDateTimeToLongTime = Year(iorginDt)&Right("00"&Month(iorginDt),2)&Right("00"&Day(iorginDt),2)&Right("00"&Hour(iorginDt),2)&Right("00"&Minute(iorginDt),2)&Right("00"&Second(iorginDt),2)
end function

function fnLongTimeToDateTime(ilongTime)
    dim iorgDt : iorgDt= ilongTime
    if LEN(ilongTime)<>14 then
        Exit function
    end if

    fnLongTimeToDateTime = CDate(LEFT(ilongTime,4)&"-"&MID(ilongTime,5,2)&"-"&MID(ilongTime,7,2)&" "&MID(ilongTime,9,2)&":"&MID(ilongTime,11,2)&":"&MID(ilongTime,13,2))
end function


''디비 세션 생성 log-on
function fnDBSessionCreateV2(ilgnchannel, issnExistsType)
    dim ssnuserid  : ssnuserid =  session("ssnuserid")
    dim ssnlogindt : ssnlogindt = session("ssnlogindt")

    if (ssnuserid="") or (ssnlogindt="") then Exit function

    Dim ssnkeepAddtime : ssnkeepAddtime = 0
    if (issnExistsType=1) then ssnkeepAddtime=SSN_get_LongTimeSessionTimedOUT
    Dim isessionData : isessionData = fnMakeSessionToDBData()  ''2018/08/07 세션값을 Serialize

    dim iSsnCon : set iSsnCon = CreateObject("ADODB.Connection")
    Dim cmd : set cmd = server.CreateObject("ADODB.Command")

    dim sqlStr
    sqlStr = "db_user.[dbo].[sp_TEN_SSN_CREATE_V2]"

    iSsnCon.Open Application(SSN_get_TEN_APP_CON_NAME) ''커넥션 스트링.
    cmd.ActiveConnection = iSsnCon
    cmd.CommandText = sqlStr
    cmd.CommandType = adCmdStoredProc

    cmd.Parameters.Append cmd.CreateParameter("@ssnuserid", adVarchar, adParamInput, 32, ssnuserid)
    cmd.Parameters.Append cmd.CreateParameter("@ssnlogindt", adVarchar, adParamInput, 14, ssnlogindt)
    cmd.Parameters.Append cmd.CreateParameter("@lgnchannel", adVarchar, adParamInput, 1, ilgnchannel)
    cmd.Parameters.Append cmd.CreateParameter("@ssnkeepAddtime", adInteger, adParamInput, , ssnkeepAddtime)
    cmd.Parameters.Append cmd.CreateParameter("@ssndata", adVarWChar, adParamInput, 384, isessionData)
    cmd.Parameters.Append cmd.CreateParameter("@retSsnHash", adVarchar, adParamOutput, 64, "")

    cmd.Execute
    Dim iretSsnHash : iretSsnHash = cmd.Parameters("@retSsnHash").Value
    fnDBSessionCreateV2 = iretSsnHash

    set cmd = Nothing
    iSsnCon.Close
    SET iSsnCon = Nothing

end function

function fnDBSessionExpireV2()
    dim ssnhash : ssnhash = session("ssnhash")
    dim cookiessnHash : cookiessnHash = request.Cookies("mssn")("ssnhash")

    if (ssnhash="") and (cookiessnHash="") then Exit function
    if (ssnhash="") then ssnhash=cookiessnHash

    dim iSsnCon : set iSsnCon = CreateObject("ADODB.Connection")
    dim intResult
    dim sqlStr

    iSsnCon.Open Application(SSN_get_TEN_APP_CON_NAME) ''커넥션 스트링.

    Dim cmd : set cmd = server.CreateObject("ADODB.Command")
    sqlStr = "db_user.[dbo].[sp_TEN_SSN_EXPIRE_V2]"
    cmd.ActiveConnection = iSsnCon
    cmd.CommandText = sqlStr
    cmd.CommandType = adCmdStoredProc

    cmd.Parameters.Append cmd.CreateParameter("returnValue", adInteger, adParamReturnValue)
    cmd.Parameters.Append cmd.CreateParameter("@ssnHash", adVarchar, adParamInput, 64, ssnhash)
    cmd.Execute

    intResult = cmd.Parameters("returnValue").Value
    set cmd = Nothing

    iSsnCon.Close
    SET iSsnCon = Nothing

    fnDBSessionExpireV2 = (intResult>0)
end function


function fnCheckDBsessionUpdateV2(icookieSsnhash,icookieSsnDt,inowSsnDt,iMaxSessionTimedOUT,byRef iloginuserid, byRef iretssndata)
    fnCheckDBsessionUpdateV2 = false
    if (icookieSsnhash="") or (icookieSsnDt="") then Exit function

    dim iSsnCon : set iSsnCon = CreateObject("ADODB.Connection")
    Dim cmd : set cmd = server.CreateObject("ADODB.Command")
    dim intResult

    dim sqlStr
    sqlStr = "db_user.[dbo].[sp_TEN_SSN_CHECKNUPDATE_V2]"

    iSsnCon.Open Application(SSN_get_TEN_APP_CON_NAME) ''커넥션 스트링.
    cmd.ActiveConnection = iSsnCon
    cmd.CommandText = sqlStr
    cmd.CommandType = adCmdStoredProc

    cmd.Parameters.Append cmd.CreateParameter("returnValue", adInteger, adParamReturnValue)
    cmd.Parameters.Append cmd.CreateParameter("@ssnhash", adVarchar, adParamInput, 64, icookieSsnhash)
    cmd.Parameters.Append cmd.CreateParameter("@ssnlogindt", adVarchar, adParamInput, 14, icookieSsnDt)
    cmd.Parameters.Append cmd.CreateParameter("@ssntimeoutScond", adInteger, adParamInput, , iMaxSessionTimedOUT)
    cmd.Parameters.Append cmd.CreateParameter("@retloginuserid", adVarchar, adParamOutput, 32, "")
    cmd.Parameters.Append cmd.CreateParameter("@retssndata", adVarWchar, adParamOutput, 384, "")
    cmd.Execute

    intResult = cmd.Parameters("returnValue").Value
    iloginuserid = cmd.Parameters("@retloginuserid").Value
    iretssndata = cmd.Parameters("@retssndata").Value

    set cmd = Nothing
    iSsnCon.Close
    SET iSsnCon = Nothing

    fnCheckDBsessionUpdateV2 = (intResult>0)
end function



function CookieSessionExpire(nk)
    Dim iCookieDomain : iCookieDomain = "10x10.co.kr"
    IF application("Svr_Info")="Dev" THEN
        if (request.ServerVariables("LOCAL_ADDR")="::1") or (request.ServerVariables("LOCAL_ADDR")="127.0.0.1") then
            iCookieDomain = "localhost"
        end if
    End if

    ''log-out
    response.Cookies("mssn").domain = iCookieDomain
    response.Cookies("mssn") = ""
    response.Cookies("mssn").Expires = Date - 1

''실오픈시까지 제외.
    response.Cookies("uinfo").domain = iCookieDomain
    response.Cookies("uinfo") = ""
    response.Cookies("uinfo").Expires = Date - 1

    response.Cookies("etc").domain = iCookieDomain
    response.Cookies("etc") = ""
    response.Cookies("etc").Expires = Date - 1

    session.abandon

    ''addLog 추가 로그 //2016/12/16
    dim iAddLogs
    iAddLogs = "r=snexpire"&nk
    if (request.ServerVariables("QUERY_STRING")<>"") then iAddLogs="&"&iAddLogs
    response.AppendToLog iAddLogs&"&"

end function


'' 세션값이 변경될경우 DB 세션값을 변경한다. 이름,이메일,레벨
function fnEtcSessionChangedToDBSessionUpdate()
    dim ssnuserid  : ssnuserid =  session("ssnuserid")
    dim ssnlogindt : ssnlogindt = session("ssnlogindt")
    dim ssnhash : ssnhash = session("ssnhash")
    Dim isessionData : isessionData = fnMakeSessionToDBData()

    dim iSsnCon : set iSsnCon = CreateObject("ADODB.Connection")
    Dim cmd : set cmd = server.CreateObject("ADODB.Command")
    dim intResult
    if (ssnhash="") then Exit function

    dim sqlStr
    sqlStr = "db_user.[dbo].[sp_TEN_SSN_SET_V2]"

    iSsnCon.Open Application(SSN_get_TEN_APP_CON_NAME) ''커넥션 스트링.
    cmd.ActiveConnection = iSsnCon
    cmd.CommandText = sqlStr
    cmd.CommandType = adCmdStoredProc

    cmd.Parameters.Append cmd.CreateParameter("returnValue", adInteger, adParamReturnValue)
    cmd.Parameters.Append cmd.CreateParameter("@ssnhash", adVarchar, adParamInput, 64, ssnhash)
    cmd.Parameters.Append cmd.CreateParameter("@ssnuserid", adVarchar, adParamInput, 32, ssnuserid)
    cmd.Parameters.Append cmd.CreateParameter("@ssnlogindt", adVarchar, adParamInput, 14, ssnlogindt)
    cmd.Parameters.Append cmd.CreateParameter("@ssndata", adVarWChar, adParamInput, 384, isessionData)
    cmd.Execute

    set cmd = Nothing
    iSsnCon.Close
    SET iSsnCon = Nothing

end function
''2018/08/07 DB저장할 세션값 Serialize
function fnMakeSessionToDBData()
    Dim retData
    Dim ispliter : ispliter = "||"
    retData = ""
    retData = retData & "ssnuserid=="&session("ssnuserid")&ispliter
    retData = retData & "ssnlogindt=="&session("ssnlogindt")&ispliter
    retData = retData & "ssnusername=="&replace(session("ssnusername"),ispliter,"")&ispliter
    retData = retData & "ssnuserdiv=="&session("ssnuserdiv")&ispliter
    retData = retData & "ssnuserlevel=="&session("ssnuserlevel")&ispliter
	retData = retData & "ssnrealnamecheck=="&session("ssnrealnamecheck")&ispliter
    retData = retData & "ssnuseremail=="&replace(session("ssnuseremail"),ispliter,"")&ispliter
    retData = retData & "ssnisAdult=="&chkIIF(session("isAdult"),"Y","N")&ispliter
    fnMakeSessionToDBData = retData
end function

''2018/08/07 DB저장 세션값 DeSerialize
function fnRestoreSessionFromDBData(idata)
    Dim ispliter : ispliter = "||"
    Dim iArrData, i, iOneRows

    if isNULL(idata) then Exit function
    if Len(idata)<1 then Exit function

    iArrData = split(idata,ispliter)

    if NOT isArray(iArrData) then Exit function

    for i=LBound(iArrData) to UBound(iArrData)
        iOneRows = iArrData(i)
        Call AssignSessionByOneSsnData(iOneRows)
    Next
end function

Sub AssignSessionByOneSsnData(ioneRow)
    if isNULL(ioneRow) then Exit Sub
    if Len(ioneRow)<1 then Exit Sub

    dim issnName, issnValue
    dim isplitedVar

    isplitedVar = split(ioneRow,"==")
    if NOT isArray(isplitedVar) then Exit Sub

    if UBound(isplitedVar)<1 then Exit Sub

    issnName  = isplitedVar(0)
    issnValue = isplitedVar(1)
    if (issnName="") then Exit Sub

    if issnName = "ssnisAdult" then
        session("isAdult") = (issnValue="Y")
    else
        session(issnName) = issnValue
    end if
end Sub

''자동로그인 및 장기로그인 접속자로그인 날짜를 업뎃
public function fnReSetSsnLoginDt(inowSsnDt)
    Dim idtauto : idtauto = request.cookies("mssn")("dtauto")
    if (idtauto="") then Exit function ''자동로그인인경우 만 로그를 쌓자.
	if (NOT IsNumeric(idtauto)) then Exit function

    if NOT (LEFT(inowSsnDt,8)>LEFT(idtauto,8)) then Exit function '' 날짜가 지난경우만 상관있음.

    dim ssnuserid  : ssnuserid =  session("ssnuserid")
    dim ssnlogindt : ssnlogindt = session("ssnlogindt")
    dim ssnhash : ssnhash = session("ssnhash")

    fnReSetSsnLoginDt = FALSE
    if (ssnhash="") or (ssnlogindt="") or (ssnuserid="") then Exit function

    Dim iuAgent : iuAgent = Lcase(Request.ServerVariables("HTTP_USER_AGENT"))
    Dim iflgDevice : iflgDevice=""
    if instr(iuAgent,"ipod")>0 or instr(iuAgent,"iphone")>0 or instr(iuAgent,"ipad")>0 then
        iflgDevice = "I" 'iPhone,iPod,iPad
    elseif instr(iuAgent,"android")>0 then
        iflgDevice = "A" 'Android
    else
        iflgDevice = "M"	'Mobile
    end if

    dim iSsnCon : set iSsnCon = CreateObject("ADODB.Connection")
    Dim cmd : set cmd = server.CreateObject("ADODB.Command")
    dim intResult, ssnkeepAddtime : ssnkeepAddtime = 0

    Dim irefip : irefip = Request.ServerVariables("REMOTE_ADDR")
    Dim isiteDiv : isiteDiv = "ten_m_auto"
    Dim ilgnGuid : ilgnGuid = LEFT(fn_getGgsnCookie(),40)

    dim sqlStr
    sqlStr = "db_user.[dbo].[sp_TEN_SSN_Auto_LoginSET]"

    iSsnCon.Open Application(SSN_get_TEN_APP_CON_NAME) ''커넥션 스트링.
    cmd.ActiveConnection = iSsnCon
    cmd.CommandText = sqlStr
    cmd.CommandType = adCmdStoredProc

    cmd.Parameters.Append cmd.CreateParameter("returnValue", adInteger, adParamReturnValue)
    cmd.Parameters.Append cmd.CreateParameter("@ssnhash", adVarchar, adParamInput, 64, ssnhash)
    cmd.Parameters.Append cmd.CreateParameter("@ssnuserid", adVarchar, adParamInput, 32, ssnuserid)
    cmd.Parameters.Append cmd.CreateParameter("@ssnlogindt", adVarchar, adParamInput, 14, ssnlogindt)
    cmd.Parameters.Append cmd.CreateParameter("@ssntimeoutScond", adInteger, adParamInput, , SSN_get_MaxSessionTimedOUT)

    cmd.Parameters.Append cmd.CreateParameter("@refip", adVarchar, adParamInput, 16, irefip)
    cmd.Parameters.Append cmd.CreateParameter("@siteDiv", adVarchar, adParamInput, 16, isiteDiv)
    cmd.Parameters.Append cmd.CreateParameter("@chkDevice", adVarchar, adParamInput, 1, iflgDevice)
    cmd.Parameters.Append cmd.CreateParameter("@lgnGuid", adVarchar, adParamInput, 40, ilgnGuid)

    cmd.Parameters.Append cmd.CreateParameter("@ssnkeepAddtime", adInteger, adParamOutput, 0)

    cmd.Execute

    intResult = cmd.Parameters("returnValue").Value
    ssnkeepAddtime = cmd.Parameters("@ssnkeepAddtime").Value

    set cmd = Nothing
    iSsnCon.Close
    SET iSsnCon = Nothing

    Dim iCookieDomain : iCookieDomain = "10x10.co.kr"
    IF application("Svr_Info")="Dev" THEN
        if (request.ServerVariables("LOCAL_ADDR")="::1") or (request.ServerVariables("LOCAL_ADDR")="127.0.0.1") then
            iCookieDomain = "localhost"
        end if
    End if

    if (intResult>0) then
        '' reSET dtauto DT
        response.Cookies("mssn").domain = iCookieDomain
        response.cookies("mssn")("dtauto") = inowSsnDt

        if (ssnkeepAddtime>0) and (CLNG(ssnkeepAddtime/(60*60*24))>0) then  ''원래 세팅한 값 만큼 추가로 지정해 준다.
            response.cookies("mssn").Expires = Date + CLNG(ssnkeepAddtime/(60*60*24))
        end if

        fnReSetSsnLoginDt = True
    end if
end function

'// 로그인쿠폰(마일리지) 지급
Function loginCouponInsert()
    dim iSsnCon, strSql
    set iSsnCon = CreateObject("ADODB.Connection")
    iSsnCon.Open Application(SSN_get_TEN_APP_CON_NAME)
    strSql = "EXEC db_user.dbo.USP_TEN_LOGINCOUPON_INSERT '"& session("ssnuserid") &"'"
    iSsnCon.Execute(strSql)
    iSsnCon.Close
    SET iSsnCon = Nothing
End Function
%>
