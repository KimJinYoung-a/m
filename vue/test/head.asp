<%
	'# 현재 페이지명 접수
	dim nowViewPage
	nowViewPage = request.ServerVariables("SCRIPT_NAME")
	Dim strOGMeta		'RecoPick환경변수

'/서버 주기적 업데이트 위한 공사중 처리 '2011.11.11 한용민 생성
'/리뉴얼시 이전해 주시고 지우지 말아 주세요
Call serverupdate_underconstruction()

	'// 사이트 공사중
	'Call Underconstruction()

	'// 로그인 유효기간 확인 및 처리
	Select Case lcase(Request.ServerVariables("URL"))
		Case "/_index.asp", "/index.asp"
			Call chk_ValidLogin()
	End Select

	'// 자동로그인 확인
	Call chk_AutoLogin()

	'####### .js 파일 연동시 사용 - CC_currentyyyymmdd=V_CURRENTYYYYMM 변수로 .js에서 해당 날짜 이미지/링크등 뿌려줌
	dim CC_currentyyyymmdd
	On Error Resume Next
	CC_currentyyyymmdd=request("yyyymmdd")
	On Error Goto 0
	if CC_currentyyyymmdd="" then CC_currentyyyymmdd = Left(now(),10)
	'#########################################################################

	'###### 제휴사 flag 관련 - 주문 저장시/회원가입시 제휴사 Flag 저장 ######
	dim irdsite20, arrRdSite, irdData
	irdsite20 = requestCheckVar(request("rdsite"),32)
	irdData = requestCheckVar(request("rddata"),100)	'기타 전송 데이터 (회원ID,이벤트 번호 등)
	'//파라메터가 겹쳐있는 경우 중복 제거
	if irdsite20<>"" then
		arrRdSite = split(irdsite20,",")
		irdsite20 = arrRdSite(0)
	end if

	if (irdsite20<>"") then
		if (request.cookies("rdsite")<>irdsite20) then
			response.cookies("rdsite").domain = "10x10.co.kr"
			if (left(irdsite20,7)<>"mobile_") then	 ''2015/05/22 추가 mobile_mobile_da CASE
				response.cookies("rdsite") = Left("mobile_"&trim(irdsite20),25)
			else
				response.cookies("rdsite") = Left(trim(irdsite20),32)
			end if
		end if
		if (request.cookies("rddata")<>irdData) then
			response.cookies("rddata") = irdData
		end if
	end if
	'#########################################################################

	Dim strPageKeyword
	'// 페이지 검색 키워드
	if strPageKeyword="" then
		strPageKeyword = "감성디자인, 디자인상품, 아이디어상품, 즐거움, 선물, 문구, 소품, 인테리어, 가구, 가전, 패션, 화장품, 반려동물, 핸드폰케이스, 패브릭, 조명, 식품"
	else
		strPageKeyword = "10x10, 텐바이텐, 감성, 디자인, " & strPageKeyword
	end If

	'################# Amplitude에 들어갈 Referer 값 정의 ###################
	Dim AmpliduteReferer
	AmpliduteReferer = Request.ServerVariables("HTTP_REFERER")
	If Trim(AmpliduteReferer) <> "" Then
		If Not(InStr(AmpliduteReferer, "10x10")>0) Then
			response.cookies("CheckReferer") = AmpliduteReferer
		End If
	End If
	'#########################################################################

	'//모바일 고도화 A/B 테스트
	Dim mAbTestMobile
	If request.Cookies("mAbTest")="" Then
		mAbTestMobile = session.sessionid Mod 2
		response.Cookies("mAbTest") = mAbTestMobile
		response.Cookies("mAbTest").expires = DateAdd("ww",2,Now())
	Else
		mAbTestMobile = request.Cookies("mAbTest")
	End If
%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" />
<meta name="keywords" content="<%=strPageKeyword%>" />
<meta name="format-detection" content="telephone=no" />
<link rel="SHORTCUT ICON" href="/lib/ico/10x10_140616.ico" />
<link rel="apple-touch-icon" href="/lib/ico/10x10TouchIcon_150303.png" />
<% if strOGMeta<>"" then Response.Write strOGMeta %>
<%
	Select Case lcase(Request.ServerVariables("URL"))
		Case "/_index.asp", "/index.asp", "/category/category_itemprd.asp", "/event/eventmain.asp"
			Response.Write "<meta name=""apple-itunes-app"" content=""app-id=864817011, app-argument=tenwishapp://"" />"
	End Select
%>
<%' 2020 리뉴얼에서 사용하는 css %>
<link rel="stylesheet" type="text/css" href="/lib/css/commonV20.css?v=1.18" />
<link rel="stylesheet" type="text/css" href="/lib/css/contentV20.css?v=1.47" />
<%'// 2020 리뉴얼에서 사용하는 css %>
<link rel="stylesheet" type="text/css" href="/lib/css/section.css?v=2.41" />
<% If InStr(Request.ServerVariables("url"),"/piece/") > 0 Then %>
<link rel="stylesheet" type="text/css" href="/lib/css/piece.css?v=1.25" />
<% End If %>
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="/lib/js/swiper6.0.4-bundle.min.js"></script>
<script type="text/javascript" src="/lib/js/TweenMax.min.js"></script>
<script type="text/javascript" src="/lib/js/common.js?v=9<%= CC_currentyyyymmdd %>"></script>
<script type="text/javascript" src="/lib/js/iscroll.js"></script>
<script type="text/javascript" src="/lib/js/buildV63.js"></script>
<script type="text/javascript" src="/lib/js/js.cookie.min.js"></script>
<script src="/data-pipeline/pipeline.min.js"></script>
<!--<script src="/data-pipeline/pipeline-origin.js"></script>-->
<% if application("Svr_Info")="staging" Then %>
	<script type="text/javascript" src="/lib/js/amplitudestaging.js?v=1.01"></script>
<% elseIf application("Svr_Info")="Dev" Then %>
	<script type="text/javascript" src="/lib/js/amplitudestaging.js?v=1.01"></script>
<% else %>
	<script type="text/javascript" src="/lib/js/amplitude.js?v=1.01"></script>
<% end if %>
<script type="text/javascript" src="https://cdn.branch.io/branch-2.52.5.min.js"></script>
<script language="javascript">
var V_CURRENTYYYYMM = "<%= CC_currentyyyymmdd %>";
</script>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js?autoload=false"></script>
<!-- #INCLUDE Virtual="/lib/inc/incNaverOpenDate.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/incDaumOpenDate.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/incPopup.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/inccoochalayerOpen.asp" -->