<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

'#######################################################
'	History	: 2021.07.01 정태훈 생성
'	Description : Biz회원 회원정보 수정 처리
'#######################################################
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
dim orgCell, orgEmail, orgEmailok, isEmailChk, orgSmsok

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

emailok     = requestCheckVar(request.Form("email_10x10"),9)
smsok           = requestCheckVar(request.Form("smsok"),9)

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

dim sqlStr, opass
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
    
	if (Enc_userpass64<>Enc_Old_userpass64)  then    '' 암호화 사용(SHA256)
		response.write "<script>alert('기존 비밀번호가 일치하지 않습니다.');</script>"
		response.write "<script>history.back();</script>"
		response.end
	end if

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

    '// 회원 기존 휴대폰번호, 이메일 정보 조회 & 변경되었다면 승인여부 N로 수정
    sqlStr = "SELECT c.soccell, c.socmail, ci.emailok, ci.smsok "
    sqlStr = sqlStr + " FROM [db_user].[dbo].[tbl_user_c] c "
    sqlStr = sqlStr + " INNER JOIN [db_user].[dbo].[tbl_user_c_addInfo] ci ON c.userid = ci.userid "
    sqlStr = sqlStr + " WHERE c.userid='" + userid + "'"
    rsget.Open sqlStr, dbget, 1
    If Not rsget.Eof Then
		orgCell = rsget("soccell")
		orgEmail = rsget("socmail")
        orgEmailok = rsget("emailok")
        orgSmsok = rsget("smsok")

        If orgCell <> usercell Then
            isMobileChk = "N"
        End If
        If orgEmail <> useremail Then
            isEmailChk = "N"
        End If
    Else
        Response.Write "<script>alert('해당 유저 정보가 존재하지 않습니다.');</script>"
		Response.Write "<script>history.back();</script>"
		Response.End
	End If
	rsget.Close

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

    '// 회원정보(tbl_user_c) 수정
    sqlStr = "UPDATE [db_user].[dbo].[tbl_user_c] SET" + VbCrlf
	sqlStr = sqlStr + "  prcname = '" + username + "'" + VbCrlf
	sqlStr = sqlStr + " ,socmail = '" + useremail + "'"  + VbCrlf
	sqlStr = sqlStr + " WHERE userid='" + userid + "'"
	dbget.Execute sqlStr

    '// 회원정보(tbl_user_c_addInfo) 수정
    sqlStr = "UPDATE [db_user].[dbo].[tbl_user_c_addInfo] SET" + VbCrlf
	sqlStr = sqlStr + "  zipcode='" + zipcode + "'"  + VbCrlf
	sqlStr = sqlStr + " ,zipaddr='" + addr1 + "'"  + VbCrlf
	sqlStr = sqlStr + " ,useraddr='" + addr2 + "'"  + VbCrlf
    sqlStr = sqlStr + " ,userphone = '" + userphone + "'"  + VbCrlf
    If isEmailChk = "N" Then
	    sqlStr = sqlStr + " ,isEmailChk='N', isEmailChkdate = null"  + VbCrlf
    End If
    If isMobileChk = "N" Then
	    sqlStr = sqlStr + " ,isMobileChk='N', isMobileChkdate = null"  + VbCrlf
    End If
	sqlStr = sqlStr + " ,emailok='" + emailok + "'"  + VbCrlf
    If emailok <> orgEmailok Then '// 이메일 수신여부 변경 시 변경일시 저장
        sqlStr = sqlStr + " ,emaildate=GETDATE()"  + VbCrlf
    End If
	sqlStr = sqlStr + " ,smsok='" + smsok + "'"  + vbcrlf
    If smsok <> orgSmsok Then '// sms 수신여부 변경 시 변경일시 저장
        sqlStr = sqlStr + " ,smsokdate=GETDATE()"  + VbCrlf
    End if
	sqlStr = sqlStr + " where userid='" + userid + "'"
	dbget.Execute sqlStr

	''2018/08/15 쿠키세션변경
	if (session("ssnusername")<>username) then
    	session("ssnusername") = username
    	Call fnEtcSessionChangedToDBSessionUpdate()
    end if

	'수정로그 저장
	Call saveUpdateLog(userid, "I")

end if

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
   	location.replace('<%= M_SSLUrl %>/biz/membermodify.asp');
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->