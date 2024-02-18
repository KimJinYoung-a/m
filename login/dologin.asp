<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/util/tenSessionLib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbEVTopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/memberlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/classes/membercls/userloginclass.asp" -->
<!-- #include virtual="/lib/classes/membercls/clsMyAnniversary.asp" -->
<!-- #include virtual="/lib/classes/cscenter/eventprizeCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/incNaverOpenDate.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/incDaumOpenDate.asp" -->
<script type="text/javascript">
<!--
    function jsReloadSSL(isOpen, strPath,blnclose){
        var replacePath =  "<%=wwwUrl%>/login/popSSLreload.asp?isOpen=" + isOpen + "&strPath=" + strPath+"&blnclose="+blnclose;
        location.replace(replacePath);
    }
//-->
</script>

<%
dim ouser
dim userid, userpass, backpath
dim strGetData, strPostData
dim isupche
dim isopenerreload,blnclose
dim snsisusing, snsid, snsgubun, snsusermail, snslogin, snsjoingubun, sns_sexflag

'sns 회원가입 추가 정보-유태욱2017-05-29
snsisusing 	= requestCheckVar(request("snsisusing"),1)
snsid			= requestCheckVar(Request("snsid"),64)
snsgubun		= requestCheckVar(Request("snsgubun"),2)
snsusermail	= requestCheckVar(Request("snsusermail"),128)
tokenval		= html2db(request("tokenval"))
snslogin		= URLDecodeUTF8( html2db(request("snslogin")))
blnclose		= requestCheckVar(Request("blnclose"),2)
snsjoingubun		= requestCheckVar(Request("snsjoingubun"),2)
sns_sexflag	= requestCheckVar(Request("sns_sexflag"),7)

userid 		= requestCheckVar(request("userid"),32)
userpass 	= requestCheckVar(request("userpass"),32)

isopenerreload= request("isopenerreload")
backpath 		= ReplaceRequestSpecialChar(request("backpath"))
strGetData  	= ReplaceRequestSpecialChar(request("strGD"))
strPostData 	= ReplaceRequestSpecialChar(request("strPD"))

if strGetData <> "" then backpath = backpath&"?"&strGetData
if backpath =""  then blnclose ="Y"

dim referer, ssnlogindt
referer = request.ServerVariables("HTTP_REFERER")

'##### 로그인 실패 제한 검사 (2015.10.28; 허진원)
Dim chkLoginFailCnt, chkCaptcha
chkLoginFailCnt = ChkLoginFailInfo(userid, "Chk")
if chkLoginFailCnt>=10 then
	chkCaptcha = false
	'// Captcha 입력 결과 확인
	if Request.form("g-recaptcha-response")<>"" then
	    Dim recaptcha_secret, sendstring, objXML
	    ' Secret key
	    recaptcha_secret = "6LdSrA8TAAAAADL9MqgEGSBRy51FXxVT0Pifr1l7"
	    sendstring = "https://www.google.com/recaptcha/api/siteverify?secret=" & recaptcha_secret & "&response=" & Request.form("g-recaptcha-response")

	    Set objXML = Server.CreateObject("MSXML2.ServerXMLHTTP")
	    objXML.Open "GET", sendstring, False
	    objXML.Send

	    if inStr(objXML.responseText,"""success"": true")>0 then chkCaptcha = true

	    Set objXML = Nothing
	end if
	'Captcha 입력 결과 확인 끝 //

    session("chkLoginLock")=true
    if Not(chkCaptcha) then
	    response.write "<script type='text/javascript'>" &_
	    				"alert('10회 이상 입력 오류로 인해 잠시 동안 로그인이 제한되었습니다.\n잠시 후 다시 로그인해주세요.');" &_
	    				"location.replace('" & referer & chkIIF(instr(referer,"backpath")>0,"","&backpath=" & server.URLEncode(backpath)) & "');" &_
	    				"</script>"
	    dbget.Close(): response.End
	end if
end if

set ouser = new CTenUser
ouser.FRectUserID = userid
ouser.FRectPassWord = userpass

ouser.FRectsns = snsid
ouser.FRectsnsgb = snsgubun

ouser.LoginProc

if (ouser.IsPassOk) then

	'이건 나중에 위쪽으로
'	if InStr(referer,"10x10.co.kr")<1 then
'		Response.Write "Err|잘못된 접속입니다."
'		dbget.close() : Response.End
'	end If

	'2017 sns 로그인 유태욱
	dim sqlstr, snscnt, sqlStrtoken, tokenval, tokencnt, snsgubunname, snsmycnt

	if snsgubun = "nv" then
		snsgubunname = "네이버"
	elseif snsgubun = "fb" then
		snsgubunname = "페이스북"
	elseif snsgubun = "ka" then
		snsgubunname = "카카오"
	elseif snsgubun = "gl" then
		snsgubunname = "구글"
	end if

	if snsisusing="Y" and snsid<>"" and snsgubun<>"" then
		'sns로그인시 전달받은 userid가 없는 경우가 있음> sns로그인에서 매칭된 값으로 할당
		if userid="" then userid=ouser.FOneUser.FUserID

		'// 토큰값 맞는지 확인
		sqlStrtoken = "Select count(*) From [db_user].[dbo].tbl_user_sns_token Where snsid='" & snsid & "' and snsgubun = '" & snsgubun & "' and snstoken = '" & tokenval & "' "
		rsget.Open sqlStrtoken,dbget,1
		IF Not rsget.Eof Then
			tokencnt = rsget(0)
		End IF
		rsget.close

		if tokencnt < 1 Then
	        response.write "<script>alert('SNS인증을 다시 시도해 주세요.')</script>"
	        response.write "<script>history.back()</script>"
	        response.end
		end if

		if snslogin = "" then
			sqlstr = ""
'			sqlstr = "select count(*) From [db_user].[dbo].[tbl_user_sns] Where tenbytenid='"& userid &"' And snsgubun='"& snsgubun &"' And isusing='Y' "		'and snsid="& snsid &"
			sqlstr = "select count(*) From [db_user].[dbo].[tbl_user_sns] Where snsid='"& snsid &"' And snsgubun='"& snsgubun &"' And isusing='Y' "	'and 	tenbytenid='"& userid &"'
			rsget.Open sqlstr, dbget, 1
				snscnt = rsget(0)
			rsget.close

			if snscnt > 0 then
			    response.write "<script type='text/javascript'>" &_
			    				"alert('이미 다른 텐바이텐 아이디와 연동된 "&snsgubunname&" 계정입니다.'); history.back();" &_
			    				"</script>"
			    dbget.Close(): response.End
			else
				sqlstr = "select count(*) From [db_user].[dbo].[tbl_user_sns] Where tenbytenid='"& userid &"' And snsgubun='"& snsgubun &"' And isusing='Y' "	'and snsid="& snsid &"
				rsget.Open sqlstr, dbget, 1
					snsmycnt = rsget(0)
				rsget.close

				if snsmycnt > 0 then
				    response.write "<script type='text/javascript'>" &_
				    				"alert('이미 다른 "&snsgubunname&" 계정과 연동된 아이디입니다.'); history.back();" &_
				    				"</script>"
				    dbget.Close(): response.End
				else
					sqlstr = ""
					sqlstr = "insert into [db_user].[dbo].[tbl_user_sns]  (snsgubun, tenbytenid, snsid, usermail, sexflag, isusing ) values " & vbCrlf
					sqlstr = sqlstr & " ( '"& snsgubun &"' " & vbCrlf
					sqlstr = sqlstr & " , '"& userid &"' " & vbCrlf
					sqlstr = sqlstr & " , '"& snsid & "' " & vbCrlf
					sqlstr = sqlstr & " , '"& snsusermail &"' " & vbCrlf
					sqlstr = sqlstr & " , '"& sns_sexflag &"' " & vbCrlf
					sqlstr = sqlstr & " , 'Y') " & vbCrlf
					dbget.Execute(sqlStr)

					if snsjoingubun = "ji" then
						backpath = ""
					end if
					response.write "<script type='text/javascript'>" &_
									"alert('계정 연결이 완료되었습니다');" &_
									"</script>"
				end if
			end if
		end if
	end if

	Dim iCookieDomainName : iCookieDomainName = GetCookieDomainName

	response.Cookies("uinfo").domain = iCookieDomainName
	response.cookies("uinfo")("shix") = HashTenID(ouser.FOneUser.FUserID)

	''아래는 오픈시 주석처리.
'	response.Cookies("uinfo")("muserid") = ouser.FOneUser.FUserID
'	response.Cookies("uinfo")("musername") = ouser.FOneUser.FUserName
'	response.Cookies("uinfo")("muserdiv") = ouser.FOneUser.FUserDiv
'	response.cookies("uinfo")("muserlevel") = ouser.FOneUser.FUserLevel
'    response.cookies("uinfo")("mrealnamecheck") = ouser.FOneUser.FRealNameCheck
    ''201212 추가 로그인아이디 해시값

    response.Cookies("etc").domain = iCookieDomainName
    response.cookies("etc")("mcouponCnt") = ouser.FOneUser.FCouponCnt
    response.cookies("etc")("mcurrentmile") = ouser.FOneUser.FCurrentMileage
	response.cookies("etc")("currtencash") = ouser.FOneUser.FCurrentTenCash
	response.cookies("etc")("currtengiftcard") = ouser.FOneUser.FCurrentTenGiftCard
    response.cookies("etc")("cartCnt") = ouser.FOneUser.FBaguniCount
    response.Cookies("etc")("ordCnt") = ouser.FOneUser.ForderCount		'201409 추가 최근주문/배송수
    response.Cookies("etc")("musericonNo") = ouser.FOneUser.FUserIconNo
    response.Cookies("etc")("logindate") = now()

    ''자동 로그인 저장 '' 세션 변경후에는 더이상 쓰지 말자.
'    response.Cookies("mSave").domain = iCookieDomainName
'    response.cookies("mSave").Expires = Date + 30	'1개월간 쿠키 저장
'    If request("saved_auto") = "o" Then
'    	response.cookies("mSave")("SAVED_AUTO") = "O"
'    	response.cookies("mSave")("SAVED_ID") = tenEnc(userid)
'    	response.cookies("mSave")("SAVED_PW") = tenEnc(userpass)
'    Else
'    	response.cookies("mSave")("SAVED_AUTO") = ""
'    	response.cookies("mSave")("SAVED_ID") = ""
'    	response.cookies("mSave")("SAVED_PW") = ""
'    End If


	'// appBoy관련데이터 추가-원승현(2017-11-07)
	'// 2018 회원등급 개편
	session("appboySession") = ouser.FOneUser.FUserSeq
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
	sqlstr = sqlstr & "	case when lastpushyn='Y' then 'opted_in' when lastpushyn='N' then 'unsubscribed' else 'subscribed' end as push_subscribe,  "
	sqlstr = sqlstr & "	case when lastpushyn='Y' then convert(varchar(33), lastpushynDate, 126)+'+09:00' else '' end as push_opted_in_at, l.counter, "
	sqlstr = sqlstr & " n.connInfo ci,"
	sqlstr = sqlstr & " n.jumin1 jumin1, case when n.realnamecheck='Y' then 1 else 0 end realnamecheck,"
	sqlstr = sqlstr & " case when email_10x10='Y' then 1 else 0 end emailcheck,"
	sqlstr = sqlstr & " case when smsok='Y' then 1 else 0 end smscheck"
	sqlstr = sqlstr & "	From db_user.dbo.tbl_user_n n "
	sqlstr = sqlstr & "	inner join db_user.dbo.tbl_logindata l on n.userid = l.userid "
	sqlstr = sqlstr & "	left join db_contents.dbo.tbl_app_wish_userinfo u on n.userid = u.userid "
	sqlstr = sqlstr & "	Where n.userid='"&LCase(ouser.FOneUser.FUserID)&"' "
	rsget.Open sqlstr, dbget, 1
	If Not(rsget.bof Or rsget.eof) Then
	''성인인증
		session("isAdult") = False
		Dim jumin1 :jumin1 = rsget("jumin1")
		If  rsget("realnamecheck") = 1 And jumin1<>"" Then
			dim dtBirthDay : dtBirthDay = chkIIF(Left( jumin1,1)<>"0", "19"+left(jumin1,2), "20"+left(jumin1,2)) & "-" & mid(jumin1,3,2) & "-" & right(jumin1,2) & " 00:00:00"
			dtBirthDay = CDate(dtBirthDay)

			if datediff("m", dtBirthDay, now())/12 >= 18 then
				session("isAdult") = True
			end if
		end if

		session("appboyDob") = rsget("dob")
		session("appboyGender") = rsget("gender")
		session("appboyUseq") = rsget("external_id")
		response.Cookies("appboy")("mfirstLoginDate") = rsget("firstLogin")
		response.Cookies("appboy")("mlastLoginDate") = rsget("lastLogin")
		response.Cookies("appboy")("mpushSubscribe") = rsget("push_subscribe")
		response.Cookies("appboy")("mpushOptedInAt") = rsget("push_opted_in_at")
		response.Cookies("appboy")("mloginCounter") = rsget("counter")
		response.Cookies("appboy")("memailCheck") = rsget("emailcheck")
		response.Cookies("appboy")("msmsCheck") = rsget("smscheck")

	End If
	rsget.close

	'' 2018/08/15 TenSessionLib    ===============================
	ssnlogindt = fnDateTimeToLongTime(now())
	response.Cookies("mssn").domain = iCookieDomainName
    response.Cookies("mssn")("ssndt") = ssnlogindt
    response.cookies("mssn")("shix") = HashTenID(ouser.FOneUser.FUserID) '' 불필요.

    Call set_cookie_secure("CHKSESSION", Left(Now(), 10), "/", 24)

	session("ssnuserid")  = LCase(ouser.FOneUser.FUserID)
    session("ssnlogindt") = ssnlogindt
    session("ssnlastcheckdt") = ssnlogindt

	session("ssnusername") 	= ouser.FOneUser.FUserName
	session("ssnuserdiv") 	= ouser.FOneUser.FUserDiv
	session("ssnuserlevel")	= CStr(ouser.FOneUser.FUserLevel)
	session("ssnrealnamecheck")	= ouser.FOneUser.FRealNameCheck
	session("ssnuseremail")	= ouser.FOneUser.FUserEmail
	session("ssnuserbizconfirm") = ouser.FOneUser.FBizConfirm

	Dim isSSnLongKeep : isSSnLongKeep = 0  '' 값이 1이면 길게 유지
    Dim retSsnHash
	if (request("saved_auto") = "o") then isSSnLongKeep=1

	retSsnHash = fnDBSessionCreateV2("M",isSSnLongKeep)  ''2018/08/07
	if (isSSnLongKeep>0) then
		response.cookies("mssn").Expires = Date + 15
		response.Cookies("mssn")("dtauto") = ssnlogindt					''2018/08/19
	end if
	response.Cookies("mssn")("ssnhash") = retSsnHash
	session("ssnhash") = retSsnHash
	'' ============================================================

    '####### 로그인 로그 저장
    Call MLoginLogSave(userid,"Y","ten_m",flgDevice)

    '###### 실패로그 정리
    if chkLoginFailCnt>0 then Call ClearLoginFailInfo(userid)
    Session.Contents.Remove("chkLoginLock")		'계정중지 리셋

    '####### 쇼핑톡 나의글에 새의견이 있는지 체크. 있으면 쿠키에 담음. ("uinfo")("isnewcomm")
    Call CheckMyTalkNewComm(userid)

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

	'// 첫구매자 you이벤트 관련(79281)
	Dim FirstUserYouEvtChk
	sqlstr = "select count(userid) From [db_EVT].[dbo].[tbl_FirstOrderEvt] Where userid='"&LCase(ouser.FOneUser.FUserID)&"' "
	rsEVTget.Open sqlstr, dbEVTget, 1
		FirstUserYouEvtChk = rsEVTget(0)
	rsEVTget.close

	If FirstUserYouEvtChk > 0 Then
		response.Cookies("Evt79281FirstOrder") = FirstUserYouEvtChk
	End If

	If Left(request.Cookies("rdsite"), 13) = "mobile_nvshop" Then
		If isNaverOpen Then
			Dim sqlnv, nvRow
'	원할인 쿠폰
			sqlnv = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & GetLoginUserID & "' AND masteridx = '1022') " & vbCrlf
			sqlnv = sqlnv & "insert into [db_user].[dbo].tbl_user_coupon " & vbCrlf
			sqlnv = sqlnv & " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice, " & vbCrlf
			sqlnv = sqlnv & " targetitemlist,startdate,expiredate) " & vbCrlf
			sqlnv = sqlnv & " values(1022,'" & GetLoginUserID & "',3000,'2','[1월 네이버]쿠폰_3000원 할인',30000, " & vbCrlf
			sqlnv = sqlnv & " '','2018-01-01 00:00:00' ,'2018-01-07 23:59:59') " & vbCrlf

'	%할인 쿠폰
'			sqlnv = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & GetLoginUserID & "' AND masteridx = '313') " & vbCrlf
'			sqlnv = sqlnv & "insert into [db_user].[dbo].tbl_user_coupon " & vbCrlf
'			sqlnv = sqlnv & " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice, " & vbCrlf
'			sqlnv = sqlnv & " targetitemlist,startdate,expiredate) " & vbCrlf
'			sqlnv = sqlnv & " values(313,'" & GetLoginUserID & "',5,'1','네이버 유입고객 쿠폰 5%',30000, " & vbCrlf
'			sqlnv = sqlnv & " '','2014-03-07 00:00:00' ,'2014-03-23 23:59:59') " & vbCrlf
			dbget.Execute sqlnv, nvRow
			If (nvRow = 1) Then
				response.Cookies("nvshop").domain = "10x10.co.kr"
				response.cookies("nvshop")("mode") = "y"
				response.cookies("nvshop").Expires = Date + 7
				response.write 	"<script type='text/javascript'>alert('네이버X텐바이텐 할인쿠폰\n\n쿠폰지급 완료');</script>"
			End If
		End If
	End If

	If Left(request.Cookies("rdsite"), 15) = "mobile_daumshop" Then
		If isDaumOpen Then
			Dim sqldaum, daumRow
'	원할인 쿠폰
			sqldaum = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & GetLoginUserID & "' AND masteridx = '2790') " & vbCrlf
			sqldaum = sqldaum & "insert into [db_user].[dbo].tbl_user_coupon " & vbCrlf
			sqldaum = sqldaum & " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice, " & vbCrlf
			sqldaum = sqldaum & " targetitemlist,startdate,expiredate) " & vbCrlf
			sqldaum = sqldaum & " values(2790,'" & GetLoginUserID & "',3000,'2','[5월 다음]쿠폰_3000원 할인',30000, " & vbCrlf
			sqldaum = sqldaum & " '','2016-05-18 00:00:00' ,'2016-05-29 23:59:59') " & vbCrlf

'	%할인 쿠폰
'			sqldaum = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & GetLoginUserID & "' AND masteridx = '313') " & vbCrlf
'			sqldaum = sqldaum & "insert into [db_user].[dbo].tbl_user_coupon " & vbCrlf
'			sqldaum = sqldaum & " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice, " & vbCrlf
'			sqldaum = sqldaum & " targetitemlist,startdate,expiredate) " & vbCrlf
'			sqldaum = sqldaum & " values(313,'" & GetLoginUserID & "',5,'1','네이버 유입고객 쿠폰 5%',30000, " & vbCrlf
'			sqldaum = sqldaum & " '','2014-03-07 00:00:00' ,'2014-03-23 23:59:59') " & vbCrlf
			dbget.Execute sqldaum, daumRow
			If (daumRow = 1) Then
				response.Cookies("daumshop").domain = "10x10.co.kr"
				response.cookies("daumshop")("mode") = "y"
				response.cookies("daumshop").Expires = Date + 7
				response.write 	"<script type='text/javascript'>alert('다음X텐바이텐 할인쿠폰\n\n쿠폰지급 완료');</script>"
			End If
		End If
	End If

	' 2019-02-26 프로모션쿠폰
	Dim couponSqlStr

	couponSqlStr = "EXEC db_user.dbo.USP_TEN_LOGINCOUPON_INSERT '"& ouser.FOneUser.FUserID &"'"
	dbget.Execute couponSqlStr, 1

	 If Now() > #12/16/2013 00:00:00# AND Now() < #01/31/2014 23:59:59# Then
		If GetLoginUserLevel() = "3" OR GetLoginUserLevel() = "4" or GetLoginUserID()="star088" Then
				If GetLoginUserID()="star088" then
		Dim vipchk, chk11
		vipchk = "SELECT count(*) FROM db_temp.dbo.tbl_user_VVip WHERE userid = '" & GetLoginUserID() & "' AND vvol='vol02'"
		rsget.Open vipchk,dbget,1
		IF Not rsget.Eof Then
			chk11 = rsget(0)
		End IF
		rsget.close

			If chk11=0 then
	%>
			<script type='text/javascript'>
				alert("test");
				location.href="<%=wwwUrl%>/event/etc/specialthanks2013.asp";
			</script>
	<%
			End If
				End If
		End If
	End IF
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

if (ouser.IsPassOk) then

	'이벤트 당첨여부 확인
	Dim clsEvtPrize	: set clsEvtPrize  = new CEventPrize
	clsEvtPrize.FUserid = getLoginuserid
		clsEvtPrize.fnGetEventCheckPrice
		if clsEvtPrize.FTotCnt>0 then
			response.Cookies("uinfo")("isEvtWinner") = true
		else
			response.Cookies("uinfo")("isEvtWinner") = false
		end if

		'Tester 당첨 여부.
		clsEvtPrize.fnGetTesterEventCheck
		if clsEvtPrize.FTotCnt>0 then
			response.Cookies("uinfo")("isTester") = true
		else
			response.Cookies("uinfo")("isTester") = false
		end if
	set clsEvtPrize = Nothing


	set ouser = Nothing
	if (isopenerreload="on") then
		if (backpath = "") then
			backpath = wwwUrl &"/"
		end if
		response.write "<script type='text/javascript'>jsReloadSSL('"&isopenerreload&"','"& server.URLEncode(backpath) &"','"&blnclose&"');</script>"
		dbget.Close: response.end
	else

		if (backpath = "") then
			If (referer = "") Then
				referer = wwwUrl &"/"
			End If
	    	response.write "<script type='text/javascript'>location.replace('" + referer + "');</script>"
			'''response.redirect(referer)
			dbget.Close: response.end
		else
		    if (strPostData<>"") then  ''2017/08/14 분기 by eastone
    		%>
    		<form method="post" name="frmLogin" action="<%=wwwUrl & backpath%>" >
    			<%	Call sbPostDataToHtml(strPostData) %>
    		</form>
    		<script type="text/javascript">
    			document.frmLogin.submit();
    		</script>
    		<%
    		else
				'일반 이동
				if (InStr(LCASE(backpath),"inipay/userinfo")>0) then  ''2017/08/14
				    response.redirect(M_SSLUrl & backpath)
				else
				    response.redirect(wwwUrl & backpath)
			    end if
			end if
		end if
		  dbget.Close: response.end
	end if
elseif (ouser.IsRequireUsingSite) then
	set ouser = Nothing
    Response.Write "<script type='text/javascript'>alert('사용 중지하신 서비스 입니다.');location.href='" & wwwUrl &"/';</script>"
    Response.End
elseif ouser.FConfirmUser="X" then
	set ouser = Nothing
    response.write "<script type='text/javascript'>" &_
    				"alert('사용이 일시정지된 아이디입니다.\n텐바이텐 고객센터(1644-6030)으로 연락주세요.');" &_
    				"history.back();" &_
    				"</script>"
elseif ouser.FConfirmUser="N" then
	set ouser = Nothing
	session("sUserid")=userid
    response.write "<script type='text/javascript'>var ret = confirm('가입 승인 대기중입니다.\n회원가입 본인인증 페이지로 이동하시겠습니까?.'); if (ret) { location.href = '" & wwwUrl &"/member/join_step3.asp?re=1'; } else { history.back(); }; </script>"
else
    '####### 로그인 실패 로그 저장
    Call MLoginLogSave(userid,"N","ten_m",flgDevice)

    '## 로그인 실패정보 저장 (2015.10.28; 허진원)
    chkLoginFailCnt = ChkLoginFailInfo(userid, "Add")

	set ouser = Nothing

	if chkLoginFailCnt<10 then
		''Session.Contents.Remove("chkLoginLock")
		response.write "<script>alert('텐바이텐 회원이 아니시거나, 아이디 또는 비밀번호를 잘못 입력하셨습니다.\n\n※ 10회 이상 입력 오류시 개인정보 보호를 위해 잠시 동안 로그인이 제한됩니다. (" & chkLoginFailCnt & "번 실패)');"
		response.write "history.back();</script>"
	else
		response.write "<script>alert('텐바이텐 회원이 아니시거나, 아이디 또는 비밀번호를 잘못 입력하셨습니다.\n\n※ 10회 이상 입력 오류로 인해 잠시 동안 로그인이 제한됩니다.\n잠시 후 다시 로그인해주세요.');"
		response.write "history.back();</script>"
	end if
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<!-- #include virtual="/lib/db/dbEVTclose.asp" -->
