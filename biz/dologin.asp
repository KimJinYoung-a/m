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
dim ouser
dim userid, userpass, backpath
dim strGetData, strPostData
dim isupche
dim isopenerreload,blnclose
dim snsisusing, snsid, snsgubun, snsusermail, snslogin, snsjoingubun, sns_sexflag

blnclose		= requestCheckVar(Request("blnclose"),2)
userid 		= requestCheckVar(request("userid"),32)
userpass 	= requestCheckVar(request("userpass"),32)

backpath 		= ReplaceRequestSpecialChar(request("backpath"))
strGetData  	= ReplaceRequestSpecialChar(request("strGD"))
strPostData 	= ReplaceRequestSpecialChar(request("strPD"))

if strGetData <> "" then backpath = backpath&"?"&strGetData
if backpath =""  then blnclose ="Y"

dim referer, ssnlogindt
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

ouser.BizLoginProc

if (ouser.IsPassOk) then

	Dim iCookieDomainName : iCookieDomainName = GetCookieDomainName

	response.Cookies("uinfo").domain = iCookieDomainName
	response.cookies("uinfo")("shix") = HashTenID(ouser.FOneUser.FUserID)
    response.Cookies("etc").domain = iCookieDomainName
    response.cookies("etc")("mcouponCnt") = ouser.FOneUser.FCouponCnt
    response.cookies("etc")("mcurrentmile") = ouser.FOneUser.FCurrentMileage
	response.cookies("etc")("currtencash") = ouser.FOneUser.FCurrentTenCash
	response.cookies("etc")("currtengiftcard") = ouser.FOneUser.FCurrentTenGiftCard
    response.cookies("etc")("cartCnt") = ouser.FOneUser.FBaguniCount
    response.Cookies("etc")("ordCnt") = ouser.FOneUser.ForderCount		'201409 추가 최근주문/배송수
    response.Cookies("etc")("musericonNo") = ouser.FOneUser.FUserIconNo
    response.Cookies("etc")("logindate") = now()

	'' 2018/08/15 TenSessionLib    ===============================
	ssnlogindt = fnDateTimeToLongTime(now())
	response.Cookies("mssn").domain = iCookieDomainName
    response.Cookies("mssn")("ssndt") = ssnlogindt
    response.cookies("mssn")("shix") = HashTenID(ouser.FOneUser.FUserID) '' 불필요.

    Call set_cookie_secure("CHKSESSION", Left(Now(), 10), "/", 24)

	session("ssnuserid")  = LCase(ouser.FOneUser.FUserID)
    session("ssnlogindt") = ssnlogindt
    session("ssnlastcheckdt") = ssnlogindt

	session("ssnusername") 	= ouser.FOneUser.FUserName
	session("ssnuserdiv") 	= ouser.FOneUser.FUserDiv
	session("ssnuserlevel")	= CStr(ouser.FOneUser.FUserLevel)
	session("ssnrealnamecheck")	= ouser.FOneUser.FRealNameCheck
	session("ssnuseremail")	= ouser.FOneUser.FUserEmail
    session("ssnuserbizconfirm") = ChkIif(CStr(ouser.FOneUser.FUserLevel)="7", "Y", ouser.FOneUser.FBizConfirm)

	session("appboySession") = ouser.FOneUser.FUserSeq
    response.Cookies("appboy")("userlevel") = "biz"

	Dim isSSnLongKeep : isSSnLongKeep = 0  '' 값이 1이면 길게 유지
    Dim retSsnHash
	if (request("saved_auto") = "o") then isSSnLongKeep=1

	retSsnHash = fnDBSessionCreateV2("M",isSSnLongKeep)  ''2018/08/07
	if (isSSnLongKeep>0) then
		response.cookies("mssn").Expires = Date + 15
		response.Cookies("mssn")("dtauto") = ssnlogindt					''2018/08/19
	end if
	response.Cookies("mssn")("ssnhash") = retSsnHash
	session("ssnhash") = retSsnHash
	'' ============================================================

    '####### 로그인 로그 저장
    Call MLoginLogSave(userid,"Y","ten_m",flgDevice)

    '###### 실패로그 정리
    if chkLoginFailCnt>0 then Call ClearLoginFailInfo(userid)
    Session.Contents.Remove("chkLoginLock")		'계정중지 리셋

end if

if (ouser.IsPassOk) then
	set ouser = Nothing
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
