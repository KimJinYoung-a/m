<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/membercls/userloginclass.asp" -->
<!-- #include virtual="/lib/classes/membercls/clsMyAnniversary.asp" -->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
''사용안함 2018/08/13
1=a 

''캘린더 앱용 API // 박재석,서동석
CONST APPNAME = "calApp"
CONST MAXVALIDAPIVER = 1   ''API버전

function appLoginProc(iUid, iUPw)
    dim ouser
    if (iUid="" or iUPw="") then
		'// 잘못된 접근
		appLoginProc = getJsonMsg("9999","",-1)
	else
		set ouser = new CTenUser
		ouser.FRectUserID = iUid
		ouser.FRectAppPass = iUPw		'App용 Encript Pass
		ouser.LoginProc

		'로그인 처리
		if (ouser.IsPassOk) then
			'// 로그인 OK > 쿠키 처리
			response.Cookies("uinfo").domain = "10x10.co.kr"
			response.Cookies("uinfo")("muserid") = ouser.FOneUser.FUserID
			response.Cookies("uinfo")("musername") = ouser.FOneUser.FUserName
			response.Cookies("uinfo")("museremail") = ouser.FOneUser.FUserEmail
			response.Cookies("uinfo")("muserdiv") = ouser.FOneUser.FUserDiv
			response.cookies("uinfo")("muserlevel") = ouser.FOneUser.FUserLevel
		    response.cookies("uinfo")("mrealnamecheck") = ouser.FOneUser.FRealNameCheck
		    response.cookies("uinfo")("shix") = HashTenID(ouser.FOneUser.FUserID)		''201212 추가 로그인아이디 해시값

		    response.Cookies("etc").domain = "10x10.co.kr"
		    response.cookies("etc")("mcouponCnt") = ouser.FOneUser.FCouponCnt
		    response.cookies("etc")("mcurrentmile") = ouser.FOneUser.FCurrentMileage
		    response.cookies("etc")("cartCnt") = ouser.FOneUser.FBaguniCount
		    response.Cookies("etc")("musericon") = ouser.FOneUser.FUserIcon

			if (ouser.FOneUser.FUserDiv="02") or (ouser.FOneUser.FUserDiv="03") or (ouser.FOneUser.FUserDiv="04") or (ouser.FOneUser.FUserDiv="05") or (ouser.FOneUser.FUserDiv="06") or (ouser.FOneUser.FUserDiv="07") or (ouser.FOneUser.FUserDiv="08") or (ouser.FOneUser.FUserDiv="19") or (ouser.FOneUser.FUserDiv="20")   then
				response.Cookies("uinfo")("misupche") = "Y"
		    else
				response.Cookies("uinfo")("misupche") = "N"
			end if

			Call MLoginLogSave(iUid,"Y","app_cal","")
			set ouser = Nothing

			'// 로그인 OK
			appLoginProc = getJsonMsg("0000","",-1)

		elseif (ouser.IsRequireUsingSite) then
			set ouser = Nothing
		    '// 사이트 사용안함(텐바이텐)
		    appLoginProc = getJsonMsg("2001","",-1)
		elseif ouser.FConfirmUser="X" then
			set ouser = Nothing
		    '// 이용정지 회원
		    appLoginProc = getJsonMsg("2002","",-1)
		elseif ouser.FConfirmUser="N" then
			set ouser = Nothing
			'// 가입 승인대기
			appLoginProc = getJsonMsg("3001","",-1)
		else
		    '// 로그인 실패
		    Call MLoginLogSave(iUid,"N","app_cal","")
			set ouser = Nothing
			appLoginProc = getJsonMsg("1002","",-1)
		end if
	end if
end function

''현재 버전을 가져와서 체크.
function AppVersionCheck(clienttype,clientver)
    dim strSQL, currVer, minuUpVer
    dim iJsObj, iappid

    if (MAXVALIDAPIVER>ptcver) then
        AppVersionCheck = getJsonMsg("9001","",-1)
    	exit function
    end if

    ''2013/12/16추가
    strSQL = "insert into db_contents.dbo.tbl_app_comLog"& VBCRLF
    strSQL = strSQL & " (appName,clienttype,clientver,refip)"& VBCRLF
    strSQL = strSQL & " values('"&APPNAME&"'"& VBCRLF
    strSQL = strSQL & " ,'"&clienttype&"'"& VBCRLF
    strSQL = strSQL & " ,'"&clientver&"'"& VBCRLF
    strSQL = strSQL & " ,'"&Request.ServerVariables("REMOTE_ADDR")&"'"& VBCRLF
    strSQL = strSQL & " )"& VBCRLF
    dbget.Execute strSQL

    strSQL = " select top 1 * from db_contents.dbo.tbl_app_master"
    strSQL = strSQL & " where appName='"&APPNAME&"'"
    strSQL = strSQL & " and clienttype='"&clienttype&"'"
    rsget.open strSQL, dbget, 1
	If not rsget.EOF Then
		currVer    = rsget("currVer")
		minuUpVer  = rsget("minuUpVer")
	    iappid     = rsget("appid")
	End If
	rsget.close

    if (iappid="") then
        AppVersionCheck = getJsonMsg("9997","",-1)
    	exit function
    end if

    ''크리티컬 버전업
    if (CLNG(clientver)<CLNG(currVer)) and (CLNG(clientver)<CLNG(minuUpVer)) then
        set iJsObj= jsObject()
        iJsObj("appid") = iappid
        AppVersionCheck = getJsonMsg("9001",iJsObj,-1)
        exit function
    end if

    ''마이너 버전업
    if (CLNG(clientver)<CLNG(currVer)) then
        set iJsObj= jsObject()
        iJsObj("appid") = iappid
        AppVersionCheck = getJsonMsg("9002",iJsObj,-1)
        set iJsObj= nothing
        exit function
    end if
    AppVersionCheck = getJsonMsg("0000","",-1)
end function

function appColorlist(apptype, appver, resltype)
    dim sqlStr, i
    dim obj, iRecordCount : iRecordCount=0
    sqlStr = "select top 100 L.idx,L.colorCode,L.colorName,L.iconImageURL1,L.iconImageURL2"
    sqlStr = sqlStr&" ,L.color_str, L.word_rgbCode, C.colorName, C.colorIcon"
    sqlStr = sqlStr&" from db_contents.dbo.tbl_app_color_list L"
    sqlStr = sqlStr&" 	left join db_item.dbo.tbl_colorChips c"
    sqlStr = sqlStr&" 	on L.colorCode=C.colorCode"
    sqlStr = sqlStr&" where L.isusing='Y'"
    sqlStr = sqlStr&" order by L.sortno,(CASE WHEN L.colorCode>999 THEN L.colorCode*-1 ELSE L.colorCode END)"

    Set obj = jsObject()
    Set obj("colorlist") = jsArray()

    rsget.open sqlStr, dbget, 1
    i=0
	If not rsget.EOF Then
	    iRecordCount = rsget.RecordCount
		Do until rsget.EOF
		    set obj("colorlist")(i) = jsObject()
		    obj("colorlist")(i)("clidx")    = rsget("idx")
            obj("colorlist")(i)("clname")   = rsget("colorName")
            obj("colorlist")(i)("clrgb")    = rsget("color_str")
            obj("colorlist")(i)("txrgb")    = rsget("word_rgbCode")
            obj("colorlist")(i)("img1")     = rsget("iconImageURL1") ''"http://webimage.10x10.co.kr/color/colorchip/chip"&rsget("colorCode")&".gif"     ''임시
            obj("colorlist")(i)("img2")     = rsget("iconImageURL2")                                                                             ''임시
            obj("colorlist")(i)("linkurl")  = "http://m.10x10.co.kr/apps/appCom/cal/webview/color/coloritemlist.asp?colorcode="&rsget("colorCode")  ''임시

		    rsget.movenext
			i = i + 1
		loop
	End If
	rsget.close

    appColorlist = getJsonMsg("0000",obj,iRecordCount)
end function

function appDailylist(apptype, appver, resltype, stdt, eddt, clidx, userid)
    dim sqlStr, i
    dim obj, iRecordCount : iRecordCount=0

    sqlStr = "select top 1000 M.yyyymmdd,m.color_idx ,m.imageURL, m.imageURL2, L.colorCode, L.colorname"
    sqlStr = sqlStr&" ,(select count(*) from db_contents.dbo.tbl_app_color_detail d where yyyymmdd=m.yyyymmdd and isusing='Y') as itemCNT"
    sqlStr = sqlStr&" ,replace(replace(replace(convert(varchar(19),m.lastupdate,20),' ',''),':',''),'-','') as lastupdt"
    sqlStr = sqlStr&" ,Case WHEN isnull(K.islike,'') = 'Y' THEN 'true' else 'false' end as islike "
    sqlStr = sqlStr&" from db_contents.dbo.tbl_app_color_master M"
    sqlStr = sqlStr&"   left join db_contents.dbo.tbl_app_color_list L"
    sqlStr = sqlStr&"   on M.color_idx=L.idx"
	sqlStr = sqlStr&"   left join db_contents.dbo.tbl_app_color_like K "
	sqlStr = sqlStr&"   on K.userid = '"&userid&"' and K.yyyymmdd = replace(M.yyyymmdd, '-', '') and K.userid<>''"
    sqlStr = sqlStr&" where replace(M.yyyymmdd,'-','')>='"&stdt&"'"
    sqlStr = sqlStr&" and replace(M.yyyymmdd,'-','')<='"&eddt&"'"
    IF (clidx<>"") then
        sqlStr = sqlStr&" and M.color_idx="&clidx
    end if
    sqlStr = sqlStr&" order by M.yyyymmdd desc"

    Set obj = jsObject()
    Set obj("dailylist") = jsArray()

    rsget.open sqlStr, dbget, 1
    i=0
	If not rsget.EOF Then
	    iRecordCount = rsget.RecordCount
		Do until rsget.EOF
		    set obj("dailylist")(i) = jsObject()
		    obj("dailylist")(i)("cldate")     = replace(rsget("yyyymmdd"),"-","")
            obj("dailylist")(i)("clidx")      = rsget("color_idx")
            obj("dailylist")(i)("clname")      = rsget("colorname")
            obj("dailylist")(i)("islike")      = rsget("islike")
            If resltype = "1" Then
            	obj("dailylist")(i)("imgmain")    = rsget("imageURL2")
            Else
            	obj("dailylist")(i)("imgmain")    = rsget("imageURL")
            End If
            obj("dailylist")(i)("subcnt")     = rsget("itemCNT")                                                                 ''임시
            obj("dailylist")(i)("linkurl")    = "http://m.10x10.co.kr/apps/appCom/cal/webview/color/dailylist.asp?iccd="&rsget("colorCode")   ''임시
            obj("dailylist")(i)("lastupdate") = rsget("lastupdt")
		    rsget.movenext
			i = i + 1
		loop
	End If
	rsget.close

    appDailylist = getJsonMsg("0000",obj,iRecordCount)
end function

Function appDailyLikelist(apptype, appver, resltype, stdt, eddt, clidx, userid)
    dim sqlStr, i
    dim obj, iRecordCount : iRecordCount=0

    sqlStr = "select top 1000 M.yyyymmdd,m.color_idx ,m.imageURL, m.imageURL2, L.colorCode, L.colorname"
    sqlStr = sqlStr&" ,(select count(*) from db_contents.dbo.tbl_app_color_detail d where yyyymmdd=m.yyyymmdd and isusing='Y') as itemCNT"
    sqlStr = sqlStr&" ,replace(replace(replace(convert(varchar(19),m.lastupdate,20),' ',''),':',''),'-','') as lastupdt"
    sqlStr = sqlStr&" ,Case WHEN isnull(K.islike,'') = 'Y' THEN 'true' else 'false' end as islike "
    sqlStr = sqlStr&" from db_contents.dbo.tbl_app_color_master M"
    sqlStr = sqlStr&"   left join db_contents.dbo.tbl_app_color_list L"
    sqlStr = sqlStr&"   on M.color_idx=L.idx"
	sqlStr = sqlStr&"   join db_contents.dbo.tbl_app_color_like K "
	sqlStr = sqlStr&"   on K.userid = '"&userid&"' and K.yyyymmdd = replace(M.yyyymmdd, '-', '') and K.userid<>''"
    sqlStr = sqlStr&" where replace(M.yyyymmdd,'-','')>='"&stdt&"'"
    sqlStr = sqlStr&" and replace(M.yyyymmdd,'-','')<='"&eddt&"'"
    IF (clidx<>"") then
        sqlStr = sqlStr&" and M.color_idx="&clidx
    end if
    sqlStr = sqlStr&" order by M.yyyymmdd desc"

    Set obj = jsObject()
    Set obj("dailylist") = jsArray()

    rsget.open sqlStr, dbget, 1
    i=0
	If not rsget.EOF Then
	    iRecordCount = rsget.RecordCount
		Do until rsget.EOF
		    set obj("dailylist")(i) = jsObject()
		    obj("dailylist")(i)("cldate")     = replace(rsget("yyyymmdd"),"-","")
            obj("dailylist")(i)("clidx")      = rsget("color_idx")
            obj("dailylist")(i)("clname")      = rsget("colorname")
            obj("dailylist")(i)("islike")      = rsget("islike")
            If resltype = "1" Then
            	obj("dailylist")(i)("imgmain")    = rsget("imageURL2")
            Else
            	obj("dailylist")(i)("imgmain")    = rsget("imageURL")
            End If
            obj("dailylist")(i)("subcnt")     = rsget("itemCNT")                                                                 ''임시
            obj("dailylist")(i)("linkurl")    = "http://www.10x10.co.kr/award/bestaward_colorpalette.asp?iccd="&rsget("colorCode")   ''임시
            obj("dailylist")(i)("lastupdate") = rsget("lastupdt")
		    rsget.movenext
			i = i + 1
		loop
	End If
	rsget.close

    appDailyLikelist = getJsonMsg("0000",obj,iRecordCount)
end function

Function appDailyLike(cldate, likeval, userid)
	Dim sqlStr, i
	Dim obj, chkLike, islike
    If userid = "" Then
        appDailyLike = getJsonMsg("4001","",-1)
    	Exit Function
    End If

	If likeval <> "true" and likeval <> "false" Then
		appDailyLike = getJsonMsg("6003","",-1)
		Exit Function
	End If

	sqlStr = ""
	sqlStr = sqlStr & " SELECT COUNT(*) as CNT FROM db_contents.dbo.tbl_app_color_like "
	sqlStr = sqlStr & " WHERE yyyymmdd = '"&cldate&"' AND userid = '"&userid&"' "
	rsget.open sqlStr, dbget, 1
	If rsget("CNT") = 0 Then	'해당 날짜에 자신의 아이디가 없다면
		chkLike = "i"
	Else
		chkLike = "u"			'해당 날짜에 자신의 아이디가 있다면
	End If
	rsget.Close

	If likeval = "true" Then
		islike = "Y"			'넘어온 값이 true면 Y로
	Else
		islike = "N"			'넘어온 값이 false면 N으로
	End If

	If chkLike = "i" Then		'해당 날짜에 자신의 아이디가 없으니 인서트
		sqlStr = ""
		sqlStr = sqlStr & " INSERT INTO db_contents.dbo.tbl_app_color_like (yyyymmdd, userid, regdate, islike) VALUES "
		sqlStr = sqlStr & " ('"& cldate &"', '"& userid &"', getdate(), 'Y') "
		dbget.Execute sqlStr
	ElseIf chkLike = "u" Then	'해당 날짜에 자신의 아이디가 있으니 업데이트
		sqlStr = ""
		sqlStr = sqlStr & " UPDATE db_contents.dbo.tbl_app_color_like SET "
		sqlStr = sqlStr & " islike = '"&islike&"' "
		sqlStr = sqlStr & " WHERE yyyymmdd = '"& cldate &"' AND userid = '"&userid&"' "
		dbget.Execute sqlStr
	End If
	appDailyLike = getJsonMsg("0000","",-1)

End Function

Function appPushDevice(key, device, userid)
	Dim sqlStr, i
	Dim obj, appKey

    if (key="") or (device="") then
        appPushDevice = getJsonMsg("6002","",-1)
    	Exit Function
    end if

    If device <> "ios" and device <> "android" Then
		appPushDevice = getJsonMsg("6003","",-1)
		Exit Function
	End If

	appKey = getAppKey(device)
    If appKey = "" Then
        appPushDevice = getJsonMsg("6001","",-1)
    	Exit Function
    End If



	sqlStr = ""
	sqlStr = sqlStr & " IF NOT EXISTS(SELECT TOP 1 * FROM db_contents.dbo.tbl_app_regInfo WHERE appKey = '"&appKey&"' AND deviceid = '"&key&"') "
	sqlStr = sqlStr & " 	INSERT INTO db_contents.dbo.tbl_app_regInfo (appKey, deviceid, userid, regdate, isAlarm01, isAlarm02, isAlarm03, isAlarm04, isAlarm05) VALUES "
	sqlStr = sqlStr & " 	('"&appKey&"', '"&key&"', '"&userid&"', getdate(), 'Y', '', '', '', '') "
	sqlStr = sqlStr & " ELSE "
	sqlStr = sqlStr & " 	UPDATE db_contents.dbo.tbl_app_regInfo SET  "
	sqlStr = sqlStr & " 	lastUpdate = getdate() "
	If userid <> "" Then
		sqlStr = sqlStr & "	,userid = '"&userid&"' "
	End If
	sqlStr = sqlStr & " 	WHERE appKey = '"&appKey&"' AND deviceid = '"&key&"' "
	dbget.Execute sqlStr
	appPushDevice = getJsonMsg("0000","",-1)
End Function

Function rmvPushDevice(key, device, userid)
    Dim sqlStr, i
	Dim obj, appKey

    if (key="") or (device="") then
        rmvPushDevice = getJsonMsg("6002","",-1)
    	Exit Function
    end if

    If device <> "ios" and device <> "android" Then
		rmvPushDevice = getJsonMsg("6003","",-1)
		Exit Function
	End If

	appKey = getAppKey(device)
    If appKey = "" Then
        rmvPushDevice = getJsonMsg("6001","",-1)
    	Exit Function
    End If

    sqlStr = " 	UPDATE db_contents.dbo.tbl_app_regInfo SET  "
	sqlStr = sqlStr & " 	lastUpdate = getdate() "
	sqlStr = sqlStr & " 	,isAlarm01 = 'N'"
	If userid <> "" Then
		sqlStr = sqlStr & "	,userid = '"&userid&"' "
	End If
	sqlStr = sqlStr & " 	WHERE appKey = '"&appKey&"' AND deviceid = '"&key&"' "
	dbget.Execute sqlStr
	rmvPushDevice = getJsonMsg("0000","",-1)
End Function

Function getAppKey(device)
	Dim sqlStr, i
	sqlStr = ""
	sqlStr = " SELECT TOP 1 appKey FROM db_contents.dbo.tbl_app_master WHERE appname = 'calapp' AND clienttype = '"&device&"' "
	rsget.open sqlStr, dbget, 1
	If not rsget.EOF Then
		getAppKey = rsget("appKey")
	Else
		getAppKey = ""
	End If
	rsget.Close
End Function

Function appLoginCheck(apptype, userid)
    dim encedID
    if (userid<>"") then
        encedID = request.cookies("uinfo")("shix")      ''암호화된쿠키값.
        if (UCASE(HashTenID(userid))=UCASE(encedID)) then
            '' 정상인경우 / 쿠키 타임 연장이 필요한경우 이곳에서 연장
            appLoginCheck = getJsonMsg("0000","",-1)
        else
            appLoginCheck = getJsonMsg("1011","",-1) ''암호화 오류
        end if
    else
        appLoginCheck = getJsonMsg("1001","",-1)
    end if
end function

'// 메시지 출력
function getJsonMsg(sCd, iJsObj,resCnt)
	dim oData, sMsg, sMsgStr

	Select Case sCd
		Case "0000"
			sMsg = "s_ok"
			sMsgStr = ""
		Case "1001"
			sMsg = "s_fail"
			sMsgStr = ""
		Case "1011"
			sMsg = "s_fail"
			sMsgStr = ""
		Case "1002"
			sMsg = "s_fail"
			sMsgStr = "아이디 또는 패스워드가 올바르지 않습니다."
		Case "1003"
			sMsg = "s_fail"
			sMsgStr = "아이디 또는 패스워드가 올바르지 않습니다."
		Case "2001"
			sMsg = "s_fail"
			sMsgStr = "사용중지 회원입니다."
		Case "2002"
			sMsg = "s_fail"
			sMsgStr = "사용중지 회원입니다."
		Case "3001"
			sMsg = "s_fail"
			sMsgStr = "인증처리가 후에 사용하실 수 있습니다."
		Case "4001"
			sMsg = "s_fail"
			sMsgStr = "로그인 후에 사용하실 수 있습니다."
		Case "4002"
			sMsg = "s_fail"
			sMsgStr = "통신중 오류가 발생하였습니다."
		Case "6001"
			sMsg = "s_fail"
			sMsgStr = "통신중 오류가 발생하였습니다."
		Case "6002"
			sMsg = "s_fail"
			sMsgStr = "필수 파라메터 오류."
	    Case "6003"
			sMsg = "s_fail"
			sMsgStr = "파라메터 값이 잘못 되었습니다."

		Case "9001"
			sMsg = "s_update_frc"
			sMsgStr = "사용할 수 없는 버전입니다.\n업그레이드 후 사용해 주시기 바랍니다."
		Case "9002"
			sMsg = "s_update_req"
			sMsgStr = "새로운 버전으로 업그레이드 되었습니다.\n업그레이드 하시겠습니까?"
		Case "9900"
			sMsg = "s_fail"
			sMsgStr = "사용할 수 없는 통신 버전입니다."
		Case "9999"
			sMsg = "s_fail"
			sMsgStr = "통신중 오류가 발생하였습니다."
		Case Else
			sMsg = "s_fail"
			sMsgStr = "통신중 오류가 발생하였습니다."
	End Select

	Set oData = jsObject()
		oData("resCd")   = sMsg
		if (sMsgStr<>"") then
		    oData("resMsg")  = sMsgStr&"("&sCd&")"
		else
    		oData("resMsg")  = ""
    	end if

    	if isObject(iJsObj) then
    	    if (resCnt>-1) then
    	        oData("resCnt") = resCnt
    	    end if
            set oData("resData") = iJsObj
        end if

		getJsonMsg = oData.jsString
	Set oData = Nothing
end function



'//헤더 출력
Response.ContentType = "application/json"
''Response.ContentType = "application/x-www-form-urlencoded"
''Response.ContentType = "text/html"

'변수 선언
Dim sJSON : sJSON = ""
Dim sData : sData = Request.form("jsonData") ''Request("jsonData")
response.write  sData

Dim sType, sUid, sUPw, hashPw
Dim ptcver, appver, apptype, resltype, stdt, eddt, cldate, likeval, devicekey, clidx
Dim checkRet


'// 전송값 없음(err.01)
if sData="" then
	Response.Write getJsonMsg("9998","",-1)
	Response.End
end if

'// 전송결과 파징
'on Error Resume Next
dim oResult
dim userid
set oResult = JSON.parse(sData)
	sType = oResult.cmdtype
	userid = request.Cookies("uinfo")("muserid")
	Select Case sType
		Case "login"
		    on Error Resume Next
			ptcver = oResult.ptcver
			sUid = oResult.id
			sUPw = oResult.pwd
			on Error Goto 0
			sJSON = appLoginProc(sUid,sUPw)
		Case "ver"
		    'on Error Resume Next
			ptcver = oResult.ptcver
    	    appver = oResult.appver
            apptype = oResult.apptype
            'on Error Goto 0
            response.write apptype
            response.end
            sJSON = appVersionCheck(apptype, appver)
        Case "getcolorlist"
            on Error Resume Next
        	ptcver = oResult.ptcver
            appver = oResult.appver
            apptype = oResult.apptype
            resltype = oResult.resltype
            on Error Goto 0
            sJSON = appColorlist(apptype, appver, resltype)
        Case "getdailylist"
            on Error Resume Next
        	ptcver = oResult.ptcver
            appver = oResult.appver
            apptype = oResult.apptype
            resltype = oResult.resltype
            stdt = oResult.stdt
            eddt = oResult.eddt
            clidx = oResult.clidx
            on Error Goto 0
            sJSON = appDailylist(apptype, appver, resltype, stdt, eddt, clidx, userid)
		Case "setlikedate"
		    on Error Resume Next
		    ptcver = oResult.ptcver
    	    appver = oResult.appver
            apptype = oResult.apptype
			cldate = oResult.cldate
			likeval = oResult.likeval
			on Error Goto 0
			sJSON = appDailyLike(cldate, likeval, userid)
		Case "getlikelist"
			on Error Resume Next
        	ptcver = oResult.ptcver
            appver = oResult.appver
            apptype = oResult.apptype
            resltype = oResult.resltype
            stdt = oResult.stdt
            eddt = oResult.eddt
            clidx = oResult.clidx
            on Error Goto 0
            sJSON = appDailyLikelist(apptype, appver, resltype, stdt, eddt, clidx, userid)
		Case "regpushdevice"
		    on Error Resume Next
		    ptcver = oResult.ptcver
    	    appver = oResult.appver
            apptype = oResult.apptype
			devicekey = oResult.devicekey
			on Error Goto 0
			sJSON = appPushDevice(devicekey, apptype, userid)
		Case "rmvpushdevice"
		    on Error Resume Next
		    ptcver = oResult.ptcver
    	    appver = oResult.appver
            apptype = oResult.apptype
			devicekey = oResult.devicekey
			on Error Goto 0
			sJSON = rmvPushDevice(devicekey, apptype, userid)
		Case "lgchk"
		    on Error Resume Next
		    ptcver = oResult.ptcver
    	    appver = oResult.appver
            apptype = oResult.apptype
			on Error Goto 0

			sJSON = appLoginCheck(apptype, userid)
        Case ELSE
            sJSON = getJsonMsg("9999","",-1)
	End Select
set oResult = Nothing

IF (Err) then
	Response.Write getJsonMsg("9999","",-1)
	Response.End
end if


''------------------------------------------------------------------------

''On Error Goto 0

' UTF-8 문서 출력(JSON)
Response.Write sJSON


%>
<!-- #include virtual="/lib/db/dbclose.asp" -->