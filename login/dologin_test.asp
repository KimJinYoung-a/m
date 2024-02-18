<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
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
''사용안함
1=a

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

dim referer
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
									"alert('연동이 완료 되었습니다.');" &_
									"</script>"
				end if
			end if
		end if
	end if

	response.Cookies("uinfo").domain = "10x10.co.kr"
	response.Cookies("uinfo")("muserid") = ouser.FOneUser.FUserID
	response.Cookies("uinfo")("musername") = ouser.FOneUser.FUserName
	'' response.Cookies("uinfo")("museremail") = ouser.FOneUser.FUserEmail  ''제거.2017/06/23
	response.Cookies("uinfo")("muserdiv") = ouser.FOneUser.FUserDiv
	response.cookies("uinfo")("muserlevel") = ouser.FOneUser.FUserLevel
    response.cookies("uinfo")("mrealnamecheck") = ouser.FOneUser.FRealNameCheck
    ''201212 추가 로그인아이디 해시값
    response.cookies("uinfo")("shix") = HashTenID(ouser.FOneUser.FUserID)

    response.Cookies("etc").domain = "10x10.co.kr"
    response.cookies("etc")("mcouponCnt") = ouser.FOneUser.FCouponCnt
    response.cookies("etc")("mcurrentmile") = ouser.FOneUser.FCurrentMileage
	response.cookies("etc")("currtencash") = ouser.FOneUser.FCurrentTenCash
	response.cookies("etc")("currtengiftcard") = ouser.FOneUser.FCurrentTenGiftCard
    response.cookies("etc")("cartCnt") = ouser.FOneUser.FBaguniCount
    response.Cookies("etc")("ordCnt") = ouser.FOneUser.ForderCount		'201409 추가 최근주문/배송수
    response.Cookies("etc")("musericonNo") = ouser.FOneUser.FUserIconNo
    response.Cookies("etc")("logindate") = now()
    response.Cookies("etc")("ConfirmUser") = ouser.FConfirmUser

	'20140902추가 'GSShop WCS 관련
	response.Cookies("wcs_uid").domain = "10x10.co.kr"
	response.Cookies("wcs_uid") = HashTenID(ouser.FOneUser.FUserID)

    ''자동 로그인 저장
    response.Cookies("mSave").domain = "10x10.co.kr"
    response.cookies("mSave").Expires = Date + 30	'1개월간 쿠키 저장
    If request("saved_auto") = "o" Then
    	response.cookies("mSave")("SAVED_AUTO") = "O"
    	response.cookies("mSave")("SAVED_ID") = tenEnc(userid)
    	response.cookies("mSave")("SAVED_PW") = tenEnc(userpass)
    Else
    	response.cookies("mSave")("SAVED_AUTO") = ""
    	response.cookies("mSave")("SAVED_ID") = ""
    	response.cookies("mSave")("SAVED_PW") = ""
    End If

	'더핑거스 구약관 동의 여부 (2016.09.05 이전 동의 회원)
	session("chkFingersAllow") = ouser.FchkFingersAllow

	if (ouser.FOneUser.FUserDiv="02") or (ouser.FOneUser.FUserDiv="03") or (ouser.FOneUser.FUserDiv="04") or (ouser.FOneUser.FUserDiv="06") or (ouser.FOneUser.FUserDiv="07") or (ouser.FOneUser.FUserDiv="08") or (ouser.FOneUser.FUserDiv="19") or (ouser.FOneUser.FUserDiv="20")   then
		isupche = "Y"
	else
		isupche = "N"
	end if

	response.Cookies("uinfo")("misupche") = isupche
	'// appBoy용 로그인 세션처리
	session("appboySession") = ouser.FOneUser.FUserSeq
	'// appBoy관련데이터 추가-원승현(2017-11-07)
	Select Case Trim(request.Cookies("uinfo")("muserlevel"))
		Case "0"
			response.Cookies("appboy")("muserlevel") = "yellow"
		Case "1"
			response.Cookies("appboy")("muserlevel") = "green"
		Case "2"
			response.Cookies("appboy")("muserlevel") = "blue"
		Case "3"
			response.Cookies("appboy")("muserlevel") = "vipsilver"
		Case "4"
			response.Cookies("appboy")("muserlevel") = "vipgold"
		Case "5"
			response.Cookies("appboy")("muserlevel") = "orange"
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
	sqlstr = sqlstr & "	case when lastpushyn='Y' then convert(varchar(33), lastpushynDate, 126)+'+09:00' else '' end as push_opted_in_at, l.counter "
	sqlstr = sqlstr & "	From db_user.dbo.tbl_user_n n "
	sqlstr = sqlstr & "	inner join db_user.dbo.tbl_logindata l on n.userid = l.userid "
	sqlstr = sqlstr & "	left join db_contents.dbo.tbl_app_wish_userinfo u on n.userid = u.userid "
	sqlstr = sqlstr & "	Where n.userid='"&LCase(ouser.FOneUser.FUserID)&"' "
	rsget.Open sqlstr, dbget, 1
	If Not(rsget.bof Or rsget.eof) Then
		session("appboyDob") = rsget("dob")
		session("appboyGender") = rsget("gender")
		response.Cookies("appboy")("mfirstLoginDate") = rsget("firstLogin")
		response.Cookies("appboy")("mlastLoginDate") = rsget("lastLogin")
		response.Cookies("appboy")("mpushSubscribe") = rsget("push_subscribe")
		response.Cookies("appboy")("mpushOptedInAt") = rsget("push_opted_in_at")
		response.Cookies("appboy")("mloginCounter") = rsget("counter")
	End If
	rsget.close

    '####### 로그인 로그 저장
    Call MLoginLogSave(userid,"Y","ten_m",flgDevice)

    '###### 실패로그 정리
    if chkLoginFailCnt>0 then Call ClearLoginFailInfo(userid)
    Session.Contents.Remove("chkLoginLock")		'계정중지 리셋

    '####### 쇼핑톡 나의글에 새의견이 있는지 체크. 있으면 쿠키에 담음. ("uinfo")("isnewcomm")
    Call CheckMyTalkNewComm(userid)

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

	Dim CheckIDX
	' 2018-04-30 정태훈 추가..특정 하루 모든 고객 쿠폰 발급(5월 가정의달 쿠폰)
	If now() > #04/30/2018 00:00:00# and now() < #05/09/2018 23:59:59# Then
		Dim sqltoday
	'	원할인
		sqltoday = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & GetLoginUserID & "' AND masteridx = '1038') " & vbCrlf
		sqltoday = sqltoday & "insert into [db_user].[dbo].tbl_user_coupon " & vbCrlf
		sqltoday = sqltoday & " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice, " & vbCrlf
		sqltoday = sqltoday & " targetitemlist,startdate,expiredate) " & vbCrlf
		sqltoday = sqltoday & " values(1038,'" & GetLoginUserID & "',5000,'2','달콤한 비밀 쿠폰',30000, " & vbCrlf
		sqltoday = sqltoday & " '','2018-03-14 00:00:00' ,'2018-03-14 23:59:59') " & vbCrlf
		dbget.Execute sqltoday, 1
		sqltoday = "select @@identity as idx "
		rsget.open sqltoday ,dbget,1
		if not rsget.eof then
			CheckIDX=rsget("idx")
		end If
		rsget.close
	End If

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

	'5월 가정의달 쿠폰 발급 완료 체크
	If CheckIDX>"0" Or GetLoginUserID="corpse2" Then
		backpath = backpath & "?mktevt=couponget"
		referer = referer & "&mktevt=couponget"
	End If
	
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