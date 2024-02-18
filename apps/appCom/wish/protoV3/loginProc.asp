<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/util/tenSessionLib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/membercls/userloginclass.asp" -->
<!-- #include virtual="/lib/classes/membercls/clsMyAnniversary.asp" -->
<!-- #include virtual="/lib/classes/cscenter/eventprizeCls.asp" -->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/util/jwtLib.asp" -->
<!-- #include virtual="/lib/util/logoneLib.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/loginProc.asp
' Discription : Wish APP 로그인 처리
' Request : json > type, id, password, pushid, OS, versioncode, versionname, verserion
' Response : response > 결과 및 쿠키생성
' History : 2013.12.13 허진원 : 신규 생성
'           2014.01.10 허진원 : 장바구니, 신규팔로워, 찜브랜드 신상품수 추가
'           2015.11.09 허진원 : 로그인 실패 로그 및 제한
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sFDesc
Dim sType, sUid, sUPw, sDeviceId, sJsonVer, hashPw, sOS, sVerCd
Dim sData : sData = Request("json")
Dim oJson
Dim AssignedRow, sAppKey
Dim snID, sTenToken, sKey, bTkVerify, sUserNo, sGubun

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sJsonVer = oResult.version
	sUid = requestCheckVar(oResult.id,32)
	sUPw = requestCheckVar(oResult.password,32)
	sDeviceId = requestCheckVar(oResult.pushid,256)
	sOS = requestCheckVar(oResult.OS,10)
	sVerCd = requestCheckVar(oResult.versioncode,20)

	'DeviceID 정보 업데이트
	sAppKey = getWishAppKey(sOS)

	''2015/08/07
    ''if ((sAppKey="6") and (sVerCd>="66")) then  ''안드로이드 66버전부터 , ios 1.97 부터 nid 추가 //2015/08/07  주석 V3부터
    if Not ERR THEN
		sUserNo = requestCheckVar(oResult.userno,64)
		sGubun = lCase(requestCheckVar(oResult.gubun,2))
	    snID = requestCheckVar(oResult.nid,40)
	    if ERR THEN Err.Clear ''파라메터가 없는 경우
    END IF

	''end if

set oResult = Nothing

if Len(sUPw)<32 and sUserNo="" and sGubun="" then '' 0을 재끼는듯
    sUPw=format00(32,sUPw)
end if

'// SNS 로그인 이라면 텐바이텐 인증토큰 확인
if Not(sUserNo="" and sGubun="") then
	'// HEADER 데이터 접수
	sTenToken = request.ServerVariables("HTTP_Authorization")
	if instr(lcase(sTenToken),"bearer ")>0 then
		sTenToken = right(sTenToken,len(sTenToken)-instr(sTenToken," "))
	else
		Set oJson = jsObject()
		oJson("response") = getErrMsg("9999",sFDesc)
		oJson("faildesc") = "잘못된 접근입니다.[E01]"
		oJson.flush
		Set oJson = Nothing
		response.End
	end if

	'=========================================================
	'// 토큰키 !!!
	sKey = "ThBxhdcEeCThSeJNSkJAwYRkbYSMkSwtELmScn"

	'// JWT 확인
	Dim jwt
	Set jwt = new cJwt
	bTkVerify = jwt.verify(sTenToken,sKey)
	Set jwt = Nothing

	if Not(bTkVerify) then
		Set oJson = jsObject()
		oJson("response") = getErrMsg("9999",sFDesc)
		oJson("faildesc") = "토큰 인증이 실패했습니다.[E02]"
		oJson.flush
		Set oJson = Nothing
		response.End
	end if
end if

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

elseif not(sType="login" or sType="pendinglogin") then
	'// 로그인 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."

elseif sUid="" then
	'// 잘못된 접근
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터 정보가 없습니다."

else
'    if (LCASE(sUid)="onlyyou2704") or (LCASE(sUid)="test001") or (LCASE(sUid)="lej4538") then
'        dim isql, ival
'        ival = "sUid:"&sUid&","&"sUPw:"&sUPw
'        isql = " insert into db_temp.dbo.tbl_temp_check_log"
'        isql = isql & " (val,refip)"
'        isql = isql & " values('"&html2db(ival)&"'"
'        isql = isql & " ,'"&Request.ServerVariables("REMOTE_ADDR")&"')"
'
'        dbget.Execute isql
'    end if


'##### 로그인 실패 제한 검사 (2015.10.28; 허진원)
Dim chkLoginFailCnt, ssnlogindt
chkLoginFailCnt = ChkLoginFailInfo(sUid, "Chk")
if chkLoginFailCnt>=10 then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "10회 이상 입력 오류로 인해 잠시 동안 로그인이 제한되었습니다." & vbCrLf & "잠시 후 다시 로그인해주세요."

else

	dim ouser
	set ouser = new CTenUser
	ouser.FRectUserID = sUid
	ouser.FRectAppPass = sUPw		'App용 Encript Pass

	ouser.FRectsns = sUserNo		'SNS 로그인 회원번호
	ouser.FRectsnsgb = sGubun		'SNS 구분

	ouser.LoginProc

	Dim iCookieDomainName : iCookieDomainName = GetCookieDomainName
	'로그인 처리
	if (ouser.IsPassOk) then
		'// 로그인 OK > 쿠키 처리
		response.Cookies("uinfo").domain = iCookieDomainName
		'response.Cookies("uinfo")("muserid") = ouser.FOneUser.FUserID
		'response.Cookies("uinfo")("musername") = ouser.FOneUser.FUserName
		'response.Cookies("uinfo")("muserdiv") = ouser.FOneUser.FUserDiv
		'response.cookies("uinfo")("muserlevel") = ouser.FOneUser.FUserLevel
	    'response.cookies("uinfo")("mrealnamecheck") = ouser.FOneUser.FRealNameCheck
	    response.cookies("uinfo")("shix") = HashTenID(ouser.FOneUser.FUserID)		''201212 추가 로그인아이디 해시값

	    response.Cookies("etc").domain = iCookieDomainName
	    response.cookies("etc")("mcouponCnt") = ouser.FOneUser.FCouponCnt
	    response.cookies("etc")("mcurrentmile") = ouser.FOneUser.FCurrentMileage
		response.cookies("etc")("currtencash") = ouser.FOneUser.FCurrentTenCash
		response.cookies("etc")("currtengiftcard") = ouser.FOneUser.FCurrentTenGiftCard
	    response.cookies("etc")("cartCnt") = ouser.FOneUser.FBaguniCount
	    response.Cookies("etc")("ordCnt") = ouser.FOneUser.ForderCount		'201409 추가 최근주문/배송수
	    response.Cookies("etc")("musericonNo") = ouser.FOneUser.FUserIconNo
	    response.Cookies("etc")("logindate") = now()


		'// appBoy CustomAttributes 데이터
		response.Cookies("appboy")("useq") = cStr(ouser.FOneUser.FUserSeq)
		'// 2018 회원등급 개편
		Select Case Trim(GetLoginUserLevel)
			Case "0"
				response.Cookies("appboy")("muserlevel") = "white"
			Case "1"
				response.Cookies("appboy")("muserlevel") = "red"
			Case "2"
				response.Cookies("appboy")("muserlevel") = "vip"
			Case "3"
				response.Cookies("appboy")("muserlevel") = "vipgold"
			Case "4"
				response.Cookies("appboy")("muserlevel") = "vvip"
			Case "5"
				response.Cookies("appboy")("muserlevel") = "white"
			Case "6"
				response.Cookies("appboy")("muserlevel") = "vvip"
			Case "7"
				response.Cookies("appboy")("muserlevel") = "staff"
			Case "8"
				response.Cookies("appboy")("muserlevel") = "family"
		End Select
		sqlstr = " Select top 1 "
		sqlstr = sqlstr & "	n.userid,  "
		sqlstr = sqlstr & "	case when convert(varchar(10), birthday, 120)='1900-01-01' then '' else convert(varchar(10), birthday, 120) end as dob, "
		sqlstr = sqlstr & "	case when n.sexflag in (1,3,5,7) then 'M' when n.sexflag in (2,4,6,8) then 'F' else '' end as gender,  "
		sqlstr = sqlstr & "	convert(varchar(33), regdate, 126)+'+09:00' as firstLogin, convert(varchar(33), l.lastlogin, 126)+'+09:00' as lastLogin,  "
		sqlstr = sqlstr & "	useq*3 as external_id,  "
		sqlstr = sqlstr & "	l.counter, "
		sqlstr = sqlstr & " n.connInfo ci, "
		sqlstr = sqlstr & " n.jumin1 jumin1, case when n.realnamecheck='Y' then 1 else 0 end realnamecheck,"
		sqlstr = sqlstr & " case when email_10x10='Y' then 1 else 0 end emailcheck,"
		sqlstr = sqlstr & " case when smsok='Y' then 1 else 0 end smscheck"		
		sqlstr = sqlstr & "	From db_user.dbo.tbl_user_n n "
		sqlstr = sqlstr & "	inner join db_user.dbo.tbl_logindata l on n.userid = l.userid "
		sqlstr = sqlstr & "	Where n.userid='"&LCase(ouser.FOneUser.FUserID)&"' "
		rsget.Open sqlstr, dbget, 1
		If Not(rsget.bof Or rsget.eof) Then
			''성인인증
			session("isAdult") = False
			Dim jumin1 :jumin1 = rsget("jumin1")
			Dim realNameCheck:realNameCheck = rsget("realnamecheck")
			If  realNameCheck = 1 And jumin1<>"" Then
				dim dtBirthDay : dtBirthDay = chkIIF(Left( jumin1,1)<>"0", "19"+left(jumin1,2), "20"+left(jumin1,2)) & "-" & mid(jumin1,3,2) & "-" & right(jumin1,2) & " 00:00:00"
				dtBirthDay = CDate(dtBirthDay)

				if datediff("m", dtBirthDay, now())/12 >= 18 then
					session("isAdult") = True
				end if
			end if
			response.Cookies("appboy")("dob") = rsget("dob")
			response.Cookies("appboy")("gender") = rsget("gender")
			response.Cookies("appboy")("mfirstLoginDate") = rsget("firstLogin")
			response.Cookies("appboy")("mlastLoginDate") = rsget("lastLogin")
			response.Cookies("appboy")("mloginCounter") = rsget("counter")
			response.Cookies("appboy")("memailCheck") = rsget("emailcheck")
			response.Cookies("appboy")("msmsCheck") = rsget("smscheck")			
		End If
		rsget.close

		'20140902추가 'GSShop WCS 관련
		'response.Cookies("wcs_uid").domain = iCookieDomainName
		'response.Cookies("wcs_uid") = HashTenID(ouser.FOneUser.FUserID)

		'// 테스터 후기 체크 쿠키
		Dim clsEvtPrize	: set clsEvtPrize  = new CEventPrize
			clsEvtPrize.FUserid = ouser.FOneUser.FUserID
			'Tester 당첨 여부.
			clsEvtPrize.fnGetTesterEventCheck
			if clsEvtPrize.FTotCnt>0 then
				response.Cookies("uinfo")("isTester") = true
			else
				response.Cookies("uinfo")("isTester") = false
			end if
		set clsEvtPrize = Nothing


		'// 회원 추가 정보
		Dim sqlStr, iNewFlw, iNewZBI, iMyIconID, isAdult
		iNewFlw=0: iNewZBI=0 : iMyIconID=0
		if session("isAdult") = True then
			isAdult = 1
		else
			isAdult = 0
		end if

        '' 2018/08/18 TenSessionLib    ===============================
		ssnlogindt = fnDateTimeToLongTime(now())
		response.Cookies("mssn").domain = iCookieDomainName
		response.Cookies("mssn")("ssndt") = ssnlogindt
		response.cookies("mssn")("shix") = HashTenID(ouser.FOneUser.FUserID)

        Call set_cookie_secure("CHKSESSION", Left(Now(), 10), "/", 24)

		session("ssnuserid")  = LCase(ouser.FOneUser.FUserID)
		session("ssnlogindt") = ssnlogindt
		session("ssnlastcheckdt") = ssnlogindt

		session("ssnusername") 	= ouser.FOneUser.FUserName
		session("ssnuserdiv") 	= ouser.FOneUser.FUserDiv
		session("ssnuserlevel")	= CStr(ouser.FOneUser.FUserLevel)
		session("ssnrealnamecheck")	= ouser.FOneUser.FRealNameCheck
		session("ssnuseremail")	= ouser.FOneUser.FUserEmail

		Dim isSSnLongKeep : isSSnLongKeep = 0  '' 값이 1이면 길게 유지
		Dim retSsnHash
		retSsnHash = fnDBSessionCreateV2("A",isSSnLongKeep)  ''2018/08/07
		response.Cookies("mssn")("ssnhash") = retSsnHash
		session("ssnhash") = retSsnHash
		'' ==========================================================

		'// WishApp 회원정보 생성
		sqlStr = "IF Not EXISTS(Select userid from db_contents.dbo.tbl_app_wish_userInfo where userid='" & sUid & "') " & vbCrLf
		sqlStr = sqlStr & "begin " & vbCrLf
		sqlStr = sqlStr & "	Insert Into db_contents.dbo.tbl_app_wish_userInfo (userid,nid) values ('" & sUid & "','"&snID&"') " & vbCrLf
		sqlStr = sqlStr & "end"
		dbget.Execute(sqlStr)

		'// 신규 팔로워수 접수
		sqlStr = "select count(*) cnt "
		sqlStr = sqlStr & "from db_contents.dbo.tbl_app_wish_followInfo as f "
		sqlStr = sqlStr & "	join db_contents.dbo.tbl_app_wish_userInfo as u "
		sqlStr = sqlStr & "		on f.followUid=u.userid "
		sqlStr = sqlStr & "			and u.userid='" & sUid & "'"
		sqlStr = sqlStr & "where f.regdate>u.lastlogin"
		sqlStr = sqlStr & "	and f.followUid='" & sUid & "'"
		rsget.Open sqlStr,dbget,1
			iNewFlw = rsget(0)
		rsget.Close

		'// 찜브랜드 신상품 수 // 불필요.
'		sqlStr = "select count(*) cnt "
'		sqlStr = sqlStr & "from db_my10x10.dbo.tbl_mybrand as z "
'		sqlStr = sqlStr & "	join db_item.dbo.tbl_item as i "
'		sqlStr = sqlStr & "		on z.userid=i.makerid "
'		sqlStr = sqlStr & "			and i.sellyn in ('Y') "
'		sqlStr = sqlStr & "			and datediff(d,i.regdate,getdate())<7 "
'		sqlStr = sqlStr & "where z.userid='" & sUid & "'"
'		rsget.Open sqlStr,dbget,1
'			iNewZBI = rsget(0)
'		rsget.Close
        iNewZBI = 0

        ''// my아이콘 이미지 번호
        iMyIconID = ouser.FOneUser.FUserIconNo
        if (iMyIconID=0) then
            iMyIconID = getDefaultProfileImgNo(ouser.FOneUser.FUserID) ''이부분 확인 필요
        end if

		'Login Log 기록
		Call MLoginLogSave(sUid,"Y","app_wsh",UCase(left(sOS,1)))

	    '###### 실패로그 정리
	    if chkLoginFailCnt>0 then Call ClearLoginFailInfo(sUid)

		'Wish Login 기록
		sqlStr = "Update db_contents.dbo.tbl_app_wish_userInfo " & vbCrLf
		sqlStr = sqlStr & "	Set lastLogin=getdate() " & vbCrLf
		sqlStr = sqlStr & "	,nid='"&snID&"'" & vbCrLf                           ''2015/08/07
		sqlStr = sqlStr & "	where userid='" & sUid & "' " & vbCrLf
		dbget.Execute(sqlStr)

		sqlStr = "update db_contents.dbo.tbl_app_regInfo " & vbCrLf
		sqlStr = sqlStr & " Set userid='" & sUid & "' " & vbCrLf
		sqlStr = sqlStr & "	,appVer='"&sVerCd&"'" & vbCrLf
		sqlStr = sqlStr & "	,lastUpdate=getdate() " & vbCrLf
		sqlStr = sqlStr & "	,lastact='lgn'" & vbCrLf
		sqlStr = sqlStr & "	,isusing='Y'" & vbCrLf							''2018/09/11
		sqlStr = sqlStr & " Where appKey='" & sAppKey & "' " & vbCrLf
		sqlStr = sqlStr & "	and deviceid='" & sDeviceId & "'"
		sqlStr = sqlStr & "	and ((isNULL(userid,'')<>'" & sUid & "') " & vbCrLf
		sqlStr = sqlStr & "	    or (appVer<>'"&sVerCd&"')" & vbCrLf
		sqlStr = sqlStr & "	) "
		dbget.Execute sqlStr,AssignedRow


'        ''2014/03/20 추가 //필요 없을듯 deviceProc.asp 추가됨 //주석 처리. 2015/08/07
'        if (sDeviceId<>"") and (AssignedRow<1) then
'            sqlStr = "IF NOT EXISTS(select regidx from db_contents.dbo.tbl_app_regInfo where appkey=" & sAppKey & " and deviceid='" & sDeviceId & "') " & vbCrLf
'			sqlStr = sqlStr & "begin " & vbCrLf
'			sqlStr = sqlStr & "	insert into db_contents.dbo.tbl_app_regInfo " & vbCrLf
'			sqlStr = sqlStr & "		(appKey,deviceid,userid,regdate,appVer,lastact,isAlarm01,isAlarm02,isAlarm03,isAlarm04,isAlarm05,regrefip) values " & vbCrLf
'			sqlStr = sqlStr & "	(" & sAppKey			'앱고유Key
'			sqlStr = sqlStr & ",'" & sDeviceId & "'"	'접속기기 DeviceID
'			sqlStr = sqlStr & ",'" & sUid & "'"	        'UserID
'			sqlStr = sqlStr & ",getdate()"				'최초접속 일시
'			sqlStr = sqlStr & ",'"&sVerCd&"'"			'버전                       ''/2014/03/21
'			sqlStr = sqlStr & ",'lgg'"                  '' 최종액션구분
'			sqlStr = sqlStr & ",'Y'"					'위시메이트 알림 여부
'			sqlStr = sqlStr & ",'Y'"					'구매정보 알림 여부
'			sqlStr = sqlStr & ",'Y'"					'이벤트 및 혜택 알림 여부
'			sqlStr = sqlStr & ",'N','N','"&Request.ServerVariables("REMOTE_ADDR")&"') " & vbCrLf
'			sqlStr = sqlStr & "end"
'			dbget.Execute(sqlStr)
'        end if

		''모웹 일반 로그인, SNS 로그인 2019년10월 18주년 상품쿠폰 지급
		If application("Svr_Info")="Dev" Then
			If date() > "2019-09-25" AND date() < "2019-10-01" Then
				Call fnSetItemCouponDown(getLoginUserid(), 22174)
				Call fnSetItemCouponDown(getLoginUserid(), 22173)
				Call fnSetItemCouponDown(getLoginUserid(), 22171)
			End IF
		Else
			If date() > "2019-09-30" AND date() < "2019-11-01" Then
				Call fnSetItemCouponDown(getLoginUserid(), 56078)
				Call fnSetItemCouponDown(getLoginUserid(), 56079)
				Call fnSetItemCouponDown(getLoginUserid(), 56080)
				Call fnSetItemCouponDown(getLoginUserid(), 56081)
				Call fnSetItemCouponDown(getLoginUserid(), 56082)
				Call fnSetItemCouponDown(getLoginUserid(), 56083)
			End IF
		End IF

		' 2019-02-26 프로모션쿠폰
		Dim couponSqlStr

		couponSqlStr = "EXEC db_user.dbo.USP_TEN_LOGINCOUPON_INSERT '"& ouser.FOneUser.FUserID &"'"
		dbget.Execute couponSqlStr, 1

        ''2015/08/07 추가
        if (snID<>"") then
            sqlStr = "update db_contents.dbo.tbl_app_NidInfo " & vbCrLf
		    sqlStr = sqlStr & " Set lastUserid='" & sUid & "' " & vbCrLf
		    sqlStr = sqlStr & " where Nid='"&snID&"'"
		    dbget.Execute sqlStr
        end if

		'// 로그인 OK
		oJson("response") = getErrMsg("1000",sFDesc)
		oJson("cart") = cStr(ouser.FOneUser.FBaguniCount)
		oJson("newfollower") = cStr(iNewFlw)
		oJson("newproductzzim") = cStr(iNewZBI)
        oJson("myiconid")   = cStr(iMyIconID)                                ''protocol V2 추가
        oJson("ulevelstr")  = UCASE(replace(GetUserStrlarge(ouser.FOneUser.FUserLevel)," ","")) ''protocol V2 추가
        oJson("ucouponcnt") = cStr(ouser.FOneUser.FCouponCnt)                ''protocol V2 추가
        oJson("umile")      = cStr( ouser.FOneUser.FCurrentMileage)          ''protocol V2 추가
        oJson("recentordercnt")      = cStr(ouser.FOneUser.ForderCount)      ''protocol V2 추가 //2014/09/24
        oJson("userid")      = cStr(ouser.FOneUser.FUserID)                  ''protocol V2 추가 //2014/09/25
        oJson("userseq")      = cStr(ouser.FOneUser.FUserSeq)                  ''protocol V3 추가 //2017/07/14
		oJson("isAdult")      = cStr(isAdult)						         ''protocol V3 추가 //2019/03/15

		'// Amplitude UserCustomAttributes 값 전송
		Set oJson("amplitudeCustomUserInfo") = jsObject()
		oJson("amplitudeCustomUserInfo")("basketCount") = ouser.FOneUser.FBaguniCount
		oJson("amplitudeCustomUserInfo")("firstLoginDate") = CStr(Replace(Replace(request.Cookies("appboy")("mfirstLoginDate"), "T", " "), "+09:00", ""))
		oJson("amplitudeCustomUserInfo")("lastLoginDate") = CStr(Replace(Replace(request.Cookies("appboy")("mlastLoginDate"), "T", " "), "+09:00", ""))
		oJson("amplitudeCustomUserInfo")("loginCount") = request.cookies("appboy")("mloginCounter")
		oJson("amplitudeCustomUserInfo")("orderCount3Week") = request.cookies("etc")("ordCnt")
		oJson("amplitudeCustomUserInfo")("tenCash") = request.cookies("etc")("currtencash")
		oJson("amplitudeCustomUserInfo")("tenCouponCnt") = request.cookies("etc")("mcouponCnt")
		oJson("amplitudeCustomUserInfo")("tenGiftCard") = request.cookies("etc")("currtengiftcard")
		oJson("amplitudeCustomUserInfo")("tenMileage") = request.cookies("etc")("mcurrentmile")
		oJson("amplitudeCustomUserInfo")("userlevel") = UCASE(replace(GetUserStrlarge(ouser.FOneUser.FUserLevel)," ",""))
		oJson("amplitudeCustomUserInfo")("recentordercnt") = cStr(ouser.FOneUser.ForderCount)

		If Trim(request.Cookies("appboy")("gender")) <> "" Then
			oJson("amplitudeCustomUserInfo")("gender") = CStr(Replace(Replace(request.Cookies("appboy")("gender"), "M", "male"), "F", "female"))
		End If

		If Trim(request.Cookies("appboy")("dob")) <> "" Then
			oJson("amplitudeCustomUserInfo")("age") = CStr(( left(now(), 4) - left(Trim( request.Cookies("appboy")("dob") ),4) )+1)
		End If

		If Trim(request.Cookies("appboy")("memailCheck")) <> "" Then
			oJson("amplitudeCustomUserInfo")("email_yn") = CInt(request.Cookies("appboy")("memailCheck"))
		Else
			oJson("amplitudeCustomUserInfo")("email_yn") = 0		
		End If

		If Trim(request.Cookies("appboy")("msmsCheck")) <> "" Then
			oJson("amplitudeCustomUserInfo")("sms_yn") = CInt(request.Cookies("appboy")("msmsCheck"))
		Else
			oJson("amplitudeCustomUserInfo")("sms_yn") = 0
		End If

		'// AppBoy(Braze) UserInfo 값 전송
		Set oJson("appboyUserInfo") = jsObject()
		oJson("appboyUserInfo")("dateOfBirth") = CStr(request.Cookies("appboy")("dob"))
		oJson("appboyUserInfo")("gender") = CStr(request.Cookies("appboy")("gender"))

		'// AppBoy(Braze) CustomUserinfo 값 전송
		Set oJson("appboyCustomUserInfo") = jsObject()
		oJson("appboyCustomUserInfo")("basketCount") = ouser.FOneUser.FBaguniCount
		oJson("appboyCustomUserInfo")("firstLoginDate") = CStr(Replace(Replace(request.Cookies("appboy")("mfirstLoginDate"), "T", " "), "+09:00", ""))
		oJson("appboyCustomUserInfo")("lastLoginDate") = CStr(Replace(Replace(request.Cookies("appboy")("mlastLoginDate"), "T", " "), "+09:00", ""))
		oJson("appboyCustomUserInfo")("loginCount") = request.cookies("appboy")("mloginCounter")
		oJson("appboyCustomUserInfo")("orderCount3Week") = request.cookies("etc")("ordCnt")
		oJson("appboyCustomUserInfo")("tenCash") = request.cookies("etc")("currtencash")
		oJson("appboyCustomUserInfo")("tenCouponCnt") = request.cookies("etc")("mcouponCnt")
		oJson("appboyCustomUserInfo")("tenGiftCard") = request.cookies("etc")("currtengiftcard")
		oJson("appboyCustomUserInfo")("tenMileage") = request.cookies("etc")("mcurrentmile")
		oJson("appboyCustomUserInfo")("userlevel") = UCASE(replace(GetUserStrlarge(ouser.FOneUser.FUserLevel)," ",""))
		oJson("appboyCustomUserInfo")("recentordercnt") = cStr(ouser.FOneUser.ForderCount)

		'// AppBoy(Braze) CustomUserInfo 배열값
'		Dim appboyArrayValue(1)
'		Set oJson("appboyCustomUserInfo")("array") = jsObject()
'		oJson("appboyCustomUserInfo")("array")("array_name") = "testArray1"
'		oJson("appboyCustomUserInfo")("array")("action") = "set"
'		oJson("appboyCustomUserInfo")("array")("value") = split("""V1"",""V2"",""V3"",""V4""",",")
'		Set appboyArrayValue(0) = oJson("appboyCustomUserInfo")("array")

'		Set oJson("appboyCustomUserInfo")("array") = jsObject()
'		oJson("appboyCustomUserInfo")("array")("array_name") = "testArray2"
'		oJson("appboyCustomUserInfo")("array")("action") = "set"
'		oJson("appboyCustomUserInfo")("array")("value") = split("""V1"",""V2"",""V3"",""V4""",",")
'		Set appboyArrayValue(1) = oJson("appboyCustomUserInfo")("array")

'		oJson("appboyCustomUserInfo")("array") = appboyArrayValue

		'로그원 로그인데이터 전송
		Call sendLogoneLoginUser(cStr(ouser.FOneUser.FUserSeq))


	elseif (ouser.IsRequireUsingSite) then
	    '// 사이트 사용안함(텐바이텐)
	    oJson("response") = getErrMsg("2201",sFDesc)
	    oJson("faildesc") = sFDesc

	elseif ouser.FConfirmUser="X" then
	    '// 이용정지 회원
	    oJson("response") = getErrMsg("2202",sFDesc)
	    oJson("faildesc") = sFDesc

	elseif ouser.FConfirmUser="N" then
		'// 가입 승인대기
		oJson("response") = getErrMsg("2301",sFDesc)
		oJson("rdurl")    = "http://m.10x10.co.kr/apps/appcom/wish/web2014/member/join_step3.asp?uid="&tenEnc(sUid)
		oJson("faildesc") = sFDesc

	elseif ouser.FConfirmUser="0" then
		'// 회원 정보 없음(아이디 없음)
		oJson("response") = getErrMsg("2103",sFDesc)
		oJson("faildesc") = sFDesc
	else

	    '// 로그인 실패
	    Call MLoginLogSave(sUid,"N","app_wsh",UCase(left(sOS,1)))

	    '## 로그인 실패정보 저장 (2015.10.28; 허진원)
	    chkLoginFailCnt = ChkLoginFailInfo(sUid, "Add")

		''oJson("response") = getErrMsg("2102",sFDesc)
		''oJson("faildesc") = sFDesc

		if chkLoginFailCnt<10 then
			oJson("response") = getErrMsg("9999",sFDesc)
			oJson("faildesc") = "텐바이텐 회원이 아니시거나, 아이디 또는 비밀번호를 잘못 입력하셨습니다." & vbCrLf & "※ 10회 이상 입력 오류시 개인정보 보호를 위해 잠시 동안 로그인이 제한됩니다. (" & chkLoginFailCnt & "번 실패)"
		else
			oJson("response") = getErrMsg("9999",sFDesc)
			oJson("faildesc") = "10회 이상 입력 오류로 인해 잠시 동안 로그인이 제한되었습니다." & vbCrLf & "잠시 후 다시 로그인해주세요."
		end if

	end if

	set ouser = Nothing
end if

end if

'## 상품쿠폰 다운 함수
Function fnSetItemCouponDown(ByVal userid, ByVal idx)
	dim sqlStr
	Dim objCmd
	Set objCmd = Server.CreateObject("ADODB.COMMAND")
	With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "{?= call [db_item].[dbo].sp_Ten_itemcoupon_down("&idx&",'"&userid&"')}"
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With
		fnSetItemCouponDown = objCmd(0).Value
	Set objCmd = Nothing
END Function

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
