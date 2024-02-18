<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 회원가입
' History : 2014.09.03 한용민 생성
' History : 2017.05.29 유태욱 수정
'####################################################
%>
<% const midx = 0 %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/incNaverOpenDate.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/incDaumOpenDate.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/util/base64_u.asp" -->
<%
'==============================================================================
'외부 URL 체크
dim backurl
backurl = request.ServerVariables("HTTP_REFERER")
if InStr(LCase(backurl),"10x10.co.kr") < 1 then
    if (Len(backurl)>0) then
        response.redirect backurl
        response.end
    else
        response.write "<script>alert('유효한 접근이 아닙니다.');history.back();</script>"
        response.end
    end if
end if

'==============================================================================
'파라미터 세팅

dim hideventid
dim txuserid, txpass1, txJumin1, txJumin2, emailok, crtfyNo, chkStat
dim txSolar, txBirthday1, txBirthday2, txBirthday3, txBirthday
dim txName, txSex, txCell1, txCell2, txCell3, txCell
dim email_way2way, email_10x10
dim smsok, smsok_fingers
dim snsgubun, tenbytenid, snsid, tokenval, tokencnt, sqlStrtoken, evtsource, sns_sexflag, kakaoterms

hideventid      = requestCheckVar(request.form("hideventid"),32)
txuserid        = requestCheckVar(request.form("txuserid"),32)
txpass1         = requestCheckVar(request.form("txpass1"),32)

email_way2way   = requestCheckVar(request.form("email_way2way"),9)
email_10x10     = requestCheckVar(request.form("email_10x10"),9)
smsok           = requestCheckVar(request.form("smsok"),9)
smsok_fingers   = requestCheckVar(request.form("smsok_fingers"),9)

txSolar         = requestCheckVar(html2db(request.form("txSolar")),1)
txBirthday1     = requestCheckVar(html2db(request.form("txBirthday1")),4)
txBirthday2     = requestCheckVar(html2db(request.form("txBirthday2")),2)
txBirthday3     = requestCheckVar(html2db(request.form("txBirthday3")),2)
txBirthday     = requestCheckVar(html2db(request.form("txBirthday")),10)

txName			= requestCheckVar(html2db(trim(request.form("txName"))),32)
txSex			= requestCheckVar(trim(request.form("txSex")),1)

txCell1			= requestCheckVar(html2db(request.form("txCell1")),4)
txCell2			= requestCheckVar(html2db(request.form("txCell2")),4)
txCell3			= requestCheckVar(html2db(request.form("txCell3")),4)
txCell			= requestCheckVar(html2db(request.form("txCell")),13)

chkStat			= requestCheckVar(Request.form("chkFlag"),1)
crtfyNo 		= requestCheckVar(Request.form("crtfyNo"),6)		' 휴대폰에 전송된 인증키

'sns 회원가입 추가 정보
snsid			= requestCheckVar(Request.form("snsid"),64)
snsgubun		= requestCheckVar(Request.form("snsgubun"),2)
sns_sexflag	= requestCheckVar(Request.form("sns_sexflag"),10)
'tenbytenid		= requestCheckVar(Request.form("tenbytenid"),32)
tokenval		= request("tokenval")
kakaoterms	= requestCheckVar(Request.form("kakaoterms"),2400)
evtsource		= "MO"
if snsgubun <> "" then
	evtsource		= evtsource&"_"&snsgubun
end if

if txBirthday="" then txBirthday="1900-01-01"

if snsgubun<>"" and snsid <> "" then
	if snsgubun <> "nv" and snsgubun <> "fb" and snsgubun <> "ka" and snsgubun <> "gl" then
        response.write "<script>alert('err01:SNS인증을 다시 시도해 주세요.')</script>"
        response.write "<script>history.back()</script>"
        response.end
	end if

	'// 토큰값 맞는지 확인
	sqlStrtoken = "Select count(*) From [db_user].[dbo].tbl_user_sns_token Where snsid='" & snsid & "' and snsgubun = '" & snsgubun & "' and snstoken = convert(nvarchar(256),'" & tokenval & "') "
	rsget.Open sqlStrtoken,dbget,1
	IF Not rsget.Eof Then
		tokencnt = rsget(0)
	End IF
	rsget.close

	if tokencnt < 1 Then
        response.write "<script>alert('err02:SNS인증을 다시 시도해 주세요.')</script>"
        response.write "<script>history.back()</script>"
        response.end
	end if

end if

'==============================================================================
dim usermail, birthday, refip, juminno, sexflag, sitegubun
dim Enc_userpass, Enc_userpass64

usermail = requestCheckVar(html2db(request.form("usermail")),128)
usermail = LeftB(usermail,128)

if email_10x10 <>"Y" then email_10x10 = "N"
if txSolar<>"Y" then txSolar = "N"
if smsok<>"Y" then smsok = "N"
if smsok_fingers<>"Y" then smsok_fingers = "N"

if (email_10x10="Y") or (email_way2way="Y") then
    emailok = "Y"
else
    emailok = "N"
end if

on error resume next
	if txBirthday1 = "0" then txBirthday1 = 1900
	if txBirthday2 = "0" then txBirthday2 = 1
	if txBirthday3 = "0" then txBirthday3 = 1
	birthday = CStr(txBirthday)
if Err then
	birthday = "1900-01-01"
end if
on error Goto 0

refip = Left(request.ServerVariables("REMOTE_ADDR"),32)

'==============================================================================
'// 통계를 위한 조합번호 생성 (생년월일, 성별)
txJumin1 = right(replace(birthday,"-",""),6)
if (txSex <> "M" and txSex <> "F") or txSex <> "" then
	txSex = "S"	''성별값 없을경우
end if

if Cint(left(txBirthday,4))<2000 then
	sexflag = chkIIF(txSex="M","1","2")
else
	sexflag = chkIIF(txSex="M","3","4")
end if

if txSex = "S" then
	sexflag = "0"
end if

juminno = txJumin1 & "-" & sexflag & "000000"
'==============================================================================
sitegubun = "10x10"
'==============================================================================
dim chk

chk = IsSpecialCharExist(db2html(txuserid))
if (chk = true) then
    response.write "<script>alert('아이디에는 특수문자를 사용할수 없습니다.(알파벳과 숫자 사용가능)')</script>"
    response.write "<script>history.back()</script>"
    response.end
end if

chk = IsUseridExist(txuserid)
if (chk = true) then
    response.write "<script>alert('이미 사용중이거나, 사용 할 수 없는 아이디입니다.')</script>"
    response.write "<script>history.back()</script>"
    response.end
end if

chk = chkSimplePwdComplex(txuserid,txpass1)
if (chk<>"") then
    response.write "<script>alert('" & chk & "')</script>"
    response.write "<script>history.back()</script>"
    response.end
end if

if usermail <> "" then
	chk = IsUserMailExist(db2html(usermail))
	if (chk = true) then
		response.write "<script>alert('이미 사용중인 메일주소입니다.')</script>"
		response.write "<script>history.back()</script>"
		response.end
	end if
end if

Enc_userpass = MD5(CStr(txpass1))
Enc_userpass64 = SHA256(MD5(CStr(txpass1)))

'========================== 휴대폰인증 인증번호 다시 검사 ====================================================
dim sqlStr, errcode, vSmsCD
'// 인증기록 검사
sqlStr = "Select top 1 usercell From db_log.dbo.tbl_userConfirm Where userid='" & txUserid & "' and smsCD = '" & crtfyNo & "' and confDiv='S' and isConfirm='Y' order by idx desc "
rsget.Open sqlStr,dbget,1
if rsget.EOF or rsget.BOF then
	rsget.close
    response.write "<script>alert('인증번호가 맞지 않습니다.\n정보입력을 다시 해주세요.'); top.location.href='/member/join.asp';</script>"
    dbget.close()
    response.end
else
	'// 인증받은 휴대폰번호인지 확인(2016.10.24; 허진원)
'	if rsget("usercell")<> CStr(txCell1)&"-"&CStr(txCell2)&"-"&CStr(txCell3) then
	if rsget("usercell")<> CStr(txCell) then
		rsget.close
	    response.write "<script>alert('입력하신 휴대폰번호가 맞지 않습니다.\n정보입력을 다시 해주세요.'); top.location.href='/member/join.asp';</script>"
	    dbget.close()
	    response.end
	end if
	rsget.close
end if


On Error Resume Next
dbget.beginTrans

If Err.Number = 0 Then
        errcode = "001"
end if
sqlStr = "insert into [db_user].[dbo].tbl_user_n(userid, username, juminno, birthday, zipcode, useraddr, usercell, usermail, regdate, mileage,  userlogo, usercomment, emailok, eventid, sitegubun, email_10x10, email_way2way, refip, issolar, smsok, smsok_fingers, sexflag, jumin1, Enc_jumin2, realnamecheck, userStat, rdsite) " + vbCrlf
sqlStr = sqlStr + "values('" + txuserid + "', '" + txName + "', '" + CStr(juminno) + "', '" + CStr(birthday) + "', '','','" + CStr(txCell) + "','" + usermail + "', getdate(), 0,  '', '','" + emailok + "','" + evtsource + "','" + sitegubun + "','" + email_10x10 + "','" + email_way2way + "','" + refip + "', '" + txSolar + "', '" + smsok + "', '" + smsok_fingers + "', '" + CStr(sexflag) + "', '" + CStr(txJumin1) + "', '', 'N', 'N', '" + CStr(hideventid) + "')" + vbCrlf
dbget.execute(sqlStr)

''sns 가입시
if snsgubun<>"" and snsid <> "" then
	If Err.Number = 0 Then
	        errcode = "009"
	end if
	sqlStr = "insert into [db_user].[dbo].tbl_user_sns(snsgubun, tenbytenid, snsid, usermail, sexflag, isusing) " + vbCrlf
	sqlStr = sqlStr + "values('" + snsgubun + "', '" + txuserid + "', '" + snsid + "', '" + usermail + "', '" + sns_sexflag + "', 'Y')" + vbCrlf
	dbget.execute(sqlStr)

	'// 카카오 싱크 사용자가 동의한 약관 데이터가 있을 시
	if kakaoterms<>"" Then
		sqlStr = "insert into [db_user].[dbo].tbl_user_sns_terms(snsgubun, tenbytenid, snsid, termsdesc, isusing, regdate, lastupdate) " + vbCrlf
		sqlStr = sqlStr + "values('" + snsgubun + "', '" + txuserid +"', '" + snsid +"', '" + kakaoterms + "', 'Y', GETDATE(), GETDATE()) " + vbCrlf
		dbget.execute(sqlStr)
	End if
end if

If Err.Number = 0 Then
        errcode = "002"
end if

''간편로그인수정;허진원 2018.04.24
sqlStr = "insert into [db_user].[dbo].tbl_logindata(userid, userpass, userdiv, lastlogin, counter, lastrefip, Enc_userpass, Enc_userpass64) " + vbCrlf
sqlStr = sqlStr + " values('" + txuserid + "', '', '" & chkIIF(snsgubun<>"" and snsid<>"","05","01") & "', getdate(), 0,'" + refip + "','','" + Enc_userpass64 + "')"
dbget.execute(sqlStr)

If Err.Number = 0 Then
        errcode = "004"
end if

sqlStr = "insert into [db_user].[dbo].tbl_user_current_mileage(userid,bonusmileage)" + vbCrlf
sqlStr = sqlStr + " values('" + txuserid + "'," + vbCrlf
sqlStr = sqlStr + " " + CStr(addmileage_join) + vbCrlf
sqlStr = sqlStr + ")"
dbget.execute(sqlStr)

If Err.Number = 0 Then
        errcode = "005"
end if

'' 사이트별 사용 구분 입력 (2007-12-27)
sqlStr = "insert into db_user.dbo.tbl_user_allow_site"
sqlStr = sqlStr + " (userid, sitegubun, siteusing, allowdate)"
sqlStr = sqlStr + " values("
sqlStr = sqlStr + " '" & txuserid & "'"
sqlStr = sqlStr + " ,'10x10'"
sqlStr = sqlStr + " ,'Y'"
sqlStr = sqlStr + " ,getdate()"
sqlStr = sqlStr + " )"

dbget.execute(sqlStr)

sqlStr = "insert into db_user.dbo.tbl_user_allow_site"
sqlStr = sqlStr + " (userid, sitegubun, siteusing, allowdate)"
sqlStr = sqlStr + " values("
sqlStr = sqlStr + " '" & txuserid & "'"
sqlStr = sqlStr + " ,'academy'"
sqlStr = sqlStr + " ,'Y'"
sqlStr = sqlStr + " ,getdate()"
sqlStr = sqlStr + " )"

dbget.execute(sqlStr)


If Err.Number = 0 Then
        errcode = "006"
end if

'==============================================================================
 ''회원가입 쿠폰
dim couponpublished
couponpublished = false

'2014년 2월 비트윈 어플 쿠폰(신규회원) idx=544
if ((date()>="2014-02-03") and (date()=<"2014-02-09"))  And request.cookies("rdsite") = "mobile_between" then
	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '544') " & vbCrlf
	sqlStr = sqlStr & "BEGIN " & vbCrlf
	sqlStr = sqlStr & "insert into [db_user].[dbo].tbl_user_coupon " & vbCrlf
	sqlStr = sqlStr & " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice, " & vbCrlf
	sqlStr = sqlStr & " targetitemlist,startdate,expiredate) " & vbCrlf
	sqlStr = sqlStr & " values(544,'" & txuserid & "',3000,'2','[2월비트윈] 회원가입 쿠폰',40000, " & vbCrlf
	sqlStr = sqlStr & " '','2014-02-03 00:00:00' ,'2014-02-10 23:59:59') " & vbCrlf
	sqlStr = sqlStr & "END " & vbCrlf

	dbget.execute(sqlStr)

	couponpublished = true
end If

'1월 신규고객 이벤트 찰칵 2015-12-30 원승현 '813
if ((date()>="2016-01-01") and (date()=<"2016-01-31")) Then
	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '813') " & vbCrlf
	sqlStr = sqlStr & "BEGIN " & vbCrlf
	sqlStr = sqlStr & "insert into [db_user].[dbo].tbl_user_coupon" + vbCrlf
	sqlStr = sqlStr + " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice," + vbCrlf
	sqlStr = sqlStr + " targetitemlist,startdate,expiredate)" + vbCrlf
	sqlStr = sqlStr + " values(813,'" + txuserid + "',10000,'2','1월 신규회원 찰칵 10000 할인쿠폰',60000," + vbCrlf
	sqlStr = sqlStr + " '','"&Date()&" 00:00:00' ,'"&Date()&" 23:59:59')" + vbCrlf
	sqlStr = sqlStr & "END " & vbCrlf

	dbget.execute(sqlStr)

	couponpublished = true
end If

'/[2월신규고객] 든든쿠폰 	'/2016.01.27 한용민 추가
If Date() >= "2016-02-01" And Date() < "2016-03-01" Then
	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '821') " & vbCrlf
	sqlStr = sqlStr & "BEGIN " & vbCrlf
	sqlStr = sqlStr & "	insert into [db_user].[dbo].tbl_user_coupon" + vbCrlf
	sqlStr = sqlStr + " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice," + vbCrlf
	sqlStr = sqlStr + " targetitemlist,startdate,expiredate)" + vbCrlf
	sqlStr = sqlStr + " values(821,'" + txuserid + "',10000,'2','2월신규가입고객[1만원할인]',60000," + vbCrlf
	sqlStr = sqlStr + " '',getdate() ,dateadd(hh, +24, getdate()))" + vbCrlf
	sqlStr = sqlStr & "END " & vbCrlf

	dbget.execute(sqlStr)

	couponpublished = true
end If

'// 3월신규고객쿠폰 	'/2016-02-24 이종화
If Date() >= "2016-03-01" And Date() < "2016-04-01" Then
	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '828') " & vbCrlf
	sqlStr = sqlStr & "BEGIN " & vbCrlf
	sqlStr = sqlStr & "	insert into [db_user].[dbo].tbl_user_coupon" + vbCrlf
	sqlStr = sqlStr + " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice," + vbCrlf
	sqlStr = sqlStr + " targetitemlist,startdate,expiredate)" + vbCrlf
	sqlStr = sqlStr + " values(828,'" + txuserid + "',10000,'2','3월신규가입고객[1만원할인]',60000," + vbCrlf
	sqlStr = sqlStr + " '','"&Date()&" 00:00:00' ,'"&Date()&" 23:59:59')" + vbCrlf
	sqlStr = sqlStr & "END " & vbCrlf

	dbget.execute(sqlStr)

	couponpublished = true
end If

'// 4월신규고객쿠폰 	'/2016-03-31 유태욱
If Date() >= "2016-04-01" And Date() < "2016-05-01" Then
	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '843') " & vbCrlf
	sqlStr = sqlStr & "BEGIN " & vbCrlf
	sqlStr = sqlStr & "	insert into [db_user].[dbo].tbl_user_coupon" + vbCrlf
	sqlStr = sqlStr + " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice," + vbCrlf
	sqlStr = sqlStr + " targetitemlist,startdate,expiredate)" + vbCrlf
	sqlStr = sqlStr + " values(843,'" + txuserid + "',10000,'2','4월신규가입고객[1만원할인]',60000," + vbCrlf
	sqlStr = sqlStr + " '',getdate() ,dateadd(hh, +24, getdate()))" + vbCrlf
	sqlStr = sqlStr & "END " & vbCrlf

	dbget.execute(sqlStr)

	couponpublished = true
end If

'// 5월신규고객쿠폰 	'/2016-04-27 유태욱
If Date() >= "2016-05-01" And Date() < "2016-06-01" Then
	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '857') " & vbCrlf
	sqlStr = sqlStr & "BEGIN " & vbCrlf
	sqlStr = sqlStr & "	insert into [db_user].[dbo].tbl_user_coupon" + vbCrlf
	sqlStr = sqlStr + " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice," + vbCrlf
	sqlStr = sqlStr + " targetitemlist,startdate,expiredate)" + vbCrlf
	sqlStr = sqlStr + " values(857,'" + txuserid + "',10000,'2','5월신규가입고객[1만원할인]',60000," + vbCrlf
	sqlStr = sqlStr + " '',getdate() ,dateadd(hh, +24, getdate()))" + vbCrlf
	sqlStr = sqlStr & "END " & vbCrlf

	dbget.execute(sqlStr)

	couponpublished = true
end If

'// 6월신규고객쿠폰 	'/2016-05-30 김진영
If Date() >= "2016-06-01" And Date() < "2016-07-01" Then
	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '867') " & vbCrlf
	sqlStr = sqlStr & "BEGIN " & vbCrlf
	sqlStr = sqlStr & "	insert into [db_user].[dbo].tbl_user_coupon" + vbCrlf
	sqlStr = sqlStr + " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice," + vbCrlf
	sqlStr = sqlStr + " targetitemlist,startdate,expiredate)" + vbCrlf
	sqlStr = sqlStr + " values(867,'" + txuserid + "',10000,'2','6월신규가입고객[1만원할인]',60000," + vbCrlf
	sqlStr = sqlStr + " '',getdate() ,dateadd(hh, +24, getdate()))" + vbCrlf
	sqlStr = sqlStr & "END " & vbCrlf

	dbget.execute(sqlStr)

	couponpublished = true
end If

'// 7월신규고객쿠폰 	'/2016-06-30 유태욱
If Date() >= "2016-07-01" And Date() < "2016-08-01" Then
	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '880') " & vbCrlf
	sqlStr = sqlStr & "BEGIN " & vbCrlf
	sqlStr = sqlStr & "	insert into [db_user].[dbo].tbl_user_coupon" + vbCrlf
	sqlStr = sqlStr + " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice," + vbCrlf
	sqlStr = sqlStr + " targetitemlist,startdate,expiredate)" + vbCrlf
	sqlStr = sqlStr + " values(880,'" + txuserid + "',10000,'2','7월신규가입고객[1만원할인]',60000," + vbCrlf
	sqlStr = sqlStr + " '',getdate() ,dateadd(hh, +24, getdate()))" + vbCrlf
	sqlStr = sqlStr & "END " & vbCrlf

	dbget.execute(sqlStr)

	couponpublished = true
end If

'// 8월신규고객쿠폰 	'/2016-08-05 김진영
If Date() >= "2016-08-08" And Date() < "2016-08-31" Then
	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '893') " & vbCrlf
	sqlStr = sqlStr & "BEGIN " & vbCrlf
	sqlStr = sqlStr & "	insert into [db_user].[dbo].tbl_user_coupon" + vbCrlf
	sqlStr = sqlStr + " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice," + vbCrlf
	sqlStr = sqlStr + " targetitemlist,startdate,expiredate)" + vbCrlf
	sqlStr = sqlStr + " values(893,'" + txuserid + "',10000,'2','8월신규가입(1만원)',60000," + vbCrlf
	sqlStr = sqlStr + " '',getdate() ,dateadd(hh, +24, getdate()))" + vbCrlf
	sqlStr = sqlStr & "END " & vbCrlf

	dbget.execute(sqlStr)

	couponpublished = true
end If

'// 신규고객쿠폰 	'/2018-06-27 최종원
sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '1063') " & vbCrlf
sqlStr = sqlStr & "BEGIN " & vbCrlf
sqlStr = sqlStr & "	INSERT INTO [db_user].[dbo].tbl_user_coupon" & vbCrlf
sqlStr = sqlStr & " (masteridx, userid, couponvalue, coupontype, couponname, minbuyprice, " & vbCrlf
sqlStr = sqlStr & " targetitemlist, startdate, expiredate)" & vbCrlf
sqlStr = sqlStr & " values(1063,'" & txUserid & "',5000,'2','신규가입쿠폰 (5,000원)',70000," & vbCrlf
sqlStr = sqlStr & " '',getdate() ,dateadd(hh, +24, getdate()))" & vbCrlf
sqlStr = sqlStr & "END " & vbCrlf

dbget.execute(sqlStr)

sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '1062') " & vbCrlf
sqlStr = sqlStr & "BEGIN " & vbCrlf
sqlStr = sqlStr & "	INSERT INTO [db_user].[dbo].tbl_user_coupon" & vbCrlf
sqlStr = sqlStr & " (masteridx, userid, couponvalue, coupontype, couponname, minbuyprice, " & vbCrlf
sqlStr = sqlStr & " targetitemlist, startdate, expiredate)" & vbCrlf
sqlStr = sqlStr & " values(1062,'" & txUserid & "',10000,'2','신규가입쿠폰 (10,000원)',150000," & vbCrlf
sqlStr = sqlStr & " '',getdate() ,dateadd(hh, +24, getdate()))" & vbCrlf
sqlStr = sqlStr & "END " & vbCrlf

dbget.execute(sqlStr)

sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '1164') " & vbCrlf
sqlStr = sqlStr & "BEGIN " & vbCrlf
sqlStr = sqlStr & "	INSERT INTO [db_user].[dbo].tbl_user_coupon" & vbCrlf
sqlStr = sqlStr & " (masteridx, userid, couponvalue, coupontype, couponname, minbuyprice, " & vbCrlf
sqlStr = sqlStr & " targetitemlist, startdate, expiredate)" & vbCrlf
sqlStr = sqlStr & " values(1164,'" & txUserid & "',30000,'2','신규가입쿠폰 (30,000원)',300000," & vbCrlf
sqlStr = sqlStr & " '',getdate() ,dateadd(hh, +24, getdate()))" & vbCrlf
sqlStr = sqlStr & "END " & vbCrlf

dbget.execute(sqlStr)		

couponpublished = true	
'네이버 유입에게 할인 쿠폰
'nvshop이라는 쿠키 mode에 y로 강제수정
if isNaverOpen And (Left(request.cookies("rdsite"), 13) = "mobile_nvshop") then
'	원할인 쿠폰
	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '1022') " & vbCrlf
	sqlStr = sqlStr & "BEGIN " & vbCrlf
	sqlStr = sqlStr & "insert into [db_user].[dbo].tbl_user_coupon " & vbCrlf
	sqlStr = sqlStr & " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice, " & vbCrlf
	sqlStr = sqlStr & " targetitemlist,startdate,expiredate) " & vbCrlf
	sqlStr = sqlStr & " values(1022,'" & txuserid & "',3000,'2','[1월 네이버]쿠폰_3000원 할인',30000, " & vbCrlf
	sqlStr = sqlStr & " '','2017-12-29 00:00:00' ,'2018-01-07 23:59:59') " & vbCrlf
	sqlStr = sqlStr & "END " & vbCrlf

'	%할인 쿠폰
'	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '565') " & vbCrlf
'	sqlStr = sqlStr & "BEGIN " & vbCrlf
'	sqlStr = sqlStr & "insert into [db_user].[dbo].tbl_user_coupon " & vbCrlf
'	sqlStr = sqlStr & " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice, " & vbCrlf
'	sqlStr = sqlStr & " targetitemlist,startdate,expiredate) " & vbCrlf
'	sqlStr = sqlStr & " values(565,'" & txuserid & "',5,'1','네이버 유입고객 쿠폰 5%',30000, " & vbCrlf
'	sqlStr = sqlStr & " '','2014-03-17 00:00:00' ,'2014-03-23 23:59:59') " & vbCrlf
'	sqlStr = sqlStr & "END " & vbCrlf
	dbget.execute(sqlStr)
	couponpublished = true

	response.Cookies("nvshop").domain = "10x10.co.kr"
	response.Cookies("nvshop")("mode") = "y"
	response.Cookies("nvshop").Expires = Date + 7
end If

'다음 유입에게 할인 쿠폰
'daumshop이라는 쿠키 mode에 y로 강제수정
if isDaumOpen And (Left(request.cookies("rdsite"), 15) = "mobile_daumshop") then
'	원할인 쿠폰
	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '862') " & vbCrlf
	sqlStr = sqlStr & "BEGIN " & vbCrlf
	sqlStr = sqlStr & "insert into [db_user].[dbo].tbl_user_coupon " & vbCrlf
	sqlStr = sqlStr & " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice, " & vbCrlf
	sqlStr = sqlStr & " targetitemlist,startdate,expiredate) " & vbCrlf
	sqlStr = sqlStr & " values(862,'" & txuserid & "',3000,'2','[5월 다음]쿠폰_3000원 할인',30000, " & vbCrlf
	sqlStr = sqlStr & " '','2016-05-23 00:00:00' ,'2016-05-29 23:59:59') " & vbCrlf
	sqlStr = sqlStr & "END " & vbCrlf

'	%할인 쿠폰
'	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '565') " & vbCrlf
'	sqlStr = sqlStr & "BEGIN " & vbCrlf
'	sqlStr = sqlStr & "insert into [db_user].[dbo].tbl_user_coupon " & vbCrlf
'	sqlStr = sqlStr & " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice, " & vbCrlf
'	sqlStr = sqlStr & " targetitemlist,startdate,expiredate) " & vbCrlf
'	sqlStr = sqlStr & " values(565,'" & txuserid & "',5,'1','네이버 유입고객 쿠폰 5%',30000, " & vbCrlf
'	sqlStr = sqlStr & " '','2014-03-17 00:00:00' ,'2014-03-23 23:59:59') " & vbCrlf
'	sqlStr = sqlStr & "END " & vbCrlf
	dbget.execute(sqlStr)
	couponpublished = true

	response.Cookies("daumshop").domain = "10x10.co.kr"
	response.Cookies("daumshop")("mode") = "y"
	response.Cookies("daumshop").Expires = Date + 7
end If

	'// 2021-07-14 정태훈 회원가입 마일리지 2000포인트 지급
	dim expireDate
	expireDate = FormatDate(DateAdd("d",1,now()),"00.00.00")

	sqlStr = "IF NOT EXISTS(SELECT sub_idx FROM [db_event].[dbo].[tbl_event_subscript] WHERE  evt_code=112900 and userid='" & txUserid & "')" & vbCrlf
	sqlStr = sqlStr & "	BEGIN" & vbCrlf  
	sqlStr = sqlStr & "		INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2)" & vbCrlf
	sqlStr = sqlStr & "		VALUES (112900,'" & txUserid & "',CONVERT(VARCHAR(10),GETDATE(),21),2000)" & vbCrlf
	sqlStr = sqlStr & "		INSERT INTO [db_user].[dbo].[tbl_mileagelog](userid , mileage , jukyocd , jukyo , deleteyn)" & vbCrlf
	sqlStr = sqlStr & "		VALUES ('" & txUserid & "',2000,112900,'회원가입 축하 마일리지 (" & expireDate & "까지 사용 가능)','N')" & vbCrlf
	sqlStr = sqlStr & "		UPDATE [db_user].[dbo].[tbl_user_current_mileage]" & vbCrlf
	sqlStr = sqlStr & "		SET bonusmileage = bonusmileage + 2000" & vbCrlf
	sqlStr = sqlStr & "		WHERE userid='" & txUserid & "'" & vbCrlf
	sqlStr = sqlStr & "	END"
	dbget.execute(sqlStr)

	'// 앱 전용 쿠폰 	'/2020-09-03 (1379>1425)
	'// 2021-07-14 정태훈 앱쿠폰 지급 삭제
'	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '1425') " & vbCrlf
'	sqlStr = sqlStr & "BEGIN " & vbCrlf
'	sqlStr = sqlStr & "	insert into [db_user].[dbo].tbl_user_coupon" + vbCrlf
'	sqlStr = sqlStr + " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice," + vbCrlf
'	sqlStr = sqlStr + " targetitemlist,startdate,expiredate,validsitename)" + vbCrlf
'	sqlStr = sqlStr + " values(1425,'" + txuserid + "',3000,'2','3,000원 신규회원 APP 쿠폰',30000," + vbCrlf
'	sqlStr = sqlStr + " '',getdate() ,dateadd(hh, +24, getdate()), 'app')" + vbCrlf
'	sqlStr = sqlStr & "END " & vbCrlf
'	dbget.execute(sqlStr)
'	couponpublished = true

If Err.Number = 0 Then
        errcode = "007"
end if

'# 회원정보 변경
sqlStr = "Update db_user.dbo.tbl_user_n Set userStat='Y', isMobileChk='Y' Where userid='" & txUserid & "'"
dbget.execute(sqlStr)

'#가입축하 메일 발송 =>CommitTrans 아래로 이동
''IF (email_10x10="Y") then call SendMailNewUser(UserMail,txuserid)

'########################################################################################################################
'텐텐 포인트 카드 발급 2015-06-08 이종화
'########################################################################################################################
Dim strsql
'Dim txCellNum : txCellNum = CStr(txCell1) + "-" + CStr(txCell2) + "-" + CStr(txCell3)
Dim txCellNum : txCellNum = CStr(txCell)
Dim newCardNo, newUserSeq, exeCnt, AssignedRow

strsql = ""
strsql = strsql & " exec [db_shop].[dbo].[sp_ten_getTenTenCardNo] "
rsget.CursorLocation = adUseClient
rsget.CursorType = adOpenStatic
rsget.LockType = adLockOptimistic
rsget.Open strsql, dbget
If (Not rsget.Eof) then
	newCardNo = rsget("CardNo")
End If
rsget.close

strsql = ""
strsql = strsql & " INSERT INTO db_shop.dbo.tbl_total_shop_user (username, jumin1, HpNo, Email, EmailYN, SMSYN, RegShopID, lastupdate, regdate, OnlineUserID) " & VBCRLF
''strsql = strsql & " SELECT TOP 1 username, LEFT(juminno, 6), usercell, usermail, emailok, smsok, 'tenten', getdate(), getdate(), userid " & VBCRLF
strsql = strsql & " SELECT TOP 1 username, '', usercell, '', '', '', 'tenten', getdate(), getdate(), userid " & VBCRLF
strsql = strsql & " FROM db_user.dbo.tbl_user_n " & VBCRLF
strsql = strsql & " WHERE userid = '"&txUserid&"' " & VBCRLF
dbget.Execute strsql, AssignedRow
If AssignedRow = 1 Then exeCnt = exeCnt + 1

strsql = ""
strsql = strsql & " SELECT TOP 1 UserSeq FROM db_shop.dbo.tbl_total_shop_user WHERE OnlineUserID = '"&txUserid&"' "
rsget.Open strsql, dbget, 1
If Not Rsget.Eof Then
	newUserSeq = rsget("UserSeq")
End If
rsget.close

strsql = ""
strsql = strsql & " INSERT INTO db_shop.dbo.tbl_total_shop_card (UserSeq, CardNo, point, useYN, RegShopID, Regdate) VALUES " & VBCRLF
strsql = strsql & " ('"&newUserSeq&"', '"&newCardNo&"', 0, 'Y', 'tenten', getdate()) " & VBCRLF
dbget.Execute strsql, AssignedRow
If AssignedRow = 1 Then exeCnt = exeCnt + 1

strsql = ""
strsql = strsql & " UPDATE db_shop.dbo.tbl_total_card_list SET " & VBCRLF
strsql = strsql & " useYN = 'Y' " & VBCRLF
strsql = strsql & " WHERE cardNo = '"&newCardNo&"' " & VBCRLF
dbget.Execute strsql, AssignedRow
If AssignedRow = 1 Then exeCnt = exeCnt + 1

strsql = ""
strsql = strsql& " SELECT TOP 1 userid FROM db_user.dbo.tbl_user_n WHERE userid <> '"&txUserid&"' "
rsget.Open strSql, dbget, 1
If rsget.RecordCount > 0 Then
	exeCnt = exeCnt - 1
End If
rsget.Close
'########################################################################################################################

If Err.Number = 0 Then
        '// 처리 완료
        dbget.CommitTrans

        '# 세션에 아이디 저장
        Session("sUserid") = txuserid

		'#가입축하 메일 발송 아래로 이동
		IF (email_10x10="Y") then call SendMailNewUser(UserMail,txuserid)

		if chkStat="N" then
			'신규가입 승인시
			Response.Redirect(wwwUrl & "/member/join_welcome.asp")
		else
			'기존회원 승인시
			Response.Redirect(wwwUrl & "/my10x10/userinfo/membermodify.asp")
		end if

Else
        '//오류가 발생했으므로 롤백
        dbget.RollBackTrans
        response.write "<script>alert('데이타를 저장하는 도중에 에러가 발생하였습니다.\r\n지속적으로 문제가 발생시에는 고객센타에 연락주시기 바랍니다.(에러코드 : " + CStr(errcode) + ")')</script>"
        response.write "<script>history.back()</script>"
        response.end
End If
on error Goto 0

'==============================================================================
function IsUseridExist(userid)
    dim sqlStr

    sqlStr = " select top 1 userid from [db_user].[dbo].tbl_logindata where userid = '" + userid + "' "
    rsget.Open sqlStr,dbget,1
    IsUseridExist = (not rsget.EOF)
    rsget.close

    sqlStr = " select userid from [db_user].[dbo].tbl_deluser where userid = '" + userid + "' "
    rsget.Open sqlStr, dbget, 1
    IsUseridExist = IsUseridExist or (Not rsget.Eof)
    rsget.Close
end function

function IsUserMailExist(usermail)
    dim strSql, bIsExist

	'// 회원정보에서 인증기록이 있는 정보만 확인(userStat N:인증전, Y:인증완료, Null:기존고객)
	strSql = "select top 1 userid from [db_user].[dbo].tbl_user_n " &_
			" where usermail='" & usermail & "' " &_
			" and (userStat='Y' or (userStat='N' and datediff(hh,regdate,getdate())<12)) "
	rsget.Open strSql, dbget, 1

	'동일한 이메일 없음
	If rsget.EOF = True Then
		bIsExist = False
	'동일한 이메일 존재
	Else
		bIsExist = True
	End If
	rsget.Close
	IsUserMailExist = bIsExist
end function

function IsSpecialCharExist(s)
    dim buf, result, index

    index = 1
    do until index > len(s)
            buf = mid(s, index, cint(1))
            if (lcase(buf) >= "a" and lcase(buf) <= "z") then
                    result = false
            elseif (buf >= "0" and buf <= "9") then
                    result = false
            else
                    IsSpecialCharExist = true
                    exit function
            end if
            index = index + 1
    loop

    IsSpecialCharExist = false
end function
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->