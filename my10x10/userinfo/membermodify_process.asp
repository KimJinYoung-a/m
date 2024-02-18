<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/util/tenSessionLib.asp" -->
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/header.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/apps/kakaotalk/lib/kakaotalk_sendFunc.asp" -->
<%
dim userid
dim mode
dim oldpass,newpass1
dim username,zipcode
dim addr1,addr2,userphone
dim usercell ,useremail, orgUsercell
dim emailok,userbirthday
dim email_way2way, email_10x10
dim userpw_q, userpw_a
dim issolar, isMobileChk
''간편로그인수정;허진원 2018.04.24
dim sexflag

'####### POINT1010 에서 넘어온건지 체크 #######
Dim pFlag
pFlag	= requestCheckVar(request("pflag"),1)
'####### POINT1010 에서 넘어온건지 체크 #######


'' 2007-12-27 추가
dim smsok, smsok_fingers, allow_other
Const COtherSiteFlag = "academy"

userid      = requestCheckVar(getEncLoginUserID,32)

oldpass     = requestCheckVar(request.Form("oldpass"),32)
newpass1    = requestCheckVar(request.Form("newpass1"),32)

mode        = requestCheckVar(request.Form("mode"),16)
username    = requestCheckVar(html2db(request.Form("username")),32)
zipcode     = requestCheckVar(request.Form("txZip"),8)
addr1       = requestCheckVar(html2db(request.Form("txAddr1")),128)
addr2       = requestCheckVar(html2db(request.Form("txAddr2")),128)

userphone   = requestCheckVar(request.Form("userphone1"),4) + "-" + requestCheckVar(request.Form("userphone2"),4) + "-" + requestCheckVar(request.Form("userphone3"),4)
usercell    = requestCheckVar(request.Form("usercell1"),4)+ "-" + requestCheckVar(request.Form("usercell2"),4) + "-" + requestCheckVar(request.Form("usercell3"),4)
useremail   = requestCheckVar(html2db(request.Form("usermail")),128)
orgUsercell = requestCheckVar(html2db(request.Form("orgUsercell")),18)

issolar         = requestCheckVar(request.Form("issolar"),9)
isMobileChk	= requestCheckVar(request.Form("isMobileChk"),1)
''간편로그인수정;허진원 2018.04.24
sexflag		= requestCheckVar(request.Form("gender"),1)

if (mode="infomodi") then
    userbirthday    = requestCheckVar(CStr(DateSerial(request.form("userbirthday1"),request.form("userbirthday2"),request.form("userbirthday3"))),10)
end if

email_10x10     = requestCheckVar(request.Form("email_10x10"),9)
email_way2way   = requestCheckVar(request.Form("email_way2way"),9)

smsok           = requestCheckVar(request.Form("smsok"),9)
smsok_fingers   = requestCheckVar(request.Form("smsok_fingers"),9)
allow_other     = requestCheckVar(request.Form("allow_other"),9)

if (email_10x10="Y") or (email_way2way="Y") then
    emailok = "Y"
else
    emailok = "N"
end if

if (smsok<>"Y") then smsok="N"
if (smsok_fingers<>"Y") then smsok_fingers="N"

if isMobileChk="Y" and trim(orgUsercell)<>trim(usercell) then
	isMobileChk = "N"
end if

if (allow_other="N") then
    if (COtherSiteFlag="10x10") then
        email_10x10 = "N"
        smsok       = "N"
    elseif (COtherSiteFlag="academy") then
        email_way2way = "N"
        smsok_fingers = "N"
    end if
end if


''if email_way2way="" then email_way2way="N"
''if email_10x10="" then email_10x10="N"
''
'' ** emailok N 일경우 email_10x10, email_way2way 둘다 N (전체 사이트 N로)
''    Y일 경우 email_way2way 특정 사이트만 Y
''    emailok Flag는 차후 통합 E-mail 발송시 사용 .. 

''비밀번호 질문답변 사용안함
''userpw_q = request.Form("userpw_q")
''userpw_a = html2db(request.Form("userpw_a"))



'================XSS방지처리==================================================
If checkNotValidHTML(addr1) Then
	response.write "<script>alert('HTML태그 및 스크립트는 입력하실 수 없습니다.');history.back();</script>"
	response.End
End If

If checkNotValidHTML(addr2) Then
	response.write "<script>alert('HTML태그 및 스크립트는 입력하실 수 없습니다.');history.back();</script>"
	response.End
End If

If checkNotValidHTML(username) Then
	response.write "<script>alert('HTML태그 및 스크립트는 입력하실 수 없습니다.');history.back();</script>"
	response.End
End If 
'============================================================================

dim sqlStr, opass, passspecial
dim Enc_userpass, Enc_Old_userpass, Enc_New_userpass
dim Enc_userpass64, Enc_Old_userpass64, Enc_New_userpass64
''간편로그인수정;허진원 2018.04.24
dim userdiv
Enc_Old_userpass =  MD5(CStr(oldpass))
Enc_Old_userpass64 =  SHA256(MD5(CStr(oldpass)))

if (mode="passmodi") then
	sqlStr = "select top 1 userpass, Enc_userpass, Enc_userpass64 from [db_user].[dbo].tbl_logindata" + VbCrlf
	sqlStr = sqlStr + " where userid='" + userid + "'" + VbCrlf
	rsget.Open sqlStr, dbget, 1

	if Not rsget.Eof then
		opass = rsget("userpass")
		Enc_userpass = rsget("Enc_userpass")
		Enc_userpass64 = rsget("Enc_userpass64")
	end if
	rsget.Close
    
    ''if (opass<>oldpass)  then                  '' 비암호화
	''if (Enc_userpass<>Enc_Old_userpass)  then    '' 암호화 사용(MD5)
	if (Enc_userpass64<>Enc_Old_userpass64)  then    '' 암호화 사용(SHA256)
		response.write "<script>alert('기존 비밀번호가 일치하지 않습니다.');</script>"
		response.write "<script>history.back();</script>"
		response.end
	end if
    
    '' 비밀번호 특수 문자 체크
'	if (IsSpecialCharExist(newpass1)) then
'		response.write "<script>alert('비밀번호에는 특수문자를 사용할수 없습니다.(알파벳과 숫자 사용가능)')</script>"
'		response.write "<script>history.back()</script>"
'		response.end
'	end if

	dim chk
	chk = chkSimplePwdComplex(userid,newpass1)
	if (chk<>"") then
	        response.write "<script>alert('" & chk & "')</script>"
	        response.write "<script>history.back()</script>"
	        response.end
	end if

    '' 차후 비밀번호 Encript시 사용 하기 위함
	Enc_New_userpass =  MD5(CStr(newpass1))
	Enc_New_userpass64 =  SHA256(MD5(CStr(newpass1)))

	sqlStr = "update [db_user].[dbo].tbl_logindata" + VbCrlf
	sqlStr = sqlStr + " set userpass=''" + VbCrlf
	sqlStr = sqlStr + " , Enc_userpass=''" + VbCrlf
	sqlStr = sqlStr + " , Enc_userpass64='" + Enc_New_userpass64 + "'" + VbCrlf
	sqlStr = sqlStr + " where userid='" + userid + "'" + VbCrlf
	
	dbget.Execute sqlStr

	'수정로그 저장
	Call saveUpdateLog(userid, "P")

elseif (mode="infomodi") then
	''간편로그인수정;허진원 2018.04.24
	sqlStr = "select top 1 userpass, Enc_userpass, Enc_userpass64, userdiv from [db_user].[dbo].tbl_logindata" + VbCrlf
	sqlStr = sqlStr + " where userid='" + userid + "'" + VbCrlf
	rsget.Open sqlStr, dbget, 1

	if Not rsget.Eof then
		opass = rsget("userpass")
		Enc_userpass = rsget("Enc_userpass")
		Enc_userpass64 = rsget("Enc_userpass64")
		''간편로그인수정;허진원 2018.04.24
		userdiv = rsget("userdiv")
	end if
	rsget.Close
    
    ''if (opass<>oldpass) then                  '' 비암호화
	''if (Enc_userpass<>Enc_Old_userpass)  then   '' 암호화 사용(MD5)
	''간편로그인수정;허진원 2018.04.24
	if (Enc_userpass64<>Enc_Old_userpass64) and userdiv<>"05" then   '' 암호화 사용(SHA256)
		response.write "<script>alert('기존 비밀번호가 일치하지 않습니다.');</script>"
		response.write "<script>history.back();</script>"
		response.end
	end if
    
    
    ''다른 사이트 이용중지설정시 -모두 사용안함으로 설정할 수 없음.
    dim IsAllSiteNotUsing
    IsAllSiteNotUsing = false
    if (allow_other="N") then
        sqlStr = "select count(userid) as cnt from db_user.dbo.tbl_user_allow_site" & VbCrlf
    	sqlStr = sqlStr & " where userid='" & userid & "'" & VbCrlf
    	sqlStr = sqlStr & " and sitegubun<>'" & COtherSiteFlag & "'"
    	sqlStr = sqlStr & " and siteusing='N'"
    	
    	rsget.Open sqlStr, dbget, 1
    	    IsAllSiteNotUsing = rsget("cnt")>=1
    	rsget.close
    	
    	if (IsAllSiteNotUsing) then
    	    response.write "<script>alert('모든 서비스를 사용 안함으로 설정 하실 수 없습니다.');</script>"
    	    response.write "<script>history.back();</script>"
    	    response.end
    	end if
    end if
    
    
	sqlStr = "update [db_user].[dbo].tbl_user_n" + VbCrlf
	sqlStr = sqlStr + " set username='" + username + "'" + VbCrlf
	sqlStr = sqlStr + " ,zipcode='" + zipcode + "'"  + VbCrlf
	sqlStr = sqlStr + " ,birthday='" + userbirthday + "'"  + VbCrlf
	sqlStr = sqlStr + " ,zipaddr='" + addr1 + "'"  + VbCrlf
	sqlStr = sqlStr + " ,useraddr='" + addr2 + "'"  + VbCrlf
	sqlStr = sqlStr + " ,userphone='" + userphone + "'"  + VbCrlf
	''sqlStr = sqlStr + " ,usercell='" + usercell + "'"  + VbCrlf
	''sqlStr = sqlStr + " ,usermail='" + useremail + "'"  + VbCrlf
	sqlStr = sqlStr + " ,isMobileChk='" + isMobileChk + "'"  + VbCrlf
	sqlStr = sqlStr + " ,emailok='" + emailok + "'"  + VbCrlf
	sqlStr = sqlStr + " ,email_10x10='" + email_10x10 + "'"  + VbCrlf
	sqlStr = sqlStr + " ,email_way2way='" + email_way2way + "'"  + VbCrlf
	sqlStr = sqlStr + " ,issolar='" + issolar + "'"  + VbCrlf
	sqlStr = sqlStr + " ,smsok='" + smsok + "'"  + VbCrlf
	sqlStr = sqlStr + " ,smsok_fingers='" + smsok_fingers + "'"  + VbCrlf
	''간편로그인수정;허진원 2018.04.24
	sqlStr = sqlStr + " ,sexflag='" + sexflag + "'"  + VbCrlf
	sqlStr = sqlStr + " where userid='" + userid + "'" + VbCrlf

	dbget.Execute sqlStr
	
	
	'' 사이트 이용 관리 (2007-12-27): 10x10
	dim SiteConfirmExistes
	
	sqlStr = "select userid, sitegubun, siteusing from db_user.dbo.tbl_user_allow_site" & VbCrlf
	sqlStr = sqlStr & " where userid='" & userid & "'" & VbCrlf
	sqlStr = sqlStr & " and sitegubun='" & COtherSiteFlag & "'"
	rsget.Open sqlStr, dbget, 1

	if Not rsget.Eof then
		SiteConfirmExistes = true
	end if
	rsget.Close
	
	if (SiteConfirmExistes) then
	    sqlStr = "update db_user.dbo.tbl_user_allow_site" & VbCrlf
	    sqlStr = sqlStr & " set siteusing='" & allow_other & "'" & VbCrlf
	    if (allow_other="Y") then
	        sqlStr = sqlStr & " ,allowdate=IsNULL(allowdate,getdate())"
	    else
	        sqlStr = sqlStr & " ,disallowdate=IsNULL(disallowdate,getdate())"
	    end if
	    sqlStr = sqlStr & " where userid='" & userid & "'" & VbCrlf
	    sqlStr = sqlStr & " and sitegubun='" & COtherSiteFlag & "'"
	    
	    dbget.Execute sqlStr
	else
	    if (allow_other="Y") then
    	    sqlStr = "insert into db_user.dbo.tbl_user_allow_site" & VbCrlf
    	    sqlStr = sqlStr + " (userid, sitegubun, siteusing, allowdate)"
            sqlStr = sqlStr + " values("
            sqlStr = sqlStr + " '" & userid & "'"
            sqlStr = sqlStr + " ,'" & COtherSiteFlag & "'"
            sqlStr = sqlStr + " ,'Y'"
            sqlStr = sqlStr + " ,getdate()"
            sqlStr = sqlStr + " )"
            
            dbget.Execute sqlStr
        else
            sqlStr = "insert into db_user.dbo.tbl_user_allow_site" & VbCrlf
    	    sqlStr = sqlStr + " (userid, sitegubun, siteusing, disallowdate)"
            sqlStr = sqlStr + " values("
            sqlStr = sqlStr + " '" & userid & "'"
            sqlStr = sqlStr + " ,'" & COtherSiteFlag & "'"
            sqlStr = sqlStr + " ,'N'"
            sqlStr = sqlStr + " ,getdate()"
            sqlStr = sqlStr + " )"
            
            dbget.Execute sqlStr
        end if
	end if
	
	
	'####### POINT1010 에서 넘어온거 데이터 UPDATE #######
	If pFlag = "o" Then
		Dim vPoint1010UserSeq, vEmailPoint1010, vSMSPoint1010
		vPoint1010UserSeq	= requestCheckVar(request.Form("point1010_userseq"),10)
		vEmailPoint1010		= requestCheckVar(request.Form("email_point1010"),1)
		vSMSPoint1010		= requestCheckVar(request.Form("smsok_point1010"),1)
		sqlStr = "UPDATE [db_shop].[dbo].tbl_total_shop_user SET EmailYN = '" & vEmailPoint1010 & "', SMSYN = '" & vSMSPoint1010 & "' WHERE UserSeq = '" & vPoint1010UserSeq & "'"
		dbget.Execute sqlStr
	End If
	'####### POINT1010 에서 넘어온거 데이터 UPDATE #######

	'쿠키 정보 수정
	response.Cookies("uinfo").domain = "10x10.co.kr"
	response.Cookies("uinfo")("musername") = username

	''2018/08/15 쿠키세션변경
	if (session("ssnusername")<>username) then
    	session("ssnusername") = username
    	Call fnEtcSessionChangedToDBSessionUpdate()
    end if

	'수정로그 저장
	Call saveUpdateLog(userid, "I")

	'카카오톡 휴대폰 변경 확인 ajaxCheckConfirmSMS.asp 에서 함
	'Call fnKakaoChkModiClear(usercell)

end if


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

'// 정보수정 로그 기록(2010.06.25; 허진원)
Sub saveUpdateLog(uid,udiv)
	dim strSql
	strSql = "insert into db_log.dbo.tbl_user_updateLog (userid,updateDiv,siteDiv,refIP) values " &_
			" ('" & uid & "'" &_
			", '" & udiv & "', 'M'" &_
			", '" & Left(request.ServerVariables("REMOTE_ADDR"),32) & "')"
	dbget.Execute strSql
end Sub

'// 회원정보 수정후에는 다시 수정페이지로 진입할 수 있도록 세션 설정
Session("InfoConfirmFlag") = userid
%>
<script language='javascript'>
    alert('수정 되었습니다.');
    <% If pFlag = "o" Then %>
    	location.replace('<%= M_SSLUrl %>/my10x10/userinfo/membermodify.asp?pflag=g');
    <% Else %>
    	location.replace('<%= M_SSLUrl %>/my10x10/userinfo/membermodify.asp');
	<% End If %>
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->