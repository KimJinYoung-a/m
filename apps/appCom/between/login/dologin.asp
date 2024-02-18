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
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/memberlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/classes/membercls/userloginclass.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim ouser
dim userid, userpass, backpath
dim isupche
dim isopenerreload,blnclose

userid 		= requestCheckVar(request("userid"),32)
userpass 	= requestCheckVar(request("userpass"),32)

backpath 		= ReplaceRequestSpecialChar(request("backpath"))

set ouser = new CTenUser
ouser.FRectUserID = userid
ouser.FRectPassWord = userpass
ouser.LoginProc

dim referer
referer = request.ServerVariables("HTTP_REFERER")


if (ouser.IsPassOk) then
	dim vTenId, vTenLv
	vTenId = ouser.FOneUser.FUserID
	vTenLv = ouser.FOneUser.FUserLevel
	
	'// 사용자 정보 저장
	Call fnUpdateTenUser(vTenId)

	session("tenUserid") = vTenId
	session("tenUserLv") = vTenLv

    '####### 로그인 로그 저장
    Call MLoginLogSave(vTenId,"Y","between",flgDevice)
end if

if (ouser.IsPassOk) then
	set ouser = Nothing
    Response.Write "<script type='text/javascript'>parent.location.reload();</script>"
    Response.End
elseif (ouser.IsRequireUsingSite) then
	set ouser = Nothing
    Response.Write "<script type='text/javascript'>alert('사용 중지하신 서비스 입니다.');</script>"
    Response.End
elseif ouser.FConfirmUser="X" then
	set ouser = Nothing
    response.write "<script type='text/javascript'>alert('사용이 일시정지된 아이디입니다.\n텐바이텐 고객센터(1644-6030)으로 연락주세요.');</script>"
elseif ouser.FConfirmUser="N" then
	set ouser = Nothing
    response.write "<script type='text/javascript'>alert('텐바이텐 가입 승인 대기중입니다.');</script>"
else
    '####### 로그인 로그 저장
    Call MLoginLogSave(userid,"N","between",flgDevice)

	set ouser = Nothing
	response.write "<script type='text/javascript'>alert('아이디가 없거나 잘못된 패스워드입니다.');</script>"
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->