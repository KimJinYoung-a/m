<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : 나의정보
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/apps/appcom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim userid, userpass, vParam, sqlStr, checkedPass, userdiv, Enc_userpass, Enc_userpass64
	userid = getEncLoginUserID
	userpass = requestCheckVar(request.form("userpass"),32)

''개인정보보호를 위해 패스워드로 한번더 Check
checkedPass = false

'''if (Session("InfoConfirmFlag")<>userid) then
''패스워드없이 쿠키로만 들어온경우
if (userpass="") then
	response.redirect M_SSLUrl & "/apps/appcom/wish/web2014/my10x10/userinfo/confirmuser.asp"
    response.end    
end if

Enc_userpass = MD5(CStr(userpass))
Enc_userpass64 = SHA256(MD5(CStr(userpass)))

''비암호화
''sqlStr = "select userid, IsNULL(userdiv,'02') as userdiv from [db_user].[dbo].tbl_logindata where userid='" & userid & "' and userpass='" & userpass & "'"

''암호화 사용(MD5)
''sqlStr = "select userid, IsNULL(userdiv,'02') as userdiv from [db_user].[dbo].tbl_logindata where userid='" & userid & "' and Enc_userpass='" & Enc_userpass & "'"

''암호화 사용(SHA256)
sqlStr = "select userid, IsNULL(userdiv,'02') as userdiv from [db_user].[dbo].tbl_logindata where userid='" & userid & "' and Enc_userpass64='" & Enc_userpass64 & "'"

rsget.Open sqlStr, dbget, 1
if Not rsget.Eof then
    checkedPass = true
    userdiv = rsget("userdiv")
end if
rsget.close

''패스워드올바르지 않음
if (Not checkedPass) then
    response.redirect M_SSLUrl & "/apps/appcom/wish/web2014/my10x10/userinfo/confirmuser.asp?errcode=1"
    response.end
end if

''업체인경우 수정 불가
if (userdiv="02") or (userdiv="03") then
    response.write "<script>alert('업체 및 기타권한은 이곳에서 수정하실 수 없습니다.');history.back();</script>"
    response.end
end if

''아이디조정, 비밀번호저장
If request("saved_id") = "o" Then
	response.cookies("SAVED_ID") = tenEnc(userid)
Else
	response.cookies("SAVED_ID") = ""
End If
If request("saved_pw") = "o" Then
	response.cookies("SAVED_PW") = tenEnc(userpass)
Else
	response.cookies("SAVED_PW") = ""
End If

'// 세션처리후 회원정보 수정 페이지로 GoGo!
Session("InfoConfirmFlag") = userid
'//세션이 안먹는경우;;
response.Cookies("uinfo").domain = "10x10.co.kr"
response.Cookies("uinfo")("EcChk") = TenEnc(userid)    
response.redirect M_SSLUrl & "/apps/appcom/wish/web2014/my10x10/userinfo/membermodify.asp"
response.end
'''end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->