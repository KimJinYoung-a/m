<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/inc_const.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/util/jwtLib.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/authorize.asp
' Discription : 인증 토큰 생성
' Request : json > type, os, clientid, state
' Response : response > 결과, code, state
' History : 2017.06.01 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sFDesc, iErrCode
Dim sType, sOS, sUserID
Dim sAppKey, sState, sGubun, sAccToken, sRefToken, sIdToken, sDebugText
Dim sData : sData = Request.form("json")
Dim oJson

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sOS = requestCheckVar(oResult.os,8)
	sType = requestCheckVar(oResult.type,12)
	sAppKey = requestCheckVar(oResult.clientid,45)
	sState = requestCheckVar(oResult.state,32)

    if Not ERR THEN
		sGubun = requestCheckVar(oResult.gubun,2)
		sAccToken = requestCheckVar(oResult.actoken,512)
		sRefToken = requestCheckVar(oResult.rftoken,1200)
		sIdToken = requestCheckVar(oResult.idtoken,1200)
	    if ERR THEN Err.Clear ''회원id 프로토콜 없음
    END IF

set oResult = Nothing

''on Error Goto 0

'디버그 메시지
sDebugText = "param:"&sOS&sType&"|"&sAppKey&"|"&sState&"|"&sGubun&"|"&sAccToken&"|"&sRefToken&"|"&sIdToken

'// json객체 선언
Set oJson = jsObject()

If sType<>"gettoken" then
	'// 잘못된 콜싸인 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다.[E01]"
	oJson("errorcode") = 10001

elseif Not(sOS="ios" or sOS="android") then
	'// OS 파라메터 없음
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터 정보가 잘못됐습니다.[E02]"
	oJson("errorcode") = 10002

elseif sAppKey<>"NzVDOTNCQUQyRjUxNEMyNDAzNTkxNkU0ODdCODhCMDI" then
	
	'// API키 파라메터 없음
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다.[E03]"
	oJson("errorcode") = 10003

elseif sGubun="" then
	'// SNS 구분 파라메터 없음
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터 정보가 잘못됐습니다. 또는 버전이 낮습니다. [E04]"
	oJson("errorcode") = 10004

elseif sAccToken="" and sIdToken="" then
	'// SNS 토큰 파라메터 없음
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터 정보가 잘못됐습니다.[E05]"
	oJson("errorcode") = 10005

elseif Not(Err) then
	Dim jwt, oPayload, sPayload, oJrt
	Dim sKey, sToken, sChkTk, sErrMsg, sAPIRst, sAPIStat, sAPIData, sAccExpr
	dim client_id, client_secret, redirectURI
	redirectURI = M_SSLUrl&"/login/snslogin.asp"
	sChkTk = false
	iErrCode = 0

	'=========================================================
	'SNS 토큰 검증 처리
	'=========================================================
	Select Case lCase(sGubun)
		Case "nv"		'네이버
			client_id = "bI8tkz5b5W5IdMPD3_AN"
			client_secret = "Tlt0EEBPWo"

			sDebugText = sDebugText&",nvAPIcall:https://openapi.naver.com/v1/nid/me"
			'네이버 회원 정보 접수
			sAPIRst = fnCallAPI("https://openapi.naver.com/v1/nid/me","application/x-www-form-urlencoded","Bearer " & sAccToken, "", sAPIStat)

			if sAPIStat="200" then
				sDebugText = sDebugText&",nv200"
				sChkTk = true				
			elseif sAPIStat="401" and sRefToken<>"" then
				sDebugText = sDebugText&",nv401"
				'접근토큰 갱신 요청
				sAPIData = "grant_type=refresh_token&client_id=" & client_id & "&client_secret=" & client_secret & "&refresh_token=" & sRefToken
				sAPIRst = fnCallAPI("https://nid.naver.com/oauth2.0/token","application/x-www-form-urlencoded","", sAPIData, sAPIStat)

				if sAPIStat="200" then
					sDebugText = sDebugText&",nv200"
					Set oJrt = JSON.Parse(sAPIRst)
						sAccToken = oJrt.access_token
						sAccExpr = oJrt.expires_in
						sChkTk = true
					if err then
						sErrMsg = "네이버 인증에 실패했습니다. 다시 로그인해주세요."
						iErrCode = 21003
						sDebugText = sDebugText&",nvERR:"&sErrMsg&",nvResponseBody:"&sAPIRst
					end if
					
				else
					sErrMsg = "네이버 인증에 실패했습니다. 다시 로그인해주세요."
					iErrCode = 21002
					sDebugText = sDebugText&",nvERR:"&sErrMsg
				end if
			else
				sErrMsg = "네이버 인증에 실패했습니다. 다시 로그인해주세요."
				iErrCode = 21001

				sDebugText = sDebugText&",nvERR:"&sErrMsg
			end if

		Case "fb"		'페이스북
			client_id = "687769024739561"
			client_secret = "69f2a6ab39e64e3185e5c1c783617846"

			sDebugText = sDebugText&",fbAPIcall:https://graph.facebook.com/me"
			'페이스북 회원 정보 접수
			sAPIData = "fields=email"
			sAPIRst = fnCallAPI("https://graph.facebook.com/me","application/x-www-form-urlencoded","Bearer " & sAccToken, sAPIData, sAPIStat)

			if sAPIStat="200" then
				sDebugText = sDebugText&",fb200"
				sChkTk = true
			elseif sAPIStat="401" then				
				sErrMsg = "페이스북 인증이 만료되었습니다. 다시 로그인해주세요."
				iErrCode = 22001
				sDebugText = sDebugText&",fb401:"&sErrMsg
			else
				sErrMsg = "페이스북 인증에 실패했습니다. 다시 로그인해주세요."
				iErrCode = 22002
				sDebugText = sDebugText&",fbERR:"&sErrMsg
			end if


		Case "gl"		'구글
			client_id = "614712658656-s78hbq7158i9o92f57dnoiq9env0cd9q.apps.googleusercontent.com"
			client_secret = "ha-9fm6gR4iLf4VuWglsP0Vz"

			'구글 회원 정보 접수
			if sIdToken<>"" then
				sDebugText = sDebugText&",glAPIcall:https://www.googleapis.com/oauth2/v3/tokeninfo"
				sAPIData = "id_token=" & sIdToken
				sAPIRst = fnCallAPI("https://www.googleapis.com/oauth2/v3/tokeninfo","application/x-www-form-urlencoded","", sAPIData, sAPIStat)
			else
				sDebugText = sDebugText&",glAPIcall:https://www.googleapis.com/oauth2/v1/tokeninfo"
				sAPIData = "access_token=" & sAccToken
				sAPIRst = fnCallAPI("https://www.googleapis.com/oauth2/v1/tokeninfo","application/x-www-form-urlencoded","Bearer " & sAccToken, sAPIData, sAPIStat)
			end if

			if sAPIStat="200" then
				sDebugText = sDebugText&",gl200"
				sChkTk = true
			elseif sAPIStat="401" then
				sDebugText = sDebugText&",gl401"
				'접근토큰 갱신 요청
				sAPIData = "grant_type=refresh_token&client_id=" & client_id & "&client_secret=" & client_secret & "&refresh_token="& sRefToken
				sAPIRst = fnCallAPI("https://www.googleapis.com/oauth2/v4/token","application/x-www-form-urlencoded","", sAPIData, sAPIStat)

				if sAPIStat="200" then
					sDebugText = sDebugText&",gl200"
					Set oJrt = JSON.Parse(sAPIRst)
						sAccToken = oJrt.access_token
						sAccExpr = oJrt.expires_in
						sChkTk = true
					if err then						
						sErrMsg = "구글 인증에 실패했습니다. 다시 로그인해주세요."
						iErrCode = 23003
						sDebugText = sDebugText&",glERR:"&sErrMsg&",glResponseBody:"&sAPIRst
					end if
					
				else					
					sErrMsg = "구글 인증에 실패했습니다. 다시 로그인해주세요."
					iErrCode = 23002
					sDebugText = sDebugText&",glERR:"&sErrMsg
				end if
			else
				'sErrMsg = "구글 인증에 실패했습니다. 다시 로그인해주세요."
				'iErrCode = 23001
				'sDebugText = sDebugText&",glERR:"&sErrMsg&",glAPIState:"&sAPIStat&",glResponseBody:"&sAPIRst
				'구글API Error 임시 확인용 메일 발송 코드
				'Call Err.Raise(60001, "api status error", "google tokeninfo api error")
				sChkTk = true
			end if
			
		Case "ka"		'카카오톡
			if application("Svr_Info")="Dev" Then
				client_id = "63d2829d10554cdd7f8fab6abde88a1a"
				client_secret = "oS4jNWkySRuGJzSTun4TcbBb8OjsTPIB"			
				sDebugText = sDebugText&",kaAPIcall:https://kapi.kakao.com/v2/user/me"
				'카카오 회원 정보 접수
				sAPIRst = fnCallAPI("https://kapi.kakao.com/v2/user/me","application/x-www-form-urlencoded","Bearer " & sAccToken, "", sAPIStat)				
			Else
				client_id = "de414684a3f15b82d7b458a1c28a29a2"
				client_secret = "IRgr5zxQEuS4uABqV30k6lik94qlk3PF"
				sDebugText = sDebugText&",kaAPIcall:https://kapi.kakao.com/v2/user/me"
				'카카오 회원 정보 접수
				sAPIRst = fnCallAPI("https://kapi.kakao.com/v2/user/me","application/x-www-form-urlencoded","Bearer " & sAccToken, "", sAPIStat)				
			End If


			if sAPIStat="200" then
				sDebugText = sDebugText&",ka200"
				sChkTk = true
			elseif sAPIStat="401" then
				sDebugText = sDebugText&",ka401"
				'접근토큰 갱신 요청
				sAPIData = "grant_type=refresh_token&client_id=" & client_id & "&client_secret=" & client_secret & "&refresh_token="& sRefToken
				sAPIRst = fnCallAPI("https://kauth.kakao.com/oauth/token","application/x-www-form-urlencoded","", sAPIData, sAPIStat)

				if sAPIStat="200" then
					sDebugText = sDebugText&",ka200"
					Set oJrt = JSON.Parse(sAPIRst)
						sAccToken = oJrt.access_token
						sAccExpr = oJrt.expires_in
						sChkTk = true
					if err then						
						sErrMsg = "카카오 인증에 실패했습니다. 다시 로그인해주세요."
						iErrCode = 24003
						sDebugText = sDebugText&",kaERR:"&sErrMsg&",kaResponseBody:"&sAPIRst
					end if
					
				else
					sErrMsg = "카카오 인증에 실패했습니다. 다시 로그인해주세요."
					iErrCode = 24002
					sDebugText = sDebugText&",kaERR:"&sErrMsg
				end if
			else
				sErrMsg = "카카오 인증에 실패했습니다. 다시 로그인해주세요."
				iErrCode = 24001
				sDebugText = sDebugText&",kaERR:"&sErrMsg
			end if

		Case "ap"		'애플
			sDebugText = sDebugText&",ap200"
			sChkTk = true

		Case else
			sErrMsg = "잘못된 접근입니다.[E06]"
			iErrCode = 10006
			sDebugText = sDebugText&",apERR:"&sErrMsg
	End Select



	if sChkTk then
		'=========================================================
		'// JWT 토큰키 !!!
		sKey = "ThBxhdcEeCThSeJNSkJAwYRkbYSMkSwtELmScn"
		'=========================================================

		'// JWT 객체 선언
		Set jwt = new cJwt

		'Payload 생성
		set oPayload = jsObject()
			oPayload("iss") = "10x10.co.kr"
			oPayload("jti") = UniqueString
			oPayload("exp") = SecsSinceEpoch + (60*5)		'만료시간 +5분
			oPayload("iat") = SecsSinceEpoch
			oPayload("state") = cStr(sState)
			sPayload = oPayload.jsString
		set oPayload = Nothing

		sDebugText = sDebugText&",jwtCreate"
		'// 토큰 생성
		sToken = jwt.encode(sPayload,sKey)

		sDebugText = sDebugText&",jsonCreate"
		'// 결과데이터 생성
		oJson("response") = getErrMsg("1000",sFDesc)
		oJson("code") = cStr(sToken)
		oJson("state") =  cStr(sState)
		oJson("gubun") =  cStr(sGubun)
		oJson("actoken") =  cStr(sAccToken)

	else
		sDebugText = sDebugText&",snsTokenFail"
		'SNS 토큰 검증 인증 실패		
		oJson("response") = getErrMsg("9999",sFDesc)
		oJson("faildesc") = cStr(sErrMsg)
		oJson("errorcode") = iErrCode
	end if

end if

IF (Err) then
	sDebugText = sDebugText&",applicationERR"
	Set oJson = jsObject()
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
	oJson("errorcode") = 90000
End if

if ERR then Call OnErrNotiImsi(sDebugText)		'// 오류 이메일로 발송

On Error Goto 0

'// API Call
function fnCallAPI(sUrl, sContTp, sAuth, sData, byRef sStat)
	Dim xml
	set xml = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
	xml.open "POST", sUrl, false
	if sContTp<>"" then xml.setRequestHeader "Content-Type", sContTp
	if sAuth<>"" then xml.SetRequestHeader "Authorization", sAuth
	xml.send sData

	sStat = xml.Status
	fnCallAPI = xml.responseText

	set xml = Nothing
end function

function OnErrNotiImsi(sEtcMessage)
    Const lngMaxFormBytes = 800
    dim strServerIP
    dim errDescription, errSource
    dim strMethod,datNow

    errDescription = ERR.Description
    errSource =  "["&ERR.Number&"]"&ERR.Source

	strServerIP = Request.ServerVariables("LOCAL_ADDR")

    dim strMsg : strMsg=""

    strMsg = strMsg & "errDescription: "&errDescription&"<br>"
    strMsg = strMsg & "errSource: "&errSource&"<br><br>"

	strMsg = strMsg & "debugText: "&sEtcMessage&"<br><br>"

    strMsg = strMsg & "<li>서버:<br>"
	strMsg = strMsg & application("Svr_Info") & ":"&strServerIP
	strMsg = strMsg & "<br><br></li>"

	'// 접속자 브라우저 정보
	strMsg = strMsg & "<li>브라우저 종류:<br>"
	strMsg = strMsg & Server.HTMLEncode(Request.ServerVariables("HTTP_USER_AGENT"))
	strMsg = strMsg & "<br><br></li>"

	strMsg = strMsg & "<li>접속자 IP:<br>"
	strMsg = strMsg & Server.HTMLEncode(Request.ServerVariables("REMOTE_ADDR"))
	strMsg = strMsg & "<br><br></li>"

	strMsg = strMsg & "<li>경유페이지:<br>"
	strMsg = strMsg & request.ServerVariables("HTTP_REFERER")
	strMsg = strMsg & "<br><br></li>"

	'// 오류 페이지 정보
	strMsg = strMsg & "<li>페이지:<br>"
	strMethod = Request.ServerVariables("REQUEST_METHOD")
	strMsg = strMsg & "HOST : " & Request.ServerVariables("HTTP_HOST") & "<BR>"
	strMsg = strMsg & strMethod & " : "

	If strMethod = "POST" Then
		strMsg = strMsg & Request.TotalBytes & " bytes to "
	End If

	strMsg = strMsg & Request.ServerVariables("SCRIPT_NAME")
	strMsg = strMsg & "</li>"

	If strMethod = "POST" Then
		strMsg = strMsg & "<br><li>POST Data:<br>"

		'실행에 관련된 에러를 출력합니다.
		If Request.TotalBytes > lngMaxFormBytes Then
			strMsg = strMsg & Server.HTMLEncode(Left(Request.Form, lngMaxFormBytes)) & " . . ."'
		Else
			strMsg = strMsg & Server.HTMLEncode(Request.Form)
		End If
		strMsg = strMsg & "</li>"
	elseif strMethod = "GET" then
		strMsg = strMsg & "<br><li>GET Data:<br>"
		strMsg = strMsg & Request.QueryString
	End If
	strMsg = strMsg & "<br><br></li>"

	'// 오류 발생시간 정보
	strMsg = strMsg & "<li>시간:<br>"
	datNow = Now()
	strMsg = strMsg & Server.HTMLEncode(FormatDateTime(datNow, 1) & ", " & FormatDateTime(datNow, 3))
	on error resume next
		Session.Codepage = bakCodepage
	on error goto 0
	strMsg = strMsg & "<br><br></li>"


    '### 시스템팀 구성원에게 오류 발생 내용 발송 ###
	dim cdoMessage,cdoConfig
	Set cdoConfig = CreateObject("CDO.Configuration")

    '-> 서버 접근방법을 설정합니다
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 '1 - (cdoSendUsingPickUp)  2 - (cdoSendUsingPort)
	'-> 서버 주소를 설정합니다
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")="110.93.128.94"
	'-> 접근할 포트번호를 설정합니다
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
	'-> 접속시도할 제한시간을 설정합니다
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 30
	'-> SMTP 접속 인증방법을 설정합니다
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
	'-> SMTP 서버에 인증할 ID를 입력합니다
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "MailSendUser"
	'-> SMTP 서버에 인증할 암호를 입력합니다
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "wjddlswjddls"
	cdoConfig.Fields.Update

	Set cdoMessage = CreateObject("CDO.Message")
	Set cdoMessage.Configuration = cdoConfig

	cdoMessage.To 		= "kobula@10x10.co.kr;skyer9@episode.co.kr;kjy8517@10x10.co.kr;tozzinet@10x10.co.kr;thensi7@10x10.co.kr;cjw0515@10x10.co.kr;errmail@10x10.co.kr"
	cdoMessage.From 	= "webserver@10x10.co.kr"
	cdoMessage.SubJect 	= "["&date()&"] App 페이지 오류 발생"
	cdoMessage.HTMLBody	= strMsg

	cdoMessage.BodyPart.Charset="ks_c_5601-1987"         '/// 한글을 위해선 꼭 넣어 주어야 합니다.
    cdoMessage.HTMLBodyPart.Charset="ks_c_5601-1987"     '/// 한글을 위해선 꼭 넣어 주어야 합니다.

	cdoMessage.Send

	Set cdoMessage = nothing
	Set cdoConfig = nothing

end function

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->