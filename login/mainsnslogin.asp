<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
dim snsdivgb, pggb, snsbackpath, snsjoingubun
snsdivgb			= requestCheckVar(request("snsdiv"),2)
pggb			= requestCheckVar(request("pggb"),2)
snsbackpath 	= ReplaceRequestSpecialChar(request("snsbackpath"))
snsjoingubun	= requestCheckVar(request("snsjoingubun"),2)

dim strGetData, strPostData, snsitemid
strGetData		= ReplaceRequestSpecialChar(request("strGD"))
strPostData	= ReplaceRequestSpecialChar(request("strPD"))
snsitemid		= requestCheckvar(request("itemid"),9)

session("snsParam") = pggb	'id-기본로그인, my-마이페이지, mc-개인정보수정확인
session("snsgbParam") = snsdivgb	'nv-네이버, fb-페이스북, ka-카카오, gl-구글
session("snsbackpath") = snsbackpath
session("snsjoingubun") = snsjoingubun	'로그인쪽인지 회원가입(ji)쪽인지

session("isopenerreload") = "on"
session("strGD") = strGetData
session("strPD") = strPostData
session("snsitemid") = snsitemid

''예외처리
''-------
dim vNaverLoginUrl, vNvClientId, vNvRdtUrl, vNvState
randomize
'vNvState = "RAMDOM_STATE"
vNvState =  Int(Rnd * 1000000)
vNvRdtUrl = server.URLEncode(M_SSLUrl&"/login/snslogin.asp")

Select Case snsdivgb
	Case "nv"
		vNvClientId = "bI8tkz5b5W5IdMPD3_AN"		''테스트용 네이버앱id : 4xjaEZMGAoiudDSz06d9
		vNaverLoginUrl = "https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=" & vNvClientId & "&redirect_uri=" & vNvRdtUrl & "&state=" & vNvState
	Case "ka"
		If application("Svr_Info")="Dev" Then
			vNvClientId = "63d2829d10554cdd7f8fab6abde88a1a"		
		Else
			vNvClientId = "de414684a3f15b82d7b458a1c28a29a2"
		End If
		vNaverLoginUrl = "https://kauth.kakao.com/oauth/authorize?client_id=" & vNvClientId & "&redirect_uri="& vNvRdtUrl&"&response_type=code&state="&vNvState
	Case "gl"
		vNvClientId = "614712658656-s78hbq7158i9o92f57dnoiq9env0cd9q.apps.googleusercontent.com"
'		vNaverLoginUrl = "https://accounts.google.com/o/oauth2/auth?client_id=" & vNvClientId & "&redirect_uri="& vNvRdtUrl&"&response_type=code&state="&vNvState&"&scope=email profile&"
		vNaverLoginUrl = "https://accounts.google.com/o/oauth2/v2/auth?client_id=" & vNvClientId & "&redirect_uri="& vNvRdtUrl&"&response_type=code&state="&vNvState&"&scope=https://www.googleapis.com/auth/plus.me https://www.googleapis.com/auth/plus.profile.emails.read profile https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/userinfo.profile&"
	Case "fb"
		vNvClientId = "687769024739561"
		vNaverLoginUrl = "https://www.facebook.com/v2.9/dialog/oauth?scope=email&display=popup&client_id=" & vNvClientId & "&redirect_uri="& vNvRdtUrl
	case else
		Response.Write "<script type=""text/javascript"">alert('잘못된 접속 입니다.');window.close();</script>"
		response.end
End Select

response.Redirect(vNaverLoginUrl)
%>
