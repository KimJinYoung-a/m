<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
response.charset = "utf-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
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
<%
''사용안함 2018/08/13
1=a 

dim ouser
dim userid, userpass, backpath
dim strGetData
dim isupche
dim isopenerreload

userid 		= requestCheckVar(request("userid"),32)
userpass 	= requestCheckVar(request("userpass"),32)

isopenerreload= request("isopenerreload")
backpath 		= ReplaceRequestSpecialChar(request("backpath"))
strGetData  	= ReplaceRequestSpecialChar(request("strGD"))

if strGetData <> "" then backpath = backpath&"?"&strGetData
	
set ouser = new CTenUser
ouser.FRectUserID = userid
ouser.FRectPassWord = userpass
ouser.LoginProc

if (ouser.IsPassOk) then

	response.Cookies("uinfo").domain = "10x10.co.kr"
	response.Cookies("uinfo")("muserid") = ouser.FOneUser.FUserID
	response.Cookies("uinfo")("musername") = ouser.FOneUser.FUserName
	response.Cookies("uinfo")("museremail") = ouser.FOneUser.FUserEmail
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
    
	if (ouser.FOneUser.FUserDiv="02") or (ouser.FOneUser.FUserDiv="03") or (ouser.FOneUser.FUserDiv="04") or (ouser.FOneUser.FUserDiv="05") or (ouser.FOneUser.FUserDiv="06") or (ouser.FOneUser.FUserDiv="07") or (ouser.FOneUser.FUserDiv="08") or (ouser.FOneUser.FUserDiv="19") or (ouser.FOneUser.FUserDiv="20")   then
		isupche = "Y"
	else
		isupche = "N"
	end if

	response.Cookies("uinfo")("misupche") = isupche

    '####### 로그인 로그 저장
    Call MLoginLogSave(userid,"Y","kakao_m",flgDevice)
end if

if (ouser.IsPassOk) then	

	set ouser = Nothing
	If (backpath = "") Then 
		backpath = wwwUrl &"/"
	End If 
	
	response.write "<script>parent.location.replace('" + backpath + "');</script>"
	''response.write "<script>location.replace('" + backpath + "');</script>"
	'''response.redirect(backpath)
	dbget.Close: response.end

elseif (ouser.IsRequireUsingSite) then
	set ouser = Nothing
    Call Alert_Move("사용 중지하신 서비스 입니다.","about:blank")
    Response.End

else
    '####### 로그인 로그 저장
    Call MLoginLogSave(userid,"N","kakao_m",flgDevice)
	set ouser = Nothing
	Call Alert_Move("죄송합니다.\n\n아이디와 비밀번호를 다시 확인해주세요.","about:blank")
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->