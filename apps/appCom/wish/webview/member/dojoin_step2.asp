<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : 회원가입
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<% const midx = 0 %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
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

dim hideventid, txuserid, txpass1, txJumin1, txJumin2, emailok, txSolar, txBirthday1, txBirthday2, txBirthday3, txBirthday
dim txName, txSex, txCell1, txCell2, txCell3, email_way2way, email_10x10, smsok, smsok_fingers
	hideventid      = requestCheckVar(request.form("hideventid"),32)
	txuserid        = requestCheckVar(request.form("txuserid"),32)
	txpass1         = requestCheckVar(request.form("txpass1"),32)
	email_way2way   = requestCheckVar(request.form("email_way2way"),9)
	email_10x10     = requestCheckVar(request.form("email_10x10"),9)
	smsok           = requestCheckVar(request.form("smsok"),9)
	smsok_fingers   = requestCheckVar(request.form("smsok_fingers"),9)
	txSolar         = requestCheckVar(html2db(request.form("txSolar")),1)
	'txBirthday     = requestCheckVar(html2db(request.form("txBirthday")),10)
	txBirthday1     = requestCheckVar(html2db(request.form("txBirthday1")),4)
	txBirthday2     = requestCheckVar(html2db(request.form("txBirthday2")),2)
	txBirthday3     = requestCheckVar(html2db(request.form("txBirthday3")),2)
	txName			= requestCheckVar(html2db(trim(request.form("txName"))),32)
	txSex			= requestCheckVar(trim(request.form("txSex")),1)
	txCell1			= requestCheckVar(html2db(request.form("txCell1")),4)
	txCell2			= requestCheckVar(html2db(request.form("txCell2")),4)
	txCell3			= requestCheckVar(html2db(request.form("txCell3")),4)

'==============================================================================
dim usermail, birthday, refip, juminno, sexflag, sitegubun
dim Enc_userpass, Enc_userpass64

usermail = requestCheckVar(html2db(request.form("usermail")),128)
usermail = LeftB(usermail,128)

if (email_10x10="Y") or (email_way2way="Y") then
    emailok = "Y"
else
    emailok = "N"
end if

if txSolar<>"Y" then txSolar = "N"
if smsok<>"Y" then smsok = "N"
if smsok_fingers<>"Y" then smsok_fingers = "N"

on error resume next
	birthday = CStr(DateSerial(txBirthday1, txBirthday2, txBirthday3))
	'birthday = txBirthday
if Err then
	birthday = "1900-01-01"
end if
on error Goto 0

refip = Left(request.ServerVariables("REMOTE_ADDR"),32)

'==============================================================================
'// 통계를 위한 조합번호 생성 (생년월일, 성별)
txJumin1 = right(replace(birthday,"-",""),6)
if Cint(txBirthday1)<2000 then
	sexflag = chkIIF(txSex="M","1","2")
else
	sexflag = chkIIF(txSex="M","3","4")
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

chk = IsUserMailExist(db2html(usermail))
if (chk = true) then
        response.write "<script>alert('이미 사용중인 메일주소입니다.')</script>"
        response.write "<script>history.back()</script>"
        response.end
end if

Enc_userpass = MD5(CStr(txpass1))
Enc_userpass64 = SHA256(MD5(CStr(txpass1)))

'==============================================================================
dim sqlStr, errcode

On Error Resume Next
dbget.beginTrans

If Err.Number = 0 Then
        errcode = "001"
end if
sqlStr = "insert into [db_user].[dbo].tbl_user_n(userid, username, juminno, birthday, zipcode, useraddr, usercell, usermail, regdate, mileage,  userlogo, usercomment, emailok, eventid, sitegubun, email_10x10, email_way2way, refip, issolar, smsok, smsok_fingers, sexflag, jumin1, Enc_jumin2, realnamecheck, userStat, rdsite) " + vbCrlf
sqlStr = sqlStr + "values('" + txuserid + "', '" + txName + "', '" + CStr(juminno) + "', '" + CStr(birthday) + "', '','','" + CStr(txCell1) + "-" + CStr(txCell2) + "-" + CStr(txCell3) + "','" + usermail + "', getdate(), 0,  '', '','" + emailok + "','" + left(CStr(hideventid),16) + "','" + sitegubun + "','" + email_10x10 + "','" + email_way2way + "','" + refip + "', '" + txSolar + "', '" + smsok + "', '" + smsok_fingers + "', '" + CStr(sexflag) + "', '" + CStr(txJumin1) + "', '', 'N', 'N', '" + CStr(hideventid) + "')" + vbCrlf

dbget.execute(sqlStr)

If Err.Number = 0 Then
        errcode = "002"
end if

sqlStr = "insert into [db_user].[dbo].tbl_logindata(userid, userpass, userdiv, lastlogin, counter, lastrefip, Enc_userpass, Enc_userpass64) " + vbCrlf
sqlStr = sqlStr + " values('" + txuserid + "', '', '01', getdate(), 0,'" + refip + "','','" + Enc_userpass64 + "')"
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

'2014년 5월 신규회원 쿠폰 idx = 태섭 : 333 실섭 : 600
if ((date()>="2014-05-26") and (date()=<"2014-06-01")) Then
	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '600') " & vbCrlf
	sqlStr = sqlStr & "BEGIN " & vbCrlf
	sqlStr = sqlStr & " 	insert into [db_user].[dbo].tbl_user_coupon" + vbCrlf
	sqlStr = sqlStr + " 	(masteridx,userid,couponvalue,coupontype,couponname,minbuyprice," + vbCrlf
	sqlStr = sqlStr + " 	targetitemlist,startdate,expiredate)" + vbCrlf
	sqlStr = sqlStr + " 	values(600,'" + txuserid + "',4000,'2','5월 MAY I HELP YOU - 신규회원',30000 " + vbCrlf
	sqlStr = sqlStr + " 	,'','2014-05-26 00:00:00' ,'2014-06-01 23:59:59')" + vbCrlf
	sqlStr = sqlStr & "END " & vbCrlf
	'response.write sqlStr & "!!!!"
	dbget.execute(sqlStr)

	couponpublished = true
end If

'2014년 8월 맘스다이어리 신규회원 쿠폰 idx = 태섭 : 333 실섭 : 624
if ((date()>="2014-08-13") and (date()=<"2014-08-29")) And request.cookies("rdsite") = "mobile_moms" Then
	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '624') " & vbCrlf
	sqlStr = sqlStr & "BEGIN " & vbCrlf
	sqlStr = sqlStr & " 	insert into [db_user].[dbo].tbl_user_coupon" + vbCrlf
	sqlStr = sqlStr + " 	(masteridx,userid,couponvalue,coupontype,couponname,minbuyprice," + vbCrlf
	sqlStr = sqlStr + " 	targetitemlist,startdate,expiredate)" + vbCrlf
	sqlStr = sqlStr + " 	values(624,'" + txuserid + "',4000,'2','[맘스다이어리전용] My Baby 쿠폰(4,000원) - 신규회원',30000 " + vbCrlf
	sqlStr = sqlStr + " 	,'','2014-08-13 00:00:00' ,'2014-08-29 23:59:59')" + vbCrlf
	sqlStr = sqlStr & "END " & vbCrlf
	'response.write sqlStr & "!!!!"
	dbget.execute(sqlStr)

	couponpublished = true
end If

'추석선물대첩 이벤트
if ((date()>="2014-08-18") and (date()=<"2014-08-22")) Then
	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '626') " & vbCrlf
	sqlStr = sqlStr & "BEGIN " & vbCrlf
	sqlStr = sqlStr & "insert into [db_user].[dbo].tbl_user_coupon" + vbCrlf
	sqlStr = sqlStr + " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice," + vbCrlf
	sqlStr = sqlStr + " targetitemlist,startdate,expiredate)" + vbCrlf
	sqlStr = sqlStr + " values(626,'" + txuserid + "',4000,'2','신규회원 추석선물대첩 4000 할인쿠폰',30000," + vbCrlf
	sqlStr = sqlStr + " '','2014-08-18 00:00:00' ,'2014-08-22 23:59:59')" + vbCrlf
	sqlStr = sqlStr & "END " & vbCrlf

	dbget.execute(sqlStr)

	couponpublished = true
end If

'2014년 8월 베페베이비페어 신규회원 쿠폰 idx = 테섭 : 348 실섭 : 631
if ((date()>="2014-08-28") and (date()=<"2014-09-07")) And request.cookies("rdsite") = "mobile_BEFE" Then
	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '631') " & vbCrlf
	sqlStr = sqlStr & "BEGIN " & vbCrlf
	sqlStr = sqlStr & " 	insert into [db_user].[dbo].tbl_user_coupon" + vbCrlf
	sqlStr = sqlStr + " 	(masteridx,userid,couponvalue,coupontype,couponname,minbuyprice," + vbCrlf
	sqlStr = sqlStr + " 	targetitemlist,startdate,expiredate)" + vbCrlf
	sqlStr = sqlStr + " 	values(631,'" + txuserid + "',5000,'2','[베페베이비페어] 5,000원 엄마 쿠폰 - 신규회원',40000 " + vbCrlf
	sqlStr = sqlStr + " 	,'','2014-08-28 00:00:00' ,'2014-09-07 23:59:59')" + vbCrlf
	sqlStr = sqlStr & "END " & vbCrlf
	'response.write sqlStr & "!!!!"
	dbget.execute(sqlStr)

	couponpublished = true
end If

'2014년 9월 [핑크파우치분홍이벤트]Get Your Pouch! 신규회원 쿠폰 idx = 테섭 : 355 실섭 : 630
if ((date()>="2014-09-18") and (date()=<"2014-09-30")) And request.cookies("rdsite") = "mobile_PINK" Then
	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & txUserid & "' AND masteridx = '630') " & vbCrlf
	sqlStr = sqlStr & "BEGIN " & vbCrlf
	sqlStr = sqlStr & " 	insert into [db_user].[dbo].tbl_user_coupon" + vbCrlf
	sqlStr = sqlStr + " 	(masteridx,userid,couponvalue,coupontype,couponname,minbuyprice," + vbCrlf
	sqlStr = sqlStr + " 	targetitemlist,startdate,expiredate)" + vbCrlf
	sqlStr = sqlStr + " 	values(630,'" + txuserid + "',4000,'2','[핑크파우치 이벤트]4,000원 핑크 쿠폰',30000 " + vbCrlf
	sqlStr = sqlStr + " 	,'','2014-09-18 00:00:00' ,'2014-09-30 23:59:59')" + vbCrlf
	sqlStr = sqlStr & "END " & vbCrlf
	'response.write sqlStr & "!!!!"
	dbget.execute(sqlStr)

	couponpublished = true
end If

If Err.Number = 0 Then
        errcode = "007"
end if

'==============================================================================
dim sRndKey, chkStat, joinDt
'// 인증 문자 발송 (모바일은 문자로~)
'// 회원 여부 확인
sqlStr = "Select userStat, regdate From db_user.dbo.tbl_user_n Where userid='" & txuserid & "'"
rsget.Open sqlStr,dbget,1
if Not(rsget.EOF or rsget.BOF) then
	chkStat = rsget("userStat")
	joinDt = rsget("regdate")
end if
rsget.close

if (chkStat="Y" and datediff("h",joinDt,now())<=12) then
	'# 이미 가입 처리 완료
	response.write "<script type='text/javascript'>alert('감사합니다.\n이미 본인인증을 받으셨습니다.\n\n메인으로 이동합니다.');location.href='" & wwwUrl & "/';</script>"
	dbget.RollBackTrans
	dbget.close(): response.End
end if

'# 유효 인증 대기값이 있는지 확인(100초 이내 / 확인은 120초까지 유효)
sqlStr = "Select top 1 smsCD From db_log.dbo.tbl_userConfirm Where userid='" & txUserid & "' and confDiv='S' and isConfirm='N' and datediff(s,regdate,getdate())<=120 order by idx desc "
rsget.Open sqlStr,dbget,1
if Not(rsget.EOF or rsget.BOF) then
	sRndKey = rsget("smsCD")
end if
rsget.close

if sRndKey<>"" then
	'// 2분 이내에는 재발송 없음(SPAM 등에 걸리지 않는 이상 거의 대부분 늦게라도 전송됨)
else

	'# sRndKey값 생성
	randomize(time())
	sRndKey=Num2Str(left(round(rnd*(1000000)),6),6,"0","R")

	'# 인증 로그에 저장
	sqlStr = "insert into db_log.dbo.tbl_userConfirm (userid, confDiv, usercell, smsCD, pFlag, evtFlag) values ("
	sqlStr = sqlStr & " '" & txuserid & "'"
	sqlStr = sqlStr & " ,'S'"
	sqlStr = sqlStr & " ,'" & CStr(txCell1) & "-" & CStr(txCell2) & "-" & CStr(txCell3) & "'"
	sqlStr = sqlStr & " ,'" & sRndKey & "'"
	sqlStr = sqlStr & " ,'T','N'"
	sqlStr = sqlStr & " )"
	dbget.execute(sqlStr)

	'# 인증 SMS 발송
	sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg ) values " + vbcrlf
	sqlStr = sqlStr & " ('" & CStr(txCell1) & "-" & CStr(txCell2) & "-" & CStr(txCell3) & "'" + vbcrlf
	sqlStr = sqlStr & " ,'1644-6030','1',getdate()" + vbcrlf
	sqlStr = sqlStr & " ,'인증번호 [" & sRndKey & "]"& vbCrLf & "입력창에 넣으시면 진행이 완료됩니다. -텐바이텐')"
	dbget.execute(sqlStr)
end if

If Err.Number = 0 Then
        errcode = "008"
end if


'IF (email_10x10="Y") then call SendMailNewUser(usermail,txuserid)

If Err.Number = 0 Then
        '// 처리 완료
        dbget.CommitTrans

        '# 세션에 아이디 저장
        Session("sUserid") = txuserid

        '# Step3로 이동
        Response.Redirect(wwwUrl & "/apps/appcom/wish/webview/member/join_step3.asp")
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