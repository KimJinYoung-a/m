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
<!-- #include virtual="/apps/appcom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/apps/nateon/lib/nateon_alarmClass.asp"-->
<%
dim userid, Enc_userpass, Enc_userpass64, username, useremail, usercell, juminno, complaindiv, complaintext, useq
dim txpass, txEmail, txPhone, chkMethod, zipcode, joindate, birthday, age, gender, area, zipaddr
dim sqlStr
dim chkOK, UserExists, errcode
''간편로그인수정;허진원 2018.04.24
dim userdiv

userid          = requestCheckVar(getEncLoginUserID,32)
txpass          = requestCheckVar(request("txpass"),32)
txEmail          = requestCheckVar(request("txEmail"),120)
txPhone          = requestCheckVar(request("txPhone"),16)
complaindiv     = requestCheckVar(request("complaindiv"),9)
complaintext    = html2db(request("complaintext"))
chkMethod		= requestCheckVar(request("chkMethod"),3)

''간편로그인수정;허진원 2018.04.24 - 유효 접근 주소 검사
dim refer
refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"/my10x10/userinfo/withdrawal.asp")<1 then
    response.write "<script>alert('잘못된 접근입니다.'); history.go(-1);</script>"
    response.end
end if
'==============================================================================
UserExists	= False
chkOK		= False

''간편로그인수정;허진원 2018.04.24
sqlStr = " select n.userid, n.username, n.usermail, n.usercell, n.juminno, n.zipcode, l.Enc_userpass, l.Enc_userpass64, convert(varchar(23),n.regdate,21) as regdate, n.birthday, n.zipaddr, l.useq, l.userdiv " & VbCrlf
sqlStr = sqlStr + " from [db_user].[dbo].tbl_user_n n, [db_user].[dbo].tbl_logindata l "& VbCrlf
sqlStr = sqlStr + " where n.userid = l.userid "& VbCrlf
sqlStr = sqlStr + " and n.userid = '" + userid + "' "& VbCrlf
rsget.Open sqlStr,dbget,1
if Not rsget.Eof then
	username	= rsget("username")
	useremail	= rsget("usermail")
	usercell	= rsget("usercell")

	juminno		= rsget("juminno")
	Enc_userpass = rsget("Enc_userpass")
	Enc_userpass64 = rsget("Enc_userpass64")
	zipcode		= rsget("zipcode")

	joindate	= rsget("regdate")
	birthday	= rsget("birthday")
	zipaddr		= rsget("zipaddr")
	useq        = rsget("useq")
    ''간편로그인수정;허진원 2018.04.24
    userdiv        = rsget("userdiv")

	UserExists = True
end if
rsget.close

'==============================================================================
''간편로그인수정;허진원 2018.04.24
Select Case chkMethod
	Case "E"
		'이메일 선택
		''if MD5(txpass)=Enc_userpass and useremail=txEmail then
		if (SHA256(MD5(txpass))=Enc_userpass64 or userdiv="05") and useremail=txEmail then
			chkOK = true
		end if
	Case "P"
		'휴대폰 선택
		''if MD5(txpass)=Enc_userpass and usercell=txPhone then
		if (SHA256(MD5(txpass))=Enc_userpass64 or userdiv="05") and usercell=txPhone then
			chkOK = true
		end if
	Case Else
	    response.write "<script>alert('잘못된 접근입니다.'); history.go(-1);</script>"
	    response.end
end Select
'==============================================================================

if chkOK then

	'' 네이트온 연동 체크 및 해제
	 on Error resume Next
	 Call NateonAlarmCheckTerminate(userid)
	 on Error goto 0

	'==============================================================================
	On Error Resume Next
	dbget.beginTrans

	If Err.Number = 0 Then
	        errcode = "013"
	end if

	'나이 계산
	if isDate(birthday) then
		age = DateDiff("yyyy",birthday,date)+1
	else
		age = 0
	end if

	'성별 산출
	if not(juminno="" or isNull(juminno)) then
		Select Case Mid(juminno,8,1)
			Case "1","3","5","7","9"
				gender = "M"
			Case "0","2","4","6","8"
				gender = "F"
		End Select
	end if

	'지역추출(시도)
	if not(zipaddr="" or isNull(zipaddr)) then
		area = split(zipaddr," ")(0)
		Select Case area
			Case "경상북도" : area="경북"
			Case "경상남도" : area="경남"
			Case "충청북도" : area="충북"
			Case "충청남도" : area="충남"
			Case "전라북도" : area="전북"
			Case "전라남도" : area="전남"
			Case Else :  area = left(area,2)
		End Select
	end if


	If Err.Number = 0 Then
	        errcode = "001"
	end if

	'// 탈퇴정보 저장
	sqlStr = "insert into [db_user].[dbo].tbl_deluser(userid, username, useremail, juminno, complaindiv, complaintext, chkMethod, zipcode, device, joindate, age, gender, area, useq) "
	sqlStr = sqlStr + " values('" + CStr(userid) + "', '', '', '" + CStr(juminno) + "','" + CStr(complaindiv) + "','" + CStr(complaintext) + "','" & chkMethod & "', '" & zipcode & "', 'A'"
	sqlStr = sqlStr + " ,'" & joindate & "', " & age & ",'" & gender & "','" & area & "','"&useq&"')"
	rsget.Open sqlStr,dbget,1

	If Err.Number = 0 Then
	        errcode = "002"
	end if
	sqlStr = "delete from [db_user].[dbo].tbl_user_n where userid = '" + CStr(userid) + "' "
	rsget.Open sqlStr,dbget,1

	If Err.Number = 0 Then
	        errcode = "003"
	end if
	sqlStr = "delete from [db_user].[dbo].tbl_logindata where userid = '" + CStr(userid) + "' "
	rsget.Open sqlStr,dbget,1


	'------ 마일리지 ----------
	If Err.Number = 0 Then
	        errcode = "004"
	end if
	''' sqlStr = "update [db_user].[dbo].tbl_mileagelog set deleteyn='Y' where userid = '" + userid + "' "
	'마일리지가 있을때 마이너스 로그 저장 (2012.12.13; 허진원)
'	sqlStr = "declare @ttMile as money " & vbCrLf
'	sqlStr = sqlStr & "select @ttMile = (m.jumunmileage +  m.flowerjumunmileage + m.bonusmileage  + m.academymileage - m.spendmileage -  IsNULL(e.realExpiredMileage,0)) " & vbCrLf
'	sqlStr = sqlStr & "from [db_user].[dbo].tbl_user_current_mileage m " & vbCrLf
'	sqlStr = sqlStr & "	left join ( " & vbCrLf
'	sqlStr = sqlStr & "	    select userid, sum(realExpiredMileage) as realExpiredMileage " & vbCrLf
'	sqlStr = sqlStr & "	    from db_user.dbo.tbl_mileage_Year_Expire " & vbCrLf
'	sqlStr = sqlStr & "	    where userid='" + userid + "' " & vbCrLf
'	sqlStr = sqlStr & "	    group by userid " & vbCrLf
'	sqlStr = sqlStr & "	) e on m.userid=e.userid " & vbCrLf
'	sqlStr = sqlStr & "where m.userid='" + userid + "' " & vbCrLf
'	sqlStr = sqlStr & "if(@ttMile>0) " & vbCrLf
'	sqlStr = sqlStr & "begin " & vbCrLf
'	sqlStr = sqlStr & "	insert into [db_user].[dbo].tbl_mileagelog (userid, mileage, jukyocd, jukyo) values ('" + userid + "',(@ttMile*-1),'9999','회원탈퇴') " & vbCrLf
'	sqlStr = sqlStr & "end"
    
    ''2014/12/23 이후 수정
	sqlStr = "declare @ttMile as money " & vbCrLf
	sqlStr = sqlStr & " select @ttMile = (m.jumunmileage +  m.flowerjumunmileage + m.bonusmileage  + m.academymileage - m.spendmileage -  IsNULL(m.expiredMile,0)) " & vbCrLf
	sqlStr = sqlStr & " from [db_user].[dbo].tbl_user_current_mileage m " & vbCrLf
	sqlStr = sqlStr & " where m.userid='" + userid + "' " & vbCrLf
	sqlStr = sqlStr & " if(@ttMile>0) " & vbCrLf
	sqlStr = sqlStr & " begin " & vbCrLf
	sqlStr = sqlStr & "	insert into [db_user].[dbo].tbl_mileagelog (userid, mileage, jukyocd, jukyo) values ('" + userid + "',(@ttMile*-1),'9999','회원탈퇴') " & vbCrLf
	sqlStr = sqlStr & " end"
	rsget.Open sqlStr,dbget,1
	
	If Err.Number = 0 Then
	        errcode = "005"
	end if
	sqlStr = "delete from [db_user].[dbo].tbl_user_current_mileage where userid = '" + userid + "' "
	rsget.Open sqlStr,dbget,1

	'------ 예치금 ----------
	If Err.Number = 0 Then
	        errcode = "006"
	end if
	sqlStr = "declare @ttCash as money " & vbCrLf
	sqlStr = sqlStr & "select @ttCash = (IsNULL(currentdeposit,0)) " & vbCrLf
	sqlStr = sqlStr & "from [db_user].[dbo].tbl_user_current_deposit  " & vbCrLf
	sqlStr = sqlStr & "where userid='" + userid + "' " & vbCrLf
	sqlStr = sqlStr & "if(@ttCash>0) " & vbCrLf
	sqlStr = sqlStr & "begin " & vbCrLf
	sqlStr = sqlStr & "	insert into [db_user].[dbo].tbl_depositlog (userid, deposit , jukyocd, jukyo) values ('" + userid + "',(@ttCash*-1),'9999','회원탈퇴') " & vbCrLf
	sqlStr = sqlStr & "end"
	rsget.Open sqlStr,dbget,1

	If Err.Number = 0 Then
	        errcode = "007"
	end if
	sqlStr = "delete from [db_user].[dbo].tbl_user_current_deposit where userid = '" + userid + "' "
	rsget.Open sqlStr,dbget,1


	'------ gift카드 ----------
	If Err.Number = 0 Then
	        errcode = "008"
	end if
	sqlStr = "declare @ttCard as money " & vbCrLf
	sqlStr = sqlStr & "select @ttCard = (IsNULL(currentCash,0)) " & vbCrLf
	sqlStr = sqlStr & "from [db_user].[dbo].tbl_giftcard_current  " & vbCrLf
	sqlStr = sqlStr & "where userid='" + userid + "' " & vbCrLf
	sqlStr = sqlStr & "if(@ttCard>0) " & vbCrLf
	sqlStr = sqlStr & "begin " & vbCrLf
	sqlStr = sqlStr & "	insert into [db_user].[dbo].tbl_giftcard_log (userid, useCash , jukyocd, jukyo, siteDiv, reguserid) values ('" + userid + "',(@ttCard*-1),'9999','회원탈퇴','T', '" + userid + "') " & vbCrLf
	sqlStr = sqlStr & "end"
	rsget.Open sqlStr,dbget,1

	If Err.Number = 0 Then
	        errcode = "009"
	end if
	sqlStr = "delete from [db_user].[dbo].tbl_giftcard_current where userid = '" + userid + "' "
	rsget.Open sqlStr,dbget,1
	
	'앱관련 삭제 작업 추가.
	If Err.Number = 0 Then
	        errcode = "010"
	end if
	sqlStr = "exec [db_contents].[dbo].[sp_Ten_App_withrawal_User] '" + userid + "'"
	rsget.Open sqlStr,dbget,1
	
	'내주소록 삭제
	If Err.Number = 0 Then
	        errcode = "011"
	end if
	sqlStr = "delete from [db_order].[dbo].[tbl_MyAddress] where userid = '" + userid + "'"
	rsget.Open sqlStr,dbget,1
	
	'내기념일 삭제
	If Err.Number = 0 Then
	        errcode = "012"
	end if
	sqlStr = "delete from [db_my10x10].[dbo].[tbl_MyAnniversary] where userid = '" + userid + "'"
	rsget.Open sqlStr,dbget,1

	'sns연동 삭제
	If Err.Number = 0 Then
	        errcode = "014"
	end if
	sqlStr = "delete from [db_user].[dbo].[tbl_user_sns]  where tenbytenid = '" + userid + "'"
	rsget.Open sqlStr,dbget,1

	If Err.Number = 0 Then
	    dbget.CommitTrans
	Else
	    dbget.RollBackTrans
	        response.write "<script>alert('데이타를 저장하는 도중에 에러가 발생하였습니다.\r\n지속적으로 문제가 발생시에는 고객센타에 연락주시기 바랍니다.(에러코드 : " + CStr(errcode) + ")')</script>"
	        response.write "<script>history.back()</script>"
	        response.end
	End If
	on error Goto 0

	Dim iCookieDomainName : iCookieDomainName = GetCookieDomainName

	response.Cookies("uinfo").domain = iCookieDomainName
	response.Cookies("uinfo") = ""
	response.Cookies("uinfo").Expires = Date - 1

	response.Cookies("mssn").domain = iCookieDomainName
    response.Cookies("mssn") = ""
    response.Cookies("mssn").Expires = Date - 1

	response.Cookies("mSave").domain = iCookieDomainName
	response.Cookies("mSave") = ""
    response.cookies("mSave").Expires = Date - 1

	response.Cookies("etc").domain = iCookieDomainName
	response.Cookies("etc") = ""
	response.Cookies("etc").Expires = Date - 1

	response.Cookies("mybadge").domain = iCookieDomainName
	response.Cookies("mybadge") = ""
	response.Cookies("mybadge").Expires = Date - 1

	response.Cookies("todayviewitemidlist").domain = iCookieDomainName
	response.cookies("todayviewitemidlist") = ""
	response.Cookies("todayviewitemidlist").Expires = Date - 1

	response.Cookies("rdsite").domain = iCookieDomainName
	response.cookies("rdsite") = ""
	response.Cookies("rdsite").Expires = Date - 1

	response.Cookies("shoppingbag").domain = iCookieDomainName
	response.cookies("shoppingbag") = ""
	response.Cookies("shoppingbag").Expires = Date - 1

	CALL fnDBSessionExpireV2() 
	
	session.abandon

	response.redirect "withdrawDone.asp"
else
	response.write "<script>alert('회원정보가 없거나 입력하신 입력하신 정보가 올바르지 않습니다.'); history.go(-1);</script>"
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->