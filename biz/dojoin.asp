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
' Description : biz 회원가입
' History : 2021.06.30 정태훈 생성
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

'// 사업자 번호 검증 Function
Function checkSocnum(socnum)
    Dim keyArr, key, number, socnoChk, i, j
    Dim numberArr(10)
    keyArr = Array(1, 3, 7, 1, 3, 7, 1, 3, 5)
    number = Replace(socnum, "-", "")
    socnoChk = 0

    If( Len(number) <> 10 ) Then
        checkSocnum = "N"
        Exit Function
    End If

    For i = 1 To Len(number)
        numberArr(i-1) = CInt(Mid(number, i, 1))
    Next
    For j = 0 To UBound(keyArr)
        socnoChk = socnoChk + ( keyArr(j) * numberArr(j) )
    Next
    socnoChk = socnoChk + Fix((keyArr(8) * numberArr(8))/10)

    checkSocnum = ChkIIF(numberArr(9) = ((10 - (socnoChk mod 10)) mod 10), "Y", "N")
End Function
'==============================================================================
'파라미터 세팅

dim hideventid
dim txuserid, txpass1, txJumin1, txJumin2, emailok, crtfyNo, chkStat
dim txName, txSex, txCell1, txCell2, txCell3, txCell
dim email_way2way, email_10x10
dim smsok, smsok_fingers, socno, socname, soccell
dim tenbytenid

hideventid      = requestCheckVar(request.form("hideventid"),32)
txuserid        = requestCheckVar(request.form("txuserid"),32)
txpass1         = requestCheckVar(request.form("txpass1"),32)

email_way2way   = requestCheckVar(request.form("email_way2way"),9)
email_10x10     = requestCheckVar(request.form("email_10x10"),9)
smsok           = requestCheckVar(request.form("smsok"),9)
smsok_fingers   = requestCheckVar(request.form("smsok_fingers"),9)

txName			= requestCheckVar(html2db(trim(request.form("txName"))),32)
txSex			= requestCheckVar(trim(request.form("txSex")),1)

txCell1			= requestCheckVar(html2db(request.form("txCell1")),4)
txCell2			= requestCheckVar(html2db(request.form("txCell2")),4)
txCell3			= requestCheckVar(html2db(request.form("txCell3")),4)
txCell			= requestCheckVar(html2db(request.form("txCell")),13)
soccell      = txCell

chkStat			= requestCheckVar(Request.form("chkFlag"),1)
crtfyNo 		= requestCheckVar(Request.form("crtfyNo"),6)		' 휴대폰에 전송된 인증키

'biz 사업자번호, 사업자명 폼 추가
socno = requestCheckVar(request.form("socno"),12)
If checkSocnum(socno) <> "Y" Then
    Response.Write "<script>alert('잘못된 사업자번호입니다.');history.back();</script>"
    Response.End
End If
socname = requestCheckVar(request.form("socname"),32)

'==============================================================================
dim usermail, birthday, refip, sitegubun
dim Enc_userpass, Enc_userpass64

usermail = requestCheckVar(html2db(request.form("usermail")),128)
usermail = LeftB(usermail,128)
birthday = "1900-01-01"
if email_10x10 <>"Y" then email_10x10 = "N"
if smsok<>"Y" then smsok = "N"
if smsok_fingers<>"Y" then smsok_fingers = "N"

if (email_10x10="Y") or (email_way2way="Y") then
    emailok = "Y"
else
    emailok = "N"
end if

refip = Left(request.ServerVariables("REMOTE_ADDR"),32)

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

sqlStr = "INSERT INTO [db_user].[dbo].[tbl_user_c] (userid, socno, socname, soccell, birthday, socmail, prcname, regdate, isb2b, userdiv, socname_kor, coname) " + vbCrlf
sqlStr = sqlStr + "VALUES ('" + txuserid + "', '" + socno + "', '" + socname + "', '" + soccell + "', '" + CStr(birthday) + "', '" + usermail + "', '" + txName + "', GETDATE(), 'Y', '09', '" + socname + "', '" + socname + "')"
dbget.execute(sqlStr)

If Err.Number = 0 Then
        errcode = "002"
end if

sqlStr = "INSERT INTO [db_user].[dbo].[tbl_logindata] (userid, userpass, userdiv, userlevel, lastlogin, counter, lastrefip, Enc_userpass, Enc_userpass64) " + vbCrlf
sqlStr = sqlStr + " values('" + txuserid + "', '', '09', 9, getdate(), 0,'" + refip + "','','" + Enc_userpass64 + "')"
dbget.execute(sqlStr)

If Err.Number = 0 Then
        errcode = "003"
end if

sqlStr = "INSERT INTO [db_user].[dbo].[tbl_user_c_auth] (userid, socno, regdt, isconfirm, adminid) " + vbCrlf
sqlStr = sqlStr + " values('" + txuserid + "', '" + socno + "',GETDATE(), 'S', 'system')"
dbget.execute(sqlStr)

If Err.Number = 0 Then
    errcode = "004"
End if

sqlStr = "INSERT INTO [db_user].[dbo].[tbl_user_c_addinfo] "
sqlStr = sqlStr & " (userid, zipcode, useraddr, emailok, smsok, emaildate, smsokdate, isEmailChk, isMobileChk) "
sqlStr = sqlStr & " VALUES ('" & txuserid & "', '', '', '" & smsok & "', '" & email_10x10 & "', GETDATE(), GETDATE(), 'N', 'N') "
dbget.execute(sqlStr)

If Err.Number = 0 Then
    errcode = "005"
End if

'# 로그인 회원 로그인 회원구분 변경
If IsUserLoginOK Then
    response.Cookies("etc").domain = "10x10.co.kr"
    response.Cookies("etc")("ConfirmUser") = "Y"
End if

If Err.Number = 0 Then
    '// 처리 완료
    dbget.CommitTrans

    '# 세션에 아이디 저장
    Session("sUserid") = txuserid

    '#가입축하 메일 발송 아래로 이동
    IF (email_10x10="Y") then call SendMailNewUser(UserMail,txuserid)

    Response.Redirect(wwwUrl & "/biz/join_welcome.asp")

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