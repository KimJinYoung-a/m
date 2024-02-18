<%
'-----------------------------------------------------------------------
' 이벤트 전역변수 선언 (2007.02.07; 정윤정)
'-----------------------------------------------------------------------
 DIM CAddDetailSpliter : CAddDetailSpliter= CHR(3)&CHR(4)
 Dim NaverSCRIPT ''네이버 웹로그 관련 변수 선언
 Dim DaumSCRIPT	''다음 관련 변수 선언
 Dim RecoPickSCRIPT	''RecoPick 관련 변수 선언
 Dim facebookSCRIPT	''FaceBook 관련 변수 선언
 Dim googleADSCRIPT	''Google ADS 관련 변수 선언
 Dim GSShopSCRIPT	''GSShop WCS 관련 변수 선언
 Dim googleANAL_ADDSCRIPT ''Google analytics 관련 변수 선언
 Dim googleANAL_EXTSCRIPT ''Google analytics 관련 변수 선언 신규 GA관련
 Dim appBoyPurchasesLog	'' 앱보이 결제 로그관련 변수 선언
 Dim appBoyUserInfo	'' 앱보이 유저 기본정보
 Dim appBoyCustomUserInfo '' 앱보이 유저 커스텀정보
 Dim appBoyCustomEvent	''앱보이 CustomEvent 값 전송
 Dim kakaoAnal_AddScript ''Kakao Analytics 관련변수
 Dim dataDive_IniApiKey	''datadive용 initApiKey
 Dim CriteoUserMailMD5	''크리테오에 전송할 유저 이메일 MD5값

 Dim strHeadTitleName	'페이지 타이틀(상단 GNB 해더 타이틀)

 Dim staticImgUrl,uploadUrl,wwwUrl,SSLUrl,webImgUrl, webURL, web1URL, M_SSLUrl, testM_SSLUrl

Dim cFlgDBUse : cFlgDBUse = true		'페이지 내 DB사용 항목들의 표시(사용) 여부

 Dim DocSvrAddr, DocSvrPort, DocAuthCode , uploadImgUrl, staticImgUpUrl
 Dim G_IsLocalDev : G_IsLocalDev = False
 
 IF application("Svr_Info")="Dev" THEN
 	staticImgUrl	= "http://testimgstatic.10x10.co.kr"	'테스트
 	uploadUrl		= "http://testimgstatic.10x10.co.kr"
 	webImgUrl		= "http://testwebimage.10x10.co.kr"
 	wwwUrl			= "http://testm.10x10.co.kr"
 	SSLUrl			= "http://2015www.10x10.co.kr"
 	DocSvrAddr      = "61.252.133.4"
 	DocSvrPort      = "6167"
	uploadImgUrl    = "http://testupload.10x10.co.kr" 	
	webURL			= "http://2015www.10x10.co.kr"
	web1URL			= "http://2015www.10x10.co.kr"
	M_SSLUrl		= "https://testm.10x10.co.kr"			''모바일용 SSL URL
	testM_SSLUrl	= M_SSLUrl
	staticImgUpUrl	= "http://testimgstatic.10x10.co.kr"

	if (request.ServerVariables("LOCAL_ADDR")="::1") or (request.ServerVariables("LOCAL_ADDR")="127.0.0.1") then
        wwwUrl= ""
        SSLUrl =""
		M_SSLUrl =""
		testM_SSLUrl	= ""
        G_IsLocalDev = True
    end if
 ELSE
 	staticImgUrl	= "http://imgstatic.10x10.co.kr"
 	uploadUrl		= "http://upload.10x10.co.kr"
 	webImgUrl		= "http://webimage.10x10.co.kr"
 	wwwUrl			= "http://m.10x10.co.kr"
	SSLUrl			= "https://www.10x10.co.kr"
 	DocSvrAddr      = ""	'110.93.128.107
 	DocSvrPort      = ""
	uploadImgUrl    = "http://upload.10x10.co.kr"          '' upload.10x10.co.kr 통해서 Nas Server로 업로드 	
	webURL			= "http://www.10x10.co.kr"
	web1URL			= "http://www1.10x10.co.kr"
	M_SSLUrl		= "https://m.10x10.co.kr"				''모바일용 SSL URL
	testM_SSLUrl	= M_SSLUrl								''기프팅,기프티콘용
	staticImgUpUrl	= "https://oimgstatic.10x10.co.kr"       ''imgstatic 업로드 경로

	'// 리뉴얼 임시코드 stgm -> stgm으로가도록
    If (InStr(request.servervariables("HTTP_HOST") ,"stgm.10x10.co.kr")>0) Then
        Dim uselevel
        uselevel = session("ssnuserlevel")
        if (uselevel="") then
            uselevel = "0"
        else
            uselevel = CStr(uselevel)
        end if

        If (uselevel = 7) or (session("ssnuserid") = "0nlyoung7") Then
            wwwUrl = "http://stgm.10x10.co.kr"
            SSLUrl = "http://stgwww.10x10.co.kr"
        Else
            Response.Redirect wwwUrl
            Response.end
        End If
    End If
 END IF

	'// APP용 Path(iFrame에서만 구분됨)
 	Dim appUrlPath, isApp: isApp = 0
 	''if session("isApp")<>"" then isApp = session("isApp")
	if inStr(lCase(Request.ServerVariables("HTTP_REFERER")),"/apps/appcom/wish/")>0 then
		'// iFrame에서 구분
		if inStr(Lcase(Request.ServerVariables("HTTP_USER_AGENT")),"tenwishapp")>0 then
			isApp = 2
		else
			isApp = 1
		end if
		''session("isApp") = isApp
	elseif inStr(Lcase(Request.ServerVariables("HTTP_USER_AGENT")),"tenapp")>0 then
		isApp = 1
	elseif inStr(lCase(Request.ServerVariables("URL")),"/apps/appcom/wish/")>0 then
		'// 경로내에서 구분
		isApp = 1
		''session("isApp") = isApp
	end if

	Select Case cStr(isApp)
		Case "2"
			appUrlPath = "/apps/appcom/wish/webview"
		Case "1"
			appUrlPath = "/apps/appcom/wish/web2014"
		Case Else
			appUrlPath = ""
	End Select

	'// 사용자 브라우저 언어 코드
	Dim cUserLangCd
	cUserLangCd = LCase(Request.ServerVariables("HTTP_ACCEPT_LANGUAGE"))

	'브라우저 언어의 우선순위로 주언어 접수(세미콜론으로 구분)
	if cUserLangCd<>"" then cUserLangCd = split(cUserLangCd,";")(0)

	'언어 분기 	>> 언어코드 참고 (http://www.todal.net/26)
	if Instr(cUserLangCd,"ko")>0 then
		cUserLangCd = "ko"		'한국어
	elseif Instr(cUserLangCd,"zh")>0 then
		cUserLangCd = "zh"		'중국어
	elseif Instr(cUserLangCd,"jp")>0 then
		cUserLangCd = "jp"		'일본어
	elseif Instr(cUserLangCd,"en")>0 then
		cUserLangCd = "en"		'영어
	else
		cUserLangCd = "ko"		'기본값(한국어)
	end If
	
	'// 더블 마일리지 날짜 변경
	Dim isdoubleMileage : isdoubleMileage = False
	Dim isdoubledate : isdoubledate = "02/09"
	If Now() > #02/05/2020 00:00:00# AND Now() < #02/09/2020 23:59:59# Then
		isdoubleMileage = True
	End If

	'// datadive용 inikey 정의
	if application("Svr_Info")="staging" Then
		dataDive_IniApiKey = "314893ff84434348b84a86fab5b3e8a9"
	elseIf application("Svr_Info")="Dev" Then
		dataDive_IniApiKey = "314893ff84434348b84a86fab5b3e8a9"
	Else
		dataDive_IniApiKey = "aafad9f151234a3981bc8dd46a1a9376"
	End If
	
%>