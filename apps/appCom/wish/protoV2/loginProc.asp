<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/util/tenSessionLib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/membercls/userloginclass.asp" -->
<!-- #include virtual="/lib/classes/membercls/clsMyAnniversary.asp" -->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
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
Dim snID

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
    if ((sAppKey="6") and (sVerCd>="66")) then  ''안드로이드 66버전부터 , ios 1.97 부터 nid 추가 //2015/08/07
	    if Not ERR THEN
    	    snID = requestCheckVar(oResult.nid,40)
    	    if ERR THEN Err.Clear ''nid 프로토콜 없음
	    END IF
	end if
	
set oResult = Nothing

if Len(sUPw)<32 then '' 0을 재끼는듯
    sUPw=format00(32,sUPw)
end if

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

elseif sType<>"login" then
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
	ouser.LoginProc

	Dim iCookieDomainName : iCookieDomainName = GetCookieDomainName
	'로그인 처리
	if (ouser.IsPassOk) then
		
		'// 로그인 OK > 쿠키 처리
		response.Cookies("uinfo").domain = iCookieDomainName
		'response.Cookies("uinfo")("muserid") = ouser.FOneUser.FUserID
		'response.Cookies("uinfo")("musername") = ouser.FOneUser.FUserName

'		response.Cookies("uinfo")("muserdiv") = ouser.FOneUser.FUserDiv
'		response.cookies("uinfo")("muserlevel") = ouser.FOneUser.FUserLevel
'	    response.cookies("uinfo")("mrealnamecheck") = ouser.FOneUser.FRealNameCheck
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
		
		'' 2018/08/18 TenSessionLib    ===============================
		ssnlogindt = fnDateTimeToLongTime(now())
		response.Cookies("mssn").domain = iCookieDomainName
		response.Cookies("mssn")("ssndt") = ssnlogindt 
		response.cookies("mssn")("shix") = HashTenID(ouser.FOneUser.FUserID)

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

		
		'// 회원 추가 정보
		Dim sqlStr, iNewFlw, iNewZBI, iMyIconID
		iNewFlw=0: iNewZBI=0 : iMyIconID=0

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
		
		'' sDeviceId가 없는 케이스가 있음..
		sqlStr = "update db_contents.dbo.tbl_app_regInfo " & vbCrLf
		sqlStr = sqlStr & " Set userid='" & sUid & "' " & vbCrLf
		sqlStr = sqlStr & "	,appVer='"&sVerCd&"'" & vbCrLf
		sqlStr = sqlStr & "	,lastUpdate=getdate() " & vbCrLf
		sqlStr = sqlStr & "	,lastact='lgn'" & vbCrLf
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
			oJson("faildesc") = "아이디와 비밀번호를 다시 확인해 주세요." & vbCrLf & "※ 10회 이상 입력 오류시 개인정보 보호를 위해 잠시 동안 로그인이 제한됩니다. (" & chkLoginFailCnt & "번 실패)"
		else
			oJson("response") = getErrMsg("9999",sFDesc)
			oJson("faildesc") = "10회 이상 입력 오류로 인해 잠시 동안 로그인이 제한되었습니다." & vbCrLf & "잠시 후 다시 로그인해주세요."
		end if

	end if

	set ouser = Nothing
end if

end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->