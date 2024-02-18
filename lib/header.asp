<%
	'# 현재 페이지명 접수
	dim nowViewPage
	nowViewPage = request.ServerVariables("SCRIPT_NAME")

'/서버 주기적 업데이트 위한 공사중 처리 '2011.11.11 한용민 생성
'/리뉴얼시 이전해 주시고 지우지 말아 주세요
Call serverupdate_underconstruction()

	'// 사이트 공사중
	'Call Underconstruction()

	'// 자동로그인 확인
	Call chk_AutoLogin()

	'####### .js 파일 연동시 사용 - CC_currentyyyymmdd=V_CURRENTYYYYMM 변수로 .js에서 해당 날짜 이미지/링크등 뿌려줌
	dim CC_currentyyyymmdd
	On Error Resume Next
	CC_currentyyyymmdd=request("yyyymmdd")
	On Error Goto 0
	if CC_currentyyyymmdd="" then CC_currentyyyymmdd = Left(now(),10)
	'#########################################################################

	'###### 제휴사 flag 관련 - 주문 저장시/회원가입시  제휴사 Flag 저장 ######
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
			if (left(irdsite20,7)<>"mobile_") then     ''2015/05/22 추가 mobile_mobile_da CASE
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
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<!--meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; minimum-scale=1.0; user-scalable=no; width=device-width;" /-->
<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; minimum-scale=1.0; user-scalable=no; width=320px;" />
<meta name="format-detection" content="telephone=no" />
<link rel="stylesheet" type="text/css" href="/lib/css/mobile_10x10.css" />
<link rel="SHORTCUT ICON" href="/lib/ico/10x10_140616.ico" />
<link rel="apple-touch-icon" href="/lib/ico/10x10TouchIcon_140616.png" />
<link rel="apple-touch-startup-image" href="/lib/ico/10x10Startup.png" />
<link rel="stylesheet" type="text/css" href="/lib/css/default.css">
<link rel="stylesheet" type="text/css" href="/lib/css/common.css">
<link rel="stylesheet" type="text/css" href="/lib/css/content.css">
<link rel="stylesheet" type="text/css" href="/lib/css/oldContent.css">
<title>텐바이텐 모바일</title>
</head>
<body>
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="/lib/js/common.js?dm=<%= CC_currentyyyymmdd %>"></script>
<script language="javascript">
var V_CURRENTYYYYMM = "<%= CC_currentyyyymmdd %>";
</script>
<%
	if flgDevice="W" then
		'Call Alert_move("모바일용 페이지 입니다.\n\nPC용 페이지로 이동합니다.","http://www.10x10.co.kr/")
		'Response.End
	End if
%>



