<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
	'// 사용자 정보 저장
	Call fnUpdateTenUser("")

	'// 텐바이텐 로그인 아이디 정리
	session("tenUserid") = ""
	session("tenUserLv") = "5"

	dim referer
	referer = request.ServerVariables("HTTP_REFERER")

	if (referer = "") then
		response.redirect "/apps/appCom/between/inipay/UserInfo.asp"
	else
		response.redirect referer
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->